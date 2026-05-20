gg.setVisible(false)

if not activity then return end

local function bind(c) local ok,r=pcall(luajava.bindClass,c) if ok then return r end end

local LinearLayout = bind("android.widget.LinearLayout")
local PopupWindow = bind("android.widget.PopupWindow")
local Button = bind("android.widget.Button")
local TextView = bind("android.widget.TextView")
local WindowManager = bind("android.view.WindowManager")
local PixelFormat = bind("android.graphics.PixelFormat")
local Gravity = bind("android.view.Gravity")
local Color = bind("android.graphics.Color")
local Build = bind("android.os.Build")

local function getType()
    if Build.VERSION.SDK_INT >= 26 then return 2038
    elseif Build.VERSION.SDK_INT >= 23 then return 2002
    else return 2003 end
end

local root = LinearLayout(activity)
root.setOrientation(1)
root.setBackgroundColor(0xCC000000)

local open = Button(activity)
open.setText("Open Popup")

local close = Button(activity)
close.setText("✕")

root.addView(open)
root.addView(close)

local params = luajava.newInstance("android.view.WindowManager$LayoutParams",-2,-2,getType(),0x00000008,PixelFormat.TRANSLUCENT)
params.gravity = Gravity.CENTER

activity.runOnUiThread(luajava.createProxy("java.lang.Runnable", {
    run=function()
        local wm = activity.getWindowManager()
        wm.addView(root, params)

        open.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
            onClick=function(v)

                local layout = LinearLayout(activity)
                layout.setOrientation(1)
                layout.setPadding(40,40,40,40)
                layout.setBackgroundColor(Color.BLACK)

                local txt = TextView(activity)
                txt.setText("Hello from Popup")
                txt.setTextColor(Color.WHITE)

                local btn = Button(activity)
                btn.setText("OK")

                layout.addView(txt)
                layout.addView(btn)

                local popup = PopupWindow(layout, -2, -2, true)
                popup.showAtLocation(v, Gravity.CENTER, 0, 0)

                btn.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
                    onClick=function()
                        gg.toast("Popup OK")
                        popup.dismiss()
                    end
                }))
            end
        }))

        close.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
            onClick=function()
                wm.removeView(root)
            end
        }))
    end
}))