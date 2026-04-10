gg.setVisible(true)

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

local function downloadMedia(videoUrl, mediaType, quality)
    gg.toast("Downloading " .. mediaType .. "...")
    
    local apiUrl = "https://api.dorratz.com/v3/ytdl?url=" .. urlencode(videoUrl)
    
    local response = gg.makeRequest(apiUrl)
    
    if type(response) == "table" and response.code == 200 then
        local success, data = pcall(json.decode, response.content)
        if success and data and data.medias then
            if mediaType == "audio" then
                
                
                local bestQuality = 0
                local bestUrl = nil
                
                for _, media in ipairs(data.medias) do
                    if media.extension == "mp3" then
                        local qualityNum = tonumber(media.quality:match("(%d+)kbps")) or 0
                        if qualityNum > bestQuality then
                            bestQuality = qualityNum
                            bestUrl = media.url
                        end
                    end
                end
                
                
                
                if not bestUrl then
                    for _, media in ipairs(data.medias) do
                        if media.extension == "m4a" or media.extension == "aac" then
                            bestUrl = media.url
                            break
                        end
                    end
                end
                
                if bestUrl then
                    return bestUrl, true
                else
                    return "No audio format available for this video", false
                end
                
            else 
                local bestQuality = 0
                local bestUrl = nil
                
                for _, media in ipairs(data.medias) do
                    if media.extension == "mp4" then
                        local qualityNum = tonumber(media.quality:match("(%d+)p")) or 0
                        if qualityNum > bestQuality then
                            bestQuality = qualityNum
                            bestUrl = media.url
                        end
                    end
                end
                
                
                
                if not bestUrl then
                    for _, media in ipairs(data.medias) do
                        if media.extension == "mp4" then
                            bestUrl = media.url
                            break
                        end
                    end
                end
                
                if bestUrl then
                    return bestUrl, true
                else
                    return "No video format available for this video", false
                end
            end
        else
            return "Invalid response from API", false
        end
    else
        local errorMsg = "API error: "
        if type(response) == "table" then
            errorMsg = errorMsg .. "Code " .. (response.code or "N/A")
        else
            errorMsg = errorMsg .. tostring(response)
        end
        return errorMsg, false
    end
end

local function downloadAndSaveFile(fileUrl, fileName)
    gg.toast("Downloading file...")
    
    local response = gg.makeRequest(fileUrl, {}, "")
    
    if type(response) == "table" and response.code == 200 and response.content then
        local path = "/sdcard/Download/" .. fileName
        
        local file = io.open(path, "wb")
        if file then
            file:write(response.content)
            file:close()
            return path, true
        else
            return "Failed to save file. Check permissions.", false
        end
    else
        return "Failed to download file. Code: " .. (response.code or "unknown"), false
    end
end

local function secondString(seconds)
    seconds = tonumber(seconds) or 0
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local secs = math.floor(seconds % 60)
    
    if hours > 0 then
        return string.format("%d:%02d:%02d", hours, minutes, secs)
    else
        return string.format("%d:%02d", minutes, secs)
    end
end

local function testAPI()
    gg.toast("Testing Dorratz API...")
    
    local testUrl = "https://www.youtube.com/watch?v=dQw4w9WgXcQ"
    local apiUrl = "https://api.dorratz.com/v3/ytdl?url=" .. urlencode(testUrl)
    
    local response = gg.makeRequest(apiUrl)
    
    if type(response) == "table" and response.code == 200 then
        local success, data = pcall(json.decode, response.content)
        if success and data and data.medias then
            return true, #data.medias .. " media formats available"
        else
            return false, "Invalid API response"
        end
    else
        return false, "API connection failed: " .. (response.code or "unknown")
    end
end

