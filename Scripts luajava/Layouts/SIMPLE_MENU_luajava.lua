gg.setVisible(false)

if luajava == nil then gg.alert(' unavaliable please use gameguardian mod (suport luajava)') else end

if not activity then
    gg.alert("No activity available")
    return
end

local function bind(c)
    local ok, r = pcall(luajava.bindClass, c)
    if ok then return r end
    return nil
end

local LinearLayout = bind("android.widget.LinearLayout")
local Button = bind("android.widget.Button")
local TextView = bind("android.widget.TextView")
local WindowManager = bind("android.view.WindowManager")
local Build = bind("android.os.Build")
local Gravity = bind("android.view.Gravity")
local Color = bind("android.graphics.Color")
local PixelFormat = bind("android.graphics.PixelFormat")
local ViewGroup = bind("android.view.ViewGroup")
local DisplayMetrics = bind("android.util.DisplayMetrics")
local MotionEvent = bind("android.view.MotionEvent")

local metrics = DisplayMetrics()
activity.getWindowManager().getDefaultDisplay().getMetrics(metrics)

local function dp(v)
    return math.floor(v * metrics.density)
end

local function getType()
    if Build.VERSION.SDK_INT >= 26 then
        return 2038
    else
        return 2002
    end
end

activity.runOnUiThread(luajava.createProxy("java.lang.Runnable", {
    run = function()

        local wm = activity.getWindowManager()

        local layout = LinearLayout(activity)
        layout.setOrientation(1)
        layout.setPadding(dp(16), dp(16), dp(16), dp(16))
        layout.setBackgroundColor(Color.parseColor("#141414"))
        layout.setMinimumWidth(dp(260))
        layout.setMinimumHeight(dp(180))

        local title = TextView(activity)
        title.setText("SIMPLE MENU")
        title.setGravity(Gravity.CENTER)
        title.setTextColor(Color.parseColor("#FFFFFF"))
        title.setTextSize(14)

        local subtitle = TextView(activity)
        subtitle.setText("version 1.0")
        subtitle.setGravity(Gravity.CENTER)
        subtitle.setTextColor(Color.parseColor("#888888"))
        subtitle.setTextSize(12)

        local btn1 = Button(activity)
        btn1.setText("GOD MODE")
btn1.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
            onClick = function()
                pcall(function()
gg.toast("god mode on")



                end)
            end
        }))
        local btn2 = Button(activity)
        btn2.setText("SPEED HACK")
btn2.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
            onClick = function()
                pcall(function()
gg.toast(" speed on")
                end)
            end
        }))
        local btnExit = Button(activity)
        btnExit.setText("EXIT")

        layout.addView(title)
      layout.addView(subtitle)
        layout.addView(btn1)
        layout.addView(btn2)
        layout.addView(btnExit)

        local params = luajava.newInstance(
            "android.view.WindowManager$LayoutParams",
            math.floor(metrics.widthPixels * 0.4),
            ViewGroup.LayoutParams.WRAP_CONTENT,
            getType(),
            0x00000020,
            PixelFormat.TRANSLUCENT
        )

        params.gravity = Gravity.TOP + Gravity.LEFT
        params.x = 100
        params.y = 200

        local lastX = 0
        local lastY = 0
        local initX = 0
        local initY = 0
        local moving = false

        layout.setOnTouchListener(luajava.createProxy("android.view.View$OnTouchListener", {
            onTouch = function(v, event)
                local action = event.getAction()

                if action == MotionEvent.ACTION_DOWN then
                    moving = true
                    lastX = event.getRawX()
                    lastY = event.getRawY()
                    initX = params.x
                    initY = params.y
                    return true
                end

                if action == MotionEvent.ACTION_MOVE and moving then
                    local dx = event.getRawX() - lastX
                    local dy = event.getRawY() - lastY
                    params.x = initX + dx
                    params.y = initY + dy
                    pcall(function()
                        wm.updateViewLayout(layout, params)
                    end)
                    return true
                end

                if action == MotionEvent.ACTION_UP then
                    moving = false
                    return true
                end

                return false
            end
        }))

        btnExit.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
            onClick = function()
                pcall(function()
                    wm.removeView(layout)
                end)
            end
        }))

        local ok, err = pcall(function()
            wm.addView(layout, params)
        end)

        if not ok then
            gg.alert("Window error: " .. tostring(err))
        else
            gg.toast("UI loaded")
        end

    end
}))


