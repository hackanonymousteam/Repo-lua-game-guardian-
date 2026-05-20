gg.setVisible(true)

local json = load(gg.makeRequest("https://raw.githubusercontent.com/rxi/json.lua/master/json.lua").content)()

local FILE = "/sdcard/ai_chat.json"

local models = {
    gpt5 = {
        name = "GPT-5.1",
        model = "gpt-5.1",
        url = "https://api.voidai.app/v1/chat/completions",
        key =     "YOUR_API_KEY"
    }

}

local current = "gpt5"

local function read()
    local f = io.open(FILE, "r")
    if not f then return {} end
    local c = f:read("*a")
    f:close()
    return json.decode(c) or {}
end

local function save(t)
    local f = io.open(FILE, "w")
    f:write(json.encode(t))
    f:close()
end

local function buildPayload(modelKey, history)
    local m = models[modelKey]
    
    return {
        model = m.model,
        messages = history,
        temperature = 0.7,
        max_tokens = 2000
    }
end

local function parseResponse(content)
    local ok, data = pcall(json.decode, content)
    if not ok or not data then 
        return "Error parsing response: " .. tostring(content)
    end
    
    if data.error then
        return "API Error: " .. (data.error.message or json.encode(data.error))
    end
    
    if data.choices and data.choices[1] then
        return data.choices[1].message.content
    end
    
    return "Unexpected response format: " .. content
end

local function chat(msg)
    local hist = read()
    
    if msg == "clear" then
        save({})
        return "🗑️ History cleared"
    end
    
    if msg == "history" then
        local txt = ""
        for _, v in ipairs(hist) do
            txt = txt .. "👤 " .. v.role .. ": " .. v.content .. "\n\n"
        end
        return txt ~= "" and txt or "📭 Empty history"
    end
    
    table.insert(hist, {role = "user", content = msg})
    
    local payload = buildPayload(current, hist)
    
    local headers = {
        ["Authorization"] = "Bearer " .. models[current].key,
        ["Content-Type"] = "application/json"
    }
    
    local res = gg.makeRequest(
        models[current].url,
        headers,
        json.encode(payload),
        "POST"
    )
    
    if type(res) ~= "table" then
        return "❌ Request failed: Invalid response"
    end
    
    if res.code ~= 200 then
        local errorMsg = "❌ HTTP Error " .. res.code
        if res.content then
            local ok, errData = pcall(json.decode, res.content)
            if ok and errData.error then
                errorMsg = errorMsg .. "\n" .. (errData.error.message or json.encode(errData.error))
            else
                errorMsg = errorMsg .. "\n" .. res.content
            end
        end
        return errorMsg
    end
    
    local reply = parseResponse(res.content)
    
    table.insert(hist, {role = "assistant", content = reply})
    
    while #hist > 20 do 
        table.remove(hist, 1) 
    end
    
    save(hist)
    
    return reply
end



local function setApiKey()
    local p = gg.prompt(
        {"API Key for " .. models[current].name}, 
        {models[current].key}, 
        {"text"}
    )
    if p and p[1] ~= "" then
        models[current].key = p[1]
        gg.toast("✅ API Key updated")
    end
end

while true do
    local c = gg.choice({
        "💬 Chat with AI",
  "🔑 Set API Key",
        "📜 View History",
        "🗑️ Clear History",
        "❌ Exit"
    }, nil, "🤖 AI Assistant - VoidAI")
    
    if c == 1 then
        local p = gg.prompt(
            {"💭 Your message:"}, 
            {""}, 
            {"text"}
        )
        if p and p[1] ~= "" then
            gg.toast("⏳ Processing...")
            local r = chat(p[1])
            gg.alert("🤖 " .. models[current].name .. "\n\n" .. r)
            print("\n🔹 Response:\n" .. r)
        end
    elseif c == 2 then
        
        setApiKey()
    elseif c == 3 then
        local hist = read()
        if #hist == 0 then
            gg.alert("📭 No conversation history")
        else
            local txt = "📜 Conversation History:\n\n"
            for i, v in ipairs(hist) do
                txt = txt .. i .. ". " .. v.role .. ": " .. 
                      string.sub(v.content, 1, 100) .. "...\n\n"
            end
            gg.alert(txt)
        end
    elseif c == 4 then
        save({})
        gg.toast("✅ History cleared")
    else
        gg.toast("👋 Goodbye!")
        break
    end
end