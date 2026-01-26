-- SELF
return [=[
local C = :C:+1
Stack[:A:+1] = Stack[:B:]
if Stack[:A:+1] then
	Stack[:A:] = Stack[:B:][Constants[C]]
end
]=]

