
local apikey = "prince"

local input = gg.prompt({'Enter text for LogoMaker'}, {}, {'text'})
if input == nil then return end
local text = input[1]

local encodedText = text:gsub(" ", "%%20")

local url = "https://api.princetechn.com/api/ephoto360/logomaker?apikey=" .. apikey .. "&text=" .. encodedText

local req = gg.makeRequest(url)
if req == nil or req.content == nil then
    print("Error: No response from API.")
    return
end

local response = req.content
local status = response:match('"status"%s*:%s*(%d+)')
local imageUrl = response:match('"image_url"%s*:%s*"([^"]+)"')

if not status or tonumber(status) ~= 200 or not imageUrl then
    print("Error: Failed to get image.")
    return
end

local actions = {"Open image", "Download Image", "Exit"}
local choice = gg.choice(actions, nil, "Choose an action for the logo")

if choice == 1 then
    image(imageUrl)

elseif choice == 2 then
    local imgReq = gg.makeRequest(imageUrl)
    if imgReq and imgReq.content then
        local filename = "/sdcard/Download/logo_" .. os.time() .. ".jpg"
        local file = io.open(filename, "wb")
        if file then
            file:write(imgReq.content)
            file:close()
            gg.alert("Image saved to:\n" .. filename)
        else
            gg.alert("Error saving image.")
        end
    else
        gg.alert("Error downloading image.")
    end
end