gg.setVisible(true)

local VOICE_API_KEY = "YOUR_KEY"
local VOICE_BASE_URL = "https://api.voicerss.org/"

local function urlencode(str)
    if str then
        str = string.gsub(str, "\n", "\r\n")
        str = string.gsub(str, "([^%w %-%_%.%~])",
            function(c) return string.format("%%%02X", string.byte(c)) end)
        str = string.gsub(str, " ", "+")
    end
    return str
end
local voiceSettings = {
    {
        name = "🇧🇷 Portuguese Brazil (Female)",
        code = "pt-br",
        voice = "Alice"
    },
    {
        name = "🇧🇷 Portuguese Brazil (Male)", 
        code = "pt-br",
        voice = "Joana"
    },
    {
        name = "🇺🇸 English US (Female)",
        code = "en-us",
        voice = "Linda"
    },
    {
        name = "🇺🇸 English US (Male)",
        code = "en-us", 
        voice = "Mike"
    },
    {
        name = "🇪🇸 Spanish (Female)",
        code = "es-es",
        voice = "Camila"
    },
    {
        name = "🇫🇷 French (Female)",
        code = "fr-fr",
        voice = "Bette"
    },
    {
        name = "🇩🇪 German (Female)",
        code = "de-de", 
        voice = "Hanna"
    },
    {
        name = "🇮🇹 Italian (Female)",
        code = "it-it",
        voice = "Paola"
    },
    {
        name = "🇷🇺 Russian (Female)",
        code = "ru-ru",
        voice = "Olga"
    },
    {
        name = "🇯🇵 Japanese (Female)",
        code = "ja-jp",
        voice = "Kyoko"
    }
}

local speedSettings = {
    {name = "🚀 Very Fast", value = "1.0"},
    {name = "⚡ Fast", value = "0.8"},
    {name = "🎯 Normal", value = "0.5"},
    {name = "🐢 Slow", value = "0.3"},
    {name = "🚶 Very Slow", value = "0.1"}
}
local function textToSpeech(text, language, voice, speed)
    if not text or text:trim() == "" then
        return nil, "Empty text"
    end
    
    local params = {
        key = VOICE_API_KEY,
        src = text,
        hl = language,
        v = voice,
        r = speed,
        c = "MP3",
        f = "44khz_16bit_stereo"
    }
    
    local url = VOICE_BASE_URL .. "?"
    local first = true
    for k, v in pairs(params) do
        if not first then
            url = url .. "&"
        end
        url = url .. k .. "=" .. urlencode(v)
        first = false
    end
    
    gg.toast("🔄 Converting text to audio...")
    
    local response = gg.makeRequest(url)
    
    if response and response.code == 200 and response.content then
     
        if response.content:sub(1, 6) == "ERROR:" then
            return nil, response.content
        end
        
        local fileName = "/sdcard/voice_output_" .. os.time() .. ".mp3"
        local file = io.open(fileName, "wb")
        if file then
            file:write(response.content)
            file:close()
            return fileName, "Audio saved to: " .. fileName
        else
            return nil, "Error saving file"
        end
    else
        return nil, "Request error: " .. (response.code or "unknown")
    end
end

local function selectLanguage()
    local choices = {}
    for i, setting in ipairs(voiceSettings) do
        table.insert(choices, setting.name)
    end
    
    local choice = gg.choice(choices, nil, "🎙️ Select language and voice:")
    if choice then
        return voiceSettings[choice]
    end
    return nil
end

local function selectSpeed()
    local choices = {}
    for i, setting in ipairs(speedSettings) do
        table.insert(choices, setting.name)
    end
    
    local choice = gg.choice(choices, nil, "🎚️ Select speech speed:")
    if choice then
        return speedSettings[choice]
    end
    return nil
end

local function voiceRSSTool()
    gg.alert("🔊 Voice RSS Text-to-Speech\n\nConvert text to audio with different voices and speeds")
    
    local languageSetting = selectLanguage()
    if not languageSetting then return end
    
    local speedSetting = selectSpeed()
    if not speedSetting then return end
    
    local text = gg.prompt({
        "Enter text to convert to speech:"
    }, {""}, {"text"})
    
    if not text or not text[1] or text[1]:trim() == "" then
        gg.alert("No text provided!")
        return
    end
    
    local result, message = textToSpeech(
        text[1], 
        languageSetting.code, 
        languageSetting.voice, 
        speedSetting.value
    )
    
    if result then
        local alertText = "✅ Conversion completed!\n\n" .. message .. "\n\n"
        
      --  gg.toast("🎵 Playing audio...")
      --  local played = playAudio(result)
        
            alertText = alertText .. "Open the file manually to listen."
        end
        
       -- gg.alert(alertText)
        
        local options = gg.choice({
         
            "📝 New conversion", 
            "❌ Exit"
        }, nil, "What would you like to do?")
        
        if options == 1 then
            voiceRSSTool() 
        elseif options == 2 then
            os.exit() 
        end
        
        gg.alert("❌ Conversion error:\n" .. message)
        
        local retry = gg.alert("Try again?", "Yes", "No")
        if retry == 1 then
            voiceRSSTool()
        end
    end

local function quickExample()
    local exampleText = "Hello! This is a text to speech conversion example using Voice RSS API."
    
    gg.alert("🎧 Quick Example\n\nConverting: \"" .. exampleText .. "\"")
    
    local result, message = textToSpeech(exampleText, "en-us", "Linda", "0.5")
    
    if result then
        gg.alert("✅ Example completed!\n\n" .. message)
        
    else
        gg.alert("❌ Example error:\n" .. message)
    end
end

local function mainMenu()
    while true do
        local choice = gg.choice({
            "🔊 Convert Text to Speech",
            "🎧 Quick Example",
            "ℹ️ About",
            "❌ Exit"
        }, nil, "🔊 Voice RSS Text-to-Speech\n\nSelect an option:")
        
        if choice == 1 then
            voiceRSSTool()
        elseif choice == 2 then
            quickExample()
        elseif choice == 3 then
            gg.alert([[
🔊 Voice RSS Text-to-Speech

Features:
• 10+ different languages
• Male and female voices  
• 5 speech speeds
• High quality MP3 output
• Automatically saves to device

Developed using Voice RSS API
            ]])
        elseif choice == 4 or choice == nil then
            gg.alert("👋 Goodbye!")
            break
        end
    end
end

gg.alert("🔊 Welcome to Voice RSS TTS!\n\nConvert text to audio with professional quality.")
mainMenu()