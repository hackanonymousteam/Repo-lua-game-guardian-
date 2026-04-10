gg.setVisible(true)

local DEEPSEEK_API_KEY = "sk-your-api-key-here"

local DEEPSEEK_API_URL = "https://api.deepseek.com/chat/completions"
local DEEPSEEK_MODEL = "deepseek-chat"

local json = nil
if not pcall(function()
    json = load(gg.makeRequest("https://raw.githubusercontent.com/rxi/json.lua/master/json.lua").content)()
end) then
    json = require("json") or gg.alert("JSON library not available")
    if not json then return end
end

function urlencode(str)
    if str then
        str = string.gsub(str, "\n", "\r\n")
        str = string.gsub(str, "([^%w %-%_%.%~])",
            function(c) return string.format("%%%02X", string.byte(c)) end)
        str = string.gsub(str, " ", "%%20")
    end
    return str
end

function saveFileToStorage(data, filename)
    local filepath = "/sdcard/"..filename
    local file = io.open(filepath, "wb")
    if file then
        file:write(data)
        file:close()
        return filepath
    end
    return nil
end

function selectAPI()
    local apis = {
        "DeepSeek Chat",
        "Cancel"
    }
    local choice = gg.choice(apis, nil, "Select AI Service")
    if not choice or choice == 2 then return nil end
    return choice
end

function processDeepSeek(query)
    gg.toast("Processing with DeepSeek...")
    
    local request_data = {
        model = DEEPSEEK_MODEL,
        messages = {
            {
                role = "system",
                content = "You are a helpful assistant. Respond in the same language as the user."
            },
            {role = "user", content = query}
        },
        stream = false
    }
    
    local headers = {
        ["Content-Type"] = "application/json",
        ["Authorization"] = "Bearer " .. DEEPSEEK_API_KEY
    }
    
    local response = gg.makeRequest(DEEPSEEK_API_URL, headers, json.encode(request_data), "POST")
    return response
end

function formatResponse(response)
    if response and response.content then
        local decoded = json.decode(response.content)
        if decoded and decoded.choices and decoded.choices[1] and decoded.choices[1].message then
            return decoded.choices[1].message.content
        end
    end
    return "No response from API"
end

function main()
    local apiChoice = selectAPI()
    if not apiChoice then
        gg.alert("Operation cancelled")
        return
    end
    
    local prompt = gg.prompt({"Enter your question:"}, {}, {"text"})
    if not prompt or not prompt[1] or prompt[1]:trim() == "" then
        gg.alert("Empty input or cancelled")
        return
    end
    local query = prompt[1]
    
    local response
    if apiChoice == 1 then
        response = processDeepSeek(query)
    end
    
    if not response or not response.content then
        gg.alert("Error connecting to API")
        return
    end
    
    local result = formatResponse(response)
    
    if string.len(result) > 3000 then
        if gg.alert("Result too long. Save to file?", "Yes", "No") == 1 then
            local filename = "ai_response_" .. os.time() .. ".txt"
            local filepath = saveFileToStorage(result, filename)
            if filepath then
                gg.alert("Saved to:\n" .. filepath)
            end
        else
            gg.alert(string.sub(result, 1, 3000) .. "...")
        end
    else
        gg.alert(result)
    end
    
    if gg.copyText then
        if gg.alert("Copy response?", "Yes", "No") == 1 then
            gg.copyText(result)
            gg.toast("Copied!")
        end
    end
end

while true do
    main()
    if gg.alert("Ask another question?", "Yes", "No") == 2 then
        break
    end
end

gg.setVisible(false)