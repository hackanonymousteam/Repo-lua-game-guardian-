local country_language_map = {
    BR = "en|pt",
    US = "en|es",
    CA = "en|fr",
    GB = "en|fr",
    FR = "en|fr",
    DE = "en|de",
    IN = "en|hi",
    JP = "en|ja",
    CN = "en|zh-CN",
    AU = "en|zh-CN",
    RU = "en|ru",
    IT = "en|it",
    ES = "en|es",
    MX = "en|es",
    ZA = "en|af",
    KR = "en|ko"
}

local function makeRequest(url)
    local request = gg.makeRequest(url)
    if not request or not request.content then
        print('Error in request.')
        os.exit()
    end
    return request.content
end

local Link = "https://ipwhois.app/json/"
local response = makeRequest(Link)

local function extractCountryCodeFromHTML(html)
    local pattern = '"country_code":"(.-)"'
    return html:match(pattern)
end

local country_code = extractCountryCodeFromHTML(response)

if not country_code then
    print('Error in getting country code.')
    os.exit()
end

print('Country code:', country_code)

local langpair = country_language_map[country_code]

if not langpair then
    print('No support for this language:', country_code)
    os.exit()
end

local chat = gg.prompt({'Insert text'}, {}, {'text'})
if chat == nil then
    return
end

local duck = chat[1]

local function urlencode(char)
    local byte = string.byte(char)
    local hex = string.format("%02X", byte)
    return "%" .. hex
end

local function url_encode(str)
    local encoded_str = ""
    for i = 1, #str do
        local char = string.sub(str, i, i)
        if char:match("[^%w%-_%.~]") then
            encoded_str = encoded_str .. urlencode(char)
        else
            encoded_str = encoded_str .. char
        end
    end
    return encoded_str:gsub(" ", "+")
end

local encoded_str = url_encode(duck)

local translation_url = 'https://api.mymemory.translated.net/get?q='..encoded_str..'&langpair='..langpair
local translation_response = makeRequest(translation_url)

local function extractTranslationFromHTML(html)
    local pattern = '"translatedText"%s*:%s*"([^"]+)"'
    return html:match(pattern)
end

local translation = extractTranslationFromHTML(translation_response)

local function decodeUnicode(str)
    return str:gsub("\\u(%x%x%x%x)", function(h)
        return utf8.char(tonumber(h, 16))
    end)
end

if not translation then
    print('Translation Error')
else
    local decoded_trans = decodeUnicode(translation)
    decoded_trans = decoded_trans:gsub("\\n", "\n")
    print('Translated Text:', decoded_trans)
end