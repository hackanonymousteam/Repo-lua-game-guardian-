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
local Spinner = bind("android.widget.Spinner")
local Button = bind("android.widget.Button")
local ArrayAdapter = bind("android.widget.ArrayAdapter")
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

local layout = LinearLayout(activity)
layout.setOrientation(1)
layout.setPadding(40,40,40,40)
layout.setBackgroundColor(0xCC000000) 


local spinner = Spinner(activity)

local ArrayList = bind("java.util.ArrayList")

local items = ArrayList()
items.add("Option 1")
items.add("Option 2")
items.add("Option 3")
items.add("Batman Mode 😎")


local adapter = ArrayAdapter(
    activity,
    android.R.layout.simple_spinner_item,
    items
)

adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item)
spinner.setAdapter(adapter)


local btn = Button(activity)
btn.setText("OK")

layout.addView(spinner)
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
                local pos = spinner.getSelectedItemPosition()
                local value = items.get(pos)
                gg.toast("Selected: " .. value)

                pcall(function()
                    wm.removeView(layout)
                end)
            end
        }))
    end
}))