
local NamePackage = "com.ghisler.android.TotalCommander"

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
    
    local packageNameFound = false
    local packageNamePattern = 'packageName%s*=%s*([^%s]+)'
    for packageName in string.gmatch(targetInfoStr2, packageNamePattern) do
        
     --   if gg.getTargetPackage() ~= packageName then
     
     if NamePackage ~= packageName then
     
            while true do
                gg.alert('Error, package name process invalid')
  os.exit()
            end
        else
            packageNameFound = true
            os.remove(path .. namer, "wb")
        end
    end

    if not packageNameFound then
        gg.alert('Failed to find packageName.')
    end
else
    gg.alert('Failed to read the file.')
end



          --[[ 
          example removes internal files
           os.remove(packageName .. v .. "code_cache")
            os.remove(packageName .. v .. "files")
            os.remove(packageName .. v .. "shared_prefs")
            
            example write content 
            local file = io.open(packageName .. v .. namer, "wb")
            if file then
            file:write(targetInfoStr)
            file:close()
             end     ]]