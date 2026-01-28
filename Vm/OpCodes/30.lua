-- RETURN:
return function(instruction, shiftAmount, constant, settings)
    local reg_b = _G.getReg(instruction, "B")

    if reg_b == 0 then
        return [[
            local output = {}
            local count = 0
            for i = :A:, top do
                count = count + 1
                output[count] = Stack[i]
            end
            return unpack(output, 1, count)
        ]]
    end
	
	-- VarArg Fix
    return [=[
        local output = {}
        local count = 0
        for i = :A:, :A: + :B: - 2 do
            count = count + 1
            output[count] = Stack[i]
        end
        return unpack(output, 1, count)
    ]=]
end