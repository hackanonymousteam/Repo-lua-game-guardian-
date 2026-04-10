gg.setVisible(true)

local deeplApiKey = "09d61d9d-9a9f-44d0-bb44-b97c2486034a:fx"
local deeplApiUrl = "https://api-free.deepl.com/v2/translate"

local json = nil

if not pcall(function()
    json = load(gg.makeRequest("https://raw.githubusercontent.com/rxi/json.lua/master/json.lua").content)()
end) then
    json = require("json") or gg.alert("JSON library not available")
    if not json then return end
end

local HISTORY_FILE = "translation_history.json"

function fileExists(filename)
    local file = io.open(filename, "r")
    if file then
        file:close()
        return true
    end
    return false
end

function loadHistory()
    local history = {}
    
    if fileExists(HISTORY_FILE) then
        local file = io.open(HISTORY_FILE, "r")
        if file then
            local content = file:read("*a")
            file:close()
            
            if content and content:trim() ~= "" then
                local success, result = pcall(json.decode, content)
                if success then
                    history = result
                end
            end
        end
    end
    
    return history
end

function saveToHistory(originalText, translatedText, sourceLang, targetLang)
    local history = loadHistory()
    
    table.insert(history, {
        timestamp = os.time(),
        original = originalText,
        translated = translatedText,
        from = sourceLang,
        to = targetLang
    })
    
    if #history > 50 then
        table.remove(history, 1)
    end
    
    local file = io.open(HISTORY_FILE, "w")
    if file then
        file:write(json.encode(history))
        file:close()
        return true
    end
    return false
end

function clearHistory()
    local file = io.open(HISTORY_FILE, "w")
    if file then
        file:write("[]")
        file:close()
        return true
    end
    return false
end

function showLanguageMenu(title, includeAuto)
    local languages = {
     --   {"auto", "Auto detect"},
        {"BG", "Bulgarian"},
        {"CS", "Czech"},
        {"DA", "Danish"},
        {"DE", "German"},
        {"EL", "Greek"},
        {"EN", "English"},
        {"EN-GB", "English (British)"},
        {"EN-US", "English (American)"},
        {"ES", "Spanish"},
        {"ET", "Estonian"},
        {"FI", "Finnish"},
        {"FR", "French"},
        {"HU", "Hungarian"},
        {"ID", "Indonesian"},
        {"IT", "Italian"},
        {"JA", "Japanese"},
        {"KO", "Korean"},
        {"LT", "Lithuanian"},
        {"LV", "Latvian"},
        {"NB", "Norwegian"},
        {"NL", "Dutch"},
        {"PL", "Polish"},
        {"PT", "Portuguese"},
        {"PT-BR", "Portuguese (Brazilian)"},
        {"PT-PT", "Portuguese (European)"},
        {"RO", "Romanian"},
        {"RU", "Russian"},
        {"SK", "Slovak"},
        {"SL", "Slovenian"},
        {"SV", "Swedish"},
        {"TR", "Turkish"},
        {"UK", "Ukrainian"},
        {"ZH", "Chinese"}
    }
    
    local options = {"Back"}
    local langCodes = {}
    local startIndex = 1
    
    if includeAuto then
        table.insert(options, languages[1][2] .. " (" .. languages[1][1] .. ")")
        table.insert(langCodes, languages[1][1])
        startIndex = 2
    end
    
    for i = startIndex, #languages do
        table.insert(options, languages[i][2] .. " (" .. languages[i][1] .. ")")
        table.insert(langCodes, languages[i][1])
    end
    
    local choice = gg.choice(options, nil, title)
    
    if choice and choice > 1 then
        return langCodes[choice - 1]
    end    
    return nil
end

