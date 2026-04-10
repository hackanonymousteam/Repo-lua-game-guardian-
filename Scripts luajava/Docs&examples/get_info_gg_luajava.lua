import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "android.content.pm.*"
import "java.io.*"
import "java.text.SimpleDateFormat"
import "java.util.*"

function getAppInfo()
  local success, result = pcall(function()
    local pm = activity.getPackageManager()
    local pkg = activity.getPackageName()
    local info = pm.getPackageInfo(pkg, PackageManager.GET_ACTIVITIES | PackageManager.GET_SERVICES)
    local appInfo = pm.getApplicationInfo(pkg, 0)
    
    local dateFormat = SimpleDateFormat("dd/MM/yyyy HH:mm:ss")
    local installTime = dateFormat.format(Date(info.firstInstallTime))
    local updateTime = dateFormat.format(Date(info.lastUpdateTime))
    
    local appName = tostring(pm.getApplicationLabel(appInfo))
    
    local permissions = {}
    local requestedPermissions = info.requestedPermissions
    if requestedPermissions then
      for i = 0, #requestedPermissions-1 do
        table.insert(permissions, requestedPermissions[i])
      end
    end

    local apkFile = File(appInfo.sourceDir)
    local apkSize = string.format("%.2f MB", apkFile.length() / (1024 * 1024))
    
    return {
      appName = appName,
      packageName = pkg,
      versionName = info.versionName or "N/A",
      versionCode = info.versionCode or 0,
      installTime = installTime,
      updateTime = updateTime,
      installTimeMillis = info.firstInstallTime,
      updateTimeMillis = info.lastUpdateTime,
      apkPath = appInfo.sourceDir,
      dataDir = appInfo.dataDir,
      apkSize = apkSize,
      apkSizeBytes = apkFile.length(),
      permissions = permissions,
      processName = appInfo.processName,
      targetSdkVersion = appInfo.targetSdkVersion,
      minSdkVersion = appInfo.minSdkVersion,
      uid = appInfo.uid
    }
  end)
  
  if success then
    return result
  else
    return {
      error = tostring(result),
      packageName = activity.getPackageName()
    }
  end
end

function showAppInfo()
  local info = getAppInfo()
  
  if info.error then
    print("Error: " .. info.error)
    return
  end
  
  print("=== APPLICATION INFORMATION ===")
  print("Name: " .. info.appName)
  print("Package: " .. info.packageName)
  print("Version: " .. info.versionName .. " (" .. info.versionCode .. ")")
  print("")
  print("=== INSTALLATION ===")
  print("Installed: " .. info.installTime)
  print("Updated: " .. info.updateTime)
  print("")
  print("=== FILES ===")
  print("APK Path: " .. info.apkPath)
  print("APK Size: " .. info.apkSize)
  print("Data Directory: " .. info.dataDir)
  print("")
  print("=== CONFIGURATION ===")
  print("Target SDK: " .. info.targetSdkVersion)
  print("Min SDK: " .. info.minSdkVersion)
  print("UID: " .. info.uid)
  print("")
  
--  print("=== PERMISSIONS ===")
--  print("Total: " .. #info.permissions .. " permissions")
  
  for i = 1, math.min(5, #info.permissions) do
    print("  - " .. info.permissions[i])
  end
  if #info.permissions > 5 then
    print("  ... and " .. (#info.permissions - 5) .. " more permissions")
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

function isDebugBuild()
  local appInfo = getAppInfo()
  return (appInfo and not appInfo.error and 
          activity.getPackageManager()
          .getApplicationInfo(activity.getPackageName(), 0)
          .flags & ApplicationInfo.FLAG_DEBUGGABLE) ~= 0
end

local appPath = getAppPath()
print("APK Path: " .. appPath)

showAppInfo()

print("Is debug build: " .. tostring(isDebugBuild()))