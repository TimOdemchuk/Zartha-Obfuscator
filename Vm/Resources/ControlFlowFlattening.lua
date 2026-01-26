math.randomseed(os.time())
local main = {}

local function shuffle(targetTable) -- vm scramble function lol
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

	local function getObfuscatedCheck(target)
		local m = math.random(17, 189)  
		local a = math.random(1500, 99999) 

		if math.random() > 0.5 then
			local result = (target * m) + a
			return string.format("(pointer * %d) + %d == %d", m, a, result)
		else
			local result = (target + m) * a
			return string.format("(pointer + %d) * %d == %d", m, a, result)
		end
	end

	local function getJunk()
		local v = math.random(100, 999)
		local junkOptions = {
			string.format("local _v%d = Stack[top]\n\t\t\tif _v%d then top = top - 1 end", v, v),
			string.format("local _v%d = Env[Constants[1]]\n\t\t\tStack[top] = _v%d", v, v),
			string.format("if (pointer * 2) < 0 then Env[1] = nil end"),
			string.format("Stack[pointer] = Constants[pointer]")
		}
		return junkOptions[math.random(1, #junkOptions)]
	end

	for i, data in ipairs(shuffle(opcodeMap)) do
		local ptr, op = data.p, data.c
		local offset = math.random(50, 999)
		local vName = "_v" .. math.random(1000, 9999)
		local junk = getJunk()

		local mathCheck = getObfuscatedCheck(ptr)

		local content = nil

		if math.random() > 0.5 then
			--// Real opcode in 'then', Junk in 'else'
			content = string.format(
				"local %s = pointer + %d\n\t\tif %s > pointer then\n\t\t\tdo\n\t\t\t\t%s\n\t\t\tend\n\t\telse\n\t\t\t%s\n\t\tend", 
				vName, offset, vName, op, junk
			)
		else
			--// Junk in 'then', Real opcode in 'else'
			content = string.format(
				"local %s = pointer - %d\n\t\tif %s > pointer then\n\t\t\t%s\n\t\telse\n\t\t\tdo\n\t\t\t\t%s\n\t\t\tend\n\t\tend", 
				vName, offset, vName, junk, op
			)
		end

        -- pointer checker
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