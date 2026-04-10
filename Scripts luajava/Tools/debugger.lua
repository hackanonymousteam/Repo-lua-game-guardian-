import "android.app.*"
import "android.content.*"
import "android.os.*"
import "java.io.*"
import "java.util.*"

local CHECK_INTERVAL = 10000 -- 10 seconds
local packageName = activity.getPackageName()

local ignoredPackages = {
    [packageName] = true
}

function identifyProcessesToIgnore(processes, ownPackageName)
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

function isBeingDebugged(pid)
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

function isAccessingMemoryTools(pid)
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

function listRunningProcesses()
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
        

        if processesToIgnore[processName] then

        else
            local isDebugging = false
            local isMemoryTool = false
            

            if isBeingDebugged(pid) then
                isDebugging = true
            end
            
            if isAccessingMemoryTools(pid) then
                isMemoryTool = true
            end
            
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

function quickCheck()
    gg.toast("🔍 starting verify...", true)
    
    local suspicious = listRunningProcesses()
    
    if #suspicious > 0 then
        local alertMessage = "🚨 alert malware!\n\n"
        
        for i, process in ipairs(suspicious) do
            alertMessage = alertMessage .. "📛 " .. process.name .. " (PID: " .. process.pid .. ")\n"
            
            if process.debugging then
                alertMessage = alertMessage .. "   → Debugging Detected\n"
            end
            
            if process.memoryTool then
                alertMessage = alertMessage .. "   → ptrace\n"
            end
            
            alertMessage = alertMessage .. "\n"
        end
        
        gg.alert(alertMessage, "ok")
    else
        gg.alert("✅ checked!\n\ndone", "OK")
        --start script here or start your logic
    end
end

function showSystemStats()
    local activityManager = activity.getSystemService(Context.ACTIVITY_SERVICE)
    local runningProcesses = activityManager.getRunningAppProcesses()
    
    if not runningProcesses then
        gg.alert("❌ error", "OK")
        os.exit()
        return
    end
    
    local totalProcesses = runningProcesses.size()
    local processesToIgnore = identifyProcessesToIgnore(runningProcesses, packageName)
    local ignoredCount = 0
    
    for _ in pairs(processesToIgnore) do
        ignoredCount = ignoredCount + 1
    end
    
    local monitoredCount = totalProcesses - ignoredCount
    
    
end

function table.size(t)
    local count = 0
    for _ in pairs(t) do count = count + 1 end
    return count
end

-- Init
gg.toast("🛡️ Loadong wait...", true)
quickCheck()

--[[

while true do
    if not monitoring then
        --mainMenu()
    else

    end
end

]]--