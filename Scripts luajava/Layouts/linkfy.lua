gg.setVisible(false)

if not activity then
    gg.alert("No activity")
    return
end

local function bind(c)
    local ok, r = pcall(luajava.bindClass, c)
    if ok then return r end
    return nil
end

local TextView = bind("android.widget.TextView")
local WindowManager = bind("android.view.WindowManager")
local PixelFormat = bind("android.graphics.PixelFormat")
local Gravity = bind("android.view.Gravity")
local Color = bind("android.graphics.Color")
local Build = bind("android.os.Build")
local Handler = bind("android.os.Handler")
local Button = bind("android.widget.Button")
local LinearLayout = bind("android.widget.LinearLayout")
local Looper = bind("android.os.Looper")
local Linkify = bind("android.text.util.Linkify")
local MovementMethod = bind("android.text.method.LinkMovementMethod")

local function getType()
    if Build.VERSION.SDK_INT >= 26 then
        return 2038
    elseif Build.VERSION.SDK_INT >= 23 then
        return 2002
    else
        return 2003
    end
end

local params = luajava.newInstance(
    "android.view.WindowManager$LayoutParams",
    -2,
    -2,
    getType(),
    0x00000008,
    PixelFormat.TRANSLUCENT
)

params.gravity = Gravity.TOP + Gravity.LEFT
params.x = 100
params.y = 200

activity.runOnUiThread(luajava.createProxy("java.lang.Runnable", {
    run = function()
        local mHandler = Handler(Looper.getMainLooper())
        
        local layout = LinearLayout(activity)
        layout.setOrientation(LinearLayout.VERTICAL)
        layout.setBackgroundColor(Color.parseColor("#FF333333"))
        layout.setPadding(50, 50, 50, 50)

        local titleView = TextView(activity)
        titleView.setText("CLICKABLE LINKS")
        titleView.setTextColor(Color.parseColor("#FFFFFF00"))
        titleView.setTextSize(18)
        titleView.setPadding(20, 20, 20, 30)
        titleView.setGravity(Gravity.CENTER)
        layout.addView(titleView)

        local textview1 = TextView(activity)
        textview1.setText("Visit our website: https://www.google.com\n" ..
                         "Email: example@email.com\n" ..
                         "Phone: (11) 99999-9999\n" ..
                         "Address: 123 Example Street")
        textview1.setTextColor(Color.WHITE)
        textview1.setTextSize(16)
        textview1.setPadding(30, 30, 30, 30)
        textview1.setBackgroundColor(Color.parseColor("#FF444444"))
        
        textview1.setClickable(true)
        textview1.setLinksClickable(true)
        textview1.setLinkTextColor(Color.parseColor("#009688"))
        textview1.setMovementMethod(MovementMethod.getInstance())
        
        Linkify.addLinks(textview1, Linkify.ALL)
        
        layout.addView(textview1)

        local spacer = TextView(activity)
        spacer.setHeight(30)
        layout.addView(spacer)

        local closeButton = Button(activity)
        closeButton.setText("CLOSE")
        closeButton.setTextColor(Color.WHITE)
        closeButton.setBackgroundColor(Color.parseColor("#FFFF0000"))
        closeButton.setPadding(30, 20, 30, 20)
        closeButton.setTextSize(16)
        layout.addView(closeButton)

        local wm = activity.getWindowManager()
        wm.addView(layout, params)

        closeButton.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
            onClick = function(v)
                wm.removeView(layout)
                gg.toast("Closed!")
            end
        }))

        gg.toast("Links Panel Opened!")
    end
}))