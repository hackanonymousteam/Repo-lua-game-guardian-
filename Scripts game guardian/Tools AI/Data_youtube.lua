gg.setVisible(true)

local TRANSCRIPT_API_URL = "https://api.supadata.ai/v1/youtube/video"
local SUPADATA_API_KEY = "your-api-key-here"  -- Substitua pela chave real

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

local function extractVideoId(url)
    if url:match("youtu.be/([%w-_]+)") then
        return url:match("youtu.be/([%w-_]+)")
    elseif url:match("youtube.com/watch%?v=([%w-_]+)") then
        return url:match("youtube.com/watch%?v=([%w-_]+)")
    elseif url:match("youtube.com/embed/([%w-_]+)") then
        return url:match("youtube.com/embed/([%w-_]+)")
    end
    return nil
end

local function getYouTubeVideoInfo(videoId)
    gg.toast("Getting video info...")
    
    local apiUrl = TRANSCRIPT_API_URL .. "?id=" .. videoId
    
    local headers = {
        ["x-api-key"] = SUPADATA_API_KEY,
        ["Content-Type"] = "application/json",
        ["User-Agent"] = "Mozilla/5.0 (Linux; Android 13; Mobile) AppleWebKit/537.36 Safari/537.36"
    }
    
    local response = gg.makeRequest(apiUrl, headers)
    
    if type(response) == "table" and response.code == 200 then
        local success, data = pcall(json.decode, response.content)
        if success and data then
            return data, true, response.content
        else
            return "Invalid JSON response: " .. response.content, false, response.content
        end
    else
        local errorMsg = "API Error: " .. (response.code or "unknown")
        if response.content then
            errorMsg = errorMsg .. " - " .. response.content
        end
        return errorMsg, false, response.content
    end
end

local function saveToFile(content, fileName)
    local path = "/sdcard/Download/" .. fileName
    
    local file = io.open(path, "w")
    if file then
        file:write(content)
        file:close()
        return path, true
    else
        return "Failed to save file", false
    end
end

local function formatVideoInfo(data, rawJson, videoId)
    local formatted = "YouTube Video Information\n"
    formatted = formatted .. "=" .. string.rep("=", 50) .. "\n\n"
    
    formatted = formatted .. "📊 BASIC INFORMATION:\n"
    formatted = formatted .. "Video ID: " .. (data.id or videoId) .. "\n"
    formatted = formatted .. "Title: " .. (data.title or "N/A") .. "\n"
    formatted = formatted .. "Duration: " .. (data.duration or "N/A") .. " seconds\n"
    formatted = formatted .. "Upload Date: " .. (data.uploadDate or "N/A") .. "\n"
    formatted = formatted .. "Views: " .. (data.viewCount or "N/A") .. "\n"
    formatted = formatted .. "Likes: " .. (data.likeCount or "N/A") .. "\n\n"
    
    if data.channel then
        formatted = formatted .. "📺 CHANNEL INFORMATION:\n"
        formatted = formatted .. "Channel ID: " .. (data.channel.id or "N/A") .. "\n"
        formatted = formatted .. "Channel Name: " .. (data.channel.name or "N/A") .. "\n\n"
    end
    
    formatted = formatted .. "📝 DESCRIPTION:\n"
    formatted = formatted .. (data.description or "N/A") .. "\n\n"
    
    if data.tags and #data.tags > 0 then
        formatted = formatted .. "🏷️ TAGS:\n"
        for i, tag in ipairs(data.tags) do
            formatted = formatted .. "- " .. tag .. "\n"
        end
        formatted = formatted .. "\n"
    end
    
    if data.thumbnail then
        formatted = formatted .. "🖼️ THUMBNAIL URL:\n"
        formatted = formatted .. data.thumbnail .. "\n\n"
    end
    
    if data.transcriptLanguages and #data.transcriptLanguages > 0 then
        formatted = formatted .. "🗣️ TRANSCRIPT LANGUAGES AVAILABLE:\n"
        for i, lang in ipairs(data.transcriptLanguages) do
            formatted = formatted .. "- " .. lang .. "\n"
        end
        formatted = formatted .. "\n"
    end
    
    formatted = formatted .. "📄 RAW JSON RESPONSE:\n"
    formatted = formatted .. "=" .. string.rep("=", 50) .. "\n"
    formatted = formatted .. rawJson .. "\n\n"
    
    formatted = formatted .. "=" .. string.rep("=", 50) .. "\n"
    formatted = formatted .. "Generated: " .. os.date("%Y-%m-%d %H:%M:%S") .. "\n"
    
    return formatted
