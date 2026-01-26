--// LE
return function(instruction,shiftAmount,constant,settings)
	local reg_a = _G.getReg(instruction,"A")
	local reg_b = _G.getReg(instruction,"B",true)
	local reg_c = _G.getReg(instruction,"C",true)
	
	local layout = ([=[
	  if (%s and Constants[:B:+1] or Stack[:B:]) %s (%s and Constants[:C:+1] or Stack[:C:]) then
            pointer = pointer + 1
        end
	]=]):format(tostring(reg_b.k),_G.getReg(instruction,"A") >0 and ">=" or "<=",tostring(reg_c.k))
	
	
	return layout
end

