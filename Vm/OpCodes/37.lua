-- VARARG
return function(instruction, shiftAmount, constant, settings)
	local reg_a = _G.getReg(instruction, "A")
	local reg_b = _G.getReg(instruction, "B")
	
	if reg_b == 0 then
		return ([=[
	top = %d + #Varargs - 1
	for i = 1, #Varargs do
		Stack[%d + i - 1] = Varargs[i]
	end
	]=]):format(reg_a, reg_a)
	else
		return ([=[
	for i = 1, %d do
		Stack[%d + i - 1] = Varargs[i]
	end
	]=]):format(reg_b - 1, reg_a)
	end
end