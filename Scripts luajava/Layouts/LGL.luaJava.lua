gg.setVisible(false)

import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "android.graphics.*"
import "android.graphics.drawable.*"
import "android.util.TypedValue"
import "android.text.Html"
import "android.content.Context"
import "android.view.WindowManager"
import "android.view.Gravity"
import "android.animation.ObjectAnimator"
import "android.view.animation.DecelerateInterpolator"

wm = activity.getSystemService(Context.WINDOW_SERVICE)

TEXT_COLOR = Color.parseColor("#000000")
TEXT_COLOR_2 = Color.parseColor("#FFFFFF")
BTN_COLOR = Color.parseColor("#000000")
MENU_BG_COLOR = Color.parseColor("#000000")
MENU_FEATURE_BG_COLOR = Color.parseColor("#000000")
MENU_WIDTH = 290
MENU_HEIGHT = 210
MENU_CORNER = 20.0
ICON_SIZE = 50
ICON_ALPHA = 0.7

mFloatingView = nil
mCollapsed = nil
mExpanded = nil
mRootContainer = nil
patches = nil
rootFrame = nil
startimage = nil
view1 = nil
view2 = nil
Btns = nil
Btns2 = nil
alert = nil
edittextvalue = nil
mLinearLayout2 = nil
ffid = nil
ffidXX = nil
phs = nil
patches2 = nil
params = nil
textView2 = nil
featureNameExt = ""
featureNum = 0
txtValue = nil

function dp(value)
  return TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, value, activity.getResources().getDisplayMetrics())
end

function convertDipToPixels(dipValue)
  return math.floor((dipValue * activity.getResources().getDisplayMetrics().density) + 0.5)
end

function getLayoutType()
  if Build.VERSION.SDK_INT >= 26 then
    return WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
  else
    return WindowManager.LayoutParams.TYPE_PHONE
  end
end

function isViewCollapsed()
  return mFloatingView == nil or mCollapsed.getVisibility() == View.VISIBLE
end

function initFloating()
  rootFrame = FrameLayout(activity)
  rootFrame.setLayoutParams(FrameLayout.LayoutParams(-1, -1))
  
  mRootContainer = RelativeLayout(activity)
  mRootContainer.setLayoutParams(FrameLayout.LayoutParams(-2, -2))
  
  
  mCollapsed = RelativeLayout(activity)
  mCollapsed.setLayoutParams(RelativeLayout.LayoutParams(-2, -2))
  mCollapsed.setVisibility(View.VISIBLE)
  

  mExpanded = LinearLayout(activity)
  mExpanded.setVisibility(View.GONE)
  mExpanded.setGravity(Gravity.CENTER)
  mExpanded.setOrientation(LinearLayout.VERTICAL)
  
  
