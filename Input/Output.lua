return (("File generated using [Zartha]") and (function() return(function(Env,Constants,shiftKey,decrypt) -- Vars
local char,insert,byte,sub,match,freeze,ttostring,pcall,unpack,concat,tonumber,setmeta,__metatable,__tostring,__index,__call,proxy,pnt,__pairs,__ipairs,Constants,pairs,__newindex = Env["string"]["char"],Env["table"]["insert"],Env["string"]["byte"],Env["string"]["sub"],Env["string"]["match"],Env["table"]["freeze"],Env["tostring"],Env["pcall"],Env["table"]["unpack"],Env["table"]["concat"],Env["tonumber"],Env["setmetatable"],"__metatable","__tostring","__index","__call",Env["newproxy"],Env["print"],"__pairs","__ipairs",{(decrypt("\094\071", "1455")),(decrypt("\081\092\091\082\089", "2041")),(decrypt("\003\050", "2946")),(decrypt("\006\003\005\003\002\003\062", "2353")),(decrypt("\010\058", "811")),(decrypt("\002\050", "1919")),(decrypt("\065\069\089\087\069", "1709")),(decrypt("\116\071\088\090\070\091\089\087\018\112\083\087\081\090\091\088\064\089\022\107\087\065\067\085\070\065", "2269")),},Env["pairs"],"__newindex"


-- VM function
return (function()
	local Stack = {}
	local Temp = {}
	local Upvalues = {}
	local pointer = 1
	local ConstantsCopy = {}
	local top = 0
	local Checks,FixMeta,HandleConstants = (function() -- Env log detection
	local function ooptest(...)
		local a = true and #{ -- troll
			...
		}
		return a
	end
	local Tamper = false
	Env[__index] = function() 
		Tamper = true
	end
	
	if Tamper then
		pointer = 100
	else
		local Checked = nil
		local _,er = pcall(function()
			Checked = (proxy(pnt)) 
		end)
		if Checked then
			pointer = 50
		else
			pointer = 1
		end
	end
	local counter = ooptest(1, 2, 3)
	
	if counter <2 then
		pointer = 50
	end
end)()
,(function()
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
							local removedByte = sub(toSend,1,#toSend-1)
		value = tonumber(removedByte)
		
				elseif lastByte == 4 then -- Constant shift back (String encryption)
					local removedByte = sub(toSend,1,len-1)
					local decrypted = {}
					for i =1,#removedByte  do
						insert(decrypted,char(byte(removedByte,i)-0)) 
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
						local const = ConstantsCopy[at]
		Constants[at] = const
		return const
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
		if pointer == 1 then -- 36 [CLOSURE] 
 	local prevStack = Stack
	local prevUpvalues = Upvalues
	
	Stack[0] = function(...) -- PROTOTYPE 1
		local Constants = {}
		
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
		local Map = {}
		
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
						local removedByte = sub(toSend,1,#toSend-1)
		value = tonumber(removedByte)
		
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
					local const = ConstantsCopy[at]
		Constants[at] = const
		return const
		end,
		[__pairs] = function() return function() pointer = pointer +15 end end,
        [__ipairs] = function() return function() pointer = pointer +10 end end
	})
		while true do
		if pointer == 1 then -- 14 [MUL] 
 	Stack[3] = (false and Constants[1+1] or Stack[1]) * (false and Constants[2+1] or Stack[2])
	 
elseif pointer == 2 then -- 12 [ADD] 
 	Stack[3] = (false and Constants[0+1] or Stack[0]) + (false and Constants[3+1] or Stack[3])
	 
elseif pointer == 3 then -- 30 [RETURN] 
         local output = {}
        local count = 0
        for i = 3, 3 + 2 - 2 do
            count = count + 1
            output[count] = Stack[i]
        end
        return unpack(output, 1, count)
     
elseif pointer == 4 then -- 30 [RETURN] 
         local output = {}
        local count = 0
        for i = 0, 0 + 1 - 2 do
            count = count + 1
            output[count] = Stack[i]
        end
        return unpack(output, 1, count)
     
end
		pointer = pointer+1
		end
	end
 
elseif pointer == 2 then -- 5 [GETGLOBAL] 
 	Temp[1] = 1 -- instA
	Temp[2] = 0+1 -- instB
	Temp[3] = Constants[Temp[2]] -- constant
	Temp[4] = Env[Temp[3]] -- env global
	Stack[Temp[1]] = Temp[4] -- set to stack
	 
elseif pointer == 3 then -- 6 [GETTABLE] 
 	Temp[1] = Constants[1+1]
	Stack[1] = Stack[1][Temp[1]]
	 
elseif pointer == 4 then -- 28 [CALL] 
 	Temp[1] = 1   -- instA
	Temp[2] = 1   -- instB
	Temp[3] = {}    -- args
	Temp[4] = {}    -- output table

	if Temp[2] == 0 then
		Temp[5] = top
	else
		Temp[5] = Temp[1] + Temp[2] - 1
	end

	for i = Temp[1] + 1, Temp[5] do
		Temp[3][i - Temp[1]] = Stack[i]
	end
	
	Temp[4] = {Stack[Temp[1]](unpack(Temp[3], 1, Temp[5] - Temp[1]))}
	
		for i = Temp[1], Temp[1] + 2 - 2 do
		Stack[i] = Temp[4][i+1-Temp[1]]
	end
	Temp = {}
	
	 
elseif pointer == 5 then -- 1 [LOADK] 
 	Temp[1] = 2
	Temp[2] = 2+1
	Temp[3] = Constants[Temp[2]]
	Stack[Temp[1]] = Temp[3]
	 
elseif pointer == 6 then -- 1 [LOADK] 
 	Temp[1] = 3
	Temp[2] = 3+1
	Temp[3] = Constants[Temp[2]]
	Stack[Temp[1]] = Temp[3]
	 
elseif pointer == 7 then -- 1 [LOADK] 
 	Temp[1] = 4
	Temp[2] = 2+1
	Temp[3] = Constants[Temp[2]]
	Stack[Temp[1]] = Temp[3]
	 
elseif pointer == 8 then -- 32 [FORPREP] 
 	Temp[1] = 2
	Temp[2] = 5

	local Init = tonumber(Stack[Temp[1]])
	local Limit = tonumber(Stack[Temp[1] + 1])
	local Step = tonumber(Stack[Temp[1] + 2])

	Stack[Temp[1]] = Init - Step
	Stack[Temp[1] + 1] = Limit
	Stack[Temp[1] + 2] = Step

	pointer = pointer + Temp[2]

	 
elseif pointer == 9 then -- 0 [MOVE] 
 	Stack[6] = Stack[0]
 
elseif pointer == 10 then -- 0 [MOVE] 
 	Stack[7] = Stack[5]
 
elseif pointer == 11 then -- 1 [LOADK] 
 	Temp[1] = 8
	Temp[2] = 4+1
	Temp[3] = Constants[Temp[2]]
	Stack[Temp[1]] = Temp[3]
	 
elseif pointer == 12 then -- 1 [LOADK] 
 	Temp[1] = 9
	Temp[2] = 5+1
	Temp[3] = Constants[Temp[2]]
	Stack[Temp[1]] = Temp[3]
	 
elseif pointer == 13 then -- 28 [CALL] 
 	Temp[1] = 6   -- instA
	Temp[2] = 4   -- instB
	Temp[3] = {}    -- args
	Temp[4] = {}    -- output table

	if Temp[2] == 0 then
		Temp[5] = top
	else
		Temp[5] = Temp[1] + Temp[2] - 1
	end

	for i = Temp[1] + 1, Temp[5] do
		Temp[3][i - Temp[1]] = Stack[i]
	end
	
	Temp[4] = {Stack[Temp[1]](unpack(Temp[3], 1, Temp[5] - Temp[1]))}
	
		for i = Temp[1], Temp[1] + 1 - 2 do
		Stack[i] = Temp[4][i+1-Temp[1]]
	end
	Temp = {}
	
	 
elseif pointer == 14 then -- 31 [FORLOOP] 
 	

	Temp[1] = 2
	Temp[2] = -6

	local Step = Stack[Temp[1] + 2]
	local Limit = Stack[Temp[1] + 1]
	local Index = Stack[Temp[1]] + Step

	Stack[Temp[1]] = Index
	
	if (Step > 0 and Index <= Limit) or (Step <= 0 and Index >= Limit) then
	    pointer = pointer + Temp[2] 
	    Stack[Temp[1] + 3] = Index 
	end


	 
elseif pointer == 15 then -- 5 [GETGLOBAL] 
 	Temp[1] = 2 -- instA
	Temp[2] = 0+1 -- instB
	Temp[3] = Constants[Temp[2]] -- constant
	Temp[4] = Env[Temp[3]] -- env global
	Stack[Temp[1]] = Temp[4] -- set to stack
	 
elseif pointer == 16 then -- 6 [GETTABLE] 
 	Temp[1] = Constants[1+1]
	Stack[2] = Stack[2][Temp[1]]
	 
elseif pointer == 17 then -- 28 [CALL] 
 	Temp[1] = 2   -- instA
	Temp[2] = 1   -- instB
	Temp[3] = {}    -- args
	Temp[4] = {}    -- output table

	if Temp[2] == 0 then
		Temp[5] = top
	else
		Temp[5] = Temp[1] + Temp[2] - 1
	end

	for i = Temp[1] + 1, Temp[5] do
		Temp[3][i - Temp[1]] = Stack[i]
	end
	
	Temp[4] = {Stack[Temp[1]](unpack(Temp[3], 1, Temp[5] - Temp[1]))}
	
		for i = Temp[1], Temp[1] + 2 - 2 do
		Stack[i] = Temp[4][i+1-Temp[1]]
	end
	Temp = {}
	
	 
elseif pointer == 18 then -- 13 [SUB] 
 	Stack[2] = (false and Constants[2+1] or Stack[2]) - (false and Constants[1+1] or Stack[1])
	 
elseif pointer == 19 then -- 5 [GETGLOBAL] 
 	Temp[1] = 3 -- instA
	Temp[2] = 6+1 -- instB
	Temp[3] = Constants[Temp[2]] -- constant
	Temp[4] = Env[Temp[3]] -- env global
	Stack[Temp[1]] = Temp[4] -- set to stack
	 
elseif pointer == 20 then -- 1 [LOADK] 
 	Temp[1] = 4
	Temp[2] = 7+1
	Temp[3] = Constants[Temp[2]]
	Stack[Temp[1]] = Temp[3]
	 
elseif pointer == 21 then -- 28 [CALL] 
 	Temp[1] = 3   -- instA
	Temp[2] = 2   -- instB
	Temp[3] = {}    -- args
	Temp[4] = {}    -- output table

	if Temp[2] == 0 then
		Temp[5] = top
	else
		Temp[5] = Temp[1] + Temp[2] - 1
	end

	for i = Temp[1] + 1, Temp[5] do
		Temp[3][i - Temp[1]] = Stack[i]
	end
	
	Temp[4] = {Stack[Temp[1]](unpack(Temp[3], 1, Temp[5] - Temp[1]))}
	
		for i = Temp[1], Temp[1] + 1 - 2 do
		Stack[i] = Temp[4][i+1-Temp[1]]
	end
	Temp = {}
	
	 
elseif pointer == 22 then -- 5 [GETGLOBAL] 
 	Temp[1] = 3 -- instA
	Temp[2] = 6+1 -- instB
	Temp[3] = Constants[Temp[2]] -- constant
	Temp[4] = Env[Temp[3]] -- env global
	Stack[Temp[1]] = Temp[4] -- set to stack
	 
elseif pointer == 23 then -- 0 [MOVE] 
 	Stack[4] = Stack[2]
 
elseif pointer == 24 then -- 28 [CALL] 
 	Temp[1] = 3   -- instA
	Temp[2] = 2   -- instB
	Temp[3] = {}    -- args
	Temp[4] = {}    -- output table

	if Temp[2] == 0 then
		Temp[5] = top
	else
		Temp[5] = Temp[1] + Temp[2] - 1
	end

	for i = Temp[1] + 1, Temp[5] do
		Temp[3][i - Temp[1]] = Stack[i]
	end
	
	Temp[4] = {Stack[Temp[1]](unpack(Temp[3], 1, Temp[5] - Temp[1]))}
	
		for i = Temp[1], Temp[1] + 1 - 2 do
		Stack[i] = Temp[4][i+1-Temp[1]]
	end
	Temp = {}
	
	 
elseif pointer == 25 then -- 30 [RETURN] 
         local output = {}
        local count = 0
        for i = 0, 0 + 1 - 2 do
            count = count + 1
            output[count] = Stack[i]
        end
        return unpack(output, 1, count)
     
end
		pointer = pointer + 1
	end
end)()

 end)((_ENV or getfenv()),{},0,function(str, key) -- Decrypt vars
	local result = {}
	for i = (6*9-32+(((-21)))), #str do
		local strByte = string.byte(str, i)
		local keyByte = string.byte(key, (i - (36*13-65+(((-402))))) % #key + (6*5-17+(((-12)))))
		table.insert(result, string.char(bit32.bxor(strByte, keyByte)))
	end
	return table.concat(result)
end
) end)())