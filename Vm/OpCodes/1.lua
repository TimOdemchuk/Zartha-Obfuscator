-- LOADK
return function(inst,shift,const,settings)
	local output = [=[
	Temp[1] = :A:
	Temp[2] = :B:+1
	Temp[3] = Constants[Temp[2]]
	Stack[Temp[1]] = Temp[3]
	]=]
	
	if settings.ConstantProtection and not const then
		output = ([=[
		Temp[1] = :A:
		Temp[2] = :B:+1
		Temp[3] = {}
		Temp[4]  = Constants(Temp[2])
		for i =1,#Temp[4]  do
			insert(Temp[3],char(byte(sub(Temp[4],i,i))-%s)) 
		end
		Temp[5] = concat(Temp[3])
		Stack[Temp[1]] = Temp[5]
		]=]):format((settings.AntiTamper and "shiftKey" or shift))
	elseif settings.ConstantProtection and const then
		output = ([=[
		Temp[1] = :A:
		Temp[2] = :B:+1
		Temp[3] = {}
		Temp[4]  = Constants(Temp[2])
		Stack[Temp[1]] = Temp[4]
		]=])
	end
	
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