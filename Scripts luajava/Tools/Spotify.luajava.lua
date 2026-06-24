if not luajava then
    print("LuaJava NOT Available!")
    return
end

if not activity then
    print("No activity available")
    return
end

local json = nil
if not pcall(function()
    json = load(gg.makeRequest("https://raw.githubusercontent.com/rxi/json.lua/master/json.lua").content)()
end) then
    json = require("json") or gg.alert("JSON library not available")
    if not json then return end
end

local Color = luajava.bindClass("android.graphics.Color")
local Context = luajava.bindClass("android.content.Context")
local Typeface = luajava.bindClass("android.graphics.Typeface")
local GradientDrawable = luajava.bindClass("android.graphics.drawable.GradientDrawable")
local Build = luajava.bindClass("android.os.Build")
local Handler = luajava.bindClass("android.os.Handler")
local Looper = luajava.bindClass("android.os.Looper")
local TypedValue = luajava.bindClass("android.util.TypedValue")
local Gravity = luajava.bindClass("android.view.Gravity")
local View = luajava.bindClass("android.view.View")
local ViewGroup = luajava.bindClass("android.view.ViewGroup")
local WindowManager = luajava.bindClass("android.view.WindowManager")
local LayoutParams = luajava.bindClass("android.view.WindowManager$LayoutParams")
local LinearLayout = luajava.bindClass("android.widget.LinearLayout")
local LinLayoutParams = luajava.bindClass("android.widget.LinearLayout$LayoutParams")
local FrameLayout = luajava.bindClass("android.widget.FrameLayout")
local FrameLayoutParams = luajava.bindClass("android.widget.FrameLayout$LayoutParams")
local ScrollView = luajava.bindClass("android.widget.ScrollView")
local TextView = luajava.bindClass("android.widget.TextView")
local EditText = luajava.bindClass("android.widget.EditText")
local Button = luajava.bindClass("android.widget.Button")
local Runnable = luajava.bindClass("java.lang.Runnable")
local Toast = luajava.bindClass("android.widget.Toast")
local Thread = luajava.bindClass("java.lang.Thread")
local File = luajava.bindClass("java.io.File")
local FileOutputStream = luajava.bindClass("java.io.FileOutputStream")
local URL = luajava.bindClass("java.net.URL")
local HttpURLConnection = luajava.bindClass("java.net.HttpURLConnection")
local BufferedReader = luajava.bindClass("java.io.BufferedReader")
local InputStreamReader = luajava.bindClass("java.io.InputStreamReader")
local StringBuilder = luajava.bindClass("java.lang.StringBuilder")
local OutputStreamWriter = luajava.bindClass("java.io.OutputStreamWriter")
local Intent = luajava.bindClass("android.content.Intent")
local Uri = luajava.bindClass("android.net.Uri")
local MediaPlayer = luajava.bindClass("android.media.MediaPlayer")
local Environment = luajava.bindClass("android.os.Environment")
local ClipboardManager = luajava.bindClass("android.content.ClipboardManager")
local ClipData = luajava.bindClass("android.content.ClipData")

local mainHandler = Handler(Looper.getMainLooper())
local vibrator = activity.getSystemService(Context.VIBRATOR_SERVICE)

local UA = "Mozilla/5.0 (Linux; Android 15; SM-F958 Build/AP3A.240905.015) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.86 Mobile Safari/537.36"

local currentSongData = nil
local audioPlayer = nil

local UI = {
    BG = Color.parseColor("#0a0a0f"),
    CARD = Color.parseColor("#1a1a2e"),
    ACCENT = Color.parseColor("#e94560"),
    ACCENT2 = Color.parseColor("#0f3460"),
    TEXT = Color.parseColor("#eaeaea"),
    SUCCESS = Color.parseColor("#4ade80"),
    DANGER = Color.parseColor("#ef4444"),
    WARNING = Color.parseColor("#f59e0b"),
    WHITE = Color.parseColor("#FFFFFF"),
    GRAY = Color.parseColor("#999999"),
    BLACK = Color.parseColor("#000000"),
    CYAN = Color.parseColor("#00d4ff"),
}

local activeView = nil
local windowManager = nil
local mParams = nil
local WIDTH = 360
local HEIGHT = 640

local urlInput = nil
local fetchButton = nil
local resultText = nil
local playButton = nil
local downloadButton = nil
local aboutButton = nil
local exitButton = nil
local copyErrorButton = nil

