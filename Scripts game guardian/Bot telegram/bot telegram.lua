
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

local chat = gg.prompt({'Enter your message'}, {}, {'text'})
if chat == nil then
    return
end

local msg = chat[1]
local token = "YOUR_TOKEN_BOT"--enter  token  bot
local chatId = "ID_USER_OR_ID_CHAT" --enter id user or id chat
local message = msg

local apiUrl = "https://api.telegram.org/bot" .. token .. "/sendMessage"

local requestData = "chat_id=" .. urlEncode(chatId) .. "&text=" .. urlEncode(message)

local request = gg.makeRequest(apiUrl, nil, requestData, nil, nil, nil, 0)

if request == nil or request.content == nil then
    print('Error: Failed to send the message.')
else
    print('Message sent successfully!')
end