local token = "YOUR_TOKEN_BOT"--enter  token  bot
local chatId = "ID_USER_OR_ID_CHAT" --enter id user or id chat

function urlEncode(str)
    if str == nil then
        return ""
    end
    str = str:gsub("\n", "\r\n")
    str = str:gsub("([^%w _%%%-%.~])", function(c)
        return string.format("%%%02X", string.byte(c))
    end)
    str = str:gsub(" ", "+")
    return str
end

local function getTextFromUpdates(jsonContent)
    for textValue in jsonContent:gmatch('"text"%s*:%s*"([^"]+)"') do
        print("msg: " .. textValue)
    end
end

local function getUpdates()
    local apiUrl = "https://api.telegram.org/bot" .. token .. "/getUpdates"
    local request = gg.makeRequest(apiUrl, nil, nil, nil, nil, nil, 0)

    if not request or not request.content then
        print("Error: Request failed or no content.")
        return
    end

    getTextFromUpdates(request.content)
end

function ab()
    local inicio = gg.choice({
        "🗃️ send message 🗃️",
        "❇️ view messages received for bot ❇️",
        "❌ Exit ❌"
    })

    function START1()
        local chat = gg.prompt({'Enter message'}, {}, {'text'})
        if chat == nil then
            return
        end

        local msg = chat[1]
        
        local message = msg

        local apiUrl = "https://api.telegram.org/bot" .. token .. "/sendMessage"

        local requestData = "chat_id=" .. urlEncode(chatId) .. "&text=" .. urlEncode(message)

        local request = gg.makeRequest(apiUrl, nil, requestData, nil, nil, nil, 0)

        if request == nil or request.content == nil then
            print('Error: Failed to send the message.')
        else
            print('Message sent successfully!')
        end
    end

    function START2()
        getUpdates()
    end

    if inicio == 1 then
        START1()
    elseif inicio == 2 then
        START2()
    elseif inicio == 3 then
        os.exit()
    else
        print("Invalid choice.")
    end
end

ab()