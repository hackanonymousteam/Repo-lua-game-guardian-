gg.setVisible(true)

local TypedValue = luajava.bindClass("android.util.TypedValue")
local Gravity = luajava.bindClass("android.view.Gravity")
local PixelFormat = luajava.bindClass("android.graphics.PixelFormat")
local Color = luajava.bindClass("android.graphics.Color")
local GradientDrawable = luajava.bindClass("android.graphics.drawable.GradientDrawable")
local Typeface = luajava.bindClass("android.graphics.Typeface")
local View = luajava.bindClass("android.view.View")
local MotionEvent = luajava.bindClass("android.view.MotionEvent")
local WindowManager = luajava.bindClass("android.view.WindowManager")
local Context = luajava.bindClass("android.content.Context")
local Build = luajava.bindClass("android.os.Build")
local LinearLayout = luajava.bindClass("android.widget.LinearLayout")
local TextView = luajava.bindClass("android.widget.TextView")
local Button = luajava.bindClass("android.widget.Button")
local ScrollView = luajava.bindClass("android.widget.ScrollView")
local FrameLayout = luajava.bindClass("android.widget.FrameLayout")

local PRIMARY_COLOR = Color.parseColor("#FF8C00")
local WHITE = Color.parseColor("#FFFFFF")
local BLACK = Color.parseColor("#000000")
local RED = Color.parseColor("#F44336")

local function dp(value)
    return TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, value, activity.getResources().getDisplayMetrics())
end

local function getShapeBackground(color, radius)
    local drawable = GradientDrawable()
    drawable.setShape(GradientDrawable.RECTANGLE)
    drawable.setColor(color)
    drawable.setCornerRadius(dp(radius))
    return drawable
end

local function getBorderBackground(bgColor, borderColor, borderWidth, radius)
    local drawable = GradientDrawable()
    drawable.setShape(GradientDrawable.RECTANGLE)
    drawable.setColor(bgColor)
    drawable.setStroke(dp(borderWidth), borderColor)
    drawable.setCornerRadius(dp(radius))
    return drawable
end

function getLayoutType()
    if Build.VERSION.SDK_INT >= 26 then
        return WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
    else
        return WindowManager.LayoutParams.TYPE_PHONE
    end
end

local floatWindow = nil
local windowManager = nil
local mainLayoutParams = nil
local isMenuVisible = false
local lastX, lastY, startX, startY = 0, 0, 0, 0
local controlView = nil
local chuangkView = nil
local layoutmView = nil

local shouldExit = false
local _speedHackPending = false
local XGCK1 = -1

