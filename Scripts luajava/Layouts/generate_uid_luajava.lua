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
local SettingsSecure = bind("android.provider.Settings$Secure")
local UUID = bind("java.util.UUID")
local String = bind("java.lang.String")

local function getType()
    if Build.VERSION.SDK_INT >= 26 then
        return 2038
    elseif Build.VERSION.SDK_INT >= 23 then
        return 2002
    else
        return 2003
    end
end

local function UserInterface()
    local face = Build.MANUFACTURER
    local mode = Build.MODEL
    if string.sub(mode, 1, string.len(face)) == face then
        return mode
    else
        return face .. " " .. mode
    end
end

local function GetInterface()
    local resolver = activity.getContentResolver()
    local android_id = SettingsSecure.getString(resolver, SettingsSecure.ANDROID_ID)

    local x = UserInterface() .. android_id .. Build.HARDWARE
    x = string.gsub(x, " ", "")

    local bytes = String(x).getBytes()
    local uuid = UUID.nameUUIDFromBytes(bytes).toString()
    uuid = string.gsub(uuid, "-", "")

    return uuid
end

local layout = LinearLayout(activity)
layout.setOrientation(1)
layout.setPadding(40,40,40,40)
layout.setBackgroundColor(0xCC000000)

local spinner = Spinner(activity)
local ArrayList = bind("java.util.ArrayList")

local items = ArrayList()
items.add("Show Device Name")
items.add("Generate ID")
items.add("Batman Mode 😎")

local adapter = ArrayAdapter(
    activity,
    android.R.layout.simple_spinner_item,
    items
)

adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item)
spinner.setAdapter(adapter)

local btn = Button(activity)
btn.setText("EXEC")

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

                if value == "Show Device Name" then
                    gg.toast(UserInterface())
                elseif value == "Generate ID" then
                    gg.toast(GetInterface())
                else
                    gg.toast("Batman Mode Activated 😎")
                end

                pcall(function()
                    wm.removeView(layout)
                end)
            end
        }))
    end
}))