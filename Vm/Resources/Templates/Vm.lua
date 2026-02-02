-- Vm Template
return [=[
%s
%s
		-- VM function
		return (function()%s
			local ConstantsCache = {}
			local Stack = {}
			local Temp = {}
			local Upvalues = {}
			local pointer = 1
			local top = 0
			local Checks,ConstantsFunc = :INSERTENVLOG:,(function() -- Constants decode
				for i, v in pairs(Constants) do
					v = gsub(v, dot, function(bb) 
						return char(byte(bb) +:CONSTANT_SHIFTER:) 
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

			local C = ConstantsCache -- Constant table

			-- VM STARTS HERE
			while true do
				%s
				%s
			end
		end)()

]=]