return function(inst)
	local reg_b = _G.getReg(inst,"B",true)
	local reg_c = _G.getReg(inst,"C",true)
	local output = ("Stack[:A:][%s and Constants[:B:+1] or Stack[:B:]] = %s and Constants[:C:+1] or Stack[:C:]"):format(
		tostring(reg_b.k),
		tostring(reg_c.k)
	)
	
	return output
end

-- stack[:a:][:kb: and constants[:kb:] or stack[:b:]] = :kc: and constants[:kc:] or stack[:c:]