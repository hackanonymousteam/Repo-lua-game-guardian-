import "android.app.*"
import "android.os.*"
import "android.content.*"
import "android.content.pm.*"
import "java.io.*"
import "android.util.*"

local dangerousPackages = {
    "com.ghostery",
    "com.fan.ggluadec",
    "com.fan.ggxxls",
    "com.chenlun.autumncloudlua",
    "com.maggienorth.max.postdata",
    "com.goushi.gtpcanary",
    "com.packagesniffer.frtparlak",
    "app.greyshirts.sslcapture",
    "com.minhui.networkcapture",
    "com.minhui.wifianalyzer",
    "frtparlak.rootsniffer",
    "jp.co.taosoftware.android.packetcapture"
}

function getInstalledApps()
    local packageManager = activity.getPackageManager()
    local apps = packageManager.getInstalledApplications(PackageManager.GET_META_DATA)
    local userApps = {}
    
    for i = 0, #apps - 1 do
        local app = apps[i]
        if (app.flags & ApplicationInfo.FLAG_SYSTEM) == 0 then
            table.insert(userApps, app)
        end
    end
    
    return userApps
end

function isDangerousByPackage(packageName)
    local lowerPackageName = string.lower(packageName)
    
    for _, dangerousPattern in ipairs(dangerousPackages) do
        if string.find(lowerPackageName, string.lower(dangerousPattern)) then
            return true, dangerousPattern
        end
    end
    return false, nil
end

function hasVpnPermission(permissions)
    if not permissions then return false end
    
    for _, perm in ipairs(permissions) do
        if string.find(perm, "BIND_VPN_SERVICE") then
            return true
        end
    end
    return false
end

function hasRootAndOverlayPermissions(permissions)
    if not permissions then return false end
    
    local hasRoot = false
    local hasOverlay = false
    
    for _, perm in ipairs(permissions) do
        if string.find(perm, "ACCESS_SUPERUSER") then
            hasRoot = true
        end
        if string.find(perm, "SYSTEM_ALERT_WINDOW") then
            hasOverlay = true
        end
    end
    
    return hasRoot and hasOverlay
end

function hasAnalyticsService(components)
    if not components then return false end
    
    for _, comp in ipairs(components) do
        if comp.name and string.find(comp.name, "AnalyticsService") then
            return true
        end
    end
    return false
end

function getAppInfo(packageName)
    local packageManager = activity.getPackageManager()
    local appInfo = {}
    
    local success, info = pcall(function() 
        return packageManager.getApplicationInfo(packageName, 0)
    end)
    
    if not success or not info then return nil end
    
    appInfo.name = tostring(packageManager.getApplicationLabel(info))
    appInfo.packageName = packageName
   
    local permSuccess, packageInfo = pcall(function()
        return packageManager.getPackageInfo(packageName, PackageManager.GET_PERMISSIONS)
    end)
    
    if permSuccess and packageInfo and packageInfo.requestedPermissions then
        appInfo.permissions = {}
        for i = 0, #packageInfo.requestedPermissions - 1 do
            table.insert(appInfo.permissions, tostring(packageInfo.requestedPermissions[i]))
        end
    else
        appInfo.permissions = {}
    end
    
    appInfo.hasVpnPermission = hasVpnPermission(appInfo.permissions)
    appInfo.hasRootAndOverlay = hasRootAndOverlayPermissions(appInfo.permissions)
    
    local classesSuccess, packageInfo = pcall(function()
        return packageManager.getPackageInfo(packageName, 
            PackageManager.GET_ACTIVITIES | 
            PackageManager.GET_SERVICES |
            PackageManager.GET_RECEIVERS)
    end)
    
    if classesSuccess and packageInfo then
        appInfo.allComponents = {}
        
        local components = {
            {type = "Activity", data = packageInfo.activities},
            {type = "Service", data = packageInfo.services},
            {type = "Receiver", data = packageInfo.receivers}
        }
        
        for _, compType in ipairs(components) do
            if compType.data then
                for i = 0, #compType.data - 1 do
                    local comp = compType.data[i]
                    if comp and comp.name then
                        local className = tostring(comp.name)
                        local compInfo = {type = compType.type, name = className}
                        table.insert(appInfo.allComponents, compInfo)
                    end
                end
            end
        end
        
        appInfo.hasAnalyticsService = hasAnalyticsService(appInfo.allComponents)
    else
        appInfo.allComponents = {}
        appInfo.hasAnalyticsService = false
    end
    
    return appInfo
end

function scanForDangerousApps()
    local installedApps = getInstalledApps()
    local dangerousAppsFound = {}
    
    for i, app in ipairs(installedApps) do
        local packageName = tostring(app.packageName)
        
        local isDangerousPkg, pkgPattern = isDangerousByPackage(packageName)
        if isDangerousPkg then
            local appInfo = getAppInfo(packageName)
            if appInfo then
                appInfo.detectionReason = "Package match: " .. pkgPattern
                table.insert(dangerousAppsFound, appInfo)
            end
        else
            local appInfo = getAppInfo(packageName)
            if appInfo then
                if appInfo.hasVpnPermission then
                    appInfo.detectionReason = "VPN permission detected"
                    table.insert(dangerousAppsFound, appInfo)
                elseif appInfo.hasRootAndOverlay and appInfo.hasAnalyticsService then
                    appInfo.detectionReason = "Root+Overlay permissions with AnalyticsService"
                    table.insert(dangerousAppsFound, appInfo)
                end
            end
        end
    end
    
    return dangerousAppsFound
end

function generateReport(dangerousApps)
    local report = "Security Scan Report\n"
    report = report .. "================================\n\n"
    report = report .. "Date: " .. os.date("%d/%m/%Y %H:%M:%S") .. "\n"
    report = report .. "Suspicious apps found: " .. #dangerousApps .. "\n\n"
    
    if #dangerousApps == 0 then
        report = report .. "No threats detected!\n"
        return report
    end
    
    for i, app in ipairs(dangerousApps) do
        report = report .. "SUSPICIOUS APP " .. i .. ":\n"
        report = report .. "Name: " .. app.name .. "\n"
        report = report .. "Package: " .. app.packageName .. "\n"
        report = report .. "Reason: " .. app.detectionReason .. "\n\n"
        
        if app.hasVpnPermission then
            report = report .. "VPN Permission: YES\n"
        end
        
        if app.hasRootAndOverlay then
            report = report .. "Root+Overlay Permissions: YES\n"
        end
        
        if app.hasAnalyticsService then
            report = report .. "AnalyticsService: YES\n"
        end
        
        report = report .. string.rep("=", 40) .. "\n\n"
    end
    
    return report
end

function main()
    local dangerousApps = scanForDangerousApps()
    local report = generateReport(dangerousApps)
    
    if #dangerousApps > 0 then
        local alert = "Warning!\n\n"
        alert = alert .. "Found " .. #dangerousApps .. " suspicious apps:\n\n"
        
        for i, app in ipairs(dangerousApps) do
            alert = alert .. i .. ". " .. app.name .. "\n"
            alert = alert .. "   " .. app.packageName .. "\n"
            alert = alert .. "   " .. app.detectionReason .. "\n\n"
        end
    else
        print("Scan completed! No threats found")
    end
    
    print("\nScan Report:\n")
    print(report)
end

main()