local BJGEDBC = GradientDrawable()
  BJGEDBC.setColor(Color.parseColor("#80000000"))
  BJGEDBC.setOrientation(GradientDrawable.Orientation.RIGHT_LEFT)
  BJGEDBC.setCornerRadii({10, 10, 10, 10, 10, 10, 10, 10})
  BJGEDBC.setStroke(2, Color.WHITE)
  mExpanded.setBackgroundDrawable(BJGEDBC)
  mExpanded.setPadding(3, 3, 3, 0)
  mExpanded.setLayoutParams(LinearLayout.LayoutParams(dp(220), dp(310)))
  
  
  view1 = LinearLayout(activity)
  view1.setLayoutParams(LinearLayout.LayoutParams(-1, 2))
  view1.setBackgroundColor(Color.WHITE)
  
  view2 = LinearLayout(activity)
  view2.setLayoutParams(LinearLayout.LayoutParams(-1, 2))
  view2.setBackgroundColor(Color.WHITE)
  
  
  startimage = ImageView(activity)
  startimage.setLayoutParams(RelativeLayout.LayoutParams(-2, -2))
  local applyDimension = dp(ICON_SIZE)
  startimage.getLayoutParams().height = applyDimension
  startimage.getLayoutParams().width = applyDimension
  startimage:requestLayout()
  startimage.setScaleType(ImageView.ScaleType.FIT_XY)
  
  
  startimage.setImageDrawable(activity.getResources().getDrawable(android.R.drawable.ic_menu_manage))
  local layoutParams = startimage.getLayoutParams()
  if layoutParams then
    layoutParams.topMargin = convertDipToPixels(10)
    startimage.setLayoutParams(layoutParams)
  end
  
  
  patches = LinearLayout(activity)
  patches.setLayoutParams(LinearLayout.LayoutParams(-1, -1))
  patches.setOrientation(LinearLayout.VERTICAL)
  
  -- Scroll view for features
  local scrollView = ScrollView(activity)
  scrollView.setPadding(0, 0, 0, 0)
  scrollView.setLayoutParams(LinearLayout.LayoutParams(-1, dp(220)))
  
  -- Title section
  local titleText = RelativeLayout(activity)
  titleText.setVerticalGravity(Gravity.CENTER_VERTICAL)
  
  -- Title text
  local badmod = TextView(activity)
  badmod.setText("ELITE VIP V1.8")
  badmod.setTextColor(Color.WHITE)
  badmod.setTextSize(18.0)
  badmod.setTypeface(Typeface.DEFAULT_BOLD)
  badmod.setGravity(Gravity.CENTER)
  badmod.setPadding(dp(30), dp(15), dp(5), 0)
  
  local rl = RelativeLayout.LayoutParams(WindowManager.LayoutParams.WRAP_CONTENT, WindowManager.LayoutParams.WRAP_CONTENT)

local rl = RelativeLayout.LayoutParams(WindowManager.LayoutParams.WRAP_CONTENT, WindowManager.LayoutParams.WRAP_CONTENT)