local function dp(v)
    return math.floor(TypedValue.applyDimension(1, v, activity.getResources().getDisplayMetrics()))
end

local function getSkin(color, radius, strokeWidth, strokeColor)
    local draw = GradientDrawable()
    draw.setColor(color)
    draw.setCornerRadius(dp(radius))
    if strokeWidth and strokeColor then
        draw.setStroke(dp(strokeWidth), strokeColor)
    end
    return draw
end

local function showToast(message)
    mainHandler.post(Runnable({
        run = function()
            Toast.makeText(activity, message, Toast.LENGTH_SHORT).show()
        end
    }))
end

local function runUi(func)
    mainHandler.post(Runnable({
        run = function()
            pcall(func)
        end
    }))
end

local function isValidSpotifyUrl(url)
    if not url then return false end
    return string.match(url, "https?://open%.spotify%.com/track/[%w]+") ~= nil or
           string.match(url, "https?://spotify%.link/[%w]+") ~= nil or
           string.match(url, "spotify:track:[%w]+") ~= nil
end

local function copyToClipboard(text)
    local clipboard = activity.getSystemService(Context.CLIPBOARD_SERVICE)
    local clip = ClipData.newPlainText("error_text", text)
    clipboard.setPrimaryClip(clip)
    showToast("Text copied to clipboard!")
end

local function readStream(inputStream)
    local reader = BufferedReader(InputStreamReader(inputStream))
    local response = StringBuilder()
    local line = reader.readLine()
    while line ~= nil do
        response.append(line)
        line = reader.readLine()
    end
    reader.close()
    return response.toString()
end

local function readErrorStream(connection)
    local errorStream = connection.getErrorStream()
    if errorStream then
        return readStream(errorStream)
    end
    return "No error details available"
end

local function stopAudio()
    if audioPlayer then
        pcall(function()
            if audioPlayer.isPlaying() then audioPlayer.stop() end
            audioPlayer.release()
        end)
        audioPlayer = nil
    end
end

local function fetchSpotifyMetadata(url, callback)
    if not isValidSpotifyUrl(url) then
        callback(false, "ERROR: Invalid Spotify URL. Please use a valid Spotify track URL.\nExample: https://open.spotify.com/track/...")
        return
    end

    local api_url = "https://spotdown.org/api/song-details?url=" .. Uri.encode(url)

    Thread(Runnable({
        run = function()
            local ok, result = pcall(function()
                local connection = nil
                local urlObj = URL(api_url)
                connection = urlObj.openConnection()
                
                connection.setConnectTimeout(15000)
                connection.setReadTimeout(15000)
                
                connection.setRequestMethod("GET")
                connection.setRequestProperty("Origin", "https://spotdown.org")
                connection.setRequestProperty("Referer", "https://spotdown.org/")
                connection.setRequestProperty("User-Agent", UA)
                connection.setRequestProperty("Accept", "application/json")
                connection.setInstanceFollowRedirects(true)

                local code = connection.getResponseCode()
                
                if code ~= 200 then
                    local errorBody = readErrorStream(connection)
                    connection.disconnect()
                    print("HTTP Error " .. code .. ": " .. errorBody)
                end

                local content = readStream(connection.getInputStream())
                connection.disconnect()

                if not content or content == "" then
                    print("Empty response from server")
                end

                local data = json.decode(content)
                if not data then 
                    print("JSON Parse Error: Invalid response format")
                end

                local songs = data.songs
                if not songs or #songs == 0 then 
                    print("Track not found. The URL might be invalid or the track is not available.")
                end

                local song = songs[1]
                return {
                    title = song.title or "Unknown",
                    artist = song.artist or "Unknown",
                    duration = song.duration or "Unknown",
                    url = url
                }
            end)

            if ok then
                callback(true, result)
            else
                callback(false, "ERROR: " .. tostring(result))
            end
        end
    })).start()
end

