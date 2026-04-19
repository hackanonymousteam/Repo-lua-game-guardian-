
gg.setVisible(false)
if luajava == nil then gg.alert(' unavaliable please use gameguardian mod (suport luajava)') else end

if not activity then
    gg.alert("No activity")
    return
end

local function bind(c)
    local ok, r = pcall(luajava.bindClass, c)
    if ok then return r end
    return nil
end

local TextView = bind("android.widget.TextView")
local WindowManager = bind("android.view.WindowManager")
local PixelFormat = bind("android.graphics.PixelFormat")
local Gravity = bind("android.view.Gravity")
local Color = bind("android.graphics.Color")
local Build = bind("android.os.Build")

local function getType()
    if Build.VERSION.SDK_INT >= 26 then
        return 2038
    elseif Build.VERSION.SDK_INT >= 23 then
        return 2002
    else
        return 2003
    end
end
local Button = bind("android.widget.Button")
local Handler = bind("android.os.Handler")
local Looper = bind("android.os.Looper")
local Runnable = bind("java.lang.Runnable")

local btn = Button(activity)
btn.setText("FPS: 0")

local handler = Handler(Looper.getMainLooper())

local frameCount = 0
local lastTime = 0

local running = true

local function fakeFrameLoop()
    if not running then return end

    frameCount = frameCount + 1

    handler.postDelayed(luajava.createProxy("java.lang.Runnable", {
        run = fakeFrameLoop
    }), 16) -- ~60fps
end

local function fpsUpdater()
    if not running then return end

    local now = os.time() * 1000
    local elapsed = now - lastTime

    if elapsed > 0 then
        local fps = math.floor(frameCount * 1000 / elapsed)
        btn.setText("FPS: " .. fps)
    end

    frameCount = 0
    lastTime = now

    handler.postDelayed(luajava.createProxy("java.lang.Runnable", {
        run = fpsUpdater
    }), 1000)
end

-- start
lastTime = os.time() * 1000
fakeFrameLoop()
fpsUpdater()

local params = luajava.newInstance(
    "android.view.WindowManager$LayoutParams",
    -2,
    -2,
    getType(),
    0x00000008,
    PixelFormat.TRANSLUCENT
)

params.gravity = Gravity.TOP + Gravity.LEFT
params.x = 100
params.y = 200


activity.runOnUiThread(luajava.createProxy("java.lang.Runnable", {
    run = function()
        local wm = activity.getWindowManager()
wm.addView(btn, params)
        loop()
        
    end
}))



