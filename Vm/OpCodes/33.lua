-- TFORLOOP
return function(instruction, shiftAmount, constant, settings)
	local reg_a = _G.getReg(instruction, "A")
	local reg_c = _G.getReg(instruction, "C")
	
	return ([=[
	local _result = {Stack[%d](Stack[%d], Stack[%d])}
	for i = 1, %d do
		Stack[%d + i] = _result[i]
	end
	if Stack[%d] ~= nil then
		Stack[%d] = Stack[%d]
	else
		pointer = pointer + 1
	end
	]=]):format(reg_a, reg_a + 1, reg_a + 2, reg_c, reg_a + 2, reg_a + 3, reg_a + 2, reg_a + 3)
end
