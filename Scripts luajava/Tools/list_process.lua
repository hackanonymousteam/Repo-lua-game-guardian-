import "android.app.*"
import "android.content.*"
import "android.os.*"
import "java.io.*"
import "java.util.*"
import "android.os.Debug$MemoryInfo"

function getProcessMemoryUsage(pid)
    local memoryUsage = {
        pss = "N/A",
        uss = "N/A", 
        privateDirty = "N/A",
        total = "N/A"
    }
    
    pcall(function()
        local activityManager = activity.getSystemService(Context.ACTIVITY_SERVICE)
        local pids = { tonumber(pid) }
        local memoryStats = activityManager.getProcessMemoryInfo(pids)
        
        if memoryStats and #memoryStats > 0 then
            local memInfo = memoryStats[1]
            memoryUsage.pss = tostring(math.floor(memInfo.getTotalPss() / 1024)) .. " MB"
            memoryUsage.uss = tostring(math.floor(memInfo.getTotalPrivateDirty() / 1024)) .. " MB"
            memoryUsage.privateDirty = tostring(math.floor(memInfo.getTotalPrivateDirty() / 1024)) .. " MB"
            memoryUsage.total = tostring(math.floor(memInfo.getTotalPss() / 1024)) .. " MB"
        end
    end)
    
    return memoryUsage
end

function getProcessDetailedInfo(pid, processName)
    local info = {
        memory = "N/A",
        status = "N/A",
        threads = "N/A",
        importance = "N/A",
        architecture = "32-bit"
    }
    
    pcall(function()
        local activityManager = activity.getSystemService(Context.ACTIVITY_SERVICE)
        
        local pids = { tonumber(pid) }
        local memoryStats = activityManager.getProcessMemoryInfo(pids)
        
        if memoryStats and #memoryStats > 0 then
            local memInfo = memoryStats[1]
            info.memory = tostring(math.floor(memInfo.getTotalPss() / 1024)) .. " MB"
        end
        
        local runningApps = activityManager.getRunningAppProcesses()
        for i = 0, runningApps.size() - 1 do
            local app = runningApps.get(i)
            if tostring(app.pid) == pid then
                info.importance = getImportanceText(app.importance)
                
                if processName:find("64") or processName:find("x64") or processName:find("64bit") then
                    info.architecture = "64-bit"
                else
                    info.architecture = "32-bit"
                end
                break
            end
        end
    end)
    
    return info
end

function getImportanceText(importance)
    local importanceMap = {
        [ActivityManager.RunningAppProcessInfo.IMPORTANCE_FOREGROUND] = "Foreground",
        [ActivityManager.RunningAppProcessInfo.IMPORTANCE_VISIBLE] = "Visible", 
        [ActivityManager.RunningAppProcessInfo.IMPORTANCE_PERCEPTIBLE] = "Perceptible",
        [ActivityManager.RunningAppProcessInfo.IMPORTANCE_CANT_SAVE_STATE] = "Cant Save State",
        [ActivityManager.RunningAppProcessInfo.IMPORTANCE_SERVICE] = "Service",
        [ActivityManager.RunningAppProcessInfo.IMPORTANCE_BACKGROUND] = "Background",
        [ActivityManager.RunningAppProcessInfo.IMPORTANCE_EMPTY] = "Empty",
        [ActivityManager.RunningAppProcessInfo.IMPORTANCE_GONE] = "Terminated"
    }
    
    return importanceMap[importance] or "Unknown (" .. tostring(importance) .. ")"
end

