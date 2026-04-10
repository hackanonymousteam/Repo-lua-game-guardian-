gg.setVisible(true)
local json = nil
if not pcall(function()
json = load(gg.makeRequest("https://raw.githubusercontent.com/rxi/json.lua/master/json.lua").content)()
end) then
json = require("json") or gg.alert("JSON library not available")
if not json then return end
end
function detectLanguage()
local systemLang = gg.getLocale() or "en"
local langMap = {
pt = "pt", br = "pt", us = "en", uk = "en", es = "es", fr = "fr", de = "de", it = "it", jp = "ja", cn = "zh", ru = "ru", idn = "id", ind = "id", ms = "ms"
}
for k, v in pairs(langMap) do
if systemLang:lower():find(k) then
return v
end
end
return "en"
end
function translateText(inputText, targetLang)
if not inputText or inputText == "" then return inputText end
local encodedText = inputText:gsub("\n", "\r\n")
encodedText = encodedText:gsub("([^%w])", function(c) 
return string.format("%%%02X", string.byte(c)) 
end)
encodedText = encodedText:gsub(" ", "%%20")
local url = "https://translate.googleapis.com/translate_a/single?client=gtx&sl=auto&tl="..targetLang.."&dt=t&q="..encodedText
local response = gg.makeRequest(url, {['User-Agent'] = "Mozilla/5.0"}).content
if response then
local matches = {}
for match in response:gmatch("\"([^\"]+)\"") do
table.insert(matches, match)
end
return matches[1] or inputText
end
return inputText
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
function urlencode(str)
    if str then
        str = string.gsub(str, "\n", "\r\n")
        str = string.gsub(str, "([^%w %-%_%.%~])",
            function(c) return string.format("%%%02X", string.byte(c)) end)
        str = string.gsub(str, " ", "+")
    end
    return str
end
function selectAPI()
local apis = {
"ChristyAI",
"DeepSeek",
"TTS SpongeBob",
"Bing Image Search",
"Brat Text Generator",
"Random BA",
"Random China",
"Random Porn Anime",
"FlamingText Logo",
"Cancel"
}
local choice = gg.choice(apis, nil, "Select an API")
if not choice or choice == 10 then return nil end
return choice
end
function processResponse(apiType, response)
if not response or not response.content then return "Error: No response from API" end
local success, data = pcall(json.decode, response.content)
if not success then return response.content end
if apiType == 1 or apiType == 2 then
if data.status and data.response then
local text = data.response
text = text:gsub("\\r\\n", "\n")
text = text:gsub("\\n", "\n")
text = text:gsub("\\r", "\n")
text = text:gsub("\\t", "\t")
text = text:gsub("\\\\", "\\")
return text
end
elseif apiType == 3 then
if data.status and data.result and data.result.url then
return data.result.url
end
elseif apiType == 4 then
if data.status and data.result then
local urls = {}
for i, item in ipairs(data.result) do
if item.url and item.url ~= "" then
table.insert(urls, item.url)
end
end
return urls
end
elseif apiType == 5 or apiType == 6 or apiType == 7 or apiType == 8 or apiType == 9 then
return response.content
end
return json.encode(data)
end
function downloadAndShowImage(imageUrl)
local imageData = downloadFile(imageUrl)
if imageData then
local filename = "image_"..os.time()..".jpg"
local filepath = saveFileToStorage(imageData, filename)
if filepath then
image(filepath)
toast("Image saved to: "..filepath)
return true
end
end
gg.alert("Failed to download image")
return false
end
function main()
local userLang = detectLanguage()
local apiChoice = selectAPI()
if not apiChoice then
gg.alert(translateText("Operation cancelled", userLang))
return
end
local promptTitle = "Enter your question/text"
local inputType = "text"
if apiChoice == 3 then
promptTitle = "Enter text for SpongeBob TTS"
elseif apiChoice == 4 then
promptTitle = "Enter search term for images"
elseif apiChoice == 5 then
promptTitle = "Enter text for Brat image"
elseif apiChoice == 6 or apiChoice == 7 or apiChoice == 8 then
promptTitle = "Press OK to generate random image"
inputType = nil
elseif apiChoice == 9 then
promptTitle = "Enter text for FlamingText logo"
inputType = "text"
end
local chat
if inputType then
chat = gg.prompt({translateText(promptTitle, userLang)}, {}, {inputType})
if not chat or not chat[1] or chat[1]:trim() == "" then
gg.alert(translateText("Empty input or cancelled", userLang))
return
end
end
local url
local query = chat and chat[1] or ""
if apiChoice == 1 then
query = query:gsub(" ", "%%20")
url = "https://www.malzxyz-api-docs.web.id/ai/christyai?text=" .. query
elseif apiChoice == 2 then
query = query:gsub(" ", "%%20")
url = "https://www.malzxyz-api-docs.web.id/ai/deepseek?text=" .. query
elseif apiChoice == 3 then
query = query:gsub(" ", "%%20")
url = "https://www.malzxyz-api-docs.web.id/tts/spongebob?text=" .. query
elseif apiChoice == 4 then
query = query:gsub(" ", "%%20")
url = "https://www.malzxyz-api-docs.web.id/search/bingimage?q=" .. query
elseif apiChoice == 5 then
query = query:gsub(" ", "%%20")
url = "https://www.malzxyz-api-docs.web.id/imagecreator/brat?text=" .. query
elseif apiChoice == 6 then
url = "https://www.malzxyz-api-docs.web.id/random/ba"
elseif apiChoice == 7 then
url = "https://www.malzxyz-api-docs.web.id/random/cecan-china"
elseif apiChoice == 8 then
url = "https://www.malzxyz-api-docs.web.id/random/nsfw"
elseif apiChoice == 9 then
local encodedQuery = urlencode(query)
url = "https://www6.flamingtext.com/net-fu/proxy_form.cgi?&imageoutput=true&script=neon-logo&doScale=true&scaleWidth=800&scaleHeight=500&fontsize=100&text=" .. encodedQuery
end

