g = {}
g.last = "/sdcard/"
g.info = nil
g.config = gg.EXT_CACHE_DIR .. "/" .. gg.getFile():match("[^/]+$") .. "cfg"
g.data = loadfile(g.config)
if g.data ~= nil then
  g.info = g.data()
  g.data = nil
end
if g.info == nil then
  g.info = { g.last, g.last:gsub("/[^/]+$", "") }
end

g.info = gg.prompt({
  ' Select file :', 
  'Select folder to save  :',
  '🔒 Add file modification protection',
}, g.info, {
  'file', 
  'path',
  'checkbox'
}) 

if g.info == nil then
  gg.alert("cancelled!")
  return
end

gg.saveVariable(g.info, g.config)
g.last = g.info[1]

if loadfile(g.last) == nil then
  gg.alert("Script not Found!")
  return
end

g.out = g.last:match("[^/]+$")
g.out = g.out:gsub(".lua", "")
g.out = g.info[2] .. "" .. g.out .. "_protected.lua"

local file = io.open(g.last, "r")
if not file then
gg.alert("❌ Error: Could not open source file!")
  return
end

local DATA = file:read('*a')
file:close()

local newContent = ""

if g.info[3] == true then
  local currentTime = os.time()
  local formattedTime = os.date("%Y-%m-%d %H:%M:%S", currentTime)
  
  newContent = newContent .. [[

local function compareFileModificationTime(filePath, targetDateTime)
    local fileModTime = file.lastTime(filePath)
    
    local function parseDateTime(dateTimeStr)
        local pattern = "(%d+)%-(%d+)%-(%d+) (%d+):(%d+):(%d+)"
        local year, month, day, hour, min, sec = dateTimeStr:match(pattern)
        return os.time{year = tonumber(year), month = tonumber(month), day = tonumber(day), hour = tonumber(hour), min = tonumber(min), sec = tonumber(sec)}
    end

    local fileModTimestamp = parseDateTime(fileModTime)
    local targetTimestamp = parseDateTime(targetDateTime)


    local tolerance = 60
    
   
    if fileModTimestamp > targetTimestamp then

        local timeDifference = fileModTimestamp - targetTimestamp
        
        if timeDifference > tolerance then

            gg.alert("❌ File modified!")
            os.exit()
        else
          --  gg.toast("⚠️ File checked - within tolerance")
        end
    end

end

local filePath = "]] .. g.out:gsub('"', '\\"') .. [["
local targetDateTime = "]] .. formattedTime .. [["

gg.toast("🔒 Checking file integrity...")
compareFileModificationTime(filePath, targetDateTime)
gg.toast("✅ File protected - OK!")
gg.sleep(500)

]]
end

newContent = newContent .. "\n" .. DATA

local outFile = io.open(g.out, "w")
if outFile then
  outFile:write(newContent)
  outFile:close()
  gg.sleep(500)
  
    gg.alert('📂 File Saved To: ' .. g.out)
  end
return