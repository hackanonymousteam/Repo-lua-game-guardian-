import "android.media.MediaPlayer"
import "android.media.AudioManager"
import "android.content.Context"
import "android.net.Uri"
import "java.io.File"
import "android.os.Environment"

local mp = nil
local Random = -1
local currentTrack = ""
local lastPath = Environment.getExternalStorageDirectory().getAbsolutePath()
local settingsFile = File(activity.getFilesDir(), "music_player_settings.txt")

local function saveSettings()
    local writer = io.open(settingsFile.getAbsolutePath(), "w")
    if writer then
        writer:write(lastPath)
        writer:close()
    end
end

local function loadSettings()
    if settingsFile.exists() then
        local reader = io.open(settingsFile.getAbsolutePath(), "r")
        if reader then
            lastPath = reader:read("*a") or lastPath
            reader:close()
        end
    end
end

loadSettings()

local function formatTime(ms)
    if ms == nil or ms < 0 then return "00:00" end
    local s = math.floor(ms / 1000)
    local m = math.floor(s / 60)
    s = s % 60
    return string.format("%02d:%02d", m, s)
end

local function joinPaths(base, name)
    return base:gsub("/$", "") .. "/" .. name:gsub("^/", "")
end

local function choiceFile(openPath)
    openPath = openPath:gsub("folder: ", "")
    local pathFile = File(openPath)
    local files = pathFile.listFiles()
    
    if not files then return nil end
    
    local displayList = {}
    local fileList = {}
    
    if openPath ~= Environment.getExternalStorageDirectory().getAbsolutePath() then
        displayList[1] = "↩️ Back"
        fileList[1] = "back"
    end
    
    for i = 0, files.length - 1 do
        local f = files[i]
        if f ~= nil then
            local name = f.getName()
            if f.isDirectory() then
                table.insert(displayList, "📁 " .. name)
                table.insert(fileList, "folder:" .. f.getAbsolutePath())
            elseif name:lower():match("%.mp3$") then
                table.insert(displayList, "🎵 " .. name)
                table.insert(fileList, "file:" .. f.getAbsolutePath())
            end
        end
    end
    
    if #displayList == 0 then
        gg.alert("No MP3 files found in this folder")
        return nil
    end
    
    local choice = gg.choice(displayList, nil, "📂 "..openPath)
    if not choice then return nil end
    
    local selected = fileList[choice]
    
    if selected == "back" then
        return choiceFile(File(openPath).getParent())
    elseif selected:match("^folder:") then
        lastPath = selected:gsub("^folder:", "")
        saveSettings()
        return choiceFile(lastPath)
    else
        return selected:gsub("^file:", "")
    end
end

local function playMusic(path)
    if mp ~= nil then
        mp:stop()
        mp:release()
    end
    
    local file = File(path)
    local uri = Uri.fromFile(file)
    mp = MediaPlayer.create(activity, uri)
    
    if mp == nil then
        gg.alert("Error loading music")
        return false
    end
    
    currentTrack = file.getName()
    mp:start()
    gg.toast("▶️ Playing: " .. currentTrack)
    return true
end

local function mainMenu()
    local status = "⏹️ No music"
    local time = ""
    
    if mp ~= nil then
        status = mp:isPlaying() and "▶️ " or "⏸️ "
        status = status .. currentTrack:gsub("%.mp3$", "")
        
        if mp:getCurrentPosition() > 0 then
            local pos = mp:getCurrentPosition()
            local dur = mp:getDuration()
            time = string.format("\n🕒 %s / %s", formatTime(pos), formatTime(dur))
        end
    end
    
    local options = {
        "🎵 Choose Music",
        mp ~= nil and mp:isPlaying() and "⏸️ Pause" or "▶️ Resume",
        "⏹️ Stop",
        "🔉 Volume +",
        "🔈 Volume -",
        "❌ Exit"
    }
    
    local choice = gg.choice(options, nil, "🔊 Music Player\n" .. status .. time)
    
    if choice == 1 then
        local musicPath = choiceFile(lastPath)
        if musicPath then
            playMusic(musicPath)
        end
    elseif choice == 2 and mp ~= nil then
        if mp:isPlaying() then
            mp:pause()
            gg.toast("⏸️ Paused")
        else
            mp:start()
            gg.toast("▶️ Resumed")
        end
    elseif choice == 3 and mp ~= nil then
        mp:stop()
        mp:release()
        mp = nil
        currentTrack = ""
        gg.toast("⏹️ Stopped")
    elseif choice == 4 then
        local am = activity.getSystemService(Context.AUDIO_SERVICE)
        local current = am.getStreamVolume(AudioManager.STREAM_MUSIC)
        local max = am.getStreamMaxVolume(AudioManager.STREAM_MUSIC)
        if current < max then
            am.setStreamVolume(AudioManager.STREAM_MUSIC, current + 1, 0)
            gg.toast("🔉 Volume: "..(current + 1).."/"..max)
        end
    elseif choice == 5 then
        local am = activity.getSystemService(Context.AUDIO_SERVICE)
        local current = am.getStreamVolume(AudioManager.STREAM_MUSIC)
        if current > 0 then
            am.setStreamVolume(AudioManager.STREAM_MUSIC, current - 1, 0)
            gg.toast("🔈 Volume: "..(current - 1).."/"..am.getStreamMaxVolume(AudioManager.STREAM_MUSIC))
        end
    elseif choice == 6 then
        saveSettings()
        if mp ~= nil then
            mp:stop()
            mp:release()
        end
        os.exit()
    end
end

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