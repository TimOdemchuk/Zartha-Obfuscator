-- SETTABLE
return function(inst)
	local reg_b = _G.getReg(inst,"B",true)
	local reg_c = _G.getReg(inst,"C",true)

	local layout = ([=[
		Stack[:A:][%s] = %s
	]=]):format(
		reg_b.k and "Constants[:B:+1]" or "Stack[:B:]", -- A
		reg_c.k and "Constants[:C:+1]" or "Stack[:C:]"  -- B
	)
	local output = ("Stack[:A:][%s and Constants[:B:+1] or Stack[:B:]] = %s and Constants[:C:+1] or Stack[:C:]"):format(
		tostring(reg_b.k),
		tostring(reg_c.k)
	)
	
	return layout
end

-- Stack[:A:][:B.k: and Constants[:B.k:] or Stack[:B:]] = :C.k: and Constants[:C.k:] or Stack[:C:]