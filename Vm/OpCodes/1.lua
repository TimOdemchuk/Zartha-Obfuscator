-- LOADK
return function(inst,shift,const,settings)
	local output = [=[
	Stack[:A:] = Constants[:B:+1]
	]=]

	return output
end

--[[
		-- [ENCRYPT CONSTANTS]
		local decoded = {}
		local Constant = Constants[:B:+1]
		
		for i =1,#Constant do
			insert(decoded,char(byte(sub(Constant,i,i))-%s)) 
		end
		
		Stack[:A:] = concat(decoded)
		---------------------------------
		-- [NORMAL]
		Stack[:A:] = Constants[:B:+1]
]]