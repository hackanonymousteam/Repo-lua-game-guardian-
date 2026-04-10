gg.setVisible(false)

local ActivityManager = luajava.bindClass("android.app.ActivityManager")
local AlertDialog = luajava.bindClass("android.app.AlertDialog")
local BitmapFactory = luajava.bindClass("android.graphics.BitmapFactory")
local Canvas = luajava.bindClass("android.graphics.Canvas")
local Color = luajava.bindClass("android.graphics.Color")
local ColorStateList = luajava.bindClass("android.content.res.ColorStateList")
local Context = luajava.bindClass("android.content.Context")
local DigitsKeyListener = luajava.bindClass("android.text.method.DigitsKeyListener")
local GradientDrawable = luajava.bindClass("android.graphics.drawable.GradientDrawable")
local Gravity = luajava.bindClass("android.view.Gravity")
local Html = luajava.bindClass("android.text.Html")
local MotionEvent = luajava.bindClass("android.view.MotionEvent")
local Paint = luajava.bindClass("android.graphics.Paint")
local PixelFormat = luajava.bindClass("android.graphics.PixelFormat")
local PorterDuff = luajava.bindClass("android.graphics.PorterDuff")
local RelativeLayout = luajava.bindClass("android.widget.RelativeLayout")
local RippleDrawable = luajava.bindClass("android.graphics.drawable.RippleDrawable")
local RunningAppProcessInfo = luajava.bindClass("android.app.ActivityManager$RunningAppProcessInfo")
local Typeface = luajava.bindClass("android.graphics.Typeface")
local TypedValue = luajava.bindClass("android.util.TypedValue")
local View = luajava.bindClass("android.view.View")
local ViewGroup = luajava.bindClass("android.view.ViewGroup")
local WindowManager = luajava.bindClass("android.view.WindowManager")
local Build = luajava.bindClass("android.os.Build")
local Handler = luajava.bindClass("android.os.Handler")
local Looper = luajava.bindClass("android.os.Looper")

local Button = luajava.bindClass("android.widget.Button")
local LinearLayout = luajava.bindClass("android.widget.LinearLayout")
local TextView = luajava.bindClass("android.widget.TextView")
local Toast = luajava.bindClass("android.widget.Toast")
local ImageView = luajava.bindClass("android.widget.ImageView")

local PRIMARY_COLOR = Color.parseColor("#FFD600FF")
local WHITE = Color.parseColor("#FFFFFF")
local BLACK = Color.parseColor("#000000")
local GRAY = Color.parseColor("#666666")

local mWindowManager = nil
local mFloatingView = nil
local params = nil
local shouldExit = false
local splashInitialized = false

local iconView = nil
local titleText = nil
local statusText = nil
local progressText = nil
local versionText = nil

local function dp(value)
    return TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, value, activity.getResources().getDisplayMetrics())
end

local function getLayoutType()
    if Build.VERSION.SDK_INT >= 26 then
        return 2038
    elseif Build.VERSION.SDK_INT >= 24 then
        return 2002
    else
        return 2003
    end
end

local function getScreenDimensions()
    local display = activity.getWindowManager().getDefaultDisplay()
    local metrics = activity.getResources().getDisplayMetrics()
    display.getMetrics(metrics)
    return metrics.widthPixels, metrics.heightPixels
end

local function getShapeBackground(color, radius)
    local drawable = GradientDrawable()
    drawable.setShape(GradientDrawable.RECTANGLE)
    drawable.setColor(color)
    drawable.setCornerRadius(dp(radius or 5))
    return drawable
end

