function df()
    local randomFuncs = {
        function() return nil end,
        function() return 1 end,
        function() return "Batman" end,
        function() return {nil} end,
        function() return {true} end,
        function() return {false} end,
        function() return function() return 2 end end,
        function() return function() return 3 end end,
        function() return {} end
    }
    
    local results = {}
    for i = 1, 3 do
        table.insert(results, randomFuncs[math.random(1, #randomFuncs)]())
    end
    local decision = results[1] and "Batman" or "No Batman"
    local tableData = {[decision] = "Batman"}
    local finalDecision = tableData[decision] and "Batman" or "Not Batman"
    
    return finalDecision
end

gg.setVisible(false)

function showBouncingText(text)
    local speed = 220 
    local screen_width = 22 
    local textLength = string.len(text)
    
    local batmanStatus = df()
    local displayText = text
    
    if batmanStatus == "Batman" then
        displayText = "🦇 " .. text .. " 🦇"
    end
    
    for i = 1, textLength + screen_width do
        local currentText
        if i <= textLength then
            currentText = string.sub(displayText, 1, i)
        else
            currentText = string.sub(displayText, i - textLength + 1, i)
        end
        gg.toast(currentText)
        gg.sleep(speed)
    end
end

local function isBlocked()
    local cmds = {
        "os.exit()",
        "return os.exit()",
        "gg.alert('Block GG Logger')"
    }
    local pattern = "gg%%.exit"
    local exitStr = tostring(os.exit)
    
    for _, cmd in ipairs(cmds) do
        local success, result = pcall(load(cmd))
        if success or not exitStr:find(pattern) then
            return true
        end
    end
    return false
end

local function protect()
    math.randomseed(os.time() + math.random(1, 99999))
    
    local protectionMessage = "Batman Protection Active"
    if df() == "Batman" then
        protectionMessage = "🦇 Batman Shield Activated 🦇"
    end
    
    while isBlocked() do
        showBouncingText(protectionMessage)
        gg.sleep(1000)
    end
end

pcall(protect)

local function anti_load()
    pcall(function()
        if not gg or not gg.getFile then os.exit() end
        setmetatable(_G, {
            __index = function(_, key)
                if key == "loadfile" or key == "dofile" or key == "load" or key == "loadstring" then
                    return function() print("Blocked unauthorized load", 2) end
                end
            end
        })
    end)
end

anti_load()