function listAllRunningProcessesWithMemory()
    local activityManager = activity.getSystemService(Context.ACTIVITY_SERVICE)
    if not activityManager then 
        gg.alert("Error: Cannot get Activity Manager")
        return {} 
    end
    
    local runningProcesses = activityManager.getRunningAppProcesses()
    if not runningProcesses or runningProcesses.size() == 0 then 
        gg.alert("Error: No processes found")
        return {} 
    end
    
    local allProcesses = {}
    local totalMemoryUsed = 0
    
    gg.toast("Calculating memory usage...", true)
    
    for i = 0, runningProcesses.size() - 1 do
        local process = runningProcesses.get(i)
        local processName = process.processName or "Unknown"
        local pid = tostring(process.pid)
        local uid = tostring(process.uid)
        
        local detailedInfo = getProcessDetailedInfo(pid, processName)
        local memoryUsage = getProcessMemoryUsage(pid)
        
        if memoryUsage.total ~= "N/A" then
            totalMemoryUsed = totalMemoryUsed + tonumber(string.match(memoryUsage.total, "(%d+)")) or 0
        end
        
        table.insert(allProcesses, {
            name = processName,
            pid = pid,
            uid = uid,
            memory = memoryUsage.total,
            memoryDetailed = memoryUsage,
            importance = detailedInfo.importance,
            architecture = detailedInfo.architecture,
            index = i + 1
        })
    end
    
    return allProcesses, runningProcesses.size(), totalMemoryUsed
end

