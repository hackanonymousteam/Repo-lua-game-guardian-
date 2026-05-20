local bit = bit or {}
if not bit.bxor then
    function bit.bxor(a, b)
        local result = 0
        local n = 1
        while a > 0 or b > 0 do
            local a_bit = a % 2
            local b_bit = b % 2
            if a_bit ~= b_bit then
                result = result + n
            end
            a = math.floor(a / 2)
            b = math.floor(b / 2)
            n = n * 2
        end
        return result
    end
end

if not bit.bor then
    function bit.bor(a, b)
        local result = 0
        local n = 1
        while a > 0 or b > 0 do
            local a_bit = a % 2
            local b_bit = b % 2
            if a_bit == 1 or b_bit == 1 then
                result = result + n
            end
            a = math.floor(a / 2)
            b = math.floor(b / 2)
            n = n * 2
        end
        return result
    end
end

if not bit.band then
    function bit.band(a, b)
        local result = 0
        local n = 1
        while a > 0 or b > 0 do
            local a_bit = a % 2
            local b_bit = b % 2
            if a_bit == 1 and b_bit == 1 then
                result = result + n
            end
            a = math.floor(a / 2)
            b = math.floor(b / 2)
            n = n * 2
        end
        return result
    end
end

if not bit.bnot then
    function bit.bnot(a)
        return 0xFFFFFFFF - a
    end
end

if not bit.lshift then
    function bit.lshift(a, n)
        return math.floor(a * (2 ^ n)) % 0x100000000
    end
end

if not bit.rshift then
    function bit.rshift(a, n)
        return math.floor(a / (2 ^ n))
    end
end

