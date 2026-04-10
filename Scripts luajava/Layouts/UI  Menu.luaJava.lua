gg.setVisible(false)

local bit = require("bit32")

import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "android.graphics.Color"
import "android.content.Context"
import "android.content.Intent"
import "android.net.Uri"
import "android.provider.Settings"
import "android.content.pm.PackageManager"
import "android.graphics.Typeface"
import "android.graphics.drawable.ColorDrawable"
import "android.graphics.drawable.GradientDrawable"
import "android.app.ActivityManager"
import "android.widget.Toast"
import "java.io.File"
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

mCollapsed = nil
mExpanded = nil
function dp(value)
  return TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, value, activity.getResources().getDisplayMetrics())
end

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

function CustomButton(view, config)
  import "android.graphics.drawable.GradientDrawable"
  import "android.graphics.drawable.StateListDrawable"
  import "android.graphics.drawable.RippleDrawable"
  import "android.content.res.ColorStateList"
  import "android.graphics.PorterDuff"
  
  local defaultConfig = {
   
    backgroundColor = 0xFF3F51B5, -- Azul material
    pressedColor = 0xFF303F9F,    -- Cor quando pressionado
    disabledColor = 0xFFCCCCCC,   -- Cor quando desabilitado
    strokeColor = 0xFF1A237E,     -- Cor da borda
    textColor = 0xFFFFFFFF,       -- Cor do texto
    rippleColor = 0x40FFFFFF,     -- Cor do efeito ripple
    
   
    borderRadius = 20,            -- Raio dos cantos (em dp)
    borderWidth = 2,              -- Largura da borda (em dp)
    shape = "rectangle",          -- "rectangle", "oval", "line"
    
    shadow = false,
    shadowColor = 0xFF000000,
    shadowRadius = 4,
    shadowX = 0,
    shadowY = 2,
    
    gradient = false,
    startColor = nil,
    endColor = nil,
    gradientType = "linear",      -- "linear", "radial", "sweep"
    gradientOrientation = "left_right", -- "left_right", "top_bottom", "tr_bl", etc.
    
  rippleEffect = true,
    elevation = 4,                -- Elevação (somente Android 5.0+)
    
    enabled = true
  }
  
  for k, v in pairs(defaultConfig) do
    if config[k] == nil then
      config[k] = v
    end
  end
  
 local function dpToPx(dp)
    return dp * activity.getResources().getDisplayMetrics().density
  end
  
  local normalDrawable = GradientDrawable()
  
  if config.shape == "oval" then
    normalDrawable.setShape(GradientDrawable.OVAL)
  elseif config.shape == "line" then
    normalDrawable.setShape(GradientDrawable.LINE)
  else
    normalDrawable.setShape(GradientDrawable.RECTANGLE)
   local radius = dpToPx(config.borderRadius)
    normalDrawable.setCornerRadii({radius, radius, radius, radius, radius, radius, radius, radius})
  end
  
  if config.gradient and config.startColor and config.endColor then
    local orientation
    if config.gradientOrientation == "top_bottom" then
      orientation = GradientDrawable.Orientation.TOP_BOTTOM
    elseif config.gradientOrientation == "tr_bl" then
      orientation = GradientDrawable.Orientation.TR_BL
    elseif config.gradientOrientation == "right_left" then
      orientation = GradientDrawable.Orientation.RIGHT_LEFT
    elseif config.gradientOrientation == "br_tl" then
      orientation = GradientDrawable.Orientation.BR_TL
    elseif config.gradientOrientation == "bottom_top" then
      orientation = GradientDrawable.Orientation.BOTTOM_TOP
    elseif config.gradientOrientation == "bl_tr" then
      orientation = GradientDrawable.Orientation.BL_TR
    elseif config.gradientOrientation == "left_right" then
      orientation = GradientDrawable.Orientation.LEFT_RIGHT
    else
      orientation = GradientDrawable.Orientation.TL_BR
    end
    
    normalDrawable.setGradientType(GradientDrawable.LINEAR_GRADIENT)
    normalDrawable.setOrientation(orientation)
  else
    normalDrawable.setColor(config.backgroundColor)
  end
  
  if config.borderWidth > 0 then
    normalDrawable.setStroke(dpToPx(config.borderWidth), config.strokeColor)
  end
  
  local pressedDrawable = GradientDrawable()
  pressedDrawable.setShape(normalDrawable.getShape())
  
  if config.shape == "rectangle" then
    local radius = dpToPx(config.borderRadius)
    pressedDrawable.setCornerRadii({radius, radius, radius, radius, radius, radius, radius, radius})
  end
  
  if config.gradient and config.startColor and config.endColor then
   local function darkenColor(color, factor)
      local a = bit.band(bit.rshift(color, 24), 0xFF)
      local r = bit.band(bit.rshift(color, 16), 0xFF)
      local g = bit.band(bit.rshift(color, 8), 0xFF)
      local b = bit.band(color, 0xFF)
      
      r = math.max(0, r - (r * factor))
      g = math.max(0, g - (g * factor))
      b = math.max(0, b - (b * factor))
      
      return bit.bor(bit.lshift(a, 24), bit.lshift(math.floor(r), 16), bit.lshift(math.floor(g), 8), math.floor(b))
    end
    
  --  pressedDrawable.setColors({darkenColor(config.startColor, 0.2), darkenColor(config.endColor, 0.2)})
    pressedDrawable.setGradientType(GradientDrawable.LINEAR_GRADIENT)
    pressedDrawable.setOrientation(normalDrawable.getOrientation())
  else
    pressedDrawable.setColor(config.pressedColor)
  end
  
  if config.borderWidth > 0 then
    pressedDrawable.setStroke(dpToPx(config.borderWidth), config.strokeColor)
  end
  
  -- Criar drawable para estado desabilitado
  local disabledDrawable = GradientDrawable()
  disabledDrawable.setShape(normalDrawable.getShape())
  
  if config.shape == "rectangle" then
    local radius = dpToPx(config.borderRadius)
    disabledDrawable.setCornerRadii({radius, radius, radius, radius, radius, radius, radius, radius})
  end
  
  disabledDrawable.setColor(config.disabledColor)
  
  if config.borderWidth > 0 then
    disabledDrawable.setStroke(dpToPx(config.borderWidth), 0xFF999999)
  end
  
  local stateListDrawable = StateListDrawable()
  stateListDrawable.addState({-android.R.attr.state_enabled}, disabledDrawable)
  stateListDrawable.addState({android.R.attr.state_pressed}, pressedDrawable)
  stateListDrawable.addState({}, normalDrawable)
  
   view.setBackgroundDrawable(stateListDrawable)
  if view.setTextColor then
    local colorStateList = ColorStateList({
      {-android.R.attr.state_enabled},
      {android.R.attr.state_pressed},
      {}
    }, {
      0xFF999999, -- Desabilitado
      config.textColor, -- Pressionado
      config.textColor  -- Normal
    })
    view.setTextColor(colorStateList)
  end
  return view
