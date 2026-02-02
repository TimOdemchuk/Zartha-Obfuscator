-- TAILCALL
return function(Inst, shiftAmount, constant, settings)
	local reg_a = _G.getReg(Inst, "A")
	local reg_b = _G.getReg(Inst, "B")
	
	if reg_b == 0 then
		-- Variable args from stack
		return ([=[
	local _args = {}
	for i = %d + 1, top do
		_args[i - %d] = Stack[i]
	end
	return Stack[%d](unpack(_args, 1, top - %d))
	]=]):format(reg_a, reg_a, reg_a, reg_a)
	end
	
	local args = {}
	for i = 1, reg_b - 1 do
		args[i] = ("Stack[%d]"):format(reg_a + i)
	end
	return ("\treturn Stack[%d](%s)"):format(reg_a, table.concat(args, ", "))
end