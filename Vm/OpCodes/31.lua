-- FORLOOP
return function(instruction,shiftAmount,constant,settings)
	local reg_a = _G.getReg(instruction,"A")
	local reg_b = _G.getReg(instruction,"B")
	
	return ([=[
	local _step = Stack[%d]
	local _limit = Stack[%d]
	local _index = Stack[%d] + _step
	Stack[%d] = _index
	if (_step > 0 and _index <= _limit) or (_step <= 0 and _index >= _limit) then
		pointer = pointer + %d
		Stack[%d] = _index
	end
	]=]):format(reg_a + 2, reg_a + 1, reg_a, reg_a, reg_b, reg_a + 3)
end

