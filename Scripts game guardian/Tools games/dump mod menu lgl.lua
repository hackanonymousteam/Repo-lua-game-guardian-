function main()
    inicio = gg.choice({
        "🗃️ method dump 1🗃️",
        "❇️ method dump 2❇️",
        "❌SAIR❌"
    })
    
    if inicio == nil then
        return
    elseif inicio == 1 then
        START1()
    elseif inicio == 2 then
        START2()
    elseif inicio == 3 then
        os.exit()
    end
end

function START1()
    gg.setRanges(gg.REGION_C_DATA | gg.REGION_C_BSS | gg.REGION_CODE_APP)
    gg.clearResults()
    gg.searchNumber(":%s has been loaded", gg.TYPE_BYTE)
    
    if gg.getResultsCount() == 0 then
        gg.alert("String not found in method 1!")
        return
    end
    
    gg.refineNumber(":%", gg.TYPE_BYTE)
    local qqq = gg.getResults(1)
    gg.clearResults()
    
    if #qqq == 0 then
        gg.alert("String not found!")
        return
    end
    
    local adf = qqq[1].address
    local adt = adf + 400000
    local addrList = {}
    
    for addr = adf, adt do
        table.insert(addrList, {address = addr, flags = gg.TYPE_BYTE})
    end
    
    local results = gg.getValues(addrList)
    local dir = gg.getFile():match("(.*/)") or ""
    local path = dir .. "antik1.h"
    local file = io.open(path, "w")
    
    if not file then
        gg.alert("Error creating file!")
        return
    end
    
    file:write("========[ Antik String Dumping - Method 1 ]========\n\n")
    local currentString = ""
    local serial = 1
    
    for i, v in ipairs(results) do
        local byte = v.value
        if byte < 0 then byte = byte + 256 end

        if byte == 0 then
            if #currentString > 0 then
                file:write(string.format("#%02d: \"%s\"\n", serial, currentString))
                serial = serial + 1
                currentString = ""
            end
        elseif byte >= 32 and byte <= 126 then
            currentString = currentString .. string.char(byte)
        end
    end
    
    if #currentString > 0 then
        file:write(string.format("#%02d: \"%s\"\n", serial, currentString))
    end
    
    file:close()
    gg.alert("Dump Saved 🗿🗿 LGL DONE: " .. path)
end

function START2()
    gg.setRanges(gg.REGION_C_DATA | gg.REGION_C_BSS | gg.REGION_CODE_APP)
    gg.clearResults()
    gg.searchNumber(":/proc/self/maps", gg.TYPE_BYTE)
    
    if gg.getResultsCount() == 0 then
        gg.alert("String not found in method 2!")
        return
    end
    
    gg.refineNumber(":/proc", gg.TYPE_BYTE)
    local qqq = gg.getResults(1)
    gg.clearResults()
    
    if #qqq == 0 then
        gg.alert("String not found!")
        return
    end
    
    local adf = qqq[1].address
    local adt = adf + 400000
    local addrList = {}
    
    for addr = adf, adt do
        table.insert(addrList, {address = addr, flags = gg.TYPE_BYTE})
    end
    
    local results = gg.getValues(addrList)
    local dir = gg.getFile():match("(.*/)") or ""
    local path = dir .. "antik2.h"
    local file = io.open(path, "w")
    
    if not file then
        gg.alert("Error creating file!")
        return
    end
    
    file:write("========[ Antik String Dumping - Method 2 ]========\n\n")
    local currentString = ""
    local serial = 1
    
    for i, v in ipairs(results) do
        local byte = v.value
        if byte < 0 then byte = byte + 256 end

        if byte == 0 then
            if #currentString > 0 then
                file:write(string.format("#%02d: \"%s\"\n", serial, currentString))
                serial = serial + 1
                currentString = ""
            end
        elseif byte >= 32 and byte <= 126 then
            currentString = currentString .. string.char(byte)
        end
    end
    
    if #currentString > 0 then
        file:write(string.format("#%02d: \"%s\"\n", serial, currentString))
    end
    
    file:close()
    gg.alert("Dump Saved 🗿🗿 LGL DONE: " .. path)
end

while true do
    if gg.isVisible() then
        gg.setVisible(false)
        main()
    end
    gg.sleep(100)
end