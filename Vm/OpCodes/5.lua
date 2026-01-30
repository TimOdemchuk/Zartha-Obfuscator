-- GETGLOBAL
return function(inst,shift,constant,settings)
	local output = [=[
		Stack[:A:] = Env[Constants[:B:+1]]
	]=]
	
	return output
end

-- Stack[:A:] = Env[Constants[:B:+1]]