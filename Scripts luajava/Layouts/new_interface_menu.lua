gg.setVisible(true)

import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "android.graphics.*"
import "android.graphics.drawable.*"
import "android.util.TypedValue"
import "android.content.Context"
import "android.view.WindowManager"
import "android.view.Gravity"
import "java.util.*"

local MENU_WIDTH = 350
local MENU_HEIGHT = 715

local floatingMenuView = nil
local windowManager = nil
local menuParams = nil
local isMenuVisible = false
local lastX, lastY, startX, startY = 0, 0, 0, 0

local PRIMARY_COLOR = Color.parseColor("#FF8C00")
local WHITE = Color.parseColor("#FFFFFF")
local BLACK = Color.parseColor("#000000")
local TRANSPARENT = Color.TRANSLUCENT
local DARK_GRAY = Color.parseColor("#222222")
local GREEN = Color.parseColor("#4CAF50")
local RED = Color.parseColor("#F44336")
local BLUE = Color.parseColor("#2196F3")
local PURPLE = Color.parseColor("#9C27B0")
local TEAL = Color.parseColor("#009688")

local function dp(value)
    return TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, value, activity.getResources().getDisplayMetrics())
end

local function getShapeBackground(color, radius)
    local drawable = GradientDrawable()
    drawable.setShape(GradientDrawable.RECTANGLE)
    drawable.setColor(color)
    drawable.setCornerRadius(radius)
    return drawable
end

local function getBorderBackground(bgColor, borderColor, borderWidth, radius)
    local drawable = GradientDrawable()
    drawable.setShape(GradientDrawable.RECTANGLE)
    drawable.setColor(bgColor)
    drawable.setStroke(borderWidth, borderColor)
    drawable.setCornerRadius(radius)
    return drawable
end

local function getLayoutType()
    if Build.VERSION.SDK_INT >= 26 then
        return WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
    else
        return WindowManager.LayoutParams.TYPE_PHONE
    end
end

function setupMenu()
    windowManager = activity.getSystemService(Context.WINDOW_SERVICE)
    
    menuParams = WindowManager.LayoutParams(
        MENU_WIDTH,
        MENU_HEIGHT,
        getLayoutType(),
        WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE | 
        WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS |
        WindowManager.LayoutParams.FLAG_WATCH_OUTSIDE_TOUCH,
        PixelFormat.TRANSLUCENT
    )
    
    menuParams.gravity = Gravity.TOP | Gravity.LEFT
    menuParams.x = 100
    menuParams.y = 100
    
    local mainLayout = LinearLayout(activity)
    mainLayout.setOrientation(LinearLayout.VERTICAL)
    mainLayout.setLayoutParams(LinearLayout.LayoutParams(
        MENU_WIDTH,
        MENU_HEIGHT
    ))
    mainLayout.setBackground(getBorderBackground(DARK_GRAY, PRIMARY_COLOR, dp(3), dp(15)))
    mainLayout.setPadding(dp(10), dp(10), dp(10), dp(10))
    
    local headerLayout = LinearLayout(activity)
    headerLayout.setOrientation(LinearLayout.HORIZONTAL)
    headerLayout.setGravity(Gravity.CENTER_VERTICAL)
    headerLayout.setLayoutParams(LinearLayout.LayoutParams(
        LinearLayout.LayoutParams.MATCH_PARENT, 
        dp(50)
    ))
    headerLayout.setBackground(getShapeBackground(Color.TRANSPARENT, dp(8)))
    
    local dragIcon = TextView(activity)
    dragIcon.setText("≡ Menu by Batman Games")
    dragIcon.setTextColor(PRIMARY_COLOR)
    dragIcon.setTextSize(TypedValue.COMPLEX_UNIT_SP, 14)
    dragIcon.setGravity(Gravity.CENTER)
    dragIcon.setPadding(dp(10), 0, 0, 0)
    
    headerLayout.addView(dragIcon)
    
    local separator = View(activity)
    separator.setLayoutParams(LinearLayout.LayoutParams(
        LinearLayout.LayoutParams.MATCH_PARENT, 
        dp(1)
    ))
    separator.setBackgroundColor(PRIMARY_COLOR)
    
    local footerLayout = LinearLayout(activity)
    footerLayout.setOrientation(LinearLayout.HORIZONTAL)
    footerLayout.setGravity(Gravity.CENTER)
    footerLayout.setLayoutParams(LinearLayout.LayoutParams(
        LinearLayout.LayoutParams.MATCH_PARENT, 
        LinearLayout.LayoutParams.WRAP_CONTENT
    ))
    footerLayout.setPadding(0, dp(5), 0, 0)
    
    local speedButton = Button(activity)
    speedButton.setText("SPEED HACK")
    speedButton.setTextColor(WHITE)
    speedButton.setBackground(getBorderBackground(Color.parseColor("#FF3333"), WHITE, dp(2), dp(10)))
    speedButton.setPadding(dp(25), dp(10), dp(25), dp(10))
    speedButton.setTextSize(TypedValue.COMPLEX_UNIT_SP, 12)
    speedButton.setGravity(Gravity.CENTER)
    speedButton.setLayoutParams(LinearLayout.LayoutParams(
        LinearLayout.LayoutParams.MATCH_PARENT, 
        LinearLayout.LayoutParams.WRAP_CONTENT
    ))
    
