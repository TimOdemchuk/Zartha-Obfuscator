-- CONCAT
return function(instruction, shiftAmount, constant, settings)
	local reg_a = _G.getReg(instruction, "A")
	local reg_b = _G.getReg(instruction, "B")
	local reg_c = _G.getReg(instruction, "C")
	
	return ([=[
	local _out = ""
	for i = %d, %d do
		_out = _out .. Stack[i]
	end
	Stack[%d] = _out
	]=]):format(reg_b, reg_c, reg_a)
end