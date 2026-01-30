-- MOD
return function(Inst,shiftAmount,constant,settings)
	local reg_a = _G.getReg(Inst,"A")
	local reg_b = _G.getReg(Inst,"B",true)
	local reg_c = _G.getReg(Inst,"C",true)

	local b_access = reg_b.k and ("C[%d]"):format(_G.getMappedConstant(reg_b.i)) or ("Stack[%d]"):format(reg_b.i)
	local c_access = reg_c.k and ("C[%d]"):format(_G.getMappedConstant(reg_c.i)) or ("Stack[%d]"):format(reg_c.i)
	
	return ("\tStack[:A:] = %s %% %s"):format(b_access, c_access)
end
