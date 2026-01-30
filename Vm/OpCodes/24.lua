-- LT
return function(instruction,shiftAmount,constant,settings)
	local reg_a = _G.getReg(instruction,"A")
	local reg_b = _G.getReg(instruction,"B",true)
	local reg_c = _G.getReg(instruction,"C",true)
	
	local b_access = reg_b.k and ("C[%d]"):format(_G.getMappedConstant(reg_b.i)) or ("Stack[%d]"):format(reg_b.i)
	local c_access = reg_c.k and ("C[%d]"):format(_G.getMappedConstant(reg_c.i)) or ("Stack[%d]"):format(reg_c.i)
	local op = reg_a > 0 and ">" or "<"
	
	return ("\tif %s %s %s then pointer = pointer + 1 end"):format(b_access, op, c_access)
end