local dire = RelativeLayout.LayoutParams(
    WindowManager.LayoutParams.WRAP_CONTENT,
    WindowManager.LayoutParams.WRAP_CONTENT
)
dire.leftMargin = 500 

  badmod.setLayoutParams(rl)
  
  -- Control buttons
  local relativeLayout = RelativeLayout(activity)
  relativeLayout.setPadding(dp(5), 0, dp(5), dp(5))
  
  -- Hide button
  local kill = Button(activity)
  kill.setBackgroundColor(Color.parseColor("#ff0000"))
  kill.setTextSize(15.0)
  kill.setVisibility(View.VISIBLE)
  kill.setTypeface(Typeface.DEFAULT_BOLD)
  kill.setText("HIDE")
  kill.setTextColor(Color.WHITE)
  kill.setShadowLayer(2.0, 0.0, 0.0, Color.BLUE)

  
  
  local CDGAEAH = GradientDrawable()
  CDGAEAH.setColor(Color.TRANSPARENT)
  CDGAEAH.setCornerRadii({0, 0, 0, 0, 0, 0, 0, 0})
  CDGAEAH.setStroke(2, Color.WHITE)
  kill.setBackgroundDrawable(CDGAEAH)
  
  -- Close button
  local close = Button(activity)
  close.setBackgroundColor(Color.parseColor("#FF0000"))
  close.setTextSize(11.0)
  close.setTypeface(Typeface.DEFAULT_BOLD)
  close.setText("CLOSE")
  close.setShadowLayer(2.0, 0.0, 0.0, Color.BLUE)
  close.setTextColor(Color.WHITE)
  
  local closeParams = RelativeLayout.LayoutParams(-2, -2)
  
  
  local CDGAEAHH = GradientDrawable()
  CDGAEAHH.setColor(Color.TRANSPARENT)
  CDGAEAHH.setCornerRadii({10, 10, 10, 10, 10, 10, 10, 10})
  CDGAEAHH.setStroke(2, Color.WHITE)
  close.setBackgroundDrawable(CDGAEAHH)
  
  -- Build the view hierarchy
 -- relativeLayout.addView(close)
  relativeLayout.addView(kill)
  
  scrollView.addView(patches)
  
  mExpanded.addView(titleText)
  titleText.addView(badmod)
  mExpanded.addView(view1)
  mExpanded.addView(scrollView)
  mExpanded.addView(relativeLayout)
  
  mCollapsed.addView(startimage)
  
  mRootContainer.addView(mCollapsed)
  mRootContainer.addView(mExpanded)
  
  rootFrame.addView(mRootContainer)
  
  mFloatingView = rootFrame
  
  -- Window manager params
  params = WindowManager.LayoutParams()
  params.width = WindowManager.LayoutParams.WRAP_CONTENT
  params.height = WindowManager.LayoutParams.WRAP_CONTENT
  params.type = getLayoutType()
  params.flags = bit32.bor(WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE, 
                          WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN)
  params.format = PixelFormat.TRANSLUCENT
  params.gravity = Gravity.TOP | Gravity.LEFT
  params.x = 0
  params.y = 100
  
  -- Add view to window manager in UI thread
  activity.runOnUiThread(function()
    wm.addView(mFloatingView, params)
  end)
  
  -- Set up touch listener
  local initialX = 0
  local initialY = 0
  local initialTouchX = 0
  local initialTouchY = 0
  
  mFloatingView.setOnTouchListener{
    onTouch = function(view, motionEvent)
      local action = motionEvent.getAction()
      
      if action == MotionEvent.ACTION_DOWN then
        initialX = params.x
        initialY = params.y
        initialTouchX = motionEvent.getRawX()
        initialTouchY = motionEvent.getRawY()
        return true
      elseif action == MotionEvent.ACTION_UP then
        local rawX = motionEvent.getRawX() - initialTouchX
        local rawY = motionEvent.getRawY() - initialTouchY
        
        if math.abs(rawX) < 10 and math.abs(rawY) < 10 and isViewCollapsed() then
          mCollapsed.setVisibility(View.GONE)
          mExpanded.setVisibility(View.VISIBLE)
        end
        return true
      elseif action == MotionEvent.ACTION_MOVE then
        params.x = initialX + (motionEvent.getRawX() - initialTouchX)
        params.y = initialY + (motionEvent.getRawY() - initialTouchY)
        activity.runOnUiThread(function()
          wm.updateViewLayout(mFloatingView, params)
        end)
        return true
      end
      return false
    end
  }
  
  -- Button click listeners
  startimage.setOnClickListener{
    onClick = function(view)
      mCollapsed.setVisibility(View.GONE)
      mExpanded.setVisibility(View.VISIBLE)
    end
  }
  
  close.setOnClickListener{
    onClick = function(view)
      mCollapsed.setVisibility(View.VISIBLE)
      mCollapsed.setAlpha(0.95)
      mExpanded.setVisibility(View.GONE)
    end
  }
  
  kill.setOnClickListener{
    onClick = function(view)
      mCollapsed.setVisibility(View.VISIBLE)
      mCollapsed.setAlpha(0.95)
      mExpanded.setVisibility(View.GONE) 
    end
  }
end

-- Add a switch to the menu
function addSwitch(str, callback)
  local switchR = Switch(activity)
  switchR.setBackgroundColor(Color.parseColor("#00000000"))
  switchR.setText(Html.fromHtml("<font face=>" .. str .. "</font>"))
  switchR.setTextColor(Color.WHITE)
  switchR.setPadding(dp(10), dp(5), 0, dp(5))
  switchR.getTrackDrawable().setColorFilter(Color.parseColor("#000000"), PorterDuff.Mode.SRC_IN)
  switchR.getThumbDrawable().setColorFilter(Color.WHITE, PorterDuff.Mode.SRC_IN)
  
  switchR.setTypeface(Typeface.DEFAULT_BOLD)
  
  switchR.setOnCheckedChangeListener{
    onCheckedChanged = function(compoundButton, isChecked)
      if isChecked then
        switchR.getTrackDrawable().setColorFilter(Color.parseColor("#FF0000"), PorterDuff.Mode.SRC_IN)
        switchR.getThumbDrawable().setColorFilter(Color.parseColor("#FF0000"), PorterDuff.Mode.SRC_IN)
      else
        switchR.getTrackDrawable().setColorFilter(Color.parseColor("#000000"), PorterDuff.Mode.SRC_IN)
        switchR.getThumbDrawable().setColorFilter(Color.WHITE, PorterDuff.Mode.SRC_IN)
      end
      callback.OnWrite(isChecked)
    end
  }
  
  patches.addView(switchR)