speedButton.onClick = function(v)
    _speedHackPending = true
    hideMenu()
end

    footerLayout.addView(speedButton)
    mainLayout.addView(headerLayout)
    mainLayout.addView(separator)
    mainLayout.addView(footerLayout)
    
    local wallhackLayout = LinearLayout(activity)
    wallhackLayout.setOrientation(LinearLayout.HORIZONTAL)
    wallhackLayout.setGravity(Gravity.CENTER)
    wallhackLayout.setLayoutParams(LinearLayout.LayoutParams(
        LinearLayout.LayoutParams.MATCH_PARENT, 
        LinearLayout.LayoutParams.WRAP_CONTENT
    ))
    wallhackLayout.setPadding(0, dp(5), 0, 0)
    
    local wallhackButton = Button(activity)
    wallhackButton.setText("WALLHACK")
    wallhackButton.setTextColor(WHITE)
    wallhackButton.setBackground(getBorderBackground(Color.parseColor("#FF3333"), WHITE, dp(2), dp(10)))
    wallhackButton.setPadding(dp(25), dp(10), dp(25), dp(10))
    wallhackButton.setTextSize(TypedValue.COMPLEX_UNIT_SP, 12)
    wallhackButton.setGravity(Gravity.CENTER)
    wallhackButton.setLayoutParams(LinearLayout.LayoutParams(
        LinearLayout.LayoutParams.MATCH_PARENT, 
        LinearLayout.LayoutParams.WRAP_CONTENT
    ))
    
    wallhackButton.onClick = function(v)
        gg.toast("WALLHACK ACTIVATED")
    end

    wallhackLayout.addView(wallhackButton)
    mainLayout.addView(wallhackLayout)
    
    local aimbotLayout = LinearLayout(activity)
    aimbotLayout.setOrientation(LinearLayout.HORIZONTAL)
    aimbotLayout.setGravity(Gravity.CENTER)
    aimbotLayout.setLayoutParams(LinearLayout.LayoutParams(
        LinearLayout.LayoutParams.MATCH_PARENT, 
        LinearLayout.LayoutParams.WRAP_CONTENT
    ))
    aimbotLayout.setPadding(0, dp(5), 0, 0)
    
    local aimbotButton = Button(activity)
    aimbotButton.setText("AIMBOT")
    aimbotButton.setTextColor(WHITE)
    aimbotButton.setBackground(getBorderBackground(Color.parseColor("#FF3333"), WHITE, dp(2), dp(10)))
    aimbotButton.setPadding(dp(25), dp(10), dp(25), dp(10))
    aimbotButton.setTextSize(TypedValue.COMPLEX_UNIT_SP, 12)
    aimbotButton.setGravity(Gravity.CENTER)
    aimbotButton.setLayoutParams(LinearLayout.LayoutParams(
        LinearLayout.LayoutParams.MATCH_PARENT, 
        LinearLayout.LayoutParams.WRAP_CONTENT
    ))
    
    aimbotButton.onClick = function(v)
        gg.toast("AIMBOT ACTIVATED")
    end

    aimbotLayout.addView(aimbotButton)
    mainLayout.addView(aimbotLayout)
    
    local flyLayout = LinearLayout(activity)
    flyLayout.setOrientation(LinearLayout.HORIZONTAL)
    flyLayout.setGravity(Gravity.CENTER)
    flyLayout.setLayoutParams(LinearLayout.LayoutParams(
        LinearLayout.LayoutParams.MATCH_PARENT, 
        LinearLayout.LayoutParams.WRAP_CONTENT
    ))
    flyLayout.setPadding(0, dp(5), 0, 0)
    
    local flyButton = Button(activity)
    flyButton.setText("FLY HACK")
    flyButton.setTextColor(WHITE)
    flyButton.setBackground(getBorderBackground(Color.parseColor("#FF3333"), WHITE, dp(2), dp(10)))
    flyButton.setPadding(dp(25), dp(10), dp(25), dp(10))
    flyButton.setTextSize(TypedValue.COMPLEX_UNIT_SP, 12)
    flyButton.setGravity(Gravity.CENTER)
    flyButton.setLayoutParams(LinearLayout.LayoutParams(
        LinearLayout.LayoutParams.MATCH_PARENT, 
        LinearLayout.LayoutParams.WRAP_CONTENT
    ))
    
    flyButton.onClick = function(v)
        gg.toast("FLY HACK ACTIVATED")
    end

    flyLayout.addView(flyButton)
    mainLayout.addView(flyLayout)
    
    local closeLayout = LinearLayout(activity)
    closeLayout.setOrientation(LinearLayout.HORIZONTAL)
    closeLayout.setGravity(Gravity.CENTER)
    closeLayout.setLayoutParams(LinearLayout.LayoutParams(
        LinearLayout.LayoutParams.MATCH_PARENT, 
        LinearLayout.LayoutParams.WRAP_CONTENT
    ))
    closeLayout.setPadding(0, dp(5), 0, 0)
    
    local closeButton = Button(activity)
    closeButton.setText("HIDE MENU")
    closeButton.setTextColor(WHITE)
    closeButton.setBackground(getBorderBackground(Color.parseColor("#7733FF"), WHITE, dp(2), dp(10)))
    closeButton.setPadding(dp(25), dp(10), dp(25), dp(10))
    closeButton.setTextSize(TypedValue.COMPLEX_UNIT_SP, 12)
    closeButton.setGravity(Gravity.CENTER)
    closeButton.setLayoutParams(LinearLayout.LayoutParams(
        LinearLayout.LayoutParams.MATCH_PARENT, 
        LinearLayout.LayoutParams.WRAP_CONTENT
    ))
    
    closeButton.onClick = function(v)
        hideMenu()
    end

    closeLayout.addView(closeButton)
    mainLayout.addView(closeLayout)
    
