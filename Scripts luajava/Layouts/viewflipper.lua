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
local ViewFlipper = bind("android.widget.ViewFlipper")
local Button = bind("android.widget.Button")
local TextView = bind("android.widget.TextView")
local SeekBar = bind("android.widget.SeekBar")
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

local root = LinearLayout(activity)
root.setOrientation(1)
root.setPadding(30,30,30,30)
root.setBackgroundColor(0xCC000000)


local btnClose = Button(activity)
btnClose.setText("✕")
btnClose.setTextColor(Color.WHITE)


local flipper = ViewFlipper(activity)


local page1 = LinearLayout(activity)
page1.setOrientation(1)

local title1 = TextView(activity)
title1.setText("Actions")
title1.setTextColor(Color.WHITE)

local btnA = Button(activity)
btnA.setText("Run A")

local btnB = Button(activity)
btnB.setText("Run B")

local next1 = Button(activity)
next1.setText("Next ▶")

page1.addView(title1)
page1.addView(btnA)
page1.addView(btnB)
page1.addView(next1)


btnA.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
    onClick = function(v)
        gg.toast("Action A executed")
    end
}))

btnB.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
    onClick = function(v)
        gg.toast("Action B executed")
    end
}))


local page2 = LinearLayout(activity)
page2.setOrientation(1)

local title2 = TextView(activity)
title2.setText("Control")
title2.setTextColor(Color.WHITE)

local valueText = TextView(activity)
valueText.setText("Value: 0")
valueText.setTextColor(Color.WHITE)

local seek = SeekBar(activity)
seek.setMax(100)

local back2 = Button(activity)
back2.setText("◀ Back")

page2.addView(title2)
page2.addView(valueText)
page2.addView(seek)
page2.addView(back2)


seek.setOnSeekBarChangeListener(luajava.createProxy("android.widget.SeekBar$OnSeekBarChangeListener", {
    onProgressChanged = function(sb, progress, fromUser)
        valueText.setText("Value: " .. progress)
    end,
    onStartTrackingTouch = function(sb) end,
    onStopTrackingTouch = function(sb)
        gg.toast("Final: " .. sb.getProgress())
    end
}))


next1.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
    onClick = function(v)
        flipper.showNext()
    end
}))

back2.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
    onClick = function(v)
        flipper.showPrevious()
    end
}))


btnClose.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
    onClick = function(v)
        pcall(function()
            local wm = activity.getWindowManager()
            wm.removeView(root)
        end)
        gg.toast("Closed")
    end
}))


flipper.addView(page1)
flipper.addView(page2)

root.addView(btnClose)
root.addView(flipper)

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
        wm.addView(root, params)
    end
}))