end

-- Add a seekbar to the menu
function addSeekBar(feature, prog, max, callback)
  local linearLayout = LinearLayout(activity)
  linearLayout.setLayoutParams(LinearLayout.LayoutParams(-1, -1))
  linearLayout.setPadding(dp(5), dp(5), 0, dp(5))
  linearLayout.setOrientation(LinearLayout.VERTICAL)
  linearLayout.setGravity(Gravity.CENTER_HORIZONTAL)
  
  local textView = TextView(activity)
  textView.setText(Html.fromHtml(feature .. " : <font color='RED'> OFF</font>"))
  textView.setTypeface(Typeface.DEFAULT_BOLD)
  textView.setTextColor(Color.WHITE)
  
  local seekBar = SeekBar(activity)
  local seekbarDrawable = GradientDrawable()
  seekbarDrawable.setShape(GradientDrawable.RECTANGLE)
  seekbarDrawable.setColor(Color.parseColor("#ff0000"))
  seekbarDrawable.setStroke(dp(2), Color.WHITE)
  seekbarDrawable.setCornerRadius(300.0)
  seekBar.setThumb(seekbarDrawable)
  seekBar.setPadding(dp(25), dp(10), dp(35), dp(10))
  seekBar.setLayoutParams(LinearLayout.LayoutParams(-1, -1))
  seekBar.setMax(max)
  seekBar.setProgress(prog)
  seekBar.getProgressDrawable().setColorFilter(Color.GREEN, PorterDuff.Mode.SRC_IN)
  
  seekBar.setOnSeekBarChangeListener{
    onStartTrackingTouch = function(seekBar) end,
    onStopTrackingTouch = function(seekBar) end,
    onProgressChanged = function(seekBar, progress, fromUser)
      if progress == 0 then
        seekBar.setProgress(progress)
        callback.OnWrite(progress)
        textView.setText(Html.fromHtml("<font face=><b>" .. feature .. " : <font color='RED'> Desativado</font>"))
      else
        callback.OnWrite(progress)
        textView.setText(Html.fromHtml("<font face=><b>" .. feature .. " : <font color='LTGRAY'>" .. progress .. "</font>"))
      end
    end
  }
  
  linearLayout.addView(textView)
  linearLayout.addView(seekBar)
  patches.addView(linearLayout)
end

