gg.setRanges(gg.REGION_OTHER)
gg.searchNumber(":gg.alert")
gg.refineNumber(":g")
local t = gg.getResults(1)
gg.addListItems(t)
t = nil

local copy = false
t = gg.getListItems()

if not copy then
    gg.removeListItems(t)
end

if #t == 0 then
    gg.alert("No address found.")
    return
end

local v = t[1]
local startAddress = v.address
local endAddress = startAddress + 0x1000

local base_dir = "/sdcard/dump_dex/"
local timestamp = os.date("%Y%m%d%H%M%S")
local dir = base_dir .. timestamp .. "/"
--local dir = "/sdcard/dump_dex/"
gg.dumpMemory(startAddress, endAddress, dir)

    gg.alert("dex saved in paste " .. dir.."\n\nplease rename .bin for extension .dex")

