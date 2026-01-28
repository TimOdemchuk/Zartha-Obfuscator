-- Vm Template
return [=[
%s
%s
-- VM function
return (function()%s
	local Stack = {}
	local Temp = {}
	local Upvalues = {}
	local pointer = 1
	local ConstantsCopy = {}
	local top = 0
	local Checks,FixMeta,HandleConstants = :INSERTENVLOG:,(function()
		-- Fix for metatable
		for i, Value in pairs(Constants) do
			ConstantsCopy[i] = Value
			Constants[i] = nil
		end
	end)(),(function()
		-- Handle constant table
		setmeta(Constants, {
			[__index] = function(Self, Key)
				local toSend = ConstantsCopy[Key]
				local len = #toSend
				local lastByte = byte(toSend, len)
				local value

				if lastByte == 11 then -- tonumber (Because constants are strings)
					%s
				elseif lastByte == 4 then -- Constant shift back (String encryption)
					local removedByte = sub(toSend,1,len-1)
					local decrypted = {}
					for i =1,#removedByte  do
						insert(decrypted,char(byte(removedByte,i)-:SHIFTAMOUNT:)) 
					end
					value = concat(decrypted)
				elseif lastByte == 7 then -- Boolean support
					value = byte(toSend, 1) == 116
				elseif lastByte == 6 then -- nil support
					return nil
				else
					value = ConstantsCopy[Key]
				end
				Constants[Key] = value
				return value
			end,
			[__metatable] = {}, -- Prevent access
			[__call] = function(_,at)
				%s
			end,
			[__tostring] = function() -- Accessing constants as string would crash the VM
				pointer = pointer ^10
				return ttostring(pointer)
			end,
			[__pairs] = function() return function() pointer = pointer +15 end end, -- looping constants as string would crash the VM
	        [__ipairs] = function() return function() pointer = pointer +10 end end -- looping constants as string would crash the VM
		})
	end)()
	
	-- VM STARTS HERE
	while true do
		%s
		%s
	end
end)()

]=]