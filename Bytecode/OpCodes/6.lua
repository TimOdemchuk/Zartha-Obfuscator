-- R(A) := R(B)[RK(C)]
-- SETTABLE
return function(inst,shiftAmount,constant,settings)
	local output = ([=[
	Temp[1] = Constants[:C:+1]
	Stack[:A:] = Stack[:B:][Temp[1]]
	]=])
	
	return output
end


--stack[:a:] = stack[:b:][:c: and constants[:c:] or stack[:c:]]