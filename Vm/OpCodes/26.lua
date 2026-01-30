-- TEST
return function(Inst,shiftAmount,constant,settings)
	local reg_a = _G.getReg(Inst, "A")
	local reg_c = _G.getReg(Inst, "C")
	
	local check = reg_c == 0 and ("Stack[%d]"):format(reg_a) or ("not Stack[%d]"):format(reg_a)
	return ("\tif %s then pointer = pointer + 1 end"):format(check)
end