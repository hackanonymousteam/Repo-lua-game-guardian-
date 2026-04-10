
local chat = gg.prompt({'insert text'}, {}, {'text'})
if chat == nil then
    return
end

local duck = chat[1]
local request = gg.makeRequest('https://api.mymemory.translated.net/get?q='..duck..'&langpair=en|pt')

if request == nil or request.content == nil then
    print('error get reply translate.')
    return
end

local response = request.content
local function extracttransFromHTML(html)

    local pattern = '"translatedText"%s*:%s*"([^"]+)"'
    local trans = html:match(pattern)
    return trans
end

local trans = extracttransFromHTML(response)

if not trans then
    print('Error')
else
    print('translate:', trans)
    
    end