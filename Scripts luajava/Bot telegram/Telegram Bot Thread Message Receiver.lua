 local ticks = 0
 
local botToken = "YOUR_TOKEN_BOT"--enter  token  bot
local chatId = "ID_USER_OR_ID_CHAT" --enter id user or id chat

local lastUpdateId = 0  
local lastMessage = ""  

local function showAlert(msg)
  gg.alert(msg)  
  
end

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
    local newestMessage = ""  
    local newestUpdateId = 0  

    for update in jsonContent:gmatch('"update_id"%s*:%s*(%d+)') do
        newestUpdateId = tonumber(update)
    end

    for textValue in jsonContent:gmatch('"text"%s*:%s*"([^"]+)"') do
        newestMessage = textValue  
    end
    
    if newestUpdateId > lastUpdateId and newestMessage ~= lastMessage and newestMessage ~= "" then
        showAlert(newestMessage)
        lastUpdateId = newestUpdateId  
        lastMessage = newestMessage  
    end
end

local function getUpdates()
    local apiUrl = "https://api.telegram.org/bot" .. botToken .. "/getUpdates"
    local request = gg.makeRequest(apiUrl, nil, nil, nil, nil, nil, 0)

    if not request or not request.content then
        print("Error: Request failed or no content.")
        return
    end

    getTextFromUpdates(request.content)
end

local function threadBody()
  while true do  
    getUpdates() 
  end
end

local runnable = luajava.createProxy("java.lang.Runnable", {run = threadBody})
local Thread = luajava.newInstance("java.lang.Thread", runnable)
Thread:start()

function init_script()
  module_manager.set_state("Telegram Listener", true)  -- Ativa o estado do módulo
end

function on_tick()
end

function on_disable()
end

function getName()
  return "Telegram Listener"
end

threadBody()