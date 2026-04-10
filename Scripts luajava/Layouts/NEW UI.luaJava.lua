
gg.setVisible(false)

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
import "android.util.DisplayMetrics"
import "java.util.*"
import "android.ext.HotPoint"
import "android.view.*"
import "android.graphics.*"
import "android.os.*"
import "android.content.res.*"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "java.lang.ref.*"
import "java.util.*"
import "android.ext.*"

local Class = luajava.bindClass
local new = luajava.new

local ExtAr = Class("android.ext.ar")
local hotpoint = android.ext.HotPoint.getInstance()
local isVisible = true

local mainHandler = luajava.bindClass("android.os.Handler")(luajava.bindClass("android.os.Looper").getMainLooper())

local metrics = Resources.getSystem():getDisplayMetrics()
local screenWidth = metrics.widthPixels
local screenHeight = metrics.heightPixels
local displayMetrics = DisplayMetrics()
activity.getWindowManager().getDefaultDisplay().getMetrics(displayMetrics)
local screenWidth = displayMetrics.widthPixels
local screenHeight = displayMetrics.heightPixels
function dp(value)
    return TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, value, activity.getResources().getDisplayMetrics())
end

local MENU_WIDTH = math.min(screenWidth * 0.85, 400)
local MENU_HEIGHT = math.min(screenHeight * 0.75, 700)
local BUTTON_HEIGHT = math.floor(screenHeight * 0.075)
local MINIMIZED_SIZE = dp(55)

local PRIMARY_COLOR = Color.parseColor("#9C27B0")
local SECONDARY_COLOR = Color.parseColor("#673AB7")
local ACCENT_COLOR = Color.parseColor("#E040FB")
local DARK_BG = Color.parseColor("#1A1A2E")
local CARD_BG = Color.parseColor("#2D2D44")
local WHITE = Color.parseColor("#FFFFFF")
local GREEN = Color.parseColor("#4CAF50")
local RED = Color.parseColor("#F44336")
local ORANGE = Color.parseColor("#FF9800")
local TEAL = Color.parseColor("#00BCD4")

local floatingMenuView = nil
local windowManager = nil
local menuParams = nil
local isMenuVisible = false
local isMinimized = false
local originalWidth, originalHeight = MENU_WIDTH, MENU_HEIGHT
local lastX, lastY, startX, startY = 0, 0, 0, 0

local currentState = {
    mode = "normal",      
    x = 0,
    y = 0,
    size = hotpoint:getSize(),
    color = 0xFF0078FF,  
    visible = true
}
function hideByPosition()

    currentState.x = hotpoint:getX()
    currentState.y = hotpoint:getY()
    
    hotpoint:setX(screenWidth + 1000)
    hotpoint:setY(screenHeight + 1000)
    
    currentState.mode = "hidden"
    currentState.visible = false
    end

function restorePosition()

    hotpoint:setX(currentState.x)
    hotpoint:setY(currentState.y)
    
    currentState.mode = "normal"
    currentState.visible = true
    
end

function hideBySize()
    currentState.size = hotpoint:getSize()
    hotpoint:setSize(3)
    hotpoint:setX(5)
    hotpoint:setY(5)
    currentState.mode = "tiny"
    currentState.visible = true
end

function restoreSize()
    hotpoint:setSize(currentState.size)
    currentState.mode = "normal"
    currentState.visible = true
end

function hideByCamouflage()
    currentState.color = hotpoint:getBackground():getColor() or 0xFF0078FF
    local bgColor = 0xFF000000
    hotpoint:setBackgroundColor(bgColor)
    hotpoint:setBackground(luajava.new(GradientDrawable))
    local bg = hotpoint:getBackground()
    bg:setColor(bgColor)
    bg:setStroke(1, 0x10FFFFFF)
    currentState.mode = "camou"
    currentState.visible = true
end

function restoreColor()
    hotpoint:setBackgroundColor(currentState.color)
    currentState.mode = "normal"
    currentState.visible = true
end

function hideBehindElement(element)
    if element then
        hotpoint:setZ(-1)
        local elementX = element:getX()
        local elementY = element:getY()
        local elementWidth = element:getWidth()
        local elementHeight = element:getHeight()
        hotpoint:setX(elementX + elementWidth/2 - hotpoint:getWidth()/2)
        hotpoint:setY(elementY + elementHeight/2 - hotpoint:getHeight()/2)
        currentState.mode = "behind"
    end
end

