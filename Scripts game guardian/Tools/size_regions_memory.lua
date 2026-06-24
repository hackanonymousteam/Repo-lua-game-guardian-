local states = {
    "Jh",
    "Ch",
    "Ca",
    "Cd",
    "Cb",
    "PS",
    "A",
    "J",
    "S",
    "As",
    "V",
    "O",
    "B",
    "Xa",
    "Xs"
}

local ranges = {
    gg.REGION_JAVA_HEAP,
    gg.REGION_C_HEAP,
    gg.REGION_C_ALLOC,
    gg.REGION_C_DATA,
    gg.REGION_C_BSS,
    gg.REGION_PPSSPP,
    gg.REGION_ANONYMOUS,
    gg.REGION_JAVA,
    gg.REGION_STACK,
    gg.REGION_ASHMEM,
    gg.REGION_VIDEO,
    gg.REGION_OTHER,
    gg.REGION_BAD,
    gg.REGION_CODE_APP,
    gg.REGION_CODE_SYS
}

local names = {
    "Jh: Java heap",
    "Ch: C++ heap",
    "Ca: C++ Alloc",
    "Cd: C++ .data",
    "Cb: C++ .bss",
    "PS: PPSSPP",
    "A: Anonymous",
    "J: Java",
    "S: Stack",
    "As: Ashmem",
    "V: Video",
    "O: Other",
    "B: Bad",
    "Xa: Code App",
    "Xs: Code system"
}

local function formatSize(bytes)
    if bytes >= 1073741824 then
        return string.format("%.2f GB", bytes / 1073741824)
    elseif bytes >= 1048576 then
        return string.format("%.2f MB", bytes / 1048576)
    elseif bytes >= 1024 then
        return string.format("%.2f KB", bytes / 1024)
    end

    return tostring(bytes) .. " B"
end

local function getRegionSizes()
    local result = {}

    for _, v in ipairs(gg.getRangesList()) do
        local state = v.state

        if state then
            result[state] = (result[state] or 0) + (v["end"] - v.start)
        end
    end

    return result
end

local function buildDescriptions()
    local sizes = getRegionSizes()
    local list = {}

    for i = 1, #states do
        local size = sizes[states[i]] or 0
        list[i] = names[i] .. " [" .. formatSize(size) .. "]"
    end

    return list
end

local function showDetailedSizes()
    local sizes = getRegionSizes()
    local text = "Memory Region Sizes\n\n"

    local temp = {}

    for i = 1, #states do
        temp[#temp + 1] = {
            name = names[i],
            size = sizes[states[i]] or 0
        }
    end

    table.sort(temp, function(a, b)
        return a.size > b.size
    end)

    for _, v in ipairs(temp) do
        text = text .. v.name .. ": " .. formatSize(v.size) .. "\n"
    end

    gg.alert(text)
end

local function main()
    local descriptions = buildDescriptions()

    local defaults = {}

    for i = 1, #descriptions do
        defaults[i] = false
    end

    local choice = gg.multiChoice(descriptions, defaults)

    if choice == nil then
        gg.alert("Selection cancelled!")
        return
    end

    local selectedCount = 0
    local resultMask = 0
    local msg = "Selected Regions\n\n"

    local sizes = getRegionSizes()

    for i, checked in pairs(choice) do
        if checked then
            selectedCount = selectedCount + 1
            resultMask = resultMask | ranges[i]

            msg = msg ..
                names[i] ..
                " [" ..
                formatSize(sizes[states[i]] or 0) ..
                "]\n"
        end
    end

    if selectedCount == 0 then
        gg.alert("No regions selected!")
        return
    end

    gg.setRanges(resultMask)

    local opt = gg.choice(
        {
            "Show all detailed sizes",
            "Close"
        },
        nil,
        msg .. "\n\nRegions applied successfully!"
    )

    if opt == 1 then
        showDetailedSizes()
    end
end

main()