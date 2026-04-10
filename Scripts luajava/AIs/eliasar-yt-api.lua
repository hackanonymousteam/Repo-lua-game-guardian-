gg.setVisible(true)

local API_BASE_URL = "https://eliasar-yt-api.vercel.app/api"

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
local function urlencode(str)
    if str then
        str = string.gsub(str, "\n", "\r\n")
        str = string.gsub(str, "([^%w %-%_%.%~])",
            function(c) return string.format("%%%02X", string.byte(c)) end)
        str = string.gsub(str, " ", "+")
    end
    return str
end

local function makeAPIRequest(endpoint, params)
    local url = API_BASE_URL .. endpoint
    if params then
        url = url .. "?"
        local first = true
        for k, v in pairs(params) do
            if not first then
                url = url .. "&"
            end
            url = url .. k .. "=" .. urlencode(v)
            first = false
        end
    end
    
    gg.toast("🔄 Making request...")
    local response = gg.makeRequest(url)
    
    if response and response.code == 200 and response.content then
        local success, data = pcall(json.decode, response.content)
        if success then
            return data, true
        else
            return "Failed to parse response", false
        end
    else
        return "Request failed: " .. (response.code or "unknown"), false
    end
end


local function downloadAndSaveImage(imageUrl, fileName)
    if not imageUrl then return nil, "No image URL" end
    
    gg.toast("📥 Downloading image...")
    local response = gg.makeRequest(imageUrl)
    
    if response and response.code == 200 and response.content then
        local filePath = "/sdcard/Download/" .. fileName .. "_" .. os.time() .. ".jpg"
        local file = io.open(filePath, "wb")
        if file then
            file:write(response.content)
            file:close()
            return filePath, true
        else
            return nil, "Failed to save file"
        end
    else
        return nil, "Download failed"
    end
end

local function getAnimeImage()
    local data, success = makeAPIRequest("/anime")
    
    if success and data.status and data.image then
        local filePath, downloadSuccess = downloadAndSaveImage(data.image, "anime")
        if downloadSuccess then
            return "✅ Anime image downloaded!\n\nSaved: " .. filePath, true
        else
            return filePath, false
        end
    else
        return "❌ Failed to get anime image", false
    end
end

local function getAnimeCosplay()
    local data, success = makeAPIRequest("/anime-cosplay")
    
    if success and data.status and data.image then
        local filePath, downloadSuccess = downloadAndSaveImage(data.image, "cosplay")
        if downloadSuccess then
            return "✅ Cosplay image downloaded!\n\nSaved: " .. filePath, true
        else
            return filePath, false
        end
    else
        return "❌ Failed to get cosplay image", false
    end
end


local function geminiAI(prompt)
    if not prompt or prompt:trim() == "" then
        return "❌ Please provide a question or text", false
    end
    
    local data, success = makeAPIRequest("/ia/gemini", {prompt = prompt})
    
    if success and data.status and data.content then
        return data.content, true
    else
        return "❌ Failed to get AI response", false
    end
end


local function getRandomMeme()
    local data, success = makeAPIRequest("/random/meme")
    
    if success and data.status == "success" and data.data then
        local filePath, downloadSuccess = downloadAndSaveImage(data.data.image, "meme")
        if downloadSuccess then
            local result = "🖼️ " .. data.data.title .. "\n\n✅ Saved: " .. filePath
            return result, true
        else
            return filePath, false
        end
    else
        return "❌ Failed to get meme", false
    end
end

