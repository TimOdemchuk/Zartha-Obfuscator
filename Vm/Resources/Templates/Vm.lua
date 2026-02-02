-- Vm Template
return [=[
%s
%s
		-- VM function
		return (function()
			local Stack = {}
			local Temp = {}
			local Upvalues = {}
			local ConstantsCache = {}
			local pointer = 1
			local top = 0
			local Checks,ConstantsDecode = :INSERTENVLOG:,(function() -- Constants decode
				for i, v in pairs(Constants) do
					v = gsub(v, dot, function(bb)
						if table.find({11,4,7,6},byte(bb)) then
							return bb 
						end
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

			local C = ConstantsCache

			-- VM STARTS HERE
			while true do
				%s
				%s
			end
		end)()

]=]