local function getAvailableQualities(videoUrl)
    local apiUrl = "https://api.dorratz.com/v3/ytdl?url=" .. urlencode(videoUrl)
    local response = gg.makeRequest(apiUrl)
    
    if type(response) == "table" and response.code == 200 then
        local success, data = pcall(json.decode, response.content)
        if success and data and data.medias then
            local audioQualities = {}
            local videoQualities = {}
            
            for _, media in ipairs(data.medias) do
                if media.extension == "mp3" or media.extension == "m4a" then
                    table.insert(audioQualities, media.quality)
                elseif media.extension == "mp4" then
                    table.insert(videoQualities, media.quality)
                end
            end
            
            return audioQualities, videoQualities
        end
    end
    return {}, {}
end

local function youtubeDownloaderMenu()
    while true do
        local options = {
            "Download Audio (MP3)",
            "Download Video (MP4)", 
            "Enter YouTube URL",
            "Test API",
            "Back to Main Menu"
        }
        
        local choice = gg.choice(options, nil, "YouTube Downloader - Dorratz API")
        
        if choice == nil or choice == 5 then
            break
            
        elseif choice == 1 then
            local searchInput = gg.prompt({
                'Enter YouTube URL:'
            }, {'https://www.youtube.com/watch?v=dQw4w9WgXcQ'}, {'text'})
            
            if searchInput and searchInput[1] and searchInput[1] ~= "" then
                local videoUrl = searchInput[1]
                local videoId = extractVideoId(videoUrl)
                
                if videoId then
                    gg.alert("🎵 Downloading Audio...\n\nVideo ID: " .. videoId .. "\n\nUsing Dorratz API")
                    
                    local mediaUrl, success = downloadMedia(videoUrl, "audio", "best")
                    
                    if success then
                        local fileName = "yt_audio_" .. videoId .. "_" .. os.time() .. ".mp3"
                        local filePath, saveSuccess = downloadAndSaveFile(mediaUrl, fileName)
                        
                        if saveSuccess then
                            gg.alert("✅ Audio Downloaded!\n\n📁 Saved as: " .. fileName .. "\n📍 Path: " .. filePath)
                        else
                            gg.alert("❌ Download failed: " .. filePath)
                        end
                    else
                        gg.alert("❌ Error: " .. mediaUrl)
                    end
                else
                    gg.alert("❌ Invalid YouTube URL")
                end
            end
            
        elseif choice == 2 then
            local searchInput = gg.prompt({
                'Enter YouTube URL:'
            }, {'https://www.youtube.com/watch?v=dQw4w9WgXcQ'}, {'text'})
            
            if searchInput and searchInput[1] and searchInput[1] ~= "" then
                local videoUrl = searchInput[1]
                local videoId = extractVideoId(videoUrl)
                
                if videoId then
                    gg.alert("🎬 Downloading Video...\n\nVideo ID: " .. videoId .. "\n\nUsing Dorratz API")
                    
                    local mediaUrl, success = downloadMedia(videoUrl, "video", "best")
                    
                    if success then
                        local fileName = "yt_video_" .. videoId .. "_" .. os.time() .. ".mp4"
                        local filePath, saveSuccess = downloadAndSaveFile(mediaUrl, fileName)
                        
                        if saveSuccess then
                            gg.alert("✅ Video Downloaded!\n\n📁 Saved as: " .. fileName .. "\n📍 Path: " .. filePath)
                        else
                            gg.alert("❌ Download failed: " .. filePath)
                        end
                    else
                        gg.alert("❌ Error: " .. mediaUrl)
                    end
                else
                    gg.alert("❌ Invalid YouTube URL")
                end
            end
            
        elseif choice == 3 then
            local urlInput = gg.prompt({
                'Enter full YouTube URL:'
            }, {'https://www.youtube.com/watch?v=dQw4w9WgXcQ'}, {'text'})
            
            if urlInput and urlInput[1] and urlInput[1] ~= "" then
                local videoId = extractVideoId(urlInput[1])
                if videoId then
                    
                    local audioQualities, videoQualities = getAvailableQualities(urlInput[1])
                    
                    local qualityInfo = "Video ID: " .. videoId .. "\n\n"
                    
                    if #audioQualities > 0 then
                        qualityInfo = qualityInfo .. "🎵 Audio Qualities:\n"
                        for _, qual in ipairs(audioQualities) do
                            qualityInfo = qualityInfo .. "• " .. qual .. "\n"
                        end
                        qualityInfo = qualityInfo .. "\n"
                    end
                    
                    if #videoQualities > 0 then
                        qualityInfo = qualityInfo .. "🎬 Video Qualities:\n"
                        for _, qual in ipairs(videoQualities) do
                            qualityInfo = qualityInfo .. "• " .. qual .. "\n"
                        end
                    end
                    
                    gg.alert("📊 Available Qualities:\n\n" .. qualityInfo)
                    
                    local downloadChoice = gg.choice({"Download MP3 (Best Quality)", "Download MP4 (Best Quality)", "Cancel"}, nil, "Download Options")
                    
                    if downloadChoice == 1 then
                        local mediaUrl, success = downloadMedia(urlInput[1], "audio", "best")
                        if success then
                            local fileName = "audio_" .. videoId .. ".mp3"
                            local filePath, saveSuccess = downloadAndSaveFile(mediaUrl, fileName)
                            if saveSuccess then
                                gg.alert("✅ Audio Downloaded!\n\nFile: " .. fileName .. "\nPath: " .. filePath)
                            else
                                gg.alert("❌ Save failed: " .. filePath)
                            end
                        else
                            gg.alert("❌ Download failed: " .. mediaUrl)
                        end
                    elseif downloadChoice == 2 then
                        local mediaUrl, success = downloadMedia(urlInput[1], "video", "best")
                        if success then
                            local fileName = "video_" .. videoId .. ".mp4"
                            local filePath, saveSuccess = downloadAndSaveFile(mediaUrl, fileName)
                            if saveSuccess then
                                gg.alert("✅ Video Downloaded!\n\nFile: " .. fileName .. "\nPath: " .. filePath)
                            else
                                gg.alert("❌ Save failed: " .. filePath)
                            end
                        else
                            gg.alert("❌ Download failed: " .. mediaUrl)
                        end
                    end
                else
                    gg.alert("❌ Invalid YouTube URL")
                end
            end
            
        elseif choice == 4 then
            local apiWorking, apiMessage = testAPI()
            if apiWorking then
                gg.alert("✅ Dorratz API Status: WORKING\n\n" .. apiMessage .. "\n\nAPI is ready to use!")
            else
                gg.alert("❌ Dorratz API Status: FAILED\n\n" .. apiMessage .. "\n\nPlease check your connection.")
            end
        end
    end
