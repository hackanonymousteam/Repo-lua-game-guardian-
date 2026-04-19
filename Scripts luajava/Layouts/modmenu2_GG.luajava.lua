gg.setVisible(false)

if luajava == nil then gg.alert(' unavaliable please use gameguardian mod (suport luajava)') else end

if not activity then
    gg.alert("No activity available")
    return
end

local function bind(c)
    local ok, r = pcall(luajava.bindClass, c)
    if ok then return r end
    return nil
end

local LinearLayout = bind("android.widget.LinearLayout")
local Button = bind("android.widget.Button")
local TextView = bind("android.widget.TextView")
local WindowManager = bind("android.view.WindowManager")
local PixelFormat = bind("android.graphics.PixelFormat")
local Gravity = bind("android.view.Gravity")
local Color = bind("android.graphics.Color")
local Build = bind("android.os.Build")
local ViewGroup = bind("android.view.ViewGroup")
local GradientDrawable = bind("android.graphics.drawable.GradientDrawable")
local Typeface = bind("android.graphics.Typeface")
local AnimatorSet = bind("android.animation.AnimatorSet")
local ObjectAnimator = bind("android.animation.ObjectAnimator")
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
local DisplayMetrics = bind("android.util.DisplayMetrics")

local metrics = DisplayMetrics()
activity.getWindowManager().getDefaultDisplay().getMetrics(metrics)

local density = metrics.density
local screenWidth = metrics.widthPixels
local screenHeight = metrics.heightPixels

local function dp(value)
    return math.floor(value * density)
end


function fxButton(btn, type)

    local GradientDrawable = bind("android.graphics.drawable.GradientDrawable")
    local StateListDrawable = bind("android.graphics.drawable.StateListDrawable")
    local Color = bind("android.graphics.Color")

    local colors = {
god    = "#B000FF", -- roxo neon
ammo   = "#7B2F9D", -- roxo médio
speed  = "#9D4EDD", -- lavanda vibrante
health = "#C77DFF", -- roxo claro
kill   = "#E0AAFF", -- lilás
money  = "#FF0A6C", -- rosa neon
close  = "#0D0D1A"  -- preto azulado    }
}
    local color = colors[type] or "#333333"

    local normal = GradientDrawable()
    normal.setColor(Color.parseColor(color))
    normal.setCornerRadius(14)

    local pressed = GradientDrawable()
    pressed.setColor(0xFF1A1A1A)
    pressed.setCornerRadius(14)

    local states = StateListDrawable()
    states.addState({-16842919}, normal)
    states.addState({16842919}, pressed)

    btn.setBackgroundDrawable(states)

    btn.setTextColor(0xFFFFFFFF)
    btn.setAllCaps(false)
    btn.setPadding(25, 0, 25, 0)
end

local LinearGradient = bind("android.graphics.LinearGradient")
local ShaderTileMode = bind("android.graphics.Shader$TileMode")
local Matrix = bind("android.graphics.Matrix")
local ValueAnimator = bind("android.animation.ValueAnimator")
local View = bind("android.view.View")



local isMenuVisible = false
local isDragging = false
local dragStartX = 0
local dragStartY = 0
local initialWindowX = 0
local initialWindowY = 0