function translateText(text, sourceLang, targetLang)
    if not text or text:trim() == "" then
        return nil, "Empty text"
    end
    
    if not targetLang then
        return nil, "No target language selected"
    end
    
    local payload = {
        text = {text},
        target_lang = targetLang
    }
    
    if sourceLang and sourceLang ~= "auto" then
        payload.source_lang = sourceLang
    end
    
    local headers = {
        ["Authorization"] = "DeepL-Auth-Key " .. deeplApiKey,
        ["Content-Type"] = "application/json",
        ["User-Agent"] = "GG-Lua-Translator/1.0"
    }
    
    gg.toast("Translating...")
    
    local response = gg.makeRequest(
        deeplApiUrl,
        headers,
        json.encode(payload),
        "POST"
    )
    
    if type(response) ~= "table" then
        return nil, "Connection error"
    end
    
    if response.code ~= 200 then
        local errorMsg = "Error " .. tostring(response.code)
        if response.content then
            local success, errorData = pcall(json.decode, response.content)
            if success and type(errorData) == "table" and errorData.message then
                errorMsg = errorMsg .. ": " .. tostring(errorData.message)
            else
                errorMsg = errorMsg .. ": " .. tostring(response.content)
            end
        end
        return nil, errorMsg
    end
    
    local success, result = pcall(json.decode, response.content)
    if not success or not result then
        return nil, "Error processing response"
    end
    
    if not result.translations or not result.translations[1] or not result.translations[1].text then
        return nil, "Invalid response format"
    end
    
    local translatedText = result.translations[1].text
    local detectedSourceLang = result.translations[1].detected_source_language or sourceLang or "auto"
    
    saveToHistory(text, translatedText, detectedSourceLang, targetLang)
    
    return translatedText, nil, detectedSourceLang
end

function showTranslationResult(originalText, translatedText, sourceLang, targetLang)
    local message = string.format(
        "Translation completed\n\n" ..
        "From: %s\nTo: %s\n\n" ..
        "Original text:\n%s\n\n" ..
        "Translated text:\n%s",
        sourceLang,
        targetLang,
        originalText,
        translatedText
    )
    
    local action = gg.alert(message, "Copy translation", "New translation", "Back to menu")
    
    if action == 1 and gg.copyText then
        gg.copyText(translatedText)
        gg.toast("Text copied!")
    end
    
    return action
end

