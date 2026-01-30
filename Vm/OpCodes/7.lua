-- SETGLOBAL
return function(inst,shift,constant,settings)
	local reg_b = _G.getReg(inst,"B")
	local mappedIdx = _G.getMappedConstant(reg_b)
	return ("\tEnv[C[%d]] = Stack[:A:]"):format(mappedIdx)
end