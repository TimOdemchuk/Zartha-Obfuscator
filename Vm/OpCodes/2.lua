-- LOADBOOL
return function(instruction, shiftAmount, constant, settings)
	local reg_a = _G.getReg(instruction, "A")
	local reg_b = _G.getReg(instruction, "B")
	local reg_c = _G.getReg(instruction, "C")
	
	local boolVal = reg_b == 1 and "true" or "false"
	if reg_c ~= 0 then
		return ("\tStack[%d] = %s\n\tpointer = pointer + 1"):format(reg_a, boolVal)
	else
		return ("\tStack[%d] = %s"):format(reg_a, boolVal)
	end
end


