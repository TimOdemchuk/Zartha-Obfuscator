-- Vm Template
return [=[
%s
%s
-- VM function
return (function()%s
	local Stack = {}
	local Temp = {}
	local Upvalues = {}
	local pointer = {}
	local ConstantsCopy = {}
	local top = 0
	local Checks,FixMeta,HandleConstants = :INSERTENVLOG:,(function()
		--// Fix for metatable
		for i, Value in pairs(Constants) do
			ConstantsCopy[i] = Value
			Constants[i] = nil
		end
	end)(),(function()
		--// Handle constant table
		setmeta(Constants, {
			[__index] = function(Self, Key)
				local toSend = ConstantsCopy[Key]

				if byte(sub(toSend,#toSend,#toSend)) == 11 then -- tonumber
					%s
				elseif byte(sub(toSend,#toSend,#toSend)) == 4 then -- constant shift back
					local removedByte = sub(toSend,1,#toSend-1)
					local decrypted = {}
					for i =1,#removedByte  do
						insert(decrypted,char(byte(sub(removedByte,i,i))-:SHIFTAMOUNT:)) 
					end
					return concat(decrypted)
				end
				return ConstantsCopy[Key]
			end,
			[__metatable] = {},
			[__call] = function(_,at)
				%s
			end,
			[__tostring] = function()
				pointer = pointer ^10
				return ttostring(pointer)
			end,
			[__pairs] = function() return function() pointer = pointer +15 end end,
	        [__ipairs] = function() return function() pointer = pointer +10 end end
		})
	end)()
	
	--// VM STARTS HERE
	for i = 1, (1+10)^100 do
		%s
		%s
	end
end)()

]=]