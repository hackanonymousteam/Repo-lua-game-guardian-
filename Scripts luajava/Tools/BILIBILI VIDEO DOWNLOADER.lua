gg.setVisible(true)

local json = nil
if not pcall(function()
    json = load(gg.makeRequest("https://raw.githubusercontent.com/rxi/json.lua/master/json.lua").content)()
end) then
    json = require("json") or gg.alert("JSON library not available")
    if not json then return end
end

local VIDEO_FILE = "bilibili_downloads.json"

function fileExists(filename)
    local file = io.open(filename, "r")
    if file then
        file:close()
        return true
    end
    return false
end

function safeReadDownloads()
    local downloadsData = {}
    
    if fileExists(VIDEO_FILE) then
        local file = io.open(VIDEO_FILE, "r")
        if file then
            local content = file:read("*a")
            file:close()
            
            if content and content:trim() ~= "" then
                local success, result = pcall(json.decode, content)
                if success then
                    downloadsData = result
                else
                    downloadsData = {}
                end
            end
        end
    end
    
    return downloadsData
end

function saveDownloads(downloadsData)
    local file = io.open(VIDEO_FILE, "w")
    if file then
        file:write(json.encode(downloadsData))
        file:close()
        return true
    end
    return false
end

function extractVideoId(url)
    local pattern = "/video/(%d+)"
    local videoId = url:match(pattern)
    return videoId
end

function addDownloadRecord(title, url, videoId, quality)
    local downloads = safeReadDownloads()
    
    local record = {
        title = title,
        url = url,
        videoId = videoId,
        quality = quality or "480P",
        downloadDate = os.date("%Y-%m-%d %H:%M:%S"),
        filePath = "/sdcard/Download/bilibili_" .. videoId .. ".mp4"
    }
    
    if not downloads.records then
        downloads.records = {}
    end
    
    table.insert(downloads.records, record)
    
    if not downloads.stats then
        downloads.stats = {
            totalDownloads = 0,
            lastDownload = ""
        }
    end
    
    downloads.stats.totalDownloads = downloads.stats.totalDownloads + 1
    downloads.stats.lastDownload = record.downloadDate
    
    saveDownloads(downloads)
    return true
end

