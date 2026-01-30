local function f(a, b, c) 
    return a + b * c 
end

local start = os.clock()

for i = 1, 900000 do
     f(i, 2, 3)
end

local elapsed = os.clock() - start

print("Function Benchmark Results")
print(elapsed)