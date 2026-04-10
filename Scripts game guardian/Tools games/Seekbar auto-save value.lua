local FileSpeedOff = gg.EXT_STORAGE .. "/Notes/value.off.txt"

function fileExists(filePath)
    local file = io.open(filePath, "r") 
    if file then
        io.close(file)  
        return true
    else
        return false  
 end
end
function a()
    local BatmanPrompt = gg.prompt({
        "Speed [1;25]"
    }, {
        "1"
    }, {
        "number"
    })
    if not BatmanPrompt then 
        print("Please select")
        os.exit()
    end
    local ValuesSpeed = BatmanPrompt[1] 
    local A = tonumber(ValuesSpeed)
    if not A then
        print("Invalid number")
        os.exit()
    end
    
   gg.loadList(FileSpeedOff, gg.LOAD_VALUES)
    local t = gg.getListItems()
  if #t > 0 then
        t[1].value = A
        gg.setValues(t)
        gg.addListItems(t)
        gg.clearList()
        gg.alert('active')
    else
        print("No items found in list")
        os.exit()
    end
end

if  fileExists(FileSpeedOff) then
    a()
end

function c()
gg.setVisible(false)
gg.setRanges(gg.REGION_CODE_APP)
gg.searchNumber("-5.03065436e27;-3.87859808e-10;-0.4028963079;0.00099999978::13", gg.TYPE_FLOAT)
gg.refineNumber("0.00099999978", gg.TYPE_FLOAT)
local results = gg.getResults(1)
if #results == 0 then
    print("No results found")
    os.exit()
end
local revert = gg.getResults(1)
gg.addListItems(results)
gg.saveList(FileSpeedOff)
gg.clearResults()
a()
end

if not fileExists(FileSpeedOff) then
    c()
end