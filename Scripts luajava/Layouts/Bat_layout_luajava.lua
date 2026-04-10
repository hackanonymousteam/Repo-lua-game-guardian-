gg.setVisible(false)
local AlertDialog = luajava.bindClass("android.app.AlertDialog")
local AlertDialogBuilder = luajava.bindClass("android.app.AlertDialog$Builder")
local Color = luajava.bindClass("android.graphics.Color")
local DialogInterface = luajava.bindClass("android.content.DialogInterface")
local GradientDrawable = luajava.bindClass("android.graphics.drawable.GradientDrawable")
local Gravity = luajava.bindClass("android.view.Gravity")
local Html = luajava.bindClass("android.text.Html")
local LinearLayout = luajava.bindClass("android.widget.LinearLayout")
local MotionEvent = luajava.bindClass("android.view.MotionEvent")
local PixelFormat = luajava.bindClass("android.graphics.PixelFormat")
local RelativeLayout = luajava.bindClass("android.widget.RelativeLayout")
local ScrollView = luajava.bindClass("android.widget.ScrollView")
local SeekBar = luajava.bindClass("android.widget.SeekBar")
local Toast = luajava.bindClass("android.widget.Toast")
local Typeface = luajava.bindClass("android.graphics.Typeface")
local TypedValue = luajava.bindClass("android.util.TypedValue")
local View = luajava.bindClass("android.view.View")
local WindowManager = luajava.bindClass("android.view.WindowManager")
local Build = luajava.bindClass("android.os.Build")
local Button = luajava.bindClass("android.widget.Button")
local TextView = luajava.bindClass("android.widget.TextView")
local ImageView = luajava.bindClass("android.widget.ImageView")
local FrameLayout = luajava.bindClass("android.widget.FrameLayout")
local PorterDuff = luajava.bindClass("android.graphics.PorterDuff")
local TITLE = "<font face=>BAT TEAM<font>"
local Hide_txt = "-"
local Close_txt = "X"
local TEXT1 = "User: BATMAN"
local TEXT2 = "Team: BAT TEAM"
local TEXT3 = "HWID: 1"
local mWindowManager, mFloatingView, mCollapsed, mExpanded
local params, startX, startY, lastX, lastY
local shouldExit = false
local menuCriado = false
local L1Bad, L2Bad, patches, buttonLayout
local collapse_view, Status, frameLayout, mRootContainer
function dp(valor)
return TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, valor, activity.getResources().getDisplayMetrics())
end
function getLayoutType()
if Build.VERSION.SDK_INT >= 26 then
return WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
else
return WindowManager.LayoutParams.TYPE_PHONE
end
end
function criarBackground(cor, raio)
local drawable = luajava.newInstance("android.graphics.drawable.GradientDrawable")
drawable.setShape(GradientDrawable.RECTANGLE)
drawable.setColor(cor)
drawable.setCornerRadius(dp(raio))
return drawable
end
function criarBackgroundCustom(cor, raios)
local drawable = luajava.newInstance("android.graphics.drawable.GradientDrawable")
drawable.setShape(GradientDrawable.RECTANGLE)
drawable.setColor(cor)
drawable.setCornerRadii({dp(raios[1]), dp(raios[1]), dp(raios[2]), dp(raios[2]), dp(raios[3]), dp(raios[3]), dp(raios[4]), dp(raios[4])})
return drawable
end
InterfaceBool = {}
InterfaceBool.__index = InterfaceBool
function InterfaceBool:new(callback)
local obj = {callback = callback}
setmetatable(obj, InterfaceBool)
return obj
end
function InterfaceBool:OnWrite(valor)
if self.callback then self.callback(valor) end
end
InterfaceInt = {}
InterfaceInt.__index = InterfaceInt
function InterfaceInt:new(callback)
local obj = {callback = callback}
setmetatable(obj, InterfaceInt)
return obj
end
function InterfaceInt:OnWrite(valor)
if self.callback then self.callback(valor) end
end
function addSwitch(nome, sw)
local Bass = LinearLayout(activity)
Bass.setLayoutParams(LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT))
Bass.setOrientation(LinearLayout.VERTICAL)
local BadLayout = RelativeLayout(activity)
BadLayout.setLayoutParams(RelativeLayout.LayoutParams(RelativeLayout.LayoutParams.MATCH_PARENT, RelativeLayout.LayoutParams.WRAP_CONTENT))
BadLayout.setPadding(0, 0, 0, 0)
BadLayout.setGravity(Gravity.CENTER_VERTICAL)
local menu_HC = LinearLayout(activity)
menu_HC.setLayoutParams(LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT))
menu_HC.setGravity(Gravity.CENTER)
menu_HC.setOrientation(LinearLayout.HORIZONTAL)
local Off_bad = ImageView(activity)
Off_bad.setLayoutParams(LinearLayout.LayoutParams(dp(30), dp(30)))
Off_bad.setPadding(dp(5), dp(2), 0, dp(2))
Off_bad.setImageResource(android.R.drawable.ic_menu_edit)
local Cpu_txt = TextView(activity)
Cpu_txt.setLayoutParams(LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT))
Cpu_txt.setText(nome)
Cpu_txt.setTextSize(TypedValue.COMPLEX_UNIT_SP, 12)
Cpu_txt.setTypeface(nil, Typeface.BOLD)
Cpu_txt.setGravity(Gravity.CENTER_VERTICAL)
Cpu_txt.setPadding(dp(5), 0, 0, 0)
Cpu_txt.setTextColor(Color.WHITE)
local ott = Button(activity)
ott.setLayoutParams(LinearLayout.LayoutParams(dp(50), dp(20)))
ott.setText("DISABLE")
ott.setPadding(0, 0, 0, 0)
ott.setTextSize(TypedValue.COMPLEX_UNIT_SP, 12)
ott.setTextColor(Color.WHITE)
ott.setAllCaps(false)
ott.setBackgroundDrawable(criarBackground(Color.RED, 5))
local button = Button(activity)
button.setLayoutParams(LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, dp(30)))
button.setPadding(0, 0, 0, 0)
button.setTextSize(TypedValue.COMPLEX_UNIT_SP, 12)
button.setAllCaps(false)
button.setGravity(Gravity.CENTER)
button.setText("TO APPLY")
button.setTextColor(Color.WHITE)
button.setBackgroundDrawable(criarBackground(Color.RED, 5))
local isChecked = true
button.setOnClickListener(function()
isChecked = not isChecked
if sw then sw:OnWrite(isChecked) end
if isChecked then
Cpu_txt.setText(nome)
ott.setText("ON")
ott.setBackgroundDrawable(criarBackground(Color.GREEN, 5))
else
Cpu_txt.setText(nome)
ott.setText("OFF")
ott.setBackgroundDrawable(criarBackground(Color.RED, 5))
end
end)
menu_HC.addView(Off_bad)
menu_HC.addView(Cpu_txt)
BadLayout.addView(menu_HC)
BadLayout.addView(ott)
Bass.addView(BadLayout)
Bass.addView(button)
L1Bad.addView(Bass)
end
function addSwitch2(nome, sw)
local Bass = LinearLayout(activity)
Bass.setLayoutParams(LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT))
Bass.setOrientation(LinearLayout.VERTICAL)
local BadLayout = RelativeLayout(activity)
BadLayout.setLayoutParams(RelativeLayout.LayoutParams(RelativeLayout.LayoutParams.MATCH_PARENT, RelativeLayout.LayoutParams.WRAP_CONTENT))
BadLayout.setPadding(0, 0, 0, 0)
BadLayout.setGravity(Gravity.CENTER_VERTICAL)
local menu_HC = LinearLayout(activity)
menu_HC.setLayoutParams(LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT))
menu_HC.setGravity(Gravity.CENTER)
menu_HC.setOrientation(LinearLayout.HORIZONTAL)
local Off_bad = ImageView(activity)
Off_bad.setLayoutParams(LinearLayout.LayoutParams(dp(30), dp(30)))
Off_bad.setPadding(dp(5), dp(2), 0, dp(2))
Off_bad.setImageResource(android.R.drawable.ic_menu_edit)
local Cpu_txt = TextView(activity)
Cpu_txt.setLayoutParams(LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT))
Cpu_txt.setText(nome)
Cpu_txt.setTextSize(TypedValue.COMPLEX_UNIT_SP, 12)
Cpu_txt.setTypeface(nil, Typeface.BOLD)
Cpu_txt.setGravity(Gravity.CENTER_VERTICAL)
Cpu_txt.setPadding(dp(5), 0, 0, 0)
Cpu_txt.setTextColor(Color.WHITE)
local ott = Button(activity)
ott.setLayoutParams(LinearLayout.LayoutParams(dp(50), dp(20)))
ott.setText("DISABLE")
ott.setPadding(0, 0, 0, 0)
ott.setTextSize(TypedValue.COMPLEX_UNIT_SP, 12)
ott.setTextColor(Color.WHITE)
ott.setAllCaps(false)
ott.setBackgroundDrawable(criarBackground(Color.RED, 5))
local button = Button(activity)
button.setLayoutParams(LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, dp(30)))
button.setPadding(0, 0, 0, 0)
button.setTextSize(TypedValue.COMPLEX_UNIT_SP, 12)
button.setAllCaps(false)
button.setGravity(Gravity.CENTER)
button.setText("TO APPLY")
button.setTextColor(Color.WHITE)
button.setBackgroundDrawable(criarBackground(Color.RED, 5))
local isChecked = true
button.setOnClickListener(function()
isChecked = not isChecked
if sw then sw:OnWrite(isChecked) end
if isChecked then
Cpu_txt.setText(nome)
ott.setText("ENABLE")
ott.setBackgroundDrawable(criarBackground(Color.GREEN, 5))
else
Cpu_txt.setText(nome)
ott.setText("DISABLE")
ott.setBackgroundDrawable(criarBackground(Color.RED, 5))
end
end)
menu_HC.addView(Off_bad)
menu_HC.addView(Cpu_txt)
BadLayout.addView(menu_HC)
BadLayout.addView(ott)
Bass.addView(BadLayout)
Bass.addView(button)
L2Bad.addView(Bass)
end
function addSeekBar(feature, progress, max, interInt)
local linearLayout = LinearLayout(activity)
linearLayout.setLayoutParams(LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT))
linearLayout.setPadding(dp(5), dp(5), dp(5), dp(5))
linearLayout.setOrientation(LinearLayout.VERTICAL)
linearLayout.setGravity(Gravity.CENTER)
linearLayout.setBackgroundColor(Color.BLACK)
local Texttit = TextView(activity)
Texttit.setLayoutParams(LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT))
Texttit.setText(Html.fromHtml("<font face='BOLD'><b>" .. feature .. ": " .. max .. "/ <font color='RED'>" .. progress .. "</font>"))
Texttit.setTypeface(nil, Typeface.BOLD)
Texttit.setTextColor(Color.parseColor("#1D2C49"))
local sbSkeebar = SeekBar(activity)
sbSkeebar.setLayoutParams(LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT))
sbSkeebar.setPadding(dp(25), dp(10), dp(25), dp(10))
sbSkeebar.setMax(max)
sbSkeebar.setProgress(progress)
sbSkeebar.setOnSeekBarChangeListener({
onProgressChanged = function(seekBar, valor, fromUser)
if interInt then interInt:OnWrite(valor) end
Texttit.setText(Html.fromHtml("<font face='BOLD'><b>" .. feature .. ": " .. max .. "/ <font color='RED'>" .. valor .. "</font>"))
end,
onStartTrackingTouch = function() end,
onStopTrackingTouch = function() end
})
linearLayout.addView(Texttit)
linearLayout.addView(sbSkeebar)
patches.addView(linearLayout)
end
function Inject()
Toast.makeText(activity, "Injecting...", Toast.LENGTH_SHORT):show()
local success = true
if success then
collapse_view.setVisibility(View.VISIBLE)
mExpanded.setVisibility(View.GONE)
_spe = true
Toast.makeText(activity, "Injected Successfully", Toast.LENGTH_SHORT):show()
if buttonLayout then
buttonLayout.setVisibility(View.GONE)
end
if L1Bad and L2Bad then
L1Bad.setVisibility(View.VISIBLE)
L2Bad.setVisibility(View.VISIBLE)
end
else
Toast.makeText(activity, "Inject Failed", Toast.LENGTH_SHORT):show()
if buttonLayout then
buttonLayout.setVisibility(View.VISIBLE)
end
end
end
function criarMenu()
mWindowManager = activity.getSystemService("window")
if not mWindowManager then return false end
params = WindowManager.LayoutParams(
WindowManager.LayoutParams.WRAP_CONTENT,
WindowManager.LayoutParams.WRAP_CONTENT,
getLayoutType(),
WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL,
PixelFormat.TRANSLUCENT
)
params.gravity = Gravity.TOP + Gravity.LEFT
params.x = dp(50)
params.y = dp(100)
frameLayout = FrameLayout(activity)
frameLayout.setLayoutParams(FrameLayout.LayoutParams(FrameLayout.LayoutParams.WRAP_CONTENT, FrameLayout.LayoutParams.WRAP_CONTENT))
mRootContainer = RelativeLayout(activity)
mRootContainer.setLayoutParams(RelativeLayout.LayoutParams(RelativeLayout.LayoutParams.WRAP_CONTENT, RelativeLayout.LayoutParams.WRAP_CONTENT))
collapse_view = RelativeLayout(activity)
collapse_view.setLayoutParams(RelativeLayout.LayoutParams(RelativeLayout.LayoutParams.WRAP_CONTENT, RelativeLayout.LayoutParams.WRAP_CONTENT))
collapse_view.setAlpha(0.8)
collapse_view.setVisibility(View.VISIBLE)
collapse_view.setOnTouchListener({
onTouch = function(view, event)
local acao = event.getAction()
if acao == MotionEvent.ACTION_DOWN then
startX, startY = event.getRawX(), event.getRawY()
lastX, lastY = params.x, params.y
return true
elseif acao == MotionEvent.ACTION_MOVE then
params.x = lastX + (event.getRawX() - startX)
params.y = lastY + (event.getRawY() - startY)
mWindowManager.updateViewLayout(frameLayout, params)
return true
elseif acao == MotionEvent.ACTION_UP then
local diffX = math.abs(event.getRawX() - startX)
local diffY = math.abs(event.getRawY() - startY)
if diffX < 10 and diffY < 10 then
collapse_view.setVisibility(View.GONE)
mExpanded.setVisibility(View.VISIBLE)
end
return true
end
return false
end
})
local Iconstop = TextView(activity)
Iconstop.setLayoutParams(RelativeLayout.LayoutParams(dp(50), dp(50)))
Iconstop.setText("⚡")
Iconstop.setTextSize(24)
Iconstop.setTextColor(Color.YELLOW)
Iconstop.setGravity(Gravity.CENTER)
Iconstop.setBackgroundDrawable(criarBackground(Color.RED, 25))
collapse_view.addView(Iconstop)
mExpanded = LinearLayout(activity)
mExpanded.setVisibility(View.GONE)
mExpanded.setOrientation(LinearLayout.HORIZONTAL)
mExpanded.setPadding(dp(5), dp(5), dp(5), dp(5))
mExpanded.setLayoutParams(LinearLayout.LayoutParams(dp(400), LinearLayout.LayoutParams.WRAP_CONTENT))
mExpanded.setBackgroundDrawable(criarBackground(Color.BLACK, 5))
mExpanded.setOnTouchListener({
onTouch = function(view, event)
local acao = event.getAction()
if acao == MotionEvent.ACTION_DOWN then
startX, startY = event.getRawX(), event.getRawY()
lastX, lastY = params.x, params.y
return true
elseif acao == MotionEvent.ACTION_MOVE then
params.x = lastX + (event.getRawX() - startX)
params.y = lastY + (event.getRawY() - startY)
mWindowManager.updateViewLayout(frameLayout, params)
return true
end
return false
end
})
local Category_Linear = LinearLayout(activity)
Category_Linear.setLayoutParams(LinearLayout.LayoutParams(dp(150), LinearLayout.LayoutParams.WRAP_CONTENT))
Category_Linear.setPadding(0, 0, 0, 0)
Category_Linear.setOrientation(LinearLayout.VERTICAL)
Category_Linear.setGravity(Gravity.TOP + Gravity.CENTER_HORIZONTAL)
local ic_Logo = LinearLayout(activity)
ic_Logo.setLayoutParams(LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, dp(80)))
ic_Logo.setGravity(Gravity.CENTER)
local icto = TextView(activity)
icto.setLayoutParams(LinearLayout.LayoutParams(dp(60), dp(60)))
icto.setText("BAT")
icto.setTextSize(18)
icto.setTextColor(Color.CYAN)
icto.setGravity(Gravity.CENTER)
icto.setBackgroundDrawable(criarBackground(Color.DKGRAY, 30))
ic_Logo.addView(icto)
local ct_Layout = LinearLayout(activity)
ct_Layout.setGravity(Gravity.BOTTOM)
ct_Layout.setOrientation(LinearLayout.VERTICAL)
ct_Layout.setLayoutParams(LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT))
ct_Layout.setPadding(dp(5), dp(5), dp(5), dp(5))
local Ct_1 = LinearLayout(activity)
Ct_1.setOrientation(LinearLayout.HORIZONTAL)
Ct_1.setLayoutParams(LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, dp(30)))
Ct_1.setGravity(Gravity.CENTER_VERTICAL)
local User_txt = TextView(activity)
User_txt.setLayoutParams(LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT))
User_txt.setText(TEXT1)
User_txt.setTextSize(TypedValue.COMPLEX_UNIT_SP, 12)
User_txt.setTypeface(Typeface.MONOSPACE)
User_txt.setTextColor(Color.WHITE)
Ct_1.addView(User_txt)
local Ct_2 = LinearLayout(activity)
Ct_2.setOrientation(LinearLayout.HORIZONTAL)
Ct_2.setLayoutParams(LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, dp(30)))
Ct_2.setGravity(Gravity.CENTER_VERTICAL)
local Time_txt = TextView(activity)
Time_txt.setLayoutParams(LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT))
Time_txt.setText(TEXT2)
Time_txt.setTextSize(TypedValue.COMPLEX_UNIT_SP, 12)
Time_txt.setTypeface(Typeface.MONOSPACE)
Time_txt.setTextColor(Color.WHITE)
Ct_2.addView(Time_txt)
local Ct_3 = LinearLayout(activity)
Ct_3.setOrientation(LinearLayout.HORIZONTAL)
Ct_3.setLayoutParams(LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, dp(30)))
Ct_3.setGravity(Gravity.CENTER_VERTICAL)
local Cpu_txt = TextView(activity)
Cpu_txt.setLayoutParams(LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT))
Cpu_txt.setText(TEXT3)
Cpu_txt.setTextSize(TypedValue.COMPLEX_UNIT_SP, 12)
Cpu_txt.setTypeface(Typeface.MONOSPACE)
Cpu_txt.setTextColor(Color.WHITE)
Ct_3.addView(Cpu_txt)
Status = TextView(activity)
Status.setLayoutParams(LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, dp(25)))
Status.setText(Html.fromHtml("<b>status : </b><font color='#00FF00'>ONLINE</font>"))
Status.setGravity(Gravity.LEFT)
Status.setTypeface(nil, Typeface.NORMAL)
Status.setTextColor(Color.WHITE)
Status.setTextSize(11)
ct_Layout.addView(Ct_1)
ct_Layout.addView(Ct_2)
ct_Layout.addView(Ct_3)
ct_Layout.addView(Status)
local Feature_Linear = LinearLayout(activity)
Feature_Linear.setLayoutParams(LinearLayout.LayoutParams(dp(230), LinearLayout.LayoutParams.WRAP_CONTENT))
Feature_Linear.setOrientation(LinearLayout.VERTICAL)
Feature_Linear.setGravity(Gravity.TOP)
Feature_Linear.setPadding(dp(5), 0, 0, 0)
local BadLayout = LinearLayout(activity)
BadLayout.setLayoutParams(LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, dp(25)))
BadLayout.setOrientation(LinearLayout.HORIZONTAL)
BadLayout.setGravity(Gravity.RIGHT)
local Hide_Layout = LinearLayout(activity)
Hide_Layout.setLayoutParams(LinearLayout.LayoutParams(dp(45), dp(25)))
Hide_Layout.setGravity(Gravity.CENTER)
local Hide = TextView(activity)
Hide.setLayoutParams(LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT))
Hide.setText(Hide_txt)
Hide.setTextSize(TypedValue.COMPLEX_UNIT_SP, 17)
Hide.setTypeface(Typeface.MONOSPACE)
Hide.setGravity(Gravity.CENTER)
Hide.setTextColor(Color.LTGRAY)
Hide_Layout.setOnClickListener(function()
collapse_view.setVisibility(View.VISIBLE)
mExpanded.setVisibility(View.GONE)
end)
local Close_layout = LinearLayout(activity)
Close_layout.setLayoutParams(LinearLayout.LayoutParams(dp(45), dp(25)))
Close_layout.setGravity(Gravity.CENTER)
local Close_Bad = TextView(activity)
Close_Bad.setLayoutParams(LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT))
Close_Bad.setText(Close_txt)
Close_Bad.setTextSize(TypedValue.COMPLEX_UNIT_SP, 17)
Close_Bad.setTypeface(Typeface.MONOSPACE)
Close_Bad.setGravity(Gravity.CENTER)
Close_Bad.setTextColor(Color.LTGRAY)
Close_layout.setOnClickListener(function()

    shouldExit = true

    activity.runOnUiThread({
        run = function()
            pcall(function()
                if mWindowManager and mFloatingView then
                    mWindowManager.removeView(mFloatingView)
                end
            end)
        end
    })

end)
Hide_Layout.addView(Hide)
Close_layout.addView(Close_Bad)
BadLayout.addView(Hide_Layout)
BadLayout.addView(Close_layout)
local FLinear = LinearLayout(activity)
FLinear.setLayoutParams(LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT))
FLinear.setOrientation(LinearLayout.VERTICAL)
FLinear.setGravity(Gravity.CENTER)
buttonLayout = LinearLayout(activity)
buttonLayout.setOrientation(LinearLayout.VERTICAL)
buttonLayout.setGravity(Gravity.CENTER)
buttonLayout.setLayoutParams(LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, dp(45)))
local injectBtn = Button(activity)
injectBtn.setLayoutParams(LinearLayout.LayoutParams(dp(100), dp(35)))
injectBtn.setText("INJECT")
injectBtn.setTextColor(Color.WHITE)
injectBtn.setTextSize(TypedValue.COMPLEX_UNIT_SP, 10)
injectBtn.setGravity(Gravity.CENTER)
injectBtn.setTypeface(nil, Typeface.BOLD)
injectBtn.setBackgroundDrawable(criarBackground(Color.parseColor("#1D2C49"), 5))
injectBtn.setOnClickListener(function()
Inject()
end)
buttonLayout.addView(injectBtn)
patches = LinearLayout(activity)
patches.setLayoutParams(LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT))
patches.setOrientation(LinearLayout.HORIZONTAL)
patches.setGravity(Gravity.CENTER)
patches.setPadding(0, dp(5), 0, 0)
L1Bad = LinearLayout(activity)
L1Bad.setLayoutParams(LinearLayout.LayoutParams(0, LinearLayout.LayoutParams.WRAP_CONTENT, 1))
L1Bad.setOrientation(LinearLayout.VERTICAL)
L1Bad.setVisibility(View.GONE)
L2Bad = LinearLayout(activity)
L2Bad.setLayoutParams(LinearLayout.LayoutParams(0, LinearLayout.LayoutParams.WRAP_CONTENT, 1))
L2Bad.setOrientation(LinearLayout.VERTICAL)
L2Bad.setVisibility(View.GONE)

