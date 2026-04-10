gg.setVisible(false) -- UI'yi gizle

-- Kullanıcıdan AES anahtarını ve IV'yi al
local key = gg.prompt({"AES Key (16 byte, hex):"}, nil, {"text"})[1]
local iv = gg.prompt({"AES IV (16 byte, hex):"}, nil, {"text"})[1]

-- Hex string'i byte dizisine çevir
function hexToBytes(hex)
    local bytes = {}
    for i = 1, #hex - 1, 2 do
        local byte = tonumber(hex:sub(i, i+1), 16)
        table.insert(bytes, byte)
    end
    return bytes
end

local keyBytes = hexToBytes(key)
local ivBytes = hexToBytes(iv)

-- AES çözüm fonksiyonu (Java ile)
function decryptAES_CBC(dataBytes, keyBytes, ivBytes)
    local SecretKeySpec = luajava.bindClass("javax.crypto.spec.SecretKeySpec")
    local IvParameterSpec = luajava.bindClass("javax.crypto.spec.IvParameterSpec")
    local Cipher = luajava.bindClass("javax.crypto.Cipher")

    local key = SecretKeySpec.new(luajava.new(byte, keyBytes), "AES")
    local iv = IvParameterSpec.new(luajava.new(byte, ivBytes))

    local cipher = Cipher.getInstance("AES/CBC/PKCS5Padding")
    cipher:init(Cipher.DECRYPT_MODE, key, iv)

    local decrypted = cipher:doFinal(luajava.new(byte, dataBytes))
    return decrypted
end

-- Aktif GG sonuçlarını al
local results = gg.getResults(gg.getResultsCount())
if #results == 0 then
    gg.alert("Önce RAM'de bir bölgeyi aratmalısın!")
    os.exit()
end

-- Bellekten byte'ları oku
local encrypted = {}
for i, r in ipairs(results) do
    table.insert(encrypted, r.value)
end

-- Java AES çözümlemesini çalıştır
local success, decrypted = pcall(decryptAES_CBC, encrypted, keyBytes, ivBytes)
if not success then
    gg.alert("AES çözümlemesi başarısız oldu: " .. decrypted)
    os.exit()
end

-- Decrypted byte'ları string'e çevir
function bytesToString(bytes)
    local str = ""
    for _, b in ipairs(bytes) do
        if b == 0 then break end -- NULL byte varsa dur
        str = str .. string.char(b)
    end
    return str
end

local plaintext = bytesToString(decrypted)

-- Sonucu dosyaya yaz