end

function Waterdropanimation(Controls, time)
  import "android.animation.ObjectAnimator"
  ObjectAnimator().ofFloat(Controls, "scaleX", {1, .8, 1.3, .9, 1}).setDuration(time).start()
  ObjectAnimator().ofFloat(Controls, "scaleY", {1, .8, 1.3, .9, 1}).setDuration(time).start()
end

function PulseAnimation(Controls, time)
  import "android.animation.ObjectAnimator"
  ObjectAnimator().ofFloat(Controls, "scaleX", {1, 1.1, 1}).setDuration(time).start()
  ObjectAnimator().ofFloat(Controls, "scaleY", {1, 1.1, 1}).setDuration(time).start()
end

function ShakeAnimation(Controls, time)
  import "android.animation.ObjectAnimator"
  ObjectAnimator().ofFloat(Controls, "translationX", {0, 10, -10, 8, -8, 0}).setDuration(time).start()
end

function RotateAnimation(Controls, time)
  import "android.animation.ObjectAnimator"
  ObjectAnimator().ofFloat(Controls, "rotation", {0, 360}).setDuration(time).start()
end

function BreatheAnimation(Controls, time)
  import "android.animation.ObjectAnimator"
  ObjectAnimator().ofFloat(Controls, "scaleX", {1, 1.05, 1}).setDuration(time).start()
  ObjectAnimator().ofFloat(Controls, "scaleY", {1, 1.05, 1}).setDuration(time).start()
  ObjectAnimator().ofFloat(Controls, "alpha", {1, 0.8, 1}).setDuration(time).start()
