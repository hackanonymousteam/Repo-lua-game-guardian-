gg.setVisible(false)
if luajava == nil then gg.alert(' unavaliable please use gameguardian mod (suport luajava)') else end

function setvalue(address, flags, value)
  local refinevalues = {}
  refinevalues[1] = {}
  refinevalues[1].address = address
  refinevalues[1].flags = flags
  refinevalues[1].value = value
  gg.setValues(refinevalues)
end


if not activity then
    gg.alert("No activity")
    return
end

local function bind(c)
    local ok, r = pcall(luajava.bindClass, c)
    if ok then return r end
    return nil
end

local TextView = bind("android.widget.TextView")
local WindowManager = bind("android.view.WindowManager")
local PixelFormat = bind("android.graphics.PixelFormat")
local Gravity = bind("android.view.Gravity")
local Color = bind("android.graphics.Color")
local Build = bind("android.os.Build")

import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "android.content.Context"
import "android.content.Intent"
import "android.net.Uri"
import "android.provider.Settings"
import "android.graphics.PixelFormat"
import "android.graphics.Color"
import "android.graphics.Typeface"
import "android.graphics.BitmapFactory"
import "android.graphics.drawable.GradientDrawable"
import "android.graphics.drawable.LayerDrawable"
import "android.graphics.drawable.StateListDrawable"
import "android.graphics.drawable.BitmapDrawable"
import "android.graphics.drawable.ColorDrawable"
import "android.view.animation.AlphaAnimation"
import "android.view.animation.Animation"
import "android.view.animation.AnimationSet"
import "android.view.animation.TranslateAnimation"
import "android.view.animation.ScaleAnimation"
import "java.io.File"
import "java.lang.Runnable"
import "android.os.Handler"
import "android.os.SystemClock"


local colors = {
    background = Color.parseColor("#12121F"),
    surface = Color.parseColor("#1A1A2E"),
    primary = Color.parseColor("#4361EE"),
    primary_dark = Color.parseColor("#3A0CA3"),
    accent = Color.parseColor("#4CC9F0"),
    accent_alt = Color.parseColor("#7209B7"),
    text_primary = Color.WHITE,
    text_secondary = Color.parseColor("#B0B0C0"),
    text_disabled = Color.parseColor("#707080"),
    success = Color.parseColor("#28A745"),
    warning = Color.parseColor("#F72585"),
    divider = Color.parseColor("#30304A"),
}


local featureStates = {
    aimbot = false,
    esp = false,
    noRecoil = false,
    headshot = false,
    wallhack = false,
}

local floatMenuView = nil
local menuParams = nil
local windowManager = nil
local isMenuVisible = false

function getType()
    if Build.VERSION.SDK_INT >= 26 then
        return 2038
    elseif Build.VERSION.SDK_INT >= 23 then
        return 2002
    else
        return 2003
    end
end

function dp(value)
    if value == nil then return 0 end
    local metrics = activity.getResources().getDisplayMetrics()
    if metrics == nil then return math.floor(value * 3.0) end
    return math.floor(value * metrics.density + 0.5)
end


function removeFloatingMenu()
    if floatMenuView ~= nil then
        activity.runOnUiThread(luajava.createProxy("java.lang.Runnable", {
            run = function()
                pcall(function()
                    if windowManager ~= nil and floatMenuView ~= nil then
                        windowManager.removeView(floatMenuView)
                    end
                end)
            end
        }))
    end
    isMenuVisible = false
    floatMenuView = nil
    gg.toast("Menu fechado")
end

