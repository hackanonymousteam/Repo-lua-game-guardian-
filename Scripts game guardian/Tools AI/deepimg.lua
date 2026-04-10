gg.setVisible(true)

local json = load(gg.makeRequest("https://raw.githubusercontent.com/rxi/json.lua/master/json.lua").content)()

local styles = {"default", "ghibli", "cyberpunk", "anime", "portrait", "chibi", "pixel art", "oil painting", "3d"}
local stylePrompts = {
    ["default"] = "-style Realism",
    ["ghibli"] = "-style Ghibli Art",
    ["cyberpunk"] = "-style Cyberpunk",
    ["anime"] = "-style Anime",
    ["portrait"] = "-style Portrait",
    ["chibi"] = "-style Chibi",
    ["pixel art"] = "-style Pixel Art",
    ["oil painting"] = "-style Oil Painting",
    ["3d"] = "-style 3D"
}
local sizes = {"1:1 (1024x1024)", "3:2 (1080x720)", "2:3 (720x1080)"}
local sizeMap = {
    ["1:1 (1024x1024)"] = "1024x1024",
    ["3:2 (1080x720)"] = "1080x720",
    ["2:3 (720x1080)"] = "720x1080"
}

local mainMenu = {"🎨 generate image", "📖 about", "❌ exit"}
while true do
    local choice = gg.choice(mainMenu, nil, "🎨 DeepImg AI Generator")
    
    if choice == 1 then
        
        local prompt = gg.prompt({"📝 enter your prompt:"}, {""}, {"text"})
        if not prompt or not prompt[1] or prompt[1] == "" then
            gg.alert("❌ prompt cannot be empty!")
        end
        
        local styleIdx = gg.choice(styles, nil, "🎨 select style:")
        if not styleIdx then end
        local style = styles[styleIdx]
        
        local sizeIdx = gg.choice(sizes, nil, "📏 select size:")
        if not sizeIdx then end
        local size = sizeMap[sizes[sizeIdx]]
        
        gg.toast("⏳ starting generation...")
        
        local device_id = ""
        for i = 1, 32 do
            device_id = device_id .. string.format("%x", math.random(0, 15))
        end
        
        local payload = {
            device_id = device_id,
            prompt = prompt[1] .. " " .. stylePrompts[style],
            size = size,
            n = "1",
            output_format = "png"
        }
        
        local headers = {
            ["content-type"] = "application/json",
            ["origin"] = "https://deepimg.ai",
            ["referer"] = "https://deepimg.ai/"
        }
        
        local res = gg.makeRequest(
            "https://api-preview.apirouter.ai/api/v1/deepimg/flux-1-dev",
            headers,
            json.encode(payload),
            "POST"
        )
        
        if res and res.code == 200 then
            local ok, data = pcall(json.decode, res.content)
            if ok and data and data.data and data.data.images and data.data.images[1] and data.data.images[1].url then
                local imageUrl = data.data.images[1].url
                
                gg.toast("📥 downloading image...")
                
                local imgRes = gg.makeRequest(imageUrl, {}, nil, "GET")
                
                if imgRes and imgRes.code == 200 and imgRes.content then
                    
                    local filename = os.date("deepimg_%Y%m%d_%H%M%S.png")
                    local file = io.open(filename, "wb")
                    if file then
                        file:write(imgRes.content)
                        file:close()
                        
                        local msg = string.format([[
✅ success!

📝 Prompt: %s
🎨 Style: %s
📏 Size: %s
💾 File: %s

📍 saved in current folder this script
]], prompt[1], style, size, filename)
                        
                        gg.alert(msg)
                        
                        if gg.copyText and gg.alert("📋 copy information?", "yes", "no") == 1 then
                            gg.copyText(string.format("Prompt: %s\nStyle: %s\nSize: %s\nFile: %s", 
                                prompt[1], style, size, filename))
                        end
                    else
                        gg.alert("❌ error saving file")
                    end
                else
                    gg.alert("❌ download error!")
                end
            else
                gg.alert("❌ invalid API response!")
            end
        else
            local error = "❌ request failed"
            if res and res.content then
                error = error .. "\n" .. res.content
            end
            gg.alert(error)
        end
        
    elseif choice == 2 then
        gg.alert([[
🎨 DeepImg AI Generator v1.0

📝 generate images using AI

🎭 available styles:
• 3d, anime, ghibli
• cyberpunk, portrait
• chibi, pixel art
• oil painting, default

📏 available sizes:
• 1:1 (1024x1024)
• 3:2 (1080x720)
• 2:3 (720x1080)

💾 images saved as PNG
in current folder this script 
        ]])
        
    elseif choice == 3 or not choice then
        gg.alert("👋 goodbye!")
        break
    end
end