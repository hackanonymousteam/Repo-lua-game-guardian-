function encode(text)
  return text:gsub("([^%w ])", function(c)
    return string.format("%%%02X", string.byte(c))
  end):gsub(" ", "+")
end

function translateMyMemory(text, fromLang, toLang)
  local url = "https://api.mymemory.translated.net/get" ..
              "?q=" .. encode(text) ..
              "&langpair=" .. fromLang .. "|" .. toLang

  local response = gg.makeRequest(url)
  if not response or not response.content then
    return nil, "No response from API"
  end

  local translated = response.content:match('"translatedText"%s*:%s*"([^"]+)"')
  if translated then
    return translated
  else
    return nil, "Translation not found in response"
  end
end

local languages = {
  "English=en",
  "Portuguese=pt",
  "Spanish=es",
  "French=fr",
  "German=de",
  "Italian=it",
  "Japanese=ja",
  "Korean=ko",
}

local fromIndex = gg.choice(languages, nil, "Select source language")
if not fromIndex then return end
local toIndex = gg.choice(languages, nil, "Select target language")
if not toIndex then return end

local fromLang = languages[fromIndex]:match("=(%a+)")
local toLang = languages[toIndex]:match("=(%a+)")

local input = gg.prompt({"Text to translate"}, {}, {"text"})
if input then
  local result, err = translateMyMemory(input[1], fromLang, toLang)
  if result then
    print("Translation: " .. result)
  else
    print("Error: " .. err)
  end
end