function smartToggle()
    if currentState.mode == "normal" then
        local methods = {hideByPosition, hideBySize, hideByCamouflage}
        local method = methods[math.random(1, #methods)]
        method()
    else
        restorePosition()
        restoreSize()
        restoreColor()
        hotpoint:setZ(0)
    end
end

function hideByRotation()
    hotpoint:setRotation(89.9)
    hotpoint:setScaleX(0.1)
    hotpoint:setScaleY(0.1)
    currentState.mode = "rotated"
    currentState.visible = true
end

function restoreRotation()
    hotpoint:setRotation(0)
    hotpoint:setScaleX(1.0)
    hotpoint:setScaleY(1.0)
    currentState.mode = "normal"
    currentState.visible = true
end

local hideTimers = {}

function hideTemporarily(method, durationMs)
    method()
    local timerId = "timer_" .. os.time()
    hideTimers[timerId] = mainHandler.postDelayed(function()
        restorePosition()
        restoreSize()
        restoreColor()
        restoreRotation()
        hotpoint:setZ(0)
        hideTimers[timerId] = nil
    end, durationMs)
    return timerId
end

function cancelHideTimer(timerId)
    if hideTimers[timerId] then
        mainHandler.removeCallbacks(hideTimers[timerId])
        hideTimers[timerId] = nil
    end
end

function absoluteEmergencyRestore()
    hotpoint:setX(100)
    hotpoint:setY(100)
    hotpoint:setSize(50)
    hotpoint:setRotation(0)
    hotpoint:setScaleX(1.0)
    hotpoint:setScaleY(1.0)
    hotpoint:setZ(0)
    local defaultColor = 0xFF0078FF
    hotpoint:setBackgroundColor(defaultColor)
    
    hotpoint:invalidate()
    hotpoint:requestLayout()
    
    for id, runnable in pairs(hideTimers) do
        mainHandler.removeCallbacks(runnable)
    end
    hideTimers = {}
    
    currentState = {
        mode = "normal",
        x = 100,
        y = 100,
        size = 50,
        color = defaultColor,
        visible = true
    }
    
end


function cancelHideTimer(timerId)
    if hideTimers[timerId] then
        mainHandler.removeCallbacks(hideTimers[timerId])
        hideTimers[timerId] = nil
    end
end

function getShapeBackground(color, radius)
    local drawable = GradientDrawable()
    drawable.setShape(GradientDrawable.RECTANGLE)
    drawable.setColor(color)
    drawable.setCornerRadius(radius)
    return drawable
end

function getBorderBackground(bgColor, borderColor, borderWidth, radius)
    local drawable = GradientDrawable()
    drawable.setShape(GradientDrawable.RECTANGLE)
    drawable.setColor(bgColor)
    drawable.setStroke(borderWidth, borderColor)
    drawable.setCornerRadius(radius)
    return drawable
end

function getGradientBackground(color1, color2, radius)
    local drawable = GradientDrawable()
    drawable.setShape(GradientDrawable.RECTANGLE)
    drawable.setGradientType(GradientDrawable.LINEAR_GRADIENT)
    drawable.setOrientation(GradientDrawable.Orientation.TOP_BOTTOM)
    local colors = {color1, color2}
    drawable.setCornerRadius(radius)
    return drawable
end

function getLayoutType()
    if Build.VERSION.SDK_INT >= 26 then
        return WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
    else
        return WindowManager.LayoutParams.TYPE_PHONE
    end
end

local menuButtons = {
    {text = "SPEED HACK", icon = "⚡", color1 = "#FF4081", color2 = "#E91E63", action = function() 
        _speedHackPending = true 
        
    end},
    {text = "WALLHACK", icon = "👁️", color1 = "#2196F3", color2 = "#1976D2", action = function() 
_speedHackPending = true 
         gg.toast("WALLHACK ACTIVATED") 
    end},
    {text = "AIMBOT", icon = "🎯", color1 = "#9C27B0", color2 = "#7B1FA2", action = function() 
        gg.toast("AIMBOT ACTIVATED") 
    end},
    {text = "FLY HACK", icon = "✈️", color1 = "#00BCD4", color2 = "#0097A7", action = function() 
        gg.toast("FLY HACK ACTIVATED") 
    end},
    {text = "GOD MODE", icon = "🛡️", color1 = "#FF9800", color2 = "#F57C00", action = function() 
        gg.toast("GOD MODE ACTIVATED") 
    end},
    {text = "UNLOCK ALL", icon = "🔓", color1 = "#4CAF50", color2 = "#388E3C", action = function() 
        gg.toast("UNLOCK ALL ACTIVATED") 
    end},
    {text = "AMMO HACK", icon = "🔫", color1 = "#795548", color2 = "#5D4037", action = function() 
        gg.toast("AMMO HACK ACTIVATED") 
    end},
{text = "restart gg", icon = "🎯", color1 = "#607D8B", color2 = "#455A64", action = function() 
ExtAr.h()
    end},

    {text = "Exit", icon = "🎯", color1 = "#607D8B", color2 = "#455A64", action = function() 
gg.exit()
closeAlt()
         
    end},

}

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
    menuParams.x = math.floor((screenWidth - MENU_WIDTH) / 2)
    menuParams.y = math.floor((screenHeight - MENU_HEIGHT) / 3)
    
    local mainLayout = LinearLayout(activity)
    mainLayout.setOrientation(LinearLayout.VERTICAL)
    mainLayout.setLayoutParams(LinearLayout.LayoutParams(
        MENU_WIDTH,
        MENU_HEIGHT
    ))
    mainLayout.setBackground(getBorderBackground(DARK_BG, PRIMARY_COLOR, dp(3), dp(15)))
    mainLayout.setPadding(0, 0, 0, 0)
    
   local headerLayout = LinearLayout(activity)
    headerLayout.setOrientation(LinearLayout.HORIZONTAL)
    headerLayout.setGravity(Gravity.CENTER_VERTICAL)

    headerLayout.setLayoutParams(LinearLayout.LayoutParams(
        LinearLayout.LayoutParams.MATCH_PARENT, 
        dp(55)
    ))
    headerLayout.setBackground(getGradientBackground(PRIMARY_COLOR, ACCENT_COLOR, dp(15)))
    headerLayout.setPadding(dp(10), 0, dp(10), 0)
    
    local titleText = TextView(activity)
  --  titleText.setText("🎮 MOD MENU v2.0")
    titleText.setTextColor(WHITE)
    titleText.setTextSize(TypedValue.COMPLEX_UNIT_SP, 12)
    titleText.setTypeface(Typeface.DEFAULT_BOLD)
    titleText.setGravity(Gravity.CENTER_VERTICAL)
    titleText.setLayoutParams(LinearLayout.LayoutParams(
        0,
        LinearLayout.LayoutParams.WRAP_CONTENT,
        1
    ))
    
    local minimizeBtn = Button(activity)
    minimizeBtn.setText(isMinimized and "❇️" or "❎   By Batman")
    minimizeBtn.setTextSize(TypedValue.COMPLEX_UNIT_SP, 18)
    minimizeBtn.setTextColor(WHITE)
    minimizeBtn.setBackground(getShapeBackground(Color.TRANSPARENT, dp(20)))
    minimizeBtn.setPadding(dp(10), dp(5), dp(10), dp(5))
    minimizeBtn.setTypeface(Typeface.DEFAULT_BOLD)
    
    minimizeBtn.onClick = function()
        toggleMinimize()
    end
    
    headerLayout.addView(titleText)
    headerLayout.addView(minimizeBtn)
    
    local separator = View(activity)
    separator.setLayoutParams(LinearLayout.LayoutParams(
        LinearLayout.LayoutParams.MATCH_PARENT, 
        dp(2)
    ))
    separator.setBackgroundColor(ACCENT_COLOR)
    
local scrollContainer = ScrollView(activity)
    scrollContainer.setLayoutParams(LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.MATCH_PARENT))
    scrollContainer.setVerticalScrollBarEnabled(true)
    scrollContainer.setPadding(dp(10), dp(10), dp(10), dp(5))
    
    local buttonContainer = LinearLayout(activity)
    buttonContainer.setOrientation(LinearLayout.VERTICAL)
    buttonContainer.setLayoutParams(LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT))
    buttonContainer.setGravity(Gravity.CENTER_HORIZONTAL)
    for i, btnData in ipairs(menuButtons) do
        local btnLayout = LinearLayout(activity)
  btnLayout.setOrientation(LinearLayout.HORIZONTAL)
        btnLayout.setGravity(Gravity.CENTER)
        btnLayout.setLayoutParams(LinearLayout.LayoutParams(
            LinearLayout.LayoutParams.MATCH_PARENT, 
            BUTTON_HEIGHT
        ))
        btnLayout.setPadding(0, dp(5), 0, dp(5))
        
        local button = Button(activity)
        button.setText(btnData.icon .. " " .. btnData.text)
        button.setTextColor(WHITE)
        button.setTextSize(TypedValue.COMPLEX_UNIT_SP, 14)
        button.setTypeface(Typeface.DEFAULT_BOLD)
        button.setGravity(Gravity.CENTER)
        button.setLayoutParams(LinearLayout.LayoutParams(
            LinearLayout.LayoutParams.MATCH_PARENT, 
            LinearLayout.LayoutParams.MATCH_PARENT
        ))
        button.setBackground(getGradientBackground(
            Color.parseColor(btnData.color1),
            Color.parseColor(btnData.color2),
            dp(12)
        ))
        button.setPadding(dp(20), dp(10), dp(20), dp(10))
        button.setShadowLayer(dp(3), dp(1), dp(1), Color.parseColor("#66000000"))       
        button.onClick = btnData.action   
        btnLayout.addView(button)
        buttonContainer.addView(btnLayout)
    end
    
    local controlSeparator = View(activity)
    controlSeparator.setLayoutParams(LinearLayout.LayoutParams(
        LinearLayout.LayoutParams.MATCH_PARENT, 
        dp(1)
    ))
    controlSeparator.setBackgroundColor(Color.parseColor("#5533AA"))
    buttonContainer.addView(controlSeparator)
    
    local controlLayout = LinearLayout(activity)
    controlLayout.setOrientation(LinearLayout.HORIZONTAL)
    controlLayout.setGravity(Gravity.CENTER)
    controlLayout.setLayoutParams(LinearLayout.LayoutParams(
        LinearLayout.LayoutParams.MATCH_PARENT, 
        BUTTON_HEIGHT
    ))
    controlLayout.setPadding(0, dp(10), 0, dp(10))
   
    buttonContainer.addView(controlLayout)
    
    scrollContainer.addView(buttonContainer)
    
    local footerLayout = LinearLayout(activity)
    footerLayout.setOrientation(LinearLayout.HORIZONTAL)
    footerLayout.setGravity(Gravity.CENTER)
    footerLayout.setLayoutParams(LinearLayout.LayoutParams(
        LinearLayout.LayoutParams(dp(5), 
        dp(5))
    ))
    footerLayout.setBackgroundColor(Color.parseColor("#1A1A1A"))
  
    mainLayout.addView(headerLayout)
    mainLayout.addView(separator)
    mainLayout.addView(scrollContainer)
    mainLayout.addView(footerLayout)
    
    floatingMenuView = mainLayout
      headerLayout.setOnTouchListener(View.OnTouchListener{
        onTouch = function(v, event)
            local action = event.getAction()
            
            if action == MotionEvent.ACTION_DOWN then
                startX = event.getRawX()
                startY = event.getRawY()
                lastX = menuParams.x
                lastY = menuParams.y
                v.setBackground(getGradientBackground(SECONDARY_COLOR, ACCENT_COLOR, dp(15)))
                return true
                
            elseif action == MotionEvent.ACTION_MOVE then
                local dx = event.getRawX() - startX
                local dy = event.getRawY() - startY
                
                menuParams.x = lastX + dx
                menuParams.y = lastY + dy
                
                menuParams.x = math.max(0, math.min(screenWidth - menuParams.width, menuParams.x))
                menuParams.y = math.max(0, math.min(screenHeight - menuParams.height, menuParams.y))
                
                if windowManager and floatingMenuView then
                    windowManager.updateViewLayout(floatingMenuView, menuParams)
                end
                return true
                
            elseif action == MotionEvent.ACTION_UP then
                v.setBackground(getGradientBackground(PRIMARY_COLOR, ACCENT_COLOR, dp(15)))
                return true
            end
            
            return false
        end
    })