function createFloatingMenu()
    if isMenuVisible then
        return
    end

    windowManager = activity.getSystemService(Context.WINDOW_SERVICE)

    
    floatMenuView = LinearLayout(activity)
    floatMenuView.setOrientation(LinearLayout.VERTICAL)
    floatMenuView.setPadding(dp(10), dp(10), dp(10), dp(10))

    
    local menuBg = GradientDrawable()
    menuBg.setShape(GradientDrawable.RECTANGLE)
    menuBg.setCornerRadius(dp(16))
    menuBg.setColor(colors.background)
    menuBg.setStroke(dp(2), colors.primary)
    floatMenuView.setBackgroundDrawable(menuBg)

    
    local headerLayout = LinearLayout(activity)
    headerLayout.setOrientation(LinearLayout.HORIZONTAL)
    headerLayout.setGravity(Gravity.CENTER_VERTICAL)
    headerLayout.setPadding(dp(16), dp(12), dp(16), dp(12))

    local headerBg = GradientDrawable()
    headerBg.setShape(GradientDrawable.RECTANGLE)
    headerBg.setCornerRadius(dp(12))
    headerBg.setColor(colors.primary)
    headerLayout.setBackgroundDrawable(headerBg)

    local titleText = TextView(activity)
    titleText.setText("BATMAN PRO         ")
    titleText.setTextColor(colors.text_primary)
    titleText.setTextSize(16)
    titleText.setTypeface(Typeface.DEFAULT_BOLD)

    local closeButton = TextView(activity)
    closeButton.setText("X")
    closeButton.setTextColor(Color.WHITE)
    closeButton.setTextSize(16)
    closeButton.setTypeface(Typeface.DEFAULT_BOLD)
    closeButton.setGravity(Gravity.CENTER)
    closeButton.setWidth(dp(32))
    closeButton.setHeight(dp(32))
    
    local closeBg = GradientDrawable()
    closeBg.setShape(GradientDrawable.OVAL)
    closeBg.setColor(Color.RED)
    closeButton.setBackgroundDrawable(closeBg)

    closeButton.setOnClickListener({
        onClick = function()
            removeFloatingMenu()
        end
    })

    headerLayout.addView(titleText)
    
    
    local spacerView = View(activity)
    local spacerLayoutParams = LinearLayout.LayoutParams(0, 0, 1.0)
    spacerView.setLayoutParams(spacerLayoutParams)
    headerLayout.addView(spacerView)
    
    headerLayout.addView(closeButton)
    floatMenuView.addView(headerLayout)

    
    local space1 = View(activity)
    space1.setLayoutParams(LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, dp(10)))
    floatMenuView.addView(space1)
 local btn1 = LinearLayout(activity)
    btn1.setOrientation(LinearLayout.HORIZONTAL)
    btn1.setGravity(Gravity.CENTER_VERTICAL)
    btn1.setPadding(dp(12), dp(10), dp(12), dp(10))
    btn1.setClickable(true)
    btn1.setFocusable(true)
    
    local btn1Bg = GradientDrawable()
    btn1Bg.setShape(GradientDrawable.RECTANGLE)
    btn1Bg.setCornerRadius(dp(8))
    btn1Bg.setStroke(dp(1), colors.divider)
    btn1Bg.setColor(colors.surface)
    btn1.setBackgroundDrawable(btn1Bg)
    
    local btn1Text = TextView(activity)
    btn1Text.setText("🎯 Aimbot")
    btn1Text.setTextColor(colors.text_secondary)
    btn1Text.setTextSize(12)
    btn1Text.setTypeface(Typeface.DEFAULT_BOLD)
    
    local btn1Status = TextView(activity)
    btn1Status.setText("OFF")
    btn1Status.setTextColor(Color.RED)
    btn1Status.setTextSize(10)
    btn1Status.setGravity(Gravity.CENTER)
    btn1Status.setWidth(dp(40))
    
    btn1.addView(btn1Text)
    btn1.addView(btn1Status)
    
    btn1.setOnClickListener({
        onClick = function()
            featureStates.aimbot = not featureStates.aimbot
            if featureStates.aimbot then
                btn1Bg.setColor(colors.primary)
                btn1Text.setTextColor(Color.WHITE)
                btn1Status.setText("ON")
                btn1Status.setTextColor(Color.GREEN)
so = gg.getRangesList('libunity.so')[1].start
setvalue(so + 0x76E767, 4, "h 6A FE FB 9F 17 A1 D6 D7")
setvalue(so + 0xFC5E65, 4, "h 6A FE FB 9F 17 A1 D6 D7")

                gg.toast("Aimbot: ON")
            else
                btn1Bg.setColor(colors.surface)
                btn1Text.setTextColor(colors.text_secondary)
                btn1Status.setText("OFF")
                btn1Status.setTextColor(Color.RED)
                gg.toast("Aimbot: OFF")
            end
        end
    })
    
    floatMenuView.addView(btn1)

    
    local space2 = View(activity)
    space2.setLayoutParams(LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, dp(5)))
    floatMenuView.addView(space2)

