gg.setVisible(false)
local function HookBlocker()
    local Add = {io, os, utf8, math, string, debug, bit, bit32, gg}
    local Hook = ""
    local TimeCheck = os.clock()
    Big = string.rep("AntiLog", 999)
    
    for i = 1, 999 do
        debug.getinfo(1000, nil, Big)
    end
    
    check = string.format("%.2f", os.clock() - TimeCheck) * 100
    while check > 10 do
        return os.exit()
    end
    
    for i = 1, #Add do
        Hook = Hook .. tostring(Add)
    end
    
    if Hook:find("@") ~= nil then
        return gg.alert("Log?")
    end
    
    local getBypassfind = tostring(string.find):match("@[^\n]*/")
    while getBypassfind ~= nil do
        os.exit()
    end
end

-- Function to check for anti-hooking
local function AntiHookCheck()
    local Checkh, z = {}, {"gg.%a+"}
    local ttz = {gg.editAll, gg.searchNumber}
    
    for _0x1 in tostring(gg):gmatch("%[%'%w+'%] = function") do
        _0x1 = _0x1:match("%[%'%w+'%]"):match("%w+")
        table.insert(Checkh, _0x1)
    end
    
    for i in ipairs(ttz) do
        while not tostring(debug.getinfo(ttz[i])):match(z[1]) do
            gg.alert("Anti Hook 1")
        end
    end
    
    for i = 1, #Checkh do
        local Check2 = tostring("gg." .. Checkh[i]):match(z[1])
        local Check3 = tostring(debug.getinfo(gg[Checkh[i]]))
        while not Check3:find(Check2) or Check3:match(z[1]) ~= Check2 do
            gg.alert("Anti Hook 2")
        end
    end
end

-- Function to check if gg.searchNumber(1) is callable
local function SearchNumberCheck()
    local sc = 0
    while (pcall(load("gg.searchNumber(1)")) == false) do
        os.exit()
        sc = sc + 1
        if sc ~= 0 then
            return gg.alert("Bypass Exit ???")
        end
    end
end

-- Main Execution
HookBlocker()
AntiHookCheck()
SearchNumberCheck()