gg.setVisible(false)

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
local Handler = bind("android.os.Handler")
local Button = bind("android.widget.Button")
local LinearLayout = bind("android.widget.LinearLayout")
local Looper = bind("android.os.Looper")
local System = bind("java.lang.System")
local Runtime = bind("java.lang.Runtime")

local function getType()
    if Build.VERSION.SDK_INT >= 26 then
        return 2038
    elseif Build.VERSION.SDK_INT >= 23 then
        return 2002
    else
        return 2003
    end
end

local function freeMemory()
    System.runFinalization()
    Runtime.getRuntime():gc()
    System.gc()
end

local function getMemoryInfo()
    local runtime = Runtime.getRuntime()
    local totalMemory = runtime:totalMemory() / (1024 * 1024)
    local freeMemory = runtime:freeMemory() / (1024 * 1024)
    local usedMemory = totalMemory - freeMemory
    local maxMemory = runtime:maxMemory() / (1024 * 1024)
    
    return string.format(
        "Total Memory: %.1f MB\n" ..
        "Used Memory: %.1f MB\n" ..
        "Free Memory: %.1f MB\n" ..
        "Max Memory: %.1f MB",
        totalMemory, usedMemory, freeMemory, maxMemory
    )
end

local function createLayout(act)
    local mHandler = Handler(Looper.getMainLooper())
    
    local layout = LinearLayout(act)
    layout.setOrientation(LinearLayout.VERTICAL)
    layout.setBackgroundColor(Color.parseColor("#FF1A1A1A"))
    layout.setPadding(40, 40, 40, 40)

    local titleView = TextView(act)
    titleView.setText("MEMORY CLEANER")
    titleView.setTextColor(Color.parseColor("#FF00E5FF"))
    titleView.setTextSize(18)
    titleView.setPadding(10, 10, 10, 20)
    titleView.setGravity(Gravity.CENTER)
    layout.addView(titleView)

    local memoryStatus = TextView(act)
    memoryStatus.setText(getMemoryInfo())
    memoryStatus.setTextColor(Color.parseColor("#FFB0BEC5"))
    memoryStatus.setTextSize(14)
    memoryStatus.setPadding(20, 20, 20, 20)
    memoryStatus.setBackgroundColor(Color.parseColor("#FF263238"))
    memoryStatus.setGravity(Gravity.CENTER)
    layout.addView(memoryStatus)

    local spacer1 = TextView(act)
    spacer1.setHeight(20)
    layout.addView(spacer1)

    local freeButton = Button(act)
    freeButton.setText("FREE MEMORY")
    freeButton.setTextColor(Color.WHITE)
    freeButton.setBackgroundColor(Color.parseColor("#FF00C853"))
    freeButton.setPadding(30, 20, 30, 20)
    freeButton.setTextSize(16)
    freeButton.setAllCaps(false)
    layout.addView(freeButton)

    local spacer2 = TextView(act)
    spacer2.setHeight(15)
    layout.addView(spacer2)

    local refreshButton = Button(act)
    refreshButton.setText("REFRESH")
    refreshButton.setTextColor(Color.WHITE)
    refreshButton.setBackgroundColor(Color.parseColor("#FF448AFF"))
    refreshButton.setPadding(30, 20, 30, 20)
    refreshButton.setTextSize(16)
    refreshButton.setAllCaps(false)
    layout.addView(refreshButton)

    local spacer3 = TextView(act)
    spacer3.setHeight(15)
    layout.addView(spacer3)

    local closeButton = Button(act)
    closeButton.setText("CLOSE")
    closeButton.setTextColor(Color.WHITE)
    closeButton.setBackgroundColor(Color.parseColor("#FFFF1744"))
    closeButton.setPadding(30, 20, 30, 20)
    closeButton.setTextSize(16)
    closeButton.setAllCaps(false)
    layout.addView(closeButton)
    
    local function updateMemoryStatus()
        memoryStatus.setText(getMemoryInfo())
    end
    
    return layout, freeButton, refreshButton, closeButton, updateMemoryStatus
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
params.x = 50
params.y = 200

activity.runOnUiThread(luajava.createProxy("java.lang.Runnable", {
    run = function()
        local layout, freeButton, refreshButton, closeButton, updateMemoryStatus = createLayout(activity)
        
        local wm = activity.getWindowManager()
        wm.addView(layout, params)

        freeButton.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
            onClick = function(v)
                gg.toast("Freeing memory...")
                freeMemory()
                updateMemoryStatus()
                gg.toast("Memory freed successfully!")
            end
        }))

        refreshButton.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
            onClick = function(v)
                updateMemoryStatus()
                gg.toast("Status updated!")
            end
        }))

        closeButton.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
            onClick = function(v)
                wm.removeView(layout)
                gg.toast("Closed!")
            end
        }))

        gg.toast("Memory Panel Opened!")
    end
}))