end

function CircleButton(view, InsideColor, radiu, InsideColor1)
  import "android.graphics.drawable.GradientDrawable"
  local drawable = GradientDrawable()
  drawable.setShape(GradientDrawable.RECTANGLE)
  drawable.setCornerRadii({radiu, radiu, radiu, radiu, radiu, radiu, radiu, radiu})
  drawable.setColor(InsideColor)
  drawable.setStroke(3, InsideColor1)
  view.setBackgroundDrawable(drawable)
end

function RectButton(view, color, borderRadius)
  return CustomButton(view, {
    shape = "rectangle",
    backgroundColor = color or 0xFF3F51B5,
    borderRadius = borderRadius or 5,
    rippleEffect = true
  })
end
function PartialRoundedButton(view, color, topLeft, topRight, bottomRight, bottomLeft)
  local drawable = GradientDrawable()
  drawable.setShape(GradientDrawable.RECTANGLE)
  
  local density = activity.getResources().getDisplayMetrics().density
  local tl = topLeft and topLeft * density or 0
  local tr = topRight and topRight * density or 0
  local br = bottomRight and bottomRight * density or 0
  local bl = bottomLeft and bottomLeft * density or 0
  
  drawable.setCornerRadii({tl, tl, tr, tr, br, br, bl, bl})
  drawable.setColor(color or 0xFF009688)
  drawable.setStroke(2, 0xFF00796B)
  
  local pressedDrawable = GradientDrawable()
  pressedDrawable.setShape(GradientDrawable.RECTANGLE)
  pressedDrawable.setCornerRadii({tl, tl, tr, tr, br, br, bl, bl})
  pressedDrawable.setColor(0xFF00897B) -- Cor mais escura para pressionado
  pressedDrawable.setStroke(2, 0xFF00796B)
  view.setBackgroundDrawable(pressedDrawable)
  return view
end

function CircleButton4(view, InsideColor, radiu, InsideColor1)
  import "android.graphics.drawable.GradientDrawable"
  local drawable = GradientDrawable()
  drawable.setShape(GradientDrawable.RECTANGLE)
  drawable.setCornerRadii({radiu, radiu, radiu, radiu, radiu, radiu, radiu, radiu})
  drawable.setColor(InsideColor)
  drawable.setStroke(4, InsideColor1)
  view.setBackgroundDrawable(drawable)
end

bCUI = luajava.bindClass
Context = bCUI("android.content.Context")
PixelFormat = bCUI("android.graphics.PixelFormat")
WindowManagerLayoutParams = bCUI("android.view.WindowManager$LayoutParams")
Gravity = bCUI("android.view.Gravity")
Build = bCUI("android.os.Build")
wm = activity.getSystemService(Context.WINDOW_SERVICE)


aa =  TextView(activity);
--bb= SimpleDateFormat("HH:mm", Locale.getDefault());
aa.setText("test");
aa.setTextColor(Color.BLACK);
aa.setTextSize(16);


btn = Button(activity)
btn.setText("Batman Menu")
btn.setTextColor(Color.BLACK)

btn.setOnTouchListener{
  onTouch = function(view, motionEvent)
    local action = motionEvent.getAction()

    if action == MotionEvent.ACTION_DOWN then
      initialX = btnLp.x
      initialY = btnLp.y
      initialTouchX = motionEvent.getRawX()
      initialTouchY = motionEvent.getRawY()
      moved = false
      return false

    elseif action == MotionEvent.ACTION_MOVE then
      local dx = motionEvent.getRawX() - initialTouchX
      local dy = motionEvent.getRawY() - initialTouchY

      if math.abs(dx) > 5 or math.abs(dy) > 5 then
        moved = true

        btnLp.x = initialX + dx
        btnLp.y = initialY + dy
        wm.updateViewLayout(btn, btnLp)

        if menuLayout.getVisibility() == View.VISIBLE then
          menuLp.x = btnLp.x + MENU_OFFSET_X
          menuLp.y = btnLp.y + MENU_OFFSET_Y
          wm.updateViewLayout(menuLayout, menuLp)
        end

        return true
      end

    elseif action == MotionEvent.ACTION_UP then
      if moved then
        return true
      end
      return false
    end

    return false
  end
}
RectButton(btn, 0xFFE76E00, 60, 0x00000000)




