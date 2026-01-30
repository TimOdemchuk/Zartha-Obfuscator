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

### CLI flags
- `--constantprotection` – encrypts constants for stronger constant security. **(WIP)**
- `--minify` – minifies the output for smaller scripts.
- `--antitamper` – injects anti-tamper checks to detect script modification.  **(WIP)**
- `--encryptstrings` – encrypts all strings in the output.
- `--controlflowflattening` – flattens control flow for simple obfuscation hardening.
- `--debug` – enables debugging tools to help diagnose errors.
- `--luau` – converts luau syntax into normal lua to feed into compiler

## Requirements
For Zartha to function you must have Lua 5.1 installed.

> [!IMPORTANT]
> This obfuscator is still work in progress. Bugs should be expected.