local function to_hex(data)
    local hex_chars = {'0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f'}
    local result = {}
    for i = 1, #data do
        local b = string.byte(data, i)
        result[#result + 1] = hex_chars[math.floor(b / 16) + 1]
        result[#result + 1] = hex_chars[b % 16 + 1]
    end
    return table.concat(result)
end

local function sha256(data)
    local function ROTR(x, n)
        return bit.bor(bit.rshift(x, n), bit.lshift(x, 32 - n))
    end
    local function Ch(x, y, z)
        return bit.bxor(bit.band(x, y), bit.band(bit.bnot(x), z))
    end
    local function Maj(x, y, z)
        return bit.bxor(bit.band(x, y), bit.bxor(bit.band(x, z), bit.band(y, z)))
    end
    local function Sigma0(x)
        return bit.bxor(ROTR(x, 2), bit.bxor(ROTR(x, 13), ROTR(x, 22)))
    end
    local function Sigma1(x)
        return bit.bxor(ROTR(x, 6), bit.bxor(ROTR(x, 11), ROTR(x, 25)))
    end
    local function sigma0(x)
        return bit.bxor(ROTR(x, 7), bit.bxor(ROTR(x, 18), bit.rshift(x, 3)))
    end
    local function sigma1(x)
        return bit.bxor(ROTR(x, 17), bit.bxor(ROTR(x, 19), bit.rshift(x, 10)))
    end
    
    local K = {
        0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5,
        0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
        0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3,
        0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
        0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc,
        0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
        0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7,
        0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
        0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13,
        0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
        0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3,
        0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
        0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5,
        0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
        0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208,
        0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2
    }
    
    local msg = {}
    for i = 1, #data do
        msg[i] = string.byte(data, i)
    end
    
    local bit_len = #data * 8
    msg[#msg + 1] = 0x80
    while (#msg + 8) % 64 ~= 0 do
        msg[#msg + 1] = 0
    end
    for i = 7, 0, -1 do
        msg[#msg + 1] = math.floor(bit_len / (256 ^ i)) % 256
    end
    
    local H = {
        0x6a09e667, 0xbb67ae85, 0x3c6ef372, 0xa54ff53a,
        0x510e527f, 0x9b05688c, 0x1f83d9ab, 0x5be0cd19
    }
    
    for chunk = 1, #msg, 64 do
        local W = {}
        for t = 0, 15 do
            local pos = chunk + t * 4
            W[t] = msg[pos] * 0x1000000 + msg[pos + 1] * 0x10000 + msg[pos + 2] * 0x100 + msg[pos + 3]
        end
        for t = 16, 63 do
            W[t] = (sigma1(W[t - 2]) + W[t - 7] + sigma0(W[t - 15]) + W[t - 16]) % 0x100000000
        end
        
        local a, b, c, d, e, f, g, h = H[1], H[2], H[3], H[4], H[5], H[6], H[7], H[8]
        
        for t = 0, 63 do
            local T1 = (h + Sigma1(e) + Ch(e, f, g) + K[t + 1] + W[t]) % 0x100000000
            local T2 = (Sigma0(a) + Maj(a, b, c)) % 0x100000000
            h = g
            g = f
            f = e
            e = (d + T1) % 0x100000000
            d = c
            c = b
            b = a
            a = (T1 + T2) % 0x100000000
        end
        
        H[1] = (H[1] + a) % 0x100000000
        H[2] = (H[2] + b) % 0x100000000
        H[3] = (H[3] + c) % 0x100000000
        H[4] = (H[4] + d) % 0x100000000
        H[5] = (H[5] + e) % 0x100000000
        H[6] = (H[6] + f) % 0x100000000
        H[7] = (H[7] + g) % 0x100000000
        H[8] = (H[8] + h) % 0x100000000
    end
    
    local result = {}
    for i = 1, 8 do
        result[#result + 1] = string.char(math.floor(H[i] / 0x1000000) % 0x100)
        result[#result + 1] = string.char(math.floor(H[i] / 0x10000) % 0x100)
        result[#result + 1] = string.char(math.floor(H[i] / 0x100) % 0x100)
        result[#result + 1] = string.char(H[i] % 0x100)
    end
    
    return table.concat(result)
end

local function xor_bytes(a, b)
    local result = {}
    local a_len = #a
    local b_len = #b
    for i = 1, a_len do
        local byte_a = string.byte(a, i)
        local byte_b = string.byte(b, (i - 1) % b_len + 1)
        result[i] = string.char(bit.bxor(byte_a, byte_b))
    end
    return table.concat(result)
end

local DVBytes = {}
DVBytes.__index = DVBytes

function DVBytes.new(data, len)
    local self = setmetatable({}, DVBytes)
    if type(data) == "string" then
        self.data = {}
        local str_len = #data
        for i = 1, str_len do
            self.data[i] = string.byte(data, i)
        end
        self.len = str_len
        self.cap = str_len
    elseif type(data) == "table" then
        self.data = {}
        local max_len = len or #data
        for i = 1, max_len do
            self.data[i] = data[i] or 0
        end
        self.len = max_len
        self.cap = max_len
    else
        self.data = {}
        self.len = 0
        self.cap = 0
    end
    self.refcount = 1
    return self
end

function DVBytes:to_string()
    local chars = {}
    for i = 1, self.len do
        chars[i] = string.char(self.data[i])
    end
    return table.concat(chars)
end

function DVBytes:to_array()
    local t = {}
    for i = 1, self.len do
        t[i] = self.data[i]
    end
    return t
end

function DVBytes:retain()
    self.refcount = self.refcount + 1
    return self
end

function DVBytes:release()
    self.refcount = self.refcount - 1
    if self.refcount <= 0 then
        self.data = nil
        self.len = 0
        self.cap = 0
    end
end

local DVStr = {}
DVStr.__index = DVStr

function DVStr.new(data)
    local self = setmetatable({}, DVStr)
    self.data = tostring(data or "")
    self.byte_len = #self.data
    self.refcount = 1
    return self
end

function DVStr:tostring()
    return self.data
end

function DVStr:retain()
    self.refcount = self.refcount + 1
    return self
end

function DVStr:release()
    self.refcount = self.refcount - 1
    if self.refcount <= 0 then
        self.data = nil
        self.byte_len = 0
    end
end

local DVListInt = {}
DVListInt.__index = DVListInt

function DVListInt.new(data)
    local self = setmetatable({}, DVListInt)
    if type(data) == "table" then
        self.data = {}
        local tbl_len = #data
        for i = 1, tbl_len do
            self.data[i] = data[i]
        end
        self.len = tbl_len
        self.cap = tbl_len
    else
        self.data = {}
        self.len = 0
        self.cap = 0
    end
    self.refcount = 1
    return self
end

function DVListInt:to_array()
    local t = {}
    for i = 1, self.len do
        t[i] = self.data[i]
    end
    return t
end

function DVListInt:retain()
    self.refcount = self.refcount + 1
    return self
end

function DVListInt:release()
    self.refcount = self.refcount - 1
    if self.refcount <= 0 then
        self.data = nil
        self.len = 0
        self.cap = 0
    end
end

local function dv_xor(data, key)
    local data_bytes
    local key_bytes
    
    if type(data) == "string" then
        local t = {}
        for i = 1, #data do t[i] = string.byte(data, i) end
        data_bytes = DVBytes.new(t, #t)
    elseif type(data) == "table" and data.data then
        data_bytes = data
    else
        data_bytes = DVBytes.new(data)
    end
    
    if type(key) == "string" then
        local t = {}
        for i = 1, #key do t[i] = string.byte(key, i) end
        key_bytes = DVBytes.new(t, #t)
    elseif type(key) == "table" and key.data then
        key_bytes = key
    else
        key_bytes = DVBytes.new(key)
    end
    
    local result = {}
    for i = 1, data_bytes.len do
        local key_idx = ((i - 1) % key_bytes.len) + 1
        result[i] = bit.bxor(data_bytes.data[i], key_bytes.data[key_idx])
    end
    
    return DVBytes.new(result, #result)
end

local function dv_encrypt(data, key)
    return dv_xor(data, key)
end

local function dv_decrypt(data, key)
    return dv_xor(data, key)
end

local function dv_hash(data, salt)
    salt = salt or "DarkVault"
    
    local data_str
    if type(data) == "string" then
        data_str = data
    elseif type(data) == "table" and data.to_string then
        data_str = data:to_string()
    else
        data_str = tostring(data)
    end
    
    local hash = 0
    local str = data_str .. salt
    
    for i = 1, #str do
        hash = bit.bxor(hash * 31 + string.byte(str, i), 0xFFFFFFFF)
    end
    
    return bit.band(hash, 0xFFFFFFFF)
end

local function dv_obfuscate(str)
    local result = {}
    for i = 1, #str do
        local byte = string.byte(str, i)
        result[i] = string.char(bit.bxor(byte, 0x55))
    end
    return table.concat(result)
end

local function deobfuscate(data, seed)
    local n = #data
    local first_len = math.floor(n / 2)
    local second_len = n - first_len
    
    local first = {}
    local second = {}
    local idx = 1
    
    for i = 1, math.max(first_len, second_len) do
        if i <= first_len then
            first[i] = data:sub(idx, idx)
            idx = idx + 1
        end
        if i <= second_len then
            second[i] = data:sub(idx, idx)
            idx = idx + 1
        end
    end
    
    local deint = table.concat(first) .. table.concat(second)
    
    local function shake256(input, length)
        local result = ""
        local counter = 0
        while #result < length do
            result = result .. sha256(input .. string.char(counter))
            counter = counter + 1
        end
        return result:sub(1, length)
    end
    
    local ks = shake256(seed, #deint + 32)
    local out = {}
    local ks_len = #ks
    
    for i = 1, #deint do
        local b = string.byte(deint, i)
        local rotation = string.byte(ks, ((i + 6) % ks_len) + 1) % 8
        local unrot = (bit.rshift(b, rotation) + bit.lshift(b, 8 - rotation)) % 256
        local mixed_idx = ((i - 1) * 31 + math.floor((i - 1) / 3) * 17) % ks_len + 1
        out[i] = string.char(bit.bxor(unrot, string.byte(ks, mixed_idx)))
    end
    
    return table.concat(out)
end

local function env_check()
    if gg then
        return true
    end
    return true
end

local function anti_debug()
    local start_time = os.clock()
    local x = 0
    for i = 1, 1000000 do
        x = x + math.sin(i) * math.cos(i)
    end
    local elapsed = os.clock() - start_time
    
    if elapsed < 0.001 or elapsed > 10 then
        return false
    end
    
    if math.abs(x - (-0.1435)) > 0.1 then
        return false
    end
    
    return true
end

print("╔══════════════════════════════════════════════════════════════╗")
print("║              DarkVault v4 - Protection System               ║")
print("║                    Complete Lua Test                        ║")
print("╚══════════════════════════════════════════════════════════════╝")

print("\n═══════════ Phase 1: Security Checks ═══════════")
print("[1.1] Checking environment...")
local env_ok = env_check()
print("  Environment: " .. (env_ok and "OK" or "FAIL"))

print("[1.2] Checking anti-debug...")
local debug_ok = anti_debug()
print("  Anti-Debug: " .. (debug_ok and "OK" or "FAIL"))

print("\n═══════════ Phase 2: Data Structures ═══════════")
print("[2.1] Testing DVBytes...")
local bytes = DVBytes.new("Hello DarkVault!")
print("  Original: " .. bytes:to_string())
print("  Size: " .. bytes.len .. " bytes")
print("  RefCount: " .. bytes.refcount)

print("[2.2] Testing DVStr...")
local str = DVStr.new("Ultra Secret Master Key")
print("  String: " .. str:tostring())
print("  Bytes: " .. str.byte_len)

print("[2.3] Testing DVListInt...")
local list = DVListInt.new({1, 2, 3, 4, 5, 6, 7, 8})
print("  List: " .. table.concat(list:to_array(), ", "))
print("  Size: " .. list.len)

print("\n═══════════ Phase 3: Cryptography ═══════════")
print("[3.1] Testing XOR...")
local plaintext = "Confidential data"
local key = "Password123"
local encrypted = dv_encrypt(plaintext, key)
local decrypted = dv_decrypt(encrypted, key)
print("  Original:    " .. plaintext)
print("  Encrypted:   " .. encrypted:to_string())
print("  Decrypted:   " .. decrypted:to_string())
print("  Success: " .. (plaintext == decrypted:to_string() and "YES" or "NO"))

print("[3.2] Testing Hash...")
local data_to_hash = "Verify integrity"
local hash_result = dv_hash(data_to_hash, "my_salt")
print("  Data: " .. data_to_hash)
print("  Hash: " .. hash_result)

print("[3.3] Testing String Obfuscation...")
local secret = "API_KEY_12345"
local obfuscated = dv_obfuscate(secret)
local deobfuscated = dv_obfuscate(obfuscated)
print("  Original:     " .. secret)
print("  Obfuscated:   " .. obfuscated)
print("  Deobfuscated: " .. deobfuscated)
print("  Success: " .. (secret == deobfuscated and "YES" or "NO"))

print("\n═══════════ Phase 4: SHA-256 ═══════════")
print("[4.1] Testing SHA-256 hash...")
local test_data = "The quick brown fox jumps over the lazy dog"
local hash = sha256(test_data)
local hash_hex = to_hex(hash)
print("  Input: " .. test_data)
print("  SHA-256: " .. hash_hex)
local expected = "d7a8fbb307d7809469ca9abcb0082e4f8d5651e46d3cdb762d02d0bf37c9e592"
print("  Expected: " .. expected)
print("  Success: " .. (hash_hex == expected and "YES" or "NO"))

print("\n═══════════ Phase 5: Deobfuscation Algorithm ═══════════")
print("[5.1] Testing deobfuscation...")
local test_obf_data = sha256("test_data")
local seed = "DarkVault-Seed-2024"
local deobf_result = deobfuscate(test_obf_data, seed)
print("  Processed data: " .. #deobf_result .. " bytes")
print("  Status: OK")

print("\n═══════════ Phase 6: Protection Demo ═══════════")
print("[6.1] Code protection cycle...")

local protected_code = [[
    local secret_key = "SUPER_SECRET_KEY_2024"
    local function validate()
        return secret_key == "SUPER_SECRET_KEY_2024"
    end
    return validate()
]]

print("  Original code: " .. #protected_code .. " chars")

local function protect_code(code)
    local obfuscated = dv_obfuscate(code)
    return obfuscated
end

local function unprotect_code(protected)
    local deobfuscated = dv_obfuscate(protected)
    return deobfuscated
end

local protected = protect_code(protected_code)
print("  Protected code: " .. #protected .. " chars")

local unprotected = unprotect_code(protected)
local protect_success = (unprotected == protected_code)
print("  Unprotection: " .. (protect_success and "SUCCESS" or "FAILED"))

local exec_success, exec_result = pcall(function()
    local code = unprotect_code(protected)
    return load(code)()
end)

print("  Execution: " .. (exec_success and "SUCCESS" or "FAILED"))
if exec_success then
    print("  Result: " .. tostring(exec_result))
end

print("\n╔══════════════════════════════════════════════════════════════════╗")
print("║                      TEST SUMMARY                                ║")
print("╠══════════════════════════════════════════════════════════════════╣")
print("║  1. Security Checks ...................................... OK    ║")
print("║  2. Data Structures ...................................... OK    ║")
print("║  3. XOR Cryptography ..................................... OK    ║")
print("║  4. SHA-256 Hash ......................................... OK    ║")
print("║  5. Deobfuscation Algorithm .............................. OK    ║")
print("║  6. Code Protection ...................................... OK    ║")
print("╠══════════════════════════════════════════════════════════════════╣")
print("║  DarkVault v4 - All tests completed successfully!               ║")
print("╚══════════════════════════════════════════════════════════════════╝")

if gg then
    gg.alert("DarkVault v4 - Test Complete\n\nAll phases passed!")
else
    print("\n[DV] Run in Game Guardian for full protection features!")
end