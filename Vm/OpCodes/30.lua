-- RETURN:
return function(instruction, shiftAmount, constant, settings)
    local reg_a = _G.getReg(instruction, "A")
    local reg_b = _G.getReg(instruction, "B")

    if reg_b == 0 then
        -- Variable return count (use top)
        return [=[
            local _out = {}
            local _n = 0
            for i = :A:, top do
                _n = _n + 1
                _out[_n] = Stack[i]
            end
            return unpack(_out, 1, _n)
        ]=]
    elseif reg_b == 1 then
        -- No return values
        return "\treturn"
    elseif reg_b == 2 then
        -- Single return value
        return ("\treturn Stack[%d]"):format(reg_a)
    else
        -- Direct return
        local rets = {}
        for i = 0, reg_b - 2 do
            rets[i + 1] = ("Stack[%d]"):format(reg_a + i)
        end
        return ("\treturn %s"):format(table.concat(rets, ", "))
    end
end