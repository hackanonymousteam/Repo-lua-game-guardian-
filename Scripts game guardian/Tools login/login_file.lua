local PASSWORD = "BATMAN"
local ERROR = "MS"
local FILE_PATH = "/sdcard/5.453"

local file = io.open(FILE_PATH, "r")
local fileExists = false
local DATA = nil

if file ~= nil then
    fileExists = true
    DATA = file:read("*a")
    file:close()
end

if not fileExists then
    local input = gg.prompt({"insert your password"}, {""}, {"text"})
    if input == nil then
        os.exit()
    end

    local key = input[1]

    if key == PASSWORD then
        local f = io.open(FILE_PATH, "w")
        if f then
            f:write(PASSWORD)
            f:close()
        end
    else
        local f = io.open(FILE_PATH, "a")
        if f then
            f:write(ERROR)
            f:close()
        end
        gg.alert("pass wrong!!")
        os.exit()
    end
else
    if DATA ~= PASSWORD then
        local f = io.open(FILE_PATH, "a")
        if f then
            f:write(ERROR)
            f:close()
        end
        gg.alert("pass wrong!!")
        os.exit()
    end
end

if gg.isVisible(true) then
    gg.setVisible(false)
end

local arg = {...}
gg.alert("done")
if arg and arg[1] and arg[2] and arg[3] then
    local env = _ENV[arg[3]]
    if env and env[arg[1]] then
        return env[arg[1]](arg[2])
    end
    gg.alert("error")
end