local bit32 = require("bit32")

local bxor = bit32.bxor
local bor = bit32.bor
local band = bit32.band
local bnot = bit32.bnot
local lshift = bit32.lshift
local rshift = bit32.rshift

local function rol(x, n)
    return bor(lshift(x, n), rshift(x, 32 - n))
end

local srep = string.rep
local schar = string.char
local sbyte = string.byte
local sub = string.sub
local tremove = table.remove
local tinsert = table.insert
local tconcat = table.concat
local mrandom = math.random

local function read_n_bytes(str, pos, n)
    pos = pos or 1
    return pos + n, sbyte(str, pos, pos + n - 1)
end

local function read_int8(str, pos)
    return read_n_bytes(str, pos, 1)
end

local function read_int16(str, pos)
    local new_pos, a, b = read_n_bytes(str, pos, 2)
    return new_pos, lshift(a, 8) + b
end

local function read_int32(str, pos)
    local new_pos, a, b, c, d = read_n_bytes(str, pos, 4)
    return new_pos, lshift(a, 24) + lshift(b, 16) + lshift(c, 8) + d
end

local function write_int8(v)
    return schar(band(v, 0xFF))
end

local function write_int16(v)
    return schar(
        band(rshift(v, 8), 0xFF),
        band(v, 0xFF)
    )
end

local function write_int32(v)
    return schar(
        band(rshift(v, 24), 0xFF),
        band(rshift(v, 16), 0xFF),
        band(rshift(v, 8), 0xFF),
        band(v, 0xFF)
    )
end

math.randomseed(os.time())

local function sha1_wiki(msg)
    local h0 = 0x67452301
    local h1 = 0xEFCDAB89
    local h2 = 0x98BADCFE
    local h3 = 0x10325476
    local h4 = 0xC3D2E1F0
    
    local bits = #msg * 8
    
    msg = msg .. schar(0x80)
    
    local bytes = #msg + 8
    local fill_bytes = 64 - (bytes % 64)
    
    if fill_bytes ~= 64 then 
        msg = msg .. srep(schar(0), fill_bytes) 
    end
    
    local high = math.floor(bits / 2^32)
    local low = bits - high * 2^32
    msg = msg .. write_int32(high) .. write_int32(low)
    
    for j = 1, #msg, 64 do
        local chunk = sub(msg, j, j + 63)
        local words = {}
        local next = 1
        local word
        
        repeat
            next, word = read_int32(chunk, next)
            tinsert(words, word)        
        until next > 64
        
        for i = 17, 80 do
            words[i] = bxor(words[i-3], words[i-8], words[i-14], words[i-16])
            words[i] = rol(words[i], 1)
        end
        
        local a, b, c, d, e = h0, h1, h2, h3, h4
        
        for i = 1, 80 do
            local k, f
            
            if i <= 20 then
                f = bor(band(b, c), band(bnot(b), d))
                k = 0x5A827999
            elseif i <= 40 then
                f = bxor(b, c, d)
                k = 0x6ED9EBA1
            elseif i <= 60 then
                f = bor(band(b, c), band(b, d), band(c, d))
                k = 0x8F1BBCDC
            else
                f = bxor(b, c, d)
                k = 0xCA62C1D6
            end
            
            local temp = rol(a, 5) + f + e + k + words[i]
            temp = band(temp, 0xFFFFFFFF)
            
            e = d
            d = c
            c = rol(b, 30)
            b = a
            a = temp
        end
        
        h0 = band(h0 + a, 0xFFFFFFFF)
        h1 = band(h1 + b, 0xFFFFFFFF)
        h2 = band(h2 + c, 0xFFFFFFFF)
        h3 = band(h3 + d, 0xFFFFFFFF)
        h4 = band(h4 + e, 0xFFFFFFFF)
    end
    
    return write_int32(h0) .. write_int32(h1) .. write_int32(h2) .. 
           write_int32(h3) .. write_int32(h4)
end

local DEFAULT_PORTS = {ws = 80, wss = 443}

local function parse_url(url)
    local protocol, address, uri = url:match("^(%w+)://([^/]+)(.*)$")
    
    if not protocol then 
        error("Invalid URL: " .. tostring(url))
    end

    protocol = protocol:lower()
    local host, port = address:match("^(.+):(%d+)$")

    if not host then
        host = address
        port = DEFAULT_PORTS[protocol]
    end

    if not uri or uri == "" then 
        uri = "/" 
    end

    return protocol, host, tonumber(port), uri
end

local function generate_key()
    local r1 = mrandom(0, 0xfffffff)
    local r2 = mrandom(0, 0xfffffff)
    local r3 = mrandom(0, 0xfffffff)
    local r4 = mrandom(0, 0xfffffff)
    
    return write_int32(r1) .. write_int32(r2) .. write_int32(r3) .. write_int32(r4)
end

print("=== Testing bit32 functions ===\n")

local key = generate_key()
print("1. Generated key (16 bytes in hex):")
for i = 1, #key do
    io.write(string.format("%02X ", string.byte(key, i)))
end
print("\nKey length: " .. #key .. " bytes\n")

local test_string = "Hello, World!"
local hash = sha1_wiki(test_string)
print("2. SHA-1 of '" .. test_string .. "':")
for i = 1, #hash do
    io.write(string.format("%02X", string.byte(hash, i)))
end
print("\nHash length: " .. #hash .. " bytes\n")

local url = "ws://example.com:8080/path"
local protocol, host, port, path = parse_url(url)
print("3. URL parsing: " .. url)
print("   Protocol: " .. protocol)
print("   Host: " .. host)
print("   Port: " .. port)
print("   Path: " .. path .. "\n")

local test_value = 0x12345678
local written = write_int32(test_value)
local _, read_back = read_int32(written, 1)
print("4. 32-bit integer write/read:")
print("   Original value: 0x" .. string.format("%08X", test_value))
print("   Written bytes: " .. 
    string.format("%02X %02X %02X %02X", 
        string.byte(written, 1),
        string.byte(written, 2),
        string.byte(written, 3),
        string.byte(written, 4)))
print("   Read value: 0x" .. string.format("%08X", read_back) .. "\n")

local empty_hash = sha1_wiki("")
print("5. SHA-1 of empty string:")
for i = 1, #empty_hash do
    io.write(string.format("%02X", string.byte(empty_hash, i)))
end
print("\n")

local long_string = string.rep("A", 100)
local long_hash = sha1_wiki(long_string)
print("6. SHA-1 of 100 bytes string 'A':")
for i = 1, #long_hash do
    io.write(string.format("%02X", string.byte(long_hash, i)))
end
print("\n")

print("7. Testing bit32 operations:")
local x = 0xF0F0F0F0
local y = 0x0F0F0F0F
print("   x = 0xF0F0F0F0")
print("   y = 0x0F0F0F0F")
print("   x xor y = 0x" .. string.format("%08X", bxor(x, y)))
print("   x and y = 0x" .. string.format("%08X", band(x, y)))
print("   x or y  = 0x" .. string.format("%08X", bor(x, y)))
print("   rol(x, 4) = 0x" .. string.format("%08X", rol(x, 4)))
print("   not x = 0x" .. string.format("%08X", bnot(x)))