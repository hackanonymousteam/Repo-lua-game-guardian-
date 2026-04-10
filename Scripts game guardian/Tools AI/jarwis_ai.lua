gg.setVisible(true)

local apiKey = "YOUR_API_KEY_OPENROUTER"
local model = "arcee-ai/trinity-large-preview:free"
local json = nil

if not pcall(function()
    json = load(gg.makeRequest("https://raw.githubusercontent.com/rxi/json.lua/master/json.lua").content)()
end) then
    json = require("json")
    if not json then
        gg.alert("JSON library not available")
        return
    end
end

function urlEncode(str)
    if not str then return "" end
    local result = ""
    for i = 1, #str do
        local char = str:sub(i, i)
        if char:match("[a-zA-Z0-9_.~-]") then
            result = result .. char
        elseif char == " " then
            result = result .. "+"
        else
            result = result .. string.format("%%%02X", string.byte(char))
        end
    end
    return result
end

function chat(prompt)
    if not apiKey or apiKey == "sk-or-v1-" then
        return "Please set your API key first"
    end
    
    gg.toast("Thinking...")
    
    local messages = {
        {role = "system", content = "You are a helpful AI assistant."},
        {role = "user", content = prompt}
    }
    
    local payload = {
        model = model,
        messages = messages
    }
    
    local headers = {
        ["Authorization"] = "Bearer " .. apiKey,
        ["Content-Type"] = "application/json"
    }
    
    local response = gg.makeRequest(
        "https://openrouter.ai/api/v1/chat/completions",
        headers,
        json.encode(payload),
        "POST"
    )
    
    if type(response) ~= "table" then
        return "Request error"
    end
    
    if response.code ~= 200 then
        return "Error " .. response.code
    end
    
    local success, data = pcall(json.decode, response.content)
    if success and data and data.choices and data.choices[1] then
        return data.choices[1].message.content
    end
    
    return "Error processing response"
end

function setKey()
    local input = gg.prompt({"Enter OpenRouter API Key"}, {apiKey}, {"text"})
    if input then
        apiKey = input[1]
        gg.alert("API Key updated")
    end
end

function main()
    local menu = {
        "Chat",
        "Set API Key",
        "Exit"
    }
    
    local choice = gg.multiChoice(menu, nil, "JARVIS AI")
    if not choice then return end
    
    for selected, _ in pairs(choice) do
        if selected == 1 then
            while true do
                local input = gg.prompt({"Ask something"}, {""}, {"text"})
                if not input then break end
                
                local msg = input[1]
                if msg == "" then break end
                
                local response = chat(msg)
                
                if #response > 500 then
                    for i = 1, #response, 500 do
                        gg.alert(response:sub(i, math.min(i + 499, #response)))
                    end
                else
                    gg.alert(response)
                end
            end
        elseif selected == 2 then
            setKey()
        elseif selected == 3 then
            os.exit()
        end
        break
    end
end

while true do
    if gg.isVisible() then
        gg.setVisible(false)
        main()
    end
    gg.sleep(100)
end