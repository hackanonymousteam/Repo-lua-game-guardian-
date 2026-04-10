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
  '🕒 add check Suspicious processes ',
  '🕒 add check Dangerous apps ',
  '🔐 add check Suspicious files',
  '🛡️add check vpn',
  '📝 add check proxy',
  '🗳 add detect Packet Capture',
  '👩 Add login shared prefs',
}, g.info, {
  'file', 
  'path',
  'checkbox',
  'checkbox',
  'checkbox',
  'checkbox',
  'checkbox',
  'checkbox',
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
g.out = g.info[2] .. "/" .. g.out .. ".lua"

local file, err = io.open(g.out, "r")  
if file then
  os.remove(g.out)
  file:close()  
end

local file = io.open(g.last, "r")
if not file then
  gg.alert("❌ Error: Could not open source file!")
  return
end

local DATA = file:read('*a')
file:close()

local newContent = ""

if g.info[3] or g.info[4] or g.info[5] or g.info[6] or g.info[7] or g.info[8] then
  newContent = newContent .. [[
local function complexLoop()
    local t = {}
    for i = 1, 100 do
        t[i] = {}
        for j = 1, 50 do
            t[i][j] = string.rep("B", 1024)
        end
    end
    local tmp = 0
    for k, v in pairs(t) do
        tmp = tmp + #v[1]
    end
end

local function createMassiveData()
    local t = {}
    for i = 1, 500 do
        t[i] = {}
        for j = 1, 50 do
            t[i][j] = string.rep("D", 2048)
        end
    end
    local tmp = 0
    for k, v in pairs(t) do
        tmp = tmp + #v[1]
    end
    complexLoop()
end

import "android.app.*"
import "android.content.*"
import "android.os.*"
import "android.content.pm.*"
import "java.io.*"
import "java.util.*"
import "java.net.NetworkInterface"
import "java.util.Collections"
import "java.lang.System"

local packageName = activity.getPackageName()

local dangerousPackages = {
    "com.ghostery", "com.fan.ggluadec", "com.fan.ggxxls", "com.chenlun.autumncloudlua",
    "com.maggienorth.max.postdata", "com.goushi.gtpcanary", "com.packagesniffer.frtparlak",
    "app.greyshirts.sslcapture", "com.minhui.networkcapture", "com.minhui.wifianalyzer",
    "frtparlak.rootsniffer", "jp.co.taosoftware.android.packetcapture"
}

local ignoredPackages = {
    [packageName] = true
}

local suspiciousKeywords = {
    "loadfile", "Loadfile", "LOADFILE", "log", "load", "LOAD", "Log", "decompile", 
    "Decompile", "Hook", "HOOK", "Decode", "DECODE", "decrypt", "Decrypt", 
    "DECRYPT", "decompiler", "DECOMPILER", "Decompiler", "Decryptor", 
    "DECRYPTOR", "Decoding", "DECODING", "decoding", "Hooker", "HOOKER", 
    "loader", "LOADER", "Loader", "Lasm", "LASM", "lasm"
}

local function identifyProcessesToIgnore(processes, ownPackageName)
    local toIgnore = {}
    toIgnore[ownPackageName] = true 
    
    local parentsWithChildren = {}
    local allSubprocesses = {}
    
    for i = 0, processes.size() - 1 do
        local process = processes.get(i)
        local processName = process.processName
        
        for j = 0, processes.size() - 1 do
            local otherProcess = processes.get(j)
            local otherName = otherProcess.processName
            
            if otherName:find(processName .. ":") == 1 then
                parentsWithChildren[processName] = true
                break
            end
        end
    end
    
    for i = 0, processes.size() - 1 do
        local process = processes.get(i)
        local processName = process.processName
        
        for parent in pairs(parentsWithChildren) do
            if processName:find(parent .. ":") == 1 then
                allSubprocesses[processName] = true
                break
            end
        end
    end

    for parent in pairs(parentsWithChildren) do
        toIgnore[parent] = true
    end
    
    for subprocess in pairs(allSubprocesses) do
        toIgnore[subprocess] = true
    end
    
    return toIgnore
end

local function isBeingDebugged(pid)
    local success, result = pcall(function()
        local file = io.open("/proc/" .. pid .. "/status", "r")
        if not file then return false end
        
        for line in file:lines() do
            if line:find("TracerPid") == 1 then
                local tracerPid = line:match("%d+")
                if tracerPid and tonumber(tracerPid) > 0 then
                    file:close()
                    return true
                end
            end
        end
        
        file:close()
        return false
    end)
    
    return success and result or false
end

local function isAccessingMemoryTools(pid)
    local success, result = pcall(function()
        local file = io.open("/proc/" .. pid .. "/maps", "r")
        if not file then return false end
        
        for line in file:lines() do
            if line:find("libgg.so") or 
               line:find("gameguardian") or 
               line:find("libdvm.so") or 
               line:find("libart.so") or
               line:find("frida") or
               line:find("xposed") or
               line:find("libriru") or
               line:find("libsubstrate") then
                file:close()
                return true
            end
        end
        
        file:close()
        return false
    end)
    
    return success and result or false
end

local function listRunningProcesses()
    local activityManager = activity.getSystemService(Context.ACTIVITY_SERVICE)
    if not activityManager then return {} end
    
    local runningProcesses = activityManager.getRunningAppProcesses()
    if not runningProcesses or runningProcesses.size() == 0 then return {} end
    
    local processesToIgnore = identifyProcessesToIgnore(runningProcesses, packageName)
    
    for pkg, _ in pairs(ignoredPackages) do
        processesToIgnore[pkg] = true
    end
    
    local suspiciousProcesses = {}
    
    for i = 0, runningProcesses.size() - 1 do
        local process = runningProcesses.get(i)
        local processName = process.processName
        local pid = tostring(process.pid)
        
        if not processesToIgnore[processName] then
            local isDebugging = isBeingDebugged(pid)
            local isMemoryTool = isAccessingMemoryTools(pid)
            
            if isDebugging or isMemoryTool then
                table.insert(suspiciousProcesses, {
                    name = processName,
                    pid = pid,
                    debugging = isDebugging,
                    memoryTool = isMemoryTool
                })
            end
        end
    end
    
    return suspiciousProcesses
end

local function checkDangerousApps()
    local packageManager = activity.getPackageManager()
    local apps = packageManager.getInstalledApplications(PackageManager.GET_META_DATA)
    local dangerousApps = {}
    
    for i = 0, #apps - 1 do
        local app = apps[i]
        if (app.flags & ApplicationInfo.FLAG_SYSTEM) == 0 then
            local packageName = app.packageName
            local isDangerous, pattern = false, nil
            local lowerPackageName = string.lower(packageName)
            
            for _, dangerousPattern in ipairs(dangerousPackages) do
                if string.find(lowerPackageName, string.lower(dangerousPattern)) then
                    isDangerous = true
                    pattern = dangerousPattern
                    break
                end
            end
            
            if isDangerous then
                table.insert(dangerousApps, {
                    name = packageManager.getApplicationLabel(app) or "Unknown",
                    packageName = packageName,
                    detectionReason = "Matches dangerous pattern: " .. pattern
                })
            end
        end
    end
    
    return dangerousApps
end

local function checkSuspiciousFiles()
    local t_dir = gg.FILES_DIR
    local original_path = t_dir:gsub("files", "shared_prefs/" .. gg.PACKAGE .. "_preferences.xml")
    
    local content = file.read(original_path)
    if content then
        for _, w in ipairs(suspiciousKeywords) do
            if content:find(w) then
                return true, "Found suspicious keyword in preferences: " .. w
            end
        end
    end
    
    local folders = {}
    if content then
        for name, path in string.gmatch(content, '<string name="(history%-%d+)">(.-)</string>') do
            local folder = path
            if folder:match("%.lua$") or folder:match("%..+[^/]*$") then
                folder = folder:match("(.*/)")
                if folder then
                    folder = folder:gsub("/$", "")
                end
            end
            if folder and #folder > 25 and not folders[folder] then
                table.insert(folders, folder)
                folders[folder] = true
            end
        end
    end
    
    local extensions = {".tar", ".lasm", ".tail", "log.txt"}
    for _, folder in ipairs(folders) do
        local files = file.list(folder)
        if files and type(files) == "table" then
            for _, filename in ipairs(files) do
                local lower = filename:lower()
                for _, ext in ipairs(extensions) do
                    if lower:sub(-#ext) == ext then
                        return true, "Suspicious file found: " .. filename .. " in " .. folder
                    end
                end
            end
        end
    end
    
    return false
end

local function checkVPN()
    local niList = NetworkInterface.getNetworkInterfaces()
    if niList ~= nil then
        local it = Collections.list(niList).iterator()
        while it.hasNext() do
            local intf = it.next()
            if intf.isUp() and intf.getInterfaceAddresses().size() ~= 0 then
                local name = intf.getName()
                if name == "tun0" or name == "ppp0" then
                    return true, "VPN detected: " .. name
                end
            end
        end
    end
    return false
end

local function checkProxy()
    local httpHost = System.getProperty("http.proxyHost")
    local httpPort = System.getProperty("http.proxyPort")
    if httpHost ~= nil and httpHost ~= "" then
        return true, "Proxy detected: " .. httpHost .. ":" .. (httpPort or "")
    end
    return false
end

local function detectPacketCapture()
    if gg.isVPN() then
        gg.alert("🚨 VPN detected - possible packet capture!")
        return true
    end
    local captureApps = {
        "com.guoship.capture",
        "com.minhui.networkcapture", 
        "app.greyshirts.sslcapture"
    }
    
    for _, pkg in ipairs(captureApps) do
        if tools.isPackageInsta(pkg) then
            gg.alert("🚨 Packet capture app installed: " .. pkg)
            createMassiveData()
            complexLoop()
            os.exit()
            return true
        end
    end
    
    return false
end

]]
end

if g.info[3] == true then
  newContent = newContent .. [[
local suspiciousProcesses = listRunningProcesses()
if #suspiciousProcesses > 0 then
    gg.alert("🚨 Suspicious processes detected!", "OK")
    createMassiveData()
    complexLoop()
    os.exit()
end
]]
end

if g.info[4] == true then
  newContent = newContent .. [[
local dangerousApps = checkDangerousApps()
if #dangerousApps > 0 then
    gg.alert("🚨 Dangerous apps detected!", "OK")
    createMassiveData()
    complexLoop()
    os.exit()
end
]]
end

if g.info[5] == true then
  newContent = newContent .. [[
local hasSuspiciousFiles, fileReason = checkSuspiciousFiles()
if hasSuspiciousFiles then
    gg.alert("🚨 " .. fileReason, "OK")
    createMassiveData()
    complexLoop()
    os.exit()
end
]]
end

if g.info[6] == true then
  newContent = newContent .. [[
local hasVPN, vpnReason = checkVPN()
if hasVPN then
    gg.alert("🚨 " .. vpnReason, "OK")
    createMassiveData()
    complexLoop()
    os.exit()
end
]]
end

if g.info[7] == true then
  newContent = newContent .. [[
local hasProxy, proxyReason = checkProxy()
if hasProxy then
    gg.alert("🚨 " .. proxyReason, "OK")
    createMassiveData()
    complexLoop()
    os.exit()
end
]]
end

if g.info[8] == true then
  newContent = newContent .. [[
detectPacketCapture()
]]
end

if g.info[9] == true then
  local LOGIN = gg.prompt({ 
      "🕵 Sᴇᴛ Usᴇʀɴᴀᴍᴇ Fᴏʀ Sᴄʀɪᴘᴛ :",
      "🔐 Sᴇᴛ Pᴀssᴡᴏʀᴅ Fᴏʀ Sᴄʀɪᴘᴛ :", 
      "📝 Tʏᴘᴇ Mᴇssᴀɢᴇ Fᴏʀ Sᴜᴄᴄᴇs Lᴏɢɪɴ :"
  }, {"Batman", "games", "🎉 Sᴜᴄᴄᴇss Lᴏɢɪɴ! 🎉"}, { "text", "text", "text"}) 
  
  if LOGIN and LOGIN[1] ~= '' and LOGIN[2] ~= '' then
    newContent = newContent .. [[

import "android.content.Context"

local PREFS_NAME = "script_login_prefs"
local USER_KEY = "username"
local PASS_KEY = "password"

local function setupCredentials()
    local sharedPrefs = activity.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
    local editor = sharedPrefs.edit()
    
  
    editor.putString(USER_KEY, "]] .. LOGIN[1] .. [[")
    editor.putString(PASS_KEY, "]] .. LOGIN[2] .. [[")
    editor.commit()
    
    return sharedPrefs
end

local function loginUser()
    
    local sharedPrefs = setupCredentials()
 
    local savedUser = sharedPrefs.getString(USER_KEY, "")
    local savedPass = sharedPrefs.getString(PASS_KEY, "")
    
    local result = gg.prompt(
        {"🕵 Usᴇʀɴᴀᴍᴇ:", "🔐 Pᴀssᴡᴏʀᴅ:"},
        {"", ""},
        {"text", "text"}
    )
    
    if result == nil then
        gg.alert("❌ Lᴏɢɪɴ Cᴀɴᴄᴇʟᴇᴅ! ❌")
        return false
    end
    
    local inputUser = result[1] or ""
    local inputPass = result[2] or ""
    
    if inputUser == "" then
        gg.alert("⚠️ Usᴇʀɴᴀᴍᴇ Cᴀɴɴᴏᴛ Bᴇ Eᴍᴘᴛʏ! ⚠️")
        return false
    end
    
    if inputPass == "" then
        gg.alert("⚠️ Pᴀssᴡᴏʀᴅ Cᴀɴɴᴏᴛ Bᴇ Eᴍᴘᴛʏ! ⚠️")
        return false
    end
    
    if inputUser == savedUser and inputPass == savedPass then
        gg.toast("]] .. LOGIN[3] .. [[")
        return true
    else
        gg.alert("❌ Iɴᴠᴀʟɪᴅ Usᴇʀɴᴀᴍᴇ ᴏʀ Pᴀssᴡᴏʀᴅ! ❌")
        return false
    end
end

gg.toast("🔐 Lᴏᴀᴅɪɴɢ Lᴏɢɪɴ Sʏsᴛᴇᴍ...")
gg.sleep(1000)

if not loginUser() then
    print("❌ Lᴏɢɪɴ Fᴀɪʟᴇᴅ! Exiting script. ❌")
    os.exit()
end

gg.sleep(500)
gg.toast("]] .. LOGIN[3] .. [[")
gg.sleep(500)

]]
  else
    gg.alert("❌ Invalid credentials for SharedPreferences login!")
  end
end

newContent = newContent .. "\n" .. DATA

local outFile = io.open(g.out, "w")
if outFile then
  outFile:write(newContent)
  outFile:close()
  
  gg.alert('📂 File Saved To: '..g.out..'\n', 'Success')
  print("\n▬▬▬▬▬▬▬▬▬▬▬▬▬\n📂 File Saved To: " .. g.out .. "\n▬▬▬▬▬▬▬▬▬▬▬▬▬")
else
  gg.alert("❌ Error: Could not create output file!")
end

return