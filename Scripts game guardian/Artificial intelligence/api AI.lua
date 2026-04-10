local apiKey = "" --get your key in https://kaiz-apis.gleeze.com

local uid = ""

local function urlEncode(str)
    if str == nil then return "" end
    return (str:gsub("([^%w])", function(c)
        return string.format("%%%02X", string.byte(c))
    end):gsub(" ", "+"))
end

local function translate(text, target_lang)
  if type(text) ~= 'string' or #text < 1 then return text end
  local function url_encode(str)
    return str:gsub("([^%w])", function(c)
      return string.format("%%%02X", string.byte(c))
    end)
  end
  local headers = {['User-Agent'] = 'GoogleTranslate/6.3.0.RC06.277163268 Linux; U; Android 14; A201SO Build/64.2.E.2.140'}
  local req = gg.makeRequest(
    'https://translate.googleapis.com/translate_a/single?client=gtx&sl=auto&tl=' ..
    target_lang .. '&dt=t&q=' .. url_encode(text),
    headers
  )
  if type(req) ~= 'table' or not req.content then return text end
  local result = req.content:match('"%s*(.-)%s*"')
  return result or text
end

local categories = {
    "AI Chat APIs",
    "Utilities APIs",
    "Image Generation APIs",
    "Entertainment APIs"
}

local availableModels = {
    puter = {
        "grok-beta",
        "gemini-2,0-flash",
        "gemini-1,5-flash",
        "deepseek-chat",
        "deepseek-reasoner",
        "gpt4o-mini",
        "o3-mini",
        "claude-3-5-sonnet-latest",
        "claude-3-7-sonnet-latest"
    },
    freepass = {
        "gpt-4o",
        "claude-3-5-sonnet",
        "gemini-1.5-pro",
        "llama-3-70b",
        "mixtral-8x7b"
    }
}

local aiChatApis = {
    {name = "Aria AI", endpoint = "https://kaiz-apis.gleeze.com/api/aria", params = {"ask"}},
    {name = "Brave AI", endpoint = "https://kaiz-apis.gleeze.com/api/brave-ai", params = {"ask"}},
    {name = "Claude 3 Haiku", endpoint = "https://kaiz-apis.gleeze.com/api/claude3-haiku", params = {"ask"}},
    {name = "Deepseek v3", endpoint = "https://kaiz-apis.gleeze.com/api/deepseek-v3", params = {"ask"}},
    {name = "Deepseek R1", endpoint = "https://kaiz-apis.gleeze.com/api/deepseek-r1", params = {"ask"}},
    {name = "GPT 3.5", endpoint = "https://kaiz-apis.gleeze.com/api/gpt-3.5", params = {"q"}},
    {name = "GPT 3", endpoint = "https://kaiz-apis.gleeze.com/api/gpt3", params = {"ask"}},
    {name = "Liner AI", endpoint = "https://kaiz-apis.gleeze.com/api/liner-ai", params = {"ask"}},
    {name = "Livechat AI", endpoint = "https://kaiz-apis.gleeze.com/api/livechat-ai", params = {"ask"}},
    {name = "Panda AI", endpoint = "https://kaiz-apis.gleeze.com/api/panda-ai", params = {"ask"}},
    {name = "Qudata", endpoint = "https://kaiz-apis.gleeze.com/api/qudata", params = {"ask"}},
    {name = "Venice AI", endpoint = "https://kaiz-apis.gleeze.com/api/venice-ai", params = {"ask"}},
    {name = "You AI", endpoint = "https://kaiz-apis.gleeze.com/api/you-ai", params = {"ask"}},
    {name = "Puter AI", endpoint = "https://kaiz-apis.gleeze.com/api/puter-ai", params = {"ask", "model"}, hasModels = true, modelType = "puter"},
    {name = "Freepass AI", endpoint = "https://kaiz-apis.gleeze.com/api/freepass-ai", params = {"ask", "model", "roleplay", "web_search"}, hasModels = true, modelType = "freepass", options = {web_search = {"true", "false"}}},
    {name = "Ministral 3b", endpoint = "https://kaiz-apis.gleeze.com/api/ministral-3b", params = {"q"}},
    {name = "Ministral 8b", endpoint = "https://kaiz-apis.gleeze.com/api/ministral-8b", params = {"q"}},
    {name = "Mistral Nemo", endpoint = "https://kaiz-apis.gleeze.com/api/mistral-nemo", params = {"q"}},
    {name = "Mistral Small", endpoint = "https://kaiz-apis.gleeze.com/api/mistral-small", params = {"q"}},
    {name = "Mixtral 8x22b", endpoint = "https://kaiz-apis.gleeze.com/api/mixtral-8x22b", params = {"q"}},
    {name = "Pixtral 12b", endpoint = "https://kaiz-apis.gleeze.com/api/pixtral-12b", params = {"q"}},
    {name = "Humanizer", endpoint = "https://kaiz-apis.gleeze.com/api/humanizer", params = {"q"}}
}

