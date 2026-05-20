gg.setVisible(false)

if not activity then gg.alert("No activity") return end

local function bind(c)
    local ok, r = pcall(luajava.bindClass, c)
    if ok then return r end
    return nil
end

local LinearLayout = bind("android.widget.LinearLayout")
local ImageSwitcher = bind("android.widget.ImageSwitcher")
local ImageView = bind("android.widget.ImageView")
local Button = bind("android.widget.Button")
local WindowManager = bind("android.view.WindowManager")
local PixelFormat = bind("android.graphics.PixelFormat")
local Gravity = bind("android.view.Gravity")
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

local switcher = ImageSwitcher(activity)


switcher.setFactory(luajava.createProxy("android.widget.ViewSwitcher$ViewFactory", {
    makeView = function()
        local img = ImageView(activity)
        return img
    end
}))


local icons = {
 android.R.drawable.ic_menu_manage,
android.R.drawable.ic_menu_preferences,
android.R.drawable.ic_menu_edit,
android.R.drawable.ic_menu_save,
android.R.drawable.ic_menu_delete,
android.R.drawable.ic_menu_search
}

local index = 0
switcher.setImageResource(icons[index + 1])

local btn = Button(activity)
btn.setText("Next")

local close = Button(activity)
close.setText("✕")

root.addView(switcher)
root.addView(btn)
root.addView(close)

btn.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
    onClick = function(v)
        index = (index + 1) % #icons
        switcher.setImageResource(icons[index + 1])
        gg.toast("Changed image")
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