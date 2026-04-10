local chat = gg.prompt({'Enter number'}, {}, {'text'})
if chat == nil then
    return
end

local HexToModify = tonumber(chat[1])

if HexToModify == nil then
    gg.alert("Invalid input. Please enter a valid number.")
    os.exit()
end

if HexToModify > 65536 then
    gg.alert("Number can't be above 65536.")
    os.exit()
end

function armtohex(fullarm)
    local fullhex = ""
    local addr = gg.getRangesList('libc.so')
    
    if addr == nil or #addr == 0 then
        gg.alert("Error: Could not find 'libc.so' memory range.")
        return nil
    end
    
    for i, v in ipairs(addr) do
        if v.type:sub(2, 2) == 'w' then
            addr = {{address = v.start, flags = gg.TYPE_DWORD}}
            break
        end
    end

    if not addr[1].address then
        gg.alert("Error: Failed to get valid address.")
        return nil
    end

    local old = gg.getValues(addr)
    addr[1].value = '~A8 ' .. fullarm
    local success, err = pcall(gg.setValues, addr)

    if not success then
        gg.alert("Error occurred while converting ARM code to hex: " .. err)
        return nil
    end

    local out = gg.getValues(addr)
    out = out[1].value & 0xFFFFFFFF
    gg.setValues(old)

    out = string.unpack('>I4', string.pack('<I4', out))
    fullhex = string.format('%08X', out)
    
    return fullhex .. "C0035FD6"
end

local HexToModify2 = armtohex("mov w0, #" .. HexToModify .. " ;ret")

if HexToModify2 then
    print(HexToModify2)
else
    print("Error: Conversion returned nil.")
end