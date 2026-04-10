
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


  hideTemporarily(hideBySize, 0)
