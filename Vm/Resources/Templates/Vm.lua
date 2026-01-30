-- Vm Template
return [=[
%s
%s
		-- Constants
		local function processConstant(toSend)
			local len = #toSend
			local lastByte = byte(toSend, len)
			if lastByte == 11 then
				%s
			elseif lastByte == 4 then
				local removedByte = sub(toSend, 1, len - 1)
				local decrypted = {}
				local n = 0
				for i = 1, #removedByte do
					n = n + 1
					decrypted[n] = char(byte(removedByte, i) - :SHIFTAMOUNT:)
				end
				return concat(decrypted)
			elseif lastByte == 7 then
				return byte(toSend, 1) == 116
			elseif lastByte == 6 then
				return nil
			end
			return toSend
		end

		local ConstantsCache = {}
		for i, v in pairs(Constants) do
			ConstantsCache[i] = processConstant(v)
		end

		-- VM function
		return (function()%s
			local Stack = {}
			local Temp = {}
			local Upvalues = {}
			local pointer = 1
			local top = 0
			local Checks = :INSERTENVLOG:

			local C = ConstantsCache

			-- VM STARTS HERE
			while true do
				%s
				%s
			end
		end)()

]=]