gg.setVisible(true)

local cohereApiKey = "your_key"
local cohereModel = "command-a-03-2025"  

local json = nil
if not pcall(function()
    json = load(gg.makeRequest("https://raw.githubusercontent.com/rxi/json.lua/master/json.lua").content)()
end) then
    json = require("json") or gg.alert("❌ Biblioteca JSON não disponível")
    if not json then return end
end

local USERS_FILE = "cohere.json"

function fileExists(filename)
    local file = io.open(filename, "r")
    if file then
        file:close()
        return true
    end
    return false
end

function safeReadUsers()
    local usersData = {}
    
    if fileExists(USERS_FILE) then
        local file = io.open(USERS_FILE, "r")
        if file then
            local content = file:read("*a")
            file:close()
            
            if content and content:trim() ~= "" then
                local success, result = pcall(json.decode, content)
                if success then
                    usersData = result
                else
                    gg.toast("error reading file conversation ")
                end
            end
        end
    end
    
    return usersData
end


function saveUsers(usersData)
    local file = io.open(USERS_FILE, "w")
    if file then
        file:write(json.encode(usersData))
        file:close()
        return true
    end
    return false
end


function getConversationId(uid)
    local users = safeReadUsers()
    return users[tostring(uid)] or nil
end


function saveConversationId(uid, conversationId)
    local users = safeReadUsers()
    users[tostring(uid)] = conversationId
    return saveUsers(users)
end

function deleteConversationId(uid)
    local users = safeReadUsers()
    users[tostring(uid)] = nil
    return saveUsers(users)
end

function clearConversationOnServer(conversationId)
    if not conversationId then return true end
    
    local payload = {
        conversation_ids = {conversationId}
    }
    
    local headers = {
        ["Authorization"] = "Bearer " .. cohereApiKey,
        ["Content-Type"] = "application/json",
        ["Accept"] = "application/json"
    }
    
    gg.toast("Limpando conversa no servidor...")
    local response = gg.makeRequest(
        "https://api.cohere.com/v2/conversations:batch_delete",
        headers,
        json.encode(payload),
        "POST"
    )
    
    return type(response) == "table" and response.code >= 200 and response.code < 300
end

function buildConversationHistory(conversationId, prompt)
    local history = {}
    
  
    if not conversationId then
        table.insert(history, {
            role = "system",
            content = "You are a helpful assistant that provides accurate and concise information."
        })
    end
    
    table.insert(history, {
        role = "user",
        content = prompt
    })
    
    return history
end

function cleanResponseText(text)
    if not text or type(text) ~= "string" then
        return "Resposta inválida"
    end
    
 
    local cleanText = ""
    for part in text:gmatch("(.-)%s*}]}") do
        cleanText = cleanText .. part
    end
    
 
    if cleanText == "" then
        for part in text:gmatch("(.-)}]}[%a_]*:") do
            cleanText = cleanText .. part
        end
    end
    
    
    if cleanText == "" then
        local endPos = text:find("%s*}]}")
        if endPos then
            cleanText = text:sub(1, endPos - 1)
        else
            endPos = text:find("}]}[%a_]*:")
            if endPos then
                cleanText = text:sub(1, endPos - 1)
            else
                
                local lastComma = text:reverse():find("}%]},")
                if lastComma then
                    cleanText = text:sub(1, #text - lastComma)
                else
                    cleanText = text
                end
            end
        end
    end
    
   
    cleanText = cleanText:gsub("%s+$", "")
    
    return cleanText
end


function extractTextFromResponse(responseContent)
    if not responseContent or type(responseContent) ~= "string" then
        return "reply empy or invalid"
    end
    
    -- Tentar extrair usando padrões de string
    local textStart, textEnd = responseContent:find('"text"%s*:%s*"')
    if textStart then
       
        local quoteCount = 0
        local textContent = ""
        
        for i = textEnd + 1, #responseContent do
            local char = responseContent:sub(i, i)
            if char == '"' then
                quoteCount = quoteCount + 1
                if quoteCount == 2 then 
                    break
                end
            elseif char == '\\' then
                
                i = i + 1
                textContent = textContent .. responseContent:sub(i, i)
            else
                textContent = textContent .. char
                quoteCount = 0
            end
        end
        
        if textContent ~= "" then
            return cleanResponseText(textContent)
        end
    end
    
  
    local pattern = '"text"%s*:%s*"([^"]+)"'
    local text = responseContent:match(pattern)
    if text then
        return cleanResponseText(text)
    end
    
    local simplePattern = '"text":%s*"([^"]+)"'
    text = responseContent:match(simplePattern)
    if text then
        return cleanResponseText(text)
    end
    
    return cleanResponseText(responseContent)
end

function chatCohere(prompt, uid, isOnStart)
    local conversationId = isOnStart and nil or getConversationId(uid)
    
    if prompt:trim():lower() == "clear" then
        local ok = clearConversationOnServer(conversationId)
        deleteConversationId(uid)
        return ok and "chat cleared" or ""
    end
    
   
    local payload = {
        model = cohereModel,
        messages = buildConversationHistory(conversationId, prompt:trim())
    }
    
    local headers = {
        ["Authorization"] = "Bearer " .. cohereApiKey,
        ["Content-Type"] = "application/json",
        ["Accept"] = "application/json"
    }
    
    gg.toast("Enviando para Cohere...")
    local response = gg.makeRequest(
        "https://api.cohere.com/v2/chat",
        headers,
        json.encode(payload),
        "POST"
    )
    
    if type(response) ~= "table" or response.code ~= 200 then
        local errorMsg = "Erro in request: "
        if type(response) == "table" then
            errorMsg = errorMsg .. "code: " .. tostring(response.code) .. "\n"
            if response.content then
                errorMsg = errorMsg .. "reply: " .. response.content
            end
        else
            errorMsg = errorMsg .. tostring(response)
        end
        return errorMsg
    end
    

    local responseText = extractTextFromResponse(response.content)
    
    return responseText
end

local function main()
    local chat = gg.prompt({
        'enter ask:',
        'ID user (optional):'
    }, {'', 'user123'}, {'text', 'text'})
    
    if not chat or not chat[1] or chat[1]:trim() == "" then
        gg.alert("cancelled or question empty!")
        return
    end
    
    local userMessage = chat[1]
    local uid = chat[2]:trim() ~= "" and chat[2] or "user123"
    
    if userMessage:lower() == "clear" then
        local conversationId = getConversationId(uid)
        local ok = clearConversationOnServer(conversationId)
        deleteConversationId(uid)
        gg.alert(ok and "chat cleared" or "")
        return
    end
    
    gg.toast("processing...")
    local startTime = os.time()
    
    local responseText = chatCohere(userMessage, uid, true)
    
    local endTime = os.time()
    local completionTime = string.format("%.2f", endTime - startTime)
    
    local finalMessage = responseText
    gg.alert("\n\n" .. finalMessage)
    
   
    if gg.copyText then
        if gg.alert(finalMessage .. "\n\ncopy?", "yes", "no") == 1 then
            gg.copyText(responseText)
            gg.toast("copied!")
        end
    end
end

main()