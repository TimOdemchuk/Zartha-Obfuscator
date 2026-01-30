-- CALL (KEEP IN MIND OF C REGISTER)
return function(Inst, shiftAmount, constant, settings)
	local reg_a = _G.getReg(Inst, "A")
	local reg_b = _G.getReg(Inst, "B")
	local reg_c = _G.getReg(Inst, "C")
	
	local args = {}
	if reg_b == 0 then
		return ([=[
	local Args = {}
	for i = :A: + 1, top do
		Args[i - :A:] = Stack[i]
	end
	local Results = {Stack[:A:](unpack(Args, 1, top - :A:))}
	%s
	]=]):format(reg_c < 1 and [=[
	local len = #Results
	if len == 0 then
		Stack[:A:] = nil
		top = :A:
	else
		top = :A: + len - 1
		for i = 1, len do
			Stack[:A: + i - 1] = Results[i]
		end
	end
	]=] or ([=[
	for i = 1, %d do
		Stack[:A: + i - 1] = Results[i]
	end
	]=]):format(reg_c - 1))
	end
	
	local argCount = reg_b - 1
	for i = 1, argCount do
		args[i] = ("Stack[%d]"):format(reg_a + i)
	end
	local argStr = table.concat(args, ", ")
	
	if reg_c < 1 then
		-- Variable return count
		return ([=[
	local Results = {Stack[:A:](%s)}
	local len = #Results
	if len == 0 then
		Stack[:A:] = nil
		top = :A:
	else
		top = :A: + len - 1
		for i = 1, len do
			Stack[:A: + i - 1] = Results[i]
		end
	end
	]=]):format(argStr)
	elseif reg_c == 1 then
		-- No return values needed
		return ("\tStack[:A:](%s)"):format(argStr)
	elseif reg_c == 2 then
		-- Single return value
		return ("\tStack[:A:] = Stack[:A:](%s)"):format(argStr)
	else
		-- Multiple fixed return values
		local rets = {}
		for i = 0, reg_c - 2 do
			rets[i + 1] = ("Stack[%d]"):format(reg_a + i)
		end
		return ("\t%s = Stack[:A:](%s)"):format(table.concat(rets, ", "), argStr)
	end
end