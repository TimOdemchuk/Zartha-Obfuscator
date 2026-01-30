-- SETUPVAL
return function(instruction, shiftAmount, constant, settings)
	local reg_a = _G.getReg(instruction, "A")
	local reg_b = _G.getReg(instruction, "B")
	return ("\tUpvalues[%d] = Stack[%d]"):format(reg_b, reg_a)
end