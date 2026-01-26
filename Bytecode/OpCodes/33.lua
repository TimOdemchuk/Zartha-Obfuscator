--// FORPREP
return function(instruction,shiftAmount,constant,settings)
	local layout = [[

local A = :A:
local C = :C:
local Result = {Stack[A](Stack[A + 1], Stack[A + 2])}

for i = 1, C do
	Stack[A + 2 +i] = Result[i]
end

if Stack[A + 3] ~= nil then
	Stack[A + 2] = Stack[A + 3]
	pointer = pointer + 1
else
	pointer = pointer + 1
end

	]]
	
	return layout
end

