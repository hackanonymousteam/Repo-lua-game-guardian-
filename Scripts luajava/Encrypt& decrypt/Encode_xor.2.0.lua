if luajava == nil then gg.alert(' unavaliable please use gameguardian mod (suport luajava)') else end

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

local function xorEncryptByte(byte, key)
    local a, b = byte, key
    local pow = 1
    local c = 0
    local xor_l = {{0,1}, {1,0}}
    while a > 0 or b > 0 do
        c = c + (xor_l[(a % 2)+1][(b % 2)+1] * pow)
        a = math.floor(a/2)
        b = math.floor(b/2)
        pow = pow * 2
    end
    return c
end

local function generateKeyHash(str)
    local r = 0
    for i = 1, #str do
        local a = string.byte(str, i)
        r = r + a - 8 / 2
    end
    r = r * 2
    return math.floor(r) % 256
end

local function encryptScript(scriptContent, password)
    local keyHash = generateKeyHash(password)
    local hexValues = {}
    for i = 1, #scriptContent do
        local byte = string.byte(scriptContent, i)
        local encrypted = xorEncryptByte(byte, keyHash)
        table.insert(hexValues, string.format("'%X'", encrypted))
    end
    return table.concat(hexValues, ",")
end

local function buildFinalScript(encryptedHex, password)
    local template = "if luajava == nil then gg.alert(' unavaliable please use gameguardian mod (suport luajava)') else end;key = gg.prompt({'Password:'}, {''}, {'text'});(function(a) function A(a,b) local pow = 1; local c = 0; local XOR_l = {{0,1},{1,0}}; while a > 0 or b > 0 do c = c + (XOR_l[(a %% 2)+1][(b %% 2)+1] * pow); a = math.floor(a/2); b = math.floor(b/2); pow = pow * 2; end; return c; end; function B(str) local r = 0; for _ = 1, #str do local a = string.byte(str, _); r = r + a - 8 / 2; end; r = r * 2; return r; end; function C(src,key) local r = ''; key = B(key); for _, v in pairs(src) do if v ~= nil then v = tonumber(v, 16); v = string.char(A(v, key)); end; r = r .. v; end; return r; end; local Class = luajava.bindClass; local new = luajava.new; local astable = luajava.astable; local methods = luajava.methods; local Script = Class('android.ext.Script'); local decrypted = C({%s},a); gg.setVisible(false); local scriptInstance = Script(decrypted, 0, ''); scriptInstance:c_(); end)(key[1])"
    return string.format(template, encryptedHex)
end

while true do
    g.info = gg.prompt({
        '📂 Select file to encrypt:',
        '📂 Select output folder:',
        '🔑 Encryption password:'
    }, {g.info[1] or g.last, g.info[2] or g.last:gsub("/[^/]+$", ""), ''}, {'file', 'path', 'text'})

    if not g.info then return end

    gg.saveVariable(g.info, g.config)
    g.last = g.info[1]
    
    local password = g.info[3]
    if password == nil or password == '' then
        password = "default"
    end

    local nomeArquivo = "script_enc.lua"
    g.out = g.info[2] .. "/" .. nomeArquivo

    local file = io.open(g.last, "r")
    if not file then
        gg.alert("❌ Could not open file:\n" .. g.last)
        return
    end
    
    local DATA = file:read("*a")
    file:close()
    
    local encryptedHex = encryptScript(DATA, password)
    local finalCode = buildFinalScript(encryptedHex, password)

    local outFile = io.open(g.out, "w")
    if not outFile then
        gg.alert("❌ Could not create output file:\n" .. g.out)
        return
    end
    
    outFile:write(finalCode)
    outFile:close()
    
    gg.alert("✅ Encrypted script saved at:\n" .. g.out .. "\n\n🔑 Password: " .. password)
    return
end