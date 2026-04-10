function getStorageInfo()
    local statFs = luajava.newInstance("android.os.StatFs", "/sdcard")
    local blockSize = statFs:getBlockSizeLong() 
    local totalBlocks = statFs:getBlockCountLong() 
    local availableBlocks = statFs:getAvailableBlocksLong() 

    local totalStorage = (totalBlocks * blockSize) / (1024 * 1024 * 1024) 
    local availableStorage = (availableBlocks * blockSize) / (1024 * 1024 * 1024)

    return string.format("Total: %.2f GB/: %.2f GB", totalStorage, availableStorage)
end

function getARMArchitecture()
    local build = luajava.bindClass("android.os.Build")
    return build.CPU_ABI or "Unknown"
end

function getDeviceDetails()
    local build = luajava.bindClass("android.os.Build")
    local version = luajava.bindClass("android.os.Build$VERSION")
    
    return {
        Model = build.MODEL or "Unknown",
        Manufacturer = build.MANUFACTURER or "Unknown",
        AndroidVersion = version.RELEASE or "Unknown",
        SDK = version.SDK_INT or "Unknown",
        Product = build.PRODUCT or "Unknown",
        ID = build.ID or "Not Found !",
    }
end

local Tools = luajava.bindClass("android.ext.Tools")
local Context = luajava.bindClass("android.content.Context")
local InetAddress = luajava.bindClass("java.net.InetAddress")
local NetworkInterface = luajava.bindClass("java.net.NetworkInterface")

local function getDeviceIP()
    local interfaces = NetworkInterface:getNetworkInterfaces()
    while interfaces:hasMoreElements() do
        local networkInterface = interfaces:nextElement()
        if networkInterface:isUp() and not networkInterface:isLoopback() then
            local addresses = networkInterface:getInetAddresses()
            while addresses:hasMoreElements() do
                local address = addresses:nextElement()
                if address:isSiteLocalAddress() and not address:isLoopbackAddress() and not address:isLinkLocalAddress() then
                    return address:getHostAddress()
                end
            end
        end
    end
    return "Tidak ada alamat IP yang ditemukan."
end

function displayInfo(packageName, armArchitecture, formattedTime, formattedDate, deviceInfo, ipAddress, ipType, storageInfo)
    return string.format(
        "≡ Package: %s\n" ..
        "≡ Time: %s\n" ..
        "≡ Date: %s\n" ..
        "≡ Model: %s\n" ..
        "≡ Manufacturer: %s\n" ..
        "≡ Architecture: %s\n" ..
        "≡ Android Version: %s\n" ..
        "≡ SDK: %s\n" ..
        "≡ ID: %s\n" ..
        "≡ IP: %s (%s)\n"..
        "≡ Storage: %s (%s)\n",
        packageName, formattedTime, formattedDate,
        deviceInfo.Model, deviceInfo.Manufacturer, armArchitecture,
        deviceInfo.AndroidVersion, deviceInfo.SDK, deviceInfo.ID,
        ipAddress, ipType, storageInfo
    )
end

function INFO_USER()
    local packageName = gg.getTargetPackage()
    local armArchitecture = getARMArchitecture()
    local formattedTime = os.date("%H:%M:%S")
    local formattedDate = os.date("%d-%m-%Y")
    local deviceInfo = getDeviceDetails()
    local storageInfo = getStorageInfo()
    
    local ipToSend, ipType

    if wifiIp ~= "Wi-Fi tidak aktif" then
        ipToSend = wifiIp
        ipType = "WIFI"
    else
        ipToSend = deviceIp
        ipType = "DEVICE"
    end
    
    local info = displayInfo(packageName, armArchitecture, formattedTime, formattedDate, deviceInfo, ipToSend, ipType, storageInfo)

    local completeInfo = info
    
    gg.alert("「 ✦ Info User  ✦ 」\n\n" .. completeInfo)
    
end

INFO_USER()