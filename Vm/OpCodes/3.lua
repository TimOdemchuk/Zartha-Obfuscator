-- LOADNIL
return function(instruction, shiftAmount, constant, settings)
	local reg_a = _G.getReg(instruction, "A")
	local reg_b = _G.getReg(instruction, "B")
	
	-- Set A through A+B to nil
	if reg_b == 0 then
		return ("\tStack[%d] = nil"):format(reg_a)
	else
		local nils = {}
		for i = 0, reg_b do
			nils[i + 1] = ("Stack[%d]"):format(reg_a + i)
		end
		return ("\t%s = nil"):format(table.concat(nils, ", "))
	end
end