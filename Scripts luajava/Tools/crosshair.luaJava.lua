import 'android.app.*'
import 'android.os.*'
import 'android.widget.*'
import 'android.view.*'
import 'android.content.*'
import 'java.util.*'
import 'android.graphics.drawable.*'
import 'android.graphics.*'

context = activity
window = context.getSystemService(Context.WINDOW_SERVICE)

-- Control variables
local currentSize = 50
local currentColor = Color.parseColor("#FFD700") -- Default gold color
local isVisible = false

-- Window parameters
function getWindowParams()
    local LayoutParams = WindowManager.LayoutParams
    local params = luajava.new(LayoutParams)
    
    params.type = (Build.VERSION.SDK_INT >= 26) and LayoutParams.TYPE_APPLICATION_OVERLAY or LayoutParams.TYPE_PHONE
    params.format = PixelFormat.RGBA_8888
    params.flags = bit32.bor(LayoutParams.FLAG_NOT_TOUCH_MODAL, LayoutParams.FLAG_LAYOUT_IN_SCREEN)
    params.gravity = Gravity.CENTER
    params.width = LayoutParams.WRAP_CONTENT
    params.height = LayoutParams.WRAP_CONTENT
    
    return params
end

-- Crosshair layout
xfq = {
    LinearLayout,
    layout_height = 'wrap_content',
    layout_width = 'wrap_content',
    {
        TextView,
        id = 'suspended_ball',
        text = "+",
        layout_width = currentSize..'dp',
        layout_height = currentSize..'dp',
        textColor = currentColor,
        textSize = currentSize..'sp',
        gravity = "center",
        textStyle = "bold",
    }
}

xfq = loadlayout(xfq)

-- Update crosshair size
function updateSize(size)
    currentSize = size
    activity.runOnUiThread(function()
        local params = suspended_ball.getLayoutParams()
        params.width = size
        params.height = size
        suspended_ball.setLayoutParams(params)
        suspended_ball.setTextSize(size * 0.4)
        suspended_ball.requestLayout()
    end)
end

-- Update crosshair color
function updateColor(color)
    currentColor = color
    activity.runOnUiThread(function()
        suspended_ball.setTextColor(color)
    end)
end

-- Show/Hide crosshair
function toggleImage(show)
    activity.runOnUiThread(function()
        if show then
            if not isVisible then
                window.addView(xfq, getWindowParams())
                isVisible = true
            end
        else
            if isVisible then
                window.removeView(xfq)
                isVisible = false
            end
        end
    end)
end

-- Size adjustment menu
function sizeMenu()
    local option = gg.choice({
        "🔘 Small (50dp)",
        "🔘 Medium (100dp)",
        "🔘 Large (150dp)",
        "🎚 Custom",
        "↩ Back"
    }, nil, "📐 SIZE SETTINGS")
    
    if option == 1 then updateSize(50)
    elseif option == 2 then updateSize(100)
    elseif option == 3 then updateSize(150)
    elseif option == 4 then
        local size = gg.prompt({
            "Size (dp):"
        }, {tostring(currentSize)}, {"number"})
        
        if size and size[1] then
            updateSize(tonumber(size[1]))
        end
    end
end

-- Color selection menu
function colorMenu()
    local option = gg.choice({
        "🟡 Gold (Default)",
        "🔴 Red",
        "🟢 Green",
        "🔵 Blue",
        "⚪ White",
        "🎚 Custom (HEX)",
        "↩ Back"
    }, nil, "🎨 COLOR SELECTION")
    
    if option == 1 then updateColor(Color.parseColor("#FFD700")) -- Gold
    elseif option == 2 then updateColor(Color.parseColor("#FF0000")) -- Red
    elseif option == 3 then updateColor(Color.parseColor("#00FF00")) -- Green
    elseif option == 4 then updateColor(Color.parseColor("#0000FF")) -- Blue
    elseif option == 5 then updateColor(Color.parseColor("#FFFFFF")) -- White
    elseif option == 6 then
        local color = gg.prompt({
            "Color (HEX, ex: FF0000):"
        }, {"FFD700"}, {"text"})
        
        if color and color[1] then
            -- Add # if missing and validate HEX format
            local hex = color[1]
            if not hex:match("^#") then
                hex = "#" .. hex
            end
            if hex:match("^#[0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f]?[0-9A-Fa-f]?[0-9A-Fa-f]?$") then
                updateColor(Color.parseColor(hex))
            else
                gg.toast("Invalid HEX color!")
            end
        end
    end
end

-- Main menu
function mainMenu()
    local option = gg.choice({
        "👁️ "..(isVisible and "Hide" or "Show").." Crosshair",
        "📏 Adjust Size",
        "🎨 Change Color",
        "❌ Exit Script"
    }, nil, "🎯 CROSSHAIR - BATMAN GAMES")
    
    if option == 1 then
        toggleImage(not isVisible)
    elseif option == 2 then
        sizeMenu()
    elseif option == 3 then
        colorMenu()
    elseif option == 4 then
        exitScript()
    end
end

-- Exit function
function exitScript()
    toggleImage(false)
    gg.toast("Script finished!")
    os.exit()
end

-- Main loop
gg.setVisible(false)
while true do
    if gg.isVisible(true) then
        gg.setVisible(false)
        mainMenu()
    end
    gg.sleep(200)
end