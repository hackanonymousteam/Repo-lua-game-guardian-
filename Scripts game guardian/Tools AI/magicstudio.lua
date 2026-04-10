gg.setVisible(true)

function Translate(InputText, SystemLangCode, TargetLangCode)
    local encodedText = InputText:gsub("\n", "\r\n")
    encodedText = encodedText:gsub("([^%w])", function(c) 
        return string.format("%%%02X", string.byte(c)) 
    end)
    encodedText = encodedText:gsub(" ", "%%20")
    
    local url = "https://translate.googleapis.com/translate_a/single?client=gtx&sl="..
                SystemLangCode.."&tl="..TargetLangCode.."&dt=t&dt=rm&q="..encodedText
    
    local response = gg.makeRequest(url, {
        ['User-Agent'] = "Mozilla/5.0"
    }).content
    
    if response == nil then
        gg.alert("Failed to connect to translation server.")
        return nil, nil
    end
    
    local matches = {}
    for match in response:gmatch("\"(.-)\"") do
        table.insert(matches, match)
    end
    
    local translatedText = matches[1] or InputText
    local phoneticText = matches[3] or "(phonetic not available)"
    
    return translatedText, phoneticText
end

local function urlEncode(str)
    return (str:gsub("([^%w%-_%.~])", function(c)
        return string.format("%%%02X", string.byte(c))
    end))
end

local input = gg.prompt({"Enter prompt for image generation:"}, {""}, {"text"})
if not input or input[1] == "" then
    gg.alert("No prompt entered!")
    return
end
local userPrompt = input[1]

local translatedPrompt, _ = Translate(userPrompt, "auto", "en")
if not translatedPrompt then
    translatedPrompt = userPrompt 
end

--gg.toast("Translated prompt: "..translatedPrompt)

local apiUrl = "https://ai-api.magicstudio.com/api/ai-art-generator"
local headers = {
    ["accept"] = "application/json, text/plain, */*",
    ["accept-language"] = "en-US,en;q=0.9",
    ["origin"] = "https://magicstudio.com",
    ["referer"] = "https://magicstudio.com/ai-art-generator/",
    ["content-type"] = "application/x-www-form-urlencoded",
    ["user-agent"] = "Mozilla/5.0"
}

local body = "prompt=" .. urlEncode(translatedPrompt)
           .. "&output_format=bytes"
           .. "&user_profile_id=null"
           .. "&user_is_subscribed=true"

gg.toast("Generating image...")

local resp = gg.makeRequest(apiUrl, headers, body)

if type(resp) ~= "table" or not resp.content then
    gg.alert("Failed to fetch image.")
    return
end

if resp.code ~= 200 then
    gg.alert("HTTP error: " .. tostring(resp.code) .. "\n" .. (resp.content or ""))
    return
end

local filePath = "/storage/emulated/0/magicstudio_"..userPrompt..".png"
local f = io.open(filePath, "wb")
if f then
    f:write(resp.content)
    f:close()
    gg.alert("✅ Image saved:\n"..filePath)
else
    gg.alert("Failed to save image.")
end