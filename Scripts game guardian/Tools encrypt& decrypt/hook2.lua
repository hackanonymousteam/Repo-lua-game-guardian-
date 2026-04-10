gg.setRanges(gg.REGION_CODE_APP)

-- Function to validate the environment
function validateEnvironment()
    -- Checking if the app is running on a supported device/environment
    if gg.getTargetInfo().name ~= "ExpectedGameName" then
        gg.alert("Invalid game environment. Please run the script in the correct game.")
        return false
    end
    
    -- Additional checks can be added here (for example, checking for virtualization, root status, etc.)
    
    return true
end

-- Start Fuzzy Search only if environment validation passes
if not validateEnvironment() then
    return
end

gg.startFuzzy(gg.TYPE_DWORD)
gg.alert('ᴄʟɪᴄᴋ ᴀɢᴀɪɴ ɪғ ʏᴏᴜʀ ᴅᴏɴᴇ')

function generateSetvalueCode(address, offset, value)
    return string.format('so = gg.getRangesList("%s")[1].start\nsetvalue(so + 0x%X, 4, "h%08X")', address, offset, value)
end

function convertResultsToOffsets(baseAddr, address)
    return address - baseAddr
end

function findLibraryForAddress(address)
    local ranges = gg.getRangesList("")
    for _, range in ipairs(ranges) do
        if address >= range.start and address <= range["end"] then
            return range
        end
    end
    return nil
end

function getLibraryName(path)
    local name = path:match(".+/([^/]+)%.so")
    return name or "ᴜɴᴋɴᴏᴡɴ-ʟɪʙ"
end

function writeToFile(filePath, output, includeSetValue)
    local file, err = io.open(filePath, "w")
    if file then
        file:write("-- Created by @lokiivc\n")
        file:write("-- Telegram link https://t.me/lokiivch\n")
        file:write("-- Dm me if you have a suggestion 💐\n")
        file:write("\n")
        if includeSetValue then
            file:write("function setvalue(address, flags, value)\n")
            file:write("  local refinevalues = {}\n")
            file:write("  refinevalues[1] = {}\n")
            file:write("  refinevalues[1].address = address\n")
            file:write("  refinevalues[1].flags = flags\n")
            file:write("  refinevalues[1].value = value\n")
            file:write("  gg.setValues(refinevalues)\n")
            file:write("end\n\n")
        end
        file:write(table.concat(output, "\n"))
        file:close()
        gg.alert("ʀᴇsᴜʟᴛs sᴀᴠᴇᴅ ᴛᴏ " .. filePath)
    else
        gg.alert("ᴇʀʀᴏʀ ᴡʀɪᴛɪɴɢ ᴛᴏ ғɪʟᴇ: " .. (err or "unknown error"))
    end
end

function doAction()
    gg.searchFuzzy("0", gg.SIGN_FUZZY_NOT_EQUAL, gg.TYPE_DWORD)
    local results = gg.getResults(gg.getResultsCount())
    if #results == 0 then
        gg.alert("ɴᴏ ʀᴇsᴜʟᴛs ғᴏᴜɴᴅ.")
        return
    end
    
    local alertOption = gg.choice({"ᴅɪsᴘʟᴀʏ ғᴜʟʟ ʜᴇxᴘᴀᴛᴄʜᴇs?", "ᴅɪsᴘʟᴀʏ ᴏғғsᴇᴛ ᴏɴʟʏ?", "ᴅɪsᴘʟᴀʏ sᴇᴛᴠᴀʟᴜᴇ ᴄᴏᴅᴇ?"}, nil, "ᴄʜᴏᴏsᴇ ʏᴏᴜʀ ᴘʀᴇғᴇʀʀᴇᴅ ᴏᴜᴛᴘᴜᴛ🤖")
    if alertOption == nil then
        gg.alert("No option selected.")
        return
    end
    
    local hexPatchOutput = {}
    local offsetOnlyOutput = {}
    local setValueOutputs = {}
    
    for _, result in ipairs(results) do
        local maskedValue = result.value & 0xFFFFFFFF
        local range = findLibraryForAddress(result.address)
        if range then
            local libBaseAddr = range.start
            local detectedLibName = range.internalName and range.internalName:match("([^/]+)%.so") or getLibraryName(range.fileName)
            detectedLibName = detectedLibName .. ".so"
            local offset = convertResultsToOffsets(libBaseAddr, result.address)
            local setvalueCode = generateSetvalueCode(detectedLibName, offset, maskedValue)
            
            if alertOption == 1 then
                table.insert(hexPatchOutput, string.format('HexPatches.unohook("%s", 0x%X, "h%08X", 4);', detectedLibName, offset, maskedValue))
            elseif alertOption == 2 then
                table.insert(offsetOnlyOutput, string.format('%s 0x%X', detectedLibName, offset))
            elseif alertOption == 3 then
                if not setValueOutputs[detectedLibName] then
                    setValueOutputs[detectedLibName] = {}
                end
                table.insert(setValueOutputs[detectedLibName], setvalueCode)
            end
        end
    end
    
    if alertOption == 1 or alertOption == 2 then
        writeToFile("/storage/emulated/0/hooksubject.lua", alertOption == 1 and hexPatchOutput or offsetOnlyOutput, false)
    elseif alertOption == 3 then
        for libName, output in pairs(setValueOutputs) do
            writeToFile("/storage/emulated/0/hooktexttt/" .. libName .. "-hook.lua", output, true)
        end
    end
end

doAction()