local function processSpotifyAudio(songData, mode)
    local download_api = "https://spotdown.org/api/download"
    local path = ""

    if mode == "save" then
        local safe_title = string.gsub(songData.title, "[^%w%s]", "")
        local safe_artist = string.gsub(songData.artist, "[^%w%s]", "")
        path = "/sdcard/Download/" .. safe_artist .. " - " .. safe_title .. ".mp3"
        showToast("Downloading to: " .. path)
    else
        path = "/sdcard/temp_spotify_play.mp3"
        showToast("Buffering... Please wait a moment.")
        runUi(function() playButton.setText("Buffering...") end)
    end

    Thread(Runnable({
        run = function()
            local ok, err = pcall(function()
                local connection = nil
                local urlObj = URL(download_api)
                connection = urlObj.openConnection()
                
                connection.setConnectTimeout(15000)
                connection.setReadTimeout(30000)
                
                connection.setRequestMethod("POST")
                connection.setRequestProperty("Origin", "https://spotdown.org")
                connection.setRequestProperty("Referer", "https://spotdown.org/")
                connection.setRequestProperty("User-Agent", UA)
                connection.setRequestProperty("Content-Type", "application/json")
                connection.setRequestProperty("Accept", "application/json")
                connection.setDoOutput(true)
                connection.setDoInput(true)

                local payload = json.encode({ url = songData.url })
                local writer = OutputStreamWriter(connection.getOutputStream())
                writer.write(payload)
                writer.flush()
                writer.close()

                local code = connection.getResponseCode()
                if code ~= 200 then
                    local errorBody = readErrorStream(connection)
                    connection.disconnect()
                    print("HTTP Error " .. code .. ": " .. errorBody)
                end

                local inputStream = connection.getInputStream()
                local file = File(path)
                if mode == "play" and file.exists() then file.delete() end

                local fos = FileOutputStream(file)
                local buffer = luajava.newArray("byte", 8192)
                local len = inputStream.read(buffer)
                while len ~= -1 do
                    fos.write(buffer, 0, len)
                    len = inputStream.read(buffer)
                end

                fos.close()
                inputStream.close()
                connection.disconnect()
                return path
            end)

            runUi(function()
                if ok then
                    if mode == "save" then
                        showToast("Download Complete!")
                    else
                        playLocalFile(path)
                    end
                else
                    local errorMsg = "Failed: " .. tostring(err)
                    showToast(errorMsg)
                    if mode == "play" then 
                        playButton.setText("Play Track") 
                    end
                    resultText.setText(errorMsg)
                    resultText.setTextColor(UI.DANGER)
                    copyErrorButton.setVisibility(View.VISIBLE)
                end
            end)
        end
    })).start()
end

local function playLocalFile(path)
    stopAudio()
    audioPlayer = MediaPlayer()

    local setupOk, err = pcall(function()
        audioPlayer.setDataSource(path)

        audioPlayer.setOnPreparedListener(luajava.createProxy("android.media.MediaPlayer$OnPreparedListener", {
            onPrepared = function(mp)
                playButton.setText("Pause Track")
                mp.start()
                showToast("Playing...")
            end
        }))

        audioPlayer.setOnCompletionListener(luajava.createProxy("android.media.MediaPlayer$OnCompletionListener", {
            onCompletion = function(mp)
                playButton.setText("Play Track")
                stopAudio()
            end
        }))

        audioPlayer.setOnErrorListener(luajava.createProxy("android.media.MediaPlayer$OnErrorListener", {
            onError = function(mp, what, extra)
                playButton.setText("Play Track")
                stopAudio()
                local errorMsg = "MediaPlayer Error: " .. what
                showToast(errorMsg)
                resultText.setText(errorMsg)
                resultText.setTextColor(UI.DANGER)
                copyErrorButton.setVisibility(View.VISIBLE)
                return true
            end
        }))

        audioPlayer.prepareAsync()
    end)

    if not setupOk then
        local errorMsg = "Failed to initialize player: " .. tostring(err)
        showToast(errorMsg)
        resultText.setText(errorMsg)
        resultText.setTextColor(UI.DANGER)
        copyErrorButton.setVisibility(View.VISIBLE)
    end
end

