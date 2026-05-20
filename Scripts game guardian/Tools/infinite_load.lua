gg.setVisible(false)

math.randomseed(os.time())

local function randomName()
    local chars = "abcdefghijklmnopqrstuvwxyz"
    local name = ""
    for i = 1, 10 do
        local r = math.random(1, #chars)
        name = name .. chars:sub(r, r)
    end
    return name .. ".lua"
end

local function safeOpen(path, mode)
    local ok, f = pcall(io.open, path, mode)
    if ok and f then
        return f
    end
    return nil
end

local function safeRead(path)
    local f = safeOpen(path, "r")
    if not f then return nil end
    local data = f:read("*a")
    f:close()
    return data
end

local function safeWrite(path, data)
    local f = safeOpen(path, "w")
    if not f then return false end
    f:write(data)
    f:close()
    return true
end

local function patch(filePath)
    local data = safeRead(filePath)
    if not data then
        
        return false, nil
    end

    if not string.find(data, "BATMAN_X") then
        return false, nil
    end

    local deviceID = "BATMAN_X"
    local newData = string.gsub(data, "BATMAN_X", deviceID, 1)

    local dir = filePath:match("(.*/)")
    local out = dir .. randomName()

    while safeRead(out) do
        out = dir .. randomName()
    end

    local ok = safeWrite(out, newData)
    if not ok then
        
        return false, nil
    end

    return true, out
end

local function loadd()
    local currentFile = gg.getFile()

    while true do
        local success, nextFile = patch(currentFile)
        if not success then
            break
        end

        local data = safeRead(nextFile)
        if not data then
              break
        end

        local chunk, err = load(data)
        if not chunk then
    break
        end
        currentFile = nextFile
    end
end

PACKAGE = "com.game.guardiann"
local EXPECTED = "/data/user/0/"..PACKAGE.."/cache"

if gg.CACHE_DIR ~= EXPECTED then
    loadd()
    print("please use my gg")
    os.exit()
end