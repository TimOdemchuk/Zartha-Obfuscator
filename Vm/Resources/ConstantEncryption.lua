local template = [=[
:gsub(dot, function(letter)
    return char(bxor(byte(letter), byteKey))
end)
]=]

return function(opcode, constant, encryptedMeta, byteKey, encryptionMetaMap)
    return opcode -- to do
end