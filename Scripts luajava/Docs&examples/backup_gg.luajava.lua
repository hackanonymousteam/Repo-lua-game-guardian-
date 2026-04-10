import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "java.io.*"
import "java.security.*"
import "java.util.zip.CRC32"
import "java.math.BigInteger"

function copyFile(srcPath, dstPath)
  local success, result = pcall(function()
    local srcFile, err = io.open(srcPath, "rb")
    if not srcFile then
      return false, "" .. tostring(err)
    end
    
    local dstFile, err = io.open(dstPath, "wb")
    if not dstFile then
      srcFile:close()
      return false, "" .. tostring(err)
    end
    
    local chunkSize = 8192
    while true do
      local chunk = srcFile:read(chunkSize)
      if not chunk then break end
      dstFile:write(chunk)
    end
    
    srcFile:close()
    dstFile:close()
    return true
  end)
  
  return success, result
end

function deleteFile(filePath)
  local ok, err = os.remove(filePath)
  if not ok then
    local file = File(filePath)
    if file:exists() then
      file:delete()
    end
  end
end

function getAppPath()
  local success, result = pcall(function()
    local pm = activity.getPackageManager()
    local pkg = activity.getPackageName()
    local info = pm.getPackageInfo(pkg, 0)
    return info.applicationInfo.sourceDir
  end)
  
  if success then
    return result
  else
    return nil
  end
end

local appPath = getAppPath()
if not appPath then
  print("❌ Error:")
  return nil
end

local backupDir = "/storage/emulated/0/temp_hashes"
local backupFile = backupDir .. "/app_backup.apk"

local dir = File(backupDir)
if not dir:exists() then
  dir:mkdirs()
end

local copyOk, copyErr = copyFile(appPath, backupFile)

if not copyOk then
  print("❌ Error: " .. tostring(copyErr))
  return nil
end

print("✅ Backup ok: " .. backupFile)

local backup = File(backupFile)
if not backup:exists() then
  print("❌ Backup error")
  return nil
end

print("📊 size: " .. backup:length() .. " bytes")

if dir:exists() and #dir:list() == 0 then
  dir:delete()
end
