-- SETTABLE
return function(inst)
	local reg_b = _G.getReg(inst,"B",true)
	local reg_c = _G.getReg(inst,"C",true)

	local b_access = reg_b.k and ("C[%d]"):format(_G.getMappedConstant(reg_b.i)) or ("Stack[%d]"):format(reg_b.i)
	local c_access = reg_c.k and ("C[%d]"):format(_G.getMappedConstant(reg_c.i)) or ("Stack[%d]"):format(reg_c.i)
	
	return ("\tStack[:A:][%s] = %s"):format(b_access, c_access)
end