math.randomseed(os.time())

local main = {}

local random = math.random
local format = string.format

-- Shuffle function (Vm scramble lol)
local function shuffle(targetTable)
	local output = {}
	
	for i, v in pairs(targetTable) do 
		output[#output + 1] = { p = i, c = v }
	end
	
	for i = #output, 2, -1 do 
		local j = random(1, i) 
		output[i], output[j] = output[j], output[i]
	end
	
	return output
end

function main:generateState(opcodeMap)
	-- Obfuscated check generator (Generate pointer check)
	local function getObfuscatedCheck(target)
		local a = random(1, 15)
		local s = random(1, 4)

		if s == 1 then
			return format("pointer + %d == %d", a, target + a)
		elseif s == 2 then
			return format("pointer - %d == %d", a, target - a)
		elseif s == 3 then
			return format("pointer * 2 + %d == %d", a, target * 2 + a)
		else
			return format("pointer * 3 - %d == %d", a, target * 3 - a)
		end
	end

	-- Junk generator
	local function getJunk()
		local s = random(1, 8)
		if s == 1 then
			return format("if (pointer * 2) < 0 then Env[1] = nil end")
		elseif s == 2 then
			return format("Stack[%d] = Constants[%d+1]", random(1,20), random(1,5))
		elseif s == 3 then
			return format("Stack[%d] = Env[Constants[%d+1]]", random(1,8), random(1,8))
		elseif s == 4 then
			return format("Stack[%d] = -Stack[%d]", random(1,8), random(1,8))
		elseif s == 5 then
			return format("Stack[%d] = nil", random(1,8))
		elseif s == 6 then
			return format("Stack[%d] = (%d == 1)", random(1,8), random(0,1))
		elseif s == 7 then
			return format("if pointer > %d then Stack[%d] = Stack[%d] end", random(50,200), random(1,8), random(1,8))
		else
			return format("Stack[%d] = Stack[%d] or Constants[%d+1]", random(1,8), random(1,8), random(1,8))
		end
	end

	local function IfStatments(op, pointer)
		local count = random(1, 3)
		local result = op
		for _ = 1, count do
			local style = random(1, 8)
			local a = random(1, 15)

			-- If statment styles
			if style == 1 then
				result = format("if pointer + %d == %d then\n\t\t\t\t\t%s\n\t\t\t\tend", a, pointer + a, result)
			elseif style == 2 then
				result = format("if pointer - %d == %d then\n\t\t\t\t\t%s\n\t\t\t\tend", a, pointer - a, result)
			elseif style == 3 then
				result = format("if pointer * 2 + %d == %d then\n\t\t\t\t\t%s\n\t\t\t\tend", a, pointer * 2 + a, result)
			elseif style == 4 then
				local wrongPointer = pointer + random(1, 20)
				result = format("if pointer + %d ~= %d then\n\t\t\t\t\t%s\n\t\t\t\tend", a, wrongPointer + a, result)
			elseif style == 5 then
				result = format("if pointer * 3 - %d == %d then\n\t\t\t\t\t%s\n\t\t\t\telse\n\t\t\t\t\tStack[%d] = nil\n\t\t\t\tend", a, pointer * 3 - a, result, random(1, 8))
			elseif style == 6 then
				local wrongTarget = pointer + random(1, 20)
				result = format("if pointer + %d == %d then\n\t\t\t\t\tStack[%d] = nil\n\t\t\t\tend\n\t\t\t\t%s", a, wrongTarget + a, random(1, 8), result)
			elseif style == 7 then
				local wrongTarget = pointer + random(1, 20)
				result = format("if pointer - %d == %d then\n\t\t\t\t\t%s\n\t\t\t\telseif pointer - %d == %d then\n\t\t\t\t\tStack[%d] = Env[%d]\n\t\t\t\tend", a, pointer - a, result, a, wrongTarget - a, random(1, 8), random(1, 8))
			else
				local b = random(1, 10)
				result = format("if pointer * 2 - %d == %d then\n\t\t\t\t\t%s\n\t\t\t\tend", b, pointer * 2 - b, result)
			end
		end
		return result
	end

	-- Obfuscated split compare
	local function getObfuscatedSplit(splitPoint)
		local a = random(1, 15)
		local s = random(1, 4)
		if s == 1 then
			return format("pointer + %d <= %d", a, splitPoint + a)
		elseif s == 2 then
			return format("pointer - %d <= %d", a, splitPoint - a)
		elseif s == 3 then
			return format("pointer * 2 <= %d", splitPoint * 2)
		else
			return format("pointer * 3 - %d <= %d", a, splitPoint * 3 - a)
		end
	end

	-- Process all opcodes into entries
	local entries = {}

	for pointer, op in pairs(opcodeMap) do
		if not op or op == "" or op:match("^%s*$") then
			op = getJunk()
		end

		local content = nil
		local style = random(1, 10)

		-- these are sizes to prevent the vm from being way to big
		if style <= 4 then
			-- Small type
			local a = random(1, 15)
			content = format(
				"if pointer + %d == %d then\n\t\t\t%s\n\t\tend",
				a, pointer + a, op
			)
		elseif style <= 7 then
			-- Medium type 
			op = IfStatments(op, pointer)
			content = format("do\n\t\t\t%s\n\t\tend", op)
		else
			-- Normal
			local offset = random(5, 99)
			local vName = "_v" .. random(10, 99)
			local junk = getJunk()
			op = IfStatments(op, pointer)

			if random() > 0.5 then
				content = format(
					"local %s = pointer + %d\n\t\tif %s > pointer then\n\t\t\tdo\n\t\t\t\t%s\n\t\t\tend\n\t\telse\n\t\t\t%s\n\t\tend", 
					vName, offset, vName, op, junk
				)
			else
				content = format(
					"local %s = pointer - %d\n\t\tif %s > pointer then\n\t\t\t%s\n\t\telse\n\t\t\tdo\n\t\t\t\t%s\n\t\t\tend\n\t\tend", 
					vName, offset, vName, junk, op
				)
			end
		end

		entries[#entries + 1] = {
			pointer = pointer,
			content = content,
		}
	end

	-- sorter
	table.sort(entries, function(a, b)
		 return a.pointer < b.pointer 
	end)

	-- binary tree
	local function buildTree(items, depth)
		depth = depth or 0
		local indent = string.rep("\t", depth)

		if #items == 0 then
			return indent .. "-- uhh this empty"
		end

		if #items <= 4 then
			for i = #items, 2, -1 do
				local j = random(1, i)
				items[i], items[j] = items[j], items[i]
			end

			local lines = {}

			for i, v in ipairs(items) do
				local mathCheck = getObfuscatedCheck(v.pointer)

				local line = format(
					"%s%s %s then\n%s\tdo\n%s\t\t%s\n%s\tend",
					indent,
					i == 1 and "if" or "elseif",
					mathCheck,
					indent, indent,
					v.content,
					indent
				)

				lines[#lines+1] = line
			end
			return table.concat(lines, "\n") .. "\n" .. indent .. "end"
		end

		-- Divide opcodes in half by pointer value
		local mid = math.floor(#items / 2)
		local left = {}
		local right = {}

		for i = 1, mid do 
			left[#left+1] = items[i] 
		end

		for i = mid+1, #items do
			 right[#right+1] = items[i] 
		end

		local splitPoint = left[#left].pointer
		local splitCheck = getObfuscatedSplit(splitPoint)

		return format(
			"%sif %s then\n%s\n%selse\n%s\n%send",
			indent, splitCheck,
			buildTree(left, depth+1),
			indent,
			buildTree(right, depth+1),
			indent
		)
	end

	return buildTree(entries, 0)
end

return main