addSeekBar("Speed", 50, 100, InterfaceInt:new(function(val)  end))
frameLayout.addView(mRootContainer)
mRootContainer.addView(collapse_view)
frameLayout.addView(mExpanded)
mExpanded.addView(Category_Linear)
Category_Linear.addView(ic_Logo)
Category_Linear.addView(ct_Layout)
mExpanded.addView(Feature_Linear)
Feature_Linear.addView(BadLayout)
Feature_Linear.addView(FLinear)
FLinear.addView(buttonLayout)
FLinear.addView(patches)
patches.addView(L1Bad)
patches.addView(L2Bad)
mFloatingView = frameLayout
mWindowManager.addView(mFloatingView, params)
menuCriado = true
return true
end
activity.runOnUiThread({
run = function()
local ok, err = pcall(criarMenu)
if not ok then
print("Error: " .. tostring(err))
end
end
})
while not shouldExit do
gg.sleep(100)
 if _spe then
    _spe = false
    gg.setVisible(false)
    gg.setRanges(gg.REGION_CODE_APP)
    gg.searchNumber("-0.50344371796;9.99999997e-7;-0.50291442871::9", gg.TYPE_FLOAT)
    gg.refineNumber("9.99999997e-7", gg.TYPE_FLOAT)
    gg.getResults(100)
    gg.editAll("-1", gg.TYPE_FLOAT)
    gg.clearResults()
    gg.toast("⚡ SPEED HACK ACTIVATED")
  end
end
if menuCriado then
activity.runOnUiThread({
run = function()
pcall(function()
if mWindowManager and mFloatingView then
mWindowManager.removeView(mFloatingView)
end
end)
end
})
end
gg.sleep(500)
os.exit()

