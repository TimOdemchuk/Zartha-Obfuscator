-- Requires
local pipeline = require("Pipeline")
local settings = require("Input.Settings")

-- Arguments
local args = {...}

-- Check args
local function hasArg(str)
    for index, value in ipairs(args) do
        if value == str then
            return true
        end
    end

    return nil
end

-- Colors for display
local displayColors = {
    red = "\27[31m",
    green = "\27[32m",
    yellow = "\27[33m",
    blue = "\27[34m",
    magenta = "\27[35m",
    cyan = "\27[36m",
    white = "\27[37m",
    reset = "\27[0m"
}

--// Check if arg is a flag
local function isFlag(value)
    return type(value) == "string" and value:sub(1, 2) == "--"
end

local function fileExists(path)
    if type(path) ~= "string" then
        return false
    end

    local f = io.open(path, "r")
    if f then
        f:close()
        return true
    end

    return false
end

-- Global functions
_G.display = function(msg, color)
    if hasArg("--silent") then
        return
    end

    if not displayColors[color] then
        color = "green"
    end
    
    print(displayColors[color:lower()] .. msg .. displayColors.reset)
end

_G.Random = function(a,b)
    return math.random(a,b)
end

_G.table.find =function(t,value)
    for i, v in ipairs(t) do
        if v == value then
            return i
        end
    end
    return nil
end

_G.bit32 = {
    bxor = function(...)
        local args = {...}

        if #args == 0 then
            return 0
        end

        local result = args[1]

        for i = 2, #args do
            local a, b = result, args[i]
            local xor = 0
            local bit = 1
            
            while a > 0 or b > 0 do
                local ra = a % 2
                local rb = b % 2
                
                if ra ~= rb then
                    xor = xor + bit
                end
                
                a = math.floor(a / 2)
                b = math.floor(b / 2)
                bit = bit * 2
            end
            
            result = xor
        end
        
        return result
    end
}

-- Check for arguments
if hasArg("--help") then
    print("Usage: lua Main.lua <input_file>")
    print("Options:")
    print("  --minify                   minifies the output for smaller output size")
    print("  --constantprotection       encrypts constants for stronger constant security")
    print("  --antitamper               injects anti-tamper checks to detect script modification")
    print("  --controlflowflattening    flattens control flow for simple obfuscation hardening")
    print("  --debug                    enables debugging tools to help diagnose errors")
    print("  --help                     shows this message")
    os.exit(0)
end

-- Check if input file is provided
local inputFile = args[1]
local outputFile = args[2]

-- Validate input and output files
if not inputFile or isFlag(inputFile) or not fileExists(inputFile) then
    print("Error: first argument must be an existing input file path (not a flag)")
    print("Usage: lua Main.lua <input_file> <output_file>")
    os.exit(1)
end

-- Validate output file
if not outputFile or isFlag(outputFile) then
    print("Error: second argument must be an output file path (not a flag)")
    print("Usage: lua Main.lua <input_file> <output_file>")
    os.exit(1)
end

-- Settings inputs
settings.ConstantProtect = hasArg("--constantprotection")
settings.Minify = hasArg("--minify")
settings.Debug = hasArg("--debug")
settings.AntiTamper = hasArg("--antitamper")
settings.EncryptStrings = hasArg("--encryptstrings")
settings.ControlFlowFlattening = hasArg("--controlflowflattening")

-- Run pipeline
_G.display("Starting obfuscation pipeline...", "green")
pipeline(inputFile, outputFile)