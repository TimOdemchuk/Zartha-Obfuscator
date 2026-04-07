-- LOADBOOL
return function(instruction, shiftAmount, constant, settings)
	local reg_a = _G.getReg(instruction, "A")
	local reg_b = _G.getReg(instruction, "B")
	local reg_c = _G.getReg(instruction, "C")
	local temp_1 = math.random(1, 16)
	local temp_2 = math.random(1, 16)
	local temp_3 = math.random(1, 16)
	local boolVal = reg_b == 1 and "ttostring ~= __metatable" or "byte == pairs"--funny

	while temp_2 == temp_1 do
		temp_2 = math.random(1, 16)
	end
	
	while temp_3 == temp_1 or temp_3 == temp_2 do
		temp_3 = math.random(1, 16)
	end
	
	if reg_c ~= 0 then
		return ([=[Temp[%d] = %d
Temp[%d] = %s
Stack[Temp[%d]] = Temp[%d]\n\tpointer = pointer + 1]=]):format(temp_1, reg_a, temp_2, boolVal, temp_1, temp_3)
	else
		return ([=[Temp[%d] = %d
Temp[%d] = %s
Stack[Temp[%d]] = Temp[%d]]=]):format(temp_1, reg_a, temp_2, boolVal, temp_1, temp_3)
	end
end


-- Stack[:A:] = :B: == 1 <-- Compare check 