local exitLayout = LinearLayout(activity)
    exitLayout.setOrientation(LinearLayout.HORIZONTAL)
    exitLayout.setGravity(Gravity.CENTER)
    exitLayout.setLayoutParams(LinearLayout.LayoutParams(
        LinearLayout.LayoutParams.MATCH_PARENT, 
        LinearLayout.LayoutParams.WRAP_CONTENT
    ))
    exitLayout.setPadding(0, dp(5), 0, 0)
    
    local closeAll = Button(activity)
    closeAll.setText("EXIT SCRIPT")
    closeAll.setTextColor(WHITE)
    closeAll.setBackground(getBorderBackground(Color.parseColor("#7733FF"), WHITE, dp(2), dp(10)))
    closeAll.setPadding(dp(25), dp(10), dp(25), dp(10))
    closeAll.setTextSize(TypedValue.COMPLEX_UNIT_SP, 12)
    closeAll.setGravity(Gravity.CENTER)
    closeAll.setLayoutParams(LinearLayout.LayoutParams(
        LinearLayout.LayoutParams.MATCH_PARENT, 
        LinearLayout.LayoutParams.WRAP_CONTENT
    ))
    
    closeAll.onClick = function(v)
--hideMenu()        
closeAlt()
        os.exit()
    end

    exitLayout.addView(closeAll)
    mainLayout.addView(exitLayout)
    
    floatingMenuView = mainLayout
    
    headerLayout.setOnTouchListener(View.OnTouchListener{
        onTouch = function(v, event)
            local action = event.getAction()
            
            if action == MotionEvent.ACTION_DOWN then
                startX = event.getRawX()
                startY = event.getRawY()
                lastX = menuParams.x
                lastY = menuParams.y
                v.setBackground(getBorderBackground(Color.parseColor("#333333"), PRIMARY_COLOR, dp(2), dp(8)))
                return true
                
            elseif action == MotionEvent.ACTION_MOVE then
                local dx = event.getRawX() - startX
                local dy = event.getRawY() - startY
                
                menuParams.x = lastX + dx
                menuParams.y = lastY + dy
                
                if windowManager and floatingMenuView then
                    windowManager.updateViewLayout(floatingMenuView, menuParams)
                end
                return true
                
            elseif action == MotionEvent.ACTION_UP then
                v.setBackground(getShapeBackground(Color.TRANSPARENT, dp(8)))
                return true
            end
            
            return false
        end
    })
