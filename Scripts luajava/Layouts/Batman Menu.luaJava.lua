gg.setVisible(false)

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


function Waterdropanimation(Controls, time)
  import "android.animation.ObjectAnimator"
  ObjectAnimator().ofFloat(Controls, "scaleX", {1, .8, 1.3, .9, 1}).setDuration(time).start()
  ObjectAnimator().ofFloat(Controls, "scaleY", {1, .8, 1.3, .9, 1}).setDuration(time).start()
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

btn = Button(activity)
btn.setText("Batman Menu")
btn.setTextColor(Color.BLACK)
CircleButton4(btn, 0xFFE76E00, 60, 0x00000000)

menuLayout = LinearLayout(activity)
menuLayout.setOrientation(LinearLayout.VERTICAL)
menuLayout.setBackgroundColor(0x88000000)
menuLayout.setPadding(20, 20, 20, 20)

function createMenuButton(text, onClick)
  local btn = Button(activity)
  btn.setText(text)
  btn.setTextColor(Color.WHITE)
  CircleButton(btn, 0xFFE76E00, 30, 0xFFFFFFFF)
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
menuLp.x = 200
menuLp.y = 500
menuLayout.setVisibility(View.GONE)

btn.setOnClickListener(View.OnClickListener{
  onClick = function(v)
    if menuLayout.getVisibility() == View.VISIBLE then
      menuLayout.setVisibility(View.GONE)
      Waterdropanimation(btn, 300)
    else
      menuLayout.setVisibility(View.VISIBLE)
      Waterdropanimation(btn, 300)
    end
  end
})

activity.runOnUiThread(function()
  activity.getWindow().addFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS)
  activity.overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out)
  activity.setRequestedOrientation(1)
  wm.addView(btn, btnLp)
  wm.addView(menuLayout, menuLp)
end)

function closeAlt()
        shouldExit = true 
end

if pcall(function()
    activity.getPackageManager().getPackageInfo("com.guoshi.httpcanary", 0)
    activity.runOnUiThread(function()
      Toast.makeText(activity, "Error: Cannot attach to mainCode.nil", Toast.LENGTH_LONG).show()
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