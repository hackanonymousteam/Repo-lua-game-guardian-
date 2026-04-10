gg.setVisible(true)

local deepseekApiKey = "sk-your_api_key"
local deepseekModel = "deepseek-chat"

local json = nil
if not pcall(function()
    json = load(gg.makeRequest("https://raw.githubusercontent.com/rxi/json.lua/master/json.lua").content)()
end) then
    json = require("json") or gg.alert("JSON library not available")
    if not json then return end
end

local HISTORY_FILE = "deepseek_history.json"
local CACHE_FILE = "translation_cache.json"

local LANG_ZH = 0
local LANG_EN = 1

local translationCache = {}
local conversationHistory = {}

function fileExists(filename)
    local file = io.open(filename, "r")
    if file then
        file:close()
        return true
    end
    return false
end

function safeReadJSON(filename, defaultValue)
    if not fileExists(filename) then
        return defaultValue or {}
    end
    
    local file = io.open(filename, "r")
    if not file then
        return defaultValue or {}
    end
    
    local content = file:read("*a")
    file:close()
    
    if content and content:trim() ~= "" then
        local success, result = pcall(json.decode, content)
        if success then
            return result
        end
    end
    
    return defaultValue or {}
end

function safeWriteJSON(filename, data)
    local file = io.open(filename, "w")
    if not file then
        return false
    end
    
    local success, encoded = pcall(json.encode, data)
    if not success then
        file:close()
        return false
    end
    
    file:write(encoded)
    file:close()
    return true
end

function detectLanguage(text)
    for i = 1, #text do
        local byte = string.byte(text, i)
        if byte and byte > 0x7F then
            return LANG_ZH
        end
    end
    return LANG_EN
end

function getLanguageName(lang)
    if lang == LANG_ZH then
        return "Chinese"
    else
        return "English"
    end
end

function trim(str)
    if not str then return "" end
    return str:match("^%s*(.-)%s*$")
end

function loadCache()
    translationCache = safeReadJSON(CACHE_FILE, {})
    if not translationCache.entries then
        translationCache.entries = {}
    end
    if not translationCache.nextIdx then
        translationCache.nextIdx = 1
    end
end

function saveCache()
    safeWriteJSON(CACHE_FILE, translationCache)
end

function cacheFind(text, lang)
    if not translationCache.entries then
        return nil
    end
    
    for key, entry in pairs(translationCache.entries) do
        if entry.text == text and entry.lang == lang then
            return entry.result
        end
    end
    return nil
end

function cacheStore(text, lang, result)
    if not translationCache.entries then
        translationCache.entries = {}
    end
    
    local count = 0
    for _ in pairs(translationCache.entries) do
        count = count + 1
    end
    
    if count >= 200 then
        local oldestKey = nil
        local oldestIdx = math.huge
        for key, entry in pairs(translationCache.entries) do
            if entry.idx and entry.idx < oldestIdx then
                oldestIdx = entry.idx
                oldestKey = key
            end
        end
        if oldestKey then
            translationCache.entries[oldestKey] = nil
        end
    end
    
    local key = text .. "_" .. lang
    translationCache.entries[key] = {
        text = text,
        lang = lang,
        result = result,
        idx = translationCache.nextIdx or 1
    }
    translationCache.nextIdx = (translationCache.nextIdx or 1) + 1
    
    saveCache()
end

function loadHistory()
    conversationHistory = safeReadJSON(HISTORY_FILE, {})
end

function saveHistory()
    safeWriteJSON(HISTORY_FILE, conversationHistory)
end

function getConversationId(uid)
    return conversationHistory[tostring(uid)]
end

function saveConversationId(uid, conversationId)
    conversationHistory[tostring(uid)] = conversationId
    saveHistory()
end

function clearConversation(uid)
    conversationHistory[tostring(uid)] = nil
    saveHistory()
end

