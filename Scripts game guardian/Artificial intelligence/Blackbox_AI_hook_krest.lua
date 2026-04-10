local json = nil
if not pcall(function()
    json = load(gg.makeRequest("https://raw.githubusercontent.com/rxi/json.lua/master/json.lua").content)()
end) then
    json = require("json") or gg.alert("❌ JSON library not available")
    if not json then return end
end

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
        return nil, "Invalid JSON data"
    end
    
    if jsonData.reply and type(jsonData.reply) == "string" then
        return jsonData.reply
    end
    
    if jsonData.status == false then
        return nil, jsonData.message or "API error"
    end
    
    return nil, "No valid reply found in response"
end

local function make_api_request(url)
    gg.toast("Connecting to Blackbox...")
    local request = gg.makeRequest(url)
    if request == nil then
        return nil, "Error: no internet connection"
    end
    if request.code ~= 200 then
        return nil, "HTTP Error: " .. (request.code or "unknown") .. " - " .. (request.message or "no message")
    end
    if request.content == nil or request.content == "" then
        return nil, "Empty API response"
    end
    return request.content, nil
end

local function chat_with_blackbox()
    local chat = gg.prompt({"Ask your question to Blackbox AI:"}, {}, {'text'})
    if chat == nil or not chat[1] or chat[1] == "" then
        gg.alert("Empty text!")
        return
    end
    
    local encoded_text = urlencode(chat[1])
    local url = "https://hookrest.my.id/ai/blackbox?text=" .. encoded_text .. "&apikey=hookrest"
    
    gg.toast("Sending request to Blackbox...")
    local response_content, error_msg = make_api_request(url)
    if error_msg then
        gg.alert("❌ Error:\n" .. error_msg)
        return
    end

    local success, decoded = pcall(json.decode, response_content)
    if not success then
        gg.alert("❌ Invalid JSON response")
        return
    end

    local reply, parse_error = parseResponse(decoded)
    if reply then
        gg.alert("\n\n" .. reply)
        gg.copyText(reply)
        gg.toast("Response copied to clipboard!")
    else
        gg.alert("❌ " .. (parse_error or "No valid reply found"))
    end
end

while true do
    local main_choice = gg.choice({
        "🧠 Chat with Blackbox AI", 
        "❌ Exit"
    }, nil, "Blackbox AI - Main Menu")
    
    if main_choice == nil or main_choice == 2 then
        break
    end
    
    if main_choice == 1 then
        chat_with_blackbox()
    end
end

gg.toast("Script finished")