
function dumpMemory(startAddress, endAddress, dir)
    local result = gg.dumpMemory(startAddress, endAddress, dir)
    if result == true then
        print("Dump sucess.")
    elseif type(result) == "string" then
        print("Error:", result)
    else
        print("Error")
    end
end
gg.setRanges(gg.REGION_OTHER)

gg.searchNumber("1.19598351e-32;4.88564391e-39::5", gg.TYPE_FLOAT)
gg.refineNumber("1.19598351e-32;", gg.TYPE_FLOAT)
local startAddresses = gg.getResults(1)
if #startAddresses > 0 then
    gg.addListItems(startAddresses)
    gg.clearResults()
else
    print("Header initial no found.")
    return
end

gg.searchNumber("1.19598351e-32;4.88564391e-39::5", gg.TYPE_FLOAT)
gg.refineNumber("1.19598351e-32;", gg.TYPE_FLOAT)

local endAddresses = gg.getResults(1)
if #endAddresses > 0 then
    local endAddress = endAddresses[1].address + 0x10

    local startAddress = gg.getListItems()[1].address
    dumpMemory(startAddress, endAddress, "/sdcard/dump_dex_file1")
else
    print("no found")
    return
end

gg.clearResults()
gg.clearList()

gg.setRanges(gg.REGION_JAVA)
gg.searchNumber("1.19598351e-32;4.88564391e-39::5", gg.TYPE_FLOAT)
gg.refineNumber("1.19598351e-32;", gg.TYPE_FLOAT)
local startAddresses = gg.getResults(1)
if #startAddresses > 0 then
    gg.addListItems(startAddresses)
    gg.clearResults()
    
else
    print("Header dex no found.")
    return
end

gg.searchNumber("1.19598351e-32;4.88564391e-39::5", gg.TYPE_FLOAT)
gg.refineNumber("1.19598351e-32;", gg.TYPE_FLOAT)

local endAddresses = gg.getResults(1)
if #endAddresses > 0 then
    
    local endAddress = endAddresses[1].address + 0x10
 
    local startAddress = gg.getListItems()[1].address
    dumpMemory(startAddress, endAddress, "/sdcard/dump_dex_file2")
    
gg.clearResults()
gg.clearList()
gg.alert("saved in: sdcard/dump_dex_file1 ")

gg.alert("saved in: sdcard/dump_dex_file2 ")

else
    print("no found.")
    return
end