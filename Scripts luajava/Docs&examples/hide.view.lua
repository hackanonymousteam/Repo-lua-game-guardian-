import "android.ext.HotPoint"
import "android.view.*"
import "android.graphics.*"
import "android.os.*"
import "android.content.res.*"

local hotpoint = android.ext.HotPoint.getInstance()
local isVisible = true
local mainHandler = luajava.bindClass("android.os.Handler")(luajava.bindClass("android.os.Looper").getMainLooper())
local metrics = Resources.getSystem():getDisplayMetrics()
local screenWidth = metrics.widthPixels
local screenHeight = metrics.heightPixels

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

hotpoint:setOnClickListener({
    onClick = function(view)
        smartToggle()
    end
})

hotpoint:setOnLongClickListener({
    onLongClick = function(view)
        return true
    end
})

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

local timer1 = hideTemporarily(hideBySize, 2000)

mainHandler.postDelayed(function()
    local timer2 = hideTemporarily(hideByPosition, 3000)
    
    mainHandler.postDelayed(function()
        local timer3 = hideTemporarily(hideByCamouflage, 2000)
    end, 3500)
end, 2500)

gg.setVisible(false)