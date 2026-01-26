-- CONCAT
return [=[
local output = ""

for i=:B:,:C: do
	output = output..Stack[i]
end

Stack[:A:] = output]=]