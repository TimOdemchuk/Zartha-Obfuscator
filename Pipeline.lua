local parser = require("Bytecode.BytecodeParser")
local treeGenerator = require("Vm.TreeGenerator")
local antiEnvLogger = require("Vm.Resources.Templates.EnvLogDetection")
local antitamper = require("Vm.Resources.Templates.AntiTamper")
local luasrcdiet = require("luasrcdiet.init")
local settings = require("Input.Settings")

return function(inputFile,outputTo)
    -- Compile to bytecode
    os.execute("luac -o Input/luac.out " .. inputFile)
    local bytecode = _G.readFile("Input/luac.out")

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