gg.setVisible(false)

if not activity then gg.alert("No activity") return end

local function bind(c)
    local ok, r = pcall(luajava.bindClass, c)
    if ok then return r end
    return nil
end

local LinearLayout = bind("android.widget.LinearLayout")
local NumberPicker = bind("android.widget.NumberPicker")
local Button = bind("android.widget.Button")
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

local np = NumberPicker(activity)
np.setMinValue(1)
np.setMaxValue(10)

local ok = Button(activity)
ok.setText("OK")

local close = Button(activity)
close.setText("✕")

root.addView(np)
root.addView(ok)
root.addView(close)

ok.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
    onClick = function(v)
        local val = np.getValue()
        gg.toast("Selected: "..val)
    end
}))

close.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
    onClick = function(v)
        pcall(function()
            activity.getWindowManager().removeView(root)
        end)
    end
}))

local params = luajava.newInstance("android.view.WindowManager$LayoutParams",-2,-2,getType(),0x00000008,PixelFormat.TRANSLUCENT)
params.gravity = Gravity.CENTER

activity.runOnUiThread(luajava.createProxy("java.lang.Runnable", {
    run = function()
        activity.getWindowManager().addView(root, params)
    end
}))