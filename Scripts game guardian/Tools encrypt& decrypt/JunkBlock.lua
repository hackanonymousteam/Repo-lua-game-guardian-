g = {}
g.last = "/sdcard/"
g.info = nil
g.config = gg.EXT_CACHE_DIR .. "/" .. gg.getFile():match("[^/]+$") .. "cfg"
g.data = loadfile(g.config)

if g.data ~= nil then
    g.info = g.data()
    g.data = nil
end

if g.info == nil then
    g.info = { g.last, g.last:gsub("/[^/]+$", "") }
end

local function randomString(len)
    local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    local s = ""
    for i = 1, len do
        s = s .. chars:sub(math.random(1, #chars), math.random(1, #chars))
    end
    return s
end

local function generateJunkBlock()
    local lines = {}
    local num1 = math.random(100, 999)
    local num2 = math.random(100, 999)
    
    lines[#lines+1] = "if nil then end"
    lines[#lines+1] = "if (tonumber(-" .. math.random(10, 99) .. ") < tonumber(-" .. math.random(100, 299) .. ")) then end"
    lines[#lines+1] = "for o = 1, 0 do"
    lines[#lines+1] = "    _()"
    lines[#lines+1] = "    local _ = {}"
    lines[#lines+1] = "    _._ = _"
    lines[#lines+1] = "    _._ = _._"
    lines[#lines+1] = "    _._ = {}"
    lines[#lines+1] = "    for o in (_) do"
    lines[#lines+1] = "        _[_] = _"
    lines[#lines+1] = "    end"
    lines[#lines+1] = "    _()"
    lines[#lines+1] = "    goto _"
    lines[#lines+1] = "    goto _"
    lines[#lines+1] = "    goto _"
    lines[#lines+1] = "    ::_::"
    lines[#lines+1] = "    local o = {(__ ~ __) | nil}"
    lines[#lines+1] = "    if o.o == o.o then"
    lines[#lines+1] = "        o.o = o.o()"
    lines[#lines+1] = "    end"
    lines[#lines+1] = "end"
    lines[#lines+1] = "if nil then end"
    lines[#lines+1] = "if (tonumber(" .. num1 .. ") < tonumber(-" .. num2 .. ")) then end"
    
    return table.concat(lines, "\n")
end

local function encodeToString(str)
    local result = {}
    for i = 1, #str do
        result[i] = string.byte(str, i)
    end
    return table.concat(result, ",")
end

local function generateObfuscatedLoader(originalCode)
    local bytes = encodeToString(originalCode)
    local varName1 = randomString(5)
    local varName2 = randomString(6)
    local varName3 = randomString(4)
    local varName4 = randomString(7)
    
    local template = [[
local ]] .. varName1 .. [[ = {]] .. bytes .. [[}

local function ]] .. varName2 .. [[(t)
    local r = {}
    for i = 1, #t do
        r[i] = string.char(t[i])
    end
    return table.concat(r)
end

]] .. generateJunkBlock() .. [[

local function ]] .. varName3 .. [[(s)
    local f = load or loadstring
    return f(s)()
end

]] .. generateJunkBlock() .. [[

local ]] .. varName4 .. [[ = ]] .. varName2 .. [[(]] .. varName1 .. [[)

]] .. generateJunkBlock() .. [[

]] .. varName3 .. [[(]] .. varName4 .. [[)
]]
    
    return template
end

while true do
    g.info = gg.prompt({
        '📂 Select file :',
        '📂 Select folder :'
    }, g.info, {'file', 'path'})

    if not g.info then return end

    gg.saveVariable(g.info, g.config)
    g.last = g.info[1]

    if loadfile(g.last) == nil then
        gg.alert("⚠️ Script not Found! ⚠️")
        return
    end

    local nomeArquivo = g.last:match("[^/]+$")
    local saida = nomeArquivo:gsub("%.lua$", "") .. "_obfuscated.lua"
    g.out = g.info[2] .. "/" .. saida

    local file = io.open(g.last, "r")
    local DATA = file:read("*a")
    file:close()

    math.randomseed(os.time())
    local finalCode = generateObfuscatedLoader(DATA)
    local outFile = io.open(g.out, "w")
    outFile:write(finalCode)
    outFile:close()
    gg.alert("📂 Obfuscated File Saved To:\n" .. g.out)
    print("📂 Obfuscated File Saved To: " .. g.out)
    return
end