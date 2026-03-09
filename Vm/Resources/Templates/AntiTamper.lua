-- Anti-Tamper Template
return [=[

local triggerTamper = false

-- Simple check to see if any of the functions are hooked
local bait = newproxy and newproxy(true) or setmetatable({},{})
local getmeta = getmetatable(bait)

getmeta.__tostring = function()
	triggerTamper = true
	_CRASH()
	return ""
end
getmeta.__iter = function()
	triggerTamper = true
	_CRASH()
end
getmeta.__index = function()
	triggerTamper = true
	_CRASH()
end
getmeta.__metatable = {}

pcall(pcall,bait,bait) --lol
pcall(tonumber,bait,bait)

if triggerTamper then -- if it somehow passes the crash??
	return error("Tamper detected")
end

-- A line check (If the error message contains a line number higher than 20 it means the code was probably formatted)
local _, e = pcall(function() 
	aa3() -- Force an error
end) 

if tonumber(e:match("%d+")) > 20  then 
	_CRASH()
	return error("Tamper detected")
end

]=]