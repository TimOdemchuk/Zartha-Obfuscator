-- FORPREP
return function(instruction,shiftAmount,constant,settings)
	local layout = [=[
	

	Temp[1] = :A:
	Temp[2] = :B:

	local Step = Stack[Temp[1] + 2]
	local Limit = Stack[Temp[1] + 1]
	local Index = Stack[Temp[1]] + Step

	Stack[Temp[1]] = Index
	
	if (Step > 0 and Index <= Limit) or (Step <= 0 and Index >= Limit) then
	    pointer = pointer + Temp[2] 
	    Stack[Temp[1] + 3] = Index 
	end


	]=]
	
	return layout
end

