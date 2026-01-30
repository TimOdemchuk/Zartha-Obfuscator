-- MOVE 
return function(instruction, shiftAmount, constant, settings)
	local reg_a = _G.getReg(instruction, "A")
	local reg_b = _G.getReg(instruction, "B")
	return ("\tStack[%d] = Stack[%d]"):format(reg_a, reg_b)
end 

-- Stack[:A:] = Stack[:B:]