function showProcessesWithMemory()
    gg.toast("Collecting detailed information...", true)
    
    local allProcesses, totalCount, totalMemoryUsed = listAllRunningProcessesWithMemory()
    
    if #allProcesses == 0 then
        gg.alert("No processes found!", "OK")
        return
    end
    
    table.sort(allProcesses, function(a, b)
        local memA = tonumber(string.match(a.memory or "0", "(%d+)")) or 0
        local memB = tonumber(string.match(b.memory or "0", "(%d+)")) or 0
        return memA > memB
    end)
    
    local message = string.format("RUNNING PROCESSES (%d):\n\n", totalCount)
    message = message .. string.format("Total Memory Used: ~%d MB\n\n", totalMemoryUsed)
    
    for i, process in ipairs(allProcesses) do
        if i <= 20 then
            message = message .. string.format(
                "%d. %s\n" ..
                "   PID: %s | %s | %s\n" ..
                "   Memory: %s | Status: %s\n\n",
                i, 
                string.sub(process.name, 1, 30),
                process.pid, 
                process.architecture,
                process.uid,
                process.memory,
                process.importance
            )
        end
    end
    
    if #allProcesses > 20 then
        message = message .. string.format("\n... and %d more processes\n", #allProcesses - 20)
    end
    
    message = message .. string.format("\nTotal: %d processes | Memory: ~%d MB", #allProcesses, totalMemoryUsed)
    
    gg.alert(message, "OK")
end

function showTopMemoryUsers()
    local allProcesses = listAllRunningProcessesWithMemory()
    
    if #allProcesses == 0 then
        gg.alert("No processes found!", "OK")
        return
    end
    
    table.sort(allProcesses, function(a, b)
        local memA = tonumber(string.match(a.memory or "0", "(%d+)")) or 0
        local memB = tonumber(string.match(b.memory or "0", "(%d+)")) or 0
        return memA > memB
    end)
    
    local message = "TOP 10 - MEMORY USAGE:\n\n"
    local totalMemory = 0
    
    for i = 1, math.min(10, #allProcesses) do
        local process = allProcesses[i]
        local memoryValue = tonumber(string.match(process.memory or "0", "(%d+)")) or 0
        totalMemory = totalMemory + memoryValue
        
        message = message .. string.format(
            "%d. %s\n" ..
            "   %s | PID: %s | %s\n" ..
            "   Status: %s\n\n",
            i,
            string.sub(process.name, 1, 25),
            process.memory,
            process.pid,
            process.architecture,
            process.importance
        )
    end
    
    message = message .. string.format("Total Top 10 Memory: ~%d MB", totalMemory)
    
    gg.alert(message, "OK")
end

function showProcessDetails()
    local search = gg.prompt({
        "Enter process name or PID:"
    }, {""}, {"text"})
    
    if not search or search[1] == "" then return end
    
    local searchTerm = search[1]
    local allProcesses = listAllRunningProcessesWithMemory()
    local foundProcesses = {}
    
    for _, process in ipairs(allProcesses) do
        if string.find(string.lower(process.name), string.lower(searchTerm), 1, true) or
           process.pid == searchTerm then
            table.insert(foundProcesses, process)
        end
    end
    
    if #foundProcesses == 0 then
        gg.alert("No process found with: " .. searchTerm, "OK")
        return
    end
    
    for _, process in ipairs(foundProcesses) do
        local message = string.format(
            "PROCESS DETAILS:\n\n" ..
            "Name: %s\n" ..
            "PID: %s\n" ..
            "UID: %s\n" ..
            "Architecture: %s\n" ..
            "Total Memory: %s\n" ..
            "Status: %s\n\n" ..
            "Memory Details:\n" ..
            "   PSS: %s\n" ..
            "   USS: %s\n" ..
            "   Private Dirty: %s",
            process.name,
            process.pid,
            process.uid,
            process.architecture,
            process.memory,
            process.importance,
            process.memoryDetailed.pss,
            process.memoryDetailed.uss,
            process.memoryDetailed.privateDirty
        )
        
        gg.alert(message, "OK")
        
        if #foundProcesses > 1 then
            local continuee = gg.choice(
                {"Next Process", "Exit"}, 
                nil, 
                string.format("Showing %d of %d processes", _, #foundProcesses)
            )
            if continuee ~= 1 then break end
        end
    end
end

function showSystemStats()
    local activityManager = activity.getSystemService(Context.ACTIVITY_SERVICE)
    local runningProcesses = activityManager.getRunningAppProcesses()
    
    if not runningProcesses then
        gg.alert("Error getting processes")
        return
    end
    
    local totalProcesses = runningProcesses.size()
    
    local memoryInfo = android.app.ActivityManager.MemoryInfo()
    activityManager.getMemoryInfo(memoryInfo)
    
    local totalMem = math.floor(memoryInfo.totalMem / (1024 * 1024 * 1024) * 100) / 100
    local availMem = math.floor(memoryInfo.availMem / (1024 * 1024 * 1024) * 100) / 100
    local usedMem = totalMem - availMem
    
    local allProcesses, _, totalMemoryUsed = listAllRunningProcessesWithMemory()
    
    local statsMessage = string.format(
        "SYSTEM STATISTICS:\n\n" ..
        "Total Processes: %d\n" ..
        "Total System Memory: %.2f GB\n" ..
        "Used System Memory: %.2f GB\n" ..
        "Available Memory: %.2f GB\n" ..
        "Memory Used by Processes: ~%d MB\n" ..
        "Low Memory: %s",
        totalProcesses, totalMem, usedMem, availMem, totalMemoryUsed,
        memoryInfo.lowMemory and "YES" or "NO"
    )
    
    gg.alert(statsMessage, "OK")
end

function mainMenu()
    local menu = {
        "Show All Processes (with Memory)",
        "Top 10 Memory Usage", 
        "Specific Process Details",
        "System Statistics",
        "Refresh Information",
        "Exit"
    }
    
    local choice = gg.choice(menu, nil, "PROCESS MEMORY MONITOR")
    
    if choice == 1 then
        showProcessesWithMemory()
    elseif choice == 2 then
        showTopMemoryUsers()
    elseif choice == 3 then
        showProcessDetails()
    elseif choice == 4 then
        showSystemStats()
    elseif choice == 5 then
        gg.toast("Refreshing...", true)
    elseif choice == 6 then
        gg.alert("Exiting monitor...", "OK")
        os.exit()
    end
    
    mainMenu()
end

gg.toast("Loading memory monitor...", true)
gg.alert("PROCESS MEMORY MONITOR\n\nComplete detection of:\n\n• Memory usage per process (MB)\n• Process architecture (32/64-bit)\n• Status and importance\n• Detailed memory information\n• Top 10 memory consumers", "START MONITOR")

mainMenu()