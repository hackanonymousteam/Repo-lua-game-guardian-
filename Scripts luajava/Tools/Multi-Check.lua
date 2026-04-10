local g = {}
g.last = gg.getFile()
g.info = nil

g.config = gg.EXT_CACHE_DIR .. "/" .. gg.getFile():match("[^/]+$") .. "cfg"
g.data = loadfile(g.config)
if g.data ~= nil then
    g.info = g.data()
    g.data = nil
end

if g.info == nil then
    g.info = {g.last, g.last:gsub('/[^/]+$', ''), false, false, false, false}
end

for i = 3, 6 do
    if g.info[i] == nil then g.info[i] = false end
end

-- ================= FILE =================

local function data_read(path)
    local f = io.open(path, "r")
    if not f then return nil end
    local c = f:read("*a")
    f:close()
    return c
end

local function data_write(path, content)
    local f = io.open(path, "w")
    f:write(content)
    f:close()
end

-- ================= MAIN =================

while true do
    g.info = gg.prompt({
        '📂 Select file',
        '📤 Select path',
        '💾 RAM Check',
        '🌐 Locale Check',
        '💾 Disk Space Check'
    }, g.info, {
        'file',
        'path',
        'checkbox',
        'checkbox',
        'checkbox',
        'checkbox'
    })

    if g.info == nil then break end

    gg.saveVariable(g.info, g.config)

    g.last = g.info[1]

    local DATA = data_read(g.last)
    if not DATA then
        gg.alert("Failed to read script")
        return
    end

    local HEADER = ""

    -- ================= CHECKS =================

    -- Check 3: RAM Check
    if g.info[3] == true then
        local MEM_CHECK = gg.prompt({
            "💾 Min RAM Required (MB):",
            "📝 Type Block Message :"
        }, {"1024", "⚠️ Insufficient RAM ⚠️"}, {"number", "text"})
        
        if not MEM_CHECK then
            gg.setVisible(true)
            return
        elseif MEM_CHECK[1] == nil then
            gg.alert("💾 RAM Value Can Not Be Empty !")
            gg.setVisible(true)
            return
        else
            print("💾 Added RAM Check : True✔")
            DATA = [[
    import "java.lang.Runtime"
    local Runtime = luajava.bindClass("java.lang.Runtime")
    local runtime = Runtime.getRuntime()
    local maxMem = runtime:maxMemory() / (1024 * 1024)
    local requiredMem = ]]..MEM_CHECK[1]..[[
    
    if maxMem < requiredMem then
  gg.alert("]]..MEM_CHECK[2]..[[")
        return
    end
    ]] .. DATA
        end
    end

    -- Check 4: Locale Check
    if g.info[4] == true then
        local LOCALE_CHECK = gg.prompt({
            "🌐 Allowed Locale (ex: pt_BR, en_US):",
            "📝 Type Block Message :"
        }, {"pt_BR", "⚠️ Region Not Supported ⚠️"}, {"text", "text"})
        
        if not LOCALE_CHECK then
            gg.setVisible(true)
            return
        elseif LOCALE_CHECK[1] == nil or LOCALE_CHECK[1] == "" then
            gg.alert("🌐 Locale Can Not Be Empty !")
            gg.setVisible(true)
            return
        else
            print("🌐 Added Locale Check : True✔")
            DATA = [[
    import "java.util.Locale"
    local Locale = luajava.bindClass("java.util.Locale")
    local currentLocale = Locale.getDefault()
    local localeStr = currentLocale:toString()
    local allowedLocale = "]]..LOCALE_CHECK[1]..[["
    
    if localeStr ~= allowedLocale then
    gg.alert("]]..LOCALE_CHECK[2]..[[")
        return
    end
    ]] .. DATA
        end
    end



    -- Check 5: Disk Space Check
    if g.info[5] == true then
        local DISK_CHECK = gg.prompt({
            "💾 Minimum Free Space Required (MB):",
            "📝 Type Block Message :"
        }, {"100", "⚠️ Insufficient Storage Space ⚠️"}, {"number", "text"})
        
        if not DISK_CHECK then
            gg.setVisible(true)
            return
        elseif DISK_CHECK[1] == nil then
            gg.alert("💾 Space Value Can Not Be Empty !")
            gg.setVisible(true)
            return
        else
            print("💾 Added Disk Space Check : True✔")
            DATA = [[
    import "java.io.File"
    local File = luajava.bindClass("java.io.File")
    local path = File("/data")
    local freeSpace = path:getFreeSpace() / (1024 * 1024)
    local required = ]]..DISK_CHECK[1]..[[
    if freeSpace < required then
 gg.alert("]]..DISK_CHECK[2]..[[")
        return
    end
    ]] .. DATA
        end
    end

   local FINAL = HEADER .. DATA

    g.name = g.last:match('[^/]+$')
    g.pathes = {
        g.info[2]..'/'..g.name,
        g.last,
        '/sdcard/'..g.name,
        gg.getFile():gsub('[^/]+$', '')..g.name,
        gg.EXT_FILES_DIR..'/'..g.name
    }

    local saved = false

    for i, v in ipairs(g.pathes) do
        local ok = pcall(function()
            data_write(v, FINAL)
        end)

        if ok then
            gg.alert("Saved:\n"..v)
            saved = true
            os.exit()
        end
    end

    if not saved then
        gg.alert("Failed to save file")
    end
end