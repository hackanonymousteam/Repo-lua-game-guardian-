if not luajava or not activity then
    print("LuaJava/Activity unavailable")
    return
end

gg.setVisible(false)

local function bind(c)
    local ok, r = pcall(luajava.bindClass, c)
    if ok then return r end
    return nil
end

local Gravity = bind("android.view.Gravity")
local WindowManager = bind("android.view.WindowManager")
local WindowManagerLayoutParams = bind("android.view.WindowManager$LayoutParams")
local Context = bind("android.content.Context")
local Handler = bind("android.os.Handler")
local Looper = bind("android.os.Looper")
local Build = bind("android.os.Build")
local View = bind("android.view.View")
local LinearLayout = bind("android.widget.LinearLayout")
local LinearLayoutParams = bind("android.widget.LinearLayout$LayoutParams")
local TextView = bind("android.widget.TextView")
local Button = bind("android.widget.Button")
local ListView = bind("android.widget.ListView")
local SeekBar = bind("android.widget.SeekBar")
local ArrayAdapter = bind("android.widget.ArrayAdapter")
local Color = bind("android.graphics.Color")
local PixelFormat = bind("android.graphics.PixelFormat")
local MediaPlayer = bind("android.media.MediaPlayer")
local PlaybackParams = bind("android.media.PlaybackParams")
local AudioManager = bind("android.media.AudioManager")
local MediaStore = bind("android.provider.MediaStore")
local ArrayList = bind("java.util.ArrayList")

local function getWindowType()
    if Build.VERSION.SDK_INT >= 26 then
        return 2038
    elseif Build.VERSION.SDK_INT >= 23 then
        return 2002
    else
        return 2003
    end
end

local function runOnUiThread(func)
    activity.runOnUiThread(luajava.createProxy("java.lang.Runnable", {
        run = function()
            pcall(func)
        end
    }))
end

local function toArrayList(t)
    local list = ArrayList()
    if t then
        for _, v in ipairs(t) do
            list.add(v)
        end
    end
    return list
end

local updateHandler
local mainLooper = Looper.getMainLooper()
if mainLooper then
    updateHandler = Handler(mainLooper)
else
    print("Error getting Looper")
    gg.setVisible(true)
    return
end

local context = activity
local mediaPlayer = MediaPlayer()
local wm = context.getSystemService(Context.WINDOW_SERVICE)

local playerState = {
    isPlaying = false,
    currentSoundFilePath = nil,
    currentSoundIndex = 0,
    playbackSpeed = 1.0,
    playbackPitch = 1.0,
    isRepeatActivated = false
}

local allAudioFiles = {}
local currentDisplayItems = {}

local rootLayout
local listView
local id_songName
local id_contador
local id_Progress
local id_startTime
local id_endTime
local playPauseButton
local speedToggleButton
local repeatToggleButton
local pitchSeekBar
local pitchValueText

local Utils = {
    formatTime = function(duration)
        if not duration or duration <= 0 then return "00:00" end
        local minutes = math.floor(duration / 60000)
        local seconds = math.floor((duration % 60000) / 1000)
        return string.format("%02d:%02d", minutes, seconds)
    end
}

function loadAllAudioFiles()
    allAudioFiles = {}

    local projection = {
        MediaStore.Audio.Media.DATA,
        MediaStore.Audio.Media.DISPLAY_NAME,
        MediaStore.Audio.Media.DATE_ADDED
    }

    local selection = MediaStore.Audio.Media.IS_MUSIC .. " != 0"
    local cursor = context.getContentResolver().query(
        MediaStore.Audio.Media.EXTERNAL_CONTENT_URI,
        projection, selection, nil, nil
    )

    if cursor then
        local columnData = cursor.getColumnIndexOrThrow(MediaStore.Audio.Media.DATA)
        local columnName = cursor.getColumnIndexOrThrow(MediaStore.Audio.Media.DISPLAY_NAME)
        local columnDate = cursor.getColumnIndexOrThrow(MediaStore.Audio.Media.DATE_ADDED)

        while cursor.moveToNext() do
            local filePath = cursor.getString(columnData)
            local displayName = cursor.getString(columnName)
            local creationTime = cursor.getLong(columnDate) * 1000

            table.insert(allAudioFiles, {
                filePath = filePath,
                displayName = displayName,
                creationTime = creationTime
            })
        end
        cursor.close()

        table.sort(allAudioFiles, function(a, b)
            return a.creationTime > b.creationTime
        end)

        currentDisplayItems = allAudioFiles
        return true
    end
    return false
