-- CLOSURE
return function(inst,shiftAmount,constant,settings)
	local output = ([=[
	local prevStack = Stack
	local prevUpvalues = Upvalues
	
	Stack[:A:] = function(...) -- PROTOTYPE :PROTOHERE:
		local Constants = {CONSTANTS_PROTOTYPE:PROTOHERE:HERE}
		
		local Varargs,Stack,Args,Temp,Upvalues,pointer,top,ConstantsCopy,Map,argCount = {},{},{...},{},{},1,0,{},:MAPPING:
		-- Fix constant int
		for i, Value in pairs(Constants) do
			ConstantsCopy[i] = Value
			Constants[i] = nil
		end
		
		-- fix upvalues
		if next(Map) then
			setmeta(Upvalues, {
			    [__index] = function(self, Key)
			        local map = Map[Key]
			        if not map then return nil end
			        
			        if map[1] == 0 then -- Type 0: Parent Stack
			            return prevStack[map[2]]
			        else -- Type 1: Parent Upvalue
			            return prevUpvalues[map[2]]
			        end
			    end,
			    [__newindex] = function(self, Key, Value)
			        local map = Map[Key]
			        if not map then return end
			        
			        if map[1] == 0 then
			            prevStack[map[2]] = Value
			        else
			            prevUpvalues[map[2]] = Value
			        end
			    end,
			    [__metatable] = {}
			})
		end
		-- Args
		local argCount = #Args
		for i = 1, argCount do
			local arg = Args[i]
			Stack[i - 1] = arg
			Varargs[i] = arg
		end
		
		setmeta(Constants, {
		[__index] = function(Self, Key)
			local toSend = ConstantsCopy[Key]
			local len = #toSend
			local lastByte = byte(toSend, len)
			local value

			if lastByte == 11 then
				%s
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
		[__metatable] = {},
		[__tostring] = function()
			pointer = pointer ^10
			return ttostring(pointer)
		end,
		[__call] = function(_,at)
			%s
		end,
		[__pairs] = function() return function() pointer = pointer +15 end end,
        [__ipairs] = function() return function() pointer = pointer +10 end end
	})
		while true do
		INST_PROTOTYPE:PROTOHERE:HERE
		pointer = pointer+1
		end
	end
]=]):format((not settings.ConstantProtection and [[
		local removedByte = sub(toSend,1,#toSend-1)
		value = tonumber(removedByte)
		]] or ([[
		local removedByte = sub(toSend,1,#toSend-1)
		local decrypted = {}
		for i =1,#removedByte  do
			insert(decrypted,char(byte(removedByte,i)-%s)) 
		end
		value = tonumber(concat(decrypted))
		]]):format(tostring(_G.shiftAmount))),settings.ConstantProtection and [=[
		local const = ConstantsCopy[at]
		if byte(const,#const) == 11 then
			return Constants[at]
		end
		local removedByte = sub(const,1,#const-1)
		Constants[at] = removedByte
		return removedByte
		]=] or [[
		local const = ConstantsCopy[at]
		Constants[at] = const
		return const]])
	
	return output
end