function setupMenu()
    windowManager = activity.getSystemService(Context.WINDOW_SERVICE)
    
    mainLayoutParams = WindowManager.LayoutParams(
        WindowManager.LayoutParams.WRAP_CONTENT,
        WindowManager.LayoutParams.WRAP_CONTENT,
        getLayoutType(),
        WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE,
        PixelFormat.TRANSLUCENT
    )
    
    mainLayoutParams.gravity = Gravity.TOP | Gravity.LEFT
    mainLayoutParams.x = dp(50)
    mainLayoutParams.y = dp(100)
    
    local mainLayout = LinearLayout(activity)
    mainLayout.setLayoutParams(LinearLayout.LayoutParams(
        WindowManager.LayoutParams.WRAP_CONTENT,
        WindowManager.LayoutParams.WRAP_CONTENT
    ))
    mainLayout.setOrientation(LinearLayout.VERTICAL)
    
    controlView = LinearLayout(activity)
    controlView.setLayoutParams(LinearLayout.LayoutParams(dp(45), dp(45)))
    controlView.setBackground(getShapeBackground(PRIMARY_COLOR, 25))
    controlView.setGravity(Gravity.CENTER)
    
    local controlText = TextView(activity)
    controlText.setText("≡")
    controlText.setTextColor(WHITE)
    controlText.setTextSize(TypedValue.COMPLEX_UNIT_SP, 24)
    controlText.setGravity(Gravity.CENTER)
    controlView.addView(controlText)
    
    chuangkView = LinearLayout(activity)
    chuangkView.setLayoutParams(LinearLayout.LayoutParams(dp(220), WindowManager.LayoutParams.WRAP_CONTENT))
    chuangkView.setOrientation(LinearLayout.VERTICAL)
    chuangkView.setBackground(getShapeBackground(Color.parseColor("#E1191919"), 25))
    chuangkView.setPadding(dp(12), dp(12), dp(12), dp(12))
    chuangkView.setVisibility(View.GONE)
    
    local headerLayout = LinearLayout(activity)
    headerLayout.setLayoutParams(LinearLayout.LayoutParams(
        LinearLayout.LayoutParams.MATCH_PARENT,
        dp(40)
    ))
    headerLayout.setOrientation(LinearLayout.HORIZONTAL)
    headerLayout.setGravity(Gravity.CENTER_VERTICAL)
    headerLayout.setPadding(dp(10), dp(5), dp(5), dp(5))
    
    local titleText = TextView(activity)
    titleText.setLayoutParams(LinearLayout.LayoutParams(
        0,
        LinearLayout.LayoutParams.WRAP_CONTENT,
        1
    ))
    titleText.setText("BATMAN PLUS")
    titleText.setTextColor(PRIMARY_COLOR)
    titleText.setTextSize(TypedValue.COMPLEX_UNIT_SP, 15)
    titleText.setTypeface(Typeface.DEFAULT_BOLD)
    titleText.setGravity(Gravity.CENTER)
    
    local closeBtn = TextView(activity)
    closeBtn.setText("✕")
    closeBtn.setTextColor(WHITE)
    closeBtn.setTextSize(TypedValue.COMPLEX_UNIT_SP, 16)
    closeBtn.setGravity(Gravity.CENTER)
    closeBtn.setLayoutParams(LinearLayout.LayoutParams(dp(30), dp(30)))
    closeBtn.setBackground(getShapeBackground(Color.parseColor("#33FFFFFF"), 15))
    closeBtn.onClick = function()
        hideMenu()
    end
    
    headerLayout.addView(titleText)
    headerLayout.addView(closeBtn)
    
    local separator = View(activity)
    separator.setLayoutParams(LinearLayout.LayoutParams(
        LinearLayout.LayoutParams.MATCH_PARENT,
        dp(1)
    ))
    separator.setBackgroundColor(PRIMARY_COLOR)
    
    local scrollView = ScrollView(activity)
    scrollView.setLayoutParams(LinearLayout.LayoutParams(
        LinearLayout.LayoutParams.MATCH_PARENT,
        LinearLayout.LayoutParams.WRAP_CONTENT
    ))
    scrollView.setFillViewport(true)
    scrollView.setOverScrollMode(View.OVER_SCROLL_NEVER)
    
    layoutmView = LinearLayout(activity)
    layoutmView.setLayoutParams(FrameLayout.LayoutParams(
        FrameLayout.LayoutParams.MATCH_PARENT,
        FrameLayout.LayoutParams.WRAP_CONTENT
    ))
    layoutmView.setOrientation(LinearLayout.VERTICAL)
    layoutmView.setGravity(Gravity.CENTER_HORIZONTAL)
    
    local buttons = {
        {"🚀 SPEED HACK", function()
            _speedHackPending = true
            gg.toast("Speed Hack Selected")
        end},
        {"👁️ WALLHACK", function()
            gg.toast("Wallhack Activated")
        end},
        {"🎯 AIMBOT", function()
            gg.toast("Aimbot Activated")
        end},
        {"🛡️ ANTI-BAN", function()
            gg.toast("Anti-Ban Activated")
        end},
        {"🎮 NO RECOIL", function()
            gg.toast("No Recoil Activated")
        end},
        {"⚡ ESP", function()
            gg.toast("ESP Activated")
        end},
        {"📦 HIDE", function()
            hideMenu()
        end},
        {"❌ EXIT", function()
            closeAlt()
        end}
    }
    
    for i, btn in ipairs(buttons) do
        local button = Button(activity)
        button.setLayoutParams(LinearLayout.LayoutParams(
            LinearLayout.LayoutParams.MATCH_PARENT,
            dp(40)
        ))
        
        if i > 1 then
            local params = button.getLayoutParams()
            params.topMargin = dp(6)
            button.setLayoutParams(params)
        end
        
        button.setText(btn[1])
        button.setTextColor(WHITE)
        button.setTextSize(TypedValue.COMPLEX_UNIT_SP, 13)
        button.setGravity(Gravity.CENTER)
        button.setPadding(dp(10), 0, dp(10), 0)
        button.setAllCaps(false)
        
        if btn[1] == "❌ EXIT" then
            button.setBackground(getBorderBackground(Color.parseColor("#33F44336"), RED, 1, 12))
        elseif btn[1] == "📦 HIDE" then
            button.setBackground(getBorderBackground(Color.parseColor("#333333"), PRIMARY_COLOR, 1, 12))
        else
            button.setBackground(getBorderBackground(Color.parseColor("#333333"), Color.parseColor("#666666"), 1, 12))
        end
        
        button.setOnTouchListener(View.OnTouchListener{
            onTouch = function(v, event)
                if event.getAction() == MotionEvent.ACTION_DOWN then
                    v.setBackground(getBorderBackground(PRIMARY_COLOR, WHITE, 1, 12))
                    v.setTextColor(BLACK)
                elseif event.getAction() == MotionEvent.ACTION_UP or event.getAction() == MotionEvent.ACTION_CANCEL then
                    if btn[1] == "❌ EXIT" then
                        v.setBackground(getBorderBackground(Color.parseColor("#33F44336"), RED, 1, 12))
                    elseif btn[1] == "📦 HIDE" then
                        v.setBackground(getBorderBackground(Color.parseColor("#333333"), PRIMARY_COLOR, 1, 12))
                    else
                        v.setBackground(getBorderBackground(Color.parseColor("#333333"), Color.parseColor("#666666"), 1, 12))
                    end
                    v.setTextColor(WHITE)
                end
                return false
            end
        })
        
        button.onClick = function()
            btn[2]()
        end
        
        layoutmView.addView(button)
    end
    
    scrollView.addView(layoutmView)
    
    chuangkView.addView(headerLayout)
    chuangkView.addView(separator)
    chuangkView.addView(scrollView)
    
    local motionView = LinearLayout(activity)
    motionView.setLayoutParams(LinearLayout.LayoutParams(
        WindowManager.LayoutParams.WRAP_CONTENT,
        WindowManager.LayoutParams.WRAP_CONTENT
    ))
    motionView.setOrientation(LinearLayout.VERTICAL)
    motionView.addView(controlView)
    motionView.addView(chuangkView)
    
    mainLayout.addView(motionView)
    floatWindow = mainLayout
    
    controlView.setOnTouchListener(View.OnTouchListener{
        onTouch = function(v, event)
            local action = event.getAction()
            
            if action == MotionEvent.ACTION_DOWN then
                startX = event.getRawX()
                startY = event.getRawY()
                lastX = mainLayoutParams.x
                lastY = mainLayoutParams.y
                v.setBackground(getShapeBackground(Color.parseColor("#FF6B00"), 25))
                return true
                
            elseif action == MotionEvent.ACTION_MOVE then
                local dx = event.getRawX() - startX
                local dy = event.getRawY() - startY
                
                mainLayoutParams.x = lastX + dx
                mainLayoutParams.y = lastY + dy
                
                if windowManager and floatWindow then
                    windowManager.updateViewLayout(floatWindow, mainLayoutParams)
                end
                return true
                
            elseif action == MotionEvent.ACTION_UP then
                v.setBackground(getShapeBackground(PRIMARY_COLOR, 25))
                
                local dx = event.getRawX() - startX
                local dy = event.getRawY() - startY
                if math.abs(dx) < 10 and math.abs(dy) < 10 then
                    toggleMenu()
                end
                return true
            end
            
            return false
        end
    })
