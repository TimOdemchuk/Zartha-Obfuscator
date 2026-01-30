-- R(A) := R(B)[RK(C)]
-- GETTABLE
return function(inst,shiftAmount,constant,settings)
	local C = inst.C
	
	if C.k then
		-- C is a constant reference - direct access
		local mappedIdx = _G.getMappedConstant(C.i)
		return ([=[
	Stack[:A:] = Stack[:B:][C[%d]]
	]=]):format(mappedIdx)
	else
		-- C is a register reference
		return ([=[
	Stack[:A:] = Stack[:B:][Stack[%d]]
	]=]):format(C.i)
	end
end