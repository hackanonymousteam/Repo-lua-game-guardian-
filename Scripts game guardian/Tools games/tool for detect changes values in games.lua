local time
local sphr

local function detect()
gg.clearList()
    gg.searchFuzzy('0', gg.SIGN_FUZZY_NOT_EQUAL)
local t= gg.getResults(100000000)

    if gg.getResultsCount() == 0 then
        gg.alert("VALUE NOT CHANGED -_-")
        os.exit()
    end
    gg.addListItems(t)
    
end

local function validateRepetitions(input)
    local number = tonumber(input)
    if number == nil or number <= 0 or number > 100 then
        return false
    end
    return true
end

local function repeatedDetect()
    local repetitionsInput = gg.prompt({"Enter the number of repetitions (1-100) for detecting changed values:"}, {1}, {"number"})
    if repetitionsInput == nil then return end
    local repetitions = repetitionsInput[1]
    
    if not validateRepetitions(repetitions) then
        gg.alert("Invalid input. Please enter a number between 1 and 100.")
      gg.clearResults()
  return
    end

    repetitions = tonumber(repetitions)
    
    for i = 1, repetitions do
        gg.toast("Detection change values: " .. i)
        detect()
        gg.sleep(time)  -- Adding a small delay between detections
    end
end
function one()
    gg.startFuzzy(sphr, 0, -1, 0)
    
    repeatedDetect()
    
    gg.clearResults()
    gg.alert("VALUES SAVE IN LIST-_-")
    os.exit()
end

local function dreaming()
    local type = gg.prompt({
        "❦ time for detect changes 1 second",
        "❦ time for detect changes 2 seconds",
        "❦ time for detect changes 3 seconds",
        "❦ time for detect changes 4 seconds",
        "❦ time for detect changes 5 seconds",
        "❦ time for detect changes 6 seconds",
        "❦ time for detect changes 7 seconds",
        "❦ time for detect changes 8 seconds",
        "❦ time for detect changes 9 seconds",
        "❦ time for detect changes 10 seconds"
    }, {0}, {"checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox"})

    if type == nil then return end

    local selectedCount = 0
    for i = 1, #type do
        if type[i] then
            selectedCount = selectedCount + 1
        end
    end

    if selectedCount > 1 then
        gg.alert("select one option")
        dreaming()
    elseif selectedCount == 0 then
        gg.alert("No options selected. Using the default value of 1 second.")
        time = 1000
    else
        if type[1] then time = 1000 end
        if type[2] then time = 2000 end
        if type[3] then time = 3000 end
        if type[4] then time = 4000 end
        if type[5] then time = 5000 end
        if type[6] then time = 6000 end
        if type[7] then time = 7000 end
        if type[8] then time = 8000 end
        if type[9] then time = 9000 end
        if type[10] then time = 10000 end
    end

    one()
end

local function typeValue()
    local type = gg.prompt({
        "❦ TYPE_AUTO",
        "❦ TYPE_BYTE",
        "❦ TYPE_DOUBLE",
        "❦ TYPE_DWORD",
        "❦ TYPE_FLOAT",
        "❦ TYPE_QWORD",
        "❦ TYPE_WORD",
        "❦ TYPE_XOR"
    }, {0}, {"checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox"})

    if type == nil then return end

    local selectedCount = 0
    for i = 1, #type do
        if type[i] then
            selectedCount = selectedCount + 1
        end
    end

    if selectedCount > 1 then
        gg.alert("select one option")
        typeValue()
    elseif selectedCount == 0 then
        gg.alert("value type auto")
        sphr = 127
    else
        if type[1] then sphr = 127 end
        if type[2] then sphr = 1 end
        if type[3] then sphr = 64 end
        if type[4] then sphr = 4 end
        if type[5] then sphr = 16 end
        if type[6] then sphr = 32 end
        if type[7] then sphr = 2 end
        if type[8] then sphr = 8 end
    end
    dreaming()
end

    local Alert = gg.alert([[
tool for detecting value changes in games. choose the region to detect the change, enter the type of value to be detected, choose the time for detection and select the number of times that the change in values ​​will be detected.
 
° ᴛᴇʟᴇɢʀᴀᴍ @batmangamesS
]], "s t a r t", "e x i t")

    if Alert == 1 then
        local log = gg.prompt({
            "❦ REGION_ANONYMOUS",
            "❦ REGION_ASHMEM",
            "❦ REGION_BAD",
            "❦ REGION_CODE_SYS",
            "❦ REGION_C_ALLOC",
            "❦ REGION_C_BSS",
            "❦ REGION_C_DATA",
            "❦ REGION_C_HEAP",
            "❦ REGION_JAVA",
            "❦ REGION_OTHER",
            "❦ REGION_STACK",
            "❦ REGION_PPSSPP",
            "❦ REGION_VIDEO"
        }, {0}, {"checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox"})

        if log == nil then return end

        local selectedCount = 0
        for i = 1, #log do
            if log[i] then
                selectedCount = selectedCount + 1
            end
        end

        if selectedCount > 1 then
            gg.alert("select one option.")
            os.exit()
            elseif selectedCount == 0 then
        gg.alert("range anonymous")
        gg.setRanges(gg.REGION_ANONYMOUS) 
    else
        
            if log[1] then gg.setRanges(gg.REGION_ANONYMOUS) typeValue() end
            if log[2] then gg.setRanges(gg.REGION_ASHMEM) typeValue() end
            if log[3] then gg.setRanges(gg.REGION_BAD) typeValue() end
            if log[4] then gg.setRanges(gg.REGION_CODE_SYS) typeValue() end
            if log[5] then gg.setRanges(gg.REGION_C_ALLOC) typeValue() end
            if log[6] then gg.setRanges(gg.REGION_C_BSS) typeValue() end
            if log[7] then gg.setRanges(gg.REGION_C_DATA) typeValue() end
            if log[8] then gg.setRanges(gg.REGION_C_HEAP) typeValue() end
            if log[9] then gg.setRanges(gg.REGION_JAVA) typeValue() end
            if log[10] then gg.setRanges(gg.REGION_OTHER) typeValue() end
            if log[11] then gg.setRanges(gg.REGION_STACK) typeValue() end
            if log[12] then gg.setRanges(gg.REGION_PPSSPP) typeValue() end
            if log[13] then gg.setRanges(gg.REGION_VIDEO) typeValue() end
        end
        typeValue()
    end