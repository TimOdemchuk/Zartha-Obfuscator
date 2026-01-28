-- EQ
return function(instruction,shiftAmount,constant,settings)
	local reg_a = _G.getReg(instruction,"A")
	local reg_b = _G.getReg(instruction,"B",true)
	local reg_c = _G.getReg(instruction,"C",true)
	
	local layout = ([=[
		if (%s %s %s) then
			pointer = pointer + 1
		end
	]=]):format(
		reg_b.k and "Constants[:B:+1]" or "Stack[:B:]", -- Check 1 (if A)
		reg_a >0 and "~=" or "==", -- Operator
		reg_c.k and "Constants[:C:+1]" or "Stack[:C:]"  -- Check 2 (B then)
	)

	
	return layout
end

--[[
	  if (%s and Constants[:B:+1] or Stack[:B:]) %s (%s and Constants[:C:+1] or Stack[:C:]) then
            pointer = pointer + 1
        end
]]