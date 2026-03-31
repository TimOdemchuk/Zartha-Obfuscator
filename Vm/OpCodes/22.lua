-- JMP
return function(inst,shiftAmount,constant,settings)
	local output = ("pointer = pointer + :B: %s"):format(settings.Debug and "--print('[VM]:','JMP -- >',pointer)" or "")
	
	if settings.LuaUSyntax then
		output = ("pointer +=:B: %s"):format(settings.Debug and "--print('[VM]:','JMP -- >',pointer)" or "")
	end
	
	return output
end

