-- GETGLOBAL
local settingsGot = require("input.Settings")

return function(inst,shift,constant,settings)
	local output = [=[
	Temp[1] = :A: -- instA
	Temp[2] = :B:+1 -- instB
	Temp[3] = Constants[Temp[2]] -- constant
	Temp[4] = Env[Temp[3]] -- env global
	Stack[Temp[1]] = Temp[4] -- set to stack
	]=]
	
	if settingsGot.ConstantProtection then
		output = ([=[
		local decoded = {}
		local Constant = Constants(:B:+1)
		
		for i =1,#Constant do
			insert(decoded,char(byte(sub(Constant,i,i))-%s)) 
		end
		
		Stack[:A:] = Env
		Stack[:A:] = Stack[:A:][concat(decoded)]
		]=]):format((settingsGot.AntiTamper and "shiftKey" or shift))
	end
	
	return output
end