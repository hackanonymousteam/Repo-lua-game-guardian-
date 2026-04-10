
local function getAndroidCPUInfo()
    local file = io.open("/proc/cpuinfo", "r")
    if file then
        local cpuinfo = {}
        for line in file:lines() do
            local key, value = line:match("^%s*([^:]+)%s*:%s*(.+)$")
            if key and value then
                cpuinfo[key] = value
            end
        end
        file:close()
        return cpuinfo
    end
    return nil
end 

local cpuInfo = getAndroidCPUInfo()

if cpuInfo then
    for key, value in pairs(cpuInfo) do
        print("  ", key, ":", value)
    end
end