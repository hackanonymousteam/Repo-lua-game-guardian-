
if luajava == nil then gg.alert(' unavaliable please use gameguardian mod (suport luajava)') else end

if not activity then
    gg.alert("No activity available")
    return
end

import "java.io.*"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "android.net.*"
import "android.content.*"
import "java.net.*"
import "android.content.pm.*"

local Class = luajava.bindClass
local new = luajava.new
local astable = luajava.astable

local context = activity

function detectVPN()
    import "java.net.NetworkInterface"
    import "java.util.Collections"
    import "java.util.Enumeration"
    import "java.util.Iterator"
    import "java.lang.String"
    
    local niList = NetworkInterface.getNetworkInterfaces()
    if niList ~= nil then
        local it = Collections.list(niList).iterator()
        while it.hasNext() do
            local intf = it.next()
            if intf.isUp() and intf.getInterfaceAddresses().size() ~= 0 then
                local name = intf.getName()
                if String("tun0").equals(name) or String("ppp0").equals(name) then
                    return true
                end
            end
        end
    end
    return false
end

function detectProxy()
    import "java.lang.System"
    import "java.lang.String"
    
    local httpHost = System.getProperty("http.proxyHost")
    local httpPort = System.getProperty("http.proxyPort")
    
    if httpHost ~= nil and httpHost ~= "" then
        return httpHost, httpPort
    end
    return nil, nil
end

local dangerousPackages = {
    "com.ghostery",
    "com.fan.ggluadec",
    "com.fan.ggxxls",
    "com.chenlun.autumncloudlua",
    "com.maggienorth.max.postdata",
    "com.goushi.gtpcanary",
    "com.guoshi.httpcanary.premium",
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
    
    for i = 0, apps.size() - 1 do
        local app = apps.get(i)
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
        for i = 0, packageInfo.requestedPermissions.length - 1 do
            table.insert(appInfo.permissions, tostring(packageInfo.requestedPermissions[i]))
        end
    else
        appInfo.permissions = {}
    end
    
    appInfo.hasVpnPermission = hasVpnPermission(appInfo.permissions)
    
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
                    appInfo.detectionReason = "remove this"
                    table.insert(dangerousAppsFound, appInfo)
                end
            end
        end
    end
    
    return dangerousAppsFound
end

local vpnDetected = detectVPN()
local proxyHost, proxyPort = detectProxy()
local dangerousApps = scanForDangerousApps()

local threats = {}

if vpnDetected then
    table.insert(threats, "Active VPN (TUN/PPP)")
end

if proxyHost then
    table.insert(threats, "Proxy: " .. proxyHost .. ":" .. (proxyPort or "N/A"))
end

if #dangerousApps > 0 then
    for _, app in ipairs(dangerousApps) do
        table.insert(threats, app.name .. " [" .. app.packageName .. "] - " .. app.detectionReason)
    end
end

if #threats > 0 then
    local alert = "VPN DETECTED!\n\n"
    for i, threat in ipairs(threats) do
        alert = alert .. i .. ". " .. threat .. "\n"
    end   
    gg.alert(alert)
    os.exit()
end

gg.alert("Done - No Vpn detected")

--start your script here