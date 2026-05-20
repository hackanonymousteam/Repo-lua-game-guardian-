gg.setVisible(false)

if not activity then return end

local function bind(c)
    local ok,r=pcall(luajava.bindClass,c)
    if ok then return r end
end

local TextView = bind("android.widget.TextView")
local Button = bind("android.widget.Button")
local LinearLayout = bind("android.widget.LinearLayout")
local ScaleGestureDetector = bind("android.view.ScaleGestureDetector")
local WindowManager = bind("android.view.WindowManager")
local PixelFormat = bind("android.graphics.PixelFormat")
local Gravity = bind("android.view.Gravity")
local Build = bind("android.os.Build")

local scale = 1.0

local function getType()
    if Build.VERSION.SDK_INT >= 26 then return 2038
    elseif Build.VERSION.SDK_INT >= 23 then return 2002
    else return 2003 end
end

activity.runOnUiThread(luajava.createProxy("java.lang.Runnable", {
    run = function()

        local root = LinearLayout(activity)
        root.setOrientation(1)
        root.setBackgroundColor(0xCC000000)

        local tv = TextView(activity)
        tv.setText("Pinch me")
        tv.setTextSize(20)

        local close = Button(activity)
        close.setText("✕")

        root.addView(tv)
        root.addView(close)

          local detector = ScaleGestureDetector(activity,
            luajava.createProxy("android.view.ScaleGestureDetector$OnScaleGestureListener", {
                onScale = function(d)
                    scale = scale * d.getScaleFactor()
                    tv.setTextSize(scale * 20)
                    return true
                end,
                onScaleBegin = function() return true end,
                onScaleEnd = function() end
            })
        )

        tv.setOnTouchListener(luajava.createProxy("android.view.View$OnTouchListener", {
            onTouch = function(v, e)
                detector.onTouchEvent(e)
                return true
            end
        }))

        local params = luajava.newInstance(
            "android.view.WindowManager$LayoutParams",
            -2, -2, getType(),
            0x00000008,
            PixelFormat.TRANSLUCENT
        )

        params.gravity = Gravity.CENTER

        local wm = activity.getWindowManager()
        wm.addView(root, params)

        close.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
            onClick = function()
                wm.removeView(root)
            end
        }))

    end
}))