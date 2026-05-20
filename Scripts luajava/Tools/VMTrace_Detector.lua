if luajava == nil then gg.alert(' unavaliable please use gameguardian mod (suport luajava)') else end

if type(gg.shell) ~= "function" then
    gg.alert("shell not available use game guardian mod luajava")
    os.exit()
end

local result = gg.shell("ps")
local process_map = {}

for line in result:gmatch("[^\n]+") do
    if not line:match("^USER%s+") then
        local pid, name = line:match("^%S+%s+(%d+)%s+%d+%s+%d+%s+%d+%s+%S+%s+%S+%s+%S+%s+(%S+)$")
        if pid and name then
            local base = name:match("^([^:]+)")
            if base then
                if not process_map[base] then
                    process_map[base] = {}
                end
                table.insert(process_map[base], {pid = pid, name = name})
            end
        end
    end
end

local all_suspect_pids = {}
local virtual_detected = false
local virtual_names = {}

for base, processes in pairs(process_map) do
    if #processes >= 3 then
        virtual_detected = true
        for _, proc in ipairs(processes) do
            table.insert(virtual_names, proc.name)
            table.insert(all_suspect_pids, proc)
        end
    end
end

if not virtual_detected then
    gg.alert("THIS SCRIPT WORK ONLY IN VIRTUAL SPACE...")
    os.exit()
end

local msg = "VIRTUAL SPACE DETECTED\n\nProcess variations found:\n"
for _, name in ipairs(virtual_names) do
    msg = msg .. "• " .. name .. "\n"
end
--gg.alert(msg)

local virtualization_confirmed = false

for _, proc in ipairs(all_suspect_pids) do
    local pid = proc.pid
    local name = proc.name
    
    local fd = gg.shell("ls -l /proc/" .. pid .. "/fd 2>/dev/null")
    
    if fd and fd ~= "" then
        local ashmem = 0
        local deleted_apk = 0
        
        for line in fd:gmatch("[^\n]+") do
            if line:match("->%s+/dev/ashmem$") then
                ashmem = ashmem + 1
            end
            if line:match("base%.apk.*%(deleted%)") or line:match("%(deleted%)$") then
                deleted_apk = deleted_apk + 1
            end
        end
        
        if ashmem > 50 or deleted_apk > 0 then
            virtualization_confirmed = true            
            gg.alert("Virtualization confirmed!\n\nProcess: " .. name .. "\nPID: " .. pid .. "\nAshmem: " .. ashmem .. "\nDeleted APK: " .. deleted_apk)
            break
        end
    end
end

if virtualization_confirmed then
    gg.alert("Virtual space validation passed!\nContinuing script...")      
else
    gg.alert("VIRTUAL SPACE DETECTED BUT NO LAYER FOUND\n\nProcess variations exist but no ashmem/deleted APK detected.\nExiting...")
    os.exit()
end

--start your script here
gg.alert("done")
