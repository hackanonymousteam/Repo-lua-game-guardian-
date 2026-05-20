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
local Color = bind("android.graphics.Color")

local LinearLayout = bind("android.widget.LinearLayout")
local TimePicker = bind("android.widget.TimePicker")
local Button = bind("android.widget.Button")
local WindowManager = bind("android.view.WindowManager")
local PixelFormat = bind("android.graphics.PixelFormat")
local Gravity = bind("android.view.Gravity")
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

local layout = LinearLayout(activity)
layout.setOrientation(1)
layout.setPadding(30,30,30,30)
layout.setBackgroundColor(Color.parseColor("#141414"))
     
local picker = TimePicker(activity)
picker.setIs24HourView(true)

local btn = Button(activity)
btn.setText("OK")

layout.addView(picker)
layout.addView(btn)

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
        wm.addView(layout, params)

        btn.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
            onClick = function(v)
                local hour = picker.getHour()
                local minute = picker.getMinute()

                gg.toast("Time: " .. hour .. ":" .. minute)

                pcall(function()
                    wm.removeView(layout)
                end)
            end
        }))
    end
}))