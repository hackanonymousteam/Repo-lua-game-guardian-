
    local function findLibs(pattern)
    local foundLibs = {}
    local ranges = gg.getRangesList("")
    
    for _, v in ipairs(ranges) do
        if v.internalName:match(pattern) and v.state == "Xa" then
            table.insert(foundLibs, v)
        end
    end
    return foundLibs
end

local function setHexMemory(pattern, offset, hex)
    local libs = findLibs(pattern)
    if #libs == 0 then
        gg.alert("No matching libraries found!")
        return false
    end
    
    local t, total = {}, 0
    for h in string.gmatch(hex, "%S%S") do
        for _, lib in ipairs(libs) do
            table.insert(t, {
                address = lib.start + offset + total,
                flags = gg.TYPE_BYTE,
                value = h .. "r"
            })
        end
        total = total + 1
    end
    
    local res = gg.setValues(t)
    if type(res) ~= 'string' then
        return true
    else
        gg.alert(res)
        return false
    end
end

setHexMemory("split_config%.armeabi_v7a%.apk$", 0x4, "00 00 80 3F")

--lib split config armeabi_v7a

-- offset 0x4

-- edited for 00 00 80 3F hex(reverse) = 1 float


--or logic 64 bit 

--setHexMemory("split_config%.arm64_v8a%.apk$", 0x491D00, "01 02 03 04")

    