local btn2 = LinearLayout(activity)
    btn2.setOrientation(LinearLayout.HORIZONTAL)
    btn2.setGravity(Gravity.CENTER_VERTICAL)
    btn2.setPadding(dp(12), dp(10), dp(12), dp(10))
    btn2.setClickable(true)
    btn2.setFocusable(true)
    
    local btn2Bg = GradientDrawable()
    btn2Bg.setShape(GradientDrawable.RECTANGLE)
    btn2Bg.setCornerRadius(dp(8))
    btn2Bg.setStroke(dp(1), colors.divider)
    btn2Bg.setColor(colors.surface)
    btn2.setBackgroundDrawable(btn2Bg)
    
    local btn2Text = TextView(activity)
    btn2Text.setText("👁 ESP")
    btn2Text.setTextColor(colors.text_secondary)
    btn2Text.setTextSize(12)
    btn2Text.setTypeface(Typeface.DEFAULT_BOLD)
    
    local btn2Status = TextView(activity)
    btn2Status.setText("OFF")
    btn2Status.setTextColor(Color.RED)
    btn2Status.setTextSize(10)
    btn2Status.setGravity(Gravity.CENTER)
    btn2Status.setWidth(dp(40))
    
    btn2.addView(btn2Text)
    btn2.addView(btn2Status)
    
    btn2.setOnClickListener({
        onClick = function()
            featureStates.esp = not featureStates.esp
            if featureStates.esp then
                btn2Bg.setColor(colors.primary)
                btn2Text.setTextColor(Color.WHITE)
                btn2Status.setText("ON")
                btn2Status.setTextColor(Color.GREEN)
                gg.toast("ESP: ON")
            else
                btn2Bg.setColor(colors.surface)
                btn2Text.setTextColor(colors.text_secondary)
                btn2Status.setText("OFF")
                btn2Status.setTextColor(Color.RED)
                gg.toast("ESP: OFF")
            end
        end
    })
    
    floatMenuView.addView(btn2)

    
    local space3 = View(activity)
    space3.setLayoutParams(LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, dp(5)))
    floatMenuView.addView(space3)

       local btn3 = LinearLayout(activity)
    btn3.setOrientation(LinearLayout.HORIZONTAL)
    btn3.setGravity(Gravity.CENTER_VERTICAL)
    btn3.setPadding(dp(12), dp(10), dp(12), dp(10))
    btn3.setClickable(true)
    btn3.setFocusable(true)
    
    local btn3Bg = GradientDrawable()
    btn3Bg.setShape(GradientDrawable.RECTANGLE)
    btn3Bg.setCornerRadius(dp(8))
    btn3Bg.setStroke(dp(1), colors.divider)
    btn3Bg.setColor(colors.surface)
    btn3.setBackgroundDrawable(btn3Bg)
    
    local btn3Text = TextView(activity)
    btn3Text.setText("🔫 No Recoil")
    btn3Text.setTextColor(colors.text_secondary)
    btn3Text.setTextSize(12)
    btn3Text.setTypeface(Typeface.DEFAULT_BOLD)
    
    local btn3Status = TextView(activity)
    btn3Status.setText("OFF")
    btn3Status.setTextColor(Color.RED)
    btn3Status.setTextSize(10)
    btn3Status.setGravity(Gravity.CENTER)
    btn3Status.setWidth(dp(40))
    
    btn3.addView(btn3Text)
    btn3.addView(btn3Status)
    
    btn3.setOnClickListener({
        onClick = function()
            featureStates.noRecoil = not featureStates.noRecoil
            if featureStates.noRecoil then
                btn3Bg.setColor(colors.primary)
                btn3Text.setTextColor(Color.WHITE)
                btn3Status.setText("ON")
                btn3Status.setTextColor(Color.GREEN)
                gg.toast("No Recoil: ON")
            else
                btn3Bg.setColor(colors.surface)
                btn3Text.setTextColor(colors.text_secondary)
                btn3Status.setText("OFF")
                btn3Status.setTextColor(Color.RED)
                gg.toast("No Recoil: OFF")
            end
        end
    })
    
    floatMenuView.addView(btn3)

    
    local space4 = View(activity)
    space4.setLayoutParams(LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, dp(5)))
    floatMenuView.addView(space4)

        local btn4 = LinearLayout(activity)
    btn4.setOrientation(LinearLayout.HORIZONTAL)
    btn4.setGravity(Gravity.CENTER_VERTICAL)
    btn4.setPadding(dp(12), dp(10), dp(12), dp(10))
    btn4.setClickable(true)
    btn4.setFocusable(true)
    
    local btn4Bg = GradientDrawable()
    btn4Bg.setShape(GradientDrawable.RECTANGLE)
    btn4Bg.setCornerRadius(dp(8))
    btn4Bg.setStroke(dp(1), colors.divider)
    btn4Bg.setColor(colors.surface)
    btn4.setBackgroundDrawable(btn4Bg)
    
    local btn4Text = TextView(activity)
    btn4Text.setText("💀 Headshot")
    btn4Text.setTextColor(colors.text_secondary)
    btn4Text.setTextSize(12)
    btn4Text.setTypeface(Typeface.DEFAULT_BOLD)
    
    local btn4Status = TextView(activity)
    btn4Status.setText("OFF")
    btn4Status.setTextColor(Color.RED)
    btn4Status.setTextSize(10)
    btn4Status.setGravity(Gravity.CENTER)
    btn4Status.setWidth(dp(40))
    
    btn4.addView(btn4Text)
    btn4.addView(btn4Status)
    
    btn4.setOnClickListener({
        onClick = function()
            featureStates.headshot = not featureStates.headshot
            if featureStates.headshot then
                btn4Bg.setColor(colors.primary)
                btn4Text.setTextColor(Color.WHITE)
                btn4Status.setText("ON")
                btn4Status.setTextColor(Color.GREEN)
                gg.toast("Headshot: ON")
            else
                btn4Bg.setColor(colors.surface)
                btn4Text.setTextColor(colors.text_secondary)
                btn4Status.setText("OFF")
                btn4Status.setTextColor(Color.RED)
                gg.toast("Headshot: OFF")
            end
        end
    })
    
    floatMenuView.addView(btn4)

    local space5 = View(activity)
    space5.setLayoutParams(LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, dp(5)))
    floatMenuView.addView(space5)

        local btn5 = LinearLayout(activity)
    btn5.setOrientation(LinearLayout.HORIZONTAL)
    btn5.setGravity(Gravity.CENTER_VERTICAL)
    btn5.setPadding(dp(12), dp(10), dp(12), dp(10))
    btn5.setClickable(true)
    btn5.setFocusable(true)
    
    local btn5Bg = GradientDrawable()
    btn5Bg.setShape(GradientDrawable.RECTANGLE)
    btn5Bg.setCornerRadius(dp(8))
    btn5Bg.setStroke(dp(1), colors.divider)
    btn5Bg.setColor(colors.surface)
    btn5.setBackgroundDrawable(btn5Bg)
    
    local btn5Text = TextView(activity)
    btn5Text.setText("🧱 Wallhack")
    btn5Text.setTextColor(colors.text_secondary)
    btn5Text.setTextSize(12)
    btn5Text.setTypeface(Typeface.DEFAULT_BOLD)
    
    local btn5Status = TextView(activity)
    btn5Status.setText("OFF")
    btn5Status.setTextColor(Color.RED)
    btn5Status.setTextSize(10)
    btn5Status.setGravity(Gravity.CENTER)
    btn5Status.setWidth(dp(40))
    
    btn5.addView(btn5Text)
    btn5.addView(btn5Status)
    
    btn5.setOnClickListener({
        onClick = function()
            featureStates.wallhack = not featureStates.wallhack
            if featureStates.wallhack then
                btn5Bg.setColor(colors.primary)
                btn5Text.setTextColor(Color.WHITE)
                btn5Status.setText("ON")
                btn5Status.setTextColor(Color.GREEN)
                gg.toast("Wallhack: ON")
            else
                btn5Bg.setColor(colors.surface)
                btn5Text.setTextColor(colors.text_secondary)
                btn5Status.setText("OFF")
                btn5Status.setTextColor(Color.RED)
                gg.toast("Wallhack: OFF")
            end
        end
    })
    
    floatMenuView.addView(btn5)


    local spaceEnd = View(activity)
    spaceEnd.setLayoutParams(LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, dp(10)))
    floatMenuView.addView(spaceEnd)

      menuParams = WindowManager.LayoutParams()
    if Build.VERSION.SDK_INT >= Build.VERSION_CODES.O then
        menuParams.type = WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
    else
        menuParams.type = WindowManager.LayoutParams.TYPE_PHONE
    end
    menuParams.format = PixelFormat.RGBA_8888
    menuParams.flags = WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE |
                      WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN |
                      WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL
    menuParams.width = dp(250)
    menuParams.height = WindowManager.LayoutParams.WRAP_CONTENT
    menuParams.gravity = Gravity.CENTER

       local startX, startY = 0, 0
    local initialX, initialY = 0, 0
    local isMoving = false
    local moveThreshold = dp(8)

    headerLayout.setOnTouchListener({
        onTouch = function(v, event)
            local action = event.getAction()
            local rawX = event.getRawX()
            local rawY = event.getRawY()

            if action == MotionEvent.ACTION_DOWN then
                startX = rawX
                startY = rawY
                initialX = menuParams.x
                initialY = menuParams.y
                isMoving = false
                return true
            elseif action == MotionEvent.ACTION_MOVE then
                local dx = rawX - startX
                local dy = rawY - startY
                
                if not isMoving and (math.abs(dx) > moveThreshold or math.abs(dy) > moveThreshold) then
                    isMoving = true
                end
                
                if isMoving then
                    menuParams.x = initialX + dx
                    menuParams.y = initialY + dy
                    

                    local dm = activity.getResources().getDisplayMetrics()
                    local screenW = dm.widthPixels
                    local screenH = dm.heightPixels
                    
                    menuParams.x = math.max(-dp(100), math.min(menuParams.x, screenW - dp(150)))
                    menuParams.y = math.max(0, math.min(menuParams.y, screenH - dp(200)))
                    
                    pcall(function()
                        if floatMenuView ~= nil and windowManager ~= nil then
                            windowManager.updateViewLayout(floatMenuView, menuParams)
                        end
                    end)
                end
                return true
            elseif action == MotionEvent.ACTION_UP or action == MotionEvent.ACTION_CANCEL then
                isMoving = false
                return true
            end
            return false
        end
    })


    activity.runOnUiThread(luajava.createProxy("java.lang.Runnable", {
        run = function()
            pcall(function()
                windowManager.addView(floatMenuView, menuParams)
                isMenuVisible = true
                
            end)
        end
    }))
end

activity.runOnUiThread(luajava.createProxy("java.lang.Runnable", {
    run = function()
       createFloatingMenu()
    end
}))