local utilitiesApis = {
    {name = "Paste Cnet", endpoint = "https://kaiz-apis.gleeze.com/api/paste-cnet", params = {"text"}},
    {name = "Html Obfuscator", endpoint = "https://kaiz-apis.gleeze.com/api/html-obfuscator", params = {"code"}},
    {name = "Shazam Lyrics", endpoint = "https://kaiz-apis.gleeze.com/api/shazam-lyrics", params = {"title"}}
}

local imageApis = {
    {name = "Flux Realtime", endpoint = "https://kaiz-apis.gleeze.com/api/flux-realtime", params = {"prompt"}},
    {name = "Flux", endpoint = "https://kaiz-apis.gleeze.com/api/flux", params = {"prompt"}},
    {name = "Fotor", endpoint = "https://kaiz-apis.gleeze.com/api/fotor", params = {"prompt"}},
    {name = "Text2 Image", endpoint = "https://kaiz-apis.gleeze.com/api/text2image", params = {"prompt"}}
}

local entertainmentApis = {
    {name = "Shazam Search", endpoint = "https://kaiz-apis.gleeze.com/api/shazam-search", params = {"title", "limit"}},
    {name = "Bible", endpoint = "https://kaiz-apis.gleeze.com/api/bible", params = {}}
}

function saveBinaryFile(filename, content)
    local file = io.open(filename, "wb")
    if file then
        file:write(content)
        file:close()
        return true
    end
    return false
end

function cleanApiResponse(content)
    if not content or content == "" then
        return "No content returned"
    end
    
    
    content = content:gsub('"author":"Kaizenji",?', '')
    
    -- Replace commas with dots in URLs
    content = content:gsub('https?://[^"]+,', function(url)
        return url:gsub(',', '.')
    end)
    
    -- Fix comma issues in text content
    content = content:gsub(',', ' ')
    
    return content
end

function extractJsonResponse(content, apiName)
    content = cleanApiResponse(content)
    
    if content:find("{type:final_usage") then
        content = content:gsub("{type:final_usage.*}", "")
    end
    
    if apiName == "Paste Cnet" then
        local urlMatch = content:match('"url"%s*:%s*"([^"]+)"')
        if urlMatch then
            return urlMatch
        end
    end
    
    if apiName == "Shazam Lyrics" then
        local lyricsMatch = content:match('"lyrics"%s*:%s*"([^"]+)"')
        if lyricsMatch then
            lyricsMatch = lyricsMatch:gsub("\\n", "\n")
            return lyricsMatch
        end
    end
    
    if apiName == "Shazam Search" then
        local urlMatch = content:match('"url"%s*:%s*"([^"]+)"')
        if urlMatch then
            return "Song URL: " .. urlMatch
        end
    end
    
    if apiName:find("Image") or apiName:find("Flux") or apiName:find("Text2") or apiName:find("Fotor") then
        local urlMatch = content:match('"url"%s*:%s*"([^"]+)"') or 
                         content:match('"image"%s*:%s*"([^"]+)"') or
                         content:match('"result"%s*:%s*"([^"]+)"') or
                         content:match('"imageUrls"%s*:%s*%[%s*"([^"]+)"') or
                         content:match('"image_url"%s*:%s*"([^"]+)"')
        if urlMatch then
            return urlMatch
        end
    end
    
    local patterns = {
        '"answer"%s*:%s*"([^"]+)"',
        '"text"%s*:%s*"([^"]+)"',
        '"result"%s*:%s*"([^"]+)"',
        '"response"%s*:%s*"([^"]+)"',
        '"message"%s*:%s*"([^"]+)"',
        '"content"%s*:%s*"([^"]+)"',
        '"data"%s*:%s*"([^"]+)"',
        '"verse"%s*:%s*"([^"]+)"',
        '"song"%s*:%s*"([^"]+)"',
        '"title"%s*:%s*"([^"]+)"'
    }
    
    for _, pattern in ipairs(patterns) do
        local match = content:match(pattern)
        if match then
            match = match:gsub("\\n", "\n"):gsub("\\", ""):gsub('""', '"')
            return match
        end
    end
    
    return content
end

