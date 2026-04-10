local json = nil
if not pcall(function()
    json = load(gg.makeRequest("https://raw.githubusercontent.com/rxi/json.lua/master/json.lua").content)()
end) then
    json = require("json") or gg.alert("❌ JSON library not available")
    if not json then return end
end

local ai_list = {
    "cici",
    "felo",
    "chatJeeves",
    "chatgptMorphic",
    "perplexity",
    "seaartChat",
    "geminiVoice",
    "sora",
    "consensus"
}
local ai_parameters = {
    cici = {param = "prompt", category = "chat"},
    felo = {param = "prompt", category = "chat"},
    chatJeeves = {param = "prompt", category = "chat"},
    chatgptMorphic = {param = "prompt", category = "chat", extra = "&system=You+are+a+helpful+AI+assistant"},
    perplexity = {param = "prompt", category = "chat"},
    seaartChat = {param = "prompt", category = "chat"},
    geminiVoice = {param = "text", category = "voice"},
    sora = {param = "prompt", category = "video"},
    consensus = {param = "query", category = "search", base_path = "search/"}
}

local function urlencode(str)
    if str then
        str = string.gsub(str, "\n", "\r\n")
        str = string.gsub(str, "([^%w %-%_%.%~])", function(c)
            return string.format("%%%02X", string.byte(c))
        end)
        str = string.gsub(str, " ", "+")
    end
    return str
end

local function parseResponse(jsonData)
    if not jsonData or type(jsonData) ~= "table" then
        return nil
    end
    local result = jsonData.data and jsonData.data.result or nil
    if not result then
        return nil
    end
    if type(result) == "string" then
        return result
    end
    if type(result) == "table" then
        local keys = { "chatgpt", "gpt", "combinedContent", "url" }
        for _, key in ipairs(keys) do
            if result[key] then
                return result[key]
            end
        end
    end
    if type(result) == "table" and #result > 0 then
        local first = result[1]
        if type(first) == "table" then
            if first.display_text then
                return first.display_text
            elseif first.url then
                return first.url
            elseif first.title then
                return first.title
            end
        end
    end
    return nil
end

local function make_api_request(url, ai_name)
    local request = gg.makeRequest(url)
    if request == nil then
        return nil, "Error: no internet"
    end
    if request.code ~= 200 then
        return nil, "HTTP Error: " .. (request.code or "unknown") .. " - " .. (request.message or "no message")
    end
    if request.content == nil then
        return nil, "Empty API reply"
    end
    return request.content, nil
end

while true do
    local main_choice = gg.choice({
        "🧠 Chat with AI [9 options]", 
        "🔊 Text to Voice [1 option]", 
        "🎨 search Video (Sora) [1 option]",
        "🔍 Search with Consensus [1 option]",
        "❌ Exit"
    }, nil, "AnaBot AI - Main Menu\nAvailable AIs: " .. #ai_list .. " options")
    
    if main_choice == nil or main_choice == 5 then
        break
    end
    
    local filtered_ais = {}
    local category_name = ""
    local category_key = ""
    
    if main_choice == 1 then
        category_name = "Chat"
        category_key = "chat"
    elseif main_choice == 2 then
        category_name = "Text to Voice"
        category_key = "voice"
    elseif main_choice == 3 then
        category_name = "Video"
        category_key = "video"
    elseif main_choice == 4 then
        category_name = "Search"
        category_key = "search"
    end
    
    for _, ai_name in ipairs(ai_list) do
        if ai_parameters[ai_name] and ai_parameters[ai_name].category == category_key then
            table.insert(filtered_ais, ai_name)
        end
    end
    
    local ai_choice = gg.choice(filtered_ais, nil, "Choose an AI (" .. category_name .. "):")
    if ai_choice == nil then
        gg.alert("No AI selected!")
    end
    
    local selected_ai = filtered_ais[ai_choice]
    local ai_config = ai_parameters[selected_ai]
    
    local prompt_texts = {
        chat = "Ask your question:",
        voice = "Enter text for voice:",
        video = "Search video:",
        search = "Enter your search query:"
    }
    
    local chat = gg.prompt({prompt_texts[category_key]}, {}, {'text'})
    if chat == nil or chat[1] == "" then
        gg.alert("Empty text!")
    end
    
    local base_url = "https://anabot.my.id/api/"
    local base_path = ai_config.base_path or "ai/"
    local param_name = ai_config.param
    local encoded_text = urlencode(chat[1])
    local api_key = "freeApikey"
    
    local url = base_url .. base_path .. selected_ai .. "?" .. param_name .. "=" .. encoded_text .. "&apikey=" .. api_key
    if ai_config.extra then
        url = url .. ai_config.extra
    end
   
    local response_content, error_msg = make_api_request(url, selected_ai)
    if error_msg then
        gg.alert("❌ Error:\n" .. error_msg)
    end

    local success, decoded = pcall(json.decode, response_content)
    if not success then
        gg.alert("Invalid JSON: " .. tostring(response_content))
        return
    end

    local reply = parseResponse(decoded)
    if reply then
        gg.alert(reply)
        gg.copyText(reply)
    else
        gg.alert("No valid reply found")
    end
end