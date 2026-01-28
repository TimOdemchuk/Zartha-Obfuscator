return (("File generated using [Zartha]") and (function() return(function(Env,Constants,shiftKey,decrypt) -- Vars
local char,insert,byte,sub,match,freeze,ttostring,pcall,unpack,concat,tonumber,setmeta,__metatable,__tostring,__index,__call,proxy,pnt,__pairs,__ipairs,Constants,pairs,__newindex = Env["string"]["char"],Env["table"]["insert"],Env["string"]["byte"],Env["string"]["sub"],Env["string"]["match"],Env["table"]["freeze"],Env["tostring"],Env["pcall"],Env["table"]["unpack"],Env["table"]["concat"],Env["tonumber"],Env["setmetatable"],"__metatable","__tostring","__index","__call",Env["newproxy"],Env["print"],"__pairs","__ipairs",{(decrypt("\065\074\090\088\069", "1836")),(decrypt("\089\086\089\093\092", "135")),(decrypt("\007\050", "795")),(decrypt("\065\075\081\095\069\095", "1981")),(decrypt("\106\105\092\091\082\080\077", "565")),(decrypt("\092\083\069", "2621")),(decrypt("\064\082\075\064\104\075\081\091\094\107\088\072\087\088\092\081", "478")),(decrypt("\089\085\089\091\094\016\091\088\094\082\070", "1057")),(decrypt("\006\062", "2559")),(decrypt("\005\050", "798")),(decrypt("\003\003\058", "2517")),(decrypt("\089\091\023\084\072\018\089\088\092\087\023\080\066\018", "1279")),(decrypt("\020\089\092\080\024\091\064\024\091\071\024\085\070\093\083\064\024\070\091\024\095\081\093\070\020\065\093\065", "482")),(decrypt("\000\050", "1926")),(decrypt("\004\051", "1824")),(decrypt("\002\057", "1235")),(decrypt("\014\015\062", "765")),(decrypt("\009\050", "1906")),},Env["pairs"],"__newindex"


-- VM function
return (function()
	local Stack = {}
	local Temp = {}
	local Upvalues = {}
	local pointer = {}
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

				if byte(sub(toSend,#toSend,#toSend)) == 11 then -- tonumber (Because constants are strings)
							local removedByte = sub(toSend,1,#toSend-1)
		return tonumber(removedByte)
		
				elseif byte(sub(toSend,#toSend,#toSend)) == 4 then -- Constant shift back (String encryption)
					local removedByte = sub(toSend,1,#toSend-1)
					local decrypted = {}
					for i =1,#removedByte  do
						insert(decrypted,char(byte(sub(removedByte,i,i))-0)) 
					end
					return concat(decrypted)
				elseif byte(sub(toSend,#toSend,#toSend)) == 7 then -- Boolean support
					if byte(sub(toSend,1,1)) == 116 then
						return true
					else
						return false
					end
				elseif byte(sub(toSend,#toSend,#toSend)) == 6 then -- nil support
					return nil
				end
				return ConstantsCopy[Key]
			end,
			[__metatable] = {}, -- Prevent access
			[__call] = function(_,at)
						local const = ConstantsCopy[at]
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
	for i = 1, (1+10)^100 do
		if pointer == 1 then -- 5 [GETGLOBAL] 
 	Temp[1] = 0 -- instA
	Temp[2] = 0+1 -- instB
	Temp[3] = Constants[Temp[2]] -- constant
	Temp[4] = Env[Temp[3]] -- env global
	Stack[Temp[1]] = Temp[4] -- set to stack
	 
elseif pointer == 2 then -- 1 [LOADK] 
 	Temp[1] = 1
	Temp[2] = 1+1
	Temp[3] = Constants[Temp[2]]
	Stack[Temp[1]] = Temp[3]
	 
elseif pointer == 3 then -- 2 [LOADBOOL] 
 Stack[2] = (1 == 1) 
elseif pointer == 4 then -- 3 [LOADNIL] 
 Stack[3] = nil 
elseif pointer == 5 then -- 0 [MOVE] 
 	Temp[1] = 8
	Temp[2] = 1
	Temp[3] = Stack
	Temp[4] = Temp[3][Temp[2]]
	Temp[3][Temp[1]] = Temp[4]
 
elseif pointer == 6 then -- 0 [MOVE] 
 	Temp[1] = 9
	Temp[2] = 0
	Temp[3] = Stack
	Temp[4] = Temp[3][Temp[2]]
	Temp[3][Temp[1]] = Temp[4]
 
elseif pointer == 7 then -- 0 [MOVE] 
 	Temp[1] = 10
	Temp[2] = 3
	Temp[3] = Stack
	Temp[4] = Temp[3][Temp[2]]
	Temp[3][Temp[1]] = Temp[4]
 
elseif pointer == 8 then -- 0 [MOVE] 
 	Temp[1] = 11
	Temp[2] = 4
	Temp[3] = Stack
	Temp[4] = Temp[3][Temp[2]]
	Temp[3][Temp[1]] = Temp[4]
 
elseif pointer == 9 then -- 0 [MOVE] 
 	Temp[1] = 12
	Temp[2] = 5
	Temp[3] = Stack
	Temp[4] = Temp[3][Temp[2]]
	Temp[3][Temp[1]] = Temp[4]
 
elseif pointer == 10 then -- 0 [MOVE] 
 	Temp[1] = 13
	Temp[2] = 6
	Temp[3] = Stack
	Temp[4] = Temp[3][Temp[2]]
	Temp[3][Temp[1]] = Temp[4]
 
elseif pointer == 11 then -- 0 [MOVE] 
 	Temp[1] = 14
	Temp[2] = 7
	Temp[3] = Stack
	Temp[4] = Temp[3][Temp[2]]
	Temp[3][Temp[1]] = Temp[4]
 
elseif pointer == 12 then -- 0 [MOVE] 
 	Temp[1] = 15
	Temp[2] = 2
	Temp[3] = Stack
	Temp[4] = Temp[3][Temp[2]]
	Temp[3][Temp[1]] = Temp[4]
 
elseif pointer == 13 then -- 0 [MOVE] 
 	Temp[1] = 16
	Temp[2] = 8
	Temp[3] = Stack
	Temp[4] = Temp[3][Temp[2]]
	Temp[3][Temp[1]] = Temp[4]
 
elseif pointer == 14 then -- 28 [CALL] 
 	Temp[1] = 9   -- instA
	Temp[2] = 8   -- instB
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
	
	 
elseif pointer == 15 then -- 1 [LOADK] 
 	Temp[1] = 9
	Temp[2] = 2+1
	Temp[3] = Constants[Temp[2]]
	Stack[Temp[1]] = Temp[3]
	 
elseif pointer == 16 then -- 36 [CLOSURE] 
 	local prevStack = Stack
	local prevUpvalues = Upvalues
	
	Stack[10] = function(...) -- PROTOTYPE 1
		local Constants = {(decrypt("\001\056", "1330")),(decrypt("\073\080\092\075\066", "915")),(decrypt("\000\005\058", "2615")),(decrypt("\004\063", "1425")),(decrypt("\001\006\051", "2086")),(decrypt("\006\006\007\057", "1222")),(decrypt("\002\062", "1517")),(decrypt("\000\051", "2899")),(decrypt("\000\006\060", "1470")),(decrypt("\007\002\003\059", "2400")),(decrypt("\005\062", "2560")),(decrypt("\004\003\063", "1546")),(decrypt("\009\059", "100")),(decrypt("\004\015\058", "2814")),(decrypt("\003\060", "2733")),}
		
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
		local Map = {[0] = {0, 0}, [1] = {0, 9}}
		
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
		for i = 0 + 1, #Args do
            insert(Varargs, Args[i])
        end
		setmeta(Constants, {
		[__index] = function(Self, Key)
			local toSend = ConstantsCopy[Key]

			if byte(sub(toSend,#toSend,#toSend)) == 11 then
						local removedByte = sub(toSend,1,#toSend-1)
		return tonumber(removedByte)
		
			elseif byte(sub(toSend,#toSend,#toSend)) == 7 then -- Boolean support
				if byte(sub(toSend,1,1)) == 116 then
					return true
				else
					return false
				end
			elseif byte(sub(toSend,#toSend,#toSend)) == 7 then -- Boolean support
				if byte(sub(toSend,1,1)) == 116 then
					return true
				else
					return false
				end
			elseif byte(sub(toSend,#toSend,#toSend)) == 6 then -- nil support
				return nil
			end

			return ConstantsCopy[Key]
		end,
		[__metatable] = {},
		[__tostring] = function()
			pointer = pointer ^10
			return ttostring(pointer)
		end,
		[__call] = function(_,at)
					local const = ConstantsCopy[at]
		return const
		end,
		[__pairs] = function() return function() pointer = pointer +15 end end,
        [__ipairs] = function() return function() pointer = pointer +10 end end
	})
		while true do
		if pointer == 1 then -- 10 [NEWTABLE] 
 Temp[1] = 1
Temp[2] = {}
Stack[Temp[1]] = Temp[2]
 
elseif pointer == 2 then -- 37 [VARARG] 
 Temp[1] = 2
Temp[2] = 0

if Temp[2] == 0 then
    top = Temp[1] + #Varargs - 1
    for i = 1, #Varargs do
        Stack[Temp[1] + i - 1] = Varargs[i]
    end
else
    for i = 1, Temp[2] - 1 do
        Stack[Temp[1] + i - 1] = Varargs[i]
    end
end
 
elseif pointer == 3 then -- 34 [SETLIST] 
     Temp[1] = 1 -- inst a
    Temp[2] = 0 -- inst b
    Temp[3] = 1 -- inst c

    local limit = Temp[2] -- limit
    
    -- If B is 0 we must calc the limit based on the stack TOPP
    if limit == 0 then
        limit = top - Temp[1]
    end

    for i = 1, limit do
        Stack[Temp[1]][(Temp[3]-1)*50 + i] = Stack[Temp[1] + i]
    end
     
elseif pointer == 4 then -- 1 [LOADK] 
 	Temp[1] = 2
	Temp[2] = 0+1
	Temp[3] = Constants[Temp[2]]
	Stack[Temp[1]] = Temp[3]
	 
elseif pointer == 5 then -- 5 [GETGLOBAL] 
 	Temp[1] = 3 -- instA
	Temp[2] = 1+1 -- instB
	Temp[3] = Constants[Temp[2]] -- constant
	Temp[4] = Env[Temp[3]] -- env global
	Stack[Temp[1]] = Temp[4] -- set to stack
	 
elseif pointer == 6 then -- 0 [MOVE] 
 	Temp[1] = 4
	Temp[2] = 1
	Temp[3] = Stack
	Temp[4] = Temp[3][Temp[2]]
	Temp[3][Temp[1]] = Temp[4]
 
elseif pointer == 7 then -- 28 [CALL] 
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
	
		for i = Temp[1], Temp[1] + 4 - 2 do
		Stack[i] = Temp[4][i+1-Temp[1]]
	end
	Temp = {}
	
	 
elseif pointer == 8 then -- 22 [JMP] 
 pointer = pointer + 1 print('[VM]:','JMP -- >',pointer) 
elseif pointer == 9 then -- 12 [ADD] 
 	Stack[2] = (false and Constants[2+1] or Stack[2]) + (false and Constants[7+1] or Stack[7])
	 
elseif pointer == 10 then -- 33 [TFORLOOP] 
 	local A = 3
	local C = 2
	local Result = {
		Stack[A](Stack[A + 1], 
		Stack[A + 2])
	}

	for i = 1, C do
		Stack[A + 2 +i] = Result[i]
	end

	if Stack[A + 3] ~= nil then
		Stack[A +2] = Stack[A + 3]
	else
		pointer = pointer + 1
	end
 
elseif pointer == 11 then -- 22 [JMP] 
 pointer = pointer + -3 print('[VM]:','JMP -- >',pointer) 
elseif pointer == 12 then -- 4 [GETUPVAL] 
 Stack[3] = Upvalues[0] 
elseif pointer == 13 then -- 0 [MOVE] 
 	Temp[1] = 4
	Temp[2] = 1
	Temp[3] = Stack
	Temp[4] = Temp[3][Temp[2]]
	Temp[3][Temp[1]] = Temp[4]
 
elseif pointer == 14 then -- 20 [LEN] 
 Stack[5] = #Stack[1] 
elseif pointer == 15 then -- 0 [MOVE] 
 	Temp[1] = 6
	Temp[2] = 2
	Temp[3] = Stack
	Temp[4] = Temp[3][Temp[2]]
	Temp[3][Temp[1]] = Temp[4]
 
elseif pointer == 16 then -- 4 [GETUPVAL] 
 Stack[7] = Upvalues[1] 
elseif pointer == 17 then -- 28 [CALL] 
 	Temp[1] = 3   -- instA
	Temp[2] = 5   -- instB
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
	
	 
elseif pointer == 18 then -- 4 [GETUPVAL] 
 Stack[3] = Upvalues[1] 
elseif pointer == 19 then -- 12 [ADD] 
 	Stack[3] = (false and Constants[3+1] or Stack[3]) + (false and Constants[2+1] or Stack[2])
	 
elseif pointer == 20 then -- 8 [SETUPVAL] 
 Upvalues[1] = Stack[3] 
elseif pointer == 21 then -- 10 [NEWTABLE] 
 Temp[1] = 3
Temp[2] = {}
Stack[Temp[1]] = Temp[2]
 
elseif pointer == 22 then -- 1 [LOADK] 
 	Temp[1] = 4
	Temp[2] = 2+1
	Temp[3] = Constants[Temp[2]]
	Stack[Temp[1]] = Temp[3]
	 
elseif pointer == 23 then -- 1 [LOADK] 
 	Temp[1] = 5
	Temp[2] = 3+1
	Temp[3] = Constants[Temp[2]]
	Stack[Temp[1]] = Temp[3]
	 
elseif pointer == 24 then -- 1 [LOADK] 
 	Temp[1] = 6
	Temp[2] = 4+1
	Temp[3] = Constants[Temp[2]]
	Stack[Temp[1]] = Temp[3]
	 
elseif pointer == 25 then -- 1 [LOADK] 
 	Temp[1] = 7
	Temp[2] = 5+1
	Temp[3] = Constants[Temp[2]]
	Stack[Temp[1]] = Temp[3]
	 
elseif pointer == 26 then -- 1 [LOADK] 
 	Temp[1] = 8
	Temp[2] = 6+1
	Temp[3] = Constants[Temp[2]]
	Stack[Temp[1]] = Temp[3]
	 
elseif pointer == 27 then -- 1 [LOADK] 
 	Temp[1] = 9
	Temp[2] = 7+1
	Temp[3] = Constants[Temp[2]]
	Stack[Temp[1]] = Temp[3]
	 
elseif pointer == 28 then -- 1 [LOADK] 
 	Temp[1] = 10
	Temp[2] = 8+1
	Temp[3] = Constants[Temp[2]]
	Stack[Temp[1]] = Temp[3]
	 
elseif pointer == 29 then -- 1 [LOADK] 
 	Temp[1] = 11
	Temp[2] = 9+1
	Temp[3] = Constants[Temp[2]]
	Stack[Temp[1]] = Temp[3]
	 
elseif pointer == 30 then -- 1 [LOADK] 
 	Temp[1] = 12
	Temp[2] = 10+1
	Temp[3] = Constants[Temp[2]]
	Stack[Temp[1]] = Temp[3]
	 
elseif pointer == 31 then -- 1 [LOADK] 
 	Temp[1] = 13
	Temp[2] = 11+1
	Temp[3] = Constants[Temp[2]]
	Stack[Temp[1]] = Temp[3]
	 
elseif pointer == 32 then -- 1 [LOADK] 
 	Temp[1] = 14
	Temp[2] = 12+1
	Temp[3] = Constants[Temp[2]]
	Stack[Temp[1]] = Temp[3]
	 
elseif pointer == 33 then -- 1 [LOADK] 
 	Temp[1] = 15
	Temp[2] = 13+1
	Temp[3] = Constants[Temp[2]]
	Stack[Temp[1]] = Temp[3]
	 
elseif pointer == 34 then -- 1 [LOADK] 
 	Temp[1] = 16
	Temp[2] = 12+1
	Temp[3] = Constants[Temp[2]]
	Stack[Temp[1]] = Temp[3]
	 
elseif pointer == 35 then -- 34 [SETLIST] 
     Temp[1] = 3 -- inst a
    Temp[2] = 13 -- inst b
    Temp[3] = 1 -- inst c

    local limit = Temp[2] -- limit
    
    -- If B is 0 we must calc the limit based on the stack TOPP
    if limit == 0 then
        limit = top - Temp[1]
    end

    for i = 1, limit do
        Stack[Temp[1]][(Temp[3]-1)*50 + i] = Stack[Temp[1] + i]
    end
     
elseif pointer == 36 then -- 4 [GETUPVAL] 
 Stack[4] = Upvalues[1] 
elseif pointer == 37 then -- 9 [SETTABLE] 
 		Stack[3][Constants[14+1]] = Stack[4]
	 
elseif pointer == 38 then -- 4 [GETUPVAL] 
 Stack[4] = Upvalues[0] 
elseif pointer == 39 then -- 0 [MOVE] 
 	Temp[1] = 5
	Temp[2] = 3
	Temp[3] = Stack
	Temp[4] = Temp[3][Temp[2]]
	Temp[3][Temp[1]] = Temp[4]
 
elseif pointer == 40 then -- 20 [LEN] 
 Stack[6] = #Stack[3] 
elseif pointer == 41 then -- 6 [GETTABLE] 
 	Temp[1] = Constants[14+1]
	Stack[7] = Stack[3][Temp[1]]
	 
elseif pointer == 42 then -- 4 [GETUPVAL] 
 Stack[8] = Upvalues[1] 
elseif pointer == 43 then -- 28 [CALL] 
 	Temp[1] = 4   -- instA
	Temp[2] = 5   -- instB
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
	
	 
elseif pointer == 44 then -- 0 [MOVE] 
 	Temp[1] = 4
	Temp[2] = 3
	Temp[3] = Stack
	Temp[4] = Temp[3][Temp[2]]
	Temp[3][Temp[1]] = Temp[4]
 
elseif pointer == 45 then -- 0 [MOVE] 
 	Temp[1] = 5
	Temp[2] = 2
	Temp[3] = Stack
	Temp[4] = Temp[3][Temp[2]]
	Temp[3][Temp[1]] = Temp[4]
 
elseif pointer == 46 then -- 6 [GETTABLE] 
 	Temp[1] = Constants[6+1]
	Stack[6] = Stack[3][Temp[1]]
	 
elseif pointer == 47 then -- 30 [RETURN] 
         local output = {}
        local count = 0
        for i = 4, 4 + 4 - 2 do
            count = count + 1
            output[count] = Stack[i]
        end
        return unpack(output, 1, count)
     
elseif pointer == 48 then -- 30 [RETURN] 
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
 
elseif pointer == 17 then -- -1 [PSEUDO] 
 -- [PSEUDO] Handled by CLOSURE 
elseif pointer == 18 then -- -1 [PSEUDO] 
 -- [PSEUDO] Handled by CLOSURE 
elseif pointer == 19 then -- 7 [SETGLOBAL] 
 Env[Constants[3+1]] = Stack[1]  
elseif pointer == 20 then -- 10 [NEWTABLE] 
 Temp[1] = 11
Temp[2] = {}
Stack[Temp[1]] = Temp[2]
 
elseif pointer == 21 then -- 9 [SETTABLE] 
 		Stack[11][Constants[4+1]] = Stack[11]
	 
elseif pointer == 22 then -- 36 [CLOSURE] 
 	local prevStack = Stack
	local prevUpvalues = Upvalues
	
	Stack[12] = function(...) -- PROTOTYPE 2
		local Constants = {(decrypt("\065\080\077\095\087\065\088\070\083\087\085\087", "2592")),(decrypt("\073\004", "950")),}
		
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
		local Map = {[0] = {0, 11}}
		
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
		for i = 0 + 1, #Args do
            insert(Varargs, Args[i])
        end
		setmeta(Constants, {
		[__index] = function(Self, Key)
			local toSend = ConstantsCopy[Key]

			if byte(sub(toSend,#toSend,#toSend)) == 11 then
						local removedByte = sub(toSend,1,#toSend-1)
		return tonumber(removedByte)
		
			elseif byte(sub(toSend,#toSend,#toSend)) == 7 then -- Boolean support
				if byte(sub(toSend,1,1)) == 116 then
					return true
				else
					return false
				end
			elseif byte(sub(toSend,#toSend,#toSend)) == 7 then -- Boolean support
				if byte(sub(toSend,1,1)) == 116 then
					return true
				else
					return false
				end
			elseif byte(sub(toSend,#toSend,#toSend)) == 6 then -- nil support
				return nil
			end

			return ConstantsCopy[Key]
		end,
		[__metatable] = {},
		[__tostring] = function()
			pointer = pointer ^10
			return ttostring(pointer)
		end,
		[__call] = function(_,at)
					local const = ConstantsCopy[at]
		return const
		end,
		[__pairs] = function() return function() pointer = pointer +15 end end,
        [__ipairs] = function() return function() pointer = pointer +10 end end
	})
		while true do
		if pointer == 1 then -- 5 [GETGLOBAL] 
 	Temp[1] = 1 -- instA
	Temp[2] = 0+1 -- instB
	Temp[3] = Constants[Temp[2]] -- constant
	Temp[4] = Env[Temp[3]] -- env global
	Stack[Temp[1]] = Temp[4] -- set to stack
	 
elseif pointer == 2 then -- 10 [NEWTABLE] 
 Temp[1] = 2
Temp[2] = {}
Stack[Temp[1]] = Temp[2]
 
elseif pointer == 3 then -- 4 [GETUPVAL] 
 Stack[3] = Upvalues[0] 
elseif pointer == 4 then -- 28 [CALL] 
 	Temp[1] = 1   -- instA
	Temp[2] = 3   -- instB
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
	
	 
elseif pointer == 5 then -- 9 [SETTABLE] 
 		Stack[1][Constants[1+1]] = Stack[0]
	 
elseif pointer == 6 then -- 30 [RETURN] 
         local output = {}
        local count = 0
        for i = 1, 1 + 2 - 2 do
            count = count + 1
            output[count] = Stack[i]
        end
        return unpack(output, 1, count)
     
elseif pointer == 7 then -- 30 [RETURN] 
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
 
elseif pointer == 23 then -- -1 [PSEUDO] 
 -- [PSEUDO] Handled by CLOSURE 
elseif pointer == 24 then -- 9 [SETTABLE] 
 		Stack[11][Constants[5+1]] = Stack[12]
	 
elseif pointer == 25 then -- 36 [CLOSURE] 
 	local prevStack = Stack
	local prevUpvalues = Upvalues
	
	Stack[12] = function(...) -- PROTOTYPE 3
		local Constants = {(decrypt("\066\074\092\088\070", "2856")),(decrypt("\068\009", "486")),}
		
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
		for i = 0 + 1, #Args do
            insert(Varargs, Args[i])
        end
		setmeta(Constants, {
		[__index] = function(Self, Key)
			local toSend = ConstantsCopy[Key]

			if byte(sub(toSend,#toSend,#toSend)) == 11 then
						local removedByte = sub(toSend,1,#toSend-1)
		return tonumber(removedByte)
		
			elseif byte(sub(toSend,#toSend,#toSend)) == 7 then -- Boolean support
				if byte(sub(toSend,1,1)) == 116 then
					return true
				else
					return false
				end
			elseif byte(sub(toSend,#toSend,#toSend)) == 7 then -- Boolean support
				if byte(sub(toSend,1,1)) == 116 then
					return true
				else
					return false
				end
			elseif byte(sub(toSend,#toSend,#toSend)) == 6 then -- nil support
				return nil
			end

			return ConstantsCopy[Key]
		end,
		[__metatable] = {},
		[__tostring] = function()
			pointer = pointer ^10
			return ttostring(pointer)
		end,
		[__call] = function(_,at)
					local const = ConstantsCopy[at]
		return const
		end,
		[__pairs] = function() return function() pointer = pointer +15 end end,
        [__ipairs] = function() return function() pointer = pointer +10 end end
	})
		while true do
		if pointer == 1 then -- 5 [GETGLOBAL] 
 	Temp[1] = 1 -- instA
	Temp[2] = 0+1 -- instB
	Temp[3] = Constants[Temp[2]] -- constant
	Temp[4] = Env[Temp[3]] -- env global
	Stack[Temp[1]] = Temp[4] -- set to stack
	 
elseif pointer == 2 then -- 6 [GETTABLE] 
 	Temp[1] = Constants[1+1]
	Stack[2] = Stack[0][Temp[1]]
	 
elseif pointer == 3 then -- 28 [CALL] 
 	Temp[1] = 1   -- instA
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
 
elseif pointer == 26 then -- 9 [SETTABLE] 
 		Stack[11][Constants[6+1]] = Stack[12]
	 
elseif pointer == 27 then -- 6 [GETTABLE] 
 	Temp[1] = Constants[5+1]
	Stack[12] = Stack[11][Temp[1]]
	 
elseif pointer == 28 then -- 1 [LOADK] 
 	Temp[1] = 13
	Temp[2] = 7+1
	Temp[3] = Constants[Temp[2]]
	Stack[Temp[1]] = Temp[3]
	 
elseif pointer == 29 then -- 28 [CALL] 
 	Temp[1] = 12   -- instA
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
	
		for i = Temp[1], Temp[1] + 2 - 2 do
		Stack[i] = Temp[4][i+1-Temp[1]]
	end
	Temp = {}
	
	 
elseif pointer == 30 then -- 11 [SELF] 
 local C = 6+1
Stack[13+1] = Stack[12]
if Stack[13+1] then
	Stack[13] = Stack[12][Constants[C]]
end
 
elseif pointer == 31 then -- 28 [CALL] 
 	Temp[1] = 13   -- instA
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
	
	 
elseif pointer == 32 then -- 1 [LOADK] 
 	Temp[1] = 13
	Temp[2] = 8+1
	Temp[3] = Constants[Temp[2]]
	Stack[Temp[1]] = Temp[3]
	 
elseif pointer == 33 then -- 1 [LOADK] 
 	Temp[1] = 14
	Temp[2] = 9+1
	Temp[3] = Constants[Temp[2]]
	Stack[Temp[1]] = Temp[3]
	 
elseif pointer == 34 then -- 12 [ADD] 
 	Stack[15] = (false and Constants[13+1] or Stack[13]) + (false and Constants[14+1] or Stack[14])
	 
elseif pointer == 35 then -- 1 [LOADK] 
 	Temp[1] = 16
	Temp[2] = 9+1
	Temp[3] = Constants[Temp[2]]
	Stack[Temp[1]] = Temp[3]
	 
elseif pointer == 36 then -- 14 [MUL] 
 	Stack[17] = (false and Constants[13+1] or Stack[13]) * (true and Constants[9+1] or Stack[9])
	 
elseif pointer == 37 then -- 15 [DIV] 
 	Stack[18] = (true and Constants[8+1] or Stack[8]) / (false and Constants[14+1] or Stack[14])
	 
elseif pointer == 38 then -- 16 [MOD] 
 	Stack[19] = (false and Constants[13+1] or Stack[13]) % (false and Constants[14+1] or Stack[14])
	 
elseif pointer == 39 then -- 1 [LOADK] 
 	Temp[1] = 20
	Temp[2] = 10+1
	Temp[3] = Constants[Temp[2]]
	Stack[Temp[1]] = Temp[3]
	 
elseif pointer == 40 then -- 0 [MOVE] 
 	Temp[1] = 21
	Temp[2] = 0
	Temp[3] = Stack
	Temp[4] = Temp[3][Temp[2]]
	Temp[3][Temp[1]] = Temp[4]
 
elseif pointer == 41 then -- 0 [MOVE] 
 	Temp[1] = 22
	Temp[2] = 15
	Temp[3] = Stack
	Temp[4] = Temp[3][Temp[2]]
	Temp[3][Temp[1]] = Temp[4]
 
elseif pointer == 42 then -- 0 [MOVE] 
 	Temp[1] = 23
	Temp[2] = 16
	Temp[3] = Stack
	Temp[4] = Temp[3][Temp[2]]
	Temp[3][Temp[1]] = Temp[4]
 
elseif pointer == 43 then -- 0 [MOVE] 
 	Temp[1] = 24
	Temp[2] = 17
	Temp[3] = Stack
	Temp[4] = Temp[3][Temp[2]]
	Temp[3][Temp[1]] = Temp[4]
 
elseif pointer == 44 then -- 0 [MOVE] 
 	Temp[1] = 25
	Temp[2] = 18
	Temp[3] = Stack
	Temp[4] = Temp[3][Temp[2]]
	Temp[3][Temp[1]] = Temp[4]
 
elseif pointer == 45 then -- 0 [MOVE] 
 	Temp[1] = 26
	Temp[2] = 19
	Temp[3] = Stack
	Temp[4] = Temp[3][Temp[2]]
	Temp[3][Temp[1]] = Temp[4]
 
elseif pointer == 46 then -- 0 [MOVE] 
 	Temp[1] = 27
	Temp[2] = 20
	Temp[3] = Stack
	Temp[4] = Temp[3][Temp[2]]
	Temp[3][Temp[1]] = Temp[4]
 
elseif pointer == 47 then -- 28 [CALL] 
 	Temp[1] = 21   -- instA
	Temp[2] = 7   -- instB
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
	
	 
elseif pointer == 48 then -- 24 [LT] 
 		if (Stack[16] < Stack[15]) then
			pointer = pointer + 1
		end
	 
elseif pointer == 49 then -- 22 [JMP] 
 pointer = pointer + 4 print('[VM]:','JMP -- >',pointer) 
elseif pointer == 50 then -- 0 [MOVE] 
 	Temp[1] = 21
	Temp[2] = 0
	Temp[3] = Stack
	Temp[4] = Temp[3][Temp[2]]
	Temp[3][Temp[1]] = Temp[4]
 
elseif pointer == 51 then -- 5 [GETGLOBAL] 
 	Temp[1] = 22 -- instA
	Temp[2] = 3+1 -- instB
	Temp[3] = Constants[Temp[2]] -- constant
	Temp[4] = Env[Temp[3]] -- env global
	Stack[Temp[1]] = Temp[4] -- set to stack
	 
elseif pointer == 52 then -- 28 [CALL] 
 	Temp[1] = 21   -- instA
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
	
	 
elseif pointer == 53 then -- 22 [JMP] 
 pointer = pointer + 11 print('[VM]:','JMP -- >',pointer) 
elseif pointer == 54 then -- 25 [LE] 
 		if (Stack[18] <= Stack[17]) then
			pointer = pointer + 1
		end
	 
elseif pointer == 55 then -- 22 [JMP] 
 pointer = pointer + 4 print('[VM]:','JMP -- >',pointer) 
elseif pointer == 56 then -- 0 [MOVE] 
 	Temp[1] = 21
	Temp[2] = 0
	Temp[3] = Stack
	Temp[4] = Temp[3][Temp[2]]
	Temp[3][Temp[1]] = Temp[4]
 
elseif pointer == 57 then -- 0 [MOVE] 
 	Temp[1] = 22
	Temp[2] = 18
	Temp[3] = Stack
	Temp[4] = Temp[3][Temp[2]]
	Temp[3][Temp[1]] = Temp[4]
 
elseif pointer == 58 then -- 28 [CALL] 
 	Temp[1] = 21   -- instA
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
	
	 
elseif pointer == 59 then -- 22 [JMP] 
 pointer = pointer + 5 print('[VM]:','JMP -- >',pointer) 
elseif pointer == 60 then -- 23 [EQ] 
 		if (Stack[19] == Stack[20]) then
			pointer = pointer + 1
		end
	 
elseif pointer == 61 then -- 22 [JMP] 
 pointer = pointer + 3 print('[VM]:','JMP -- >',pointer) 
elseif pointer == 62 then -- 0 [MOVE] 
 	Temp[1] = 21
	Temp[2] = 0
	Temp[3] = Stack
	Temp[4] = Temp[3][Temp[2]]
	Temp[3][Temp[1]] = Temp[4]
 
elseif pointer == 63 then -- 0 [MOVE] 
 	Temp[1] = 22
	Temp[2] = 20
	Temp[3] = Stack
	Temp[4] = Temp[3][Temp[2]]
	Temp[3][Temp[1]] = Temp[4]
 
elseif pointer == 64 then -- 28 [CALL] 
 	Temp[1] = 21   -- instA
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
	
	 
elseif pointer == 65 then -- 36 [CLOSURE] 
 	local prevStack = Stack
	local prevUpvalues = Upvalues
	
	Stack[21] = function(...) -- PROTOTYPE 4
		local Constants = {(decrypt("\003\004\062", "1657")),(decrypt("\006\006\059", "2207")),(decrypt("\001\007\061", "2064")),}
		
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
		local Map = {[0] = {0, 10}}
		
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
		for i = 0 + 1, #Args do
            insert(Varargs, Args[i])
        end
		setmeta(Constants, {
		[__index] = function(Self, Key)
			local toSend = ConstantsCopy[Key]

			if byte(sub(toSend,#toSend,#toSend)) == 11 then
						local removedByte = sub(toSend,1,#toSend-1)
		return tonumber(removedByte)
		
			elseif byte(sub(toSend,#toSend,#toSend)) == 7 then -- Boolean support
				if byte(sub(toSend,1,1)) == 116 then
					return true
				else
					return false
				end
			elseif byte(sub(toSend,#toSend,#toSend)) == 7 then -- Boolean support
				if byte(sub(toSend,1,1)) == 116 then
					return true
				else
					return false
				end
			elseif byte(sub(toSend,#toSend,#toSend)) == 6 then -- nil support
				return nil
			end

			return ConstantsCopy[Key]
		end,
		[__metatable] = {},
		[__tostring] = function()
			pointer = pointer ^10
			return ttostring(pointer)
		end,
		[__call] = function(_,at)
					local const = ConstantsCopy[at]
		return const
		end,
		[__pairs] = function() return function() pointer = pointer +15 end end,
        [__ipairs] = function() return function() pointer = pointer +10 end end
	})
		while true do
		if pointer == 1 then -- 4 [GETUPVAL] 
 Stack[0] = Upvalues[0] 
elseif pointer == 2 then -- 1 [LOADK] 
 	Temp[1] = 1
	Temp[2] = 0+1
	Temp[3] = Constants[Temp[2]]
	Stack[Temp[1]] = Temp[3]
	 
elseif pointer == 3 then -- 1 [LOADK] 
 	Temp[1] = 2
	Temp[2] = 1+1
	Temp[3] = Constants[Temp[2]]
	Stack[Temp[1]] = Temp[3]
	 
elseif pointer == 4 then -- 1 [LOADK] 
 	Temp[1] = 3
	Temp[2] = 2+1
	Temp[3] = Constants[Temp[2]]
	Stack[Temp[1]] = Temp[3]
	 
elseif pointer == 5 then -- 29 [TAILCALL] 
     Temp[1] = 0   -- Function Register
    Temp[2] = 4   -- Argument Count (0 = Variable)
    Temp[3] = {}    -- Arguments Table
    
    local limit = 0
    
    if Temp[2] == 0 then
        limit = top
    else
        limit = Temp[1] + Temp[2] - 1
    end

    for i = Temp[1] + 1, limit do
        insert(Temp[3], Stack[i])
    end

    return Stack[Temp[1]](unpack(Temp[3]))
 
elseif pointer == 6 then -- 30 [RETURN] 
             local output = {}
            local count = 0
            for i = 0, top do
                count = count + 1
                output[count] = Stack[i]
            end
            return unpack(output, 1, count)
         
elseif pointer == 7 then -- 30 [RETURN] 
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
 
elseif pointer == 66 then -- -1 [PSEUDO] 
 -- [PSEUDO] Handled by CLOSURE 
elseif pointer == 67 then -- 18 [UNM] 
 Stack[15] = -Stack[15] 
elseif pointer == 68 then -- 19 [NOT] 
 Stack[2] = not Stack[2] 
elseif pointer == 69 then -- 0 [MOVE] 
 	Temp[1] = 22
	Temp[2] = 0
	Temp[3] = Stack
	Temp[4] = Temp[3][Temp[2]]
	Temp[3][Temp[1]] = Temp[4]
 
elseif pointer == 70 then -- 0 [MOVE] 
 	Temp[1] = 23
	Temp[2] = 15
	Temp[3] = Stack
	Temp[4] = Temp[3][Temp[2]]
	Temp[3][Temp[1]] = Temp[4]
 
elseif pointer == 71 then -- 0 [MOVE] 
 	Temp[1] = 24
	Temp[2] = 2
	Temp[3] = Stack
	Temp[4] = Temp[3][Temp[2]]
	Temp[3][Temp[1]] = Temp[4]
 
elseif pointer == 72 then -- 0 [MOVE] 
 	Temp[1] = 25
	Temp[2] = 21
	Temp[3] = Stack
	Temp[4] = Temp[3][Temp[2]]
	Temp[3][Temp[1]] = Temp[4]
 
elseif pointer == 73 then -- 28 [CALL] 
 	Temp[1] = 22   -- instA
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
	
	 
elseif pointer == 74 then -- 26 [TEST] 
 	if  Stack[2] then
		pointer = pointer + 1
		print('[VM]:','JMP -- > ',pointer)
	end 
elseif pointer == 75 then -- 22 [JMP] 
 pointer = pointer + 1 print('[VM]:','JMP -- >',pointer) 
elseif pointer == 76 then -- 0 [MOVE] 
 	Temp[1] = 2
	Temp[2] = 15
	Temp[3] = Stack
	Temp[4] = Temp[3][Temp[2]]
	Temp[3][Temp[1]] = Temp[4]
 
elseif pointer == 77 then -- 26 [TEST] 
 	if  Stack[2] then
		pointer = pointer + 1
		print('[VM]:','JMP -- > ',pointer)
	end 
elseif pointer == 78 then -- 22 [JMP] 
 pointer = pointer + 2 print('[VM]:','JMP -- >',pointer) 
elseif pointer == 79 then -- 27 [TESTSET] 
 if (not Stack[15]) == (1 ~= 0) then
	pointer = pointer + 1
else
	Stack[22] = Stack[15]
end
 
elseif pointer == 80 then -- 22 [JMP] 
 pointer = pointer + 1 print('[VM]:','JMP -- >',pointer) 
elseif pointer == 81 then -- 0 [MOVE] 
 	Temp[1] = 22
	Temp[2] = 16
	Temp[3] = Stack
	Temp[4] = Temp[3][Temp[2]]
	Temp[3][Temp[1]] = Temp[4]
 
elseif pointer == 82 then -- 1 [LOADK] 
 	Temp[1] = 23
	Temp[2] = 11+1
	Temp[3] = Constants[Temp[2]]
	Stack[Temp[1]] = Temp[3]
	 
elseif pointer == 83 then -- 0 [MOVE] 
 	Temp[1] = 24
	Temp[2] = 1
	Temp[3] = Stack
	Temp[4] = Temp[3][Temp[2]]
	Temp[3][Temp[1]] = Temp[4]
 
elseif pointer == 84 then -- 1 [LOADK] 
 	Temp[1] = 25
	Temp[2] = 12+1
	Temp[3] = Constants[Temp[2]]
	Stack[Temp[1]] = Temp[3]
	 
elseif pointer == 85 then -- 21 [CONCAT] 
 local output = ""

for i=23,25 do
	output = output..Stack[i]
end

Stack[23] = output 
elseif pointer == 86 then -- 0 [MOVE] 
 	Temp[1] = 24
	Temp[2] = 21
	Temp[3] = Stack
	Temp[4] = Temp[3][Temp[2]]
	Temp[3][Temp[1]] = Temp[4]
 
elseif pointer == 87 then -- 28 [CALL] 
 	Temp[1] = 24   -- instA
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
	
		for i = Temp[1], Temp[1] + 4 - 2 do
		Stack[i] = Temp[4][i+1-Temp[1]]
	end
	Temp = {}
	
	 
elseif pointer == 88 then -- 0 [MOVE] 
 	Temp[1] = 27
	Temp[2] = 0
	Temp[3] = Stack
	Temp[4] = Temp[3][Temp[2]]
	Temp[3][Temp[1]] = Temp[4]
 
elseif pointer == 89 then -- 0 [MOVE] 
 	Temp[1] = 28
	Temp[2] = 2
	Temp[3] = Stack
	Temp[4] = Temp[3][Temp[2]]
	Temp[3][Temp[1]] = Temp[4]
 
elseif pointer == 90 then -- 0 [MOVE] 
 	Temp[1] = 29
	Temp[2] = 22
	Temp[3] = Stack
	Temp[4] = Temp[3][Temp[2]]
	Temp[3][Temp[1]] = Temp[4]
 
elseif pointer == 91 then -- 0 [MOVE] 
 	Temp[1] = 30
	Temp[2] = 23
	Temp[3] = Stack
	Temp[4] = Temp[3][Temp[2]]
	Temp[3][Temp[1]] = Temp[4]
 
elseif pointer == 92 then -- 0 [MOVE] 
 	Temp[1] = 31
	Temp[2] = 24
	Temp[3] = Stack
	Temp[4] = Temp[3][Temp[2]]
	Temp[3][Temp[1]] = Temp[4]
 
elseif pointer == 93 then -- 0 [MOVE] 
 	Temp[1] = 32
	Temp[2] = 25
	Temp[3] = Stack
	Temp[4] = Temp[3][Temp[2]]
	Temp[3][Temp[1]] = Temp[4]
 
elseif pointer == 94 then -- 0 [MOVE] 
 	Temp[1] = 33
	Temp[2] = 26
	Temp[3] = Stack
	Temp[4] = Temp[3][Temp[2]]
	Temp[3][Temp[1]] = Temp[4]
 
elseif pointer == 95 then -- 28 [CALL] 
 	Temp[1] = 27   -- instA
	Temp[2] = 7   -- instB
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
	
	 
elseif pointer == 96 then -- 1 [LOADK] 
 	Temp[1] = 27
	Temp[2] = 13+1
	Temp[3] = Constants[Temp[2]]
	Stack[Temp[1]] = Temp[3]
	 
elseif pointer == 97 then -- 1 [LOADK] 
 	Temp[1] = 28
	Temp[2] = 14+1
	Temp[3] = Constants[Temp[2]]
	Stack[Temp[1]] = Temp[3]
	 
elseif pointer == 98 then -- 1 [LOADK] 
 	Temp[1] = 29
	Temp[2] = 13+1
	Temp[3] = Constants[Temp[2]]
	Stack[Temp[1]] = Temp[3]
	 
elseif pointer == 99 then -- 32 [FORPREP] 
 	Temp[1] = 27
	Temp[2] = 1

	local Init = tonumber(Stack[Temp[1]])
	local Limit = tonumber(Stack[Temp[1] + 1])
	local Step = tonumber(Stack[Temp[1] + 2])

	Stack[Temp[1]] = Init - Step
	Stack[Temp[1] + 1] = Limit
	Stack[Temp[1] + 2] = Step

	pointer = pointer + Temp[2]

	 
elseif pointer == 100 then -- 12 [ADD] 
 	Stack[15] = (false and Constants[15+1] or Stack[15]) + (false and Constants[25+1] or Stack[25])
	 
elseif pointer == 101 then -- 31 [FORLOOP] 
 	

	Temp[1] = 27
	Temp[2] = -2

	local Step = Stack[Temp[1] + 2]
	local Limit = Stack[Temp[1] + 1]
	local Index = Stack[Temp[1]] + Step

	Stack[Temp[1]] = Index
	
	if (Step > 0 and Index <= Limit) or (Step <= 0 and Index >= Limit) then
	    pointer = pointer + Temp[2] 
	    Stack[Temp[1] + 3] = Index 
	end


	 
elseif pointer == 102 then -- 0 [MOVE] 
 	Temp[1] = 27
	Temp[2] = 10
	Temp[3] = Stack
	Temp[4] = Temp[3][Temp[2]]
	Temp[3][Temp[1]] = Temp[4]
 
elseif pointer == 103 then -- 1 [LOADK] 
 	Temp[1] = 28
	Temp[2] = 15+1
	Temp[3] = Constants[Temp[2]]
	Stack[Temp[1]] = Temp[3]
	 
elseif pointer == 104 then -- 1 [LOADK] 
 	Temp[1] = 29
	Temp[2] = 14+1
	Temp[3] = Constants[Temp[2]]
	Stack[Temp[1]] = Temp[3]
	 
elseif pointer == 105 then -- 1 [LOADK] 
 	Temp[1] = 30
	Temp[2] = 16+1
	Temp[3] = Constants[Temp[2]]
	Stack[Temp[1]] = Temp[3]
	 
elseif pointer == 106 then -- 1 [LOADK] 
 	Temp[1] = 31
	Temp[2] = 17+1
	Temp[3] = Constants[Temp[2]]
	Stack[Temp[1]] = Temp[3]
	 
elseif pointer == 107 then -- 28 [CALL] 
 	Temp[1] = 27   -- instA
	Temp[2] = 5   -- instB
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
	
		for i = Temp[1], Temp[1] + 4 - 2 do
		Stack[i] = Temp[4][i+1-Temp[1]]
	end
	Temp = {}
	
	 
elseif pointer == 108 then -- 20 [LEN] 
 Stack[30] = #Stack[27] 
elseif pointer == 109 then -- 0 [MOVE] 
 	Temp[1] = 31
	Temp[2] = 0
	Temp[3] = Stack
	Temp[4] = Temp[3][Temp[2]]
	Temp[3][Temp[1]] = Temp[4]
 
elseif pointer == 110 then -- 0 [MOVE] 
 	Temp[1] = 32
	Temp[2] = 15
	Temp[3] = Stack
	Temp[4] = Temp[3][Temp[2]]
	Temp[3][Temp[1]] = Temp[4]
 
elseif pointer == 111 then -- 0 [MOVE] 
 	Temp[1] = 33
	Temp[2] = 27
	Temp[3] = Stack
	Temp[4] = Temp[3][Temp[2]]
	Temp[3][Temp[1]] = Temp[4]
 
elseif pointer == 112 then -- 0 [MOVE] 
 	Temp[1] = 34
	Temp[2] = 28
	Temp[3] = Stack
	Temp[4] = Temp[3][Temp[2]]
	Temp[3][Temp[1]] = Temp[4]
 
elseif pointer == 113 then -- 0 [MOVE] 
 	Temp[1] = 35
	Temp[2] = 29
	Temp[3] = Stack
	Temp[4] = Temp[3][Temp[2]]
	Temp[3][Temp[1]] = Temp[4]
 
elseif pointer == 114 then -- 0 [MOVE] 
 	Temp[1] = 36
	Temp[2] = 30
	Temp[3] = Stack
	Temp[4] = Temp[3][Temp[2]]
	Temp[3][Temp[1]] = Temp[4]
 
elseif pointer == 115 then -- 0 [MOVE] 
 	Temp[1] = 37
	Temp[2] = 10
	Temp[3] = Stack
	Temp[4] = Temp[3][Temp[2]]
	Temp[3][Temp[1]] = Temp[4]
 
elseif pointer == 116 then -- 0 [MOVE] 
 	Temp[1] = 38
	Temp[2] = 9
	Temp[3] = Stack
	Temp[4] = Temp[3][Temp[2]]
	Temp[3][Temp[1]] = Temp[4]
 
elseif pointer == 117 then -- 28 [CALL] 
 	Temp[1] = 31   -- instA
	Temp[2] = 8   -- instB
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
	
	 
elseif pointer == 118 then -- 30 [RETURN] 
         local output = {}
        local count = 0
        for i = 0, 0 + 1 - 2 do
            count = count + 1
            output[count] = Stack[i]
        end
        return unpack(output, 1, count)
     
end
		pointer=pointer+1
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