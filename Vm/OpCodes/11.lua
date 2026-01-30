-- SELF
-- R(A+1) := R(B); R(A) := R(B)[RK(C)]
return function(inst,shiftAmount,constant,settings)
	local C = inst.C
	local reg_a = _G.getReg(inst,"A")
	local reg_b = _G.getReg(inst,"B")
	
	local c_access = C.k and ("C[%d]"):format(_G.getMappedConstant(C.i)) or ("Stack[%d]"):format(C.i)
	
	return ([=[
	Stack[%d] = Stack[%d]
	if Stack[%d] then
		Stack[%d] = Stack[%d][%s]
	end
	]=]):format(reg_a + 1, reg_b, reg_a + 1, reg_a, reg_b, c_access)
end