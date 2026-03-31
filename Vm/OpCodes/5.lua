-- GETGLOBAL
return function(inst,shift,constant,settings)
	local reg_b = _G.getReg(inst,"B")
	local mappedIdx = _G.getMappedConstant(reg_b)
	return ("\tStack[:A:] = vmEnv[Constants[%d]] or Env[Constants[%d]]"):format(mappedIdx, mappedIdx)
end