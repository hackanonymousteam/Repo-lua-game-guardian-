local Context = luajava.bindClass("android.content.Context")
local Intent = luajava.bindClass("android.content.Intent")
local Uri = luajava.bindClass("android.net.Uri")
local MediaPlayer = luajava.bindClass("android.media.MediaPlayer")
local AudioManager = luajava.bindClass("android.media.AudioManager")
local Settings = luajava.bindClass("android.provider.Settings")
local InputMethodManager = luajava.bindClass("android.view.inputmethod.InputMethodManager")
local Build = luajava.bindClass("android.os.Build")

local mediaPlayerInstance = nil

local function getGGVersion()
    local success, result = pcall(function()
        local pm = activity.getPackageManager()
        local pkgInfo = pm.getPackageInfo(activity.getPackageName(), 0)
        return pkgInfo.versionName
    end)
    
    if success then
        return result
    else
        return "Unknown"
    end
end

local function getCurrentTime()
    local hour = tonumber(os.date("%H"))
    local minute = os.date("%M")
    local second = os.date("%S")
    
    local period = ""
    if hour >= 24 or hour < 6 then
        period = "Night"
    elseif hour < 12 then
        period = "Morning"
    elseif hour < 18 then
        period = "Afternoon"
    else
        period = "Evening"
    end
    
    local formattedTime = string.format("%02d:%02d:%02d", hour, minute, second)
    return formattedTime, period
end

local function shareText()
    local result = gg.prompt({"Enter text to share:"}, {"Shared from GG " .. os.date()}, {"text"})
    
    if result and result[1] then
        local text = result[1]
        local shareIntent = Intent(Intent.ACTION_SEND)
        shareIntent.setType("text/plain")
        shareIntent.putExtra(Intent.EXTRA_TEXT, text)
        shareIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        
        if shareIntent.resolveActivity(activity.getPackageManager()) then
            activity.startActivity(Intent.createChooser(shareIntent, "Share text"))
            gg.toast("Sharing text...")
        else
            gg.toast("No sharing app found")
        end
    end
end

local function createMediaPlayer()
    if mediaPlayerInstance == nil then
        mediaPlayerInstance = MediaPlayer()
        mediaPlayerInstance.setAudioStreamType(AudioManager.STREAM_MUSIC)
        gg.toast("MediaPlayer created")
    end
    return mediaPlayerInstance
end

local function playMusic()
    local options = {
        "Play test music",
        "Pause music",
        "Stop music",
        "Player status"
    }
    
    local choice = gg.choice(options, nil, "Music Control")
    
    if choice == 1 then
        local mp = createMediaPlayer()
        
        if mp:isPlaying() then
            gg.toast("Already playing music")
            return
        end
        
        local success, error = pcall(function()
            mp.reset()
            mp.setDataSource("https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3")
            
            mp.setOnPreparedListener({
                onPrepared = function(player)
                    player.start()
                    gg.toast("Playing music...")
                end
            })
            
            mp.setOnErrorListener({
                onError = function(player, what, extra)
                    gg.toast("Error: " .. what .. ", " .. extra)
                    return true
                end
            })
            
            mp.prepareAsync()
        end)
        
        if not success then
            gg.toast("Error: " .. tostring(error))
        end
        
    elseif choice == 2 then
        if mediaPlayerInstance and mediaPlayerInstance:isPlaying() then
            mediaPlayerInstance:pause()
            gg.toast("Music paused")
        else
            gg.toast("No music playing")
        end
        
    elseif choice == 3 then
        if mediaPlayerInstance then
            if mediaPlayerInstance:isPlaying() then
                mediaPlayerInstance:stop()
            end
            mediaPlayerInstance:release()
            mediaPlayerInstance = nil
            gg.toast("Music stopped")
        else
            gg.toast("No active music")
        end
        
    elseif choice == 4 then
        if mediaPlayerInstance then
            local status = mediaPlayerInstance:isPlaying() and "PLAYING" or "STOPPED"
            local duration = mediaPlayerInstance:getDuration()
            local position = mediaPlayerInstance:getCurrentPosition()
            
            gg.toast(string.format("Status: %s\nDuration: %d\nPosition: %d", 
                                  status, duration, position))
        else
            gg.toast("MediaPlayer not initialized")
        end
    end
end

local function openSettings()
    local intent = Intent(Settings.ACTION_SETTINGS)
    intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
    
    if intent.resolveActivity(activity.getPackageManager()) then
        activity.startActivity(intent)
        gg.toast("Opening settings...")
    else
        gg.toast("Cannot open settings")
    end
end

local function checkVPN()
    local success, result = pcall(function()
        local NetworkInterface = luajava.bindClass("java.net.NetworkInterface")
        local Collections = luajava.bindClass("java.util.Collections")
        
        local interfaces = NetworkInterface.getNetworkInterfaces()
        if interfaces then
            local list = Collections.list(interfaces)
            
            for i = 0, list.size() - 1 do
                local intf = list.get(i)
                if intf.isUp() and intf.getInterfaceAddresses().size() ~= 0 then
                    local name = intf.getName()
                    if name:find("tun") or name:find("ppp") or name:find("tap") then
                        return true, name
                    end
                end
            end
        end
        
        return false, nil
    end)
    
    if success then
        local vpnDetected, interfaceName = result
        
        if vpnDetected then
            local message = string.format(
                "VPN DETECTED\n\n" ..
                "Interface: %s\n" ..
                "Status: ACTIVE",
                interfaceName
            )
            gg.alert(message)
        else
            gg.alert("VPN NOT DETECTED\n\nNo active VPN interface found")
        end
    else
        gg.toast("Error checking VPN: " .. tostring(result))
    end
end

local function showVirtualKeyboard()
    local imm = activity.getSystemService(Context.INPUT_METHOD_SERVICE)
    
    local success, error = pcall(function()
        imm.toggleSoftInput(InputMethodManager.SHOW_FORCED, 0)
    end)
    
    if success then
        gg.toast("Virtual keyboard activated")
    else
        gg.toast("Error: " .. tostring(error))
    end
end

local function mainMenu()
    while true do
        local options = {
            "Get version",
            "Share text",
            "Play music",
            "Open settings",
            "Get current time",
            "Check VPN",
            "Virtual keyboard",
            "Exit"
        }
        
        local choice = gg.choice(options, nil, "GG Functions v1.0")
        
        if choice == nil or choice == 8 then
            if mediaPlayerInstance then
                if mediaPlayerInstance:isPlaying() then
                    mediaPlayerInstance:stop()
                end
                mediaPlayerInstance:release()
                mediaPlayerInstance = nil
            end
            gg.toast("Goodbye!")
            break
        end
        
        if choice == 1 then
            local version = getGGVersion()
            gg.alert(string.format("GG INFORMATION\n\nVersion: %s\nPackage: %s\nAndroid: %s",
                                  version,
                                  activity.getPackageName(),
                                  Build.VERSION.RELEASE))
            
        elseif choice == 2 then
            shareText()
            
        elseif choice == 3 then
            playMusic()
            
        elseif choice == 4 then
            openSettings()
            
        elseif choice == 5 then
            local time, period = getCurrentTime()
            gg.alert(string.format("CURRENT TIME\n\n%s\n%s\n\n%s",
                                  time,
                                  period,
                                  os.date("%d/%m/%Y")))
            
        elseif choice == 6 then
            checkVPN()
            
        elseif choice == 7 then
            showVirtualKeyboard()
        end
    end
end

local function start()
    mainMenu()
end

start()