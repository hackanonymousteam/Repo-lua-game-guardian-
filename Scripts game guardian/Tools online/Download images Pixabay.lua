local chat = gg.prompt({'Search image'}, {}, {'text'})
if chat == nil then
    return
end

local duck = chat[1]
local request = gg.makeRequest('https://pixabay.com/photos/search/' .. duck)
local response = request.content


local pattern = 'https://cdn.pixabay.com/photo/[^"]+%.jpg'


local urls = {}
for url in response:gmatch(pattern) do
    table.insert(urls, url)
end


for i, url in ipairs(urls) do
   -- print('URL ' .. i .. ': ' .. url)
end 

local answers = {}
for i, url in ipairs(urls) do
    table.insert(answers, 'Image ' .. i)
end
table.insert(answers, 'Exit') 


local choice
repeat
    choice = gg.choice(answers, nil, 'Select image for download')
    if choice == nil then
        return 
    end
until choice ~= nil

if choice == #answers then
    gg.alert('thanks for use my script...')
else
    local selected_url = urls[choice]
    local image_name = 'image_' .. choice .. '.jpg'
    local path = "/sdcard/"
    
    
    gg.alert('Downloading image')
    

    local image_content = gg.makeRequest(selected_url).content
    if image_content == nil then
        gg.alert('Failed to download the image.')
        return
    end
    
    local file = io.open(path .. image_name, "wb")
    if file then
        file:write(image_content)
        file:close()
        gg.alert('Image saved in ' .. path .. image_name)
    else
        gg.alert('Failed to save the image.')
    end
end