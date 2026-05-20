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

local ProgressBar = bind("android.widget.ProgressBar")
local WindowManager = bind("android.view.WindowManager")
local PixelFormat = bind("android.graphics.PixelFormat")
local Gravity = bind("android.view.Gravity")
local Build = bind("android.os.Build")
local Handler = bind("android.os.Handler")
local Looper = bind("android.os.Looper")

local function getType()
    if Build.VERSION.SDK_INT >= 26 then
        return 2038
    elseif Build.VERSION.SDK_INT >= 23 then
        return 2002
    else
        return 2003
    end
end

local view = ProgressBar(activity)
view.setIndeterminate(true)

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
        local wm = activity.getWindowManager()

        wm.addView(view, params)
    local handler = Handler(Looper.getMainLooper())
        handler.postDelayed(luajava.createProxy("java.lang.Runnable", {
            run = function()
                pcall(function()
                    wm.removeView(view)
                end)
               -- gg.toast("Finished")
            end
        }), 5000)
    end
}))