activity.runOnUiThread(luajava.createProxy("java.lang.Runnable", {
    run = function()
        local border = GradientDrawable()
        border.setCornerRadius(20)
border.setStroke(2, Color.parseColor("#505050"))
       -- border.setStroke(2, Color.parseColor("#2A2A2A"))
     --   border.setStroke(2, Color.parseColor("#404040"))
        border.setColor(Color.parseColor("#0F0F0F"))
        
        
        
        local layout = LinearLayout(activity)
        layout.setOrientation(LinearLayout.VERTICAL)
        layout.setBackgroundDrawable(border)
        layout.setPadding(dp(12), dp(12), dp(12), dp(12))




local params = LinearLayout.LayoutParams(
    ViewGroup.LayoutParams.MATCH_PARENT,
    dp(50)
)
        
        layout.setElevation(8)
        
        
        
        
        local headerBg = GradientDrawable()
        headerBg.setCornerRadius(15)
        headerBg.setColor(Color.parseColor("#1A1A1A"))
        
        local header = LinearLayout(activity)
        header.setOrientation(LinearLayout.VERTICAL)
        header.setBackgroundDrawable(headerBg)
        header.setPadding(20, 15, 20, 15)
        
        local title = TextView(activity)
        title.setText("✦ MOD MENU ✦")
        title.setTextColor(Color.parseColor("#E0E0E0"))
        title.setTextSize(16)
        title.setTypeface(Typeface.DEFAULT_BOLD)
        
        title.setGravity(Gravity.CENTER)
        title.setPadding(0, 0, 0, 5)

        local subtitle = TextView(activity)
        subtitle.setText("drag to move")
        subtitle.setTextColor(Color.parseColor("#666666"))
        subtitle.setTextSize(10)
        subtitle.setGravity(Gravity.CENTER)
        
        header.addView(title)
        
        
        header.addView(subtitle)
        layout.addView(header)
        
        local function createButton(text, bgColor)
            local btn = Button(activity)
            btn.setText(text)
            btn.setTextColor(Color.parseColor("#FFFFFF"))
            btn.setAllCaps(false)
            btn.setTypeface(Typeface.DEFAULT)
            btn.setTextSize(13)
            
            local btnBg = GradientDrawable()
            btnBg.setCornerRadius(10)
            btnBg.setColor(Color.parseColor(bgColor))
            btn.setBackgroundDrawable(btnBg)
            
            local params = LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                90
            )
            params.topMargin = 8
            btn.setLayoutParams(params)
            btn.setPadding(20, 0, 20, 0)
            btn.setGravity(Gravity.CENTER_VERTICAL + Gravity.START)
            
            return btn
        end
        
        local btn1 = createButton("⚔️  GOD MODE", "#2E7D32")
local btn2 = createButton("🎯  UNLIMITED AMMO", "#1565C0")
local btn3 = createButton("⚡  SPEED HACK", "#EF6C00")
local btn4 = createButton("❤️  INFINITE HEALTH", "#C62828")
local btn5 = createButton("💀  ONE HIT KILL", "#6A1B9A")
local btn6 = createButton("💰  UNLIMITED MONEY", "#F9A825")
local btn7 = createButton("✕  CLOSE MENU", "#424242")

layout.addView(btn1)
fxButton(btn1, "god")

layout.addView(btn2)
fxButton(btn2, "ammo")

layout.addView(btn3)
fxButton(btn3, "speed")

layout.addView(btn4)
fxButton(btn4, "health")

layout.addView(btn5)
fxButton(btn5, "kill")

layout.addView(btn6)
fxButton(btn6, "money")

layout.addView(btn7)
fxButton(btn7, "close")
        
        
        
        local menuWidth = math.floor(screenWidth * 0.6)

local params = luajava.newInstance(
    "android.view.WindowManager$LayoutParams",
    menuWidth,
    ViewGroup.LayoutParams.WRAP_CONTENT,
    getType(),
    0x00000028,
    PixelFormat.TRANSLUCENT
)
        
        params.gravity = Gravity.TOP + Gravity.LEFT
        params.x = 100
        params.y = 200
        
        btn1.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
            onClick = function() gg.toast("God Mode Activated") _wall = true end
        }))
        
        btn2.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
            onClick = function() gg.toast("Unlimited Ammo Activated") end
        }))
        
        btn3.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
            onClick = function() gg.toast("Speed Hack Activated") end
        }))
        
        btn4.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
            onClick = function() gg.toast("Infinite Health Activated") end
        }))
        
        btn5.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
            onClick = function() gg.toast("One Hit Kill Activated") end
        }))
        
        btn6.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
            onClick = function() gg.toast("Unlimited Money Activated") end
        }))
        
        btn7.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
            onClick = function()
                local wm = activity.getWindowManager()
                wm.removeView(layout)
                isMenuVisible = false
                gg.toast("Menu Closed")
            end
        }))
        
        header.setOnTouchListener(luajava.createProxy("android.view.View$OnTouchListener", {
            onTouch = function(v, event)
                local action = event.getAction()
                
                if action == 0 then
                    isDragging = true
                    dragStartX = event.getRawX()
                    dragStartY = event.getRawY()
                    initialWindowX = params.x
                    initialWindowY = params.y
                    return true
                elseif action == 2 then
                    if isDragging then
                        local deltaX = event.getRawX() - dragStartX
                        local deltaY = event.getRawY() - dragStartY
                        params.x = initialWindowX + deltaX
                        params.y = initialWindowY + deltaY
                        local wm = activity.getWindowManager()
                        wm.updateViewLayout(layout, params)
                        return true
                    end
                elseif action == 1 or action == 3 then
                    isDragging = false
                    return true
                end
                
                return false
            end
        }))
        
        local wm = activity.getWindowManager()
        wm.addView(layout, params)
        isMenuVisible = true
        gg.toast("Menu Loaded - Drag header to move")
        
        _G.menuLayout = layout
        _G.menuParams = params
        
        local colors = {0xFFE0E0E0, 0xFFC0C0C0, 0xFFA0A0A0, 0xFF808080, 0xFFA0A0A0, 0xFFC0C0C0}
        local animators = {}
        
        for i = 1, #colors do
            local anim = ObjectAnimator:ofInt(title, "textColor", colors)
            anim:setDuration(2000)
            anim:setStartDelay((i - 1) * 2000)
            anim:setEvaluator(ArgbEvaluator())
            table.insert(animators, anim)
        end
        
        local animSet = AnimatorSet()
        animSet:playSequentially(animators)
        animSet:start()
    end
}))

gg.sleep(500)

while true do
    if gg.isVisible() then
        gg.setVisible(false)
        
        activity.runOnUiThread(luajava.createProxy("java.lang.Runnable", {
            run = function()
                local wm = activity.getWindowManager()
                
                if isMenuVisible then
                    wm.removeView(_G.menuLayout)
                    isMenuVisible = false
                    gg.toast("Menu Closed")
                else
                    wm.addView(_G.menuLayout, _G.menuParams)
                    isMenuVisible = true
                    gg.toast("Menu Opened - Drag header to move")
                end
            end
        }))
    end
  if _wall then
    _wall = false
    gg.setRanges(gg.REGION_CODE_APP)
    gg.searchNumber("-0.50344371796;9.99999997e-7;-0.50291442871::9", gg.TYPE_FLOAT)
    gg.refineNumber("9.99999997e-7", gg.TYPE_FLOAT)
    gg.getResults(100)
    gg.editAll("-1", gg.TYPE_FLOAT)
    gg.clearResults()
    gg.toast("HACK on")
  end
end