menuLayout = LinearLayout(activity)
menuLayout.setOrientation(LinearLayout.VERTICAL)
menuLayout.setBackgroundColor(0x88000000)
menuLayout.setPadding(20, 20, 20, 20)


function createMenuButton(text, onClick)
  local btn = Button(activity)
  btn.setText(text)
  btn.setTextColor(Color.WHITE)
  RectButton(btn, 0xFFE76E00, 30, 0xFFFFFFFF)
  btn.setOnClickListener(View.OnClickListener{
    onClick = function(v)
      onClick()
      menuLayout.setVisibility(View.GONE)
    end
  })
  return btn
end

local buttons = {
  {"Start", function()
    _speedHackPending = true
  end},
  {"Stop", function()

    gg.toast("HACK off")
  end},
  {"Settings", function()
    
  end},
  {"Exit", function()
  gg.exit()
    wm.removeView(btn)
    wm.removeView(menuLayout)
--closeAlt()
shouldExit = true 
    os.exit()
  end}
}
for i, buttonData in ipairs(buttons) do
  menuLayout.addView(createMenuButton(buttonData[1], buttonData[2]))
end

btnLp = WindowManagerLayoutParams()
btnLp.width = WindowManagerLayoutParams.WRAP_CONTENT
btnLp.height = WindowManagerLayoutParams.WRAP_CONTENT
btnLp.format = PixelFormat.TRANSLUCENT
if Build.VERSION.SDK_INT >= 26 then
  btnLp.type = 2038
else
  btnLp.type = 2002
end
btnLp.flags = WindowManagerLayoutParams.FLAG_NOT_FOCUSABLE
btnLp.gravity = Gravity.TOP | Gravity.LEFT
btnLp.x = 200
btnLp.y = 400

menuLp = WindowManagerLayoutParams()
menuLp.width = WindowManagerLayoutParams.WRAP_CONTENT
menuLp.height = WindowManagerLayoutParams.WRAP_CONTENT
menuLp.format = PixelFormat.TRANSLUCENT
if Build.VERSION.SDK_INT >= 26 then
  menuLp.type = 2038
else
  menuLp.type = 2002
end
menuLp.flags = WindowManagerLayoutParams.FLAG_NOT_FOCUSABLE
menuLp.gravity = Gravity.TOP | Gravity.LEFT
menuLp.x = 225
menuLp.y = 500
menuLayout.setVisibility(View.GONE)
MENU_OFFSET_X = menuLp.x - btnLp.x
MENU_OFFSET_Y = menuLp.y - btnLp.y
btn.setOnClickListener(View.OnClickListener{
  onClick = function(v)
    if menuLayout.getVisibility() == View.VISIBLE then
      menuLayout.setVisibility(View.GONE)
    else
      MENU_OFFSET_X = 0
      MENU_OFFSET_Y = btn.getHeight() + 10

      menuLp.x = btnLp.x
      menuLp.y = btnLp.y + MENU_OFFSET_Y
      wm.updateViewLayout(menuLayout, menuLp)

      menuLayout.setVisibility(View.VISIBLE)
    end
    Waterdropanimation(btn, 300)
  end
})





activity.runOnUiThread(function()
  activity.getWindow().addFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS)
  activity.overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out)
  activity.setRequestedOrientation(1)
  wm.addView(btn, btnLp)
  wm.addView(menuLayout, menuLp)
  hideTemporarily(hideBySize, 0)
end)

function closeAlt()
        shouldExit = true 
end

if pcall(function()
    activity.getPackageManager().getPackageInfo("com.guoshi.httpcanary", 0)
    activity.runOnUiThread(function()
     -- Toast.makeText(activity, "Error: Cannot attach to mainCode.nil", Toast.LENGTH_LONG).show()
    end)
  end) then
  os.exit()
end
XGCK1 = -1
shouldExit = false

while true do
  if shouldExit then break end
  
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
    gg.toast("HACK ATIVADO")
  end  
  if XGCK1 == 1 then    
  end  
  XGCK1 = -1
  gg.sleep(100)
end