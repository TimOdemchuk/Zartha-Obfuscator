-- R(A) := R(B)[RK(C)]
-- GETTABLE
return function(inst,shiftAmount,constant,settings)
	-- C can be either a constant (k=true) or register (k=false)
	local C = inst.C
	local output
	
	if C.k then
		-- C is a constant reference
		output = ([=[
	Temp[1] = Constants[:Ci:+1]
	Stack[:A:] = Stack[:B:][Temp[1]]
	]=]):gsub(":Ci:", tostring(C.i))
	else
		-- C is a register reference
		output = ([=[
	Temp[1] = Stack[:Ci:]
	Stack[:A:] = Stack[:B:][Temp[1]]
	]=]):gsub(":Ci:", tostring(C.i))
	end
	
	return output
end