end

function refreshListView()
    local displayNames = {}
    for _, item in ipairs(currentDisplayItems) do
        table.insert(displayNames, item.displayName)
    end
    if listView then
        if #displayNames > 0 then
            listView.setAdapter(ArrayAdapter(context, android.R.layout.simple_list_item_1, toArrayList(displayNames)))
        else
            listView.setAdapter(ArrayAdapter(context, android.R.layout.simple_list_item_1, toArrayList({})))
        end
    end
    if id_contador then
        id_contador.text = "Tracks: " .. tostring(#currentDisplayItems)
    end
end

PlaybackManager = {
    updateProgress = function()
        if mediaPlayer.isPlaying() then
            local pos = mediaPlayer.getCurrentPosition()
            if id_startTime then id_startTime.setText(Utils.formatTime(pos)) end
            if id_Progress then id_Progress.setProgress(pos) end
            updateHandler.postDelayed(PlaybackManager.updateProgress, 1000)
        end
    end,

    stopUpdateHandler = function()
        updateHandler.removeCallbacksAndMessages(nil)
    end,

    updatePlaybackParams = function()
        if mediaPlayer.isPlaying() then
            local params = PlaybackParams()
            params.setSpeed(playerState.playbackSpeed)
            params.setPitch(playerState.playbackPitch)
            mediaPlayer.setPlaybackParams(params)
        end
    end,

    playSound = function(soundFilePath)
        if playerState.currentSoundFilePath == soundFilePath then
            mediaPlayer.stop()
            mediaPlayer.reset()
            playerState.isPlaying = false
            playerState.currentSoundFilePath = nil
            PlaybackManager.stopUpdateHandler()
            return
        end

        if playerState.isPlaying then
            mediaPlayer.stop()
            mediaPlayer.reset()
            PlaybackManager.stopUpdateHandler()
        end

        pcall(function()
            mediaPlayer.setAudioStreamType(AudioManager.STREAM_MUSIC)
            mediaPlayer.reset()
            mediaPlayer.setDataSource(soundFilePath)
            mediaPlayer.prepare()
            mediaPlayer.start()
            PlaybackManager.updatePlaybackParams()

            local songName = string.match(soundFilePath, ".*/(.*)")
            if id_songName then id_songName.text = songName end
            playerState.isPlaying = true
            playerState.currentSoundFilePath = soundFilePath
            if playPauseButton then playPauseButton.text = "Pause" end

            local totalDuration = mediaPlayer.getDuration()
            if id_endTime then id_endTime.setText(Utils.formatTime(totalDuration)) end
            if id_Progress then id_Progress.setMax(totalDuration) end

            local currentPos = mediaPlayer.getCurrentPosition()
            if id_startTime then id_startTime.setText(Utils.formatTime(currentPos)) end
            if id_Progress then id_Progress.setProgress(currentPos) end

            updateHandler.postDelayed(PlaybackManager.updateProgress, 1000)
        end)

        if id_Progress then
            id_Progress.setOnSeekBarChangeListener({
                onProgressChanged = function(seekBar, progress, fromUser)
                    if fromUser then
                        mediaPlayer.seekTo(progress)
                        if id_startTime then id_startTime.setText(Utils.formatTime(progress)) end
                    end
                end
            })
        end

        for i, item in ipairs(currentDisplayItems) do
            if item.filePath == soundFilePath then
                playerState.currentSoundIndex = i
                if listView then listView.setSelection(i - 1) end
                break
            end
        end

        mediaPlayer.setOnCompletionListener({
            onCompletion = function(mp)
                if playerState.isRepeatActivated then
                    mp.seekTo(0)
                    mp.start()
                    return
                end
                if playPauseButton then playPauseButton.text = "Play" end
                local nextPos = playerState.currentSoundIndex + 1
                if nextPos <= #currentDisplayItems then
                    PlaybackManager.playSound(currentDisplayItems[nextPos].filePath)
                end
            end
        })
    end,

    togglePlayPause = function()
        if not playerState.currentSoundFilePath then
            if #currentDisplayItems > 0 then
                PlaybackManager.playSound(currentDisplayItems[1].filePath)
            end
            return
        end

        if playerState.isPlaying then
            mediaPlayer.pause()
            playerState.isPlaying = false
            if playPauseButton then playPauseButton.text = "Play" end
        else
            mediaPlayer.start()
            playerState.isPlaying = true
            if playPauseButton then playPauseButton.text = "Pause" end
        end
    end,

    playNext = function()
        local nextPos = playerState.currentSoundIndex + 1
        if nextPos <= #currentDisplayItems then
            PlaybackManager.playSound(currentDisplayItems[nextPos].filePath)
        end
    end,

    playPrevious = function()
        local prevPos = playerState.currentSoundIndex - 1
        if prevPos >= 1 then
            PlaybackManager.playSound(currentDisplayItems[prevPos].filePath)
        end
    end,

    toggleSpeed = function(view)
        if playerState.playbackSpeed == 1.0 then
            playerState.playbackSpeed = 1.5
            view.setText("Speed 1.5x")
        elseif playerState.playbackSpeed == 1.5 then
            playerState.playbackSpeed = 2.0
            view.setText("Speed 2x")
        elseif playerState.playbackSpeed == 2.0 then
            playerState.playbackSpeed = 0.75
            view.setText("Speed 0.75x")
        else
            playerState.playbackSpeed = 1.0
            view.setText("Normal speed")
        end
        PlaybackManager.updatePlaybackParams()
    end,

    toggleRepeat = function(view)
        playerState.isRepeatActivated = not playerState.isRepeatActivated
        view.setText(playerState.isRepeatActivated and "Repeat ON" or "Repeat OFF")
    end
}

local function handleItemClick(l, v, position, id)
    if not currentDisplayItems[position + 1] then return end
    local selectedPath = currentDisplayItems[position + 1].filePath
    if playerState.currentSoundFilePath == selectedPath then
        PlaybackManager.togglePlayPause()
    else
        PlaybackManager.playSound(selectedPath)
    end
end

local function initialize()
    runOnUiThread(function()
        rootLayout = LinearLayout(context)
        rootLayout.setOrientation(LinearLayout.VERTICAL)
        rootLayout.setBackgroundColor(0xCC000000)

        local closeBtn = Button(context)
        closeBtn.setText("X CLOSE")
        closeBtn.setTextColor(Color.WHITE)
        closeBtn.setBackgroundColor(Color.parseColor("#FF8B0000"))
        closeBtn.setOnClickListener({
            onClick = function()
                mediaPlayer.stop()
                PlaybackManager.stopUpdateHandler()
                pcall(function() wm.removeView(rootLayout) end)
            end
        })
        rootLayout.addView(closeBtn)

        id_songName = TextView(context)
        id_songName.setText("Ready")
        id_songName.setTextSize(14)
        id_songName.setTextColor(Color.WHITE)
        id_songName.setGravity(Gravity.CENTER)
        id_songName.setPadding(0, 8, 0, 4)
        rootLayout.addView(id_songName)

        id_contador = TextView(context)
        id_contador.setText("Loading...")
        id_contador.setTextSize(10)
        id_contador.setTextColor(Color.GRAY)
        id_contador.setGravity(Gravity.CENTER)
        id_contador.setPadding(0, 0, 0, 6)
        rootLayout.addView(id_contador)

        local controlsLayout = LinearLayout(context)
        controlsLayout.setOrientation(LinearLayout.HORIZONTAL)
        controlsLayout.setGravity(Gravity.CENTER)
        controlsLayout.setPadding(5, 0, 5, 4)

        speedToggleButton = Button(context)
        speedToggleButton.setText("Speed")
        speedToggleButton.setTextSize(11)
        speedToggleButton.setOnClickListener({
            onClick = function(view) PlaybackManager.toggleSpeed(view) end
        })
        controlsLayout.addView(speedToggleButton)

        repeatToggleButton = Button(context)
        repeatToggleButton.setText("Repeat OFF")
        repeatToggleButton.setTextSize(11)
        repeatToggleButton.setOnClickListener({
            onClick = function(view) PlaybackManager.toggleRepeat(view) end
        })
        controlsLayout.addView(repeatToggleButton)
        rootLayout.addView(controlsLayout)

        local pitchLayout = LinearLayout(context)
        pitchLayout.setOrientation(LinearLayout.HORIZONTAL)
        pitchLayout.setGravity(Gravity.CENTER)
        pitchLayout.setPadding(10, 2, 10, 6)

        local pitchLabel = TextView(context)
        pitchLabel.setText("Pitch:")
        pitchLabel.setTextSize(11)
        pitchLabel.setTextColor(Color.WHITE)
        pitchLayout.addView(pitchLabel)

        pitchValueText = TextView(context)
        pitchValueText.setText("1.00x")
        pitchValueText.setTextSize(11)
        pitchValueText.setTextColor(Color.parseColor("#FFF9B947"))
        pitchValueText.setPadding(4, 0, 8, 0)
        pitchLayout.addView(pitchValueText)

        pitchSeekBar = SeekBar(context)
pitchSeekBar.setMax(20)
pitchSeekBar.setProgress(10)

local pitchSeekParams = LinearLayoutParams(
    0,
    LinearLayoutParams.WRAP_CONTENT,
    1
)
pitchSeekBar.setLayoutParams(pitchSeekParams)

pitchSeekBar.setOnSeekBarChangeListener({
    onProgressChanged = function(seekBar, progress, fromUser)
        local pitchValue = 0.8 + (progress * 0.02)
        pitchValue = math.floor(pitchValue * 100 + 0.5) / 100

        playerState.playbackPitch = pitchValue
        pitchValueText.setText(string.format("%.2fx", pitchValue))

        if fromUser then
            PlaybackManager.updatePlaybackParams()
        end
    end
})
        pitchLayout.addView(pitchSeekBar)
        rootLayout.addView(pitchLayout)

        listView = ListView(context)
        listView.setFastScrollEnabled(false)
        listView.setBackgroundColor(Color.BLACK)
        local listParams = LinearLayoutParams(LinearLayoutParams.MATCH_PARENT, 0, 1)
        listView.setLayoutParams(listParams)
        rootLayout.addView(listView)

        local playerControlsLayout = LinearLayout(context)
        playerControlsLayout.setOrientation(LinearLayout.VERTICAL)
        playerControlsLayout.setBackgroundColor(Color.parseColor("#FF202125"))
        playerControlsLayout.setPadding(10, 5, 10, 10)

        id_Progress = SeekBar(context)
        id_Progress.setLayoutParams(LinearLayoutParams(LinearLayoutParams.MATCH_PARENT, LinearLayoutParams.WRAP_CONTENT))
        playerControlsLayout.addView(id_Progress)

        local timeAndButtonsLayout = LinearLayout(context)
        timeAndButtonsLayout.setOrientation(LinearLayout.HORIZONTAL)
        timeAndButtonsLayout.setGravity(Gravity.CENTER)

        id_startTime = TextView(context)
        id_startTime.setText("00:00")
        id_startTime.setTextSize(12)
        id_startTime.setTextColor(Color.WHITE)
        timeAndButtonsLayout.addView(id_startTime)

        local prevBtn = Button(context)
        prevBtn.setText("|<")
        prevBtn.setTextSize(12)
        prevBtn.setOnClickListener({ onClick = function() PlaybackManager.playPrevious() end })
        timeAndButtonsLayout.addView(prevBtn)

        playPauseButton = Button(context)
        playPauseButton.setText("Play")
        playPauseButton.setTextSize(14)
        playPauseButton.setBackgroundColor(Color.parseColor("#FF00CC00"))
        playPauseButton.setTextColor(Color.WHITE)
        local playBtnParams = LinearLayoutParams(LinearLayoutParams.WRAP_CONTENT, LinearLayoutParams.WRAP_CONTENT)
        playBtnParams.setMargins(20, 0, 20, 0)
        playPauseButton.setLayoutParams(playBtnParams)
        playPauseButton.setOnClickListener({ onClick = function() PlaybackManager.togglePlayPause() end })
        timeAndButtonsLayout.addView(playPauseButton)

        local nextBtn = Button(context)
        nextBtn.setText(">|")
        nextBtn.setTextSize(12)
        nextBtn.setOnClickListener({ onClick = function() PlaybackManager.playNext() end })
        timeAndButtonsLayout.addView(nextBtn)

        id_endTime = TextView(context)
        id_endTime.setText("00:00")
        id_endTime.setTextColor(Color.WHITE)
        id_endTime.setTextSize(12)
        timeAndButtonsLayout.addView(id_endTime)

        playerControlsLayout.addView(timeAndButtonsLayout)
        rootLayout.addView(playerControlsLayout)

        local params = WindowManagerLayoutParams(
            WindowManagerLayoutParams.MATCH_PARENT,
            WindowManagerLayoutParams.MATCH_PARENT,
            getWindowType(),
            0x00000008,
            PixelFormat.TRANSLUCENT
        )
        params.gravity = Gravity.CENTER

        wm.addView(rootLayout, params)

        listView.onItemClick = handleItemClick

        if loadAllAudioFiles() then
            refreshListView()
            print("Loaded " .. #currentDisplayItems .. " audio files")
        end
    end)
end

initialize()