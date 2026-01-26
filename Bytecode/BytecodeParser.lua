local Enums = require("Bytecode.Enums")
local parser = require("Bytecode.BcUtils")

local function readHeader()
	return {
		signature = parser:ReadBytes(4),
		version = parser:ReadByte(),
		format = parser:ReadByte(),
		endianness = parser:ReadByte(),
		intSize = parser:ReadByte(),
		sizeTSize = parser:ReadByte(),
		instructionSize = parser:ReadByte(),
		luaNumberSize = parser:ReadByte(),
		integral = parser:ReadByte(),
	}
end

local function decodeRK(x)
	if x >= 256 then
		return { k = true, i = x - 256 }
	end
	return { k = false, i = x }
end

local function decodeInstruction(raw)
	local opcode = raw % 64
	local a = math.floor(raw / 64) % 256
	
	local mode = Enums[opcode].Type
	local instruction = {
		Opcode = opcode,
		OpcodeName = Enums[opcode].Mnemonic,
		A = a,
		Raw = raw
	}
	
	if mode == 'iABC' then
		instruction.B = decodeRK(math.floor(raw / 8388608) % 512)
		instruction.C = decodeRK(math.floor(raw / 16384) % 512)
	elseif mode == 'iABx' then
		instruction.Bx = math.floor(raw / 16384)
	elseif mode == 'iAsBx' then
		instruction.sBx = math.floor(raw / 16384) - 131071
	end
	-- zaza
	return instruction
end

local function readFunction(sourcename)
	local func = {
		Source = nil,
		LineDefined = 0,
		LastLineDefined = 0,
		NumUpvalues = 0,
		NumParams = 0,
		IsVararg = 0,
		MaxStackSize = 0,
		Instructions = {},
		Constants = {},
		Prototypes = {}
	}
	
	func.Source = parser:ReadString() or sourcename
	func.LineDefined = parser:ReadInt32()
	func.LastLineDefined = parser:ReadInt32()
	func.NumUpvalues = parser:ReadByte()
	func.NumParams = parser:ReadByte()
	func.IsVararg = parser:ReadByte()
	func.MaxStackSize = parser:ReadByte()
	
	local numInstr = parser:ReadInt32()
	for i = 1, numInstr do
		local raw = parser:ReadInt32()
		func.Instructions[i] = decodeInstruction(raw)
		func.Instructions[i].Index = i
	end
	
	local numConsts = parser:ReadInt32()
	for i = 1, numConsts do
		local constant = {Index = i - 1}
		local constType = parser:ReadByte()
		
		if constType == 0 then
			constant.Type = 'nil'
			constant.Value = 'nil'
		elseif constType == 1 then
			constant.Type = 'boolean'
			constant.Value = parser:ReadByte() ~= 0
		elseif constType == 3 then
			constant.Type = 'number'
			constant.Value = parser:ReadDouble()
		elseif constType == 4 then
			constant.Type = 'string'
			constant.Value = parser:ReadString()
		end
		func.Constants[i] = constant
	end
	
	local numPrototypes = parser:ReadInt32()
	for i = 1, numPrototypes do
		func.Prototypes[i] = readFunction(func.Source)
		func.Prototypes[i].Index = i - 1
	end
	
	return func
end

return function(bytecode)
	parser = parser.new(bytecode)
	return {
		readHeader(),
		readFunction('@compiled-lua')
	}
end