local function createSplashScreen()
    mWindowManager = activity.getSystemService(Context.WINDOW_SERVICE)
    
    local screenWidth, screenHeight = getScreenDimensions()
    
    params = WindowManager.LayoutParams(
        screenWidth,
        screenHeight,
        getLayoutType(),
        WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE,
        PixelFormat.TRANSLUCENT
    )
    params.gravity = Gravity.CENTER
    
    local rootLayout = LinearLayout(activity)
    rootLayout.setLayoutParams(LinearLayout.LayoutParams(screenWidth, screenHeight))
    rootLayout.setOrientation(LinearLayout.VERTICAL)
    rootLayout.setGravity(Gravity.CENTER)
    rootLayout.setBackgroundColor(BLACK)
    rootLayout.setPadding(dp(20), dp(20), dp(20), dp(20))
    
    iconView = TextView(activity)
    local iconParams = LinearLayout.LayoutParams(dp(100), dp(100))
    iconParams.gravity = Gravity.CENTER
    iconView.setLayoutParams(iconParams)
    iconView.setText("⚡")
    iconView.setTextSize(TypedValue.COMPLEX_UNIT_SP, 60)
    iconView.setTextColor(WHITE)
    iconView.setGravity(Gravity.CENTER)
    iconView.setBackground(getShapeBackground(PRIMARY_COLOR, 50))
    
    rootLayout.addView(iconView)
    
    titleText = TextView(activity)
    local titleParams = LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT)
    titleParams.gravity = Gravity.CENTER
    titleParams.topMargin = dp(20)
    titleText.setLayoutParams(titleParams)
    titleText.setText("BATMAN SCRIPT")
    titleText.setTextColor(WHITE)
    titleText.setTextSize(TypedValue.COMPLEX_UNIT_SP, 24)
    titleText.setTypeface(Typeface.DEFAULT_BOLD)
    titleText.setGravity(Gravity.CENTER)
    
    rootLayout.addView(titleText)
    
    statusText = TextView(activity)
    local statusParams = LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT)
    statusParams.gravity = Gravity.CENTER
    statusParams.topMargin = dp(10)
    statusText.setLayoutParams(statusParams)
    statusText.setText("Starting...")
    statusText.setTextColor(GRAY)
    statusText.setTextSize(TypedValue.COMPLEX_UNIT_SP, 16)
    statusText.setGravity(Gravity.CENTER)
    
    rootLayout.addView(statusText)
    
    progressText = TextView(activity)
    local progressParams = LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT)
    progressParams.gravity = Gravity.CENTER
    progressParams.topMargin = dp(20)
    progressText.setLayoutParams(progressParams)
    progressText.setText("[                    ] 0%")
    progressText.setTextColor(PRIMARY_COLOR)
    progressText.setTextSize(TypedValue.COMPLEX_UNIT_SP, 18)
    progressText.setTypeface(Typeface.MONOSPACE)
    progressText.setGravity(Gravity.CENTER)
    
    rootLayout.addView(progressText)
    
    versionText = TextView(activity)
    local versionParams = LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT)
    versionParams.gravity = Gravity.CENTER
    versionParams.topMargin = dp(50)
    versionText.setLayoutParams(versionParams)
    versionText.setText("v1.0.0")
    versionText.setTextColor(GRAY)
    versionText.setTextSize(TypedValue.COMPLEX_UNIT_SP, 12)
    versionText.setGravity(Gravity.CENTER)
    
    rootLayout.addView(versionText)
    
    mFloatingView = rootLayout
    mWindowManager.addView(mFloatingView, params)
end

local function closeSplash()
    if mFloatingView and mWindowManager then
        activity.runOnUiThread(luajava.createProxy("java.lang.Runnable", {
            run = function()
                pcall(function()
                    mWindowManager.removeView(mFloatingView)
                    mFloatingView = nil
                    mWindowManager = nil
                    splashInitialized = false
                end)
            end
        }))
    end
end

local function initializeSplash()
    if splashInitialized then
        return
    end
    
    activity.runOnUiThread(luajava.createProxy("java.lang.Runnable", {
        run = function()
            local success, err = pcall(function()
                createSplashScreen()
                splashInitialized = true
            end)
            
            if not success then
                print("ERROR: " .. tostring(err))
                shouldExit = true
            end
        end
    }))
end

if not splashInitialized then
    initializeSplash()
end

gg.sleep(500)

local statusMessages = {
    "Starting",
    "loading modules",
    "settings",
    "Wait...",
    "Wait..."
}

for percent = 0, 100, 2 do  
    if shouldExit then break end
    
    local barLength = 20
    local filled = math.floor((percent / 100) * barLength)
    local empty = barLength - filled
    local bar = "[" .. string.rep("█", filled) .. string.rep("░", empty) .. "]"
    
   local statusIndex = math.floor((percent / 100) * #statusMessages) + 1
    if statusIndex > #statusMessages then
        statusIndex = #statusMessages
    end
    
    activity.runOnUiThread(luajava.createProxy("java.lang.Runnable", {
        run = function()
            if mFloatingView then
                statusText.setText(statusMessages[statusIndex] .. "...")
                progressText.setText(bar .. " " .. percent .. "%")
                iconView.setRotation(percent * 3.6)  -- 360° no final
            
                local scale = 1 + math.sin(percent * 0.1) * 0.1
                iconView.setScaleX(scale)
                iconView.setScaleY(scale)
            end
        end
    }))
    
   if percent % 20 == 0 and percent > 0 then
        gg.toast("⚡ " .. percent .. "% done")
    end    
  gg.sleep(200)  -- 200ms 
end

if not shouldExit then
    activity.runOnUiThread(luajava.createProxy("java.lang.Runnable", {
        run = function()
            if mFloatingView then
                statusText.setText("done!")
                progressText.setText("[████████████████████] 100%")
                iconView.setRotation(360)
                iconView.setScaleX(1.2)
                iconView.setScaleY(1.2)
            end
        end
    }))
    
    gg.sleep(1000)
    gg.sleep(500)
end

closeSplash()
gg.sleep(500)
os.exit()