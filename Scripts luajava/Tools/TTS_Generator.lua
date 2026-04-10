gg.setVisible(true)

local json = load(gg.makeRequest("https://raw.githubusercontent.com/rxi/json.lua/master/json.lua").content)()

local models = {
    miku = { voice_id = "67aee909-5d4b-11ee-a861-00163e2ac61b", voice_name = "Hatsune Miku" },
    nahida = { voice_id = "67ae0979-5d4b-11ee-a861-00163e2ac61b", voice_name = "Nahida (Exclusive)" },
    nami = { voice_id = "67ad95a0-5d4b-11ee-a861-00163e2ac61b", voice_name = "Nami" },
    ana = { voice_id = "f2ec72cc-110c-11ef-811c-00163e0255ec", voice_name = "Ana(Female)" },
    optimus_prime = { voice_id = "67ae0f40-5d4b-11ee-a861-00163e2ac61b", voice_name = "Optimus Prime" },
    goku = { voice_id = "67aed50c-5d4b-11ee-a861-00163e2ac61b", voice_name = "Goku" },
  --  taylor_swift = { voice_id = "67ae4751-5d4b-11ee-a861-00163e2ac61b", voice_name = "Taylor Swift" },
    elon_musk = { voice_id = "67ada61f-5d4b-11ee-a861-00163e2ac61b", voice_name = "Elon Musk" },
    mickey_mouse = { voice_id = "67ae7d37-5d4b-11ee-a861-00163e2ac61b", voice_name = "Mickey Mouse" },
    kendrick_lamar = { voice_id = "67add638-5d4b-11ee-a861-00163e2ac61b", voice_name = "Kendrick Lamar" },
  --  angela_adkinsh = { voice_id = "d23f2adb-5d1b-11ee-a861-00163e2ac61b", voice_name = "Angela Adkinsh" },
    eminem = { voice_id = "c82964b9-d093-11ee-bfb7-e86f38d7ec1a", voice_name = "Eminem" }
}

local userAgents = {
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3",
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/602.3.12 (KHTML, like Gecko) Version/10.1.2 Safari/602.3.12",
    "Mozilla/5.0 (Linux; Android 8.0.0; Pixel 2 XL Build/OPD3.170816.012) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/67.0.3396.87 Mobile Safari/537.36"
}

function getRandomIP()
    return string.format("%d.%d.%d.%d",
        math.random(0, 255),
        math.random(0, 255),
        math.random(0, 255),
        math.random(0, 255)
    )
end

function generateTTS(text, modelKey)
    local model = models[modelKey]
    if not model then return nil, "Model not found" end
    
    local payload = {
        raw_text = text,
        url = "https://filme.imyfone.com/text-to-speech/anime-text-to-speech/",
        product_id = "200054",
        convert_data = {{
            voice_id = model.voice_id,
            speed = "1",
            volume = "50",
            text = text,
            pos = 0
        }}
    }
    
    local headers = {
        ["Content-Type"] = "application/json",
        ["Accept"] = "*/*",
        ["X-Forwarded-For"] = getRandomIP(),
        ["User-Agent"] = userAgents[math.random(#userAgents)]
    }
    
    gg.toast("🎤 Generating " .. model.voice_name .. "...")
    
    local res = gg.makeRequest(
        "https://voxbox-tts-api.imyfone.com/pc/v1/voice/tts",
        headers,
        json.encode(payload),
        "POST"
    )
    
    if not res or res.code ~= 200 then
        return nil, "Request error: " .. tostring(res and res.code)
    end
    
    local ok, data = pcall(json.decode, res.content)
    if not ok or not data or not data.data or not data.data.convert_result or #data.data.convert_result == 0 then
        return nil, "Invalid API response"
    end
    
    local result = data.data.convert_result[1]
    return {
        channel_id = result.channel_id,
        oss_url = result.oss_url,
        voice_name = model.voice_name
    }, nil
end

function downloadAudio(url, filename)
    gg.toast("📥 Downloading audio...")
    
    local res = gg.makeRequest(url, {["User-Agent"] = userAgents[math.random(#userAgents)]}, nil, "GET")
    
    if not res or res.code ~= 200 or not res.content then
        return false, "Error downloading audio"
    end
    
    local file = io.open(filename, "wb")
    if not file then
        return false, "Error creating file"
    end
    
    file:write(res.content)
    file:close()
    
    return true, nil
end

local modelNames = {}
for _, model in pairs(models) do
    table.insert(modelNames, model.voice_name)
end

while true do
    local menu = gg.choice({
        "🎤 Text to Speech",
        "📋 List Voices",
        "📖 About",
        "❌ Exit"
    }, nil, "🔊 TTS Generator")
    
    if menu == 1 then
        local modelChoice = gg.choice(modelNames, nil, "Choose voice:")
        if not modelChoice then break end
        
        local modelKey = nil
        local count = 0
        for key, _ in pairs(models) do
            count = count + 1
            if count == modelChoice then
                modelKey = key
                break
            end
        end
        
        local input = gg.prompt({"📝 Text to convert:"}, {""}, {"text"})
        if not input or not input[1] or input[1] == "" then
            gg.alert("❌ Empty text!")
            break
        end
        
        local text = input[1]:trim()
        
        local result, err = generateTTS(text, modelKey)
        
        if err then
            gg.alert("❌ " .. err)
            break
        end
        
        local msg = string.format([[
✅ Audio generated successfully!

🎤 Voice: %s
📝 Text: %s
━━━━━━━━━━━━━━━━━━
🔗 URL: %s
]], result.voice_name, text:sub(1,50)..(#text>50 and "..." or ""), result.oss_url)
        
        gg.alert(msg)
        
        local download = gg.alert("📥 Download audio?", "Yes", "No")
        
        if download == 1 then
            local filename = os.date("tts_%Y%m%d_%H%M%S") .. "_" .. modelKey .. ".mp3"
            local success, downloadErr = downloadAudio(result.oss_url, filename)
            
            if success then
                gg.alert(string.format([[
✅ Audio saved!

💾 File: %s
]], filename))
                
                if gg.copyText and gg.alert("📋 Copy filename?", "Yes", "No") == 1 then
                    gg.copyText(filename)
                end
            else
                gg.alert("❌ " .. (downloadErr or "Error saving"))
            end
        end
        
        if gg.copyText then
            local copy = gg.alert("📋 Copy URL?", "Yes", "No")
            if copy == 1 then
                gg.copyText(result.oss_url)
                gg.toast("✅ URL copied!")
            end
        end
        
    elseif menu == 2 then
        local list = "📋 Available voices:\n━━━━━━━━━━━━━━━━━━\n"
        local i = 1
        for _, model in pairs(models) do
            list = list .. string.format("%d. %s\n", i, model.voice_name)
            i = i + 1
        end
        gg.alert(list)
        
    elseif menu == 3 then
        gg.alert([[
🔊 TTS Generator v1.0

🎤 Convert text to speech
with character voices:

• Hatsune Miku
• Nahida
• Goku
• Taylor Swift
• Eminem
• And many more!

📥 Audio saved as MP3
📍 in current folder this script 

        ]])
        
    elseif menu == 4 or not menu then
        gg.alert("👋 Goodbye!")
        break
    end
end