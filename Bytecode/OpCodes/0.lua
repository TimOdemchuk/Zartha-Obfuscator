-- MOVE 
return [=[
	Temp[1] = :A:
	Temp[2] = :B:
	Temp[3] = Stack
	Temp[4] = Temp[3][Temp[2]]
	Temp[3][Temp[1]] = Temp[4]
]=]

-- Stack[:A:] = Stack[:B:] 