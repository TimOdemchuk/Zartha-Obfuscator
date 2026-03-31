-- FORLOOP
return function(instruction, shiftAmount, constant, settings)
    local reg_a = _G.getReg(instruction, "A")
    local reg_b = _G.getReg(instruction, "B")
    
    return ([=[
    Stack[%d] = Stack[%d] + Stack[%d]
    if (Stack[%d] > 0 and Stack[%d] <= Stack[%d]) or (Stack[%d] <= 0 and Stack[%d] >= Stack[%d]) then
        pointer = pointer + %d
        Stack[%d] = Stack[%d]
    end
    ]=]):format(reg_a, reg_a, reg_a + 2, reg_a + 2, reg_a, reg_a + 1, reg_a + 2, reg_a, reg_a + 1, reg_b, reg_a + 3, reg_a)
end