end

local function mainMenu()
    while true do
        local options = {
            "YouTube Downloader",
            "API Status", 
            "How to Use",
            "Exit"
        }
        
        local choice = gg.choice(options, nil, "Media Downloader - Dorratz API")
        
        if choice == nil or choice == 4 then
            break
            
        elseif choice == 1 then
            youtubeDownloaderMenu()
            
        elseif choice == 2 then
            local apiWorking, apiMessage = testAPI()
            local statusText = "🔧 Dorratz API Status:\n\n"
            if apiWorking then
                statusText = statusText .. "✅ WORKING\n\n" .. apiMessage
            else
                statusText = statusText .. "❌ FAILED\n\n" .. apiMessage
            end
            gg.alert(statusText)
            
        elseif choice == 3 then
            gg.alert([[
🎯 HOW TO USE DORRATZ DOWNLOADER:

1. **Download Audio/Video:**
   - Enter full YouTube URL
   - Choose MP3 (audio) or MP4 (video)
   - Automatically selects best quality
   - File saves to /sdcard/Download/

2. **Supported URLs:**
   - youtube.com/watch?v=XXX
   - youtu.be/XXX
   - youtube.com/embed/XXX

3. **Features:**
   - Automatic quality selection
   - Shows available formats
   - API status checking
   - Fast downloads

4. **Note:**
   - Some videos may be restricted
   - Quality depends on source video
   - Large files may take time
            ]])
        end
    end
end

-- Start the application
gg.alert("🎵 YouTube Downloader\n\n✅ Using Dorratz API Only\n📥 Download MP3/MP4 from YouTube\n\nSimply paste any YouTube URL!")
mainMenu()