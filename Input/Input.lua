local function abc() -- CLOSURE 0 0
    print("Hello, World!") -- GETGLOBAL 0 -1, LOADK 1 -2, CALL 0 2 1
    -- RETURN 0 1
end
-- MOVE 1 0
abc() -- CALL
-- RETURN