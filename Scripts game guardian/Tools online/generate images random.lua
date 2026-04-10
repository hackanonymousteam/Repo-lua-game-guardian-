--https://picsum.photos/400/300

local chat = gg.prompt({
    'Width imaget',
    'Height image', 
    
}, {}, {'number', 'number'})

if chat == nil then
    return
end

local width = chat[1]
local height = chat[2]
local url = 'https://picsum.photos/' .. width..'/'..height

local request = gg.makeRequest(url)
if request == nil or request.content == nil then
    gg.alert('error.')
    return
end

local audio = request.content
local name = 'Random_image.jpeg'

local path = "/sdcard/"

local file = io.open(path .. name, "wb")
if file then
    file:write(audio)
    file:close()
    gg.alert('image random save in ' .. path .. name)
else
    gg.alert('failed to save image.')
end