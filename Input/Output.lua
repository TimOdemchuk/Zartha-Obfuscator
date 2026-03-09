return (("File generated using [Zartha]") and (function() return(function(Env,Constants,shiftKey,decrypt) -- Vars
local char,byte,sub,ttostring,pcall,unpack,concat,tonumber,setmeta,__metatable,__index,proxy,pnt,Constants,pairs,__newindex,next,dot,gsub,stringv,find,tfind = Env["string"]["char"],Env["string"]["byte"],Env["string"]["sub"],Env["tostring"],Env["pcall"],Env["table"]["unpack"] or Env["unpack"],Env["table"]["concat"],Env["tonumber"],Env["setmetatable"],"__metatable","__index",Env["newproxy"],Env["print"],{(decrypt("\097\089\104\102\080\043\084\083\108\105\093\088\081", "1759")),(decrypt("\105\127\010\112\099\123\011\015\098\117\116", "2442")),((decrypt("\003\007", "1758"))),(decrypt("\086\086\091\094\089", "2736")),(decrypt("\097\087\089\083\090\067\064", "1202")),(decrypt("\094\089\084\092\066", "2716")),((decrypt("\002", "2659"))),},Env["pairs"],"__newindex",Env["next"],".",Env["string"]["gsub"],"string",Env["string"]["find"],function(targetTable, value)
	for i,v in pairs(targetTable) do
		if v == value then
			return i
		end
	end
	
	return nil
end


		-- VM function
		return (function()
			local Stack = {}
			local Temp = {}
			local Upvalues = {}
			local ConstantsCache = {}
			local ProtosConstants = {}
			local vmEnv = {}
			local pointer = 1
			local top = 0
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
				for i, v in pairs(Constants) do
					v = gsub(v, dot, function(bb)
						if tfind({11,4,7,6},byte(bb)) then
							return bb 
						end
						return char(byte(bb) +4) 
					end)
					ConstantsCache[i] = (function(toSend)
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

			local C = ConstantsCache

			-- VM STARTS HERE
			while true do
				if pointer == 1 then -- 2 [LOADBOOL] 
 	Stack[0] = true 
elseif pointer == 2 then -- 7 [SETGLOBAL] 
 	vmEnv[C[2]] = Stack[0] 
elseif pointer == 3 then -- 5 [GETGLOBAL] 
 	Stack[0] = vmEnv[C[6]] or Env[C[6]] 
elseif pointer == 4 then -- 1 [LOADK] 
 	Stack[1] = C[4] 
elseif pointer == 5 then -- 28 [CALL] 
 	Stack[0](Stack[1]) 
elseif pointer == 6 then -- 30 [RETURN] 
 	return 
end
				pointer = pointer + 1
			end
		end)()

 end)((_ENV or getfenv()),{},0,function(str, key) -- Decrypt vars
	local result = {}
	local keyLen = #key
	local n = 0
	for i = 1, #str do
		n = n + 1
		result[n] = string.char((function(a, b) 
	local r, p = 0, 1
	for _ = 1, 8 do
		if a % 2 ~= b % 2 then r = r + p end
		a, b, p = (a - a % 2) / 2, (b - b % 2) / 2, p * 2
	end
	return r
end)(string.byte(str, i), string.byte(key, (i - 1) % keyLen + 1)))
	end
	return table.concat(result)
end
) end)())