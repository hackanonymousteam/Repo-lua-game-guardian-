gg.setVisible(true)

local function randomHex(length)
    local chars = "abcdef0123456789"
    local result = ""
    for i = 1, length do
        result = result .. chars:sub(math.random(1, #chars), math.random(1, #chars))
    end
    return result
end

local function gieneticTrace()
    return randomHex(32) .. "-" .. randomHex(16)
end

local function uuidv4()
    return randomHex(8) .. "-" .. randomHex(4) .. "-" .. randomHex(4) .. "-" .. randomHex(4) .. "-" .. randomHex(12)
end

local json = nil
if not pcall(function()
    json = load(gg.makeRequest("https://raw.githubusercontent.com/rxi/json.lua/master/json.lua").content)()
end) then
    json = require("json")
    if not json then 
        gg.alert("JSON library not available")
        return 
    end
end

local function showDebug(title, response)
    local debugText = "🔍 " .. title .. "\n\n"
    debugText = debugText .. "Code: " .. (response.code or "N/A") .. "\n\n"
    
    if response.content then
        if #response.content > 1000 then
            debugText = debugText .. "Content (first 1000 chars):\n" .. response.content:sub(1, 1000) .. "..."
        else
            debugText = debugText .. "Content:\n" .. response.content
        end
    else
        debugText = debugText .. "No content"
    end
    
    print(debugText)
end

local function login(deviceId)
    local payload = {
        device_id = deviceId
    }
    
    local headers = {
        ["user-agent"] = "Dart/3.4 (gienetic_build)",
        ["version"] = "2.2.2",
        ["accept-encoding"] = "gzip",
        ["content-type"] = "application/json",
        ["buildnumber"] = "105",
        ["platform"] = "android",
        ["sentry-trace"] = gieneticTrace()
    }
    
    gg.toast("Logging in...")
    local response = gg.makeRequest("https://api.sunora.mavtao.com/api/auth/login", headers, json.encode(payload))
    
    showDebug("LOGIN RESPONSE", response)
    
    if type(response) == "table" and response.code == 200 then
        local success, data = pcall(json.decode, response.content)
        if success and data and data.data then
            return data.data.token
        end
    end
    return nil
end

local function pollResults(xAuth, maxAttempts, delayMs)
    maxAttempts = maxAttempts or 5
    delayMs = delayMs or 10000
    
    for attempt = 1, maxAttempts do
        gg.toast("Checking results " .. attempt .. "/" .. maxAttempts)
        
        local headers = {
            ["user-agent"] = "Dart/3.4 (gienetic_build)",
            ["version"] = "2.2.2",
            ["accept-encoding"] = "gzip",
            ["x-auth"] = xAuth,
            ["buildnumber"] = "105",
            ["platform"] = "android",
            ["sentry-trace"] = gieneticTrace()
        }
        
        local response = gg.makeRequest("https://api.sunora.mavtao.com/api/music/music_page?page=1&pagesize=50", headers)
        
        showDebug("POLL ATTEMPT " .. attempt, response)
        
        if type(response) == "table" and response.code == 200 then
            local success, data = pcall(json.decode, response.content)
            if success and data and data.data and data.data.records then
                local doneSongs = {}
                for _, record in ipairs(data.data.records) do
                    if record.status == "complete" then
                        table.insert(doneSongs, {
                            id = record.song_id,
                            title = record.title or "Song by AI",
                            audioUrl = record.audio_url,
                            videoUrl = record.video_url,
                            imageUrl = record.image_url,
                            model = record.model_name
                        })
                    end
                end
                
                if #doneSongs > 0 then
                    return doneSongs
                end
            end
        end
        
        gg.sleep(50000)
    end
    
    return {}
end

local function generateNormal(description)
    local deviceId = uuidv4()
  --  gg.alert("Device ID: " .. deviceId)
    local token = login(deviceId)
    if not token then
        return nil, "Login failed"
    end
    
  --  gg.alert("Login successful!\nToken: " .. token:sub(1, 20) .. "...")
    
    local payload = {
        continue_at = nil,
        continue_clip_id = nil,
        mv = nil,
        description = description,
        title = "",
        mood = "",
        music_style = "",
        instrumental_only = false
    }
    
    local headers = {
        ["user-agent"] = "Dart/3.4 (gienetic_build)",
        ["version"] = "2.2.2",
        ["accept-encoding"] = "gzip",
        ["x-auth"] = token,
        ["content-type"] = "application/json",
        ["buildnumber"] = "105",
        ["platform"] = "android",
        ["sentry-trace"] = gieneticTrace()
    }
    
    gg.toast("Sending generation request...")
    local response = gg.makeRequest("https://api.sunora.mavtao.com/api/music/advanced_custom_generate", headers, json.encode(payload))
    
   -- showDebug("GENERATION REQUEST", response)
    
    if type(response) == "table" and response.code == 200 then
      --  gg.alert("✅ Generation started!\n\nNow polling for results...")
        return pollResults(token)
    else
        return nil, "Generation failed: " .. (response.code or "unknown")
    end
end

local function saveAudioFromUrl(audioUrl, fileName)
    gg.toast("Downloading audio...")
    
    local response = gg.makeRequest(audioUrl)
   -- showDebug("AUDIO DOWNLOAD", response)
     -- os.execute("mkdir -p /sdcard/Download/AI_Music")
        local path = "/sdcard/Download/" .. fileName
        local file = io.open(path, "wb")
        if file then
            file:write(response.content)
            file:close()
            return path, true
        end
    end
    
local promptInput = gg.prompt({
    'Enter music description:'
}, {
    'a happy pop song about summer'
}, {
    'text'
})

if promptInput and promptInput[1] then
 --   gg.alert("🎵 Starting music generation...\n\nDescription: " .. promptInput[1])
    
    local songs, error = generateNormal(promptInput[1])
    
    if songs and #songs > 0 then
        local song = songs[1]
        gg.alert("✅ Music generated!\n\n🎵 Title: " .. song.title .. "\n🤖 Model: " .. (song.model or "Unknown") .. "\n\nAudio URL: " .. song.audioUrl)
        
        gg.copyText("✅ Music generated!\n\n🎵 Title: " .. song.title .. "\n🤖 Model: " .. (song.model or "Unknown") .. "\n\nAudio URL: " .. song.audioUrl)
        
        local fileName = "ai_music_" .. os.time() .. ".mp3"
        local filePath, saveSuccess = saveAudioFromUrl(song.audioUrl, fileName)
        if saveSuccess then
            gg.alert("🎵 Music saved!\n\n📁 " .. filePath)
        else
            gg.alert("❌ Download failed:\n" .. filePath)
        end
    else
        gg.alert("❌ Generation failed:\n" .. (error or "No songs generated after polling"))
    end
end