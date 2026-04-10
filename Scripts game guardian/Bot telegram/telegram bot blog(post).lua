
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

function sendTelegramMessage(token, chatId, message)
    local apiUrl = "https://api.telegram.org/bot" .. token .. "/sendMessage"
    local requestData = "chat_id=" .. urlEncode(chatId) .. "&text=" .. urlEncode(message)

    local request = gg.makeRequest(apiUrl, nil, requestData, nil, nil, nil, 0)

    if request == nil or request.content == nil then
        print('Error: Failed to send the message.')
    else
        print('Message sent successfully!')
    end
end

local input = gg.prompt(
    {'Enter post title', 'Enter post author', 'Enter post URL'}, 
    {}, 
    {'text', 'text', 'text'}
)

if input == nil then
    print('Action cancelled by the user.')
    return
end

local postTitle = input[1]
local postAuthor = input[2]
local postUrl = input[3]

if postTitle == "" or postAuthor == "" or postUrl == "" then
    print('Error: All fields must be filled.')
    return
end

local message = "📢 New Blog Post Published!\n\n"
message = message .. "📌 Title: " .. postTitle .. "\n"
message = message .. "👤 Author: " .. postAuthor .. "\n"
message = message .. "🔗 URL: " .. postUrl .. "\n\n"
message = message .. "🚀 Check it out now!"

local token = "YOUR_TOKEN_BOT"--enter  token  bot
local chatId = "ID_USER_OR_ID_CHAT" --enter id user or id chat

sendTelegramMessage(token, chatId, message)