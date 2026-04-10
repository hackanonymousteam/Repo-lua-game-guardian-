gg.setVisible(true)

local NEKOS_API_URL = "https://nekos.best/api/v2/neko"

local json = nil
if not pcall(function()
    json = load(gg.makeRequest("https://raw.githubusercontent.com/rxi/json.lua/master/json.lua").content)()
end) then
    json = require("json")
    if not json then 
        gg.alert("JSON library not available")
        return 
    end
end

local function getNekoImage()
 --   gg.toast("🔄 Getting neko image...")
    local response = gg.makeRequest(NEKOS_API_URL)
    
    if response and response.code == 200 and response.content then
        local success, data = pcall(json.decode, response.content)
        
        if success and data.results and #data.results > 0 then
            local imageUrl = data.results[1].url
            local artist = data.results[1].artist_name or "Unknown"
            
            return imageUrl, artist, true
        else
            return nil, "Failed to parse API response", false
        end
    else
        return nil, "Request failed: " .. (response.code or "unknown"), false
    end
end

local function downloadImage(imageUrl)
    if not imageUrl then return nil, "No image URL" end
    
    gg.toast("📥 Downloading image...")
    
    local response = gg.makeRequest(imageUrl)
    
    if response and response.code == 200 and response.content then

        local fileName = "/sdcard/Download/neko_" .. os.time() .. ".png"
        
       local imager = fileName
       
        local file = io.open(fileName, "wb")
        if file then
            file:write(response.content)
            file:close()
            return fileName, true
        else
            return nil, "Failed to save file"
        end
    else
        return nil, "Download failed: " .. (response.code or "unknown")
    end
end

local function showImageInfo(imageUrl, artist, filePath)
    local info = "🎨 Artist: " .. artist .. "\n"
    info = info .. "📁 Saved: " .. filePath .. "\n"
    info = info .. "🔗 URL: " .. imageUrl .. "\n\n"
    info = info .. "Image successfully downloaded!"
    
    gg.alert(info)
end

local function getAndSaveNeko()
    gg.alert("🐾 Nekos.best Image Downloader\n\nDownload random anime neko images!")
    
    local imageUrl, artist, success = getNekoImage()
    
    if success then
        gg.toast("🖼️ Image found, downloading...")
        
        local filePath, downloadSuccess = downloadImage(imageUrl)
        
        if downloadSuccess then
            showImageInfo(imageUrl, artist, filePath)
            
            local choice = gg.choice({
                "🔄 Get Another Image",
                "📱 View Image",
                "❌ Exit"
            }, nil, "Download Complete! What next?")
            
            if choice == 1 then
                getAndSaveNeko()
            elseif choice == 2 then
image(imageUrl)
--image(imager)

            end
        else
            gg.alert("❌ Download failed:\n" .. filePath)
        end
    else
        gg.alert("❌ Failed to get image:\n" .. artist)
    end
end

local function quickDownload()
    gg.toast("🐾 Getting random neko...")
    
    local imageUrl, artist, success = getNekoImage()
    
    if success then
        local filePath, downloadSuccess = downloadImage(imageUrl)
        if downloadSuccess then
            gg.alert("✅ Quick Download Complete!\n\nArtist: " .. artist .. "\nSaved: " .. filePath)
        else
            gg.alert("❌ Download failed")
        end
    else
        gg.alert("❌ Failed to get image")
    end
end

local function mainMenu()
    while true do
        local choice = gg.choice({
            "🐾 Get Random Neko Image",
         --   "📥 Download Multiple Images", 
         --   "⚡ Quick Download",
            "ℹ️ About",
            "❌ Exit"
        }, nil, "🐾 Nekos.best Image Downloader\n\nDownload anime neko images!")
        
        if choice == 1 then
            getAndSaveNeko()
        elseif choice == 2 then
       
            gg.alert([[
🐾 Nekos.best Image Downloader

Features:
• Download random anime neko images
• High quality PNG files
• Artist credit information
• Automatic save to Downloads folder
• Multiple download options

API: nekos.best
File location: /sdcard/Download/
            ]])
        elseif choice == 5 or choice == nil then
            gg.alert("👋 Goodbye!")
os.exit()
elseif choice == 3 then
os.exit()
         
        end
    end
end

gg.alert("🐾 Welcome to Nekos.best Downloader!\n\nDownload cute anime neko images!")
mainMenu()