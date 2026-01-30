-- LOADK
return function(inst,shift,const,settings)
	local reg_b = _G.getReg(inst,"B")
	local mappedIdx = _G.getMappedConstant(reg_b)
	return ("\tStack[:A:] = C[%d]"):format(mappedIdx)
end