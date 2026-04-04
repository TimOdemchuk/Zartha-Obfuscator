local parser = require("Bytecode.BytecodeParser")
local treeGenerator = require("Vm.TreeGenerator")
local antiEnvLogger = require("Vm.Resources.Templates.EnvLogDetection")
local antitamper = require("Vm.Resources.Templates.AntiTamper")
local LuauSanitizer = require("Vm.LuauSanitizer")
local luasrcdiet = require("luasrcdiet.init")
local settings = require("Input.Settings")

return function(inputFile,outputTo)
    local savedInput = _G.readFile(inputFile)
    
    -- Add input template
    local addToInput = _G.readFile("Vm/Resources/Templates/AddToInput.lua")
    local inputHandle = io.open(inputFile, "w")
   
    inputHandle:write(addToInput .. "\n" .. savedInput)
    inputHandle:close()
 
    -- Insert anti-tamper
    if settings.AntiTamper then
        _G.display("Adding Anti-Tamper...", "green")
        local rawInput = _G.readFile(inputFile)
        local combined = antitamper .. " \n " .. rawInput
        local inputHandle = io.open(inputFile, "w")
        inputHandle:write(combined)
        inputHandle:close()
    end
    
    -- Remove all LuaU specific syntax 
    if settings.LuaUCompatibility then
        _G.display("LuaU Compatibility mode enabled.", "yellow")
        
        local rawInput = _G.readFile(inputFile)
        local sanitized = LuauSanitizer.sanitize(rawInput)
        local inputHandle = io.open(inputFile, "w")

        inputHandle:write(sanitized)
        inputHandle:close()
    end

    -- Compile to bytecode
    _G.display("Compiling to bytecode...", "green")
    local compileSuccess, compileType, compileCode = os.execute("luac -o Input/luac.out " .. inputFile)
    
    if compileSuccess == 0 or compileSuccess == true then
        -- everythings fine
    else
        _G.display("luac compilation failed! (exit code: " .. tostring(compileCode or compileSuccess) .. ")", "red")

        -- Restore file
        savedInput = savedInput:gsub("\r\n", "\n"):gsub("\r", "\n")
        local restoreHandle = io.open(inputFile, "wb")
        restoreHandle:write(savedInput)
        restoreHandle:close()

        return
    end

    local bytecode = _G.readFile("Input/luac.out")

    if not bytecode or #bytecode == 0 then
        _G.display("luac produced no output! Check your input file for syntax errors.", "red")

        -- Restore
        savedInput = savedInput:gsub("\r\n", "\n"):gsub("\r", "\n")
        local restoreHandle = io.open(inputFile, "wb")
        restoreHandle:write(savedInput)
        restoreHandle:close()

        return
    end

    -- Parser bytecode
    _G.display("Parsering bytecode...", "green")
    local parsered = parser(bytecode)

    -- Generate VM tree
    _G.display("Generating VM tree...", "green")
    local vmTree = treeGenerator(parsered)

    -- Insert anti-env logger
    _G.display("Adding Anti-Env Logger...", "green")
    vmTree = vmTree:gsub(":INSERTENVLOG:", antiEnvLogger)

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

    -- Restore original input file
    savedInput = savedInput:gsub("\r\n", "\n"):gsub("\r", "\n")

    local inputFile = io.open(inputFile, "wb")
    inputFile:write(savedInput)
    inputFile:close()
end