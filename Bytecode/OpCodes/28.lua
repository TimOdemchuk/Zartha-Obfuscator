-- CALL (KEEP IN MIND OF C REGISTER)
return function(Inst,shiftAmount,constant,settings)
	local output = ([=[
	Temp[1] = :A:	-- instA
	Temp[2] = :B: -- instB
	Temp[3] = {} -- args
	Temp[4] = {} -- output table
	Temp[5] = Temp[1] + Temp[2] - 1 -- limit
	
	if Temp[2] == 0 then
		Temp[5] = top+1
	else
		Temp[5] = Temp[1] + Temp[2] - 1
	end

	for i = Temp[1] + 1, Temp[5] do
		insert(Temp[3], Stack[i])
	end
	
	Temp[4] = {Stack[:A:](unpack(Temp[3]))}
	%s
	]=]):format(_G.getReg(Inst,"C") < 1 and [=[
	top = Temp[1] + #Temp[4] - 1
	for i = Temp[1], top do
		Stack[i] = Temp[4][i+1-Temp[1]]
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

--[[

        local func = stack[:a:]
        local args = {}

        local lim = :a: + :b: - 1
        if :b: == 0 then lim = top + 1 end

        for i=:a:+1, lim do
            table_insert(args, stack[i])
        end

        top = :a:-1

        local results = {func(unpack(args))}

        if :c: < 1 then
            for i=:a:, :a:+#results-1 do
                stack[i] = results[i+1-:a:]
            end
        elseif :c: > 1 then
            for i=:a:,:a:+:c:-2 do
                stack[i] = results[i+1-:a:]
            end
        end
]]