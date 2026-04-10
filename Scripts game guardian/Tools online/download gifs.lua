local chat = gg.prompt({'Search gif -----(Enter text in english please)-----'}, {}, {'text'})
if chat == nil then
    return
end

local duck = chat[1]
local request = gg.makeRequest('https://pixabay.com/gifs/search/' .. duck)
local response = request.content


local pattern = 'https://cdn.pixabay.com/animation/[^"]+%.gif'

local urls = {}
for url in response:gmatch(pattern) do
    table.insert(urls, url)
end


for i, url in ipairs(urls) do
   -- print('URL ' .. i .. ': ' .. url)
end 

local answers = {}
for i, url in ipairs(urls) do
    table.insert(answers, 'gif ' .. i)
end
table.insert(answers, 'Exit') 


local choice
repeat
    choice = gg.choice(answers, nil, 'Select gif for download')
    if choice == nil then
        return 
    end
until choice ~= nil

if choice == #answers then
    gg.alert('thanks for use my script...')
else
    local selected_url = urls[choice]
    local gif_name = 'gif_animation' .. choice .. '.gif'
    local path = "/sdcard/Download/"
    
    
    gg.alert('Downloading gif')
    

    local gif_content = gg.makeRequest(selected_url).content
    if gif_content == nil then
        gg.alert('Failed to download the gif.')
        return
    end
    
    local file = io.open(path .. gif_name, "wb")
    if file then
        file:write(gif_content)
        file:close()
        gg.alert('gif saved in ' .. path .. gif_name)
    else
        gg.alert('Failed to save the gif.')
    end
end