-- ADD
return function(Inst,shiftAmount,constant,settings)
	local reg_a = _G.getReg(Inst,"A")
	local reg_b = _G.getReg(Inst,"B",true)
	local reg_c = _G.getReg(Inst,"C",true)
	
	local output = ([[
	Stack[:A:] = (%s and Constants[:B:+1] or Stack[:B:]) + (%s and Constants[:C:+1] or Stack[:C:])
	]]):format(tostring(reg_b.k),tostring(reg_c.k))
	
	return output
end


--[[
Stack[Inst.reg_a] = (Inst.reg_b.k and Constants[Inst.reg_b.i] or Stack[Inst.reg_b.i]) + (Inst.reg_c.k and Constants[Inst.reg_c.i] or Stack[Inst.reg_c.i])
]]