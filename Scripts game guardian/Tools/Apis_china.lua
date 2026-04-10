local json = nil
if not pcall(function()
    json = load(gg.makeRequest("https://raw.githubusercontent.com/rxi/json.lua/master/json.lua").content)()
end) then
    json = require("json") or gg.alert("JSON library not available")
    if not json then return end
end

local options = {"Pixiv (image)", "Meinv (video)", "DMPC (png)", "All"}
local choice = gg.choice(options, nil, "Select API")

if choice == nil then return end

local function saveFile(url, filename)
    local req = gg.makeRequest(url)
    if req and req.content then
        local file = io.open("/sdcard/" .. filename, "wb")
        if file then
            file:write(req.content)
            file:close()
            print("Saved: " .. filename)
        else
            print("Error creating: " .. filename)
        end
    else
        print("Error downloading: " .. url)
    end
end

local function getPixiv()
    local pixiv = gg.makeRequest("https://apiv1.yrain.top/pixiv.php")
    if pixiv and pixiv.content then
        local data = json.decode(pixiv.content)
        if data and data.image then
            saveFile(data.image, "pixiv_image.jpg")
        end
    end
end

local function getMeinv()
    local meinv = gg.makeRequest("https://apix.iqfk.top/api/meinv")
    if meinv and meinv.content then
        local data = json.decode(meinv.content)
        if data and data.data then
            saveFile(data.data, "meinv_video.mp4")
        end
    end
end

local function getDmpc()
    local dmpc = gg.makeRequest("https://api.s0o1.com/API/dmpc")
    if dmpc and dmpc.content then
        saveFile("https://api.s0o1.com/API/dmpc", "dmpc_image.png")
    end
end

if choice == 1 then
    getPixiv()
elseif choice == 2 then
    getMeinv()
elseif choice == 3 then
    getDmpc()
elseif choice == 4 then
    getPixiv()
    getMeinv()
    getDmpc()
    print("All APIs processed!")
end

if choice ~= 4 then
    print("Download complete!")
end