function makeApiRequest(endpoint, params, apiName)
    local url = endpoint .. "?"
    
    for key, value in pairs(params) do
        if value ~= nil and value ~= "" then
            url = url .. key .. "=" .. urlEncode(tostring(value)) .. "&"
        end
    end
    
    url = url .. "uid=" .. uid .. "&apikey=" .. apiKey
    
    local success, resp = pcall(gg.makeRequest, url)
    if not success or not resp or not resp.content then
        return "Request error: " .. (resp and resp.message or "No response")
    end
    
    if apiName == "Flux" or apiName == "Flux Realtime" then
        local filename = "/sdcard/" .. os.time() .. ".webp"
        if saveBinaryFile(filename, resp.content) then
            return "Image saved: " .. filename
        else
            return "Error saving image"
        end
    elseif apiName == "Text2 Image" then
        local filename = "/sdcard/" .. os.time() .. ".jpeg"
        if saveBinaryFile(filename, resp.content) then
            return "Image saved: " .. filename
        else
            return "Error saving image"
        end
    end
    
    local result = extractJsonResponse(resp.content, apiName)
    
    -- Translate Bible text
    if apiName == "Bible" then
        local userLang = gg.getLocale()
        result = translate(result, userLang)
    end
    
    return result
end

function selectModel(modelType)
    if not availableModels[modelType] then
        return nil
    end
    
    local modelNames = {}
    for _, model in ipairs(availableModels[modelType]) do
        table.insert(modelNames, model)
    end
    
    local choice = gg.choice(modelNames, nil, "Select model for " .. modelType .. ":")
    if choice == nil then return nil end
    
    return availableModels[modelType][choice]
end

function selectApi(apiList, categoryName)
    local apiNames = {}
    for i, api in ipairs(apiList) do
        table.insert(apiNames, api.name)
    end
    
    local choice = gg.choice(apiNames, nil, "Select API from " .. categoryName)
    if choice == nil then return nil end
    
    return apiList[choice]
end

function getApiParams(api)
    local params = {}
    
    for i, param in ipairs(api.params) do
        local value = ""
        
        if param == "model" and api.hasModels then
            value = selectModel(api.modelType)
            if not value then
                return nil
            end
        elseif api.options and api.options[param] then
            local optionChoice = gg.choice(api.options[param], nil, "Select " .. param .. ":")
            if optionChoice then
                value = api.options[param][optionChoice]
            end
        else
            if param == "ask" or param == "q" or param == "prompt" or param == "roleplay" or 
               param == "text" or param == "code" or param == "url" or param == "title" or
               param == "lyrics" or param == "tags" or param == "search" then
                local input = gg.prompt({param .. ":"}, {""}, {"text"})
                if input then
                    value = input[1]
                else
                    return nil
                end
            elseif param == "limit" or param == "page" then
                local input = gg.prompt({param .. ":"}, {"1"}, {"number"})
                if input then
                    value = input[1]
                else
                    return nil
                end
            end
        end
        
        params[param] = value
    end
    
    return params
end

function copyToClipboard(text)
    if gg.copyText then
        gg.copyText(text)
        return true
    end
    return false
end

function main()
    while true do
        local choice = gg.choice(categories, nil, "🌐 Kaizenji AI APIs - Select category")
        
        if choice == nil then
            break
        elseif choice == 1 then
            local api = selectApi(aiChatApis, "AI Chat")
            if api then
                local params = getApiParams(api)
                if params then
                    gg.toast("Processing...")
                    local result = makeApiRequest(api.endpoint, params, api.name)
                    
                    local copyBtn = "Copy"
                    local alertResult = gg.alert(api.name .. " response:\n\n" .. result, copyBtn, "OK")
                    
                    if alertResult == 1 then
                        copyToClipboard(result)
                        gg.toast("Text copied!")
                    end
                end
            end
        elseif choice == 2 then
            local api = selectApi(utilitiesApis, "Utilities")
            if api then
                local params = getApiParams(api)
                if params then
                    gg.toast("Processing...")
                    local result = makeApiRequest(api.endpoint, params, api.name)
                    
                    local copyBtn = "Copy"
                    local alertResult = gg.alert(api.name .. " response:\n\n" .. result, copyBtn, "OK")
                    
                    if alertResult == 1 then
                        copyToClipboard(result)
                        gg.toast("Text copied!")
                    end
                end
            end
        elseif choice == 3 then
            local api = selectApi(imageApis, "Image Generation")
            if api then
                local params = getApiParams(api)
                if params then
                    gg.toast("Processing...")
                    local result = makeApiRequest(api.endpoint, params, api.name)
                    
                    local copyBtn = "Copy"
                    local alertResult = gg.alert(api.name .. " response:\n\n" .. result, copyBtn, "OK")
                    
                    if alertResult == 1 then
                        copyToClipboard(result)
                        gg.toast("Text copied!")
                    end
                end
            end
        elseif choice == 4 then
            local api = selectApi(entertainmentApis, "Entertainment")
            if api then
                local params = getApiParams(api)
                if params then
                    gg.toast("Processing...")
                    local result = makeApiRequest(api.endpoint, params, api.name)
                    
                    local copyBtn = "Copy"
                    local alertResult = gg.alert(api.name .. " response:\n\n" .. result, copyBtn, "OK")
                    
                    if alertResult == 1 then
                        copyToClipboard(result)
                        gg.toast("Text copied!")
                    end
                end
            end
        end
    end
end

main()