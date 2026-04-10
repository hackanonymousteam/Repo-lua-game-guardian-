gg.setVisible(true)

local API_URL = "https://www.sparklingapps.com/piccybotapi/index.php/speech"
local VOICES = {"alloy", "echo", "fable", "onyx", "nova", "shimmer"}
local currentVoice = "alloy"

local json = nil
if not pcall(function()
    json = load(gg.makeRequest("https://raw.githubusercontent.com/rxi/json.lua/master/json.lua").content)()
end) then
    json = require("json") or gg.alert("Sem JSON")
    if not json then return end
end

function generateTTS(text)
    if not text or #text == 0 then return nil end
    
    local payload = {
        extracted_content = "Read only this text word by word, do not add anything else: " .. text,
        voice = currentVoice,
        exp = true,
        mode = "standard",
        purchase_token = "",
        sub = true,
        piccy_valid = ""
    }
    
    local headers = {
        ["Content-Type"] = "application/json",
        ["User-Agent"] = "PiccyBot/1.76"
    }
    
    local payloadStr = json.encode(payload)
    local response = gg.makeRequest(API_URL, headers, payloadStr, "POST")
    
    if type(response) == "table" and response.code == 200 then
        return response.content
    end
    return nil
end

function main()
    while true do
        local choice = gg.choice({
            "generate audio",
            "voice: " .. currentVoice,
            "exit"
        })
        
        if not choice then break end
        
        if choice == 1 then
            local input = gg.prompt({"Texto:"}, {""})
            if input and input[1] then
                local audio = generateTTS(input[1])
                if audio then
                    local filename = "tts.mp3"
                    local file = io.open(filename, "wb")
                    if file then
                        file:write(audio)
                        file:close()
                        gg.playMusic(filename)
                    end
                end
            end
            
        elseif choice == 2 then
            local options = {}
            for _, v in ipairs(VOICES) do
                table.insert(options, v)
            end
            local voiceChoice = gg.choice(options)
            if voiceChoice then
                currentVoice = VOICES[voiceChoice]
            end
            
        elseif choice == 3 then
            break
        end
    end
end

main()