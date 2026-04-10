local function toBase8(str)
    local chars = '01234567'
    local result = {}
    local buffer = 0
    local bits = 0
    
    for i = 1, #str do
        buffer = buffer * 256 + string.byte(str, i)
        bits = bits + 8
        
        while bits >= 3 do
            bits = bits - 3
            local index = math.floor(buffer / (2^bits)) + 1
            table.insert(result, string.sub(chars, index, index))
            buffer = buffer % (2^bits)
        end
    end
    
    if bits > 0 then
        local index = buffer * 2^(3-bits) + 1
        table.insert(result, string.sub(chars, index, index))
    end
    
    return table.concat(result)
end

local function fromBase8(str)
    local chars = '01234567'
    local map = {}
    for i = 1, 8 do
        map[string.sub(chars, i, i)] = i - 1
    end
    
    local result = {}
    local buffer = 0
    local bits = 0
    
    for i = 1, #str do
        local char = string.sub(str, i, i)
        buffer = buffer * 8 + map[char]
        bits = bits + 3
        
        while bits >= 8 do
            bits = bits - 8
            local byte = math.floor(buffer / (2^bits))
            table.insert(result, string.char(byte))
            buffer = buffer % (2^bits)
        end
    end
    
    return table.concat(result)
end

local function simpleEncrypt(data, key)
    local result = {}
    local keyLen = #key
    
    for i = 1, #data do
        local byte = string.byte(data, i)
        local keyByte = string.byte(key, ((i-1) % keyLen) + 1)
        table.insert(result, string.char(bit32.bxor(byte, keyByte)))
    end
    
    return table.concat(result)
end

local function simpleDecrypt(data, key)
    return simpleEncrypt(data, key)
end

local function simpleHash(str)
    local hash = 0x811c9dc5
    
    for i = 1, #str do
        hash = bit32.bxor(hash, string.byte(str, i))
        hash = hash * 0x1000193
        hash = bit32.band(hash, 0xffffffff)
    end
    
    return string.format("%08x", hash)
end

local function deriveKey(password, salt, iterations)
    local key = password .. salt
    
    for i = 1, iterations do
        key = simpleHash(key)
    end
    
    return key
end

local function encryptFile(inputPath, outputPath, password)
    local file = io.open(inputPath, "rb")
    if not file then
        return "Error: Input file not found"
    end
    
    local content = file:read("*a")
    file:close()
    
    local chunk, err = load(content)
    if not chunk then
        return "Error: Invalid script - " .. tostring(err)
    end
    
    math.randomseed(os.time())
    local salt = ""
    for i = 1, 16 do
        salt = salt .. string.char(math.random(0, 255))
    end
    
    local key = deriveKey(password, salt, 1000)
    local encrypted = simpleEncrypt(content, key)
    local hmac = simpleHash(salt .. encrypted)
    
    local payload = {
        v = "1.0",
        s = toBase8(salt),
        c = toBase8(encrypted),
        h = hmac
    }
    
    local payloadStr = string.format('{"v":"%s","s":"%s","c":"%s","h":"%s"}',
        payload.v, payload.s, payload.c, payload.h)
    
    local runtime = [[
local b='01234567' local m={}
for i=1,8 do m[b:sub(i,i)]=i-1 end

local function f8(s)
    local r,buf,bits={},0,0
    for i=1,#s do
        buf=buf*8+m[s:sub(i,i)]
        bits=bits+3
        while bits>=8 do
            bits=bits-8
            table.insert(r,string.char(math.floor(buf/2^bits)))
            buf=buf%(2^bits)
        end
    end
    return table.concat(r)
end

local function simpleHash(str)
    local h=0x811c9dc5
    for i=1,#str do
        h=bit32.bxor(h,str:byte(i))
        h=h*0x1000193
        h=bit32.band(h,0xffffffff)
    end
    return string.format("%08x",h)
end

local function deriveKey(p,s,i)
    local k=p..s
    for j=1,i do k=simpleHash(k) end
    return k
end

local function simpleXOR(data,key)
    local r,kl={},#key
    for i=1,#data do
        local b=data:byte(i)
        local kb=key:byte(((i-1)%kl)+1)
        table.insert(r,string.char(bit32.bxor(b,kb)))
    end
    return table.concat(r)
end

local pstr = f8(']] .. toBase8(payloadStr) .. [[')
local p = {}
for k,v in pstr:gmatch('"([^"]+)":"([^"]+)"') do p[k]=v end

local salt = f8(p.s)
local enc = f8(p.c)

local pass
if gg then
    local ret = gg.prompt({'Password:'},{''},{'text'})
    if not ret then return end
    pass = ret[1]
else
    io.write('Password: ')
    pass = io.read()
end

if not pass or pass=='' then
    print('Password required')
    return
end

local key = deriveKey(pass, salt, 1000)
local calcHmac = simpleHash(salt..enc)

if calcHmac ~= p.h then
    print('Invalid HMAC - corrupted file')
    return
end

local dec = simpleXOR(enc, key)
local fn = load(dec)
if fn then
    fn()
else
    print('Error loading script')
end
]]

    local out = io.open(outputPath, "wb")
    if not out then
        return "Error: Cannot create output file"
    end
    
    out:write("-- ENC Simple v1.0\n")
    out:write(runtime)
    out:close()
    
    return "OK: " .. outputPath
end

if gg then
    local function showMenu()
        local menu = gg.choice({
            "🔐 Encrypt File",
            "❓ Help",
            "🚪 Exit"
        }, nil, "⚡ ENCRYPTION SIMPLE ⚡")
        
        if menu == 1 then
            local currentFile = gg.getFile()
            local defaultOut = gg.getFile() .. "/enc_" .. 
                (currentFile:match("([^/]+)$") or "script.lua")
            
            local inputs = gg.prompt({
                "📁 Input File:",
                "📁 Output File:",
                "🔒 Password:"
            }, {
                currentFile,
                defaultOut,
                ""
            }, {
                "file",
                "path",
                "text"
            })
            
            if inputs then
                local result = encryptFile(inputs[1], inputs[2], inputs[3])
                gg.alert(result)
            end
        elseif menu == 2 then
            gg.alert([[⚡ ENCRYPTION SIMPLE ⚡

This script encrypts Lua files using:
- XOR with derived key
- Base8 encoding
- HMAC verification

How to use:
1. Select .lua file
2. Choose output location
3. Enter strong password

Generated file can only be executed with same password.]])
        elseif menu == 3 then
            return
        end
    end
    
    showMenu()
else
    print("Usage: lua encrypt.lua <input_file> <output_file> <password>")
    if arg and #arg >= 3 then
        local result = encryptFile(arg[1], arg[2], arg[3])
        print(result)
    end
end