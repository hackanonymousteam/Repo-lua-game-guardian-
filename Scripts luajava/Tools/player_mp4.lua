local File = luajava.bindClass("java.io.File")
local Uri = luajava.bindClass("android.net.Uri")
local VideoView = luajava.bindClass("android.widget.VideoView")
local MediaController = luajava.bindClass("android.widget.MediaController")
local LinearLayout = luajava.bindClass("android.widget.LinearLayout")
local TextView = luajava.bindClass("android.widget.TextView")
local Button = luajava.bindClass("android.widget.Button")
local ScrollView = luajava.bindClass("android.widget.ScrollView")
local WindowManager = luajava.bindClass("android.view.WindowManager")
local Gravity = luajava.bindClass("android.view.Gravity")
local Color = luajava.bindClass("android.graphics.Color")
local Context = luajava.bindClass("android.content.Context")
local MotionEvent = luajava.bindClass("android.view.MotionEvent")
local View = luajava.bindClass("android.view.View")
local Environment = luajava.bindClass("android.os.Environment")
local GradientDrawable = luajava.bindClass("android.graphics.drawable.GradientDrawable")
local Build = luajava.bindClass("android.os.Build")

local windowManager
local floatView
local menuView
local playerView
local videoList = {}
local mainView
local layout

function dp(value)
    return value * activity.getResources().getDisplayMetrics().density
end

function findVideos()
    videoList = {}
    local root = Environment.getExternalStorageDirectory():getAbsolutePath()
    
    local folders = {
        root .. "/Download",
        root .. "/DCIM",
        root .. "/Movies",
        root .. "/Video",
        root .. "/Videos",
        root .. "/WhatsApp/Media/WhatsApp Video",
        root .. "/Telegram/Telegram Video",
        root
    }
    
    for _, folder in ipairs(folders) do
        local dir = File(folder)
        if dir.exists() and dir.isDirectory() then
            local files = dir.listFiles()
            if files then
                for i = 0, files.length - 1 do
                    local file = files[i]
                    if file and file.isFile() then
                        local name = file.getName()
                        if name:lower():match("%.mp4$") then
                            table.insert(videoList, {
                                path = file.getAbsolutePath(),
                                name = name
                            })
                        end
                    end
                end
            end
        end
    end
    
    return #videoList
end

function createRoundButton(text, color, size)
    local btn = TextView(activity)
    btn.setText(text)
    btn.setTextSize(18)
    btn.setTextColor(Color.WHITE)
    btn.setGravity(Gravity.CENTER)
    
    local drawable = GradientDrawable()
    drawable.setShape(GradientDrawable.OVAL)
    drawable.setColor(color)
    if Build.VERSION.SDK_INT >= 16 then
        btn.setBackground(drawable)
    end
    
    btn.setLayoutParams(LinearLayout.LayoutParams(dp(size), dp(size)))
    return btn
end

function createFloatButton()
    return createRoundButton("🎬", Color.parseColor("#FF4444"), 55)
end

function createMenu()
    local layout = LinearLayout(activity)
    layout.setOrientation(LinearLayout.VERTICAL)
    layout.setBackgroundColor(Color.parseColor("#2C3E50"))
    layout.setPadding(dp(20), dp(20), dp(20), dp(20))
    
    local title = TextView(activity)
    title.setText("MP4 PLAYER")
    title.setTextColor(Color.WHITE)
    title.setTextSize(20)
    title.setGravity(Gravity.CENTER)
    title.setPadding(0, 0, 0, dp(20))
    layout.addView(title)
    
    local scanBtn = Button(activity)
    scanBtn.setText("🔍 SCAN VIDEOS")
    scanBtn.setTextColor(Color.WHITE)
    scanBtn.setBackgroundColor(Color.parseColor("#4CAF50"))
    scanBtn.setLayoutParams(LinearLayout.LayoutParams(
        LinearLayout.LayoutParams.MATCH_PARENT,
        dp(50)
    ))
    scanBtn.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
        onClick = function()
            local total = findVideos()
            
            local msg = TextView(activity)
            msg.setText("Found: " .. total .. " videos")
            msg.setTextColor(Color.YELLOW)
            msg.setPadding(0, dp(10), 0, dp(10))
            layout.addView(msg)
            
            if total > 0 then
                local scroll = ScrollView(activity)
                scroll.setLayoutParams(LinearLayout.LayoutParams(
                    LinearLayout.LayoutParams.MATCH_PARENT,
                    dp(300)
                ))
                
                local listLayout = LinearLayout(activity)
                listLayout.setOrientation(LinearLayout.VERTICAL)
                
                for i, video in ipairs(videoList) do
                    local item = Button(activity)
                    item.setText(i .. ". " .. video.name)
                    item.setTextColor(Color.WHITE)
                    item.setBackgroundColor(Color.parseColor("#34495E"))
                    item.setPadding(dp(10), dp(10), dp(10), dp(10))
                    item.setLayoutParams(LinearLayout.LayoutParams(
                        LinearLayout.LayoutParams.MATCH_PARENT,
                        dp(50)
                    ))
                    
                    local params = item.getLayoutParams()
                    params.bottomMargin = dp(5)
                    
                    item.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
                        onClick = function()
                            playVideo(video.path, video.name)
                        end
                    }))
                    
                    listLayout.addView(item)
                end
                
                scroll.addView(listLayout)
                layout.addView(scroll)
            end
        end
    }))
    layout.addView(scanBtn)
    
    local exitBtn = Button(activity)
    exitBtn.setText("❌ CLOSE PLAYER")
    exitBtn.setTextColor(Color.WHITE)
    exitBtn.setBackgroundColor(Color.parseColor("#E74C3C"))
    exitBtn.setLayoutParams(LinearLayout.LayoutParams(
        LinearLayout.LayoutParams.MATCH_PARENT,
        dp(50)
    ))
    exitBtn.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
        onClick = function()
            if windowManager and mainView then
                windowManager.removeView(mainView)
            end
        end
    }))
    layout.addView(exitBtn)
    
    return layout
