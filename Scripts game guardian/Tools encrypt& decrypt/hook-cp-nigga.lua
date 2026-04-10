function HOME()
    local menuOptions = gg.multiChoice({
        "HOOK BYPASS",
        "『 ᴇxɪᴛ 』"
    }, nil, " " .. os.date())
    
   if menuOptions == nil then return end
   if menuOptions[1] then B1() end
   if menuOptions[2] then EXIT() end
 
   menuOptions = -1
end

function B1()
gg.setRanges(gg.REGION_CODE_APP)
gg.startFuzzy(gg.TYPE_DWORD)
gg.alert('ᴄʟɪᴄᴋ ᴀɢᴀɪɴ ɪғ ʏᴏᴜʀ ᴅᴏɴᴇ')

-- Generates the Lua code for setting a value
function generateSetvalueCode(address, offset, value)
    return string.format('so = gg.getRangesList("%s")[1].start\nsetvalue(so + 0x%X, 4, "h%08X")', address, offset, value)
end

-- Converts an address to an offset based on the base address
function convertResultsToOffsets(baseAddr, address)
    return address - baseAddr
end

-- Finds the library range for a given address
function findLibraryForAddress(address)
    local ranges = gg.getRangesList("")
    for _, range in ipairs(ranges) do
        if address >= range.start and address <= range["end"] then
            return range
        end
    end
    return nil
end

-- Extracts library name from the file path
function getLibraryName(path)
    local name = path:match(".+/([^/]+)%.so")
    return name or "ᴜɴᴋɴᴏᴡɴ-ʟɪʙ"
end

-- Writes output to a specified file
function writeToFile(filePath, output, includeSetValue)
    local file, err = io.open(filePath, "w")
    if not file then
        gg.alert("ᴇʀʀᴏʀ ᴡʀɪᴛɪɴɢ ᴛᴏ ғɪʟᴇ: " .. (err or "unknown error"))
        return
    end
  
    file:write("-- Created by @hookbotty\n")
    file:write("-- Telegram link https://t.me/copypastenigga\n")
    file:write("-- Dm me if you have a suggestion @hookbotty_bot \n\n")
    
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
end

-- Main action function to perform search and save results
function doAction()
    gg.searchFuzzy("0", gg.SIGN_FUZZY_NOT_EQUAL, gg.TYPE_DWORD)
    local results = gg.getResults(gg.getResultsCount())
    
    if #results == 0 then
        gg.alert("ɴᴏ ʀᴇsᴜʟᴛs ғᴏᴜɴᴅ.")
        return
    end

    local alertOption = gg.choice({
        "ᴅɪsᴘʟᴀʏ ғᴜʟʟ ʜᴇxᴘᴀᴛᴄʜᴇs?", 
        "ᴅɪsᴘʟᴀʏ ᴏғғsᴇᴛ ᴏɴʟʏ?", 
        "ᴅɪsᴘʟᴀʏ sᴇᴛᴠᴀʟᴜᴇ ᴄᴏᴅᴇ?"
    }, nil, "ᴄʜᴏᴏsᴇ ʏᴏᴜʀ ᴘʀᴇғᴇʀʀᴇᴅ ᴏᴜᴛᴘᴜᴛ🤖")

    if not alertOption then
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
                table.insert(hexPatchOutput, string.format('HexPatches.HOOK("%s", 0x%X, "h00 00 80 D2 C0 03 5F D6", 32);', detectedLibName, offset, maskedValue))
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

    -- Write outputs to respective files
    if alertOption == 1 or alertOption == 2 then
        writeToFile("/storage/emulated/0/hooksubject.lua", alertOption == 1 and hexPatchOutput or offsetOnlyOutput, false)
    elseif alertOption == 3 then
        for libName, output in pairs(setValueOutputs) do
            writeToFile("/storage/emulated/0/hooktexttt/" .. libName .. "-hook.lua", output, true)
        end
    end
end

gg.setVisible(false)
    while true do
        if gg.isVisible() then
            gg.setVisible(false)
            doAction()
            break
        end
        gg.sleep(1)
    end
end
-- Function to exit the script
function EXIT()
    gg.skipRestoreState()
    gg.setVisible(true)
    os.exit()
    gg.sleep(1)
end

-- Main loop to keep the script running
while true do
    if gg.isVisible(true) then
        uno = 1
        gg.setVisible(false)
    end
    if uno == 1 then
        HOME()
    end
end