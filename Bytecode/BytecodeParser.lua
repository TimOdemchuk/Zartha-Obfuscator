local Enums = require("Bytecode.Enums")
local parser = require("Bytecode.BcUtils")

local function readHeader()
	local header = {
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

	if header.signature ~= "\27Lua" then
		error("Invalid Lua signature")
	end
	if header.version ~= 0x51 then
		error("Unsupported Lua version (expected 5.1)")
	end
	if header.format ~= 0 then
		error("Unsupported format (expected official format 0)")
	end
	parser.sizeT = header.sizeTSize
	if header.endianness ~= 1 then
		error("Unsupported endianness (expected little-endian)")
	end
	if header.intSize ~= 4 or header.instructionSize ~= 4 then
		error("Unsupported int/instruction size (expected 4 bytes)")
	end

	return header
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
	print("PARSER OPCODE --> ",opcode)
	local enum = Enums[opcode]
	if not enum then
		error("Unknown opcode: " .. tostring(opcode))
	end
	local mode = enum.Type
	local instruction = {
		Opcode = opcode,
		OpcodeName = enum.Mnemonic,
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

	local numLineInfo = parser:ReadInt32()
	for i = 1, numLineInfo do
		parser:ReadInt32()
	end

	local numLocals = parser:ReadInt32()
	for i = 1, numLocals do
		parser:ReadString() -- varname
		parser:ReadInt32() -- startpc
		parser:ReadInt32() -- endpc
	end

	local numUpvalueNames = parser:ReadInt32()
	for i = 1, numUpvalueNames do
		parser:ReadString()
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
