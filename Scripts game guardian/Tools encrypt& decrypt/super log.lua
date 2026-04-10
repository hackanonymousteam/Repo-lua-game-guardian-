
local A = gg.prompt({
    "Select File",
}, {
    "/sdcard/",
}, {
    "file",
})


if A == nil or A[1] == nil then
    print("please select script lua")
    return
end

local tempo_atual = os.time()

local function createHook(funcName)
    local originalFunc = _G[funcName] 
    local hookedFunc = function(...)
        if funcName == "os.time" then
            return tempo_atual  
        else
            return originalFunc(...)  
        end
    end
    return hookedFunc
end

local rep = string.rep
string.rep = function(x, y)
    if string.len(x) == (6*999)*999 and y <= 4 then
        return ''
    end
    return rep(x, y)
end

local originalTraceback = debug.traceback
debug.traceback = function(x)
   
    tostring = tostr
    debug.getinfo = deb
    string.match = mth
    gg.isVisible = vis
    string.rep = rep

    if x == nil then
        -- Bypass Anti loadfile
        local x = originalTraceback()
        x = string.gsub(x, gg.getFile(), A[1]) 
        return x
    end
    return originalTraceback(x)
end


gg.addListItems = function(items) print([[gg.addListItems(]]..tostring(items)..[[)]]) end
gg.alert = function(text, positive, negative, neutral) 
    local params = [[gg.alert("]]..text..[["]]
    if positive then params = params..[[, "]]..positive..[["]] end
    if negative then params = params..[[, "]]..negative..[["]] end
    if neutral then params = params..[[, "]]..neutral..[["]] end
    print(params..[[)]])
end
gg.allocatePage = function(mode, address) print([[gg.allocatePage(]]..tostring(mode)..[[, ]]..tostring(address)..[[)]]) end
gg.bytes = function(text, encoding) print([[gg.bytes("]]..text..[[", "]]..(encoding or "UTF-8")..[[")]]) end
--gg.choice = function(items, selected, message) 
   -- local params = [[gg.choice(]]..tostring(items)
--    if selected then params = params..[[, "]]..selected..[["]] end
  --  if message then params = params..[[, "]]..message..[["]] end
    --print(params..[[)]])
--end
gg.clearList = function() print([[gg.clearList()]]) end
gg.clearResults = function() print([[gg.clearResults()]]) end
gg.copyMemory = function(from, to, bytes) print([[gg.copyMemory(]]..from..[[, ]]..to..[[, ]]..bytes..[[)]]) end
gg.copyText = function(text, fixLocale) print([[gg.copyText("]]..text..[[", ]]..tostring(fixLocale ~= false)..[[)]]) end
gg.disasm = function(type, address, opcode) print([[gg.disasm(]]..type..[[, ]]..address..[[, ]]..opcode..[[)]]) end
gg.dumpMemory = function(from, to, dir, flags) 
    local params = [[gg.dumpMemory(]]..from..[[, ]]..to..[[, "]]..dir..[["]]
    if flags then params = params..[[, ]]..flags end
    print(params..[[)]])
end
gg.editAll = function(value, type) print([[gg.editAll("]]..value..[[", ]]..type..[[)]]) end
gg.getActiveTab = function() print([[gg.getActiveTab()]]) end
gg.getFile = function() print([[gg.getFile()]]) end
gg.getLine = function() print([[gg.getLine()]]) end
gg.getListItems = function() print([[gg.getListItems()]]) end
gg.getLocale = function() print([[gg.getLocale()]]) end
gg.getRanges = function() print([[gg.getRanges()]]) end
gg.getRangesList = function(filter) print([[gg.getRangesList("]]..(filter or "")..[[")]]) end
gg.getResults = function(maxCount, skip, addressMin, addressMax, valueMin, valueMax, type, fractional, pointer)
    local params = [[gg.getResults(]]..maxCount
    if skip then params = params..[[, ]]..skip end
    if addressMin then params = params..[[, ]]..addressMin end
    if addressMax then params = params..[[, ]]..addressMax end
    if valueMin then params = params..[[, "]]..valueMin..[["]] end
    if valueMax then params = params..[[, "]]..valueMax..[["]] end
    if type then params = params..[[, ]]..type end
    if fractional then params = params..[[, "]]..fractional..[["]] end
    if pointer then params = params..[[, ]]..pointer end
    print(params..[[)]])