function getDownloadHistory()
    local downloads = safeReadDownloads()
    
    if not downloads.records or #downloads.records == 0 then
        return "No downloads registered"
    end
    
    local history = "DOWNLOAD HISTORY:\n\n"
    
    for i, record in ipairs(downloads.records) do
        history = history .. string.format("%d. %s\n", i, record.title)
        history = history .. string.format("   ID: %s\n", record.videoId)
        history = history .. string.format("   Quality: %s\n", record.quality)
        history = history .. string.format("   Date: %s\n", record.downloadDate)
        history = history .. string.format("   File: %s\n\n", record.filePath)
    end
    
    history = history .. string.format("Total: %d downloads", #downloads.records)
    
    if downloads.stats then
        history = history .. string.format("\nLast: %s", downloads.stats.lastDownload)
    end
    
    return history
end

function clearDownloadHistory()
    local confirm = gg.alert("DELETE HISTORY?\n\nThis will remove all download records.", "Cancel", "Delete")
    
    if confirm ~= 2 then
        return false, "Operation cancelled"
    end
    
    local emptyData = {
        records = {},
        stats = {
            totalDownloads = 0,
            lastDownload = ""
        }
    }
    
    local success = saveDownloads(emptyData)
    
    if success then
        return true, "History cleared successfully!"
    else
        return false, "Error clearing history"
    end
end

function downloadBilibiliVideo(url, quality)
    gg.toast("Extracting video ID...")
    
    local videoId = extractVideoId(url)
    if not videoId then
        return false, "Invalid URL. Format: https://www.bilibili.tv/video/ID"
    end
    
    gg.toast("Fetching video information...")
    
    local headers = {
        ["User-Agent"] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36",
        ["Accept"] = "application/json",
        ["Referer"] = "https://www.bilibili.tv"
    }
    
    local apiUrl = "https://api.bilibili.tv/intl/gateway/web/playurl?" ..
                   "s_locale=id_ID&platform=web&aid=" .. videoId ..
                   "&qn=64&type=0&device=wap&tf=0" ..
                   "&spm_id=bstar-web.ugc-video-detail.0.0" ..
                   "&from_spm_id=bstar-web.homepage.trending.all" ..
                   "&fnval=16&fnver=0"
    
    local response = gg.makeRequest(apiUrl, headers)
    
    if type(response) ~= "table" or response.code ~= 200 then
        return false, "API error: " .. tostring(response.code or "no connection")
    end
    
    local data = json.decode(response.content)
    
    if not data.data or not data.data.playurl then
        return false, "Video data not found"
    end
    
    gg.toast("Finding video URL...")
    
    local videoStreams = data.data.playurl.video
    local selectedStream = nil
    
    for _, stream in ipairs(videoStreams) do
        if stream.stream_info and stream.stream_info.desc_words == quality then
            selectedStream = stream
            break
        end
    end
    
    if not selectedStream then
        selectedStream = videoStreams[1]
        quality = selectedStream.stream_info.desc_words or "Unknown"
    end
    
    local videoUrl = selectedStream.video_resource.url or 
                    selectedStream.video_resource.backup_url[1]
    
    if not videoUrl then
        return false, "Video URL not found"
    end
    
    gg.toast("Downloading video...")
    
    local savePath = "/sdcard/Download/bilibili_" .. videoId .. ".mp4"
    
    local downloadResponse = gg.makeRequest(videoUrl, {
        ["User-Agent"] = "Mozilla/5.0",
        ["Referer"] = "https://www.bilibili.tv"
    })
    
    if type(downloadResponse) ~= "table" or downloadResponse.code ~= 200 then
        return false, "Download error: " .. tostring(downloadResponse.code or "")
    end
    
    gg.toast("Saving file...")
    
    local file = io.open(savePath, "wb")
    if not file then
        return false, "Error creating file"
    end
    
    file:write(downloadResponse.content)
    file:close()
    
    local title = "Bilibili Video ID: " .. videoId
    local pageResponse = gg.makeRequest(url)
    
    if type(pageResponse) == "table" and pageResponse.code == 200 then
        local titleMatch = pageResponse.content:match('<title>([^<]+)</title>')
        if titleMatch then
            title = titleMatch:gsub("|.*", ""):trim()
        end
    end
    
    addDownloadRecord(title, url, videoId, quality)
    
    return true, savePath, title, quality
end

function main()
    while true do
        local choice = gg.choice({
            "Download Bilibili Video",
            "View Download History",
            "Clear History",
            "About/Instructions",
            "Exit"
        }, nil, "BILIBILI VIDEO DOWNLOADER")
        
        if not choice then
            break
        end
        
        if choice == 1 then
            local input = gg.prompt({
                "Bilibili Video URL:",
                "Quality (480P, 720P, 1080P):"
            }, {"https://www.bilibili.tv/video/4793817472438784", "480P"}, {"text", "text"})
            
            if input and input[1] and input[1]:trim() ~= "" then
                local url = input[1]:trim()
                local quality = input[2]:trim() or "480P"
                
                local success, result, title, actualQuality = downloadBilibiliVideo(url, quality)
                
                if success then
                    gg.alert(string.format("DOWNLOAD COMPLETED!\n\nTitle: %s\nQuality: %s\nSaved to: %s\n\nVideo saved successfully!", 
                        title, actualQuality, result))
                else
                    gg.alert("DOWNLOAD ERROR:\n\n" .. result)
                end
            else
                gg.toast("Download cancelled")
            end
            
        elseif choice == 2 then
            local history = getDownloadHistory()
            gg.alert(history)
            
        elseif choice == 3 then
            local success, message = clearDownloadHistory()
            gg.alert(message)
            
        elseif choice == 4 then
            gg.alert([[BILIBILI VIDEO DOWNLOADER

INSTRUCTIONS:
1. Paste the full Bilibili video URL
2. Choose quality (480P, 720P, 1080P)
3. Wait for download
4. Video will be saved to /sdcard/Download/

URL FORMAT:
https://www.bilibili.tv/video/VIDEO_ID

LIMITATIONS:
• Public videos only
• no have audio in video downloaded
• Depends on API availability
• Maximum quality available in video

RECOMMENDATION:
Use "480P" quality for faster downloads
]])
            
        elseif choice == 5 then
            gg.toast("Exiting...")
            break
        end
    end
end

main()
gg.setVisible(false)