-- CONCAT
return function(instruction, shiftAmount, constant, settings)
	local reg_a = _G.getReg(instruction, "A")
	local reg_b = _G.getReg(instruction, "B")
	local reg_c = _G.getReg(instruction, "C")
	
	return ([=[
	Temp[1] = ""
	for i = %d, %d do
		Temp[1] = Temp[1] .. Stack[i]
	end
	Stack[%d] = Temp[1]
	]=]):format(reg_b, reg_c, reg_a)
end