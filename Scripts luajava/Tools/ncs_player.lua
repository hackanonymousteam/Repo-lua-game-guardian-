local currentTrack = ""
local currentTrackName = ""
local searchResults = {}
local Random = -1
local isPlaying = false

local function urlencode(str)
    if str then
        str = string.gsub(str, "\n", "\r\n")
        str = string.gsub(str, "([^%w %-%_%.%~])",
            function(c) return string.format("%%%02X", string.byte(c)) end)
        str = string.gsub(str, " ", "+")
    end
    return str
end

local function extractMusicData(html)
    local musicList = {}
    
    local pattern = 'data%-url="(.-)"%s+data%-artist="(.-)"%s+data%-artistraw="(.-)"%s+data%-track="(.-)"%s+data%-cover="(.-)"'
    
    for url, artist, artistRaw, track, cover in html:gmatch(pattern) do
        table.insert(musicList, {
            url = url:gsub("&amp;", "&"),
            artist = artist:gsub("&amp;", "&"),
            artistRaw = artistRaw:gsub("&amp;", "&"),
            track = track:gsub("&amp;", "&"),
            cover = cover:gsub("&amp;", "&")
        })
    end
    
    return musicList
end

local function searchNCSMusic(query)
    gg.toast("Searching NCS...")
    
    local searchUrl = "https://ncs.io/music-search"
    if query and query ~= "" then
        searchUrl = searchUrl .. "?q=" .. urlencode(query)
    end
    
    local request = gg.makeRequest(searchUrl)
    
    if not request or request.code ~= 200 then
        gg.alert("Error connecting to NCS")
        return nil
    end
    
    local musicList = {}
    local html = request.content
    
    local trackPattern = 'data%-tid="(.-)"%s+data%-track="(.-)"%s+data%-artistraw="(.-)"'
    
    for tid, track, artist in html:gmatch(trackPattern) do
        if tid and track then
            table.insert(musicList, {
                tid = tid,
                track = track:gsub("&amp;", "&"),
                artist = artist:gsub("&amp;", "&"),
                searchResult = true
            })
        end
    end
    
    if #musicList == 0 then
        local fallbackList = extractMusicData(html)
        for i, music in ipairs(fallbackList) do
            music.searchResult = true
            table.insert(musicList, music)
        end
    end
    
    if #musicList == 0 then
        gg.alert("No tracks found")
        return nil
    end
    
    gg.toast(#musicList .. " search results")
    return musicList
end

local function fetchNCSMusic()
    gg.toast("Loading NCS...")
    
    local request = gg.makeRequest('https://ncs.io')
    
    if not request or request.code ~= 200 then
        gg.alert("Error connecting to NCS")
        return nil
    end
    
    local musicList = extractMusicData(request.content)
    
    if #musicList == 0 then
        gg.alert("No music found")
        return nil
    end
    
    gg.toast(#musicList .. " tracks found")
    return musicList
end

local function getDownloadInfo(tid)
    gg.toast("Getting download info...")
    
    local infoUrl = "https://ncs.io/track/info/" .. tid
    local request = gg.makeRequest(infoUrl)
    
    if not request or request.code ~= 200 then
        return nil
    end
    
    local html = request.content
    local downloadUrl = nil
    
    local downloadPattern = 'href="(/track/download/[^"]+)"'
    for url in html:gmatch(downloadPattern) do
        if url then
            downloadUrl = "https://ncs.io" .. url
            break
        end
    end
    
    return downloadUrl
end

local function downloadTrack(url, filename)
    gg.toast("Downloading...")
    
    local request = gg.makeRequest(url)
    
    if request and request.code == 200 then
        local path = "/sdcard/Download/" .. filename .. ".mp3"
        local file = io.open(path, "wb")
        if file then
            file:write(request.content)
            file:close()
            gg.toast("Downloaded: " .. path)
            return true
        end
    end
    
    gg.alert("Download failed")
    return false
end

local function playMusic(url, trackName)
    gg.toast("Loading: " .. trackName)
    
    gg.playMusic(url)
    
    currentTrack = url
    currentTrackName = trackName
    isPlaying = true
    gg.toast("Now playing: " .. trackName)
    return true
end

local function chooseNCSMusic()
    local musicList = fetchNCSMusic()
    if not musicList then return nil end
    
    local displayList = {}
    for i, music in ipairs(musicList) do
        local displayName = "🎵 " .. music.track
        if music.artistRaw and music.artistRaw ~= "" then
            displayName = displayName .. " - " .. music.artistRaw
        end
        table.insert(displayList, displayName)
    end
    
    if #displayList == 0 then
        gg.alert("No tracks available")
        return nil
    end
    
    local choice = gg.choice(displayList, nil, "NCS Music - Select a track")
    if not choice then return nil end
    
    local selectedMusic = musicList[choice]
    return selectedMusic.url, selectedMusic.track, selectedMusic
end

local function searchAndplayMusic()
    local query = gg.prompt({"Enter search term:"}, {""}, {"text"})
    if not query or query[1] == "" then return nil end
    
    local musicList = searchNCSMusic(query[1])
    if not musicList then return nil end
    
    local displayList = {}
    for i, music in ipairs(musicList) do
        local displayName = "🎵 " .. music.track
        if music.artist and music.artist ~= "" then
            displayName = displayName .. " - " .. music.artist
        end
        table.insert(displayList, displayName)
    end
    
    local choice = gg.choice(displayList, nil, "NCS Search Results - " .. query[1])
    if not choice then return nil end
    
    local selectedMusic = musicList[choice]
    
    if selectedMusic.url then
        return selectedMusic.url, selectedMusic.track, selectedMusic
    elseif selectedMusic.tid then
        local downloadUrl = getDownloadInfo(selectedMusic.tid)
        if downloadUrl then
            return downloadUrl, selectedMusic.track, selectedMusic
        else
            gg.alert("Could not get download URL for this track")
            return nil
        end
    end
    
    return nil
end

local function playFromSearchResults()
    if not searchResults or #searchResults == 0 then
        gg.alert("No search results available")
        return nil
    end
    
    local displayList = {}
    for i, music in ipairs(searchResults) do
        local displayName = i .. ". " .. music.track
        if music.artist and music.artist ~= "" then
            displayName = displayName .. " - " .. music.artist
        end
        table.insert(displayList, displayName)
    end
    
    local choice = gg.choice(displayList, nil, "Select from search results")
    if not choice then return nil end
    
    local selectedMusic = searchResults[choice]
    
    if selectedMusic.url then
        return selectedMusic.url, selectedMusic.track, selectedMusic
    elseif selectedMusic.tid then
        local downloadUrl = getDownloadInfo(selectedMusic.tid)
        if downloadUrl then
            return downloadUrl, selectedMusic.track, selectedMusic
        else
            gg.alert("Could not get download URL for this track")
            return nil
        end
    end
    
    return nil
end

local function downloadCurrentTrack()
    if currentTrack == "" then
        gg.alert("No track playing")
        return false
    end
    
    local filename = currentTrackName or "ncs_track"
    filename = filename:gsub("[^%w%s]", ""):gsub("%s+", "_")
    
    return downloadTrack(currentTrack, filename)
end

local function downloadTrackFromList(music)
    if not music then return false end
    
    local url = nil
    local filename = music.track or "ncs_track"
    filename = filename:gsub("[^%w%s]", ""):gsub("%s+", "_")
    
    if music.url then
        url = music.url
    elseif music.tid then
        url = getDownloadInfo(music.tid)
    end
    
    if not url then
        gg.alert("Could not get download URL")
        return false
    end
    
    return downloadTrack(url, filename)
end

local function mainMenu()
    local status = "⏹️ No music"
    
    if currentTrackName ~= "" then
        if isPlaying then
            status = "▶️ " .. currentTrackName
        else
            status = "⏸️ " .. currentTrackName
        end
    end
    
    local hasSearchResults = searchResults and #searchResults > 0
    
    local options = {
        "🎵 Browse NCS Music",
        "🔍 Search NCS Music",
        hasSearchResults and "📋 Play from search results" or nil,
        "💾 Download current track",
        "⏸️ Pause",
        "❌ Exit"
    }
    
    if not isPlaying then
        options[5] = nil
    end
    
    local cleanOptions = {}
    for i, option in ipairs(options) do
        if option ~= nil then
            table.insert(cleanOptions, option)
        end
    end
    
    local choice = gg.choice(cleanOptions, nil, "NCS Music Player\n" .. status)
    
    if choice == 1 then
        local url, trackName, music = chooseNCSMusic()
        if url then
            playMusic(url, trackName)
            if music and gg.choice({"", "  Download"}, nil, "Download this track too?") == 2 then
                downloadTrackFromList(music)
            end
        end
    elseif choice == 2 then
        local url, trackName, music = searchAndplayMusic()
        if url then
            playMusic(url, trackName)
            if music and gg.choice({"", " Download"}, nil, "Download this track too?") == 2 then
                downloadTrackFromList(music)
            end
        end
    elseif choice == 3 and hasSearchResults then
        local url, trackName, music = playFromSearchResults()
        if url then
            playMusic(url, trackName)
            if music and gg.choice({"", " Download"}, nil, "Download this track too?") == 2 then
                downloadTrackFromList(music)
            end
        end
    elseif choice == (hasSearchResults and 4 or 3) then
        downloadCurrentTrack()
    elseif choice == (hasSearchResults and 5 or 4) then
        gg.playMusic("")
        isPlaying = false
        gg.toast("⏸️ Paused")
    elseif choice == (hasSearchResults and 6 or 5) then
        gg.toast("Goodbye!")
        os.exit()
    end
end

gg.toast("NCS Music Player Loaded!")

while true do
    if gg.isVisible(true) then
        Random = 1
        gg.setVisible(false)
    end
    
    if Random == 1 then
        mainMenu()
        Random = -1
    end
    
    gg.sleep(100)
end