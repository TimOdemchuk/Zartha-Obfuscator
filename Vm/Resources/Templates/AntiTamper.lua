-- Anti-Tamper Template
return [=[

local tampered = false
local function Crash() tampered = true _CRASH() end
local bait = setmetatable({}, {__tostring = Crash, __iter = Crash, __index = Crash, __metatable = 1}) -- bait printing

pcall(pcall, bait, bait)--lol
pcall(tonumber, bait)

local _, e = pcall(function() aa3() end) 
if tampered or tonumber(e:match("%d+")) > 40 then -- Max lines the script can be is 40
    Crash()
    return error("Tamper detected")
end

]=]