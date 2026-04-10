
function urlEncode(str)
    local url = str:gsub("([^%w])", function(c)
        return string.format("%%%02X", string.byte(c))
    end)
    return url:gsub(" ", "+")  
end

local chat = gg.prompt({'Singer', 'Music'}, {}, {'text', 'text'})
if chat == nil then
    return
end

local singer = chat[1]
local music = chat[2]
local m = "mp3"

--local n = "&type=audio&sort=fileasc"
--local query = singer .. ' ' .. music .. ' ' .. m.. ' '..n

local query = singer .. ' ' .. music .. ' ' .. m

local encoded_query = urlEncode(query)
local request_url = 'https://filepursuit.com/pursuit?q=' .. encoded_query

local request = gg.makeRequest(request_url)

if request == nil or request.content == nil then
    print('Error getting reply.')
    return
end

local content = request.content

local urls = {}
for url in string.gmatch(content, "/file/.-mp3/") do
    table.insert(urls, 'https://filepursuit.com' .. url)
end

table.insert(urls, 'Exit')

local answers = {}
for i, url in ipairs(urls) do
    table.insert(answers, music.. i)
end

local choice
repeat
    choice = gg.choice(answers, nil, 'Select audio page for download')
    if choice == nil then
        return
    end
until choice ~= nil

if choice == #answers then
    gg.alert('failed...')
else
    local selected_url = urls[choice]
    
    local page_request = gg.makeRequest(selected_url)
    if page_request == nil or page_request.content == nil then
        gg.alert('Failed to access the selected page.')
        return
    end
    
    local page_content = page_request.content
    
    
    local sources = {}
    for src in string.gmatch(page_content, '<source%s+src="([^"]+)"%s*/?>') do
        table.insert(sources, src)
    end

    if #sources == 0 then
        gg.alert('erro.')
        return
    end
    
    local audio_url = sources[1]
    local audio_request = gg.makeRequest(audio_url)
    
    if audio_request == nil or audio_request.content == nil then
        gg.alert('Failed to download the mp3.')
        return
    end
    
    local audio_content = audio_request.content
    local audio_name = music .. choice .. '.mp3'
    local path = "/sdcard/"
    
    gg.alert('Downloading audio, please wait...')
    
    local file = io.open(path .. audio_name, "wb")
    if file then
        file:write(audio_content)
        file:close()
        gg.alert('Audio saved in ' .. path .. audio_name)
    else
        gg.alert('Failed to save the mp3.')
    end
end