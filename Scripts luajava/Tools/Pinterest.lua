gg.setVisible(true)

local json = nil
if not pcall(function()
    json = load(gg.makeRequest("https://raw.githubusercontent.com/rxi/json.lua/master/json.lua").content)()
end) then
    json = require("json") or gg.alert("JSON library error")
    if not json then return end
end

function urlencode(str)
    if str then
        str = string.gsub(str, "\n", "\r\n")
        str = string.gsub(str, "([^%w %-%_%.%~])",
            function(c) return string.format("%%%02X", string.byte(c)) end)
        str = string.gsub(str, " ", "%%20")
    end
    return str
end

function downloadImage(url)
    local headers = {
        ["User-Agent"] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36",
        ["Accept"] = "image/webp,image/apng,image/*,*/*;q=0.8",
        ["Accept-Language"] = "en-US,en;q=0.9",
        ["Referer"] = "https://www.pinterest.com/"
    }
    
    local response = gg.makeRequest(url, headers, nil, "GET")
    
    if response and response.code == 200 and response.content then
        return response.content
    end
    return nil
end

function saveImageToFile(imageData, filename)
    local file = io.open(filename, "wb")
    if file then
        file:write(imageData)
        file:close()
        return true
    end
    return false
end

function searchPinterest(query)
    local url = "https://id.pinterest.com/search/pins/?autologin=true&q=" .. urlencode(query)
    
    local headers = {
        ["cookie"] = '_auth=1; _b="AVna7S1p7l1C5I9u0+nR3YzijpvXOPc6d09SyCzO+DcwpersQH36SmGiYfymBKhZcGg="; _pinterest_sess=TWc9PSZHamJOZ0JobUFiSEpSN3Z4a2NsMk9wZ3gxL1NSc2k2NkFLaUw5bVY5cXR5alZHR0gxY2h2MVZDZlNQalNpUUJFRVR5L3NlYy9JZkthekp3bHo5bXFuaFZzVHJFMnkrR3lTbm56U3YvQXBBTW96VUgzVUhuK1Z4VURGKzczUi9hNHdDeTJ5Y2pBTmxhc2owZ2hkSGlDemtUSnYvVXh5dDNkaDN3TjZCTk8ycTdHRHVsOFg2b2NQWCtpOWxqeDNjNkk3cS85MkhhSklSb0hwTnZvZVFyZmJEUllwbG9UVnpCYVNTRzZxOXNJcmduOVc4aURtM3NtRFo3STlmWjJvSjlWTU5ITzg0VUg1NGhOTEZzME9SNFNhVWJRWjRJK3pGMFA4Q3UvcHBnWHdaYXZpa2FUNkx6Z3RNQjEzTFJEOHZoaHRvazc1c1UrYlRuUmdKcDg3ZEY4cjNtZlBLRTRBZjNYK0lPTXZJTzQ5dU8ybDdVS015bWJKT0tjTWYyRlBzclpiamdsNmtpeUZnRjlwVGJXUmdOMXdTUkFHRWloVjBMR0JlTE5YcmhxVHdoNzFHbDZ0YmFHZ1VLQXU1QnpkM1FqUTNMTnhYb3VKeDVGbnhNSkdkNXFSMXQybjRGL3pyZXRLR0ZTc0xHZ0JvbTJCNnAzQzE0cW1WTndIK0trY05HV1gxS09NRktadnFCSDR2YzBoWmRiUGZiWXFQNjcwWmZhaDZQRm1UbzNxc21pV1p5WDlabm1UWGQzanc1SGlrZXB1bDVDWXQvUis3elN2SVFDbm1DSVE5Z0d4YW1sa2hsSkZJb1h0MTFpck5BdDR0d0lZOW1Pa2RDVzNySWpXWmUwOUFhQmFSVUpaOFQ3WlhOQldNMkExeDIvMjZHeXdnNjdMYWdiQUhUSEFBUlhUVTdBMThRRmh1ekJMYWZ2YTJkNlg0cmFCdnU2WEpwcXlPOVZYcGNhNkZDd051S3lGZmo0eHV0ZE42NW8xRm5aRWpoQnNKNnNlSGFad1MzOHNkdWtER0xQTFN5Z3lmRERsZnZWWE5CZEJneVRlMDd2VmNPMjloK0g5eCswZUVJTS9CRkFweHc5RUh6K1JocGN6clc1JmZtL3JhRE1sc0NMTFlpMVErRGtPcllvTGdldz0=; _ir=0'
    }
    
    gg.toast("🔍 Searching Pinterest...")
    
    local response = gg.makeRequest(url, headers, nil, "GET")
    
    if response and response.code == 200 then
        local images = {}
        for link in response.content:gmatch('<img[^>]+src="([^"]+)"[^>]*>') do
            if link:find("236x") then
                local hdLink = link:gsub("236x", "736x")
                table.insert(images, hdLink)
                if #images >= 10 then break end
            end
        end
        return images
    end
    return nil, "Failed to connect to Pinterest"
