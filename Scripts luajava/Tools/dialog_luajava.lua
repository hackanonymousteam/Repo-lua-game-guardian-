gg.setVisible(false)
if luajava == nil then gg.alert(' unavaliable please use gameguardian mod (suport luajava)') else end

if not activity then
    gg.alert("No activity")
    return
end

local function bind(c)
    local ok, r = pcall(luajava.bindClass, c)
    if ok then return r end
    return nil
end

local LinearLayout = bind("android.widget.LinearLayout")
local TextView = bind("android.widget.TextView")
local Button = bind("android.widget.Button")
local ImageView = bind("android.widget.ImageView")
local ScrollView = bind("android.widget.ScrollView")
local Color = bind("android.graphics.Color")
local Gravity = bind("android.view.Gravity")
local GradientDrawable = bind("android.graphics.drawable.GradientDrawable")
local PixelFormat = bind("android.graphics.PixelFormat")
local Build = bind("android.os.Build")
local Intent = bind("android.content.Intent")
local Uri = bind("android.net.Uri")
local DisplayMetrics = bind("android.util.DisplayMetrics")

local metrics = DisplayMetrics()
activity.getWindowManager().getDefaultDisplay().getMetrics(metrics)

local function dp(v)
    return math.floor(v * metrics.density)
end

local function getType()
    if Build.VERSION.SDK_INT >= 26 then return 2038
    elseif Build.VERSION.SDK_INT >= 23 then return 2002
    else return 2003 end
end

local layout = LinearLayout(activity)
layout.setOrientation(LinearLayout.VERTICAL)
layout.setPadding(dp(20), dp(20), dp(20), dp(20))

local bg = GradientDrawable()
bg.setCornerRadius(dp(25))
bg.setColor(Color.parseColor("#111111"))
layout.setBackground(bg)

local title = TextView(activity)
title.setText("DIALOG BATMAN")
title.setTextColor(Color.WHITE)
title.setGravity(Gravity.CENTER)
title.setTextSize(18)
title.setPadding(0, 0, 0, dp(16))

local scroll = ScrollView(activity)
local scrollParams = LinearLayout.LayoutParams(dp(320), dp(350))
scroll.setLayoutParams(scrollParams)

local content = LinearLayout(activity)
content.setOrientation(LinearLayout.VERTICAL)

local card1 = LinearLayout(activity)
card1.setOrientation(LinearLayout.HORIZONTAL)
card1.setGravity(Gravity.CENTER_VERTICAL)
card1.setPadding(dp(10), dp(10), dp(10), dp(10))
local card1Params = LinearLayout.LayoutParams(dp(300), dp(70))
card1.setLayoutParams(card1Params)
local card1Bg = GradientDrawable()
card1Bg.setCornerRadius(dp(16))
card1Bg.setColor(Color.parseColor("#1A1A1A"))
card1.setBackground(card1Bg)
local icon1 = ImageView(activity)
local icon1Params = LinearLayout.LayoutParams(dp(45), dp(45))
icon1.setLayoutParams(icon1Params)
icon1.setImageResource(android.R.drawable.ic_menu_manage)
local name1 = TextView(activity)
name1.setText("Batman channel")
name1.setTextColor(Color.WHITE)
name1.setTextSize(14)
name1.setPadding(dp(12), 0, dp(8), 0)
local name1Params = LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT, 1.0)
name1.setLayoutParams(name1Params)
local btn1 = Button(activity)
btn1.setText("Get")
btn1.setTextColor(Color.WHITE)
btn1.setTextSize(12)
local btn1Bg = GradientDrawable()
btn1Bg.setCornerRadius(dp(12))
btn1Bg.setColor(Color.parseColor("#2575FC"))
btn1.setBackground(btn1Bg)
btn1.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
    onClick = function()
        local intent = Intent(Intent.ACTION_VIEW)
        intent.setData(Uri.parse("https://t.me/batmangamesSS"))
        activity.startActivity(intent)
        pcall(function()
            activity.getWindowManager().removeView(layout)
        end)
    end
}))
card1.addView(icon1)
card1.addView(name1)
card1.addView(btn1)

local card2 = LinearLayout(activity)
card2.setOrientation(LinearLayout.HORIZONTAL)
card2.setGravity(Gravity.CENTER_VERTICAL)
card2.setPadding(dp(10), dp(10), dp(10), dp(10))
local card2Params = LinearLayout.LayoutParams(dp(300), dp(70))
card2.setLayoutParams(card2Params)
local card2Bg = GradientDrawable()
card2Bg.setCornerRadius(dp(16))
card2Bg.setColor(Color.parseColor("#1A1A1A"))
card2.setBackground(card2Bg)
local icon2 = ImageView(activity)
local icon2Params = LinearLayout.LayoutParams(dp(45), dp(45))
icon2.setLayoutParams(icon2Params)
icon2.setImageResource(android.R.drawable.ic_menu_preferences)
local name2 = TextView(activity)
name2.setText("Batman  Scripts ")
name2.setTextColor(Color.WHITE)
name2.setTextSize(14)
name2.setPadding(dp(12), 0, dp(8), 0)
local name2Params = LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT, 1.0)
name2.setLayoutParams(name2Params)
local btn2 = Button(activity)
btn2.setText("Get")
btn2.setTextColor(Color.WHITE)
btn2.setTextSize(12)
local btn2Bg = GradientDrawable()
btn2Bg.setCornerRadius(dp(12))
btn2Bg.setColor(Color.parseColor("#2575FC"))
btn2.setBackground(btn2Bg)

