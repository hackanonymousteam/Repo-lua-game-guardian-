local function generateXORKey(length)
    local key = {}
    for i = 1, length do
        key[i] = math.random(65, 122)
    end
    return key
end

local function xorEncrypt(str, key)
    local encrypted = {}
    for i = 1, #str do
        local keyByte = key[((i - 1) % #key) + 1]
        encrypted[i] = string.char(string.byte(str, i) ~ keyByte)
    end
    return table.concat(encrypted)
end

local function generateRandomVarName(usedNames)
    local chars = "abcdefghijklmnopqrstuvwxyz"
    local length = math.random(2, 3)
    local name
    repeat
        name = ""
        for i = 1, length do
            local pos = math.random(1, #chars)
            name = name .. chars:sub(pos, pos)
        end
    until not usedNames[name]
    usedNames[name] = true
    return name
end

local function escapeString(str)
    return str:gsub("\\", "\\\\"):gsub("\"", "\\\""):gsub("\n", "\\n"):gsub("\r", "\\r"):gsub("\t", "\\t")
end

local function obfuscate(code)
    local usedVarNames = {}
    local strings = {}
    local modifiedCode = code
    local pattern = '(["\'])((.-))%1'
    local counter = 0
    
    for quote, content in modifiedCode:gmatch(pattern) do
        if content and #content > 0 then
            counter = counter + 1
            local fullMatch = quote .. content .. quote
            local placeholder = "§§STR" .. counter .. "§§"
            strings[counter] = content
            modifiedCode = modifiedCode:gsub(fullMatch:gsub("([%.%+%-%*%?%[%]%(%)%^%$%%])", "%%%1"), '"' .. placeholder .. '"', 1)
        end
    end
    
    if counter == 0 then
        return code
    end
    
    local keyLength = math.random(8, 16)
    local xorKey = generateXORKey(keyLength)
    local keyStr = ""
    for i = 1, #xorKey do
        keyStr = keyStr .. xorKey[i] .. ","
    end
    keyStr = keyStr:sub(1, -2)
    
    local encryptedStrings = {}
    for i = 1, counter do
        encryptedStrings[i] = escapeString(xorEncrypt(strings[i], xorKey))
    end
    
    local varDecrypt = generateRandomVarName(usedVarNames)
    local varKey = generateRandomVarName(usedVarNames)
    local varStrs = generateRandomVarName(usedVarNames)
    
    local output = {}
    
    table.insert(output, varKey .. "={" .. keyStr .. "}")
    
    local encryptedArray = ""
    for i = 1, #encryptedStrings do
        if encryptedArray ~= "" then
            encryptedArray = encryptedArray .. ","
        end
        encryptedArray = encryptedArray .. '"' .. encryptedStrings[i] .. '"'
    end
    table.insert(output, varStrs .. "={" .. encryptedArray .. "}")
    
    table.insert(output, "function " .. varDecrypt .. "(s,k)local r={}for i=1,#s do local kb=k[((i-1)%#k)+1]r[i]=string.char(string.byte(s,i)~kb)end return table.concat(r)end")
    
    local finalCode = modifiedCode
    for i = 1, counter do
        local placeholder = '"§§STR' .. i .. '§§"'
        finalCode = finalCode:gsub(placeholder, varDecrypt .. "(" .. varStrs .. "[" .. i .. "]," .. varKey .. ")", 1)
    end
    
    table.insert(output, "")
    table.insert(output, finalCode)
    
    return table.concat(output, "\n")
end

local function main()
    local g = {}
    g.last = "/sdcard/"
    g.info = nil
    g.config = gg.EXT_CACHE_DIR .. "/" .. gg.getFile():match("[^/]+$") .. "cfg"
    g.data = loadfile(g.config)
    
    if g.data ~= nil then
        g.info = g.data()
        g.data = nil
    end
    
    if g.info == nil then
        g.info = {g.last}
    end
    
    while true do
        g.info = gg.prompt({
            'Select .lua file:'
        }, g.info, {
            'file'
        })
        
        if not g.info or not g.info[1] then
            gg.alert("No file selected!")
            return
        end
        
        gg.saveVariable(g.info, g.config)
        g.last = g.info[1]
        
        if loadfile(g.last) == nil then
            gg.alert("Invalid .lua file!")
            return
        end
        
        local f = io.open(g.last, "r")
        if not f then
            gg.alert("Error opening file!")
            return
        end
        
        local data = f:read('*a')
        f:close()
        
        if not data or data == "" then
            gg.alert("File is empty!")
            return
        end
        
        g.out = g.last:match("[^/]+$")
        g.out = g.out:gsub("%.lua$", "")
        g.out = "/sdcard/" .. g.out .. ".encrypted.lua"
        
        gg.toast("Encrypting...")
        local encryptedCode = obfuscate(data)
        
        local out_file = io.open(g.out, "w")
        if not out_file then
            gg.alert("Error creating output file!")
            return
        end
        
        out_file:write(encryptedCode)
        out_file:close()
        
        gg.alert("Encryption completed!\n\n" ..
                 "File: " .. g.out:match("[^/]+$") .. "\n\n" ..
                 "by batman games")
        break
    end
end

main()