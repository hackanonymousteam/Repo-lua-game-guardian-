local ULTIMATE = {}

ULTIMATE.last = "/sdcard/"
ULTIMATE.info = nil
ULTIMATE.config = gg.EXT_CACHE_DIR .. "/" .. gg.getFile():match("[^/]+$") .. "ULTIMATE.cfg"
ULTIMATE.data = loadfile(ULTIMATE.config)

if ULTIMATE.data ~= nil then
    ULTIMATE.info = ULTIMATE.data()
    ULTIMATE.data = nil
end

if ULTIMATE.info == nil then
    ULTIMATE.info = { ULTIMATE.last, ULTIMATE.last:gsub("/[^/]+$", ""), false }
end

while true do
    ULTIMATE.info = gg.prompt({
        '📁 SCRIPT TO PROTECT:',
        '📁 OUTPUT FOLDER:'

    }, ULTIMATE.info, {
        'file',
        'path'
        
    })

    if ULTIMATE.info == nil then 
        gg.alert("❌ CANCELLED")
        os.exit()
    end

    gg.saveVariable(ULTIMATE.info, ULTIMATE.config)
    ULTIMATE.last = ULTIMATE.info[1]

    if loadfile(ULTIMATE.last) == nil then
        gg.alert("⚠️ SCRIPT NOT FOUND!")
        return
    else
        ULTIMATE.out = ULTIMATE.last:match("[^/]+$")
        ULTIMATE.out = ULTIMATE.out:gsub("%.lua$", "")
        ULTIMATE.out = ULTIMATE.info[2] .. "/" .. ULTIMATE.out .. ".PROTECTED.lua"
    end

    local file = io.open(ULTIMATE.last, "r")
    local ORIGINAL = file:read('*a')
    file:close()

    local function random_name()
        local chars = {}
        local length = math.random(8, 15)
        for i = 1, length do
            chars[i] = string.char(math.random(97, 122))
        end
        return "_" .. table.concat(chars) .. "_"
    end

    local function shuffle_table(t)
        local n = #t
        while n > 1 do
            local k = math.random(n)
            t[n], t[k] = t[k], t[n]
            n = n - 1
        end
        return t
    end

    local function super_encode(str)
        local bytes = {}
        local transforms = {}

        for i = 1, 5 do
            transforms[i] = math.random(10, 99)
        end

        local function mod(x)
            x = x % 256
            if x < 0 then x = x + 256 end
            return x
        end

        for i = 1, #str do
            local b = string.byte(str, i)
            b = mod(b + transforms[1])
            b = mod(b + transforms[2])
            b = mod(b - transforms[3])
            b = mod(b + (i * transforms[4]))
            b = mod(b + transforms[5])
            bytes[i] = b
        end

        return bytes, transforms
    end

    local function create_obfuscated_decoder(transforms, bytes)
        local func_name = random_name()
        local decoder = {}

      --  decoder[#decoder+1] = "-- PROTECTED SCRIPT"
        decoder[#decoder+1] = "local encrypted = {" .. table.concat(bytes, ",") .. "}"
        decoder[#decoder+1] = "local t1=" .. transforms[1]
        decoder[#decoder+1] = "local t2=" .. transforms[2]
        decoder[#decoder+1] = "local t3=" .. transforms[3]
        decoder[#decoder+1] = "local t4=" .. transforms[4]
        decoder[#decoder+1] = "local t5=" .. transforms[5]
        decoder[#decoder+1] = "local function " .. func_name .. "()"
        decoder[#decoder+1] = "  local out = {}"
        decoder[#decoder+1] = "  for i=1,#encrypted do"
        decoder[#decoder+1] = "    local b = encrypted[i]"
        decoder[#decoder+1] = "    b = (b - t5) % 256"
        decoder[#decoder+1] = "    b = (b - (i * t4)) % 256"
        decoder[#decoder+1] = "    b = (b + t3) % 256"
        decoder[#decoder+1] = "    b = (b - t2) % 256"
        decoder[#decoder+1] = "    b = (b - t1) % 256"
        decoder[#decoder+1] = "    if b < 0 then b = b + 256 end"
        decoder[#decoder+1] = "    out[i] = string.char(b)"
        decoder[#decoder+1] = "  end"
        decoder[#decoder+1] = "  return table.concat(out)"
        decoder[#decoder+1] = "end"
        decoder[#decoder+1] = "local src = " .. func_name .. "()"
        decoder[#decoder+1] = "local f = load(src)"
        decoder[#decoder+1] = "if f then f() else gg.alert('DECODE ERROR') os.exit() end"

        return table.concat(decoder, "\n")
    end

    local encoded_bytes, transforms = super_encode(ORIGINAL)
    local decoder_code = create_obfuscated_decoder(transforms, encoded_bytes)
    local final_code = {}


    
    final_code[#final_code + 1] = decoder_code
    final_code = shuffle_table(final_code)
    local final = table.concat(final_code, "\n\n")
    local out = io.open(ULTIMATE.out, "w")
    out:write(final)
    out:close()

    local msg = "✅ PROTECTION COMPLETE!\n"
    msg = msg .. "📁 SAVED: " .. ULTIMATE.out .. "\n"
    
    gg.alert(msg)
    print("\n" .. string.rep("═", 50))
    print(msg)
    print(string.rep("═", 50))
    
    return
end