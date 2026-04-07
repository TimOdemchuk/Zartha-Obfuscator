return (("File generated using [Zartha]") and (function() return(function(Env,Constants,shiftKey,decrypt) -- Vars
local char,byte,sub,ttostring,pcall,unpack,concat,tonumber,setmeta,__metatable,__index,proxy,pnt,EncryptedConstants,pairs,__newindex,next,dot,gsub,stringv,find,tfind,bxor = Env["string"]["char"],Env["string"]["byte"],Env["string"]["sub"],Env["tostring"],Env["pcall"],Env["table"]["unpack"] or Env["unpack"],Env["table"]["concat"],Env["tonumber"],Env["setmetatable"],"__metatable","__index",Env["newproxy"],Env["print"],{(decrypt("\092\087\095\094\064", "1895")),((decrypt("\005\000\002\006\000", "620"))),(decrypt("\100", "2245")),(decrypt("\111\120\014\112\102\097\115\010\096\113\117", "341")),(decrypt("\105\104\084", "774")),(decrypt("\098\072\105\080\090\036\070\095\108\089\085", "2970")),(decrypt("\084\083\095\095\093", "1166")),},Env["pairs"],"__newindex",Env["next"],".",Env["string"]["gsub"],"string",Env["string"]["find"],Env["table"]["find"] or function(targetTable, value)
	for i,v in pairs(targetTable) do
		if v == value then
			return i
		end
	end
	
	return nil
end,Env["bit32"] and Env["bit32"]["bxor"] or function(a, b)
		local r, p = 0, 1
		for _ = 1, 8 do
			if a % 2 ~= b % 2 then r = r + p end
			a, b, p = (a - a % 2) / 2, (b - b % 2) / 2, p * 2
		end
		return r
	end

		-- VM function
		return (function()
			local Stack,Temp,Upvalues,Constants,ProtosConstants,vmEnv,pointer,top = {},{},{},{},{},{},1,0

			local Checks,ConstantsDecode = (function() -- Env log detection
	local function ooptest(...)
		local a = true and #{ -- troll
			...
		}
		return a
	end
	local _, err = pcall(function() 
		Env[__newindex](1) 
	end)
	local Tamper = false
	Env[__index] = function() 
		Tamper = true
	end
	if find(err,stringv) then
		pointer = 5^5
	end
	Env[4] = 11
	
	if Tamper then
		pointer = 10^5
	else
		local Checked = nil
		local _,er = pcall(function()
			Checked = (proxy(pnt)) 
		end)
		if Checked then
			pointer = 50^5
		else
			pointer = 1^5
		end
	end
	local counter = ooptest(1, 2, 3)
	
	if counter <2 then
		pointer = 5^5
	end
end)()
,(function() -- Constants decode
				for i, v in pairs(EncryptedConstants) do
					v = gsub(v, dot, function(bb)
						if tfind({11,4,7,6},byte(bb)) then
							return bb 
						end
						return char(byte(bb) +3) 
					end)
					Constants[i] = (function(toSend)
						local len = #toSend
						local lastByte = byte(toSend, len)
						if lastByte == 11 then
							return tonumber(sub(toSend, pointer, len - pointer))
						elseif lastByte == 4 then
							local removedByte = sub(toSend, pointer, len - pointer)
							local decrypted = {}
							local n = 0
							for i = 1, #removedByte do
								n = n + 1
								decrypted[n] = char(byte(removedByte, i) - 0)
							end
							return concat(decrypted)
						elseif lastByte == 7 then
							return byte(toSend, 1) == 116
						elseif lastByte == 6 then
							return nil
						end
						return toSend
					end)(v)
				end
			end)()

			-- VM STARTS HERE
			while true do
				if pointer == 1 then -- 2 [LOADBOOL] 
 Temp[1] = 0
Temp[2] = ttostring ~= __metatable
Stack[Temp[1]] = Temp[3] 
elseif pointer == 2 then -- 7 [SETGLOBAL] 
 Temp[1] = vmEnv
Temp[2] = 4
Temp[3] = Constants[Temp[2]]
Temp[4] = 0
Temp[1][Temp[3]] = Temp[3] 
elseif pointer == 3 then -- 1 [LOADK] 
 Temp[1] = 0
Temp[2] = Constants
Temp[3] = 7
Stack[Temp[1]] = Temp[2][Temp[3]] 
elseif pointer == 4 then -- 7 [SETGLOBAL] 
 Temp[1] = vmEnv
Temp[2] = 5
Temp[3] = Constants[Temp[2]]
Temp[4] = 0
Temp[1][Temp[3]] = Temp[3] 
elseif pointer == 5 then -- 1 [LOADK] 
 Temp[1] = 0
Temp[2] = Constants
Temp[3] = 5
Stack[Temp[1]] = Temp[2][Temp[3]] 
elseif pointer == 6 then -- 7 [SETGLOBAL] 
 Temp[1] = vmEnv
Temp[2] = 5
Temp[3] = Constants[Temp[2]]
Temp[4] = 0
Temp[1][Temp[3]] = Temp[3] 
elseif pointer == 7 then -- 5 [GETGLOBAL] 
 Temp[1] = 0
Temp[2] = 1
Temp[3] = Constants[Temp[2]]
Stack[Temp[1]] = vmEnv[Temp[3]] or Env[Temp[3]] 
elseif pointer == 8 then -- 5 [GETGLOBAL] 
 Temp[1] = 1
Temp[2] = 5
Temp[3] = Constants[Temp[2]]
Stack[Temp[1]] = vmEnv[Temp[3]] or Env[Temp[3]] 
elseif pointer == 9 then -- 28 [CALL] 
 	Stack[0](Stack[1]) 
elseif pointer == 10 then -- 30 [RETURN] 
 	return 
end
				pointer = pointer + 1
			end
		end)()

 end)((_ENV or getfenv()),{},0,function(str, key) -- Decrypt vars
	local result = {}
	local keyLen = #key
	local sbyte = string.byte
	local schar = string.char
	local bxor = bit32 and bit32.bxor or function(a, b)
		local r, p = 0, 1
		for _ = 1, 8 do
			if a % 2 ~= b % 2 then r = r + p end
			a, b, p = (a - a % 2) / 2, (b - b % 2) / 2, p * 2
		end
		return r
	end
	for i = 1, #str do
		result[i] = schar(bxor(sbyte(str, i), sbyte(key, (i - 1) % keyLen + 1)))
	end
	return table.concat(result)
end
) end)())