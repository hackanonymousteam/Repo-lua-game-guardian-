
local token = "YOUR_TOKEN_BOT"--enter  token  bot
local chatId = "ID_USER_OR_ID_CHAT" --enter id user or id chat

function jsonEncode(tbl)
    local function escapeStr(s)
        s = s:gsub("\\", "\\\\")
        s = s:gsub('"', '\\"')
        s = s:gsub("\n", "\\n")
        s = s:gsub("\r", "\\r")
        s = s:gsub("\t", "\\t")
        return '"' .. s .. '"'
    end

    local function tableToJson(t)
        local result = {}
        for i, v in ipairs(t) do
            if type(v) == "string" then
                table.insert(result, escapeStr(v))
            end
        end
        return "[" .. table.concat(result, ",") .. "]"
    end

    return tableToJson(tbl)
end
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

function sendFile(filePath)
    local apiUrl = "https://api.telegram.org/bot" .. token .. "/sendDocument"
    
    local file = io.open(filePath, "rb")
    if not file then
        print("Error: Unable to open the file.")
        return
    end
    
    local fileData = file:read("*all")
    file:close()

    local boundary = "----LuaBoundary"
    local body = "--" .. boundary .. "\r\n"
        .. 'Content-Disposition: form-data; name="chat_id"\r\n\r\n'
        .. chatId .. "\r\n"
        .. "--" .. boundary .. "\r\n"
        .. 'Content-Disposition: form-data; name="document"; filename="' .. filePath .. '"\r\n'
        .. "Content-Type: application/octet-stream\r\n\r\n"
        .. fileData .. "\r\n"
        .. "--" .. boundary .. "--\r\n"

    local headers = {
        ["Content-Type"] = "multipart/form-data; boundary=" .. boundary,
        ["Content-Length"] = tostring(#body)
    }

    local request = gg.makeRequest(apiUrl, headers, body, nil, nil, nil, 0)

    if not request or not request.content then
        print("Error: Failed to send the file.")
        return
    end

    print("File sent successfully!")
end

function ab()
    local inicio = gg.choice({
        "🗃️ send message 🗃️",
        "❇️ view messages received for bot ❇️",
        "❇️ send files for user using bot ❇️",
        "❇️ create poll ❇️",
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
    
    function START3()
        g = {}
g.last = "/sdcard/"
g.info = nil
g.config = gg.EXT_CACHE_DIR .. "/" .. gg.getFile():match("[^/]+$") .. "cfg"
g.data = loadfile(g.config)
if g.data ~= nil then
  g.info = g.data()
  g.data = nil
end
if g.info == nil then
  g.info = { g.last, g.last:gsub("/[^/]+$", "") }
end

while true do
  g.info = gg.prompt({
    ' Select file to upload:'
  
  }, g.info, {
    'file' -- 1
  })

  if g.info == nil then
    return
  end

  local myFile = g.info[1]

  local FileName = myFile:match("[^/]+$")

  gg.saveVariable(g.info, g.config)
  g.last = myFile

  sendFile(g.last, FileName)
  os.exit()
end
 end
  
function sendPoll()
    
    local chat = gg.prompt(
        {'Enter question', 'Option 1', 'Option 2', 'Option 3'}, 
        {}, 
        {'text', 'text', 'text', 'text'}
    )

    if chat == nil then
        print("Operation canceled.")
        return
    end

    local question = chat[1]
    local options = {chat[2], chat[3], chat[4]} 

    if question == "" or options[1] == "" or options[2] == "" then
        print("Error: Question and at least two options are required.")
        return
    end

    local apiUrl = "https://api.telegram.org/bot" .. token .. "/sendPoll"

    local requestData = "chat_id=" .. urlEncode(chatId) ..
        "&question=" .. urlEncode(question) ..
        "&options=" .. urlEncode(jsonEncode(options))

    local request = gg.makeRequest(apiUrl, nil, requestData, nil, nil, nil, 0)
    
    if not request or not request.content then
        print("Error: Failed to create poll.")
    else
        print("Poll created successfully!")
    end
end

    if inicio == 1 then
        START1()
    elseif inicio == 2 then
        START2()
        elseif inicio == 3 then
        START3()
        elseif inicio == 4 then
        sendPoll()
    elseif inicio == 5 then
        os.exit()
    else
        print("Invalid choice.")
    end
end

ab()