function buildTranslationPrompt(text, targetLang)
    if targetLang == LANG_ZH then
        return "Detect the language automatically and translate the following text to Simplified Chinese. Output only the translation, no explanations:\n\n" .. text
    else
        return "Detect the language automatically and translate the following text to English. Output only the translation, no explanations:\n\n" .. text
    end
end

function extractTextFromResponse(content)
    if not content or type(content) ~= "string" then
        return "Invalid response"
    end
    
    local pattern = '"content"%s*:%s*"([^"]+)"'
    local text = content:match(pattern)
    if text then
        return text
    end
    
    pattern = '"content"%s*:%s*"(([^"\\]|\\.)*)"'
    text = content:match(pattern)
    if text then
        text = text:gsub("\\\"", "\"")
        text = text:gsub("\\\\", "\\")
        text = text:gsub("\\n", "\n")
        return text
    end
    
    return content
end

function translateWithDeepSeek(text, targetLang, uid, isConversation)
    local cached = cacheFind(text, targetLang)
    if cached then
        return cached
    end
    
    local payload = {
        model = deepseekModel,
        messages = {},
        temperature = 0.3,
       -- max_tokens = 500,
        stream = false
    }
    
    if isConversation then
        local convId = getConversationId(uid)
        payload.messages = {
            {
                role = "system",
                content = "You are a helpful assistant. Keep responses concise and accurate."
            }
        }
        table.insert(payload.messages, {
            role = "user",
            content = text
        })
    else
        payload.messages = {
            {
                role = "user",
                content = buildTranslationPrompt(text, targetLang)
            }
        }
    end
    
    local headers = {
        ["Authorization"] = "Bearer " .. deepseekApiKey,
        ["Content-Type"] = "application/json"
    }
    
    gg.toast("Sending to DeepSeek...")
    
    local response = gg.makeRequest(
        "https://api.deepseek.com/chat/completions",
        headers,
        json.encode(payload),
        "POST"
    )
    
    if type(response) ~= "table" or response.code ~= 200 then
        local errorMsg = "Request error: "
        if type(response) == "table" then
            errorMsg = errorMsg .. "code: " .. tostring(response.code) .. "\n"
            if response.content then
                errorMsg = errorMsg .. "response: " .. response.content
            end
        else
            errorMsg = errorMsg .. tostring(response)
        end
        return errorMsg
    end
    
    local translatedText = extractTextFromResponse(response.content)
    translatedText = trim(translatedText)
    if translatedText:sub(1, 1) == '"' and translatedText:sub(-1) == '"' then
        translatedText = translatedText:sub(2, -2)
    end
    
    if translatedText and translatedText ~= "" then
        cacheStore(text, targetLang, translatedText)
    end
    
    return translatedText
end

function showMainMenu()
    local options = {
        "Translate Message",
        "Chat with AI",
        "Settings",
        "About"
    }
    
    local choice = gg.choice(options, nil, "DeepSeek AI Assistant")
    
    if choice == 1 then
        showTranslationMenu()
    elseif choice == 2 then
        showChatMenu()
    elseif choice == 3 then
        showSettingsMenu()
    elseif choice == 4 then
        showAboutMenu()
    end
end

function showTranslationMenu()
    local menu = {
        "Translate to Chinese",
        "Translate to English",
        "Back"
    }
    
    local choice = gg.choice(menu, nil, "Translation")
    
    if choice == 1 then
        showTranslationInput(LANG_ZH)
    elseif choice == 2 then
        showTranslationInput(LANG_EN)
    elseif choice == 3 then
        showMainMenu()
    end
end

