-- Opcode 34: SETLIST
return function(Inst, shift, const)
	local output = ([=[
    Temp[1] = :A: -- inst a
    Temp[2] = :B: -- inst b
    Temp[3] = :C: -- inst c

    local limit = Temp[2] -- limit
    
    -- If B is 0 we must calc the limit based on the stack TOPP
    if limit == 0 then
        limit = top - Temp[1]
    end

    for i = 1, limit do
        Stack[Temp[1]][(Temp[3]-1)*50 + i] = Stack[Temp[1] + i]
    end
    ]=])
	
	return output
end