end

function toggleMenu()
    if chuangkView then
        if chuangkView.getVisibility() == View.GONE then
            chuangkView.setVisibility(View.VISIBLE)
            controlView.setVisibility(View.GONE)
            isMenuVisible = true
        else
            chuangkView.setVisibility(View.GONE)
            controlView.setVisibility(View.VISIBLE)
            isMenuVisible = false
        end
    end
end

function showMenu()
    if floatWindow == nil then
        setupMenu()
    end
    if floatWindow ~= nil and windowManager ~= nil and not isMenuVisible then
        activity.runOnUiThread(luajava.createProxy("java.lang.Runnable", {
            run = function()
                pcall(function()
                    windowManager.addView(floatWindow, mainLayoutParams)
                    toggleMenu()
                end)
            end
        }))
    end
end

function hideMenu()
    if chuangkView and controlView then
        activity.runOnUiThread(luajava.createProxy("java.lang.Runnable", {
            run = function()
                pcall(function()
                    chuangkView.setVisibility(View.GONE)
                    controlView.setVisibility(View.VISIBLE)
                    isMenuVisible = false
                end)
            end
        }))
    end
end

function closeAlt()
    hideMenu()
    if floatWindow ~= nil and windowManager ~= nil then
        activity.runOnUiThread(luajava.createProxy("java.lang.Runnable", {
            run = function()
                pcall(function()
                    windowManager.removeView(floatWindow)
                    floatWindow = nil
                    windowManager = nil
                    isMenuVisible = false
                    shouldExit = true
                end)
            end
        }))
    else
        shouldExit = true
    end
    gg.sleep(100)
    os.exit()
end

function showFunctionMenu()
    local success, err = pcall(showMenu)
    if not success then
        print("ERROR: " .. tostring(err))
        gg.toast("ERROR OPENING MENU")
    end
end

while true do
    if shouldExit then
        break
    end
    
    if gg.isVisible(true) then
        XGCK1 = 1
        gg.setVisible(false)
        gg.clearResults()
    end
    
    if _speedHackPending then
        _speedHackPending = false
        gg.setRanges(gg.REGION_CODE_APP)
        gg.searchNumber("-0.50344371796;9.99999997e-7;-0.50291442871::9", gg.TYPE_FLOAT)
        gg.refineNumber("9.99999997e-7", gg.TYPE_FLOAT)
        gg.getResults(100)
        gg.editAll("-1", gg.TYPE_FLOAT)
        gg.clearResults()
        gg.toast("SPEED HACK ACTIVATED")
    end
    
    if XGCK1 == 1 then
        showFunctionMenu()
        XGCK1 = -1
    end
    
    gg.sleep(100)
end