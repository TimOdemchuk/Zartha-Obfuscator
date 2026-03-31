-- TFORLOOP
return function(instruction, shiftAmount, constant, settings)
    local reg_a = _G.getReg(instruction, "A")
    local reg_c = _G.getReg(instruction, "C")
    
    local returns = {}
    local assignments = {}

    for i = 1, reg_c do
        returns[i] = "r" .. i
        assignments[i] = string.format("Stack[%d] = r%d", reg_a + 2 + i, i)
    end
    
    local ret_str = table.concat(returns, ", ")
    local assign_str = table.concat(assignments, "\n        ")

    return ([=[
    local %s = Stack[%d](Stack[%d], Stack[%d])
    %s
    if Stack[%d] ~= nil then
        Stack[%d] = Stack[%d]
    else
        pointer = pointer + 1
    end
    ]=]):format(ret_str, reg_a, reg_a + 1, reg_a + 2, assign_str, reg_a + 3, reg_a + 2, reg_a + 3)
end