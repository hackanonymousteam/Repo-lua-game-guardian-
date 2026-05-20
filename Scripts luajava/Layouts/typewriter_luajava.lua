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

        local view = TextView(activity)
        view.setTextColor(Color.parseColor("#FF00FF00"))
        view.setTextSize(25)
        view.setPadding(30, 30, 30, 30)
        view.setMinWidth(400)
        view.setMinHeight(100)
        view.setGravity(Gravity.CENTER)

        local mText = "Developer Batman"
        local mIndex = 1
        local mDelay = 200

        local characterAdder

        characterAdder = luajava.createProxy("java.lang.Runnable", {
            run = function()
                if mIndex <= string.len(mText) then
                    local partialText = string.sub(mText, 1, mIndex)
                    view.setText(partialText)

                    mIndex = mIndex + 1
                    mHandler.postDelayed(characterAdder, mDelay)
                end
            end
        })

        local function animateText(text)
            mText = text
            mIndex = 1
            view.setText("")
            mHandler.removeCallbacks(characterAdder)
            mHandler.post(characterAdder)
        end

        local closeButton = Button(activity)
        closeButton.setText("CLOSE")
        closeButton.setTextColor(Color.WHITE)
        closeButton.setBackgroundColor(Color.parseColor("#FFFF0000"))
        closeButton.setPadding(30, 20, 30, 20)
        closeButton.setTextSize(18)

        layout.addView(view)
        
        local spacer = TextView(activity)
        spacer.setHeight(40)
        layout.addView(spacer)
        
        layout.addView(closeButton)

        local wm = activity.getWindowManager()
        wm.addView(layout, params)
        
        gg.toast("Window added!")
        
        mHandler.postDelayed(luajava.createProxy("java.lang.Runnable", {
            run = function()
                animateText("Developer Batman")
                gg.toast("Animation started!")
            end
        }), 500)
        
        closeButton.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
            onClick = function(v)
                mHandler.removeCallbacks(characterAdder)
                wm.removeView(layout)
                gg.toast("Closed!")
            end
        }))
    end
}))