-- Add a color selection seekbar (for ESP)
function addEsp(feature, prog, max, callback)
  local linearLayout = LinearLayout(activity)
  linearLayout.setLayoutParams(LinearLayout.LayoutParams(-1, -1))
  linearLayout.setPadding(dp(5), dp(5), 0, dp(5))
  linearLayout.setOrientation(LinearLayout.VERTICAL)
  linearLayout.setGravity(Gravity.CENTER_HORIZONTAL)
  
  local textView = TextView(activity)
  textView.setText(Html.fromHtml(feature .. " : <font color='RED'> OFF</font>"))
  textView.setTypeface(Typeface.DEFAULT_BOLD)
  textView.setTextColor(Color.WHITE)
  
  local seekBar = SeekBar(activity)
  local seekbarDrawable = GradientDrawable()
  seekbarDrawable.setShape(GradientDrawable.RECTANGLE)
  seekbarDrawable.setColor(Color.parseColor("#ff0000"))
  seekbarDrawable.setStroke(dp(2), Color.WHITE)
  seekbarDrawable.setCornerRadius(300.0)
  seekBar.setThumb(seekbarDrawable)
  seekBar.setPadding(dp(25), dp(10), dp(35), dp(10))
  seekBar.setLayoutParams(LinearLayout.LayoutParams(-1, -1))
  seekBar.getProgressDrawable().setColorFilter(Color.GREEN, PorterDuff.Mode.SRC_IN)
  seekBar.setMax(max)
  seekBar.setProgress(prog)
  
  seekBar.setOnSeekBarChangeListener{
    onStartTrackingTouch = function(seekBar) end,
    onStopTrackingTouch = function(seekBar) end,
    onProgressChanged = function(seekBar, progress, fromUser)
      if progress == 0 then
        seekBar.setProgress(progress)
        callback.OnWrite(progress)
        textView.setText(Html.fromHtml("<font face=><b>" .. feature .. " : <font color='WHITE'> Branco</font>"))
        
        
      elseif progress == 1 then
        seekBar.setProgress(progress)
        callback.OnWrite(progress)
        textView.setText(Html.fromHtml("<font face=><b>" .. feature .. " : <font color='GREEN'> Verde</font>"))
        
              
      elseif progress == 2 then
        seekBar.setProgress(progress)
        callback.OnWrite(progress)
        textView.setText(Html.fromHtml("<font face=><b>" .. feature .. ": <font color='Blue'> Azul</b></font>"))
      elseif progress == 3 then
        seekBar.setProgress(progress)
        callback.OnWrite(progress)
        textView.setText(Html.fromHtml("<font face=><b>" .. feature .. ": <font color='Red'> Vermelho</b></font>"))
      elseif progress == 4 then
        seekBar.setProgress(progress)
        callback.OnWrite(progress)
        textView.setText(Html.fromHtml("<font face=><b>" .. feature .. ": <font color='Yellow'> Amarelo</b></font>"))
      elseif progress == 5 then
        seekBar.setProgress(progress)
        callback.OnWrite(progress)
        textView.setText(Html.fromHtml("<font face=><b>" .. feature .. ": <font color='Cyan'> Ciano</b></font>"))
      elseif progress == 6 then
        seekBar.setProgress(progress)
        callback.OnWrite(progress)
        textView.setText(Html.fromHtml("<font face=><b>" .. feature .. ": <font color='Magenta'> Rosa</b></font>"))
      end
    end
  }
  
  patches.addView(textView)
  patches.addView(seekBar)
end


initFloating()

function onCreate()
  addSeekBar("Aimbot Strength", 0, 100, {
    OnWrite = function(i)
      print("Aimbot Strength: " .. i)
    end
  })
  
  addEsp("ESP Color", 0, 6, {
    OnWrite = function(i)
print("Esp: " .. i)
    end
  })
  
addSwitch("God Mode", {
    OnWrite = function(z)
        _speedHackPending = true
        -- Device info functionality
      gg.toast("sucess")
    end
  })

addSwitch("Exit", {
    OnWrite = function(z)
 mCollapsed.setVisibility(View.VISIBLE)
      mCollapsed.setAlpha(0.95)
      mExpanded.setVisibility(View.GONE) 
      startimage.setVisibility(View.GONE)
closeAlt()
    end
  })

end

onCreate()
function closeAlt()
  shouldExit = true 
end

XGCK1 = -1
shouldExit = false

while true do
  if shouldExit then 
    mCollapsed.setVisibility(View.VISIBLE)
      mCollapsed.setAlpha(0.95)
      mExpanded.setVisibility(View.GONE) 
      startimage.setVisibility(View.GONE)
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
    gg.toast("HACK ATIVADO")
  end
  
  if XGCK1 == 1 then    
  end  
  XGCK1 = -1
  gg.sleep(100)
end

