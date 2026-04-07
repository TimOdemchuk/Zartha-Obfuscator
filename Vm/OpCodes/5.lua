-- GETGLOBAL
return function(inst,shift,constant,settings)
	local reg_b = _G.getReg(inst,"B")
	local mappedIdx = _G.getMappedConstant(reg_b)
	local temp_1 = math.random(1, 16)
	local temp_2 = math.random(1, 16)
	local temp_3 = math.random(1, 16)

	while temp_2 == temp_1 do
		temp_2 = math.random(1, 16)
	end

	while temp_3 == temp_1 or temp_3 == temp_2 do
		temp_3 = math.random(1, 16)
	end

	return ([=[Temp[%d] = :A:
Temp[%d] = %d
Temp[%d] = Constants[Temp[%d]]
Stack[Temp[%d]] = vmEnv[Temp[%d]] or Env[Temp[%d]]]=]):format(temp_1, temp_2, mappedIdx, temp_3, temp_2, temp_1, temp_3, temp_3)
end

-- Stack[:A:] = vmEnv[Constants[:B:]] or Env[Constants[:B:]] 