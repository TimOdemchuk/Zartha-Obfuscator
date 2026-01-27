return (("File generated using [Zartha]") and (function() return(function(Env,Constants,shiftKey,decrypt) -- Vars
local char,insert,byte,sub,match,freeze,ttostring,pcall,unpack,concat,tonumber,setmeta,__metatable,__tostring,__index,__call,proxy,pnt,__pairs,__ipairs,Constants,pairs,__newindex = Env["string"]["char"],Env["table"]["insert"],Env["string"]["byte"],Env["string"]["sub"],Env["string"]["match"],Env["table"]["freeze"],Env["tostring"],Env["pcall"],Env["table"]["unpack"],Env["table"]["concat"],Env["tonumber"],Env["setmetatable"],"__metatable","__tostring","__index","__call",Env["newproxy"],Env["print"],"__pairs","__ipairs",{},Env["pairs"],"__newindex"


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
		if pointer == 1 then -- 30 [RETURN] 
 	local output = {}

	for i=0,0+1-2 do
		insert(output,Stack[i])
	end

	return unpack(output)
	 
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