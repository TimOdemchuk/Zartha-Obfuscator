-- TESTSET
return function(Inst, shiftAmount, constant, settings)
	local reg_a = _G.getReg(Inst, "A")
	local reg_b = _G.getReg(Inst, "B")
	local reg_c = _G.getReg(Inst, "C")
	
	local check = reg_c ~= 0 and "not" or ""
	return ([=[
	if (%s Stack[%d]) then
		pointer = pointer + 1
	else
		Stack[%d] = Stack[%d]
	end
	]=]):format(check, reg_b, reg_a, reg_b)
end