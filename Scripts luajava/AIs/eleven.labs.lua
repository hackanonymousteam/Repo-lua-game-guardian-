gg.setVisible(true)

local apiKey = "YOUR_API_KEY"  
local apiURL = "https://api.elevenlabs.io/v1/text-to-speech/"

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
local voices = {
    -- Inglês
    {"2EiwWnXFnvU5JabPnv8n", "Clyde - American Male (Intense)"},
    {"CwhRBWXzGAHq8TQ4Fs17", "Roger - American Male (Classy)"},
    {"EXAVITQu4vr4xnSDxMaL", "Sarah - American Female (Professional)"},
    {"FGY2WhTYpPnrIDTdsKH5", "Laura - American Female (Sassy)"},
    {"GBv7mTt0atIp3Br8iCZE", "Thomas - American Male (Meditative)"},
    {"IKne3meq5aSn9XLyUdCD", "Charlie - Australian Male (Hyped)"},
    {"JBFqnCBsd6RMkjVDRZzb", "George - British Male (Mature)"},
    {"N2lVS1w4EtoT3dr4eOWO", "Callum - Male (Characters)"},
    {"SAz9YHcvj6GT2YYXdXww", "River - Neutral (Calm)"},
    {"SOYHLrjzK2X1ezoPC6cr", "Harry - American Male (Rough)"},
    {"TX3LPaxmHKxFdv7VOQHJ", "Liam - American Male (Confident)"},
    {"Xb7hH8MSUJpSbSDYk0k2", "Alice - British Female (Professional)"},
    {"XrExE9yKIg1WjnnlVkGX", "Matilda - American Female (Upbeat)"},
    {"bIHbv24MWmeRgasZH58o", "Will - American Male (Chill)"},
    {"cgSgspJ2msm6clMCkdW9", "Jessica - American Female (Cute)"},
    {"cjVigY5qzO86Huf0OWal", "Eric - American Male (Classy)"},
    {"iP95p4xoKVk53GoZ742B", "Chris - American Male (Casual)"},
    {"nPczCjzI2devNBz1zQrb", "Brian - American Male (Classy)"},
    {"onwK4e9ZLuTAKqWW03F9", "Daniel - British Male (Formal)"},
    {"pFZP5JQG7iQjIQuC4Bku", "Lily - British Female (Warm)"},
    {"pqHfZKP75CvOlQylNhV4", "Bill - American Male (Crisp)"},

    -- Português
    {"21m00Tcm4TlvDq8ikWAM", "Rachel - Portuguese Female (Neutral)"},
    {"QYtR7PfL9Km3NxVd2JbH", "Lucas - Portuguese Male (Calm)"},
    {"QJrX2LdP5Sn8TbVw3HzK", "Ana - Portuguese Female (Cheerful)"},
    {"LkT8VnPw3Qd5HbRx2JmS", "Marcos - Portuguese Male (Confident)"},

    -- Espanhol
    {"AZnzlk1XvdvUeBnXmlld", "Domi - Spanish Female (Professional)"},
    {"ErTt3fHyTnmE4XhR4g8Q", "Carlos - Spanish Male (Warm)"},
    {"RbT9xKvWmJp6LnQs4YzF", "Isabella - Spanish Female (Happy)"},

    -- Francês
    {"BvGm9RZpXqDk2LtY8Cj3", "Emma - French Female (Elegant)"},
    {"MfPq8DkXjRzV4WnT6Lh1", "Louis - French Male (Confident)"},
    {"TpK8VwXnRdJ2GqLm4HsB", "Chloe - French Female (Soft)"},

    -- Alemão
    {"AzJk2XwPqLt9VmNfH3B8", "Friedrich - German Male (Strong)"},
    {"KlMn7GhRfVz1QxJdP9T4", "Sophie - German Female (Soft)"},
    {"PdVt6XkRqJb4HwLs9CnZ", "Heinrich - German Male (Serious)"},

    -- Italiano
    {"JkL9PxTmVqRd5WnZ7YbC", "Giulia - Italian Female (Warm)"},
    {"NrT4VkQpLsJ8DzXy3HfM", "Lorenzo - Italian Male (Friendly)"},
    {"VkB8YpTqXnLm2JdH6RsC", "Francesca - Italian Female (Cheerful)"}
}


