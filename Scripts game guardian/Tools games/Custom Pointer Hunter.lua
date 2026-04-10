function antiSpy()
    gg.setVisible(false)
end

function failed(msg)
    gg.alert(msg)
    gg.clearResults()
end

function attempt(ranges_values, dataType)
    gg.refineNumber(ranges_values, dataType)
end

function user_want()

    local input = gg.prompt({
        "Multiplier [format: x6, x10, etc.]:",
        "Value range to search [format: min~max]:",
        "Data type [1=WORD, 2=DWORD, 4=QWORD, 16=FLOAT]:"
    }, {"x6", "200~65000", "1"}, {"text", "text", "text"})
    
    if not input then
        return failed("❌ User canceled the operation.")
    end
    
    local multiple = input[1]:match("x(%d+)")
    local searchRange = input[2]
    local dataType = tonumber(input[3])
    
    if not multiple or not searchRange or not dataType then
        return failed("❌ Invalid input values provided.")
    end
    
    local targetValue = "0+" .. multiple
    local searchKey = "10" .. multiple
    

    attempt(searchRange..'::9', dataType)

    attempt(searchKey, dataType)
    
    antiSpy()
    gg.toast('#Loading ..[90%]')
    local raw_results = gg.getResults(gg.getResultCount())

    for i, v in ipairs(raw_results) do
        v.value = targetValue
    end

    gg.setValues(raw_results)
    gg.toast('#Loading ..[100%]') 
    gg.sleep(1000)
    gg.toast("#Activate your Booster Now")
    gg.clearResults()
end

function deepPointerScan()
    antiSpy()
    

    local regionInput = gg.multiChoice(
        {"C_ALLOC", "C_BSS", "C_DATA", "C_HEAP", "ANONYMOUS", "JAVA", "STACK", "ASHMEM", "CODE_APP", "CODE_SYS"},
        {false, false, false, false, true, false, false, false, false, false},
        "Select memory regions to search:"
    )
    
    if not regionInput then
        return failed("❌ Memory region selection canceled.")
    end
    

    local regions = {
        gg.REGION_C_ALLOC, gg.REGION_C_BSS, gg.REGION_C_DATA,
        gg.REGION_C_HEAP, gg.REGION_ANONYMOUS, gg.REGION_JAVA,
        gg.REGION_STACK, gg.REGION_ASHMEM, gg.REGION_CODE_APP,
        gg.REGION_CODE_SYS
    }
    
    local selectedRegions = 0
    for i, v in ipairs(regionInput) do
        if v then
            selectedRegions = selectedRegions | regions[i]
        end
    end
    
    gg.setRanges(selectedRegions)
    
  
    local scanInput = gg.prompt({
        "Signature HEX value:",
        "Offset (in hexadecimal):",
        "Pointer level (1-5):",
        "Max results to display:"
    }, {"1970445129618058", "11c", "1", "100"}, {"text", "text", "text", "text"})
    
    if not scanInput then
        return failed("❌ Scan configuration canceled.")
    end
    
    local sigHex = scanInput[1]
    local offset = tonumber(scanInput[2], 16)
    local pointerLevel = tonumber(scanInput[3])
    local maxResult = tonumber(scanInput[4])
    
    if not sigHex or not offset or not pointerLevel or not maxResult then
        return failed("❌ Invalid scan configuration values.")
    end
    
    failed([[
🛡 Save this script:

    ]])
    
    gg.toast('#Loading ..[1%]')
    gg.searchNumber(sigHex, gg.TYPE_QWORD)
    antiSpy()
    local anchor = gg.getResults(1)
    if #anchor == 0 then
        return failed("🚫 You are not in the game!")
    end
    
    antiSpy()
    local offsetResults = {}
    for i, v in ipairs(anchor) do
        table.insert(offsetResults, {
            address = v.address - offset,
            flags = gg.TYPE_QWORD
        })
    end
    
    antiSpy()
    local xResults = gg.getValues(offsetResults)
    local baseAddr = xResults[1].address
    
    gg.clearResults()
    antiSpy()
    gg.searchNumber(tostring(baseAddr), gg.TYPE_QWORD)
    gg.toast('#Loading ..[59%]')
    antiSpy()
    local results = gg.getResults(gg.getResultCount())
    if #results == 0 then
        return failed("🚫 Base address reference not found!")
    end
    
    antiSpy()
    local pointerList = {}
    local offset_to_values = { 0x3E, 0x46 }  -- 
    
    for _, item in ipairs(results) do
        for _, o in ipairs(offset_to_values) do
            table.insert(pointerList, {
                address = item.address + o,
                flags = gg.TYPE_WORD
            })
        end
    end
    
    antiSpy()
    if #pointerList == 0 then
        return failed("❌ No pointer offsets could be calculated!")
    end
    
    antiSpy()
    gg.clearResults()
    gg.loadResults(pointerList)
    local finalResults = gg.getResults(gg.getResultCount())
    
    if #finalResults > 0 then
        gg.toast('#Loading ..[70%]')
        antiSpy()
        gg.sleep(1000)
        antiSpy()
        user_want()
    else
        failed("☢️ 404: 🛡 Protection triggered or no valid values found.")
    end
end

antiSpy()
deepPointerScan()