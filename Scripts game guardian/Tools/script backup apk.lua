
local targetInfo = gg.getTargetInfo()

local targetInfoStr = ""
for k, v in pairs(targetInfo) do
    targetInfoStr = targetInfoStr .. k .. " = " .. tostring(v) .. "\n"
end

local v = '/'
local namer = 'info.txt'
local path = "/sdcard/"

local file = io.open(path .. namer, "wb")
if file then
    file:write(targetInfoStr)
    file:close()
else
    return
end

local file = io.open(path .. namer, "rb")
if file then
    local targetInfoStr2 = file:read("*all")
    file:close()
    
    local sourceDirFound = false
    local sourceDirPattern = 'sourceDir%s*=%s*([^%s]+)'
    for sourceDir in string.gmatch(targetInfoStr2, sourceDirPattern) do
        
  g = {}
g.last = "my_apk"
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

gg.alert([[

script for backup apk

by Batman Games🍿 

My telegram @batmangamesS 
]])

while true do
  g.info = gg.prompt({
    '📂 Select nameAPK file:', -- 1
    '📂 Select folder to save apk :' -- 2
  }, g.info, {
  'file', -- 1
    'path' -- 2
  })

  if g.info == nil then
    return
  end
  local apkFilePath = sourceDir
 local extends  = ".apk"
 
local nameApk = g.info[1]..extends
  local saveFolder = g.info[2]
  
  if not apkFilePath:match("%.apk$") then
    gg.alert("⚠️ Please select a valid APK file! ⚠️")
    return
  end

  gg.saveVariable(g.info, g.config)
  g.last = apkFilePath

  local file = io.open(g.last, "rb") 
  local data = file:read('*a')
  file:close()
  
            local file = io.open(saveFolder .. nameApk, "wb")
            if file then
            file:write(data)
            file:close()
            os.remove(path .. namer)
            
    ClU = '📂 File Saved To: '..saveFolder..nameApk..'\n'
  gg.alert(ClU, '')
  print("\n▬▬▬▬▬▬▬▬▬▬▬▬▬\n📂 File Saved To :" .. saveFolder..nameApk .. "\n▬▬▬▬▬▬▬▬▬▬▬▬▬")
 
return
end
end
end
end