function showTranslationInput(targetLang)
    local langName = getLanguageName(targetLang)
    local input = gg.prompt({
        "Text to translate:",
        "Target language: " .. langName .. " (auto-detect)"
    }, {"", ""}, {"text", "text"})
    
    if not input or not input[1] or input[1]:trim() == "" then
        gg.alert("Empty text or cancelled!")
        showTranslationMenu()
        return
    end
    
    local text = input[1]:trim()
    
    gg.toast("Translating...")
    local startTime = os.time()
    
    local result = translateWithDeepSeek(text, targetLang, nil, false)
    
    local endTime = os.time()
    local duration = endTime - startTime
    
    local message = "Original text:\n" .. text .. "\n\n" ..
                    "Translation (" .. getLanguageName(targetLang) .. "):\n" .. result .. "\n\n" ..
                    "Time: " .. duration .. "s"
    
    local copyChoice = gg.alert(message, "Copy", "Back")
    
    if copyChoice == 1 then
        if gg.copyText then
            gg.copyText(result)
            gg.toast("Copied!")
        else
            gg.alert("Copy function not available")
        end
    end
    
    showTranslationMenu()
end

function showChatMenu()
    local input = gg.prompt({
        "Enter your message:",
        "User ID (optional):"
    }, {"", "user123"}, {"text", "text"})
    
    if not input or not input[1] or input[1]:trim() == "" then
        gg.alert("Empty message or cancelled!")
        showMainMenu()
        return
    end
    
    local message = input[1]:trim()
    local uid = input[2]:trim() ~= "" and input[2] or "user123"
    
    if message:lower() == "clear" then
        clearConversation(uid)
        gg.alert("Conversation cleared!")
        showChatMenu()
        return
    end
    
    gg.toast("Processing...")
    local startTime = os.time()
    
    local response = translateWithDeepSeek(message, LANG_ZH, uid, true)
    
    local endTime = os.time()
    local duration = endTime - startTime
    
    if not getConversationId(uid) then
        saveConversationId(uid, "conv_" .. uid .. "_" .. os.time())
    end
    
    local finalMessage = "You: " .. message .. "\n\n" ..
                         "DeepSeek: " .. response .. "\n\n" ..
                         "Time: " .. duration .. "s"
    
    local copyChoice = gg.alert(finalMessage, "Copy response", "Back")
    
    if copyChoice == 1 then
        if gg.copyText then
            gg.copyText(response)
            gg.toast("Copied!")
        end
    end
    
    local continueChoice = gg.alert("Continue chatting?", "Yes", "No")
    if continueChoice == 1 then
        showChatMenu()
    else
        showMainMenu()
    end
end

function showSettingsMenu()
    local options = {
        "Clear translation cache",
        "Clear conversation history",
        "Back"
    }
    
    local choice = gg.choice(options, nil, "Settings")
    
    if choice == 1 then
        translationCache = {entries = {}, nextIdx = 1}
        saveCache()
        gg.alert("Translation cache cleared!")
        showSettingsMenu()
    elseif choice == 2 then
        conversationHistory = {}
        saveHistory()
        gg.alert("Conversation history cleared!")
        showSettingsMenu()
    elseif choice == 3 then
        showMainMenu()
    end
end

function showAboutMenu()
    local aboutText = "DeepSeek AI Assistant\n\n" ..
                      "This script uses DeepSeek API for:\n" ..
                      "• Automatic text translation\n" ..
                      "• AI conversations\n\n" ..
                      "Model: deepseek-chat\n" ..
                      "Developed for GG Script\n\n" ..
                      "Configure your API key at the beginning of the script."
    
    gg.alert(aboutText)
    showMainMenu()
end

function main()
    if deepseekApiKey == "" then
        local input = gg.prompt({
            "DeepSeek API Key:",
            "Get your key at platform.deepseek.com"
        }, {"", ""}, {"text", "text"})
        
        if input and input[1] and input[1]:trim() ~= "" then
            deepseekApiKey = input[1]:trim()
            local config = {api_key = deepseekApiKey}
            safeWriteJSON("deepseek_config.json", config)
            gg.toast("API Key saved!")
        else
            gg.alert("API Key not configured!\n\nThe script won't work without a valid key.\n\nGet your key at: platform.deepseek.com")
            return
        end
    end
    
    loadCache()
    loadHistory()
    
    showMainMenu()
end

main()