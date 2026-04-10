gg.setVisible(false)

import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "android.graphics.*"
import "android.content.*"
import "android.net.*"
import "android.provider.*"
import "android.content.pm.*"
import "android.graphics.Typeface"
import "android.graphics.drawable.*"
import "android.app.ActivityManager"
import "android.widget.Toast"
import "java.io.File"

local fontList = {
    "DroidSans.ttf",
    "DroidSans-Bold.ttf",
    "DroidSerif-Regular.ttf",
    "DroidSerif-Bold.ttf",
    "DroidSerif-Italic.ttf",
    "DroidSerif-BoldItalic.ttf",
    "Roboto-Regular.ttf",
    "Roboto-Bold.ttf",
    "Roboto-Italic.ttf",
    "Roboto-BoldItalic.ttf",
    "NotoSerif-Regular.ttf",
    "NotoSerif-Bold.ttf",
    "NotoSerif-Italic.ttf",
    "NotoSerif-BoldItalic.ttf",
    "CutiveMono.ttf",
    "DancingScript-Regular.ttf",
    "DancingScript-Bold.ttf"
}

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

function checkValue(v)
    local values = {
        normal = Typeface.NORMAL,
        bold = Typeface.BOLD,
        italic = Typeface.ITALIC,
        ["bold|italic"] = Typeface.BOLD_ITALIC,
        ["italic|bold"] = Typeface.BOLD_ITALIC
    }
    return values[v]
end

function setTextStyle(view, v)
    local face = checkValue(v) or -1
    local currentTypeface = view.getTypeface()
    local newTypeface = Typeface.create(currentTypeface, face)
    view.setTypeface(newTypeface)
end

function setTextFont(view, v)
    if type(v) == "string" then
        local path = "/system/fonts/" .. v
        if not path:find("%.ttf$") then
            path = path .. ".ttf"
        end
        local file = File(path)
        if file.exists() then
            view.setTypeface(Typeface.createFromFile(file))
        end
    end
end

function setTextAppearance(view, v)
    local resid = android.R.style[v:sub(2, -1)]
    if resid then
        view.setTextAppearance(activity, resid)
    end
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
setTextStyle(btn, "bold")
setTextFont(btn, "DroidSans-Bold.ttf")

menuLayout = LinearLayout(activity)
menuLayout.setOrientation(LinearLayout.VERTICAL)
menuLayout.setBackgroundColor(0x88000000)
menuLayout.setPadding(20, 20, 20, 20)

function createMenuButton(text, onClick)
    local btn = Button(activity)
    btn.setText(text)
    btn.setTextColor(Color.WHITE)
    btn.setTextSize(16)
    CircleButton(btn, 0xFFE76E00, 30, 0xFFFFFFFF)
    setTextStyle(btn, "bold")
    setTextFont(btn, "DancingScript-Regular.ttf")
    
    btn.setOnClickListener(View.OnClickListener{
        onClick = function(v)
            onClick()
            --menuLayout.setVisibility(View.GONE)
        end
    })
    return btn
end

function changeAllFontsRandomly()
    local randomFont = fontList[math.random(#fontList)]
    for i = 0, menuLayout.getChildCount() - 1 do
        local child = menuLayout.getChildAt(i)
        if child.getClass().getName() == "android.widget.Button" then
            setTextFont(child, randomFont)
        end
    end
    setTextFont(btn, randomFont)
    Toast.makeText(activity, "Font changed to: "..randomFont, Toast.LENGTH_SHORT).show()
    
    -- Keep the menu visible after changing font
    menuLayout.setVisibility(View.VISIBLE)
end

local buttons = {
    {"Start", function() 
_speedHackPending = true
       -- Toast.makeText(activity, "Start pressed", Toast.LENGTH_SHORT).show()
    end},
    {"Stop", function() 
        Toast.makeText(activity, "Stop pressed", Toast.LENGTH_SHORT).show()
    end},
    {"Settings", function() 
        Toast.makeText(activity, "Settings pressed", Toast.LENGTH_SHORT).show()
    end},
    {"Change Font", function() 
    
        changeAllFontsRandomly()
changeAllFontsRandomly()
     --   menuLayout.setVisibility(View.VISIBLE)
    end},
    {"Exit", function() 
        wm.removeView(btn)
        wm.removeView(menuLayout)
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

local str_mt = debug.getmetatable("string")
if str_mt then
    debug.setmetatable("string", str_mt)
end

local ids = luajava.ids
local _G = _G
local insert = table.insert
local new = luajava.new
local bindClass = luajava.bindClass
local ltrs = {}

local File = bindClass("java.io.File")
local ViewGroup = bindClass("android.view.ViewGroup")
local String = bindClass("java.lang.String")
local Gravity = bindClass("android.view.Gravity")
local OnClickListener = bindClass("android.view.View$OnClickListener")
local TypedValue = bindClass("android.util.TypedValue")
local BitmapDrawable = bindClass("android.graphics.drawable.BitmapDrawable")

ScaleType = bindClass("android.widget.ImageView$ScaleType")
TruncateAt = bindClass("android.text.TextUtils$TruncateAt")
scaleTypes = ScaleType.values()
android_R = bindClass("android.R")
android = {R = android_R}

Context = bindClass("android.content.Context")
DisplayMetrics = bindClass("android.util.DisplayMetrics")

wm = context.getSystemService(Context.WINDOW_SERVICE)
outMetrics = DisplayMetrics()
wm.getDefaultDisplay().getMetrics(outMetrics)
W = outMetrics.widthPixels
H = outMetrics.heightPixels

ver = luajava.bindClass("android.os.Build").VERSION.SDK_INT
function setBackground(view, bg)
    if ver < 16 then
        view.setBackgroundDrawable(bg)
    else
        view.setBackground(bg)
    end
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