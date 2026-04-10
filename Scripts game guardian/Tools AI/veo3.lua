-- Veo3 Lua (GameGuardian by @batmangamesS )

gg.setVisible(true)

local BYPASS_API_KEY = "freeApikey"
local SITE_ORIGIN = "https://veo3api.ai/"
local SITEKEY = "0x4AAAAAAA6UyTUbN2VIQ0np"
local BYPASS_URL = "https://anabot.my.id/api/tools/bypass"
local CREATE_URL = "https://aiarticle.erweima.ai/api/v1/secondary-page/api/create"
local STATUS_URL = "https://aiarticle.erweima.ai/api/v1/secondary-page/api/"

local function base64_encode(data)
    local b64chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    local bytes = {}
    
    for i = 1, #data do
        bytes[i] = data:byte(i)
    end
    
    local result = ''
    local temp = 0
    local bits = 0
    
    for i = 1, #bytes do
        temp = (temp * 256) + bytes[i]
        bits = bits + 8
        while bits >= 6 do
            bits = bits - 6
            result = result .. b64chars:sub(math.floor(temp / (2^bits)) % 64 + 1)
            temp = temp % (2^bits)
        end
    end
    
    if bits > 0 then
        result = result .. b64chars:sub(math.floor(temp * (2^(6-bits))) % 64 + 1)
    end
    
    while #result % 4 ~= 0 do
        result = result .. '='
    end
    
    return result
end

local json = nil
if pcall(function()
    json = load(gg.makeRequest("https://raw.githubusercontent.com/rxi/json.lua/master/json.lua").content)()
end) then
  
else
  
    json = require("json")
    if not json then
        gg.alert("❌ JSON library not available")
        return
    end
end

local function urlencode(str)
    if str then
        str = string.gsub(str, "\n", "\r\n")
        str = string.gsub(str, "([^%w %-%_%.%~])",
            function(c) return string.format("%%%02X", string.byte(c)) end)
        str = string.gsub(str, " ", "+")
    end
    return str
end

local chat = gg.prompt({
    'Prompt vídeo:',
    'Quality (ex: 720p):',
    'Duration (seconds, ex: 8):'
}, {'one dog driver in space','720p','8'}, {'text','text','number'})

if not chat or not chat[1] or chat[1] == '' then
    gg.alert("Cancelled!")
    return
end

local userPrompt = chat[1]
local quality = chat[2] ~= "" and chat[2] or "720p"
local duration = tonumber(chat[3]) or 8

local function sleep(sec)
    local start = os.time()
    while os.time() - start < sec do
        -- Busy wait
    end
end

local function getBypassToken(origin, apikey)
    local api = BYPASS_URL .. "?url=" .. urlencode(origin) ..
                "&siteKey=" .. urlencode(SITEKEY) ..
                "&type=" .. urlencode("turnstile-min") ..  
                "&proxy=&apikey=" .. urlencode(apikey)

   -- gg.toast(" token  bypass...")
    local res = gg.makeRequest(api, {["Accept"] = "application/json"})

    if res and res.code == 200 then
        local ok, data = pcall(json.decode, res.content)
        if ok and data then
            
            if data.data and data.data.result and data.data.result.token then
                return data.data.result.token
            elseif data.token then
                return data.token
            elseif data.data and data.data.token then
                return data.data.token
            elseif data.result and data.result.token then
                return data.result.token
            end
        end
        return nil, "Token no found in reply : " .. (res.content or "vazio")
    else
        local err = "failed  bypass - code: " .. (res and tostring(res.code) or "unknown")
        if res and res.content then
            local ok, errorData = pcall(json.decode, res.content)
            if ok and errorData and errorData.error then
                err = err .. "\nErro: " .. tostring(errorData.error.message or errorData.error)
            else
                err = err .. "\nReply: " .. tostring(res.content)
            end
        end
        return nil, err
    end
end

local function createVideo(token, prompt, imgUrls)
    imgUrls = imgUrls or {}
    
    local payload = {
        prompt = prompt,
        imgUrls = imgUrls,
        quality = quality,
        duration = duration,
        autoSoundFlag = true,
        soundPrompt = "",
        autoSpeechFlag = true,
        speechPrompt = "",
        speakerId = "Auto",
        aspectRatio = "16:9",
        secondaryPageId = 2019,
        channel = "VEO3",
        source = "veo3api.ai",
        type = "features",
        watermarkFlag = true,
        privateFlag = true,
        isTemp = true,
        vipFlag = true,
        model = "veo-3-fast"
    }

    local headers = {
        ["Content-Type"] = "application/json",
        ["authority"] = "aiarticle.erweima.ai",
        ["accept-language"] = "ms-MY,ms;q=0.9,en-US;q=0.8,en;q=0.7",
        ["origin"] = "https://veo3api.ai",
        ["referer"] = "https://veo3api.ai/",
        ["sec-ch-ua"] = '"Not A(Brand";v="8", "Chromium";v="132"',
        ["sec-ch-ua-mobile"] = "?1",
        ["sec-ch-ua-platform"] = '"Android"',
        ["sec-fetch-dest"] = "empty",
        ["sec-fetch-mode"] = "cors",
        ["sec-fetch-site"] = "cross-site",
        ["user-agent"] = "Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Mobile Safari/537.36",
        ["verify"] = token,
        ["uniqueid"] = base64_encode(tostring(os.time() * 1000))
    }

    gg.toast("creating vídeo...")
    local res = gg.makeRequest(CREATE_URL, headers, json.encode(payload))

    if res and (res.code == 200 or res.code == 201) then
        local ok, data = pcall(json.decode, res.content)
        if ok and data then
            if data.data and data.data.recordId then
                return data.data.recordId
            elseif data.recordId then
                return data.recordId
            else
                return nil, "RecordId no  found: " .. json.encode(data)
            end
        else
            return nil, "reply invalid: " .. (res.content or "vazio")
        end
    end
    
    return nil, "Falha HTTP: " .. (res and tostring(res.code) or "unknown") .. " - " .. (res and res.content or "no response")
