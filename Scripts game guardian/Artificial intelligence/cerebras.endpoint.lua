
gg.setVisible(true)

local apiConfig = {
    { name = "Cerebras", model = "llama3.1-8b", apiKey = "YOUR_API_KEY", endpoint = "https://api.cerebras.ai/v1/chat/completions" },
    { name = "Cerebras", model = "llama-3.3-70b", apiKey = "YOUR_API_KEY", endpoint = "https://api.cerebras.ai/v1/chat/completions" },
    { name = "Cerebras", model = "llama-4-scout-17b-16e-instruct", apiKey = "YOUR_API_KEY", endpoint = "https://api.cerebras.ai/v1/chat/completions" }
}

local json = nil
if not pcall(function()
    json = load(gg.makeRequest("https://raw.githubusercontent.com/rxi/json.lua/master/json.lua").content)()
end) then
    json = require("json") or gg.alert("❌ JSON not available")
    if not json then return end
end

local modelNames = {}
for i, cfg in ipairs(apiConfig) do
    table.insert(modelNames, cfg.name .. " (" .. cfg.model .. ")")
end

local selection = gg.choice(modelNames, nil, "Select AI model:")
if not selection then return end

local selected = apiConfig[selection]

local chat = gg.prompt({
    "Enter your question:",
    "Temperature (0.1-1.0):",
    "Max tokens (1-2000):"
}, {"", "0.7", "500"}, {"text", "number", "number"})

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
    model = selected.model,
    messages = {
        { role = "system", content = "You are an assistant. Reply in the user's language." },
        { role = "user", content = userMessage }
    },
    max_tokens = maxTokens,
    temperature = temperature
}

local jsonPayload = json.encode(payload)
local headers = {
    ["Content-Type"] = "application/json",
    ["Authorization"] = "Bearer " .. selected.apiKey,
    ["Accept"] = "application/json"
}

gg.toast("Sending... " .. selected.model .. "...")
local response = gg.makeRequest(selected.endpoint, headers, jsonPayload)

if type(response) == "table" and response.code == 200 then
    local data = json.decode(response.content)
    if data and data.choices and #data.choices > 0 then
        local botResponse = data.choices[1].message and data.choices[1].message.content or data.choices[1].text or ""
        local opt = gg.choice({"✅ OK", "📋 Copy"}, nil, selected.model .. " replied:\n\n" .. botResponse)
        if opt == 2 and gg.copyText then
            gg.copyText(botResponse)
            gg.toast("Copied!")
        end
    else
        gg.alert("Error in reply API:\n" .. (response.content or "empty"))
    end
else
    local msg = "Request error:\n"
    if type(response) == "table" then
        msg = msg .. "code: " .. (response.code or "N/A") .. "\n" .. (response.content or "null")
    else
        msg = msg .. tostring(response)
    end
    gg.alert(msg)
end