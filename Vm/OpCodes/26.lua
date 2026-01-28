-- TEST
return function(Inst,shiftAmount,constant,settings)
	local output = ([=[
	if %s Stack[:A:] then
		pointer = pointer + 1
		%s
	end]=])
	
	if _G.getReg(Inst,"C")== 0 then
		output = output:format("",settings.Debug and "print('[VM]:','JMP -- > ',pointer)" or "")
	else
		output = output:format("not",settings.Debug and "print('[VM]:','JMP -- > ',pointer)" or "")
	end
	
	return output
end