end

local function checkStatus(recordId)
    local url = STATUS_URL .. recordId
    local headers = {
        ["accept"] = "application/json, text/plain, */*",
        ["accept-language"] = "ms-MY,ms;q=0.9,en-US;q=0.8,en;q=0.7",
        ["origin"] = "https://veo3api.ai",
        ["referer"] = "https://veo3api.ai/",
        ["sec-ch-ua"] = '"Not A(Brand";v="8", "Chromium";v="132"',
        ["sec-ch-ua-mobile"] = "?1",
        ["sec-ch-ua-platform"] = '"Android"',
        ["sec-fetch-dest"] = "empty",
        ["sec-fetch-mode"] = "cors",
        ["sec-fetch-site"] = "cross-site",
        ["user-agent"] = "Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Mobile Safari/537.36"
    }

    local res = gg.makeRequest(url, headers)
    
    if res and res.code == 200 then
        local ok, data = pcall(json.decode, res.content)
        if ok and data then
            return data.data or data
        end
    end
    
    return nil
end

local function pollStatus(recordId, timeout)
    timeout = timeout or 600  -- 10 minutes default
    local startTime = os.time()
    
    gg.toast("waiting vídeo... (ID: " .. recordId .. ")")
    
    while os.time() - startTime < timeout do
        local status = checkStatus(recordId)
        
        if status then
            if status.state == "success" and status.completeData then
                local ok, result = pcall(json.decode, status.completeData)
                if ok and result then
                    return result
                elseif type(status.completeData) == "table" then
                    return status.completeData
                end
            elseif status.state == "fail" or status.failMsg then
                return nil, status.failMsg or "Falha na geração"
            elseif status.status == "completed" then
                return status
            end
        end
        
        sleep(5)
        local elapsed = os.time() - startTime
        gg.toast("waiting... " .. elapsed .. "s/" .. timeout .. "s")
        

        if elapsed % 30 == 0 then
            gg.toast("Still processing... " .. elapsed .. "s")
        end
    end
    
    return nil, "Timeout após " .. timeout .. " seconds"
end

local function downloadAndSave(videoUrl)
    if not videoUrl or videoUrl == "" then
        return nil, "URL empty"
    end
    
    gg.toast("downloading vídeo...")
    local res = gg.makeRequest(videoUrl)
    
    if res and res.code == 200 and res.content and #res.content > 100 then  
        local filename = "veo3_video_" .. os.time() .. ".mp4"
        local path = "/sdcard/Download/" .. filename
        
        local file = io.open(path, "wb")
        if file then
            file:write(res.content)
            file:close()
            gg.toast("Vídeo save: " .. filename)
            return path
        else
            return nil, "failed create file  " .. path
        end
    else
        return nil, "Falha no download - Código: " .. (res and tostring(res.code) or "unknown") .. 
               ", Tamanho: " .. (res and res.content and #res.content or "0") .. " bytes"
    end
end


gg.toast("starting Veo3 API...")

gg.toast("step 1/4: getting token bypass...")
local token, err = getBypassToken(SITE_ORIGIN, BYPASS_API_KEY)
if not token then
    gg.alert("❌ Error in bypass:\n" .. tostring(err))
    return
end

--gg.toast("✅ Token ok!")

gg.toast("step 2/4: creating vídeo...")
local recordId, err = createVideo(token, userPrompt, {})
if not recordId then
    gg.alert("❌ Error:\n" .. tostring(err))
    return
end

gg.toast("✅ Vídeo criado! ID: " .. recordId)

gg.toast("step 3/4: Processing vídeo...")
local result, err = pollStatus(recordId, 600)
if not result then
    gg.alert("❌ Erro in generation:\n" .. tostring(err))
    return
end

gg.toast("✅ Vídeo ok!")

local videoUrl = nil
if result.data then
    videoUrl = result.data.video_nowm_url or 
               result.data.video_url or
               (result.data.image_url and result.data.image_url:gsub("%.(jpg|jpeg|png|webp|gif)$", ".mp4"))
elseif result.video_nowm_url then
    videoUrl = result.video_nowm_url
elseif result.video_url then
    videoUrl = result.video_url
end

if not videoUrl then
    gg.alert("❌ URL  vídeo no found\nResult: " .. json.encode(result))
    return
end

--gg.toast("📹 URL encontrada: " .. string.sub(videoUrl, 1, 50) .. "...")

gg.toast("step 4/4: downloading vídeo...")
local savedPath, err = downloadAndSave(videoUrl)
if savedPath then
    gg.alert("✅ Vídeo save in !\n\n📁 Local: " .. savedPath ..
             "\n🎬 Prompt: " .. userPrompt ..
             "\n⏱️ Duration: " .. duration .. "s" ..
             "\n📺 Quality: " .. quality)
else
    gg.alert("❌ Error:\n" .. tostring(err))
end