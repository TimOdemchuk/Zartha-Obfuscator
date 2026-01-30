-- This file generates the VM tree from parsed bytecode
-- It uses templates and fills them with the generated opcodes and constants
-- I will rewrite this later to be more efficient and cleaner

math.randomseed(os.time())
package.path = package.path .. ";" .. "./Vm/?.lua"

return function(parasedBytecode)
	parasedBytecode = parasedBytecode[2]
    
	-- Requires
	local header = require("Resources.Templates.Header")
	local vm = require("Resources.Templates.Vm")
	local settingsSelected = require("Input.Settings")
	local stringEncryptor = require("Resources.EncryptStrings")
	local stringEncryptorFunction = require("Resources.EncryptStrings")(nil,true)
	local stringEncryptorTemplate = require("Resources.Templates.DecryptStringsTemplate")
	local ControlFlowFlattening = require("Resources.ControlFlowFlattening")

	local decryptStr = tostring(_G.Random(100,400))

	-- Encrypt header 
	if settingsSelected.EncryptStrings then
		header = stringEncryptor(header,decryptStr)
	end

	-- Initialize variables
	local protoAt = 0
	local tree = ""
	local protosCount = 0
	local scannedProtos = {}
	local shiftAmount = settingsSelected.ConstantProtection and _G.Random(10,20) or 0

	-- Get register type
	local function getCorrectRegister(location,name,fulltable)
		name = name:upper()

		if fulltable then
			return location[name]
		end

		local tableType = location[name] or location[name.."x"] or location["s"..name.."x"]

		return type(tableType) == "table" and tableType.i or tableType
	end

	-- print out tables
    local function dump(tableData, indent)
        indent = indent or 0
        local function serializeValue(value, level)
            level = level or 0
            if type(value) == "string" then
                return string.format("%q", value)
            elseif type(value) == "table" then
                return dump(value, level + 1)
            else
                return tostring(value)
            end
        end
        local result = "{\n"
        for k, v in pairs(tableData) do
            local keyIndent = string.rep(" ", indent + 2)
            local valueIndent = string.rep(" ", indent + 4)
            if type(k) == "string" then
                result = result..keyIndent.."["..string.format("%q", k).."] = "
            else
                result = result..keyIndent.."["..tostring(k).."] = "
            end
            result = result..serializeValue(v, indent + 2)..",\n"
        end
        result = result..string.rep(" ", indent).."}"
        return result
    end

	_G.getReg = getCorrectRegister -- For opcodes getting correct register

	-- parser layout
	local constants = parasedBytecode.Constants
	local prototypes = parasedBytecode.Prototypes
	local instructions,constants = require("Vm.Resources.ModifyInstructions")(parasedBytecode.Instructions,constants,prototypes) 

	do
		-- Display parsed data
		_G.display("---------------- CONSTANTS ---------------","yellow")
		_G.display(dump(constants))
		_G.display("---------------- INSTRUCTIONS ---------------","yellow")
		_G.display(dump(instructions))
		_G.display("---------------- PROTOTYPES ---------------","yellow")
		_G.display(dump(prototypes))
	end

	-- Get opcode path
	local function getOpcode(num,name)
		num = tostring(num)

		local modulePath = "Vm.OpCodes."..num
		local success, result = pcall(require, modulePath)
		
		if success then
			return result
		else
			local missing  = ("--> OP_MISSING:	(%s, [%s])"):format(num,name)

			_G.display(missing,"red")
			return nil
		end
	end

	-- Replace function for templates
	local function replace(normal,key,with) 
		local out = normal:gsub(":"..key:upper()..":",with)

		return out
	end

	-- Load constants
	local function getConstants(targetConstants)
		local constantsStr = ""
		for i, const in ipairs(targetConstants) do

			local costAt = type(const) == "table" and tostring(const.Value) or tostring(const)
			local byted = costAt

			--[[
			local byted = costAt:gsub(".", function(b) return "\\" .. b:byte()+(shiftAmount) end)
			local split = string.split(byted,"\\")

			if split[#split] == "0" or split[#split]  == tostring(shiftAmount) then -- Prevent null bytes
				byted = string.sub(byted,1,#byted-2)
			end
			]]

			-- CONSTANT TYPES:
			-- Identifier for constant protection
			if settingsSelected.ConstantProtection then  -- byte 4
				if string.sub(byted,#byted,#byted) == "\\" then
					byted = string.sub(byted,1,#byted-1)
				end
				byted = byted..string.char(4)
			end

			-- Number Identifier
			if const.Type == "number" then  -- byte 11
				byted = byted..string.char(11)
			end

			-- Boolean Identifier
			if const.Type == "boolean" then -- byte 7
				byted = byted..string.char(7)
			end

			-- nil Identifier
			if const.Type == "nil" then -- byte 6
				byted = byted..string.char(6)
			end

			constantsStr = constantsStr..('%s("%s")%s,'):format(tonumber(const) and "(" or "",byted,tonumber(const) and ")" or "")
		end
		constantsStr = stringEncryptor(constantsStr)
		return constantsStr
	end

	_G.shiftAmount = shiftAmount -- For other scripts (Decrypt key)

	-- Generate opcode template
	local function generateOpcode(inst, index, allInstructions) 
		if inst.OpcodeName == "PSEUDO" or inst.Opcode == -1 then
			return "-- [PSEUDO] Handled by CLOSURE"
		end

		local getOpcodeFormat = getOpcode(inst.Opcode,inst.OpcodeName)

		if type(getOpcodeFormat) == "function" then
			-- LOADK number support + constant protection
			local const = nil

			if inst.Opcode == 1  then
				local B = getCorrectRegister(inst,"B")
				local constGot = constants[B+1]

				if B and constGot and constGot.Type == "number" then
					const= constGot
				end
			end

			getOpcodeFormat = getOpcodeFormat(inst,shiftAmount,const,settingsSelected)
		end

		if getOpcodeFormat ~= nil then 
			-- Fill registers
			local replaced = replace(getOpcodeFormat,"a",tostring(getCorrectRegister(inst,"A")))
			replaced = replace(replaced,"c",tostring(getCorrectRegister(inst,"C")))
			replaced = replace(replaced,"b",tostring(getCorrectRegister(inst,"B")))

			-- CLOSURE MAPPING (UPVALUES)
			if inst.OpcodeName == "CLOSURE" then
				local mapParts = {}

				-- PSEUDO
				if allInstructions and index then
					local lookAheadIndex = index + 1
					local pseudoCount = 0

					while true do
						local nextInst = allInstructions[lookAheadIndex]
						if not nextInst or (nextInst.OpcodeName ~= "PSEUDO" and nextInst.Opcode ~= -1) then
							break
						end

						local childIdx = pseudoCount 

						local parentIdx = getCorrectRegister(nextInst, "B")
						local typeIdx = getCorrectRegister(nextInst, "C") or 0 

						table.insert(mapParts, string.format("[%s] = {%s, %s}", childIdx, typeIdx, parentIdx))

						pseudoCount = pseudoCount + 1 
						lookAheadIndex = lookAheadIndex + 1
					end
				end

				local mapString = "{" .. table.concat(mapParts, ", ") .. "}"

				replaced = replace(replaced, "MAPPING", mapString)

				if not table.find(scannedProtos,inst) then
					table.insert(scannedProtos,inst)
					protosCount = protosCount+1
					replaced = replace(replaced,"PROTOHERE",tostring(protosCount))
				end
			end

			return replaced
		end

		return "-- ERROR GENERATING OPCODE"
	end

	-- Generate instructions tree
	local function readInstructions(currentInstructions,_,extraString)
		local opcodeMap = {} 
		local output = ""
		local function addToTree(str)
			output = output..str..""
		end

		-- Opcode reading
		local isFirst = true
		for i, inst in ipairs(currentInstructions) do
			-- Skip PSEUDO opcodes (-1)
			if inst.OpcodeName ~= "PSEUDO" and inst.Opcode ~= -1 then
				local pointer = i
				local opcodeType = inst.Opcode -- opcode index
				local generatedOpcode = generateOpcode(inst, i, currentInstructions)

				local generatedInfo = {
					["generatedOpcode"] = generatedOpcode,
					["tatementType"] = isFirst and "if" or "elseif",
					["currentPointer"] = tostring(pointer),
					["debugInfo"] = (" -- %s [%s]"):format(opcodeType,inst.OpcodeName or "unknown"),
					["endType"] = pointer == #currentInstructions and "end" or "",
				}

				 -- ControlFlowFlattening
				if settingsSelected.ControlFlowFlattening then
					opcodeMap[pointer] = generatedInfo.generatedOpcode
				else
					-- Normal generation
					local opcodeGenerated = ("%s pointer == %s then%s \n %s \n%s"):format(
						isFirst and "if" or "elseif", -- Else or elseif start with
						tostring(i), -- pointer
						(" -- %s [%s]"):format(opcodeType,inst.OpcodeName), --debug code
						generatedInfo.generatedOpcode, -- the generated opcode
						i == #currentInstructions and "end" or "" -- if its end of vm
					)

					addToTree(opcodeGenerated)
				end

				isFirst = false
			end
		end

		-- ControlFlowFlattening
		if settingsSelected.ControlFlowFlattening then
			-- Display extra info
			if extraString then
				_G.display("--> Generating Control Flow Flattening ("..extraString..")", "yellow")
				else
				_G.display("--> Generating Control Flow Flattening", "yellow")
			end

			-- Generate control flow flattened opcodes
			local controlFlowed = ControlFlowFlattening:generateState(opcodeMap)

			return controlFlowed
		end

		return output
	end
	
	-- Process prototypes
	local function processPrototypes()
		local currentLevel = {}
		local nextLevel = {}
		
		for i = 1, #prototypes do
			table.insert(currentLevel, {proto = prototypes[i], extra = nil})
		end
		
		while #currentLevel > 0 do
			-- Process all prototypes at current level
			for _, protoData in ipairs(currentLevel) do
				local proto = protoData.proto
				local extra = protoData.extra
				protoAt = protoAt + 1
				local protoName = ("PROTOTYPE%sHERE"):format(tostring(protoAt))

				_G.display("--> Reading prototype: "..tostring(protoAt)..(extra or ""),"yellow")

				local numParams = proto.NumUpvalues
				local newInstructions = readInstructions(require("Vm.Resources.ModifyInstructions")(proto.Instructions,proto.Constants,proto.Prototypes),nil,"PROTOTYPE "..tostring(protoAt),extra)
				local constants = getConstants(proto.Constants)

				-- Instructions
				tree = tree:gsub("INST_"..protoName, function() return newInstructions end)

				-- Constants
				tree = tree:gsub("CONSTANTS_"..protoName, function() return constants end)

				-- numParams
				tree = tree:gsub("NUMBERPARAMS_"..protoName,tostring(numParams))

				--:NumUpvalues:
				tree = tree:gsub("UPVALS_"..protoName,proto.NumUpvalues)

				--STACK_LOCATION
				tree = tree:gsub("STACK_LOCATION_"..protoName,
					extra == nil and "prevStack" or "Upvalues"
				)
				
				-- Collect sub-prototypes for next level
				if proto.Prototypes and #proto.Prototypes > 0 then
					for _, subProto in pairs(proto.Prototypes) do
						table.insert(nextLevel, {proto = subProto, extra = "(SUB)"})
					end
				end
			end
			
			-- Move to next level
			currentLevel = nextLevel
			nextLevel = {}
		end
	end

	local function getPrototypes(targetPrototype,extra)
		processPrototypes()
	end

	-- Add VM
	local insertInstructions = readInstructions(instructions,constants)
	tree = tree..insertInstructions

	-- Prototypes
	getPrototypes(prototypes)

	-- Insert constants
	header = header:gsub("CONSTANTS_HERE_BASEVM",getConstants(constants))

	-- Format VM
	tree = vm:format(
		header,
		"",
		settingsSelected.LuaU_Syntax and ":any" or "",
		(not settingsSelected.ConstantProtection and [[
		local removedByte = sub(toSend,1,#toSend-1)
		value = tonumber(removedByte)
		]] or ([[
		local removedByte = sub(toSend,1,#toSend-2)
		local decrypted = {}
		for i =1,#removedByte  do
			insert(decrypted,char(byte(removedByte,i)-%s)) 
		end
		value = tonumber(concat(decrypted))
		]]):format(tostring(_G.shiftAmount))),
		settingsSelected.ConstantProtection and [=[
		local const = ConstantsCopy[at]
		if byte(const,#const) == 11 then
			return Constants[at]
		end
		local removedByte = sub(const,1,#const-1)
		Constants[at] = removedByte
		return removedByte
		]=] or [[
		local const = ConstantsCopy[at]
		Constants[at] = const
		return const]],
		tree,
		settingsSelected.LuaU_Syntax and "pointer+=1" or "pointer = pointer + 1"
	)
	tree = tree:gsub(":SHIFTAMOUNT:",tostring(_G.shiftAmount))
	
	-- Wrap in function
	tree = ([[return (("%s") and (function() return(function(Env,Constants,shiftKey,decrypt)%s %s end)((_ENV or getfenv()),{},0%s) end)())]]):format(settingsSelected.Watermark,settingsSelected.LuaU_Syntax and ":any" or "",tree,","..stringEncryptorTemplate)

	return tree
end