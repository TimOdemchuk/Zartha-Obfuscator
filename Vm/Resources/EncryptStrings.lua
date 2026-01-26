local settingsGot = require("Input.Settings")

-- Protection from special characters
local function toSafeString(s)
	local safe = ""
	for i = 1, #s do
		safe = safe .. string.format("\\%03d", string.byte(s, i))
	end
	return safe
end

-- Encryption function
local function encrypt(str, key)
	local result = {}
	local keyLen = #key
	for i = 1, #str do
		local strByte = string.byte(str, i)
		local keyByte = string.byte(key, (i - 1) % keyLen + 1)
		table.insert(result, string.char(bit32.bxor(strByte, keyByte)))
	end
	return table.concat(result)
end

-- Main function
return function(scriptSource,wantsFunction)
	-- Return the encrypt function if wanted
	if wantsFunction == true then
		return encrypt
	end

	-- Encrypt all strings in the script
	local encryptedScript = scriptSource:gsub('"(.-)"', function(match)
		local key = tostring(math.random(100,3000))
		local encryptedData = encrypt(match, key)
		local safeData = toSafeString(encryptedData)
		local formatted = string.format('decrypt("%s", "%s")', safeData, key)
		
		return formatted
	end)

	-- Return the modified script
	return encryptedScript
end