end

function showMenu()
    if floatingMenuView == nil then
        setupMenu()
    end   
    if floatingMenuView ~= nil and windowManager ~= nil and not isMenuVisible then
        local handler = Handler(Looper.getMainLooper())
        handler.post(function()
            pcall(function()
                windowManager.addView(floatingMenuView, menuParams)
                isMenuVisible = true
               -- gg.toast("FUNCTION MENU OPENED")
            end)
        end)
    end
end

function hideMenu()
    if floatingMenuView ~= nil and windowManager ~= nil and isMenuVisible then
        local handler = Handler(Looper.getMainLooper())
        handler.post(function()
            pcall(function()
                windowManager.removeView(floatingMenuView)
                isMenuVisible = false
                gg.toast("MENU CLOSED")
            end)
        end)
    end
end

function showFunctionMenu()
    local success, err = pcall(showMenu)
    if not success then
        print("ERROR: " .. tostring(err))
        gg.toast("ERROR OPENING MENU")
    end
end

function isMenuOpen()
    return isMenuVisible
end

local shouldExit = false

function closeAlt()
    hideMenu()
    if floatingMenuView ~= nil and windowManager ~= nil then
        local handler = Handler(Looper.getMainLooper())
        handler.post(function()
            pcall(function()
                windowManager.removeView(floatingMenuView)
                floatingMenuView = nil
                windowManager = nil
                isMenuVisible = false
                shouldExit = true  
            end)
        end)
    else
        shouldExit = true 
    end   
    local timer = Timer()
    timer.schedule(TimerTask({
        run = function()
            os.exit()
        end
    }), 100)
end

while true do
  if shouldExit then break end
  
  if gg.isVisible(true) then
    XGCK1 = 1
    gg.setVisible(false)
    gg.clearResults()
  end
  
  if isMenuOpen(false) then
    XGCK1 = 1
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
  end
  
  XGCK1 = -1
  gg.sleep(100)
end
