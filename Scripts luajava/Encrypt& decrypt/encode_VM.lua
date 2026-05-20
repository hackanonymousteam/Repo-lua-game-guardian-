

if luajava == nil then
  gg.alert(" unavaliable please use gameguardian mod (suport luajava)")
else
  gg.toast("🎉 doneا 🎉")
end
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
    local result = ""
    for i = 1, len do
        result = result .. chars:sub(math.random(1, #chars), math.random(1, #chars))
    end
    return result
end

local function randomVarName()
    local prefixes = {"_", "v", "f", "l", "m", "p", "t", "c", "r"}
    local prefix = prefixes[math.random(1, #prefixes)]
    return prefix .. randomString(math.random(2, 4)) .. math.random(10, 99)
end

local function xorEncrypt(data, key)
    local result = {}
    for i = 1, #data do
        local b = string.byte(data, i)
        result[i] = string.char(b ~ (key % 256))
    end
    return table.concat(result)
end

local function generateHeader()
    return [==[--[[
by Batman Games 
Version: 1.0.0

]]
if luajava == nil then
  gg.alert(" unavaliable please use gameguardian mod (suport luajava)")
else
  gg.toast("🎉 doneا 🎉")
end
local Class = luajava.bindClass
local Script = Class("android.ext.Script")

]==]
end

local function generateEncryptedData(code)
    local key = math.random(100, 200)
    local encrypted = {}
    for i = 1, #code do
        local b = string.byte(code, i)
        encrypted[i] = b ~ key
    end
    return encrypted, key
end

local function generateDecryptFunction()
    return [[
local function decrypt(data, key)
  local result = {}
  for i = 1, #data do
    result[i] = string.char(data[i] ~ key)
  end
  return table.concat(result)
end
]]
end

local function generateEncryptedTable(encrypted, key)
    local parts = {}
    for i = 1, #encrypted, 50 do
        local chunk = {}
        local endIdx = math.min(i + 49, #encrypted)
        for j = i, endIdx do
            chunk[#chunk + 1] = encrypted[j]
        end
        parts[#parts + 1] = "{" .. table.concat(chunk, ",") .. "}"
    end
    return "local encryptedData = {\n" .. table.concat(parts, ",\n") .. "\n}\nlocal decryptKey = " .. key
end

local function generateDummyCode()
    local f1 = randomVarName()
    local f2 = randomVarName()
    local f3 = randomVarName()
    local v1 = randomVarName()
    local v2 = randomVarName()
    local v3 = randomVarName()
    local v4 = randomVarName()
    local v5 = randomVarName()
    local v6 = randomVarName()
    return 'local function ' .. f1 .. '(x)\n' ..
           '  local ' .. v1 .. '=(x*5)-(x*5)\n' ..
           '  local ' .. v2 .. '=(' .. v1 .. '+53)-53\n' ..
           '  if ' .. v2 .. '~=0 then return x end\n' ..
           '  return x\n' ..
           'end\n' ..
           f1 .. '(1)\n' ..
           'local function ' .. f2 .. '(x)\n' ..
           '  local ' .. v3 .. '=x*2\n' ..
           '  return ' .. v3 .. '/2\n' ..
           'end\n' ..
           'local ' .. v4 .. '=' .. f2 .. '(2)\n' ..
           'do local ' .. v5 .. '=1; local ' .. v6 .. '=1; if (' .. v5 .. '+' .. v6 .. ')==3 then ' .. v5 .. '=' .. v5 .. '+1 end end\n' ..
           'local function ' .. f3 .. '()\n' ..
           '  local t={}\n' ..
           '  for i=1,10 do t[i]=i*2 end\n' ..
           '  return t\n' ..
           'end\n'
end

local function generateVM()
    return [[
local function processData()
  local fullData = {}
  for i = 1, #encryptedData do
    for j = 1, #encryptedData[i] do
      fullData[#fullData + 1] = encryptedData[i][j]
    end
  end
  return decrypt(fullData, decryptKey)
end

local scriptContent = processData()
if scriptContent and #scriptContent > 0 then
  local scriptInstance = Script(scriptContent, 0, "")
  scriptInstance:c_()
end
]]
end

local function generateObfuscatedScript(originalCode)
    math.randomseed(os.time())
    local encrypted, key = generateEncryptedData(originalCode)
    
    local script = generateHeader()
    script = script .. generateDecryptFunction()
    script = script .. generateEncryptedTable(encrypted, key) .. "\n"
    script = script .. generateDummyCode()
    script = script .. generateVM()
    return script
end

while true do
    g.info = gg.prompt({
        'Select file to encrypt:',
        'Select output folder:'
    }, {g.info[1] or g.last, g.info[2] or g.last:gsub("/[^/]+$", "")}, {'file', 'path'})

    if not g.info then return end

    gg.saveVariable(g.info, g.config)
    g.last = g.info[1]

    local fileName = "script_enc_batman.lua"
    g.out = g.info[2] .. "/" .. fileName

    local file = io.open(g.last, "r")
    if not file then
        gg.alert("Error: Could not open file:\n" .. g.last)
        return
    end
    
    local DATA = file:read("*a")
    file:close()
    
    local finalCode = generateObfuscatedScript(DATA)
    
    local f, err = load(finalCode)
    if not f then
        gg.alert("Syntax error in generated code:\n" .. err)

        return
    end

    local outFile = io.open(g.out, "w")
    if not outFile then
        gg.alert("Error: Could not create output file:\n" .. g.out)
        return
    end
    
   outFile:write(finalCode)
   outFile:close()
    
    gg.alert(" Obfuscation V1\n\nEncrypted script saved at:\n" .. g.out)
    return
end