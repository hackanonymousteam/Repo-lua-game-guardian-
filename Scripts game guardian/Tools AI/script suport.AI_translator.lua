gg.setVisible(true)

local json = load(gg.makeRequest("https://raw.githubusercontent.com/rxi/json.lua/master/json.lua").content)()

local API_URL = "https://api.voidai.app/v1/chat/completions"
local API_KEY =     "YOUR_API_KEY"
    
local function parseResponse(content)
    local ok, data = pcall(json.decode, content)
    if not ok or not data then 
        return nil
    end
    
    if data.choices and data.choices[1] then
        return data.choices[1].message.content
    end
    
    return nil
end

local function translateText(textToTranslate, targetLanguage)
    local prompt = "Translate the following text to " .. targetLanguage .. ". Return ONLY the translated text, nothing else, no explanations, no quotation marks: " .. textToTranslate

    local payload = {
        model = "gpt-5.1",
        messages = {
            {
                role = "user",
                content = prompt
            }
        },
        temperature = 0.3,
        max_tokens = 100
    }
    
    local headers = {
        ["Authorization"] = "Bearer " .. API_KEY,
        ["Content-Type"] = "application/json"
    }
    
    local res = gg.makeRequest(
        API_URL,
        headers,
        json.encode(payload),
        "POST"
    )
    
    if type(res) ~= "table" then
        return textToTranslate
    end
    
    if res.code ~= 200 then
        return textToTranslate
    end
    
    local reply = parseResponse(res.content)
    
    if not reply then
        return textToTranslate
    end
    
    return reply
end

local languages = {
    "English",
    "Portuguese",
    "Spanish",
    "French",
    "German",
    "Italian",
    "Russian",
    "Japanese",
    "Korean",
    "Chinese",
    "Arabic",
    "Turkish",
    "Indonesian",
    "Thai",
    "Vietnamese"
}

local languageCodes = {
    ["English"] = "en",
    ["Portuguese"] = "pt",
    ["Spanish"] = "es",
    ["French"] = "fr",
    ["German"] = "de",
    ["Italian"] = "it",
    ["Russian"] = "ru",
    ["Japanese"] = "ja",
    ["Korean"] = "ko",
    ["Chinese"] = "zh",
    ["Arabic"] = "ar",
    ["Turkish"] = "tr",
    ["Indonesian"] = "id",
    ["Thai"] = "th",
    ["Vietnamese"] = "vi"
}

if not selectedLanguage then
    local choice = gg.choice(languages, nil, "Choose your language")
    if choice then
        selectedLanguage = languageCodes[languages[choice]]
        gg.alert("Language saved: " .. languages[choice])
    else
        selectedLanguage = "en"
        gg.toast("No language selected, using default: English")
    end
end

local function1 = "Headshot"
local function2 = "Speed Hack"
local function3 = "Fly Hack"
local function4 = "Unlimited Money"
local function5 = "Bypass"
local exitText = "Exit"
local menuTitle = "Script by your name"
local toast1 = "Headshot Activated"
local toast2 = "Speed Hack Activated"
local toast3 = "Fly Hack Activated"
local toast4 = "Unlimited Money Activated"
local toast5 = "Bypass Activated"

local T1 = translateText(function1, selectedLanguage)
local T2 = translateText(function2, selectedLanguage)
local T3 = translateText(function3, selectedLanguage)
local T4 = translateText(function4, selectedLanguage)
local T5 = translateText(function5, selectedLanguage)
local Texit = translateText(exitText, selectedLanguage)
local Ttitle = translateText(menuTitle, selectedLanguage)
local Ttoast1 = translateText(toast1, selectedLanguage)
local Ttoast2 = translateText(toast2, selectedLanguage)
local Ttoast3 = translateText(toast3, selectedLanguage)
local Ttoast4 = translateText(toast4, selectedLanguage)
local Ttoast5 = translateText(toast5, selectedLanguage)

function start()
    local menuchper = gg.multiChoice({
        T1,
        T2,
        T3,
        T4,
        T5,
        Texit
    }, nil, Ttitle)

    if menuchper then  
        if menuchper[1] then headshot() end  
        if menuchper[2] then speedHack() end  
        if menuchper[3] then flyHack() end  
        if menuchper[4] then unlimitedMoney() end  
        if menuchper[5] then bypass() end  
        if menuchper[6] then os.exit() end  
    end
end

function headshot()
    gg.setRanges(gg.REGION_ANONYMOUS)
    gg.searchNumber("1;-1088232020D::5", 16)
    gg.refineNumber("1", 16)
    gg.getResults(100)
    gg.editAll("200.621", 16)
    gg.clearResults()
    gg.toast(Ttoast1)
end

function speedHack()
    gg.setRanges(gg.REGION_ANONYMOUS)
    gg.searchNumber("2;1092837465D::5", 16)
    gg.refineNumber("2", 16)
    gg.getResults(100)
    gg.editAll("1.5", 16)
    gg.clearResults()
    gg.toast(Ttoast2)
end

function flyHack()
    gg.setRanges(gg.REGION_ANONYMOUS)
    gg.searchNumber("3;209384756D::5", 16)
    gg.refineNumber("3", 16)
    gg.getResults(100)
    gg.editAll("-5.0", 16)
    gg.clearResults()
    gg.toast(Ttoast3)
end

function unlimitedMoney()
    gg.setRanges(gg.REGION_ANONYMOUS)
    gg.searchNumber("99999;123456789D::5", 16)
    gg.refineNumber("99999", 16)
    gg.getResults(100)
    gg.editAll("999999999", 16)
    gg.clearResults()
    gg.toast(Ttoast4)
end

function bypass()
    gg.setRanges(gg.REGION_ANONYMOUS)
    gg.searchNumber("777;192837465D::5", 16)
    gg.refineNumber("777", 16)
    gg.getResults(100)
    gg.editAll("0", 16)
    gg.clearResults()
    gg.toast(Ttoast5)
end

while true do
    if gg.isVisible(true) then
        gg.setVisible(false)
        start()
    end
end