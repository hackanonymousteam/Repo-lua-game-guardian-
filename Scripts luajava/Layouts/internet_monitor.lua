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

local TextView = bind("android.widget.TextView")
local Handler = bind("android.os.Handler")
local Looper = bind("android.os.Looper")
local Runnable = bind("java.lang.Runnable")
local TrafficStats = bind("android.net.TrafficStats")
local Color = bind("android.graphics.Color")
local tv = TextView(activity)

tv.setTextColor(Color.WHITE)
tv.setTextSize(18)
tv.setBackgroundColor(0xAA000000)
tv.setPadding(20,20,20,20)


local handler = Handler(Looper.getMainLooper())

local lastRx = TrafficStats.getTotalRxBytes()
local lastTx = TrafficStats.getTotalTxBytes()

local download = 0
local upload = 0

local function format(speed)
    if speed > 1024 * 1024 then
        return string.format("%.2f MB/s", speed / (1024 * 1024))
    elseif speed > 1024 then
        return string.format("%.2f KB/s", speed / 1024)
    else
        return string.format("%.2f B/s", speed)
    end
end

local function update()
    local rx = TrafficStats.getTotalRxBytes()
    local tx = TrafficStats.getTotalTxBytes()

    download = (rx - lastRx) / 2
    upload = (tx - lastTx) / 2

    lastRx = rx
    lastTx = tx

    tv.setText("Download: " .. format(download) .. "\nUpload: " .. format(upload))

    handler.postDelayed(luajava.createProxy("java.lang.Runnable", {
        run = update
    }), 2000)
end

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
wm.addView(tv, params)

        update()
        
    end
}))