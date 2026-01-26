-- JMP
local settingsGot = require("input.Settings")

return function(inst,shiftAmount,constant,settings)
	local output = ("pointer = pointer + :B: %s"):format(settings.Debug and "print('[VM]:','JMP -- >',pointer)" or "")
	
	if settingsGot.LuaU_Syntax then
		output = ("pointer += :B:-1 %s"):format(settings.Debug and "print('[VM]:','JMP -- >',pointer)" or "")
	end
	
	return output
end

