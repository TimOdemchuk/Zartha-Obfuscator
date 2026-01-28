local g = print

local kst = "hello" -- loadk
local bool = true -- loadbool

local a,b,c,d,e = nil,nil,nil,nil,nil -- loadnil

local tmp; tmp = kst -- move

g(a,b,c,d,e,bool,tmp)

local upval = 0
local function closure(...) -- vararg, closure
    local args = {...}

    local total = 0

    for i,v in pairs(args) do -- tforloop
        total = total + v
    end

    g(args, #args, total, upval)

    upval = upval + total -- getupval, setupval ??

    local newt = {23,5,36,745,3,2,12,563,7,56,8,67,8} -- newtable, setlist
    newt[1] = upval -- settable
    g(newt,#newt,newt[1], upval)

    return newt, total, newt[3] -- return, gettable
end

printf = kst

local oop = {}
oop.__index = oop

function oop.new(p1)
    local this = setmetatable({},oop)

    this.p1 = p1
    return this
end

function oop:test_self_opcode()
    print(self.p1)
end

local obj = oop.new("hello noobs")
obj:test_self_opcode()

-- missing self

local _4,_2 = 4,2

local add = _4 + _2
local sub = 4 - 2
local mul = _4 * 2
local div = 4 / _2
local mod = _4 % _2
local pow = 4 ^ 2
-- all maths

g(add,sub,mul,div,mod,pow)

if add > sub then -- lt
    g(printf)
elseif mul >= div then -- le
    g(div)
elseif mod == pow then -- eq
    g(pow)
end

--jmp

local function wrapper()
    return closure(22,44,37)
end

add = -add -- unm
bool = not bool -- not

g(add,bool,wrapper)

bool = bool and add
local new = bool and add or sub

local str = "hi my name is " .. kst .. " and it is great to meet you"

local rt, rtotal, rnum = wrapper()

g(bool,new,str,rt,rtotal,rnum)

for i=1,5 do
    add = add + rtotal
end

local t, total, num = closure(3,5,99,8) -- call
local len = #t -- len

g(add,t,total,num,len,closure,upval)
