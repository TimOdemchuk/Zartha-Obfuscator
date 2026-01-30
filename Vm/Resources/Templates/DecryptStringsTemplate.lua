return [=[
function(str, key) -- Decrypt vars
	local result = {}
	local keyLen = #key
	local n = 0
	local bxor = (bit32 and bit32.bxor) or (bit and bit.bxor) or function(a, b)
		local r, p = 0, 1
		for _ = 1, 8 do
			if a % 2 ~= b % 2 then r = r + p end
			a, b, p = (a - a % 2) / 2, (b - b % 2) / 2, p * 2
		end
		return r
	end
	for i = 1, #str do
		n = n + 1
		result[n] = string.char(bxor(string.byte(str, i), string.byte(key, (i - 1) % keyLen + 1)))
	end
	return table.concat(result)
end
]=]