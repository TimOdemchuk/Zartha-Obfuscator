



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
	local stringEncryptorFunction = require("Resources.EncryptStrings")(nil, true)
	local stringEncryptorTemplate = require("Vm.Resources.Templates.DecryptStrings")
	local controlFlowFlattening = require("Resources.ControlFlowFlattening")
	local junkConstants = require("Resources.Templates.FakeConstants")
	local constantEncryption = require("Resources.ConstantEncryption")

	local decryptStr = tostring(_G.Random(100, 400))
	local constantShifter = tostring(_G.Random(3, 10))


	print("CONSTANT SHIFT AMOUNT:", constantShifter)

	-- Encrypt header 
	if settingsSelected.EncryptStrings then
		header = stringEncryptor(header, decryptStr)
	end

	-- Initialize variables
	local protoAt = 0
	local tree = ""
	local protosCount = 0
	local scannedProtos = {}
	local shiftAmount = settingsSelected.ConstantProtection and _G.Random(10, 20) or 0

	-- Get register type
	local function getCorrectRegister(location, name, fulltable)
		name = name:upper()

		if fulltable then
			return location[name]
		end

		local tableType = location[name] or location[name .. "x"] or location["s" .. name .. "x"]

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
				result = result .. keyIndent .. "[" .. string.format("%q", k) .. "] = "
			else
				result = result .. keyIndent .. "[" .. tostring(k) .. "] = "
			end
			result = result .. serializeValue(v, indent + 2) .. ",\n"
		end
		result = result .. string.rep(" ", indent) .. "}"
		return result
	end

	_G.getReg = getCorrectRegister -- For opcodes getting correct register

	-- parser layout
	local constants = parasedBytecode.Constants
	local prototypes = parasedBytecode.Prototypes
	local instructions, constants = require("Vm.Resources.ModifyInstructions")(parasedBytecode.Instructions, constants, prototypes) 

	do
		-- Display parsed data
		_G.display("---------------- CONSTANTS ---------------", "yellow")
		_G.display(dump(constants))
		_G.display("---------------- INSTRUCTIONS ---------------", "yellow")
		_G.display(dump(instructions))
		_G.display("---------------- PROTOTYPES ---------------", "yellow")
		_G.display(dump(prototypes))
	end

	-- Get opcode path
	local function getOpcode(num, name)
		num = tostring(num)

		local modulePath = "Vm.OpCodes." .. num
		local success, result = pcall(require, modulePath)
		
		if success then
			return result
		else
			local missing  = ("--> OP_MISSING:	(%s, [%s])"):format(num, name)

			_G.display(missing, "red")
			return nil
		end
	end

	-- Replace function for templates
	local function replace(normal, key, with) 
		local out = normal:gsub(":" .. key:upper() .. ":", with)

		return out
	end

	-- Generate junk constant value
	local function generateJunkConstant()
		return tostring(junkConstants[math.random(1, #junkConstants)])
	end

	-- Shuffle constants and create mapping
	local function shuffleConstants(targetConstants)
		local shuffled = {}
		local indexMap = {} 
		local reverseMap = {} 
		
		-- Add junk constants (random amount)
		local junkCount = math.random(2, 6)
		local totalSize = #targetConstants + junkCount
		
		-- shuffle stuff
		local positions = {}
		for i = 1, totalSize do
			positions[i] = i
		end
		
		for i = totalSize, 2, -1 do
			local j = math.random(1, i)
			positions[i], positions[j] = positions[j], positions[i]
		end
		
		for origIdx = 1, #targetConstants do
			local newPos = positions[origIdx]
			shuffled[newPos] = targetConstants[origIdx]
			indexMap[origIdx] = newPos
			reverseMap[newPos] = origIdx
		end
		
		-- Add junk constants
		for i = #targetConstants + 1, totalSize do
			local newPos = positions[i]
			shuffled[newPos] = generateJunkConstant()
		end
		
		return shuffled, indexMap, reverseMap
	end

	-- Store constant mappings globally for opcodes to use
	_G.constantMaps = {}
	_G.currentMapId = "base"

	-- Generate constant mapping
	local function prepareConstantMapping(targetConstants, mapId)
		-- Shuffle constants
		local shuffledConstants, indexMap, reverseMap = shuffleConstants(targetConstants)

		_G.constantMaps[mapId or "base"] = {
			shuffled = shuffledConstants,
			indexMap = indexMap,
			reverseMap = reverseMap,
			encryptionMeta = {}
		}
		
		return shuffledConstants, indexMap
	end

	-- Load constants (generated mapping)
	local function getConstants(targetConstants, mapId)
		mapId = mapId or _G.currentMapId or "base"
		
		local mapData = _G.constantMaps[mapId]
		local shuffledConstants
		local reverseMap
		
		if mapData then
			shuffledConstants = mapData.shuffled
			reverseMap = mapData.reverseMap
		else
			shuffledConstants = shuffleConstants(targetConstants)
		end

		local encryptionMeta = {}
		
		local constantsStr = ""

		for i = 1, #shuffledConstants do
			local const = shuffledConstants[i]
			if not const then
				-- add junk constant (encrypted empty string)
				local junkKey = tostring(math.random(100, 3000))
				constantsStr = constantsStr .. '(decrypt("", "' .. junkKey .. '")),'
			else
				local costAt = type(const) == "table" and tostring(const.Value) or tostring(const)
				local byted = costAt
				local byteKey = nil

				-- CONSTANT TYPES:
				-- Because constants can be either string, number, boolean, nil we need the identifiers so the VM knows what to convert the constant to. This solves the VM trying to compare string on string when its suppoosed to be number on number
				-- Identifier for constant protection
				
				if settingsSelected.ConstantProtection then -- im too lazy ngl
					byteKey = math.random(2, 30)

					if const.Type == "string" then
						local src = byted
						local t = {}

						for i = 1, #src do
							local byte = string.byte(src, i)
							t[i] = string.char(bit32.bxor(byte, byteKey))
						end

						byted = table.concat(t)
					end
				end

				-- Hide constants from plain view
				byted = byted:gsub(".", function(bb) 
					return string.char(bb:byte() - constantShifter) 
				end)
				
				-- Number Identifier
				if const.Type == "number" then  -- byte 11
					byted = byted .. string.char(11)
				end

				-- Boolean Identifier
				if const.Type == "boolean" then -- byte 7
					byted = byted .. string.char(7)
				end

				-- nil Identifier
				if const.Type == "nil" then -- byte 6
					byted = byted .. string.char(6)
				end

				-- Encrypt the raw bytes directly (avoids pattern-matching issues with " and \ in byte-shifted data)
				local key = tostring(math.random(100, 3000))
				local encryptedData = stringEncryptorFunction(byted, key)
				local safeEncrypted = ""

				for ci = 1, #encryptedData do
					safeEncrypted = safeEncrypted .. string.format("\\%03d", string.byte(encryptedData, ci))
				end

				encryptionMeta[i] = { -- constant table
					constant = const,
					encrypted = safeEncrypted,
					key = key,
					byteKey = byteKey,
					origIndex = reverseMap and reverseMap[i] or nil,
				}

				constantsStr = constantsStr .. ('%s(decrypt("%s", "%s"))%s,'):format(tonumber(const) and "(" or "", safeEncrypted, key, tonumber(const) and ")" or "")
			end
		end

		if _G.constantMaps[mapId] then
			_G.constantMaps[mapId].encryptionMeta = encryptionMeta
		else
			_G.constantMaps[mapId] = {
				shuffled = shuffledConstants,
				encryptionMeta = encryptionMeta
			}
		end

		return constantsStr
	end

	-- Get mapped constant index
	local function getMappedConstantIndex(origIndex, mapId)
		mapId = mapId or _G.currentMapId or "base"
		local mapData = _G.constantMaps[mapId]
		if mapData and mapData.indexMap and mapData.indexMap[origIndex + 1] then
			return mapData.indexMap[origIndex + 1]
		end
		return origIndex + 1 -- fallback
	end
	
	_G.getMappedConstant = getMappedConstantIndex

	_G.shiftAmount = shiftAmount -- For other scripts (Decrypt key)

	-- Generate opcode template
	local function generateOpcode(inst, index, allInstructions) 
		if inst.OpcodeName == "PSEUDO" or inst.Opcode == -1 then
			return "-- [PSEUDO] Handled by CLOSURE"
		end

		local function getInstructionConstant() -- more easy way to gather correct constant
			if inst.Opcode == 1 or inst.Opcode == 5 or inst.Opcode == 7 then
				local bIndex = getCorrectRegister(inst, "B")
				if type(bIndex) == "number" then
					return constants[bIndex + 1], getMappedConstantIndex(bIndex)
				end
			end

			local regB = getCorrectRegister(inst, "B", true)
			if type(regB) == "table" and regB.k and type(regB.i) == "number" then
				return constants[regB.i + 1], getMappedConstantIndex(regB.i)
			end

			local regC = getCorrectRegister(inst, "C", true)
			if type(regC) == "table" and regC.k and type(regC.i) == "number" then
				return constants[regC.i + 1], getMappedConstantIndex(regC.i)
			end

			return nil, nil
		end

		local constant, mappedConstantIndex = getInstructionConstant()
		local encryptedConstant = nil
		local constantByteKey = nil
		local encryptionMetaMap = nil

		do
			local mapData = _G.constantMaps[_G.currentMapId or "base"]
			if mapData and mapData.encryptionMeta and mappedConstantIndex then
				encryptedConstant = mapData.encryptionMeta[mappedConstantIndex]
				constantByteKey = encryptedConstant and encryptedConstant.byteKey or nil
			end
			encryptionMetaMap = mapData and mapData.encryptionMeta or nil
		end
		local getOpcodeFormat = getOpcode(inst.Opcode, inst.OpcodeName)

		if type(getOpcodeFormat) == "function" then
			-- LOADK number support
			local const = nil

			if inst.Opcode == 1  then
				local B = getCorrectRegister(inst, "B")
				local constGot = constants[B + 1]

				if B and constGot and constGot.Type == "number" then
					const = constGot
				end
			end

			getOpcodeFormat = getOpcodeFormat(inst, shiftAmount, const, settingsSelected)
		end

		if getOpcodeFormat ~= nil then 
			-- Fill registers
			local replaced = replace(getOpcodeFormat, "a", tostring(getCorrectRegister(inst, "A")))
			replaced = replace(replaced, "c", tostring(getCorrectRegister(inst, "C")))
			replaced = replace(replaced, "b", tostring(getCorrectRegister(inst, "B")))

			-- ConstantEncryption
			if settingsSelected.ConstantProtection and replaced:find("Constants", 1, true) then
				local encryptedOpcode = constantEncryption(replaced, constant, encryptedConstant, constantByteKey, encryptionMetaMap)
				if type(encryptedOpcode) == "string" then
					replaced = encryptedOpcode
				end
			end

			 -- String Encryption

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

				-- Upvalue map
				local mapString = "{" .. table.concat(mapParts, ", ") .. "}"

				replaced = replace(replaced, "MAPPING", mapString)

				if not table.find(scannedProtos, inst) then
					table.insert(scannedProtos, inst)
					protosCount = protosCount + 1
					replaced = replace(replaced, "PROTOHERE", tostring(protosCount))
				end
			end

			return replaced
		end

		return "-- ERROR GENERATING OPCODE"
	end

	-- Generate instructions tree
	local function readInstructions(currentInstructions, _, extraString)
		local opcodeMap = {} 
		local output = ""
		local function addToTree(str)
			output = output .. str .. ""
		end

		-- Opcode reading
		local isFirst = true
		local skipNext = false
		
		for i, inst in ipairs(currentInstructions) do
			if skipNext then
				skipNext = false
				-- Skip PSEUDO opcodes (-1)
			elseif inst.OpcodeName ~= "PSEUDO" and inst.Opcode ~= -1 then
				local pointer = i
				local opcodeType = inst.Opcode -- opcode index
				local generatedOpcode = generateOpcode(inst, i, currentInstructions)


				-- SUPER INSTRUCTIONS!!! (Instead of generating separate opcodes we can merge them together this makes it more optimised and harder to detect patterns)
				-- Super Instruction: LOADK + CALL merged into one
				if inst.Opcode == 1 then -- LOADK
					local nextInst = currentInstructions[i+1]
					
					if nextInst and nextInst.Opcode == 28 then -- CALL
						local callOpcode = generateOpcode(nextInst, i+1, currentInstructions)
						generatedOpcode = generatedOpcode .. "\n" .. callOpcode .. "\n\tpointer = pointer + 1"
						skipNext = true
						_G.display(("--> Super Instruction: LOADK_AND_CALL at instruction %d"):format(i), "yellow")
					end
				end

				-- Super Instruction: GETGLOBAL + GETTABLE merged into one 
				if inst.Opcode == 5 and not skipNext then -- GETGLOBAL
					local nextInst = currentInstructions[i+1]

					if nextInst and nextInst.Opcode == 6 then -- GETTABLE
						local getA = getCorrectRegister(inst, "A")
						local nextB = getCorrectRegister(nextInst, "B")

						if getA == nextB then
							local tableOpcode = generateOpcode(nextInst, i+1, currentInstructions)
							generatedOpcode = generatedOpcode .. "\n" .. tableOpcode .. "\n\tpointer = pointer + 1"
							skipNext = true
							_G.display(("--> Super Instruction: GETGLOBAL_TABLE at instruction %d"):format(i), "yellow")
						end
					end
				end

				-- Super Instruction: GETTABLE + CALL merged into one (e.g. obj:method() or tbl.func())
				if inst.Opcode == 6 and not skipNext then -- GETTABLE
					local nextInst = currentInstructions[i+1]

					if nextInst and nextInst.Opcode == 28 then -- CALL
						local getA = getCorrectRegister(inst, "A")
						local callA = getCorrectRegister(nextInst, "A")

						if getA == callA then
							local callOpcode = generateOpcode(nextInst, i+1, currentInstructions)
							generatedOpcode = generatedOpcode .. "\n" .. callOpcode .. "\n\tpointer = pointer + 1"
							skipNext = true
							_G.display(("--> Super Instruction: TABLE_CALL at instruction %d"):format(i), "yellow")
						end
					end
				end

				local generatedInfo = {
					["generatedOpcode"] = generatedOpcode,
					["tatementType"] = isFirst and "if" or "elseif",
					["currentPointer"] = tostring(pointer),
					["debugInfo"] = (" -- %s [%s]"):format(opcodeType, inst.OpcodeName or "unknown"),
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
						(" -- %s [%s]"):format(opcodeType, inst.OpcodeName), --debug code
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
				_G.display("--> Generating Control Flow Flattening (" .. extraString .. ")", "yellow")
			else
				_G.display("--> Generating Control Flow Flattening", "yellow")
			end

			-- Generate control flow flattened opcodes
			local controlFlowed = controlFlowFlattening:generateState(opcodeMap)

			return controlFlowed
		end

		return output
	end

	-- Process prototypes
	local function processPrototypes()
		local currentLevel = {}
		local nextLevel = {}
		
		for i = 1, #prototypes do
			table.insert(currentLevel, {
				proto = prototypes[i],
				extra = nil
			})
		end
		
		while #currentLevel > 0 do
			-- Process all prototypes at current level (sub prototypes supported here)
			for _, protoData in ipairs(currentLevel) do

				local proto = protoData.proto
				local extra = protoData.extra

				protoAt = protoAt + 1

				local protoName = ("PROTOTYPE%sHERE"):format(tostring(protoAt))
				local protoMapId = "proto_" .. tostring(protoAt)

				_G.display("--> Reading prototype: " .. tostring(protoAt) .. (extra or ""), "yellow")

				local numParams = proto.NumUpvalues
				
				-- Prepare constant mapping BEFORE reading instructions
				_G.currentMapId = protoMapId
				prepareConstantMapping(proto.Constants, protoMapId)

				local constants = getConstants(proto.Constants, protoMapId)
				local newInstructions = readInstructions(require("Vm.Resources.ModifyInstructions")(proto.Instructions, proto.Constants, proto.Prototypes), nil, "PROTOTYPE " .. tostring(protoAt), extra)

				-- Instructions
				tree = tree:gsub("INST_" .. protoName, function()
					return newInstructions
				end)

				-- Constants
				tree = tree:gsub("CONSTANTS_" .. protoName, function()
					return constants
				end)

				-- numParams
				tree = tree:gsub("NUMBERPARAMS_" .. protoName, tostring(numParams))

				--:NumUpvalues:
				tree = tree:gsub("UPVALS_" .. protoName, proto.NumUpvalues)

				-- STACK_LOCATION
				tree = tree:gsub("STACK_LOCATION_" .. protoName,
					extra == nil and "prevStack" or "Upvalues"
				)
				
				-- Collect the next sub prototypes
				if proto.Prototypes and #proto.Prototypes > 0 then
					for _, subProto in pairs(proto.Prototypes) do
						table.insert(nextLevel, {
							proto = subProto,
							extra = "(SUB)"
						})
					end
				end
			end
			
			-- Move to next level
			currentLevel = nextLevel
			nextLevel = {}
		end
	end

	local function getPrototypes(targetPrototype, extra)
		processPrototypes()
	end

	-- Prepare base constant mapping FIRST (before reading instructions)
	_G.currentMapId = "base"
	prepareConstantMapping(constants, "base")
	local baseConstants = getConstants(constants, "base")

	-- Add main VM instructions
	local insertInstructions = readInstructions(instructions, constants)
	tree = tree .. insertInstructions

	-- Generate Prototypes
	getPrototypes(prototypes)

	-- Insert constants
	header = header:gsub("CONSTANTS_HERE_BASEVM", baseConstants)
	-- VM Format
	tree = vm:format(
		header,
		tree,
		settingsSelected.LuaUSyntax and "pointer+=1" or "pointer = pointer + 1"
	)
	tree = tree:gsub(":CONSTANT_SHIFTER:", tostring(constantShifter))
	
	
	-- Wrap in function
	tree = ([[return (("%s") and (function() return(function(Env,Constants,shiftKey,decrypt) %s end)((_ENV or getfenv()),{},0%s) end)())]]):format(settingsSelected.Watermark, tree, "," .. stringEncryptorTemplate)

	return tree
end