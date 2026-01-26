--// TAILCALL
return [=[
    Temp[1] = :A:   -- Function Register
    Temp[2] = :B:   -- Argument Count (0 = Variable)
    Temp[3] = {}    -- Arguments Table
    
    local limit = 0
    
    if Temp[2] == 0 then
        limit = top
    else
        limit = Temp[1] + Temp[2] - 1
    end

    for i = Temp[1] + 1, limit do
        insert(Temp[3], Stack[i])
    end

    return Stack[Temp[1]](unpack(Temp[3]))
]=]