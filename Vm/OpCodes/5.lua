-- GETGLOBAL
return function(inst,shift,constant,settings)
	local output = [=[
	Temp[1] = :A: -- instA
	Temp[2] = :B:+1 -- instB
	Temp[3] = Constants[Temp[2]] -- constant
	Temp[4] = Env[Temp[3]] -- env global
	Stack[Temp[1]] = Temp[4] -- set to stack
	]=]
	
	return output
end

-- Stack[:A:] = Env[Constants[:B:+1]]