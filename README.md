# Zartha-Obfuscator
Zartha is a Lua 5.1 obfuscator that can only obfuscate Lua 5.1 files. I am unlikely to ever use this for production and is just a project for others and me to learn more about. The obfuscator uses Luac to compile code to bytecode, which the parser reads. It builds a VM using the parser's output and finally minifies the code using [luasrcdiet](https://github.com/jirutka/luasrcdiet).

## Installation
```batch
git clone https://github.com/TimOdemchuk/Zartha-Obfuscator
```

## Usage
```
lua Main.lua <InputPath> <OutputPath>
```

## Requirements
For Zartha to function you must have Lua 5.1 installed.