function showHistory()
    local history = loadHistory()
    
    if #history == 0 then
        gg.alert("History is empty")
        return
    end
    
    local options = {"Back", "Clear History"}
    local items = {}
    
    for i = math.max(1, #history - 9), #history do
        local item = history[i]
        local date = os.date("%H:%M %d/%m", item.timestamp)
        local preview = item.original:sub(1, 20)
        if #item.original > 20 then preview = preview .. "..." end
        
        table.insert(options, date .. ": " .. preview)
        table.insert(items, item)
    end
    
    local choice = gg.choice(options, nil, "Translation History")
    
    if choice == nil then return
    elseif choice == 1 then return
    elseif choice == 2 then
        if gg.alert("Clear all history?", "Yes", "No") == 1 then
            if clearHistory() then
                gg.toast("History cleared")
            else
                gg.toast("Error clearing history")
            end
        end
    else
        local idx = choice - 2
        local item = items[idx]
        local message = string.format(
            "Date: %s\n\n" ..
            "Original (%s):\n%s\n\n" ..
            "Translated (%s):\n%s",
            os.date("%d/%m/%Y %H:%M:%S", item.timestamp),
            item.from,
            item.original,
            item.to,
            item.translated
        )
        
        local action = gg.alert(message, "Copy translation", "Back", "Delete")
        
        if action == 1 then
            if gg.copyText then
                gg.copyText(item.translated)
                gg.toast("Copied!")
            end
        elseif action == 3 then
            local newHistory = {}
            for i, h in ipairs(history) do
                if h.timestamp ~= item.timestamp then
                    table.insert(newHistory, h)
                end
            end
            
            local file = io.open(HISTORY_FILE, "w")
            if file then
                file:write(json.encode(newHistory))
                file:close()
                gg.toast("Item deleted")
                showHistory()
            end
        end
    end
end

function singleTranslation()
    local sourceLang = showLanguageMenu("Select source language", true)
    if not sourceLang then return end
    
    local textInput = gg.prompt({
        "Enter text to translate:"
    }, {""}, {"text"})
    
    if not textInput or not textInput[1] or textInput[1]:trim() == "" then
        return
    end
    
    local text = textInput[1]:trim()
    
    local targetLang = showLanguageMenu("Select target language", false)
    if not targetLang then return end
    
    gg.toast("Processing...")
    local translated, error, detectedLang = translateText(text, sourceLang, targetLang)
    
    if translated then
        local actualSourceLang = detectedLang or sourceLang
        local action = showTranslationResult(text, translated, actualSourceLang, targetLang)
        
        if action == 2 then
            singleTranslation()
        end
    else
        gg.alert("Translation error:\n" .. (error or "Unknown"))
    end
end

function multipleTranslation()
    local sourceLang = showLanguageMenu("Select source language", true)
    if not sourceLang then return end
    
    local textInput = gg.prompt({
        "Enter texts (one per line):"
    }, {""}, {"text"})
    
    if not textInput or not textInput[1] or textInput[1]:trim() == "" then
        return
    end
    
    local lines = {}
    for line in textInput[1]:gmatch("[^\r\n]+") do
        if line:trim() ~= "" then
            table.insert(lines, line:trim())
        end
    end
    
    if #lines == 0 then return end
    
    local targetLang = showLanguageMenu("Select target language", false)
    if not targetLang then return end
    
    gg.toast("Translating " .. #lines .. " texts...")
    
    local allTranslated = true
    local results = {}
    
    for i, text in ipairs(lines) do
        local translated, error = translateText(text, sourceLang, targetLang)
        if translated then
            results[i] = translated
        else
            results[i] = "ERROR: " .. (error or "Translation failed")
            allTranslated = false
        end
    end
    
    local resultText = ""
    for i, text in ipairs(lines) do
        resultText = resultText .. "Original " .. i .. ":\n" .. text .. "\n\n"
        resultText = resultText .. "Translated " .. i .. ":\n" .. results[i] .. "\n\n"
        resultText = resultText .. "--------------------------------\n\n"
    end
    
    local title = allTranslated and "Translation Results" or "Translation Results (with errors)"
    local action = gg.alert(resultText, "Copy all", "Back to menu")
    
    if action == 1 and gg.copyText then
        gg.copyText(resultText)
        gg.toast("All results copied!")
    end
end

function main()
    while true do
        local menu = gg.choice({
            "Single translation",
         --   "Multiple translations",
            "View history",
            "Settings",
            "Exit"
        }, nil, "DeepL Translator")
        
        if menu == nil or menu == 4 then
            break
            
        elseif menu == 1 then
            singleTranslation()
            
      --  elseif menu == 2 then
          --  multipleTranslation()
            
        elseif menu == 2 then
            showHistory()
            
        elseif menu == 3 then
            local settings = gg.choice({
                "Change API key",
                "Statistics",
                "Back"
            }, nil, "Settings")
            
            if settings == 1 then
                local newKey = gg.prompt({"New DeepL API key:"}, {deeplApiKey}, {"text"})
                if newKey and newKey[1] and newKey[1]:trim() ~= "" then
                    deeplApiKey = newKey[1]:trim()
                    gg.toast("API key updated!")
                end
                
            elseif settings == 2 then
                local history = loadHistory()
                gg.alert(string.format(
                    "Statistics:\n\n" ..
                    "Total translations: %d\n" ..
                    "First translation: %s\n" ..
                    "Last translation: %s",
                    #history,
                    #history > 0 and os.date("%d/%m/%Y", history[1].timestamp) or "N/A",
                    #history > 0 and os.date("%d/%m/%Y %H:%M", history[#history].timestamp) or "N/A"
                ))
            end
        end
    end
    gg.toast("DeepL Translator closed")
end

if gg.alert("DeepL Translator\n\nDirect connection to DeepL API", "Start", "Exit") == 1 then
    main()
end