-- EQ
return function(instruction,shiftAmount,constant,settings)
	local reg_a = _G.getReg(instruction,"A")
	local reg_b = _G.getReg(instruction,"B",true)
	local reg_c = _G.getReg(instruction,"C",true)
	
	local layout = ([=[
		Temp[1] = %s -- regB
		Temp[2] = Constants[:B:+1] -- constants
		Temp[3] = Stack[:B:] -- stack location regB
		Temp[4] = Constants[:C:+1] -- constants regC
		Temp[5] = Stack[:C:] -- stack location regC
		Temp[6] = %s
		
		if (Temp[1] and Temp[2] or Temp[3]) %s (Temp[6] and Temp[4] or Temp[5] ) then
			pointer = pointer + 1
		end
	]=]):format(tostring(reg_b.k),tostring(reg_c.k),_G.getReg(instruction,"A") >0 and "~=" or "==")
	
	return layout
end

--[[
	  if (%s and Constants[:B:+1] or Stack[:B:]) %s (%s and Constants[:C:+1] or Stack[:C:]) then
            pointer = pointer + 1
        end
]]