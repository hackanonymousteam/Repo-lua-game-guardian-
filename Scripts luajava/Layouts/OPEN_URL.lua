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

local LinearLayout = bind("android.widget.LinearLayout")
local Spinner = bind("android.widget.Spinner")
local Button = bind("android.widget.Button")
local ArrayAdapter = bind("android.widget.ArrayAdapter")
local WindowManager = bind("android.view.WindowManager")
local PixelFormat = bind("android.graphics.PixelFormat")
local Gravity = bind("android.view.Gravity")
local Build = bind("android.os.Build")
local Uri = bind("android.net.Uri")
local Intent = bind("android.content.Intent")

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

items.add("channe 1")
items.add("channel 2")
items.add("channel 3")
items.add("contact private")

local adapter = ArrayAdapter(
    activity,
    android.R.layout.simple_spinner_item,
    items
)

adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item)
spinner.setAdapter(adapter)

local btn = Button(activity)
btn.setText("OPEN")

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

                local url = nil

                if pos == 0 then
                    url = "https://t.me/batmangamesSS"
                elseif pos == 1 then
                    url = "https://t.me/share_scripts_lua_GG"
                elseif pos == 2 then
                    url = "https://t.me/+K5gDLYipi_5jOTcx"
                else
                    url = "https://t.me/batmangamesS"
                end

                local intent = Intent(Intent.ACTION_VIEW)
                intent.setData(Uri.parse(url))

                activity.startActivity(intent)

                pcall(function()
                    wm.removeView(layout)
                end)
            end
        }))
    end
}))