end

local function displayVideoInfo(data, rawJson, videoId)
    local displayText = "🎬 YOUTUBE VIDEO INFORMATION\n\n"
    
    displayText = displayText .. "📺 Title: " .. (data.title or "N/A") .. "\n"
    displayText = displayText .. "🆔 Video ID: " .. (data.id or videoId) .. "\n"
    displayText = displayText .. "⏱️ Duration: " .. (data.duration or "N/A") .. " seconds\n"
    displayText = displayText .. "👀 Views: " .. (data.viewCount or "N/A") .. "\n"
    displayText = displayText .. "👍 Likes: " .. (data.likeCount or "N/A") .. "\n"
    displayText = displayText .. "📅 Uploaded: " .. (data.uploadDate or "N/A") .. "\n\n"
    
    if data.channel then
        displayText = displayText .. "📢 Channel: " .. (data.channel.name or "N/A") .. "\n\n"
    end
    
    -- Mostrar parte da descrição (primeiras 3 linhas)
    if data.description then
        local descLines = {}
        for line in data.description:gmatch("[^\r\n]+") do
            table.insert(descLines, line)
        end
        displayText = displayText .. "📝 Description Preview:\n"
        for i = 1, math.min(3, #descLines) do
            if #descLines[i] > 100 then
                displayText = displayText .. "- " .. descLines[i]:sub(1, 100) .. "...\n"
            else
                displayText = displayText .. "- " .. descLines[i] .. "\n"
            end
        end
        if #descLines > 3 then
            displayText = displayText .. "- ... and " .. (#descLines - 3) .. " more lines\n"
        end
    end
    
    displayText = displayText .. "\n✅ Response received successfully!"
    displayText = displayText .. "\n📏 Raw JSON size: " .. #rawJson .. " characters"
    
    return displayText
end

local function quickVideoInfo()
    local urlInput = gg.prompt({
        'Enter YouTube URL:'
    }, {'https://www.youtube.com/watch?v=sbZN_lrLMlk'}, {'text'})
    
    if urlInput and urlInput[1] and urlInput[1] ~= "" then
        local videoId = extractVideoId(urlInput[1])
        if not videoId then
            gg.alert("❌ Invalid YouTube URL\n\nPlease enter a valid YouTube URL")
            return
        end
        
        gg.alert("📡 Fetching Video Information...\n\nVideo ID: " .. videoId .. "\n\nPlease wait...")
        
        local data, success, rawJson = getYouTubeVideoInfo(videoId)
        
        if success then
            local displayText = displayVideoInfo(data, rawJson, videoId)
            
            local choice = gg.choice(
                {"💾 Save Full Info to File", "📋 Show Raw JSON", "🔄 New Search", "❌ Cancel"},
                nil,
                displayText
            )
            
            if choice == 1 then
                local fileName = "youtube_info_" .. videoId .. "_" .. os.time() .. ".txt"
                local formattedContent = formatVideoInfo(data, rawJson, videoId)
                local filePath, saveSuccess = saveToFile(formattedContent, fileName)
                
                if saveSuccess then
                    gg.alert("✅ Information Saved!\n\n📁 File: " .. fileName .. "\n📍 Path: " .. filePath .. "\n\n📊 Contains:\n• Video metadata\n• Description\n• Channel info\n• Raw JSON response")
                else
                    gg.alert("❌ Save Failed: " .. filePath)
                end
            elseif choice == 2 then
                -- Mostrar JSON completo
                local jsonDisplay = "RAW JSON RESPONSE (" .. #rawJson .. " characters):\n\n" .. rawJson
                
                local jsonChoice = gg.choice(
                    {"💾 Save to File", "⬅️ Back"},
                    nil,
                    jsonDisplay
                )
                
                if jsonChoice == 1 then
                    local fileName = "youtube_raw_json_" .. videoId .. "_" .. os.time() .. ".json"
                    local filePath, saveSuccess = saveToFile(rawJson, fileName)
                    
                    if saveSuccess then
                        gg.alert("✅ Raw JSON Saved!\n\n📁 File: " .. fileName .. "\n📍 Path: " .. filePath)
                    else
                        gg.alert("❌ Save Failed: " .. filePath)
                    end
                end
            elseif choice == 3 then
                quickVideoInfo()
            end
        else
            gg.alert("❌ Failed to get video information:\n" .. data .. "\n\nRaw response:\n" .. (rawJson or "No response"))
        end
    end
end

local function batchVideoInfo()
    local urlsInput = gg.prompt({
        'Enter YouTube URLs (one per line):'
    }, {'https://www.youtube.com/watch?v=sbZN_lrLMlk\nhttps://www.youtube.com/watch?v=ANOTHER_ID'}, {'text'})
    
    if urlsInput and urlsInput[1] and urlsInput[1] ~= "" then
        local videos = {}
        for url in urlsInput[1]:gmatch("[^\r\n]+") do
            local videoId = extractVideoId(url)
            if videoId then
                table.insert(videos, {url = url, id = videoId})
            end
        end
        
        if #videos == 0 then
            gg.alert("❌ No valid YouTube URLs found")
            return
        end
        
        gg.alert("📡 Batch Video Information\n\nVideos to process: " .. #videos .. "\n\nThis may take a while...")
        
        local allData = "BATCH YOUTUBE VIDEO INFORMATION\n"
        allData = allData .. "Generated: " .. os.date("%Y-%m-%d %H:%M:%S") .. "\n"
        allData = allData .. "Total videos: " .. #videos .. "\n\n"
        allData = allData .. string.rep("=", 60) .. "\n\n"
        
        local successCount = 0
        local failedVideos = {}
        
        for i, videoInfo in ipairs(videos) do
            gg.toast("Processing " .. i .. "/" .. #videos .. " - " .. videoInfo.id)
            
            local data, success, rawJson = getYouTubeVideoInfo(videoInfo.id)
            
            if success then
                allData = allData .. "🎬 VIDEO #" .. i .. "\n"
                allData = allData .. "URL: " .. videoInfo.url .. "\n"
                allData = allData .. "Title: " .. (data.title or "N/A") .. "\n"
                allData = allData .. "Duration: " .. (data.duration or "N/A") .. "s\n"
                allData = allData .. "Views: " .. (data.viewCount or "N/A") .. "\n"
                allData = allData .. "Likes: " .. (data.likeCount or "N/A") .. "\n"
                allData = allData .. "Channel: " .. (data.channel and data.channel.name or "N/A") .. "\n"
                allData = allData .. "Description: " .. (data.description and string.sub(data.description, 1, 200) or "N/A") .. "\n"
                allData = allData .. "Raw JSON Size: " .. #rawJson .. " characters\n"
                allData = allData .. string.rep("-", 40) .. "\n\n"
                successCount = successCount + 1
            else
                allData = allData .. "❌ VIDEO #" .. i .. " - FAILED\n"
                allData = allData .. "URL: " .. videoInfo.url .. "\n"
                allData = allData .. "Error: " .. data .. "\n"
                allData = allData .. string.rep("-", 40) .. "\n\n"
                table.insert(failedVideos, {id = videoInfo.id, error = data})
            end
            
            -- Pequeno delay para não sobrecarregar a API
            os.execute("sleep 2")
        end
        
        allData = allData .. string.rep("=", 60) .. "\n"
        allData = allData .. "SUMMARY:\n"
        allData = allData .. "Successful: " .. successCount .. "/" .. #videos .. "\n"
        allData = allData .. "Failed: " .. (#videos - successCount) .. "\n"
        allData = allData .. "Completion time: " .. os.date("%Y-%m-%d %H:%M:%S") .. "\n"
        
        if successCount > 0 then
            local fileName = "batch_youtube_info_" .. os.time() .. ".txt"
            local filePath, saveSuccess = saveToFile(allData, fileName)
            
            if saveSuccess then
                local resultMsg = "✅ Batch Complete!\n\n📊 Results: " .. successCount .. "/" .. #videos .. " successful\n📁 File: " .. fileName .. "\n📍 Path: " .. filePath
                
                if #failedVideos > 0 then
                    resultMsg = resultMsg .. "\n\n❌ Failed videos:"
                    for i, failed in ipairs(failedVideos) do
                        if i <= 3 then
                            resultMsg = resultMsg .. "\n• " .. failed.id .. " - " .. failed.error
                        end
                    end
                end
                
                gg.alert(resultMsg)
            else
                gg.alert("⚠️ Processing complete but save failed:\n" .. filePath)
            end
        else
            gg.alert("❌ All requests failed\n\nNo video information could be retrieved")
        end
    end
end

local function testApiConnection()
    gg.toast("Testing API connection...")
    
    local testVideoId = "sbZN_lrLMlk"
    local testUrl = TRANSCRIPT_API_URL .. "?id=" .. testVideoId
    
    local headers = {
        ["x-api-key"] = SUPADATA_API_KEY,
        ["Content-Type"] = "application/json"
    }
    
    local response = gg.makeRequest(testUrl, headers)
    
    if type(response) == "table" then
        if response.code == 200 then
            return "✅ API is responding", true
        else
            return "❌ API returned code: " .. (response.code or "unknown"), false
        end
    else
        return "❌ Failed to connect to API", false
    end
end

local function setupApiKey()
    local currentKey = SUPADATA_API_KEY
    if currentKey == "your-api-key-here" then
        currentKey = ""
    end
    
    local keyInput = gg.prompt({
        'Enter Supadata API Key:',
        'Get key from: https://supadata.ai'
    }, {currentKey}, {'text'})
    
    if keyInput and keyInput[1] and keyInput[1] ~= "" then
        SUPADATA_API_KEY = keyInput[1]
        gg.alert("✅ API Key updated!\n\nYou can now use the video information features.")
        return true
    else
        gg.alert("❌ API Key is required to use this feature")
        return false
    end
end

local function mainMenu()
    while true do
        local options = {
            "🎬 Get Video Information",
            "📚 Batch Video Info", 
            "🔑 Setup API Key",
            "🔧 Test API Connection",
            "📖 How to Use",
            "❌ Exit"
        }
        
        local choice = gg.choice(options, nil, "YouTube Video Information")
        
        if choice == nil or choice == 6 then
            break
            
        elseif choice == 1 then
            if SUPADATA_API_KEY == "your-api-key-here" then
                if not setupApiKey() then
                    break
                end
            end
            quickVideoInfo()
            
        elseif choice == 2 then
            if SUPADATA_API_KEY == "your-api-key-here" then
                if not setupApiKey() then
                    break
                end
            end
            batchVideoInfo()
            
        elseif choice == 3 then
            setupApiKey()
            
        elseif choice == 4 then
            if SUPADATA_API_KEY == "your-api-key-here" then
                gg.alert("❌ Please set up your API key first")
            else
                local message, success = testApiConnection()
                if success then
                    gg.alert("🌐 API Status: " .. message .. "\n\n✅ API Key: " .. SUPADATA_API_KEY:sub(1, 10) .. "..." .. "\n✅ Endpoint: " .. TRANSCRIPT_API_URL)
                else
                    gg.alert("🌐 API Status: " .. message .. "\n\n❌ Please check your API key and connection")
                end
            end
            
        elseif choice == 5 then
            gg.alert([[
🎯 HOW TO USE YOUTUBE VIDEO INFORMATION:

1. **Setup:**
   - First, set up your API key from Supadata.ai
   - The API key is required for all requests

2. **Get Video Information:**
   - Paste any YouTube video URL
   - Get complete video metadata including:
     • Title, description, duration
     • View count, likes, upload date
     • Channel information
     • Available transcript languages
     • Thumbnail URL and tags
   - Save formatted information or raw JSON

3. **Batch Video Info:**
   - Enter multiple URLs (one per line)
   - Process all videos automatically
   - Combined results in one file

4. **Output Features:**
   - Formatted text files with all metadata
   - Raw JSON responses preserved
   - Error reporting for failed requests
   - Batch processing summaries

🔑 Get API Key: https://supadata.ai
            ]])
        end
    end
end

-- Iniciar a aplicação
if SUPADATA_API_KEY == "your-api-key-here" then
    gg.alert("🔑 YouTube Video Information\n\n⚠️ API Key Required\n\nPlease set up your Supadata.ai API key to continue.")
    if not setupApiKey() then
        return
    end
end

gg.alert("🎬 YouTube Video Information\n\n🔑 Using Supadata.ai API\n📊 Get complete video metadata\n💾 Save formatted information")
mainMenu()