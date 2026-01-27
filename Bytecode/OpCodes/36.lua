-- CLOSURE
return function(inst,shiftAmount,constant,settings)
	local output = ([=[
	local prevStack = Stack
	local prevUpvalues = Upvalues
	
	Stack[:A:] = function(...) -- PROTOTYPE :PROTOHERE:
		local Constants = {CONSTANTS_PROTOTYPE:PROTOHERE:HERE}
		
		local Varargs = {}
		local Stack = {}
		local Args = {...}
		local Temp = {}
		local Upvalues = {}
		local pointer = 1	
		local top = 0
		
		local ConstantsCopy = {}
		-- Fix constant int
		for i, Value in pairs(Constants) do
			ConstantsCopy[i] = Value
			Constants[i] = nil
		end
		
		-- upvalue mapping
		:MAPPING:
		
		-- fix upvalues
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
		-- Args
		for i = 1, #Args do
			Stack[i - 1] = Args[i]
		end
		-- Params
		for i = NUMBERPARAMS_PROTOTYPE:B:HERE + 1, #Args do
            insert(Varargs, Args[i])
        end
		setmeta(Constants, {
		[__index] = function(Self, Key)
			local toSend = ConstantsCopy[Key]

			if byte(sub(toSend,#toSend,#toSend)) == 11 then
				%s
			end
			return ConstantsCopy[Key]
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
		INST_PROTOTYPE:B:HERE
		pointer = pointer+1
		end
	end
]=]):format((not settings.ConstantProtection and [[
		local removedByte = sub(toSend,1,#toSend-1)
		return tonumber(removedByte)
		]] or ([[
		local removedByte = sub(toSend,1,#toSend-1)
		local decrypted = {}
		for i =1,#removedByte  do
			insert(decrypted,char(byte(sub(removedByte,i,i))-%s)) 
		end
		return tonumber(concat(decrypted))
		]]):format(tostring(_G.shiftAmount))),settings.ConstantProtection and [=[
		local const = ConstantsCopy[at]
		if byte(sub(const,#const,#const)) == 11 then
			return Constants[at]
		end
		local removedByte = sub(const,1,#const-1)
		return removedByte
		]=] or [[
		local const = ConstantsCopy[at]
		return const]])
	
	return output
end


