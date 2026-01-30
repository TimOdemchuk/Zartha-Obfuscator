math.randomseed(os.time())

local main = {}

-- Shuffle function (Vm scramble lol)
local function shuffle(targetTable)
	local output = {}
	
	for i, v in pairs(targetTable) do 
		table.insert(output, {
            p = i,
            c = v
        }) 
	end
	
	for i = #output, 2, -1 do 
		local j = math.random(1, i) 
		output[i], output[j] = output[j], output[i]
	end
	
	return output
end

function main:generateState(opcodeMap)
	local output = {}

	-- Obfuscated check generator (Generate pointer check)
	local function getObfuscatedCheck(target)
		local m = math.random(10, 500)  
		local a = math.random(10, 500) 

		if math.random() > 0.5 then
			local result = (target * m) + a
			return string.format("(pointer * %d) + %d == %d", m, a, result)
		else
			local result = (target + m) * a
			return string.format("(pointer + %d) * %d == %d", m, a, result)
		end
	end

	-- Junk generator
	local function getJunk()
		local v = math.random(100, 999)
		local junkOptions = {
			string.format("if (pointer * 2) < 0 then Env[1] = nil end"),
			string.format("Stack[%d] = Constants[%d+1]",math.random(1,55),math.random(1,5)),
			string.format("Stack[pointer] = Env[Constants[%d+1]]",math.random(1,55)),
			string.format("Stack[%d] = Env[Constants[%d+1]]",math.random(1,10),math.random(1,10)),
			string.format("Stack[%d] = -Stack[%d]",math.random(1,10),math.random(1,10)),
			string.format("pointer = pointer + %d",math.random(1,3)),
			string.format("pointer = pointer + %d",math.random(1,3)),
			string.format("Stack[%d] = (%s and Constants[%d+1] or Stack[%d]) * (%s and Constants[%d+1] or Stack[%d])",math.random(1,10),math.random(0,1) == 1 and "true" or "false",math.random(1,10),math.random(1,10),math.random(0,1) == 1 and "true" or "false",math.random(1,10),math.random(1,10)),
			string.format("Stack[%d] = (%d == 1)",math.random(1,10),math.random(0,1)),
			string.format("Stack[%d] = nil",math.random(1,10)),
			string.format("Stack[%d] = Env[Constants[%d+1]]",math.random(1,10),math.random(1,10)),
		}
		local choice = junkOptions[math.random(1, #junkOptions)]
	
		return choice
	end

	for i, data in ipairs(shuffle(opcodeMap)) do
		local ptr, op = data.p, data.c
		local offset = math.random(50, 999)
		local vName = "_v" .. math.random(1000, 9999)
		local junk = getJunk()


		-- Make sure op is never empty
		if not op or op == "" or op:match("^%s*$") then
			op = getJunk()
		end

		local mathCheck = getObfuscatedCheck(ptr)

		local content = nil

		if math.random() > 0.5 then
			-- Real opcode in 'then', Junk in 'else'
			content = string.format(
				"local %s = pointer + %d\n\t\tif %s > pointer then\n\t\t\tdo\n\t\t\t\t%s\n\t\t\tend\n\t\telse\n\t\t\t%s\n\t\tend", 
				vName, offset, vName, op, junk
			)
		else
			-- Junk in 'then', Real opcode in 'else'
			content = string.format(
				"local %s = pointer - %d\n\t\tif %s > pointer then\n\t\t\t%s\n\t\telse\n\t\t\tdo\n\t\t\t\t%s\n\t\t\tend\n\t\tend", 
				vName, offset, vName, junk, op
			)
		end

        -- Pointer checker
		local line = string.format(
			"%s %s then\n\tdo\n\t\t%s\n\tend",
			i == 1 and "if" or "elseif",
			mathCheck, 
			content
		)
		table.insert(output, line)
	end

	return table.concat(output, "\n") .. "\nend"
end

return main