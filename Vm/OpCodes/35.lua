-- CLOSE
return function(instruction, shiftAmount, constant, settings)
	print("CLOSE????")
	local reg_a = _G.getReg(instruction, "A")
	return ([=[
	for i = %d, #Stack do
		Stack[i] = nil
	end
	]=]):format(reg_a) -- im just guessing this is correct
end

