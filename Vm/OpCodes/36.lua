-- CLOSURE
return function(inst,shiftAmount,constant,settings)
	local output = ([=[
	local prevStack = Stack
	local prevUpvalues = Upvalues
	
	local rawConsts:PROTOHERE: = {CONSTANTS_PROTOTYPE:PROTOHERE:HERE}
	local C:PROTOHERE: = {}
	for i, v in pairs(rawConsts:PROTOHERE:) do
		v = gsub(v, dot, function(bb)
			if table.find({11,4,7,6},byte(bb)) then
				return bb 
			end
			return char(byte(bb) +:CONSTANT_SHIFTER:) 
		end)
		local len = #v
		local lastByte = byte(v, len)
		if lastByte == 11 then
			%s
		elseif lastByte == 7 then
			C:PROTOHERE:[i] = byte(v, 1) == 116
		elseif lastByte == 6 then
			C:PROTOHERE:[i] = nil
		else
			C:PROTOHERE:[i] = v
		end
	end
	rawConsts:PROTOHERE: = nil
	
	Stack[:A:] = function(...) -- PROTOTYPE :PROTOHERE:
		local Varargs, Stack, Temp, Upvalues, pointer, top, Map = {}, {}, {}, {}, 1, 0, :MAPPING:
		local Args = {...}
		local C = C:PROTOHERE:
		
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
			Stack[i - 1] = Args[i]
			Varargs[i] = Args[i]
		end
		
		while true do
		INST_PROTOTYPE:PROTOHERE:HERE
		pointer = pointer+1
		end
	end
]=]):format((not settings.ConstantProtection and [[
			C:PROTOHERE:[i] = tonumber(sub(v, 1, len - 1))
		]] or ([[
			local removedByte = sub(v, 1, len - 1)
			local decrypted = {}
			local n = 0
			for j = 1, #removedByte do
				n = n + 1
				decrypted[n] = char(byte(removedByte, j) - %s)
			end
			C:PROTOHERE:[i] = tonumber(concat(decrypted))
		]]):format(tostring(_G.shiftAmount))))
	
	return output
end


