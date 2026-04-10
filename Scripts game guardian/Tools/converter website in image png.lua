
local chat = gg.prompt({'link website'}, {}, {'text'})

if chat == nil then
    return
end

local name = chat[1]

name = name:gsub("https?://", "")

local url = 'https://api.microlink.io/?url=https%3A%2F%2F' .. name .. '&overlay.browser=dark&overlay.background=%23c1c1c1&screenshot=true&embed=screenshot.url'

local request = gg.makeRequest(url)
if request == nil or request.content == nil then
    gg.alert('error.')
    return
end

local graf = request.content
local namer = 'website.png'

local path = "/sdcard/"

local file = io.open(path .. namer, "wb")
if file then
    file:write(graf)
    file:close()
    gg.alert('PNG  website save in  ' .. path .. namer)
else
    gg.alert('failed.')
end