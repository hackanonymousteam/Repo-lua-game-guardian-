
function dumpMemory(startAddress, endAddress, dir)

    local result = gg.dumpMemory(startAddress, endAddress, dir)
    if result == true then
        print("Dump  sucess.")
    elseif type(result) == "string" then
        print("Error:", result)
    else
        print("Error.")
    end
end

gg.setRanges(gg.REGION_OTHER)

gg.searchNumber("50r;4Br;03r;04r;14r;00r;08r;00r::8", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1)
local startAddresses = gg.getResults(1)
if #startAddresses > 0 then
    gg.addListItems(startAddresses)
    gg.clearResults()
else
    print("Header no found.")
    return
end
gg.setRanges(gg.REGION_OTHER)
gg.searchNumber("50r;4Br;03r;04r;14r;00r;00r;08r::8", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1)
local endAddresses = gg.getResults(1)
if #endAddresses > 0 then
    gg.addListItems(endAddresses)
    local endAddress = endAddresses[1].address + 0x1000
else
    print("no found.")
    return
end

local startAddress = gg.getListItems()[1].address
local endAddress = endAddresses[1].address

dumpMemory(startAddress, endAddress, "/sdcard/dump_zip_file")

gg.alert("saved in: /sdcard/dump_zip_file")

gg.clearResults()
gg.clearList()