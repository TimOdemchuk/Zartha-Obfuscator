-- SELF
-- R(A+1) := R(B); R(A) := R(B)[RK(C)]
return function(inst,shiftAmount,constant,settings)
	local C = inst.C
	local output
	
	if C.k then
		-- C is a constant reference
		output = ([=[
local C = :Ci:+1
Stack[:A:+1] = Stack[:B:]
if Stack[:A:+1] then
	Stack[:A:] = Stack[:B:][Constants[C]]
end
]=]):gsub(":Ci:", tostring(C.i))
	else
		-- C is a register reference  
		output = ([=[
local C = Stack[:Ci:]
Stack[:A:+1] = Stack[:B:]
if Stack[:A:+1] then
	Stack[:A:] = Stack[:B:][C]
end
]=]):gsub(":Ci:", tostring(C.i))
	end
	
	return output
end