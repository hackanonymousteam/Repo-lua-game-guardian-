gg.setVisible(false)

if not activity then gg.alert("No activity") return end

local function bind(c)
    local ok, r = pcall(luajava.bindClass, c)
    if ok then return r end
    return nil
end

local LinearLayout = bind("android.widget.LinearLayout")
local Chronometer = bind("android.widget.Chronometer")
local Button = bind("android.widget.Button")
local SystemClock = bind("android.os.SystemClock")
local WindowManager = bind("android.view.WindowManager")
local PixelFormat = bind("android.graphics.PixelFormat")
local Gravity = bind("android.view.Gravity")
local Color = bind("android.graphics.Color")
local Build = bind("android.os.Build")

local function getType()
    if Build.VERSION.SDK_INT >= 26 then return 2038
    elseif Build.VERSION.SDK_INT >= 23 then return 2002
    else return 2003 end
end

local root = LinearLayout(activity)
root.setOrientation(1)
root.setPadding(40,40,40,40)
root.setBackgroundColor(0xCC000000)

local chrono = Chronometer(activity)

local btnStart = Button(activity)
btnStart.setText("Start")

local btnPause = Button(activity)
btnPause.setText("Pause")

local btnResume = Button(activity)
btnResume.setText("Resume")

local btnReset = Button(activity)
btnReset.setText("Reset")

local btnClose = Button(activity)
btnClose.setText("✕")

root.addView(chrono)
root.addView(btnStart)
root.addView(btnPause)
root.addView(btnResume)
root.addView(btnReset)
root.addView(btnClose)


local running = false
local pausedTime = 0

-- START
btnStart.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
    onClick = function(v)
        chrono.setBase(SystemClock.elapsedRealtime())
        chrono.start()
        running = true
        pausedTime = 0
        gg.toast("Started")
    end
}))

-- PAUSE
btnPause.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
    onClick = function(v)
        if running then
            pausedTime = SystemClock.elapsedRealtime() - chrono.getBase()
            chrono.stop()
            running = false
            gg.toast("Paused")
        end
    end
}))

-- RESUME
btnResume.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
    onClick = function(v)
        if not running and pausedTime > 0 then
            chrono.setBase(SystemClock.elapsedRealtime() - pausedTime)
            chrono.start()
            running = true
            gg.toast("Resumed")
        end
    end
}))

-- RESET
btnReset.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
    onClick = function(v)
        chrono.stop()
        chrono.setBase(SystemClock.elapsedRealtime())
        pausedTime = 0
        running = false
        gg.toast("Reset")
    end
}))

-- CLOSE
btnClose.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
    onClick = function(v)
        pcall(function()
            activity.getWindowManager().removeView(root)
        end)
    end
}))

local params = luajava.newInstance(
    "android.view.WindowManager$LayoutParams",
    -2,
    -2,
    getType(),
    0x00000008,
    PixelFormat.TRANSLUCENT
)

params.gravity = Gravity.CENTER

activity.runOnUiThread(luajava.createProxy("java.lang.Runnable", {
    run = function()
        activity.getWindowManager().addView(root, params)
    end
}))