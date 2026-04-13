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

local function generateJunkLoops(count)
    local junk = {}
    for i = 1, count do
        junk[#junk+1] = "while (nil) do; local i = {}; if(i.i)then i.i=(i.i(i));end;end;"
    end
    return table.concat(junk, "\n")
end

local function encodeString(str)
    local result = {}
    local key = math.random(100, 255)
    for i = 1, #str do
        local byte = string.byte(str, i)
        local encoded = (byte ~ key) % 256
        result[i] = string.format("\\%03d", encoded)
    end
    return table.concat(result), key
end

local function generateCharacterTable()
    local chars = {}
    for i = 1, 50 do
        chars[i] = '"' .. utf8.char(0x1D000 + i * 13) .. '"'
    end
    return table.concat(chars, ",")
end

local function generateRysFunction(key)
    return [[
local __rys__ = function(s)
  local r = {}
  local k = ]] .. key .. [[
  for v in s:gmatch("\\(%d%d%d)") do
    local b = tonumber(v)
    local d = (b ~ k) % 256
    r[#r+1] = string.char(d)
  end
  return table.concat(r)
end]]
end

local function generateObfuscatedLoader(originalCode)
    local junkLoops1 = generateJunkLoops(15)
    local junkLoops2 = generateJunkLoops(15)
    local junkLoops3 = generateJunkLoops(15)
    
    local encodedStr, key = encodeString(originalCode)
    local rysFunction = generateRysFunction(key)
    local charTableStr = generateCharacterTable()
    
    local template = [[
local infos =[=[
]] .. encodedStr .. [[
]=]

]] .. junkLoops1 .. [[

]] .. rysFunction .. [[

]] .. junkLoops2 .. [[

local __Character_Table__ = {]] .. charTableStr .. [[}

local __StartScript__ = function()
  local d = __rys__(infos)
  local f = load or loadstring
  f(d)()
end

__StartScript__()

]] .. junkLoops3 .. [[


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
    local saida = nomeArquivo:gsub("%.lua$", "") .. "_batman.lua"
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