local function createMainScreen()
    local root = FrameLayout(activity)
    local rootParams = FrameLayoutParams(dp(WIDTH), dp(HEIGHT))
    root.setLayoutParams(rootParams)

    local main = LinearLayout(activity)
    main.setOrientation(LinearLayout.VERTICAL)
    main.setBackground(getSkin(UI.BG, 20, 2, UI.ACCENT))
    main.setPadding(dp(16), dp(16), dp(16), dp(16))
    main.setLayoutParams(FrameLayoutParams(FrameLayoutParams.MATCH_PARENT, FrameLayoutParams.MATCH_PARENT))

    local titleText = TextView(activity)
    titleText.setText("Spotify Player & Downloader")
    titleText.setTextColor(UI.ACCENT)
    titleText.setTextSize(1, 20)
    titleText.setTypeface(Typeface.create("sans-serif-black", Typeface.BOLD))
    titleText.setGravity(Gravity.CENTER)
    local titleParams = LinLayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT)
    titleParams.setMargins(0, 0, 0, dp(12))
    titleText.setLayoutParams(titleParams)
    main.addView(titleText)

    local sep1 = View(activity)
    sep1.setLayoutParams(LinLayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, dp(2)))
    sep1.setBackgroundColor(UI.ACCENT)
    sep1.setAlpha(0.5)
    main.addView(sep1)

    local spacer1 = View(activity)
    spacer1.setLayoutParams(LinLayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, dp(12)))
    main.addView(spacer1)

    urlInput = EditText(activity)
    urlInput.setHint("Paste Spotify URL here...")
    urlInput.setHintTextColor(UI.GRAY)
    urlInput.setTextColor(UI.TEXT)
    urlInput.setTextSize(1, 14)
    urlInput.setBackground(getSkin(UI.CARD, 10))
    urlInput.setPadding(dp(12), dp(12), dp(12), dp(12))
    urlInput.setSingleLine(true)
    local urlParams = LinLayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT)
    urlInput.setLayoutParams(urlParams)
    main.addView(urlInput)

    local spacer2 = View(activity)
    spacer2.setLayoutParams(LinLayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, dp(10)))
    main.addView(spacer2)

    fetchButton = Button(activity)
    fetchButton.setText("Search Song")
    fetchButton.setTextColor(UI.WHITE)
    fetchButton.setTextSize(1, 16)
    fetchButton.setTypeface(Typeface.DEFAULT_BOLD)
    fetchButton.setBackground(getSkin(UI.ACCENT, 10))
    fetchButton.setAllCaps(false)
    local fetchParams = LinLayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, dp(48))
    fetchButton.setLayoutParams(fetchParams)
    main.addView(fetchButton)

    local spacer3 = View(activity)
    spacer3.setLayoutParams(LinLayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, dp(10)))
    main.addView(spacer3)

    local scrollView = ScrollView(activity)
    local scrollParams = LinLayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, 0, 1.0)
    scrollView.setLayoutParams(scrollParams)
    scrollView.setBackground(getSkin(UI.CARD, 10))

    resultText = TextView(activity)
    resultText.setText("Enter URL, click Search.\nSong info will appear here.")
    resultText.setTextColor(UI.TEXT)
    resultText.setTextSize(1, 14)
    resultText.setPadding(dp(12), dp(12), dp(12), dp(12))
    resultText.setTextIsSelectable(true)
    scrollView.addView(resultText)
    main.addView(scrollView)

    local spacer4 = View(activity)
    spacer4.setLayoutParams(LinLayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, dp(6)))
    main.addView(spacer4)

    copyErrorButton = Button(activity)
    copyErrorButton.setText("Copy Error Text")
    copyErrorButton.setTextColor(UI.WHITE)
    copyErrorButton.setTextSize(1, 12)
    copyErrorButton.setBackground(getSkin(UI.WARNING, 8))
    copyErrorButton.setAllCaps(false)
    copyErrorButton.setVisibility(View.GONE)
    local copyErrorParams = LinLayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, dp(36))
    copyErrorParams.setMargins(0, 0, 0, dp(6))
    copyErrorButton.setLayoutParams(copyErrorParams)
    main.addView(copyErrorButton)

    playButton = Button(activity)
    playButton.setText("Play Track")
    playButton.setTextColor(UI.WHITE)
    playButton.setTextSize(1, 16)
    playButton.setTypeface(Typeface.DEFAULT_BOLD)
    playButton.setBackground(getSkin(UI.SUCCESS, 10))
    playButton.setAllCaps(false)
    playButton.setVisibility(View.GONE)
    local playParams = LinLayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, dp(48))
    playParams.setMargins(0, 0, 0, dp(8))
    playButton.setLayoutParams(playParams)
    main.addView(playButton)

    downloadButton = Button(activity)
    downloadButton.setText("Download Track")
    downloadButton.setTextColor(UI.WHITE)
    downloadButton.setTextSize(1, 16)
    downloadButton.setTypeface(Typeface.DEFAULT_BOLD)
    downloadButton.setBackground(getSkin(UI.ACCENT2, 10))
    downloadButton.setAllCaps(false)
    downloadButton.setVisibility(View.GONE)
    local downParams = LinLayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, dp(48))
    downParams.setMargins(0, 0, 0, dp(10))
    downloadButton.setLayoutParams(downParams)
    main.addView(downloadButton)

    local sep2 = View(activity)
    sep2.setLayoutParams(LinLayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, dp(2)))
    sep2.setBackgroundColor(UI.ACCENT)
    sep2.setAlpha(0.5)
    main.addView(sep2)

    local spacer5 = View(activity)
    spacer5.setLayoutParams(LinLayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, dp(10)))
    main.addView(spacer5)

    local bottomButtons = LinearLayout(activity)
    bottomButtons.setOrientation(LinearLayout.HORIZONTAL)
    bottomButtons.setGravity(Gravity.CENTER)
    local bottomParams = LinLayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT)
    bottomButtons.setLayoutParams(bottomParams)

    aboutButton = Button(activity)
    aboutButton.setText("About")
    aboutButton.setTextColor(UI.WHITE)
    aboutButton.setTextSize(1, 14)
    aboutButton.setBackground(getSkin(UI.CARD, 10))
    aboutButton.setAllCaps(false)
    local aboutParams = LinLayoutParams(0, dp(44), 0.5)
    aboutParams.setMargins(0, 0, dp(4), 0)
    aboutButton.setLayoutParams(aboutParams)
    bottomButtons.addView(aboutButton)

    exitButton = Button(activity)
    exitButton.setText("Exit")
    exitButton.setTextColor(UI.WHITE)
    exitButton.setTextSize(1, 14)
    exitButton.setBackground(getSkin(UI.DANGER, 10))
    exitButton.setAllCaps(false)
    local exitParams = LinLayoutParams(0, dp(44), 0.5)
    exitParams.setMargins(dp(4), 0, 0, 0)
    exitButton.setLayoutParams(exitParams)
    bottomButtons.addView(exitButton)

    main.addView(bottomButtons)

    root.addView(main)
    return root
