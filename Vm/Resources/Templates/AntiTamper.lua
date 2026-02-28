-- Anti-Tamper Template
return [=[
local _, e = pcall(function() 
	aa3() -- Force an error
end) 

if tonumber(e:match("%d+")) > 20  then 
	_CRASH()
	return error("Tamper detected")
end

]=]