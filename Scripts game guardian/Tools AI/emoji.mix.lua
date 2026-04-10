gg.setVisible(true)

local json = load(gg.makeRequest("https://raw.githubusercontent.com/rxi/json.lua/master/json.lua").content)()

local emojis = {
    "😀", "😂", "😍", "🥰", "😎", "😭", "😡", "🥳",
    "😱", "🤔", "🙄", "😴", "💀", "👻", "🤖", "🐱",
    "🐶", "🐼", "🦊", "🐸", "🐨", "🦁", "🐮", "🐷"
}

function URLencode(str)
    if str then
        str = string.gsub(str, "\n", "\r\n")
        str = string.gsub(str, "([^%w %-%_%.%~])",
            function(c) return string.format("%%%02X", string.byte(c)) end)
        str = string.gsub(str, " ", "+")
    end
    return str
end

function emojimix(emoji1, emoji2)
    local url = string.format(
        "https://tenor.googleapis.com/v2/featured?key=AIzaSyAyimkuYQYF_FXVALexPuGQctUWRURdCYQ&contentfilter=high&media_filter=png_transparent&component=proactive&collection=emoji_kitchen_v5&q=%s_%s",
        URLencode(emoji1),
        URLencode(emoji2)
    )

    gg.toast("🔄 mixing emojis...")
    
    local response = gg.makeRequest(url, {accept = "application/json"}, nil, "GET")
    
    if not response or response.code ~= 200 then
        gg.alert("❌ API error: " .. tostring(response and response.code or "no response"))
        return false
    end
    
    local ok, data = pcall(json.decode, response.content)
    if not ok or not data or not data.results or not data.results[1] then
        gg.alert("❌ error: could not find combination.")
        return false
    end
    
    local imageUrl = data.results[1].url
    if not imageUrl then
        gg.alert("❌ error: image URL not found.")
        return false
    end
    
    gg.toast("📥 downloading image...")
    
    local imageResponse = gg.makeRequest(imageUrl, {}, nil, "GET")
    if not imageResponse or imageResponse.code ~= 200 or not imageResponse.content then
        gg.alert("❌ error downloading image.")
        return false
    end
    
    local filename = os.date("emojimix_%Y%m%d_%H%M%S.png")
    local file = io.open(filename, "wb")
    if file then
        file:write(imageResponse.content)
        file:close()
        
        local msg = string.format([[
✅ emojis mixed successfully!

🤝 combination: %s + %s
💾 file saved: %s

📍 image is in current folder this script.
]], emoji1, emoji2, filename)
        
        gg.alert(msg)
        
        if gg.copyText and gg.alert("📋 copy filename?", "yes", "no") == 1 then
            gg.copyText(filename)
            gg.toast("✅ copied!")
        end
        
        return true
    else
        gg.alert("❌ error saving file.")
        return false
    end
end

while true do
    local menu = gg.choice({
        "🎨 mix emojis",
        "📖 about",
        "❌ exit"
    }, nil, "🤖 EmojiMix - FlowFalcon")
    
    if menu == 1 then
        local choice1 = gg.choice(emojis, nil, "choose FIRST emoji:")
        if not choice1 then break end
        local emoji1 = emojis[choice1]
        
        local choice2 = gg.choice(emojis, nil, "choose SECOND emoji:")
        if not choice2 then break end
        local emoji2 = emojis[choice2]
        
        local confirm = gg.alert(
            string.format("🤝 combine: %s + %s ?", emoji1, emoji2),
            "yes",
            "no"
        )
        
        if confirm == 1 then
            emojimix(emoji1, emoji2)
        end
        
    elseif menu == 2 then
        gg.alert([[
🎨 EmojiMix v1.0

🤔 how it works:
1. choose two emojis
2. Google Tenor API combines them
3. generates a unique PNG image

📱 based on Google Tenor API
🎯 use your creativity!


        ]])
        
    elseif menu == 3 or not menu then
        gg.alert("👋 goodbye!")
        break
    end
end