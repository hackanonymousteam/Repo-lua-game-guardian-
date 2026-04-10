gg.setVisible(true)

local mistralApiKey = "your-api-key-here" 
local mistralModel = "mistral-small-latest"

local json = nil
if not pcall(function()
    json = load(gg.makeRequest("https://raw.githubusercontent.com/rxi/json.lua/master/json.lua").content)()
end) then
    json = require("json") or gg.alert("❌ JSON library not available")
    if not json then return end
end

local chat = gg.prompt({
    'ask your question:',
    'Temperature (0.1-1.0):',
    'Tokens max (1-800):'
}, {'', '0.7', '200'}, {'text', 'number', 'number'})

if chat == nil then
    gg.alert("cancel!")
    return
end

local userMessage = chat[1]
local temperature = tonumber(chat[2]) or 0.7
local maxTokens = tonumber(chat[3]) or 200

if temperature < 0.1 or temperature > 1.0 then
    temperature = 0.7
end

if maxTokens < 1 or maxTokens > 800 then
    maxTokens = 200
end

local payload = {
    model = mistralModel,
    messages = {
        {
            role = "system",
            content = "speak in idiom the user"
        },
        {
            role = "user",
            content = userMessage
        }
    },
    max_tokens = maxTokens,
    temperature = temperature
}

local jsonPayload = json.encode(payload)

local headers = {
    ["Content-Type"] = "application/json",
    ["Authorization"] = "Bearer " .. mistralApiKey,
    ["Accept"] = "application/json"
}

gg.toast("sending for Mistral...")
local response = gg.makeRequest(
    "https://api.mistral.ai/v1/chat/completions",
    headers,
    jsonPayload
)

if type(response) == "table" and response.code == 200 then
    local data = json.decode(response.content)
    
    if data and data.choices and #data.choices > 0 then
        local botResponse = data.choices[1].message.content
        gg.alert("reply  Mistral:\n\n" .. botResponse)
        
        if gg.copyText then
            if gg.alert(botResponse .. "\n\n copy?", "yes", "no") == 1 then
                gg.copyText(botResponse)
                gg.toast("copied!")
            end
        end
    else
        gg.alert("Erro: in API\n" .. response.content)
    end
else
    local errorMsg = "Erro in request:\n"
    
    if type(response) == "table" then
        errorMsg = errorMsg .. "code: " .. (response.code or "N/A") .. "\n"
        errorMsg = errorMsg .. "reply: " .. (response.content or "nothing")
    else
        errorMsg = errorMsg .. tostring(response)
    end
    
    gg.alert(errorMsg)
end