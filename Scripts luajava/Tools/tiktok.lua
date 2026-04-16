local apikey = "prince"

local input = gg.prompt({'Enter TikTok search query'}, {}, {'text'})
if input == nil then return end
local query = input[1]

local url = "https://api.princetechn.com/api/search/tiktoksearch?apikey=" .. apikey .. "&query=" .. query
local req = gg.makeRequest(url)

if req == nil or req.content == nil then
    print("Error: No response from server.")
    return
end

local response = req.content

local results = {}
for title, cover, nowm, wm, music in response:gmatch('"title"%s*:%s*"([^"]*)".-"cover"%s*:%s*"([^"]+)".-"no_watermark"%s*:%s*"([^"]+)".-"watermark"%s*:%s*"([^"]+)".-"music"%s*:%s*"([^"]+)"') do
    table.insert(results, {
        title = title,
        cover = cover,
        no_watermark = nowm,
        watermark = wm,
        music = music
    })
end

if #results == 0 then
    print("No results found.")
    return
end

--print(results)

local list = {}
for i, r in ipairs(results) do
    local display = r.title
    if display == "" then display = "No title" end
    list[i] = display
end

local choice = gg.choice(list, nil, "Select TikTok Video")
if choice then
    local selected = results[choice]
    
    gg.toast("Playing video (no watermark)...")
    gg.playVideo(selected.no_watermark)
    
  --  print("Playing music...")
  --  gg.playMusic(selected.music)
end