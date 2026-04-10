LOG_MODE = "both"
LOG_LEVEL = 5
LOG_PROGRAM = "GGExecutor"

local LOG_LEVELS = {
    [1] = "OFF",
    [2] = "FATAL",
    [3] = "ERROR", 
    [4] = "WARN",
    [5] = "INFO",
    [6] = "DEBUG",
    [7] = "TRACE"
}

local function log(level, message)
    if level > LOG_LEVEL then return end
    
    local timestamp = os.date("%H:%M:%S")
    local level_str = LOG_LEVELS[level] or "LOG"
    local formatted = string.format("[%s][%s] %s", timestamp, level_str, message)
    
    if LOG_MODE == "print" or LOG_MODE == "both" then
        print(formatted)
    end
    
    if LOG_MODE == "toast" or LOG_MODE == "both" then
        gg.toast(formatted, false)
    end
end

function LOG_FATAL(msg) log(2, msg) end
function LOG_ERROR(msg) log(3, msg) end 
function LOG_WARN(msg)  log(4, msg) end
function LOG_INFO(msg)  log(5, msg) end
function LOG_DEBUG(msg) log(6, msg) end
function LOG_TRACE(msg) log(7, msg) end

local ORIGINAL = {
    os = {
        time = os.time,
        exit = os.exit
    },
    string = {
        rep = string.rep
    },
    debug = {
        traceback = debug.traceback
    },
    gg = {
        searchNumber = gg.searchNumber,
        refineNumber = gg.refineNumber,
        getResults = gg.getResults,
        editAll = gg.editAll,
        clearResults = gg.clearResults,
    }
}

local FIXED_TIME = os.time()
os.time = function() return FIXED_TIME end

os.exit = function(code)
    local msg = "Script tried to exit"
    if code then msg = msg .. " with code: "..tostring(code) end
    gg.toast(msg, true)
    LOG_ERROR(msg)
end

gg.searchNumber = function(value, type, mask, sign, range)
    local params = string.format(
        "Value: %s, Type: %s, Mask: %s, Sign: %s, Range: %s",
        tostring(value),
        tostring(type or "nil"),
        tostring(mask or "nil"),
        tostring(sign or "nil"),
        tostring(range or "nil")
    )
    LOG_DEBUG("gg.searchNumber: "..params)
    print("CALL gg.searchNumber: "..params)
    return ORIGINAL.gg.searchNumber(value, type, mask, sign, range)
end

gg.refineNumber = function(value, type, mask, sign, range)
    local params = string.format(
        "Value: %s, Type: %s, Mask: %s, Sign: %s, Range: %s",
        tostring(value),
        tostring(type or "nil"),
        tostring(mask or "nil"),
        tostring(sign or "nil"),
        tostring(range or "nil")
    )
    LOG_DEBUG("gg.refineNumber: "..params)
    print("CALL gg.refineNumber: "..params)
    return ORIGINAL.gg.refineNumber(value, type, mask, sign, range)
end

gg.getResults = function(count, type)
    local params = string.format(
        "Count: %s, Type: %s",
        tostring(count),
        tostring(type or "nil")
    )
    LOG_DEBUG("gg.getResults: "..params)
    print("CALL gg.getResults: "..params)
    local results = ORIGINAL.gg.getResults(count, type)
    
    if results and #results > 0 then
        local sample = {}
        for i = 1, math.min(3, #results) do
            table.insert(sample, string.format("{address=%X, value=%s, flags=%s}", 
                results[i].address, 
                tostring(results[i].value), 
                tostring(results[i].flags)))
        end
        LOG_DEBUG("Results sample: "..table.concat(sample, ", "))
    end
    
    return results
end

gg.editAll = function(value, type)
    local params = string.format(
        "Value: %s, Type: %s",
        tostring(value),
        tostring(type or "nil")
    )
    LOG_DEBUG("gg.editAll: "..params)
    print("CALL gg.editAll: "..params)
    return ORIGINAL.gg.editAll(value, type)
end

gg.clearResults = function()
    LOG_DEBUG("gg.clearResults called")
    print("CALL gg.clearResults")
    return ORIGINAL.gg.clearResults()
end

local function execute_script(path)
    local file = io.open(path, "r")
    if not file then
        LOG_ERROR("File not found: "..path)
        return false
    end
    file:close()
    
    local sandbox = {
        gg = gg,
        print = print,
        string = string,
        math = math,
        table = table,
    }
    setmetatable(sandbox, {__index = _G})
    
    local chunk, err = loadfile(path, "t", sandbox)
    if not chunk then
        LOG_ERROR("Load error:\n"..(err or "Unknown"))
        return false
    end
    
    local success, result = xpcall(chunk, function(err)
        return debug.traceback(err, 2)
    end)
    
    if not success then
        LOG_ERROR("Runtime error:\n"..(result or "Unknown"))
        return false
    end
    
    return true
end

LOG_INFO("System initialized")

local file_path = gg.prompt(
    {"📁 Select script to execute"},
    {"/sdcard/script.lua"},
    {"file"}
)

if not file_path or not file_path[1] then
    LOG_WARN("No file selected")
    gg.toast("Execution canceled", false)
    return
end

LOG_INFO("Starting execution: "..file_path[1])
gg.toast("Starting script...", false)

if execute_script(file_path[1]) then
    LOG_INFO("Script executed successfully!")
    gg.toast("Script completed!", false)
else
    LOG_ERROR("Script execution failed")
    gg.toast("Execution error", false)
end