-- Função para buscar no YouTube
local function youtubeSearch(query)
    if not query or query:trim() == "" then
        return "❌ Please provide search query", false
    end
    
    local data, success = makeAPIRequest("/oficial/youtube", {query = query})
    
    if success and data.status and data.results and #data.results > 0 then
        local result = data.results[1]
        local snippet = result.snippet
        local stats = result.statistics or {}
        
        local info = "🎥 YouTube Search Result:\n\n"
        info = info .. "📺 Title: " .. snippet.title .. "\n"
        info = info .. "📝 Channel: " .. snippet.channelTitle .. "\n"
        info = info .. "📅 Published: " .. (snippet.publishedAt or "N/A") .. "\n"
        info = info .. "👁️ Views: " .. (stats.viewCount or "N/A") .. "\n"
        info = info .. "👍 Likes: " .. (stats.likeCount or "N/A") .. "\n"
        info = info .. "🔗 URL: https://www.youtube.com/watch?v=" .. result.id
        
        return info, true
    else
        return "❌ No results found", false
    end
end


local function getRandomFreeFireCharacter()
    local data, success = makeAPIRequest("/freefire/random")
    
    if success and data.status and data.personaje then
        local char = data.personaje
        local filePath, downloadSuccess = downloadAndSaveImage(char.imagem, "freefire")
        
        if downloadSuccess then
            local info = "🎮 Free Fire Character:\n\n"
            info = info .. "👤 Name: " .. char.nombre .. "\n"
            info = info .. "🛡️ Ability: " .. char.habilidad .. "\n"
            info = info .. "💎 Price: " .. char.precio .. "\n"
            info = info .. "📜 Description: " .. char.descripcion .. "\n\n"
            info = info .. "✅ Saved: " .. filePath
            
            return info, true
        else
            return filePath, false
        end
    else
        return "❌ Failed to get Free Fire character", false
    end
end


local function searchFreeFireCharacter(name)
    if not name or name:trim() == "" then
        return "❌ Please provide character name", false
    end
    
    local data, success = makeAPIRequest("/frefire/personaje", {name = name})
    
    if success and data.status and data.personaje then
        local char = data.personaje
        local filePath, downloadSuccess = downloadAndSaveImage(char.imagem, "ff_" .. name)
        
        if downloadSuccess then
            local info = "🎮 Free Fire Character:\n\n"
            info = info .. "👤 Name: " .. char.nombre .. "\n"
            info = info .. "🛡️ Ability: " .. char.habilidad .. "\n"
            info = info .. "💎 Price: " .. char.precio .. "\n"
            info = info .. "📜 Description: " .. char.descripcion .. "\n\n"
            info = info .. "✅ Saved: " .. filePath
            
            return info, true
        else
            return filePath, false
        end
    else
        return "❌ Character not found", false
    end
end


local function generateLogo(text)
    if not text or text:trim() == "" then
        return "❌ Please provide text for logo", false
    end
    
    local profilePic = "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png"
    local data, success = makeAPIRequest("/canvas/logo", {texto = text, url = profilePic})
    
    if success then
        local filePath, downloadSuccess = downloadAndSaveImage(API_BASE_URL .. "/canvas/logo?texto=" .. urlencode(text) .. "&url=" .. urlencode(profilePic), "logo")
        if downloadSuccess then
            return "✅ Logo generated!\n\nText: " .. text .. "\nSaved: " .. filePath, true
        else
            return filePath, false
        end
    else
        return "❌ Failed to generate logo", false
    end
end


local function mainMenu()
    while true do
        local choice = gg.choice({
            "🇯🇵 Random Anime Image",
            "🎭 Anime Cosplay", 
         --   "🤖 Gemini AI Chat",
            "😂 Random Meme",
          --  "🎥 YouTube Search",
        --    "🎮 Random Free Fire Character",
          --  "🔍 Search Free Fire Character",
        --    "✨ Generate Logo",
         --   "📊 API Status",
            "❌ Exit"
        }, nil, "🎌 API Tools\n\nSelect an option:")
        
        if choice == 1 then
            local result, success = getAnimeImage()
            gg.alert(result)
        elseif choice == 2 then
            local result, success = getAnimeCosplay()
            gg.alert(result)
        
        elseif choice == 3 then
            local result, success = getRandomMeme()
            gg.alert(result)

        elseif choice == 4 then
            os.exit()
        elseif choice == 10 or choice == nil then
            gg.alert("👋 Goodbye!")
            break
        end
    end
end



mainMenu()