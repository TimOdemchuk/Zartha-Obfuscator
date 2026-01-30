-- FORPREP
return function(instruction,shiftAmount,constant,settings)
	local reg_a = _G.getReg(instruction,"A")
	local reg_b = _G.getReg(instruction,"B")
	
	return ([=[
	local _init = tonumber(Stack[%d])
	local _limit = tonumber(Stack[%d])
	local _step = tonumber(Stack[%d])
	Stack[%d] = _init - _step
	Stack[%d] = _limit
	Stack[%d] = _step
	pointer = pointer + %d
	]=]):format(reg_a, reg_a + 1, reg_a + 2, reg_a, reg_a + 1, reg_a + 2, reg_b)
end

