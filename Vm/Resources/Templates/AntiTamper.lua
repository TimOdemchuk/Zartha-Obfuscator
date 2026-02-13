-- Anti-Tamper Template
return [=[
local _, e = pcall(function() 
	aa.cc() -- Force an error
end) 

if tonumber(e:match("%d+")) > 20 or e:find("sand") then 
	_CRASH()
	return error("Tamper detected")
end

]=]