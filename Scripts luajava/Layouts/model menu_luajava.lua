
if luajava == nil then gg.alert(' unavaliable please use gameguardian mod (suport luajava)') else end

if not activity then
    gg.alert("No activity available")
    return
end
local Context = luajava.bindClass("android.content.Context")
local TextView = luajava.bindClass("android.widget.TextView")
local LinearLayout = luajava.bindClass("android.widget.LinearLayout")
local LinearLayout_LayoutParams = luajava.bindClass("android.widget.LinearLayout$LayoutParams")
local Button = luajava.bindClass("android.widget.Button")
local View = luajava.bindClass("android.view.View")
local Gravity = luajava.bindClass("android.view.Gravity")
local Color = luajava.bindClass("android.graphics.Color")
local PixelFormat = luajava.bindClass("android.graphics.PixelFormat")
local WindowManager = luajava.bindClass("android.view.WindowManager")
local WindowManager_LayoutParams = luajava.bindClass("android.view.WindowManager$LayoutParams")

local windowManager = activity.getSystemService(Context.WINDOW_SERVICE)

function dp_to_px(context, dp)
    local density = context.getResources().getDisplayMetrics().density
    return math.floor(dp * density + 0.5)
end

local menuLayout = LinearLayout(activity)
menuLayout.setOrientation(LinearLayout.VERTICAL)
menuLayout.setBackgroundColor(Color.parseColor("#AA000000"))
menuLayout.setPadding(
    dp_to_px(activity, 16),
    dp_to_px(activity, 16),
    dp_to_px(activity, 16),
    dp_to_px(activity, 16)
)

local itemLayoutParams = LinearLayout_LayoutParams(
    LinearLayout_LayoutParams.MATCH_PARENT,
    LinearLayout_LayoutParams.WRAP_CONTENT
)
itemLayoutParams.topMargin = dp_to_px(activity, 6)
itemLayoutParams.bottomMargin = dp_to_px(activity, 6)

local function addItem(text, onClick)
    local btn = Button(activity)
    btn.setText(text)
    btn.setLayoutParams(itemLayoutParams)
    btn.setBackgroundColor(Color.parseColor("#55000000"))
    btn.setTextColor(Color.WHITE)
    btn.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
        onClick = function()
            if onClick then onClick() end
        end
    }))
    menuLayout.addView(btn)
end

addItem("Start Game", function()  gg.toast("on") end)
addItem("Settings", function()  end)
addItem("About", function() end)
addItem("Exit", function()
    if menuLayout and windowManager then
        windowManager.removeView(menuLayout)
        menuLayout = nil
    end
end)

local layoutParams = WindowManager_LayoutParams()

layoutParams.width = dp_to_px(activity, 250)
layoutParams.height = WindowManager_LayoutParams.WRAP_CONTENT
layoutParams.format = PixelFormat.TRANSLUCENT
layoutParams.gravity = Gravity.CENTER

layoutParams.type = WindowManager_LayoutParams.TYPE_APPLICATION_OVERLAY
layoutParams.flags =
    WindowManager_LayoutParams.FLAG_NOT_FOCUSABLE +
    WindowManager_LayoutParams.FLAG_LAYOUT_IN_SCREEN

activity.runOnUiThread(luajava.createProxy("java.lang.Runnable", {
    run = function()
        windowManager.addView(menuLayout, layoutParams)
isMenuVisible = true
     end
}))

function removeMenu()
    if menuLayout ~= nil then
        activity.runOnUiThread(luajava.createProxy("java.lang.Runnable", {
            run = function()
                pcall(function()
                    windowManager.removeView(menuLayout)
                    
                end)
            end
        }))
        menuLayout = nil
    end
end


