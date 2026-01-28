-- FORPREP
return function(instruction,shiftAmount,constant,settings)
	local layout = [=[
	Temp[1] = :A:
	Temp[2] = :B:

	local Init = tonumber(Stack[Temp[1]])
	local Limit = tonumber(Stack[Temp[1] + 1])
	local Step = tonumber(Stack[Temp[1] + 2])

	Stack[Temp[1]] = Init - Step
	Stack[Temp[1] + 1] = Limit
	Stack[Temp[1] + 2] = Step

	pointer = pointer + Temp[2]

	]=]
	
	return layout
end

