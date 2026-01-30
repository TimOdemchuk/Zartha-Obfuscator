-- Opcode 34: SETLIST
return function(Inst, shift, const)
	local reg_a = _G.getReg(Inst, "A")
	local reg_b = _G.getReg(Inst, "B")
	local reg_c = _G.getReg(Inst, "C")
	
	if reg_b == 0 then
		return ([=[
	local _limit = top - %d
	for i = 1, _limit do
		Stack[%d][(%d - 1) * 50 + i] = Stack[%d + i]
	end
	]=]):format(reg_a, reg_a, reg_c, reg_a)
	else
		return ([=[
	for i = 1, %d do
		Stack[%d][(%d - 1) * 50 + i] = Stack[%d + i]
	end
	]=]):format(reg_b, reg_a, reg_c, reg_a)
	end
end