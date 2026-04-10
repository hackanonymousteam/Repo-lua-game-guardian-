function Translate(InputText, SystemLangCode, TargetLangCode)
    local encodedText = InputText:gsub("\n", "\r\n")
    encodedText = encodedText:gsub("([^%w])", function(c) 
        return string.format("%%%02X", string.byte(c)) 
    end)
    encodedText = encodedText:gsub(" ", "%%20")
    
    local url = "https://translate.googleapis.com/translate_a/single?client=gtx&sl="..
                SystemLangCode.."&tl="..TargetLangCode.."&dt=t&dt=rm&q="..encodedText
    
    local response = gg.makeRequest(url, {
        ['User-Agent'] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.3578.98 Safari/537.36"
    }).content
    
    if response == nil then
        gg.alert("Failed to connect to server, check your internet connection.")
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

function SaveAudio(Text, LangCode)
    local encodedText = Text:gsub("([^%w])", function(c) 
        return string.format("%%%02X", string.byte(c)) 
    end)
    encodedText = encodedText:gsub(" ", "%%20")
    
    local TTSurl = "https://translate.google.com/translate_tts?ie=UTF-8&client=gtx&tl="..
                   LangCode.."&q="..encodedText
    
    local audio = gg.makeRequest(TTSurl, {
        ['User-Agent'] = "Mozilla/5.0"
    }).content
    
    if audio == nil then
        gg.alert("Failed to get TTS audio.")
        return false
    end
    
    local filePath = "/sdcard/translation_"..LangCode..".mp3"
    local file = io.open(filePath, "wb")
    if file then
        file:write(audio)
        file:close()
        gg.alert("Audio saved to: "..filePath)
        return true
    else
        gg.alert("Could not save audio file.")
        return false
    end
end

local langtable = {{}, {}}
local lang_code = {
    'af', 'afrikaans', 'sq', 'albanian', 'am', 'amharic', 'ar', 'arabic', 
    'hy', 'armenian', 'az', 'azerbaijani', 'eu', 'basque', 'be', 'belarusian', 
    'bn', 'bengali', 'bs', 'bosnian', 'bg', 'bulgarian', 'ca', 'catalan', 
    'ceb', 'cebuano', 'ny', 'chichewa', 'zh-cn', 'chinese (simplified)', 
    'zh-tw', 'chinese (traditional)', 'co', 'corsican', 'hr', 'croatian', 
    'cs', 'czech', 'da', 'danish', 'nl', 'dutch', 'en', 'english', 
    'eo', 'esperanto', 'et', 'estonian', 'tl', 'filipino', 'fi', 'finnish', 
    'fr', 'french', 'fy', 'frisian', 'gl', 'galician', 'ka', 'georgian', 
    'de', 'german', 'el', 'greek', 'gu', 'gujarati', 'ht', 'haitian creole', 
    'ha', 'hausa', 'haw', 'hawaiian', 'iw', 'hebrew', 'hi', 'hindi', 
    'hmn', 'hmong', 'hu', 'hungarian', 'is', 'icelandic', 'ig', 'igbo', 
    'id', 'indonesian', 'ga', 'irish', 'it', 'italian', 'ja', 'japanese', 
    'jw', 'javanese', 'kn', 'kannada', 'kk', 'kazakh', 'km', 'khmer', 
    'ko', 'korean', 'ku', 'kurdish (kurmanji)', 'ky', 'kyrgyz', 'lo', 'lao', 
    'la', 'latin', 'lv', 'latvian', 'lt', 'lithuanian', 'lb', 'luxembourgish', 
    'mk', 'macedonian', 'mg', 'malagasy', 'ms', 'malay', 'ml', 'malayalam', 
    'mt', 'maltese', 'mi', 'maori', 'mr', 'marathi', 'mn', 'mongolian', 
    'my', 'myanmar (burmese)', 'ne', 'nepali', 'no', 'norwegian', 'ps', 'pashto', 
    'fa', 'persian', 'pl', 'polish', 'pt', 'portuguese', 'pa', 'punjabi', 
    'ro', 'romanian', 'ru', 'russian', 'sm', 'samoan', 'gd', 'scots gaelic', 
    'sr', 'serbian', 'st', 'sesotho', 'sn', 'shona', 'sd', 'sindhi', 
    'si', 'sinhala', 'sk', 'slovak', 'sl', 'slovenian', 'so', 'somali', 
    'es', 'spanish', 'su', 'sundanese', 'sw', 'swahili', 'sv', 'swedish', 
    'tg', 'tajik', 'ta', 'tamil', 'te', 'telugu', 'th', 'thai', 'tr', 'turkish', 
    'uk', 'ukrainian', 'ur', 'urdu', 'uz', 'uzbek', 'vi', 'vietnamese', 
    'cy', 'welsh', 'xh', 'xhosa', 'yi', 'yiddish', 'yo', 'yoruba', 'zu', 'zulu', 
    'fil', 'Filipino', 'he', 'Hebrew'
}

for i, code in ipairs(lang_code) do
    if i % 2 == 0 then
        table.insert(langtable[1], code)
    else
        table.insert(langtable[2], code)
    end
end

::asktext::
local Text = gg.prompt({"Enter text to translate:"}, nil, {"text"})
if Text == nil then
    gg.alert("Please enter text to translate!")
    goto asktext
end

::askcode::
local choice = gg.choice(langtable[1], nil, "Translate to:")
if choice == nil then
    goto askcode
end

local targetLangCode = langtable[2][choice]

local translatedText, phoneticText = Translate(Text[1], "auto", targetLangCode)

if translatedText then
    local result = "Translation ("..langtable[1][choice].."):\n"..translatedText..
                   "\n\nPhonetic:\n"..phoneticText
    
    local options = {"Save audio", "OK"}
    local action = gg.choice(options, nil, result)
    
    if action == 1 then
        SaveAudio(translatedText, targetLangCode)
    end
end