local function generateElevenLabsTTS(text, voiceId)
    local url = apiURL .. voiceId
    
    local payload = {
        text = text,
        model_id = "eleven_multilingual_v2",
        voice_settings = {
            stability = 0.5,
            similarity_boost = 0.5
        }
    }

    local jsonPayload = json.encode(payload)

    local headers = {
        ["Content-Type"] = "application/json",
        ["xi-api-key"] = apiKey,
        ["Accept"] = "audio/mpeg"
    }

    gg.toast("Generating audio...")
    local response = gg.makeRequest(url, headers, jsonPayload)

    if type(response) == "table" and response.code == 200 then
        return response.content, true
    else
        local errorMsg = "API error: "
        if type(response) == "table" then
            errorMsg = errorMsg .. "Code " .. (response.code or "N/A")
            if response.content then
                local errorData = json.decode(response.content) or {}
                errorMsg = errorMsg .. "\n" .. (errorData.error and errorData.error.message or response.content)
            end
        else
            errorMsg = errorMsg .. tostring(response)
        end
        return errorMsg, false
    end
end

local function saveAndPlayAudio(audioData, voiceName)
    local name = 'Eleven_audio_' .. os.time() .. '.mp3'
    local path = "/sdcard/"
local abc = path .. name
    local file = io.open(path .. name, "wb")
    if file then
        file:write(audioData)
        file:close()
        gg.alert('Audio saved in ' .. path .. name .. '\n\nVoice: ' .. voiceName)
        
        if gg.playMusic then
            gg.toast("Playing audio...")
            gg.playMusic(abc)
        else
            gg.alert("gg.playMusic not available")
        end
    else
        gg.alert('Failed to save audio.')
    end
end

local function selectVoice()
    local voiceNames = {}
    for i, voice in ipairs(voices) do
        voiceNames[i] = voice[2]
    end
    
    local choice = gg.choice(voiceNames, nil, "Select ElevenLabs Voice")
    
    if choice then
        return voices[choice][1], voices[choice][2]
    end
    return nil, nil
end

local function ttsMenu()
    while true do
        local options = {
            "Generate TTS",
            "Voice List", 
            "Exit"
        }
        
        local choice = gg.choice(options, nil, "ElevenLabs TTS")
        
        if choice == nil or choice == 3 then
            break
            
        elseif choice == 1 then
            local textInput = gg.prompt({
                'Enter text to convert to speech:'
            }, {'Hello, how are you today?'}, {'text'})
            
            if textInput and textInput[1] and textInput[1] ~= "" then
                local voiceId, voiceName = selectVoice()
                
                if voiceId then
                    local audioData, success = generateElevenLabsTTS(textInput[1], voiceId)
                    
                    if success then
                        saveAndPlayAudio(audioData, voiceName)
                    else
                        gg.alert("Error: " .. audioData)
                    end
                end
            end
            
        elseif choice == 2 then
            local voiceList = "Available Voices:\n\n"
            for i, voice in ipairs(voices) do
                voiceList = voiceList .. voice[2] .. "\n"
                if i % 8 == 0 then
                    voiceList = voiceList .. "\n"
                end
            end
            gg.alert(voiceList)
        end
    end
end

if apiKey == "" then
    local keyInput = gg.prompt({
        'Enter your ElevenLabs API Key:'
    }, {''}, {'text'})
    
    if keyInput and keyInput[1] and keyInput[1] ~= "" then
        apiKey = keyInput[1]
        gg.toast("API Key configured")
    else
        gg.alert("API Key is required for ElevenLabs TTS")
        return
    end
end

local startChoice = gg.choice({
    "ElevenLabs Menu",
    "Quick Generate",
    "Exit"
}, nil, "ElevenLabs Text-to-Speech")

if startChoice == 1 then
    ttsMenu()
elseif startChoice == 2 then
    local textInput = gg.prompt({
        'Enter text for quick TTS:'
    }, {'Hello world'}, {'text'})
    
    if textInput and textInput[1] and textInput[1] ~= "" then
        local audioData, success = generateElevenLabsTTS(textInput[1], "2EiwWnXFnvU5JabPnv8n")
        
        if success then
            saveAndPlayAudio(audioData, "Clyde - Quick Voice")
        else
            gg.alert("Error: " .. audioData)
        end
    end
end