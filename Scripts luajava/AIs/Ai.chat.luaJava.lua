import "java.net.*"
import "java.io.*"
import "java.util.*"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "org.json.JSONObject"
import "org.json.JSONArray"

local Class = luajava.bindClass
local new = luajava.new
local astable = luajava.astable

local function urlencode(str)
    if str then
        str = string.gsub(str, "\n", "\r\n")
        str = string.gsub(str, "([^%w %-%_%.%~])",
            function(c) return string.format("%%%02X", string.byte(c)) end)
        str = string.gsub(str, " ", "+")
    end
    return str
end

local function askAI(question)
    local apiUrl = "https://api.alyachan.dev/api/gpt4"
    local apiKey = "syah11"
    
    local encodedQuestion = urlencode(question)
    local fullUrl = apiUrl .. "?prompt=" .. encodedQuestion .. "&apikey=" .. apiKey
    
    local success, result = pcall(function()
        local url = new(URL, fullUrl)
        local connection = url:openConnection()
        
        connection:setConnectTimeout(15000)
        connection:setReadTimeout(15000)
        connection:setRequestProperty("User-Agent", "LuaJava-AI-Assistant/1.0")
        connection:setRequestProperty("Accept", "application/json")
        
        connection:connect()
        
        local responseCode = connection:getResponseCode()
        local responseMessage = connection:getResponseMessage()
        
        if responseCode >= 200 and responseCode < 300 then
            local inputStream = connection:getInputStream()
            local reader = new(BufferedReader, new(InputStreamReader, inputStream))
            
            local response = {}
            local line = reader:readLine()
            while line do
                table.insert(response, line)
                line = reader:readLine()
            end
            
            reader:close()
            connection:disconnect()
            
            local responseText = table.concat(response, "\n")
            
            local jsonSuccess, jsonResult = pcall(function()
                local JSONObject = Class("org.json.JSONObject")
                local jsonResponse = new(JSONObject, responseText)
                
                if jsonResponse:has("status") and jsonResponse:getBoolean("status") then
                    if jsonResponse:has("data") then
                        local data = jsonResponse:getJSONObject("data")
                        if data:has("content") then
                            return data:getString("content")
                        end
                    end
                end
                
                if jsonResponse:has("response") then
                    return jsonResponse:getString("response")
                elseif jsonResponse:has("answer") then
                    return jsonResponse:getString("answer")
                elseif jsonResponse:has("text") then
                    return jsonResponse:getString("text")
                else
                    return responseText
                end
            end)
            
            if jsonSuccess then
                return jsonResult
            else
                return responseText
            end
            
        else
            connection:disconnect()
            return "API Error: " .. responseCode .. " - " .. responseMessage
        end
    end)
    
    if success then
        return result
    else
        return "Connection error: " .. tostring(result)
    end
end

local function main()
    local chat = gg.prompt({
        'Ask your question:'
    }, {}, {'text'})
    
    if chat == nil then
        return
    end
    
    local question = chat[1]
    
    if question == nil or question == "" then
        gg.alert("Please enter a question")
        return
    end
    
    gg.toast("Processing...")
    
    local answer = askAI(question)
    
    gg.alert("Question: " .. question .. "\n\nAnswer: " .. answer)
    
    local continuee = gg.alert("Ask another question?", "Yes", "No")
    
    if continuee == 1 then
        main()
    end
end

local function advancedMode()
    local history = {}
    
    while true do
        local chat = gg.prompt({
            'Ask your question:',
            'History (' .. #history .. ' questions)'
        }, {'', table.concat(history, '\n')}, {'text', 'text'})
        
        if chat == nil then
            break
        end
        
        local question = chat[1]
        
        if question == nil or question == "" then
            gg.alert("Please enter a question")
        else
            table.insert(history, "Q: " .. question)
            
            gg.toast("Processing...")
            local answer = askAI(question)
            
            table.insert(history, "A: " .. answer)
            table.insert(history, "---")
            
            gg.alert("Question: " .. question .. "\n\nAnswer: " .. answer)
        end
        
        local choice = gg.alert("AI Assistant", "Ask another", "View history", "Exit")
        
        if choice == 2 then
            gg.alert("History:\n\n" .. table.concat(history, '\n'))
        elseif choice == 3 then
            break
        end
    end
end

local function showMenu()
    local choice = gg.choice({
        "Single question",
        "Advanced mode with history", 
        "Exit"
    }, nil, "AI Assistant")
    
    if choice == 1 then
        main()
    elseif choice == 2 then
        advancedMode()
        showMenu()
    elseif choice == 3 then
        return
    else
        showMenu()
    end
end

gg.alert("AI Assistant - Ask questions and get intelligent answers")

showMenu()