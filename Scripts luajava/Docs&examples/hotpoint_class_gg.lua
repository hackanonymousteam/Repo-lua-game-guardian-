import "android.ext.HotPoint"
import "android.view.*"
import "android.widget.*"
import "android.graphics.*"
import "android.content.*"
import "android.util.*"
import "android.animation.*"
import "android.os.*"

local Class = luajava.bindClass
local new = luajava.new
local astable = luajava.astable

gg.setVisible(false)

local hotpoint = android.ext.HotPoint.getInstance()
local hotpointClass = hotpoint:getClass()

hotpoint:setMarginX(30)
hotpoint:setBackgroundResource(android.R.color.holo_blue_light)
hotpoint:setElevation(16.0)


pcall(function()
    local marginX = hotpoint:getMarginX()
    hotpoint:setMarginX(30)
end)



hotpoint:setOnLongClickListener({
    onLongClick = function(v)
        return true
    end
})

hotpoint:setClickable(true)
hotpoint:setLongClickable(true)
hotpoint:setFocusable(true)
hotpoint:setFocusableInTouchMode(true)

local childCount = hotpoint:getChildCount()
hotpoint:setClipChildren(false)

pcall(function()
    local layoutAnim = new(LayoutAnimationController, new(AlphaAnimation, 0, 1))
    layoutAnim:setDelay(0.5)
    hotpoint:setLayoutAnimation(layoutAnim)
end)

hotpoint:setImportantForAccessibility(View.IMPORTANT_FOR_ACCESSIBILITY_YES)

pcall(function()
    local clicked = hotpoint:performClick()
end)

pcall(function()
    local longClicked = hotpoint:performLongClick()
end)

pcall(function()
    local touchEvent = MotionEvent.obtain(
        System.currentTimeMillis(),
        System.currentTimeMillis(),
        MotionEvent.ACTION_DOWN,
        50, 50, 0
    )
    local handled = hotpoint:dispatchTouchEvent(touchEvent)
    touchEvent:recycle()
end)



hotpoint:measure(
    View.MeasureSpec.makeMeasureSpec(300, View.MeasureSpec.EXACTLY),
    View.MeasureSpec.makeMeasureSpec(400, View.MeasureSpec.EXACTLY)
)

local measuredWidth = hotpoint:getMeasuredWidth()
local measuredHeight = hotpoint:getMeasuredHeight()

hotpoint:setDrawingCacheEnabled(true)
hotpoint:buildDrawingCache()

local drawingCache = hotpoint:getDrawingCache()

local focusObtained = hotpoint:requestFocus()
local hasFocus = hotpoint:hasFocus()
local isFocused = hotpoint:isFocused()

hotpoint:setSystemUiVisibility(View.SYSTEM_UI_FLAG_FULLSCREEN)

local hashCode = hotpoint:hashCode()
local className = hotpoint:getClass():getName()

pcall(function()
    hotpoint:setOrientation(LinearLayout.VERTICAL)
    hotpoint:setGravity(Gravity.CENTER)
    hotpoint:setWeightSum(1.0)
end)