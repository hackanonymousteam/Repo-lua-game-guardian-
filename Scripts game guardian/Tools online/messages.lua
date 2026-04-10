
function translate(text, target_lang)
  if type(text) ~= 'string' or #text < 1 then return text end
  local function url_encode(str)
    return str:gsub("([^%w])", function(c)
      return string.format("%%%02X", string.byte(c))
    end)
  end
  local headers = {['User-Agent'] = 'GoogleTranslate/6.3.0.RC06.277163268 Linux; U; Android 14; A201SO Build/64.2.E.2.140'}
  local req = gg.makeRequest(
    'https://translate.googleapis.com/translate_a/single?client=gtx&sl=auto&tl=' ..
    target_lang .. '&dt=t&q=' .. url_encode(text),
    headers
  )
  if type(req) ~= 'table' or not req.content then return text end
  local result = req.content:match('"%s*(.-)%s*"')
  return result or text
end

local yiyan = gg.makeRequest("https://v1.hitokoto.cn/").content
local content = yiyan:match('"hitokoto"%s*:%s*"(.-)"')
local from = yiyan:match('"from"%s*:%s*"(.-)"')

local userLang = gg.getLocale()
local translated = translate(content, userLang)

gg.alert(translated)