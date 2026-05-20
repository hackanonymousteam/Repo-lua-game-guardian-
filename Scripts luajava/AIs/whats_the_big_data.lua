gg.setVisible(true)

local json = load(gg.makeRequest("https://raw.githubusercontent.com/rxi/json.lua/master/json.lua").content)()

local FILE = "/sdcard/ai_chat.json"
local API_URL = "https://whatsthebigdata.com/api/ask-ai/"

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

local function parseResponse(content)
    local ok, data = pcall(json.decode, content)
    if not ok or not data then 
        return "Error parsing response"
    end
    
    if data.text then
        return data.text
    end
    
    return "No response text"
end

local function chat(msg)
    local hist = read()
    
    if msg == "clear" then
        save({})
        return "History cleared"
    end
    
    if msg == "history" then
        local txt = ""
        for _, v in ipairs(hist) do
            txt = txt .. v.role .. ": " .. v.content .. "\n\n"
        end
        return txt ~= "" and txt or "Empty history"
    end
    
    table.insert(hist, {role = "user", content = msg})
    
    local payload = {
        message = msg,
        model = "mistral-large",
        history = {}
    }
    
    for i = 1, #hist - 1 do
        table.insert(payload.history, {
            role = hist[i].role,
            content = hist[i].content
        })
    end
    
    local headers = {
        ["Content-Type"] = "application/json",
        ["Origin"] = "https://whatsthebigdata.com",
        ["Referer"] = "https://whatsthebigdata.com/ai-chat/",
        ["User-Agent"] = "Mozilla/5.0"
    }
    
    local res = gg.makeRequest(
        API_URL,
        headers,
        json.encode(payload),
        "POST"
    )
    
    if type(res) ~= "table" then
        return "Request failed"
    end
    
    if res.code ~= 200 then
        return "HTTP Error " .. res.code
    end
    
    local reply = parseResponse(res.content)
    
    table.insert(hist, {role = "assistant", content = reply})
    
    while #hist > 20 do 
        table.remove(hist, 1) 
    end
    
    save(hist)
    
    return reply
end

while true do
    local c = gg.choice({
        "Chat with Mistral Large",
        "View History",
        "Clear History",
        "Exit"
    }, nil, "Mistral Large AI")
    
    if c == 1 then
        local p = gg.prompt({"Message:"}, {""}, {"text"})
        if p and p[1] ~= "" then
            gg.toast("Processing...")
            local r = chat(p[1])
            gg.alert("Mistral Large\n\n" .. r)
            print(r)
        end
    elseif c == 2 then
        local hist = read()
        if #hist == 0 then
            gg.alert("No history")
        else
            local txt = ""
            for i, v in ipairs(hist) do
                txt = txt .. v.role .. ": " .. string.sub(v.content, 1, 100) .. "...\n\n"
            end
            gg.alert(txt)
        end
    elseif c == 3 then
        save({})
        gg.toast("History cleared")
    else
        break
    end
end