end
gg.getResultsCount = function() print([[gg.getResultsCount()]]) end
gg.getSelectedElements = function() print([[gg.getSelectedElements()]]) end
gg.getSelectedListItems = function() print([[gg.getSelectedListItems()]]) end
gg.getSelectedResults = function() print([[gg.getSelectedResults()]]) end
gg.getSpeed = function() print([[gg.getSpeed()]]) end
gg.getTargetInfo = function() print([[gg.getTargetInfo()]]) end
gg.getTargetPackage = function() print([[gg.getTargetPackage()]]) end
gg.getValues = function(values) print([[gg.getValues(]]..tostring(values)..[[)]]) end
gg.getValuesRange = function(values) print([[gg.getValuesRange(]]..tostring(values)..[[)]]) end
gg.gotoAddress = function(address) print([[gg.gotoAddress(]]..address..[[)]]) end
gg.hideUiButton = function() print([[gg.hideUiButton()]]) end
gg.isClickedUiButton = function() print([[gg.isClickedUiButton()]]) end
gg.isPackageInstalled = function(pkg) print([[gg.isPackageInstalled("]]..pkg..[[")]]) end
gg.isProcessPaused = function() print([[gg.isProcessPaused()]]) end
--gg.isVisible = function() print([[gg.isVisible()]]) end
gg.loadList = function(file, flags) 
    local content = io.open(file, "r"):read("*a") 
    print(content)
    local params = [[gg.loadList("]]..file..[["]]
    if flags then params = params..[[, ]]..flags end
    print(params)
end
gg.loadResults = function(results) print([[gg.loadResults(]]..tostring(results)..[[)]]) end
gg.makeRequest = function(url, headers, data)
    local params = [[gg.makeRequest("]]..url..[["]]
    if headers then params = params..[[, ]]..tostring(headers) end
    if data then params = params..[[, "]]..data..[["]] end
    print(params..[[)]])
end
gg.multiChoice = function(items, selection, message)
    local params = [[gg.multiChoice(]]..tostring(items)
    if selection then params = params..[[, ]]..tostring(selection) end
    if message then params = params..[[, "]]..message..[["]] end
    print(params..[[)]])
end
gg.numberFromLocale = function(num) print([[gg.numberFromLocale("]]..num..[[")]]) end
gg.numberToLocale = function(num) print([[gg.numberToLocale("]]..num..[[")]]) end
gg.processKill = function() print([[gg.processKill()]]) end
gg.processPause = function() print([[gg.processPause()]]) end
gg.processResume = function() print([[gg.processResume()]]) end
gg.processToggle = function() print([[gg.processToggle()]]) end
gg.prompt = function(prompts, defaults, types) print([[gg.prompt(]]..tostring(prompts)..[[, ]]..tostring(defaults or {})..[[, ]]..tostring(types or {})..[[)]]) end
gg.refineAddress = function(text, mask, type, sign, memoryFrom, memoryTo, limit)
    local params = [[gg.refineAddress("]]..text..[["]]
    if mask then params = params..[[, ]]..mask end
    if type then params = params..[[, ]]..type end
    if sign then params = params..[[, ]]..sign end
    if memoryFrom then params = params..[[, ]]..memoryFrom end
    if memoryTo then params = params..[[, ]]..memoryTo end
    if limit then params = params..[[, ]]..limit end
    print(params..[[)]])
end
gg.refineNumber = function(text, type, encrypted, sign, memoryFrom, memoryTo, limit)
    local params = [[gg.refineNumber("]]..text..[["]]
    if type then params = params..[[, ]]..type end
    if encrypted ~= nil then params = params..[[, ]]..tostring(encrypted) end
    if sign then params = params..[[, ]]..sign end
    if memoryFrom then params = params..[[, ]]..memoryFrom end
    if memoryTo then params = params..[[, ]]..memoryTo end
    if limit then params = params..[[, ]]..limit end
    print(params..[[)]])
end
gg.removeListItems = function(items) print([[gg.removeListItems(]]..tostring(items)..[[)]]) end
gg.removeResults = function(results) print([[gg.removeResults(]]..tostring(results)..[[)]]) end
gg.require = function(version, build) 
    local params = [[gg.require(]]
    if version then params = params..[["]]..version..[["]] end
    if build then params = params..[[, ]]..build end
    print(params..[[)]])
end
gg.saveList = function(file, flags) 
    local params = [[gg.saveList("]]..file..[["]]
    if flags then params = params..[[, ]]..flags end
    print(params..[[)]])
end
gg.saveVariable = function(variable, filename) print([[gg.saveVariable(]]..tostring(variable)..[[, "]]..filename..[[")]]) end
gg.searchAddress = function(text, mask, type, sign, memoryFrom, memoryTo, limit)
    local params = [[gg.searchAddress("]]..text..[["]]
    if mask then params = params..[[, ]]..mask end
    if type then params = params..[[, ]]..type end
    if sign then params = params..[[, ]]..sign end
    if memoryFrom then params = params..[[, ]]..memoryFrom end
    if memoryTo then params = params..[[, ]]..memoryTo end
    if limit then params = params..[[, ]]..limit end
    print(params..[[)]])
end
gg.searchFuzzy = function(difference, sign, type, memoryFrom, memoryTo, limit)
    local params = [[gg.searchFuzzy("]]..(difference or "0")..[["]]
    if sign then params = params..[[, ]]..sign end
    if type then params = params..[[, ]]..type end
    if memoryFrom then params = params..[[, ]]..memoryFrom end
    if memoryTo then params = params..[[, ]]..memoryTo end
    if limit then params = params..[[, ]]..limit end
    print(params..[[)]])
end
gg.searchNumber = function(text, type, encrypted, sign, memoryFrom, memoryTo, limit)
    local params = [[gg.searchNumber("]]..text..[["]]
    if type then params = params..[[, ]]..type end
    if encrypted ~= nil then params = params..[[, ]]..tostring(encrypted) end
    if sign then params = params..[[, ]]..sign end
    if memoryFrom then params = params..[[, ]]..memoryFrom end
    if memoryTo then params = params..[[, ]]..memoryTo end
    if limit then params = params..[[, ]]..limit end
    print(params..[[)]])
end
gg.searchPointer = function(maxOffset, memoryFrom, memoryTo, limit)
    local params = [[gg.searchPointer(]]..maxOffset
    if memoryFrom then params = params..[[, ]]..memoryFrom end
    if memoryTo then params = params..[[, ]]..memoryTo end
    if limit then params = params..[[, ]]..limit end
    print(params..[[)]])
end
gg.setRanges = function(ranges) print([[gg.setRanges(]]..ranges..[[)]]) end
gg.setSpeed = function(speed) print([[gg.setSpeed(]]..speed..[[)]]) end
gg.setValues = function(values) print([[gg.setValues(]]..tostring(values)..[[)]]) end
gg.setVisible = function(visible) print([[gg.setVisible(]]..tostring(visible)..[[)]]) end
gg.showUiButton = function() print([[gg.showUiButton()]]) end
gg.skipRestoreState = function() print([[gg.skipRestoreState()]]) end
gg.sleep = function(milliseconds) print([[gg.sleep(]]..milliseconds..[[)]]) end
gg.startFuzzy = function(type, memoryFrom, memoryTo, limit)
    local params = [[gg.startFuzzy(]]
    if type then params = params..type end
    if memoryFrom then params = params..[[, ]]..memoryFrom end
    if memoryTo then params = params..[[, ]]..memoryTo end
    if limit then params = params..[[, ]]..limit end
    print(params..[[)]])
end
gg.timeJump = function(time) print([[gg.timeJump("]]..time..[[")]]) end
gg.toast = function(text, fast) print([[gg.toast("]]..text..[[", ]]..tostring(fast or false)..[[)]]) end
gg.unrandomizer = function(qword, qincr, double_, dincr)
    local params = [[gg.unrandomizer(]]
    if qword then params = params..qword end
    if qincr then params = params..[[, ]]..qincr end
    if double_ then params = params..[[, ]]..double_ end
    if dincr then params = params..[[, ]]..dincr end
    print(params..[[)]])
end

local file_path = A[1]  
local loaded_script, err = loadfile(file_path)

if loaded_script then
    loaded_script()
else
    print("Erro in load", err)
end