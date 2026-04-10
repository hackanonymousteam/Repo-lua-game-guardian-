gg.setVisible(true)
local json = nil
if not pcall(function()
json = load(gg.makeRequest("https://raw.githubusercontent.com/rxi/json.lua/master/json.lua").content)()
end) then
json = require("json") or gg.alert("JSON library not available")
if not json then return end
end

function urlencode(str)
if str then
str = string.gsub(str, "\n", "\r\n")
str = string.gsub(str, "([^%w %-%_%.%~])",
function(c) return string.format("%%%02X", string.byte(c)) end)
str = string.gsub(str, " ", "%%20")
end
return str
end

function saveFileToStorage(data, filename)
local filepath = "/sdcard/"..filename
local file = io.open(filepath, "wb")
if file then
file:write(data)
file:close()
return filepath
end
return nil
end

function downloadFile(url)
local response = gg.makeRequest(url)
if response and response.content then
return response.content
end
return nil
end

function selectAPI()
local apis = {
"🤖 PowerBrain AI",
"📝 Lyrics Generator",
"💻 HTML/CSS/JS Generator",
"🔊 TikTok TTS",
"❌ Cancel"
}
local choice = gg.choice(apis, nil, "🎯 Select an API")
if not choice or choice == 5 then return nil end
return choice
end

function getTikTokVoices()
    local url = "https://xlhyimcdp9om.manus.space/api/voices"
    local response = gg.makeRequest(url)

    if response and response.content then
        local success, data = pcall(json.decode, response.content)

        if success and data and data.voices then
            return data.voices
        end
    end

    gg.alert("Failed to load voice list")
    return nil
end

function selectVoice(voices)
    if not voices then return nil end

    local voiceNames = {}

    for i = 1, #voices do
        voiceNames[i] = voices[i].name
    end

    voiceNames[#voiceNames + 1] = "❌ Cancel"

    local choice = gg.choice(voiceNames, nil, "🎤 Select a voice")

    if not choice or choice > #voices then
        return nil
    end

    return voices[choice].id
end
function formatResponse(apiType, response)
if not response or not response.content then return "Error: No response from API" end
if apiType == 1 then
local success, data = pcall(json.decode, response.content)
if success and data.result then
local text = data.result
text = text:gsub("([%.,!?;:])", "%1 ")
text = text:gsub("%s+", " ")
return text
end
elseif apiType == 2 then
local success, data = pcall(json.decode, response.content)
if success and data.result then
return data.result
end
elseif apiType == 3 then
local success, data = pcall(json.decode, response.content)
if success and data.result and data.result.reply then
local reply = data.result.reply
reply = reply:gsub("\\n", "\n")
reply = reply:gsub("\\t", "\t")
reply = reply:gsub("\\\"", "\"")
reply = reply:gsub("```html", "")
reply = reply:gsub("```", "")
return reply
end
return response.content
elseif apiType == 4 then
return response.content
end
return response.content
end

function testTikTokTTS(voice, text)
local encodedText = urlencode(text)
local url = "https://xlhyimcdp9om.manus.space/api/generate?voice=" .. voice .. "&text=" .. encodedText
gg.toast("Testing TTS with voice: " .. voice)
local response = gg.makeRequest(url)
if response and response.content then
local success, data = pcall(json.decode, response.content)
if success and data.error then
gg.alert("TTS Error: " .. data.error)
return nil
elseif success and data.success == false then
gg.alert("TTS Failed: " .. (data.error or "Unknown error"))
return nil
end
local filename = "tts_test_" .. os.time() .. ".mp3"
local filepath = saveFileToStorage(response.content, filename)
if filepath then
gg.playMusic(filepath)
gg.alert("✅ TTS Test Successful!\nVoice: " .. voice .. "\nFile: " .. filepath)
return filepath
else
gg.alert("❌ Failed to save TTS audio")
return nil
end
else
gg.alert("❌ No response from TTS API")
return nil
end
end

function main()
local apiChoice = selectAPI()
if not apiChoice then
gg.alert("Operation cancelled")
return
end
local promptTitle = "Enter your question/text"
local inputType = "text"
local isTTS = false
if apiChoice == 2 then
promptTitle = "Enter song lyrics theme"
elseif apiChoice == 3 then
promptTitle = "Enter what you want to create (e.g., digital clock with neon effect)"
elseif apiChoice == 4 then
isTTS = true
promptTitle = "Enter text to convert to speech"
end
local selectedVoice
if isTTS then
gg.toast("Getting voice list...")
local voices = getTikTokVoices()
selectedVoice = selectVoice(voices)
if not selectedVoice then
gg.alert("Selected index: " .. tostring(choice) ..
         "\nName: " .. tostring(voices[choice].name) ..
         "\nVoice ID: " .. tostring(voices[choice].voice_id))
return
end
end
local chat = gg.prompt({promptTitle}, {}, {inputType})
if not chat or not chat[1] or chat[1]:trim() == "" then
gg.alert("Empty input or cancelled")
return
end
local query = chat[1]
local encodedQuery = urlencode(query)
local url
gg.toast("Processing...")
if apiChoice == 1 then
url = "https://yogapis.web.id/api/ai/powerbrain?query=" .. encodedQuery
elseif apiChoice == 2 then
url = "https://angela-imut-27.vercel.app/lyrics?prompt=/" .. encodedQuery
elseif apiChoice == 3 then
url = "https://apis.scraper.web.id/soymaycolicu?text=" .. encodedQuery .. "&model=deepseek/deepseek-v3-0324"
elseif apiChoice == 4 then
testTikTokTTS(selectedVoice, query)
return
end
local response = gg.makeRequest(url)
if not response or not response.content then
gg.alert("Error connecting to API")
return
end
local result = formatResponse(apiChoice, response)
if string.len(result) > 3000 then
if gg.alert("Result too long. Save to file?", "Yes", "No") == 1 then
local filename = "result_" .. os.time() .. ".txt"
local filepath = saveFileToStorage(result, filename)
if filepath then
gg.alert("✅ Saved to:\n" .. filepath)
end
else
gg.alert(string.sub(result, 1, 3000) .. "...")
end
else
gg.alert(result)
end
if gg.copyText then
if gg.alert("Copy response?", "Yes", "No") == 1 then
gg.copyText(result)
gg.toast("Copied!")
end
end
end
main()