gg.setVisible(true)

local API_URL = "https://www.openai.fm/api/generate"
local GENERATION_ID = "261e0a0d-697f-4d8f-b73f-bbb2d4d64546"

local available_voices = {"coral", "shimmer", "echo", "onyx", "nova", "alloy"}
local available_styles = {"default", "excited", "calm", "happy", "sad", "angry"}

local function urlencode(str)
    if str then
        str = string.gsub(str, "\n", "\r\n")
        str = string.gsub(str, "([^%w %-%_%.%~])",
            function(c) return string.format("%%%02X", string.byte(c)) end)
        str = string.gsub(str, " ", "+")
    end
    return str
end

local function textToSpeech(text, voice, style)
    gg.toast("Converting text to speech...")
    
    local params = "?input=" .. urlencode(text) ..
                   "&prompt=" .. urlencode(text) ..
                   "&voice=" .. voice ..
                   "&style=" .. style ..
                   "&generation=" .. GENERATION_ID
    
    local fullUrl = API_URL .. params
    
    local headers = {
        ["Referer"] = "https://www.openai.fm/",
        ["User-Agent"] = "Mozilla/5.0 (Linux; Android 13; Mobile) AppleWebKit/537.36 Safari/537.36",
        ["Range"] = "bytes=0-"
    }
    
    local response = gg.makeRequest(fullUrl, headers)
    
    if type(response) == "table" and response.code == 200 and response.content then
        return response.content, true
    else
        return "Error: " .. (response.code or "unknown"), false
    end
end

local function saveAudioToFile(audioData, fileName)
    os.execute("mkdir -p /sdcard/Download/AI_Audio")
    local path = "/sdcard/Download/AI_Audio/" .. fileName
    local file = io.open(path, "wb")
    if file then
        file:write(audioData)
        file:close()
        return path, true
    end
    return "Failed to save file", false
end

-- Selecionar voz
local voiceChoice = gg.choice(available_voices, nil, "Select voice:")
if not voiceChoice then return end
local selectedVoice = available_voices[voiceChoice]

-- Selecionar estilo
local styleChoice = gg.choice(available_styles, nil, "Select style:")
if not styleChoice then return end
local selectedStyle = available_styles[styleChoice]

-- Inserir texto
local textInput = gg.prompt({
    'Enter text to convert to speech:'
}, {
    'Hello, this is a test of text to speech conversion'
}, {
    'text'
})

if textInput and textInput[1] then
    local text = textInput[1]
    
    local audioData, success = textToSpeech(text, selectedVoice, selectedStyle)
    
    if success then
        local fileName = "speech_" .. selectedVoice .. "_" .. os.time() .. ".mp3"
        local filePath, saveSuccess = saveAudioToFile(audioData, fileName)
        
        if saveSuccess then
            gg.alert("✅ Audio saved!\n\n📁 File: " .. fileName .. "\n📍 Path: " .. filePath .. "\n\n🗣️ Voice: " .. selectedVoice .. "\n🎭 Style: " .. selectedStyle .. "\n📝 Text: " .. text)
        else
            gg.alert("❌ Save failed: " .. filePath)
        end
    else
        gg.alert("❌ Conversion failed: " .. audioData)
    end
end