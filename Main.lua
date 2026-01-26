local pipeline = require("Pipeline")

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

-- Global functions
_G.sendToClient = function(msg, color)
    if hasArg("-silent") then
        return
    end
    
    local colors = {
        red = "\27[31m",
        green = "\27[32m",
        yellow = "\27[33m",
        blue = "\27[34m",
        magenta = "\27[35m",
        cyan = "\27[36m",
        white = "\27[37m",
        reset = "\27[0m"
    }

    if not colors[color] then
        color = "green"
    end
    
    print(colors[color:lower()] .. msg .. colors.reset)
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

-- Show help message
if hasArg("-h") or hasArg("--help") then
    print("Usage: lua Main.lua <input_file>")
    print("Options:")
    print("  -h, --help     Show this help message")
    os.exit(0)
end

-- Check if input file is provided
if not args[1] then
    print("Error: You need to input file")
    print("Usage: lua Main.lua <input_file>")
    os.exit(1)
end

local inputFile = args[1]

pipeline(inputFile)
