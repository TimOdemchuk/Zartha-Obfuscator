-- FORPREP
return function(instruction, shiftAmount, constant, settings)
    local reg_a = _G.getReg(instruction, "A")
    local reg_b = _G.getReg(instruction, "B")
    
    return ([=[
    Stack[%d] = Stack[%d] - Stack[%d]
    pointer = pointer + %d
    ]=]):format(reg_a, reg_a, reg_a + 2, reg_b)
end