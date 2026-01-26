local parser = require("Bytecode.BytecodeParser")
local treeGenerator = require("Vm.TreeGenerator")
local antiEnvLogger = require("Vm.Resources.Templates.EnvLogDetection")
local antitamper = require("Vm.Resources.Templates.AntiTamper")
local luasrcdiet = require("luasrcdiet.init")
local settings = require("Input.Settings")

local function readFile(file)
    local bytecode = io.open(file, "rb")
    local content = bytecode:read("*all")
    bytecode:close()

    return content
end

local function dump(tableData, indent) --// print out tables
	local function serializeValue(value, level)
		level = level or 0
		if type(value) == "string" then
			return string.format("%q", value)
		elseif type(value) == "table" then
			return dump(value, level + 1)
		else
			return tostring(value)
		end
	end
	local result = "{\n"
	for k, v in pairs(tableData) do
		local keyIndent = string.rep(" ", indent + 2)
		local valueIndent = string.rep(" ", indent + 4)
		if type(k) == "string" then
			result = result..keyIndent.."["..string.format("%q", k).."] = "
		else
			result = result..keyIndent.."["..tostring(k).."] = "
		end
		result = result..serializeValue(v, indent + 2)..",\n"
	end
	result = result..string.rep(" ", indent).."}"
	return result
end

return function(inputFile,outputTo)
    -- Compile to bytecode
    os.execute("luac -o Input/luac.out " .. inputFile)
    local bytecode = readFile("Input/luac.out")

    -- Parser bytecode
    _G.display("Parsering bytecode...", "green")
    local parsered = parser(bytecode)

    -- Generate VM tree
    _G.display("Generating VM tree...", "green")
    local vmTree = treeGenerator(parsered)

    -- Insert anti-env logger
    _G.display("Adding Anti-Env Logger...", "green")
    vmTree = vmTree:gsub(":INSERTENVLOG:", antiEnvLogger)

    -- Insert anti-tamper
    _G.display("Adding Anti-Tamper...", "green")
    vmTree = vmTree:gsub(":ANTITAMPER:", antitamper)

    -- Minify
    if settings.Minify then
        _G.display("Minifying output...", "green")
        vmTree = luasrcdiet.optimize(luasrcdiet.MAXIMUM_OPTS, vmTree)
    end

    -- Write output to file
    local outputFile = io.open(outputTo or "Input/Output.lua", "w")
    
    if outputFile then
        outputFile:write(vmTree)
        outputFile:close()
        _G.display("Output written to "..(outputTo or "Input/Output.lua"), "green")
    else
        _G.display("Error writing to "..(outputTo or "Input/Output.lua"), "red")
    end

    print("File has been obfuscated.")
end