-- Anti-Tamper Template
return [=[
local _, e = pcall(function() 
	aa.cc() -- Force an error
end) 

if tonumber(e:match("%d+")) > 20 or e:find("sand") then 
	return error("Tamper detected")
end

]=]