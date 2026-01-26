return [=[
function(str, key) -- Decrypt vars
	local result = {}
	for i = (6*9-32+(((-21)))), #str do
		local strByte = string.byte(str, i)
		local keyByte = string.byte(key, (i - (36*13-65+(((-402))))) % #key + (6*5-17+(((-12)))))
		table.insert(result, string.char(bit32.bxor(strByte, keyByte)))
	end
	return table.concat(result)
end
]=]