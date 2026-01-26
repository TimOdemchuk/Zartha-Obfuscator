--// Modify any instructions that have a macro
local function fileExists(path)
    local f = io.open(path, "r")
    if f then 
        f:close() 
        return true 
    end
    return false
end

return function(instructions,constants,prototypes)
	--// Fix upvalues (PSEUDO)
	for i, inst in ipairs(instructions) do
		if inst.OpcodeName == "CLOSURE" then
			--// warn("PROTOTYPE","-",inst, _G.getReg(inst, "B"),prototypes)
			local protoIndex = _G.getReg(inst, "B")
			local proto = prototypes[protoIndex+1]
			
			if proto and proto.NumUpvalues > 0 then
				for i2 = 1, proto.NumUpvalues do
					local pseudoInst = instructions[i + i2]
					if pseudoInst then

						if pseudoInst.OpcodeName == "GETUPVAL" or pseudoInst.Opcode == 4 then
							pseudoInst.C = 1 --// Upvalue
						else
							pseudoInst.C = 0 --// Stack
						end
						--// Mark so the VM knows to skip it later
						pseudoInst.OpcodeName = "PSEUDO"
						pseudoInst.Opcode = -1 
					end
				end
			end
		end
	end
	
	for i, inst in ipairs(instructions) do
		if inst.OpcodeName == "GETGLOBAL" then
			local registerB = _G.getReg(inst,"B")+1
			local constant = constants[registerB]
			
			if constant then
				constant = constant.Value
                local opcodeExists = fileExists("Bytecode.OpCodes."..tostring(constant)..".lua")
				if constant and opcodeExists then
					local callOpcode = (instructions[i+1])
					if callOpcode.OpcodeName == "CALL" then
						local callingIndex = instructions[inst.Index+1]

						--// Check if correct
						if callingIndex.OpcodeName == "CALL" and callingIndex.A == inst.A then
							--// Transform opcode into custom macro
							local customInstruction = require("Bytecode.OpCodes."..tostring(constant)..".lua")("custom",callOpcode)

							instructions[i+1] = customInstruction

							--// Remove unused opcodes

							constants[tonumber(_G.getReg(inst,"B")+1)] = {
								["Index"] = 0,
								["Type"] = "string",
								["Value"] = tostring(math.random(10000,30000))
							}
							instructions[i] = {
								OpcodeName = "INVALID",
								Opcode = "INVALID",
							}
						end
					end
				end
			end
		end
	end


	return instructions,constants
end

--[[ ver1
			local constant = tostring(constants[tonumber(_G.getReg(inst,"B")+1)].Value)
			if opcodes:FindFirstChild(constant)  then
				local callOpcode = (instructions[i+1])
				
				if callOpcode.OpcodeName == "CALL" then
					local callingIndex = instructions[callOpcode.A+1]
					
					if callingIndex == inst then
						--// Transform opcode into custom macro
						warn(callOpcode)
						local customInstruction = require(opcodes:FindFirstChild(constant))("custom",callOpcode)
						
						instructions[i+1] = customInstruction
					end
				end
			end
]]

--[[ ver 2
				for _,foundInst in pairs(instructions) do
					if foundInst.OpcodeName == "CALL" then
						local callingIndex = instructions[foundInst.A+1]
						print(callingIndex,"----------<>",inst)
						if callingIndex == inst then
							--// Transform opcode into custom macro
							warn(foundInst)
							local customInstruction = require(opcodes:FindFirstChild(constant))("custom",foundInst)

							instructions[i+1] = customInstruction
						end
					end
				end
]]