gg.toast(translateText("Processing...", userLang))
local response = gg.makeRequest(url)
if not response or not response.content then
gg.alert(translateText("Error connecting to API", userLang))
return
end
if apiChoice == 3 then
local audioUrl = processResponse(apiChoice, response)
if audioUrl and type(audioUrl) == "string" and audioUrl:match("^https?://") then
local audioData = downloadFile(audioUrl)
if audioData then
local filename = "tts_spongebob_"..os.time()..".wav"
local filepath = saveFileToStorage(audioData, filename)
if filepath then
gg.playMusic(filepath)
gg.alert(translateText(" File saved to: " .. filepath, userLang))
else
gg.alert(translateText("Error saving audio", userLang))
end
else
gg.alert(translateText("Error downloading audio", userLang))
end
else
gg.alert(translateText("Invalid audio URL", userLang))
end
elseif apiChoice == 4 then
local imageUrls = processResponse(apiChoice, response)
if type(imageUrls) == "table" and #imageUrls > 0 then
local choices = {}
for i, url in ipairs(imageUrls) do
table.insert(choices, "Image "..i)
end
local selected = gg.choice(choices, nil, translateText("Select image to download", userLang))
if selected then
downloadAndShowImage(imageUrls[selected])
end
else
gg.alert(translateText("No images found", userLang))
end
elseif apiChoice == 5 or apiChoice == 6 or apiChoice == 7 or apiChoice == 8 or apiChoice == 9 then
local filename = "image_"..os.time()..".jpg"
local filepath = saveFileToStorage(response.content, filename)
if filepath then
image(filepath)
gg.toast(translateText("Image saved to: "..filepath, userLang))
else
gg.alert(translateText("Error saving image", userLang))
end
else
local result = processResponse(apiChoice, response)
local translated = translateText(result, userLang)
gg.alert(translated)
if gg.copyText then
if gg.alert(translateText("Copy response?", userLang), translateText("Yes", userLang), translateText("No", userLang)) == 1 then
gg.copyText(result)
gg.toast(translateText("Copied!", userLang))
end
end
end
end
main()