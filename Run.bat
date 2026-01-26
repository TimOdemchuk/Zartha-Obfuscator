@echo off
lua Main.lua Input/Input.lua Input/Output.lua --minify --encryptstrings --controlflowflattening
pause