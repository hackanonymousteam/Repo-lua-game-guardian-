
function hex() 
enc = gg.choice({
"Read only hex in game lib", 
"read and edit game hex",
"exit"
},0,"")
if enc == 1 then v3() end
if enc == 2 then v1() end
if enc == 3 then os.exit() end

BATMAN = -1
end

 function v1() 

local function hexToAscii(hex)
    local ascii = ""
    for i = 1, #hex, 2 do
        local byte = tonumber(hex:sub(i, i+1), 16)
        if byte >= 32 and byte <= 126 then
            ascii = ascii .. string.char(byte)
        else
            ascii = ascii .. "."
        end
    end
    return ascii
end

local function START()
    local menu = gg.choice({
        "➣ libil2cpp",
        "➣ libunity",
        "➣ libanogs",
        " ❎exit ❎ "
    })

    if menu == nil then return end 

    local lib = ""
    if menu == 1 then
        lib = "il2cpp"
    elseif menu == 2 then
        lib = "unity"
    elseif menu == 3 then
        lib = "anogs"
    elseif menu == 4 then
        gg.toast("exit...")
        os.exit()
    else
        return
    end

    local info = gg.getTargetInfo()
    local localpack = info.nativeLibraryDir
    local libPath = localpack .. "/lib" .. lib .. ".so"

    local t = gg.getRangesList(libPath)
    if #t == 0 then
        gg.alert("no found: " .. libPath)
        return
    end
    
    local input = gg.prompt({"enter address:"}, {"0"}, {"text"})
    if input == nil or not input[1] then
        input[1] = "0"
    end
    local noob = tonumber(input[1], 16)
    
    local startAddress = t[1].start + noob

    local _rw = {}
    for i = 1, 32 do
        _rw[i] = { address = startAddress + (i - 1), flags = gg.TYPE_BYTE }
    end

    local values = gg.getValues(_rw)
    local hexString = ""

    for i = 1, #values do
        hexString = hexString .. string.format("%02X ", values[i].value & 0xFF)
        
        if i % 8 == 0 then
            hexString = hexString .. "\n"
        end
    end

    hexString = hexString:sub(1, -2)

    local group1 = ""
    local group2 = ""
    local group3 = ""
    local group4 = ""

    for i = 1, 8 do
        group1 = group1 .. string.format("%02X ", values[i].value & 0xFF)
    end
    for i = 9, 16 do
        group2 = group2 .. string.format("%02X ", values[i].value & 0xFF)
    end
    for i = 17, 24 do
        group3 = group3 .. string.format("%02X ", values[i].value & 0xFF)
    end
    for i = 25, 32 do
        group4 = group4 .. string.format("%02X ", values[i].value & 0xFF)
    end

    local asciiGroup1 = hexToAscii(group1:gsub(" ", ""))
    local asciiGroup2 = hexToAscii(group2:gsub(" ", ""))
    local asciiGroup3 = hexToAscii(group3:gsub(" ", ""))
    local asciiGroup4 = hexToAscii(group4:gsub(" ", ""))

    local adress1 = noob + 0x0
    local adress2 = noob + 0x8
    local adress3 = noob + 0x10
    local adress4 = noob + 0x18

    local sph = gg.prompt({
        "0x" .. string.format("%X", adress1),
        "0x" .. string.format("%X", adress2),
        "0x" .. string.format("%X", adress3),
        "0x" .. string.format("%X", adress4)
    },
    {group1 .. "                   " .. asciiGroup1, 
     group2 .. "                  " .. asciiGroup2, 
     group3 .. "                   " .. asciiGroup3,
     group4 .. "                   " .. asciiGroup4}, 
    {"text", "text", "text", "text"} 
    )

    if sph == nil then return end

    local newValues = {}
    local editedGroups = {sph[1], sph[2], sph[3], sph[4]}
    
    for i = 1, 4 do
        local startIdx = (i - 1) * 8 + 0
        local endIdx = i * 8
        local groupHex = editedGroups[i]:match("^[0-9A-Fa-f%s]+")
        
        if groupHex then
            for j = 1, 8 do
                local byteHex = groupHex:sub((j-1)*3 + 1, j*3 - 1)
                local byteVal = tonumber(byteHex, 16)
                if byteVal then
                    table.insert(newValues, { address = startAddress + (startIdx + j - 1), value = byteVal, flags = gg.TYPE_BYTE })
                end
            end
        end
    end

    gg.setValues(newValues)
    gg.toast("Memory updated successfully!")
