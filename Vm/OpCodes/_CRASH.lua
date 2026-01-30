-- Template for custom macro
return function(inst,shiftAmount,constant,settings)
	if inst == "custom" then --// Custom opcode
		return {
			["A"] = shiftAmount.A+1, --// Call opcode 
			["Opcode"] = "_CRASH",
			["OpcodeName"] = "_CRASH",
		}
	end
    
    -- Debug mode (So we don't crash ourselfs while testing)
	if settings.Debug then
		return "print('[VM]:','CRASH_VM!') break"
	end

    -- Template
	return [=[
		pointer = pointer + 40^10
	]=]
end