end

function playVideo(path, name)
    activity.runOnUiThread(luajava.createProxy("java.lang.Runnable", {
        run = function()
            if playerView then
                playerView.removeAllViews()
            end
            
            local container = LinearLayout(activity)
            container.setOrientation(LinearLayout.VERTICAL)
            container.setBackgroundColor(Color.BLACK)
            container.setLayoutParams(LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.MATCH_PARENT
            ))
            
            local video = VideoView(activity)
            video.setLayoutParams(LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
--LinearLayout.LayoutParams.MATCH_PARENT
                dp(450)
            ))
            
            local controls = MediaController(activity)
            video.setMediaController(controls)
            
            local videoFile = File(path)
            if videoFile.exists() then
                video.setVideoURI(Uri.fromFile(videoFile))
                video.start()
                
                local title = TextView(activity)
                title.setText("▶ " .. name)
                title.setTextColor(Color.WHITE)
                title.setPadding(dp(10), dp(5), dp(10), dp(5))
                
                container.addView(video)
                container.addView(title)
                
                local closeBtn = Button(activity)
                closeBtn.setText("CLOSE")
                closeBtn.setTextColor(Color.WHITE)
                closeBtn.setBackgroundColor(Color.RED)
                closeBtn.setLayoutParams(LinearLayout.LayoutParams(
                    LinearLayout.LayoutParams.MATCH_PARENT,
                    dp(50)
                ))
                closeBtn.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
                    onClick = function()
                        video.stopPlayback()
                        playerView.setVisibility(View.GONE)
                        floatView.setVisibility(View.VISIBLE)
                    end
                }))
                container.addView(closeBtn)
                
                playerView.addView(container)
                playerView.setVisibility(View.VISIBLE)
                floatView.setVisibility(View.GONE)
                menuView.setVisibility(View.GONE)
            end
        end
    }))
end

activity.runOnUiThread(luajava.createProxy("java.lang.Runnable", {
    run = function()
        windowManager = activity.getSystemService(Context.WINDOW_SERVICE)
        
        layout = WindowManager.LayoutParams(
            dp(350), dp(550),
            WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY,
            WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE,
            -3
        )
        layout.gravity = Gravity.TOP + Gravity.LEFT
        layout.x = 50
        layout.y = 100
        
        mainView = LinearLayout(activity)
        mainView.setOrientation(LinearLayout.VERTICAL)
        
        floatView = createFloatButton()
        
        menuView = createMenu()
        menuView.setVisibility(View.GONE)
        
        playerView = LinearLayout(activity)
        playerView.setLayoutParams(LinearLayout.LayoutParams(
            LinearLayout.LayoutParams.MATCH_PARENT,
            LinearLayout.LayoutParams.MATCH_PARENT
        ))
        playerView.setVisibility(View.GONE)
        
        mainView.addView(floatView)
        mainView.addView(menuView)
        mainView.addView(playerView)
        
        floatView.setOnTouchListener(luajava.createProxy("android.view.View$OnTouchListener", {
            onTouch = function(v, event)
                if event.getAction() == MotionEvent.ACTION_UP then
                    menuView.setVisibility(View.VISIBLE)
                    floatView.setVisibility(View.GONE)
                elseif event.getAction() == MotionEvent.ACTION_DOWN then
                    ultX = layout.x
                    ultY = layout.y
                    iniX = event.getRawX()
                    iniY = event.getRawY()
                elseif event.getAction() == MotionEvent.ACTION_MOVE then
                    layout.x = ultX + (event.getRawX() - iniX)
                    layout.y = ultY + (event.getRawY() - iniY)
                    windowManager.updateViewLayout(mainView, layout)
                end
                return true
            end
        }))
        
        windowManager.addView(mainView, layout)
    end
}))

gg.setVisible(false)
while true do
    gg.sleep(1000)
end