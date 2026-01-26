--// RETURN:

return function(instruction,shiftAmount,constant,settings)
	local output = [=[
	local output = {}

	for i=:A:,:A:+:B:-2 do
		insert(output,Stack[i])
	end

	return unpack(output)
	]=]
	
	local reg_b = _G.getReg(instruction,"B")
	
	if reg_b == 0 then -- fix for vararg
		return [[
            local output = {}
            for i = :A:, top do
                insert(output, Stack[i])
            end
            return unpack(output)
        ]]
	end
	
	return output
end