end

function showPinterestGallery(images, query)
    if not images or #images == 0 then
        gg.alert("No images found for '" .. query .. "'")
        return
    end
    
    local menuItems = {}
    
    for i = 1, #images do
        table.insert(menuItems, "📷 Image " .. i)
    end
    
    table.insert(menuItems, "🔍 New Search")
    table.insert(menuItems, "◀️ Main Menu")
    
    while true do
        local choice = gg.choice(menuItems, nil, "📸 PINTEREST: " .. query .. " (" .. #images .. " images)")
        
        if not choice then break end
        
        if choice == #menuItems - 1 then
            return "new"
        elseif choice == #menuItems then
            break
        elseif choice >= 1 and choice <= #images then
            local imgUrl = images[choice]
            
            local imgMenu = {
                "💾 Download Image",
                "📋 Copy Image URL",
                "◀️ Back to Gallery"
            }
            
            local imgChoice = gg.choice(imgMenu, nil, "📷 Image " .. choice)
            
            if imgChoice == 1 then
                gg.toast("⬇️ Downloading image...")
                local imageData = downloadImage(imgUrl)
                
                if imageData then
                    local filename = "/sdcard/Pinterest_" .. os.time() .. ".jpg"
                    local success = saveImageToFile(imageData, filename)
                    
                    if success then
                        gg.alert("✅ Image saved!\n\nLocation: " .. filename)
                    else
                        gg.alert("❌ Failed to save image\n\nTrying copy URL instead...")
                        if gg.copyText then
                            gg.copyText(imgUrl)
                            gg.toast("📋 URL copied!")
                        end
                    end
                else
                    gg.alert("❌ Failed to download image")
                end
                
            elseif imgChoice == 2 then
                if gg.copyText then
                    gg.copyText(imgUrl)
                    gg.toast("📋 Image URL copied!")
                end
            end
        end
    end
    
    return nil
end

local function mainInterface()
    gg.alert("📸 PINTEREST DOWNLOADER\n\n• Search any topic\n• View up to 10 images\n• Download images\n• Copy image URLs")
    
    while true do
        local choice = gg.choice({
            "🔍 New Pinterest Search",
            "ℹ️ How to Use",
            "❌ Exit"
        }, nil, "📸 MAIN MENU")
        
        if choice == 1 then
            local input = gg.prompt({
                "Search Pinterest for:"
            }, {""}, {"text"})
            
            if input and input[1] and input[1]:trim() ~= "" then
                local query = input[1]:trim()
                local images, error = searchPinterest(query)
                
                if error then
                    gg.alert("❌ Error: " .. error)
                elseif images then
                    local action = showPinterestGallery(images, query)
                    if action == "new" then
                    end
                end
            end
            
        elseif choice == 2 then
            local help = [[📖 HOW TO USE:

1. Enter a search term
2. Browse through images (max 10)
3. Click any image to:
   • Download it (saves to /sdcard/)
   • Copy image URL

💡 TIPS:
• Use specific keywords
• HD images (736px)
• Files saved as Pinterest_time.jpg]]
            
            gg.alert(help)
            
        elseif choice == 3 then
            gg.toast("👋 Goodbye!")
            break
        end
    end
end

gg.toast("📸 Loading Pinterest Downloader...")
mainInterface()