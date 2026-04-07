-- MOVE 
return function(instruction, shiftAmount, constant, settings)
	local reg_a = _G.getReg(instruction, "A")
	local reg_b = _G.getReg(instruction, "B")
	local temp_a = math.random(1, 16)
	local temp_b = math.random(1, 16)

	while temp_b == temp_a do
		temp_b = math.random(1, 16)
	end
	return ([=[
Temp[%d] = %d
Temp[%d] = %d
Stack[Temp[%d]] = Stack[Temp[%d]]]=]):format(temp_a, reg_a, temp_b, reg_b, temp_a, temp_b)
end 

-- Stack[:A:] = Stack[:B:]