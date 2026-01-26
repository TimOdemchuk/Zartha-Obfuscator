-- VARARG
return [[
Temp[1] = :A:
Temp[2] = :B:

if Temp[2] == 0 then
    Top = Temp[1] + #Varargs - 1
    for i = 1, #Varargs do
        Stack[Temp[1] + i - 1] = Varargs[i]
    end
else
    for i = 1, Temp[2] - 1 do
        Stack[Temp[1] + i - 1] = Varargs[i]
    end
end
]]