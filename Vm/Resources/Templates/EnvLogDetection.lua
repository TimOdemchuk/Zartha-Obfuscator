--[[

-- Env log detection (Template)
(function()
	local function ooptest(...)
		local a = true and #{ -- solvers would make this 1 instead of 3
			...
		}
		return a
	end

	local Tamper = false

	getfenv()["runtime"] = function() -- Env loggers would run to see what this function is
		Tamper = true
	end
	
	if Tamper then
		return -- Detect
	else
		local Checked = nil
		local _,er = pcall(function()
			Checked = (newproxy(print)) -- 25ms sets this as a valid because of their custom print 
		end)
		if Checked then
			return -- Detect
		else
			warn("Passed")
		end
	end
	local counter = ooptest(1, 2, 3)
	
	if counter <1 then
		return	-- Detect
	end
end)()
]]

return [=[
(function() -- Env log detection
	local function ooptest(...)
		local a = true and #{ -- troll
			...
		}
		return a
	end
	local Tamper = false
	Env[__index] = function() 
		Tamper = true
	end
	
	if Tamper then
		pointer = 100
	else
		local Checked = nil
		local _,er = pcall(function()
			Checked = (proxy(pnt)) 
		end)
		if Checked then
			pointer = 50
		else
			pointer = 1
		end
	end
	local counter = ooptest(1, 2, 3)
	
	if counter <2 then
		pointer = 50
	end
end)()
]=]