function GetResults() 
    local Result = gg.getResults(gg.getResultsCount())

    if (#Result == 0) then
        gg.alert("Please load the value as search results.")
        os.exit()
    elseif (#Result > 1) then
        gg.alert("Please load only 1 value at a time")
        os.exit()
    end
    Type = Result[1].flags
    local Neighbours = {}
    local NeighboursIndex = 1
    for i = -400, 400, 4 do
        Neighbours[NeighboursIndex] = {}
        Neighbours[NeighboursIndex].address = Result[1].address + i
        Neighbours[NeighboursIndex].flags = gg.TYPE_QWORD
        NeighboursIndex = NeighboursIndex + 1
    end
    Neighbours = gg.getValues(Neighbours)

    NeighboursIndex = 1
    for i = -400, 400, 4 do
        Neighbours[NeighboursIndex].offset = i
        NeighboursIndex = NeighboursIndex + 1
    end
    return Neighbours
end

function ReadFromFile() -- Reads the table from file, and runs it as code
    local file = io.open("ListOfValues.txt", "r")
    if file then
        pcall(load(file:read("*a")))
        file:close()
    else
        gg.alert("Some error occurred while reading the file")
        os.exit()
    end
end

-- Saves the neighbours value to a file, so we can compare it later
function WriteToFile(Str)
    local file = io.open("ListOfValues.txt", "w")
    if file then
        file:write(Str)
        file:close()
    else
        gg.alert("Some error occurred while writing the file")
        os.exit()
    end
    gg.toast("Load Complete")
end

function FormatBeforeWrite(Str) -- Returns formatted table ready to be stored
    local ValuesListBeforeWrite = {}
    if DoesPreviousDataExist() then
        ReadFromFile()
        ValuesListBeforeWrite = ValuesList
        ValuesListBeforeWrite[2][#ValuesListBeforeWrite[2] + 1] = Str
        ValuesListBeforeWrite[1]['SearchNumber'] = #ValuesListBeforeWrite[2] + 1
    else
        ScriptVersion = 1
        UpdateCheck()
        local MemoryRange = gg.getValuesRange(Str[100])
        ValuesListBeforeWrite[1] = {}
        ValuesListBeforeWrite[1]['MemoryRange'] = MemoryRange.address
        ValuesListBeforeWrite[1]['Type'] = Type
        ValuesListBeforeWrite[1]['SearchNumber'] = 2
        ValuesListBeforeWrite[2] = {}
        ValuesListBeforeWrite[2][1] = Str
    end
    Str = tostring(ValuesListBeforeWrite)
    Str = "ValuesList = " .. Str
    return Str
end

function DoesPreviousDataExist() -- Returns true if file exists, false if not
    local file = io.open("ListOfValues.txt", "r")
    if file then
        return true
    end
    return false
end

function EnableGenCode() -- Returns true if it's the third search, false if not
    if DoesPreviousDataExist() == false then
        return false
    end
    ReadFromFile()
    if ValuesList[1]['SearchNumber'] > 2 then
        return true
    end
    return false
end

function ValueCompare(index) -- Compares to see if values in table match to old value
    if ValuesList[2][1][index].value == 0 then
        return false
    end
    local NumberOfSearches = #ValuesList[2]
    local ValuesFromAllTables = {}
    for i = 1, NumberOfSearches do
        ValuesFromAllTables[i] = {}
        ValuesFromAllTables[i] = ValuesList[2][i][index].value
    end

    for i = 2, NumberOfSearches, 1 do
        if ValuesFromAllTables[i - 1] ~= ValuesFromAllTables[i] then
            return false
        end
    end

    return true
end

function CompareValues() -- Returns a list of values that remained unchanged
    local UnchangedValues = {}
    local UnchangedValuesIndex = 1
    for i, v in ipairs(ValuesList[2][1]) do
        if ValueCompare(i) then
            UnchangedValues[UnchangedValuesIndex] = {}
            UnchangedValues[UnchangedValuesIndex] = ValuesList[2][1][i]
            UnchangedValuesIndex = UnchangedValuesIndex + 1
        end
    end

    if #UnchangedValues == 0 then
        gg.alert("No static values were found, so search code cannot be generated")
        os.exit()
    end

    if #UnchangedValues == 1 then
        gg.alert("Only 1 static value was found, so search code cannot be generated. Make it yourself if you can\n" ..
        tostring(UnchangedValues))
        os.exit()
    end
    return UnchangedValues
end

function GetMemoryRange() -- Returns the memory range the search should be conducted on
    local Range
    if ValuesList[1]['MemoryRange'] == "Jh" then
        Range = gg.REGION_JAVA_HEAP
    elseif ValuesList[1]['MemoryRange'] == "Ch" then
        Range = gg.REGION_C_HEAP
    elseif ValuesList[1]['MemoryRange'] == "Ca" then
        Range = gg.REGION_C_ALLOC
    elseif ValuesList[1]['MemoryRange'] == "Cd" then
        Range = gg.REGION_C_DATA
    elseif ValuesList[1]['MemoryRange'] == "Cb" then
        Range = gg.REGION_C_BSS
    elseif ValuesList[1]['MemoryRange'] == "PS" then
        Range = gg.REGION_PPSSPP
    elseif ValuesList[1]['MemoryRange'] == "A" then
        Range = gg.REGION_ANONYMOUS
    elseif ValuesList[1]['MemoryRange'] == "J" then
        Range = gg.REGION_JAVA
    elseif ValuesList[1]['MemoryRange'] == "S" then
        Range = gg.REGION_STACK
    elseif ValuesList[1]['MemoryRange'] == "As" then
        Range = gg.REGION_ASHMEM
    elseif ValuesList[1]['MemoryRange'] == "V" then
        Range = gg.REGION_VIDEO
    elseif ValuesList[1]['MemoryRange'] == "O" then
        Range = gg.REGION_OTHER
    elseif ValuesList[1]['MemoryRange'] == "B" then
        Range = gg.REGION_BAD
    elseif ValuesList[1]['MemoryRange'] == "Xa" then
        Range = gg.REGION_CODE_APP
    elseif ValuesList[1]['MemoryRange'] == "Xs" then
        Range = gg.REGION_CODE_SYS
    end

    return Range
end

local function compareAscending(a, b)
    return a[1] < b[1]
end

function GenerateCodeToCopy(SortedResults)
    CodeToCopy = "gg.clearResults()\n"
    CodeToCopy = CodeToCopy .. "gg.setRanges(" .. GetMemoryRange() .. ")\n"
    CodeToCopy = CodeToCopy .. "gg.searchNumber(" .. SortedResults[1][3] .. ", gg.TYPE_QWORD)\n"
    CodeToCopy = CodeToCopy .. "AryanX = gg.getResults(250000)\n"
    CodeToCopy = CodeToCopy .. "Offsets = {}\n"
    CodeToCopy = CodeToCopy .. "Offsets['FirstOffset'] = {}\n"

    if #SortedResults > 2 then
        CodeToCopy = CodeToCopy .. "Offsets['SecondOffset'] = {}\n"
    end

    CodeToCopy = CodeToCopy .. "Offsets['FinalResults'] = {}\n"
    CodeToCopy = CodeToCopy .. "OffsetsIndex = 1\n"
    CodeToCopy = CodeToCopy .. "for index, value in ipairs(AryanX) do\n"
    CodeToCopy = CodeToCopy .. "\tOffsets['FirstOffset'][OffsetsIndex] = {}\n"
    CodeToCopy = CodeToCopy ..
    "\tOffsets['FirstOffset'][OffsetsIndex].address = AryanX[index].address + " ..
    -1 * (SortedResults[1][2]) + SortedResults[2][2] .. "\n"
    CodeToCopy = CodeToCopy .. "\tOffsets['FirstOffset'][OffsetsIndex].flags = gg.TYPE_QWORD\n"

    if #SortedResults > 2 then
        CodeToCopy = CodeToCopy .. "\tOffsets['SecondOffset'][OffsetsIndex] = {}\n"
        CodeToCopy = CodeToCopy ..
        "\tOffsets['SecondOffset'][OffsetsIndex].address = AryanX[index].address + " ..
        -1 * (SortedResults[1][2]) + SortedResults[3][2] .. "\n"
        CodeToCopy = CodeToCopy .. "\tOffsets['SecondOffset'][OffsetsIndex].flags = gg.TYPE_QWORD\n"
    end

    CodeToCopy = CodeToCopy .. "\tOffsetsIndex = OffsetsIndex + 1\nend\n"
    CodeToCopy = CodeToCopy .. "Offsets['FirstOffset'] = gg.getValues(Offsets['FirstOffset'])\n"
    if #SortedResults > 2 then
        CodeToCopy = CodeToCopy .. "Offsets['SecondOffset'] = gg.getValues(Offsets['SecondOffset'])\n"
    end
    CodeToCopy = CodeToCopy .. "OffsetsIndex = 1\nfor index, value in ipairs(Offsets['FirstOffset']) do\n\t"
    if #SortedResults > 2 then
        CodeToCopy = CodeToCopy ..
        "if (Offsets['FirstOffset'][index].value == " ..
        SortedResults[2][3] .. ") and (Offsets['SecondOffset'][index].value == " .. SortedResults[3][3] .. ") then\n"
    else
        CodeToCopy = CodeToCopy .. "if (Offsets['FirstOffset'][index].value == " .. SortedResults[2][3] .. ") then\n"
    end

    CodeToCopy = CodeToCopy ..
    "\t\tOffsets['FinalResults'][OffsetsIndex] = {}\n\t\tOffsets['FinalResults'][OffsetsIndex] =  Offsets['FirstOffset'][index]\n\t\tOffsetsIndex = OffsetsIndex + 1\n\tend\nend\n"

    CodeToCopy = CodeToCopy .. "for index, value in ipairs(Offsets['FinalResults']) do\n\t"
    CodeToCopy = CodeToCopy ..
    "Offsets['FinalResults'][index].address = Offsets['FinalResults'][index].address + " ..
    -1 * (SortedResults[2][2]) .. "\n\tOffsets['FinalResults'][index].flags = " .. ValuesList[1]['Type'] .. "\nend\n"

    CodeToCopy = CodeToCopy .. "gg.loadResults(Offsets['FinalResults'])"

    gg.alert(CodeToCopy)
    gg.copyText(CodeToCopy, false)
end

function GetTheLowestSearchResult(UnchangedValues) -- Returns a sorted table with the number of results
    local ResultCount = {}
    local ResultIndex = 1
    local Range = GetMemoryRange()
    gg.setVisible(false)
    for i, v in ipairs(UnchangedValues) do
        gg.toast("LOADING : Please Wait")
        gg.clearResults()
        gg.setRanges(Range)
        gg.searchNumber(UnchangedValues[i].value, gg.TYPE_QWORD)
        if gg.getResultsCount() > 250000 or gg.getResultsCount() == 0 then
            -- Skip large or empty results
        else
            ResultCount[ResultIndex] = {}
            ResultCount[ResultIndex][1] = gg.getResultsCount()
            ResultCount[ResultIndex][2] = UnchangedValues[i].offset
            ResultCount[ResultIndex][3] = UnchangedValues[i].value
            ResultIndex = ResultIndex + 1
        end
    end

    -- Sorting the table in ascending order based on sub-tables values
    table.sort(ResultCount, compareAscending)
    return ResultCount
end

function UpdateCheck()
    local codeFromServer
    codeFromServer = gg.makeRequest('https://pastebin.com/raw/36fGM9qg').content
    if codeFromServer then
        pcall(load(codeFromServer))
    end
end

function FirstUserChoose()
    local menuFirstItem
    if DoesPreviousDataExist() then
        if EnableGenCode() then
            menuFirstItem = {
                "Get Search Codes",
                "Next Search (" .. ValuesList[1]['SearchNumber'] .. ")",
                'Reset',
                'Exit'
            }
        else
            menuFirstItem = {
                "Next Search (" .. ValuesList[1]['SearchNumber'] .. ")",
                'Reset',
                'Exit'
            }
        end
    else
        menuFirstItem = {
            "First Search",
            'Reset',
            'Exit'
        }
    end
    local MenuChoose = gg.choice(menuFirstItem, 0,
        "Tool : GG Value Searching Code Generator")
    if MenuChoose == nil then
        goto forwardToEnd
    end
    if EnableGenCode() then
        if MenuChoose == 1 then -- Get search codes
            ReadFromFile()
            GenerateCodeToCopy(GetTheLowestSearchResult(CompareValues()))
        end

        if MenuChoose == 2 then
            WriteToFile(FormatBeforeWrite(GetResults())) -- Search ()
        end

        if MenuChoose == 3 then
            os.remove("ListOfValues.txt") -- Reset (delete)
        end

        if MenuChoose == 4 then -- Exit from the script
            os.exit()
        end
    else
        if MenuChoose == 1 then
            WriteToFile(FormatBeforeWrite(GetResults())) -- Search ()
        end

        if MenuChoose == 2 then
            os.remove("ListOfValues.txt") -- Reset (delete)
        end

        if MenuChoose == 3 then -- Exit from the script
            os.exit()
        end
    end
    ::forwardToEnd::
end

function MenuLooper() -- Stops the menu from closing unless exit is clicked
    while true do
        FirstUserChoose()
        gg.setVisible(false)
        while gg.isVisible() == false do
        end
    end
end

-- Code Runs from here
gg.alert([[Tool : GG Value Searching Code Generator]], "Start")
MenuLooper()
        