end

local function setupEvents()
    local function loadingState(isLoading)
        if isLoading then
            fetchButton.setText("Searching...")
            fetchButton.setEnabled(false)
            stopAudio()
            copyErrorButton.setVisibility(View.GONE)
        else
            fetchButton.setText("Search Song")
            fetchButton.setEnabled(true)
        end
    end

    copyErrorButton.setOnClickListener(View.OnClickListener({
        onClick = function(v)
            local errorText = resultText.getText().toString()
            if errorText ~= "" then
                copyToClipboard(errorText)
            end
        end
    }))

    fetchButton.setOnClickListener(View.OnClickListener({
        onClick = function(v)
            local url = urlInput.getText().toString()
            if url == "" then
                showToast("URL cannot be empty!")
                return
            end

            loadingState(true)
            fetchSpotifyMetadata(url, function(success, data)
                runUi(function()
                    if success then
                        currentSongData = data
                        resultText.setText("Title: " .. data.title .. "\nArtist: " .. data.artist .. "\nDuration: " .. data.duration)
                        resultText.setTextColor(UI.TEXT)
                        copyErrorButton.setVisibility(View.GONE)
                        playButton.setVisibility(View.VISIBLE)
                        downloadButton.setVisibility(View.VISIBLE)
                        playButton.setText("Play Track")
                    else
                        local errorMsg = tostring(data)
                        resultText.setText(errorMsg)
                        resultText.setTextColor(UI.DANGER)
                        copyErrorButton.setVisibility(View.VISIBLE)
                        showToast("Failed to find song.")
                        playButton.setVisibility(View.GONE)
                        downloadButton.setVisibility(View.GONE)
                    end
                    loadingState(false)
                end)
            end)
        end
    }))

    playButton.setOnClickListener(View.OnClickListener({
        onClick = function(v)
            if not currentSongData then return end
            vibrator.vibrate(50)

            if audioPlayer and audioPlayer.isPlaying() then
                audioPlayer.pause()
                playButton.setText("Play Track")
            elseif audioPlayer and not audioPlayer.isPlaying() then
                audioPlayer.start()
                playButton.setText("Pause Track")
            else
                processSpotifyAudio(currentSongData, "play")
            end
        end
    }))

    downloadButton.setOnClickListener(View.OnClickListener({
        onClick = function(v)
            if currentSongData then
                vibrator.vibrate(50)
                processSpotifyAudio(currentSongData, "save")
            end
        end
    }))

    aboutButton.setOnClickListener(View.OnClickListener({
        onClick = function(v)
            vibrator.vibrate(50)
            local telegramUrl = "https://t.me/batmangamesSS"
            
            local aboutView = LinearLayout(activity)
            aboutView.setOrientation(LinearLayout.VERTICAL)
            aboutView.setPadding(dp(20), dp(20), dp(20), dp(20))
            aboutView.setBackground(getSkin(UI.BG, 16, 2, UI.ACCENT))

            local desc = TextView(activity)
            desc.setText("To get the latest updates or other extensions, join our channel.")
            desc.setTextColor(UI.WHITE)
            desc.setTextSize(1, 16)
            desc.setPadding(0, 0, 0, dp(20))
            desc.setTextIsSelectable(true)
            aboutView.addView(desc)

            local joinBtn = Button(activity)
            joinBtn.setText("Join Telegram")
            joinBtn.setTextColor(UI.WHITE)
            joinBtn.setBackground(getSkin(Color.parseColor("#0088cc"), 10))
            joinBtn.setAllCaps(false)
            joinBtn.setLayoutParams(LinLayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, dp(48)))
            aboutView.addView(joinBtn)

            local closeBtn = Button(activity)
            closeBtn.setText("Close")
            closeBtn.setTextColor(UI.WHITE)
            closeBtn.setBackground(getSkin(UI.CARD, 10))
            closeBtn.setAllCaps(false)
            local closeBtnParams = LinLayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, dp(48))
            closeBtnParams.setMargins(0, dp(10), 0, 0)
            closeBtn.setLayoutParams(closeBtnParams)
            aboutView.addView(closeBtn)

            local credit = TextView(activity)
            credit.setText("Script by Spotdown & You")
            credit.setTextColor(UI.GRAY)
            credit.setTextSize(1, 12)
            credit.setGravity(Gravity.CENTER)
            local creditParams = LinLayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT)
            creditParams.setMargins(0, dp(20), 0, 0)
            credit.setLayoutParams(creditParams)
            credit.setTextIsSelectable(true)
            aboutView.addView(credit)

            local aboutPopup = FrameLayout(activity)
            local popupParams = FrameLayoutParams(dp(320), ViewGroup.LayoutParams.WRAP_CONTENT)
            aboutPopup.setLayoutParams(popupParams)
            aboutPopup.addView(aboutView)

            local dialogParams = LayoutParams(dp(320), ViewGroup.LayoutParams.WRAP_CONTENT,
                Build.VERSION.SDK_INT >= 26 and LayoutParams.TYPE_APPLICATION_OVERLAY or LayoutParams.TYPE_PHONE,
                LayoutParams.FLAG_NOT_TOUCH_MODAL + LayoutParams.FLAG_WATCH_OUTSIDE_TOUCH,
                -3)
            dialogParams.gravity = Gravity.CENTER

            windowManager.addView(aboutPopup, dialogParams)

            joinBtn.setOnClickListener(View.OnClickListener({
                onClick = function(v)
                    windowManager.removeView(aboutPopup)
                    closeUI()
                    local intent = Intent(Intent.ACTION_VIEW)
                    intent.setData(Uri.parse(telegramUrl))
                    pcall(function()
                        activity.startActivity(intent)
                    end)
                end
            }))

            closeBtn.setOnClickListener(View.OnClickListener({
                onClick = function(v)
                    windowManager.removeView(aboutPopup)
                end
            }))
        end
    }))

    exitButton.setOnClickListener(View.OnClickListener({
        onClick = function(v)
            stopAudio()
            closeUI()
        end
    }))
end

local function showUI()
    windowManager = activity.getSystemService(Context.WINDOW_SERVICE)

    local layoutType
    if Build.VERSION.SDK_INT >= 26 then
        layoutType = LayoutParams.TYPE_APPLICATION_OVERLAY
    else
        layoutType = LayoutParams.TYPE_PHONE
    end

    mParams = LayoutParams(dp(WIDTH), dp(HEIGHT), layoutType,
        LayoutParams.FLAG_NOT_TOUCH_MODAL + LayoutParams.FLAG_WATCH_OUTSIDE_TOUCH, -3)
    mParams.gravity = Gravity.CENTER
    mParams.x = 0
    mParams.y = 0

    local mainView = createMainScreen()
    setupEvents()

    mainHandler.post(Runnable({
        run = function()
            pcall(function()
                windowManager.addView(mainView, mParams)
                activeView = mainView
            end)
        end
    }))
end

function closeUI()
    mainHandler.postDelayed(Runnable({
        run = function()
            pcall(function()
                if activeView and windowManager then
                    windowManager.removeView(activeView)
                    activeView = nil
                end
            end)
        end
    }), 150)
end

showUI()

return {
    closeUI = closeUI
}