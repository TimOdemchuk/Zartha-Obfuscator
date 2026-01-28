-- CALL (KEEP IN MIND OF C REGISTER)
return function(Inst, shiftAmount, constant, settings)
	local output = ([=[
	Temp[1] = :A:   -- instA
	Temp[2] = :B:   -- instB
	Temp[3] = {}    -- args
	Temp[4] = {}    -- output table

	if Temp[2] == 0 then
		Temp[5] = top
	else
		Temp[5] = Temp[1] + Temp[2] - 1
	end

	for i = Temp[1] + 1, Temp[5] do
		Temp[3][i - Temp[1]] = Stack[i]
	end
	
	Temp[4] = {Stack[Temp[1]](unpack(Temp[3], 1, Temp[5] - Temp[1]))}
	
	%s
	]=]):format(_G.getReg(Inst, "C") < 1 and [=[
	if #Temp[4] == 0 then
		Stack[Temp[1]] = nil
		top = Temp[1]
	else
		top = Temp[1] + #Temp[4] - 1
		for i = Temp[1], top do
			Stack[i] = Temp[4][i+1-Temp[1]]
		end
	end
	Temp = {}
	]=] or [=[
	for i = Temp[1], Temp[1] + :C: - 2 do
		Stack[i] = Temp[4][i+1-Temp[1]]
	end
	Temp = {}
	]=])

	return output
end