end

function toggleMinimize()
    if not floatingMenuView or not windowManager then return end
    
    isMinimized = not isMinimized    
    if isMinimized then
    menuParams.width = MINIMIZED_SIZE
        menuParams.height = MINIMIZED_SIZE
    floatingMenuView.getChildAt(0).getChildAt(1).setText("❇️")
    floatingMenuView.getChildAt(1).setVisibility(View.GONE)
        floatingMenuView.getChildAt(2).setVisibility(View.GONE)
        floatingMenuView.getChildAt(3).setVisibility(View.GONE)
    else
      menuParams.width = originalWidth
        menuParams.height = originalHeight
        floatingMenuView.getChildAt(0).getChildAt(1).setText("❎   By Batman")
floatingMenuView.setGravity(Gravity.CENTER)
        floatingMenuView.getChildAt(1).setVisibility(View.VISIBLE)
        floatingMenuView.getChildAt(2).setVisibility(View.VISIBLE)
        floatingMenuView.getChildAt(3).setVisibility(View.VISIBLE)
    end
    windowManager.updateViewLayout(floatingMenuView, menuParams)
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
    gg.toast("⚡ SPEED HACK ACTIVATED")
  end
  
  if XGCK1 == 1 then
--  hideTemporarily(hideBySize, 0)
  --  showFunctionMenu()
  end
  XGCK1 = -1
  hideTemporarily(hideBySize, 0)
    showFunctionMenu()
end








