-- LOADK
return function(inst,shift,const,settings)
	local reg_b = _G.getReg(inst,"B")
	local mappedIdx = _G.getMappedConstant(reg_b)
	local temp_1 = math.random(1, 16)
	local temp_2 = math.random(1, 16)
	
	while temp_2 == temp_1 do
		temp_2 = math.random(1, 16)
	end

	local temp_3 = math.random(1, 16)
	while temp_3 == temp_1 or temp_3 == temp_2 do
		temp_3 = math.random(1, 16)
	end

	return ([=[Temp[%d] = :A:
Temp[%d] = Constants
Temp[%d] = %d
Stack[Temp[%d]] = Temp[%d][Temp[%d]]]=]):format(temp_1, temp_2, temp_3, mappedIdx, temp_1, temp_2, temp_3)
end

--Stack[:A:] = Constants[%d]