btn2.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
    onClick = function()
        local intent = Intent(Intent.ACTION_VIEW)
        intent.setData(Uri.parse("https://t.me/share_scripts_lua_GG"))
        activity.startActivity(intent)
pcall(function()
            activity.getWindowManager().removeView(layout)
        end)
    end
}))
    
card2.addView(icon2)
card2.addView(name2)
card2.addView(btn2)

local card3 = LinearLayout(activity)
card3.setOrientation(LinearLayout.HORIZONTAL)
card3.setGravity(Gravity.CENTER_VERTICAL)
card3.setPadding(dp(10), dp(10), dp(10), dp(10))
local card3Params = LinearLayout.LayoutParams(dp(300), dp(70))
card3.setLayoutParams(card3Params)
local card3Bg = GradientDrawable()
card3Bg.setCornerRadius(dp(16))
card3Bg.setColor(Color.parseColor("#1A1A1A"))
card3.setBackground(card3Bg)
local icon3 = ImageView(activity)
local icon3Params = LinearLayout.LayoutParams(dp(45), dp(45))
icon3.setLayoutParams(icon3Params)
icon3.setImageResource(android.R.drawable.ic_menu_edit)
local name3 = TextView(activity)
name3.setText("Batman projects")
name3.setTextColor(Color.WHITE)
name3.setTextSize(14)
name3.setPadding(dp(12), 0, dp(8), 0)
local name3Params = LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT, 1.0)
name3.setLayoutParams(name3Params)
local btn3 = Button(activity)
btn3.setText("Get")
btn3.setTextColor(Color.WHITE)
btn3.setTextSize(12)
local btn3Bg = GradientDrawable()
btn3Bg.setCornerRadius(dp(12))
btn3Bg.setColor(Color.parseColor("#2575FC"))
btn3.setBackground(btn3Bg)
btn3.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
    onClick = function()
        local intent = Intent(Intent.ACTION_VIEW)
        intent.setData(Uri.parse("https://t.me/+K5gDLYipi_5jOTcx"))
        activity.startActivity(intent)
        pcall(function()
            activity.getWindowManager().removeView(layout)
        end)
    end
}))
card3.addView(icon3)
card3.addView(name3)
card3.addView(btn3)

local card4 = LinearLayout(activity)
card4.setOrientation(LinearLayout.HORIZONTAL)
card4.setGravity(Gravity.CENTER_VERTICAL)
card4.setPadding(dp(10), dp(10), dp(10), dp(10))
local card4Params = LinearLayout.LayoutParams(dp(300), dp(70))
card4.setLayoutParams(card4Params)
local card4Bg = GradientDrawable()
card4Bg.setCornerRadius(dp(16))
card4Bg.setColor(Color.parseColor("#1A1A1A"))
card4.setBackground(card4Bg)
local icon4 = ImageView(activity)
local icon4Params = LinearLayout.LayoutParams(dp(45), dp(45))
icon4.setLayoutParams(icon4Params)
icon4.setImageResource(android.R.drawable.ic_menu_save)
local name4 = TextView(activity)
name4.setText("Batman contact")
name4.setTextColor(Color.WHITE)
name4.setTextSize(14)
name4.setPadding(dp(12), 0, dp(8), 0)
local name4Params = LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT, 1.0)
name4.setLayoutParams(name4Params)
local btn4 = Button(activity)
btn4.setText("Get")
btn4.setTextColor(Color.WHITE)
btn4.setTextSize(12)
local btn4Bg = GradientDrawable()
btn4Bg.setCornerRadius(dp(12))
btn4Bg.setColor(Color.parseColor("#2575FC"))
btn4.setBackground(btn4Bg)
btn4.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
    onClick = function()
        local intent = Intent(Intent.ACTION_VIEW)
        intent.setData(Uri.parse("https://t.me/batmangamesS"))
        activity.startActivity(intent)
pcall(function()
            activity.getWindowManager().removeView(layout)
        end)
    end
}))
card4.addView(icon4)
card4.addView(name4)
card4.addView(btn4)

content.addView(card1)
content.addView(card2)
content.addView(card3)
content.addView(card4)

scroll.addView(content)

local closeBtn = Button(activity)
closeBtn.setText("Close")
closeBtn.setTextColor(Color.WHITE)

local closeBg = GradientDrawable()
closeBg.setCornerRadius(dp(12))
closeBg.setColor(Color.parseColor("#FF4444"))
closeBtn.setBackground(closeBg)

local btnParams = LinearLayout.LayoutParams(
    LinearLayout.LayoutParams.MATCH_PARENT,
    LinearLayout.LayoutParams.WRAP_CONTENT
)
--btnParams.setMargins(0, dp(16), 0, 0)
closeBtn.setLayoutParams(btnParams)

layout.addView(title)
layout.addView(scroll)
layout.addView(closeBtn)

local params = luajava.newInstance(
    "android.view.WindowManager$LayoutParams",
    -2, -2,
    getType(),
    0x00000008,
    PixelFormat.TRANSLUCENT
)

params.gravity = Gravity.CENTER

activity.runOnUiThread(luajava.createProxy("java.lang.Runnable", {
    run = function()
        local wm = activity.getWindowManager()
        
        closeBtn.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
            onClick = function()
                pcall(function()
                    wm.removeView(layout)
                end)
            end
        }))
        
        pcall(function()
            wm.addView(layout, params)
        end)
    end
}))