end

START()
end

 function v3() 
local function hexToAscii(hex)
    local ascii = ""
    for i = 1, #hex, 2 do
        local byte = tonumber(hex:sub(i, i+1), 16)
        if byte >= 32 and byte <= 126 then
            ascii = ascii .. string.char(byte)
        else
            ascii = ascii .. "."
        end
    end
    return ascii
end

local function START()
    local menu = gg.choice({
        "➣ libil2cpp",
        "➣ libunity",
        "➣ libanogs",
        " ❎exit ❎ "
    })

    if menu == nil then return end 

    local lib = ""
    if menu == 1 then
        lib = "il2cpp"
    elseif menu == 2 then
        lib = "unity"
    elseif menu == 3 then
        lib = "anogs"
    elseif menu == 4 then
        gg.toast("exit...")
        os.exit()
    else
        return
    end

    local info = gg.getTargetInfo()
    local localpack = info.nativeLibraryDir
    local libPath = localpack .. "/lib" .. lib .. ".so"

    local t = gg.getRangesList(libPath)
    if #t == 0 then
        gg.alert("no found: " .. libPath)
        return
    end
    
    local input = gg.prompt({"enter hex address:"}, {"0"}, {"text"})
    if input == nil or not input[1] then
               input[1] = "0"
    end
    local noob = input[1]
    
    local startAddress = t[1].start + tonumber(noob, 16)

    local _rw = {}
    for i = 1, 32 do
        _rw[i] = { address = startAddress + (i - 1), flags = gg.TYPE_BYTE }
    end

    local values = gg.getValues(_rw)
    local hexString = ""

    for i = 1, #values do
        hexString = hexString .. string.format("%02X ", values[i].value & 0xFF)
        
        if i % 8 == 0 then
            hexString = hexString .. "\n"
        end
    end
    
    hexString = hexString:sub(1, -2)

    local group1 = ""
    local group2 = ""
    local group3 = ""
    local group4 = ""

    for i = 1, 8 do
        group1 = group1 .. string.format("%02X ", values[i].value & 0xFF)
    end
    for i = 9, 16 do
        group2 = group2 .. string.format("%02X ", values[i].value & 0xFF)
    end
    for i = 17, 24 do
        group3 = group3 .. string.format("%02X ", values[i].value & 0xFF)
    end
    for i = 25, 32 do
        group4 = group4 .. string.format("%02X ", values[i].value & 0xFF)
    end
    
    local asciiGroup1 = hexToAscii(group1:gsub(" ", ""))
    local asciiGroup2 = hexToAscii(group2:gsub(" ", ""))
    local asciiGroup3 = hexToAscii(group3:gsub(" ", ""))
    local asciiGroup4 = hexToAscii(group4:gsub(" ", ""))
    
    local choices = {
        group1 .. "                     " .. asciiGroup1,
        group2 .. "                     " .. asciiGroup2,
        group3 .. "                     " .. asciiGroup3,
        group4 .. "                     " .. asciiGroup4
    }

    local choice = gg.choice(choices, nil, 'lib'..lib)
    if choice == nil then return end

    print(choices[choice])
    gg.copyText(choices[choice])
end

START()
end

while(true)do if gg.isVisible(true)then BATMAN = 1 gg.setVisible(false)end
if BATMAN == 1 then hex()end
end