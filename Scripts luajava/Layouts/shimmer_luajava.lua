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
local TextView = bind("android.widget.TextView")
local ArrayAdapter = bind("android.widget.ArrayAdapter")

local ColorDrawable = bind("android.graphics.drawable.ColorDrawable")
local WindowManager = bind("android.view.WindowManager")
local PixelFormat = bind("android.graphics.PixelFormat")
local Gravity = bind("android.view.Gravity")
local Build = bind("android.os.Build")

local ValueAnimator = bind("android.animation.ValueAnimator")
local ArgbEvaluator = bind("android.animation.ArgbEvaluator")


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
layout.setPadding(40, 40, 40, 40)

local bgColors = {

    0xFF00C2FF, -- cyan vivo controlado
    0xFF6A5CFF, -- roxo equilibrado
    0xFFFF3D8D, -- pink forte
    0xFF00C853, -- verde vivo
    0xFFFFB300  -- âmbar limpo
}
local bgAnimator = ValueAnimator.ofInt(table.unpack(bgColors))
bgAnimator.setEvaluator(ArgbEvaluator())
bgAnimator.setDuration(3000)
bgAnimator.setRepeatCount(ValueAnimator.INFINITE)
bgAnimator.setRepeatMode(ValueAnimator.RESTART)

bgAnimator.addUpdateListener(luajava.createProxy(
"android.animation.ValueAnimator$AnimatorUpdateListener",
{
    onAnimationUpdate = function(a)
        local color = a.getAnimatedValue()
        layout.setBackgroundColor(color)
    end
}))

local title = TextView(activity)
title.setText("BATMAN MODE ACTIVE")
title.setTextSize(18)
title.setGravity(Gravity.CENTER)

local textColors = {
    0xFF6EE7F9, -- azul-ciano suave
    0xFF8B5CF6, -- roxo moderno
    0xFFEC4899, -- pink suave
    0xFFF59E0B, -- âmbar elegante
    0xFF10B981, -- verde esmeralda
    0xFF3B82F6, -- azul limpo
    0xFFA78BFA  -- lavanda
}
local textAnimator = ValueAnimator.ofInt(table.unpack(textColors))
textAnimator.setEvaluator(ArgbEvaluator())
textAnimator.setDuration(2000)
textAnimator.setRepeatCount(ValueAnimator.INFINITE)
textAnimator.setRepeatMode(ValueAnimator.RESTART)

textAnimator.addUpdateListener(luajava.createProxy(
"android.animation.ValueAnimator$AnimatorUpdateListener",
{
    onAnimationUpdate = function(a)
        title.setTextColor(a.getAnimatedValue())
    end
}))

local spinner = Spinner(activity)
local ArrayList = bind("java.util.ArrayList")
local items = ArrayList()

items.add("Option 1")
items.add("Option 2")
items.add("Option 3")
items.add("Batman Mode 😎")

local adapter = ArrayAdapter(activity,
    android.R.layout.simple_spinner_item,
    items
)

adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item)
spinner.setAdapter(adapter)

local btn = Button(activity)
btn.setText("OK")

layout.addView(title)
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

 bgAnimator.start()
        textAnimator.start()

        btn.setOnClickListener(luajava.createProxy(
        "android.view.View$OnClickListener",
        {
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