gg.setVisible(true)

local apiConfig = {
    {
        name = "OpenRouter",
        model = "meta-llama/llama-3.3-70b-instruct:free",
        apiKey = "you_is_gay",  
        endpoint = "https://openrouter.ai/api/v1/chat/completions"
    }
}
local json = nil
if not pcall(function()
    json = load(gg.makeRequest("https://raw.githubusercontent.com/rxi/json.lua/master/json.lua").content)()
end) then
    json = require("json") or gg.alert("❌  JSON no avaliable")
    if not json then return end
end
local modelNames = {}
for i, config in ipairs(apiConfig) do
    table.insert(modelNames, config.name .. " (" .. config.model .. ")")
end

local selection = gg.choice(modelNames, nil, "Select o model AI:")

if not selection then
    
    return
end

local selectedConfig = apiConfig[selection]

local chat = gg.prompt({
    'enter your question:',
    'Temperature (0.1-1.0):',
    ' max Tokens (1-2000):'
}, {'', '0.7', '500'}, {'text', 'number', 'number'})

if chat == nil then
    gg.alert("Cancelled!")
    return
end

local userMessage = chat[1]
local temperature = tonumber(chat[2]) or 0.7
local maxTokens = tonumber(chat[3]) or 500

if temperature < 0.1 or temperature > 1.0 then
    temperature = 0.7
end

if maxTokens < 1 or maxTokens > 2000 then
    maxTokens = 500
end

local payload = {
    model = selectedConfig.model,
    messages = {
        {
            role = "system",
            content = "your is assistent. reply in idiom user."
        },
        {
            role = "user",
            content = userMessage
        }
    },
    max_tokens = maxTokens,
    temperature = temperature
}

if selectedConfig.name == "OpenRouter" then
    payload.max_tokens = math.min(maxTokens, 1000)  
end

local jsonPayload = json.encode(payload)

local headers = {
    ["Content-Type"] = "application/json",
    ["Authorization"] = "Bearer " .. selectedConfig.apiKey,
    ["Accept"] = "application/json"
}

if selectedConfig.name == "OpenRouter" then
    headers["HTTP-Referer"] = "gameguardian.ai"
    headers["X-Title"] = "GameGuardian AI"
end

gg.toast("sending... " .. selectedConfig.name .. "...")
local response = gg.makeRequest(
    selectedConfig.endpoint,
    headers,
    jsonPayload
)

if type(response) == "table" and response.code == 200 then
    local data = json.decode(response.content)
    
    if data and data.choices and #data.choices > 0 then
        local botResponse = data.choices[1].message.content
        
        local copyOption = gg.choice(
            {"✅ OK", "📋 Copy"}, 
            nil, 
            selectedConfig.name .. " respondeu:\n\n" .. botResponse
        )
        
        if copyOption == 2 then
            if gg.copyText then
                gg.copyText(botResponse)
                gg.toast("copied!")
            else
                
            end
        end
    else
        gg.alert("Erro in reply API:\n" .. (response.content or "empty"))
    end
else
    local errorMsg = "Erro in request:\n"
    if type(response) == "table" then
        errorMsg = errorMsg .. "code: " .. (response.code or "N/A") .. "\n"
        errorMsg = errorMsg .. "reply: " .. (response.content or "null")
    else
        errorMsg = errorMsg .. tostring(response)
    end
    
    gg.alert(errorMsg)
end