gg.setVisible(false)

import "android.widget.*"
import "android.graphics.*"
import "android.view.*"
import "java.io.*"
import "android.content.Context"
import "android.view.WindowManager"
import "android.view.WindowManager$LayoutParams"

local Context = luajava.bindClass("android.content.Context")
local WindowManager = luajava.bindClass("android.view.WindowManager")
local WindowManagerLayoutParams = luajava.bindClass("android.view.WindowManager$LayoutParams")
local wm = activity.getSystemService(Context.WINDOW_SERVICE)

local originalImage = nil
local currentImage = nil
local imageView = nil
local mainLayout = nil

function saveAndExit()
local data = os.date("%Y%m%d_%H%M%S")
            local path = "/sdcard/EditedImage_"..data..".png"
            
                local out = FileOutputStream(path)
                currentImage.compress(Bitmap.CompressFormat.PNG, 100, out)
                out.close()
gg.alert("✅ Image saved at:\n"..path)
        os.exit()
        end

local function dpToPx(dp)
    local metrics = activity.getResources().getDisplayMetrics()
    return math.floor(dp * (metrics.densityDpi / 160))
end

local function createInterface()
    mainLayout = LinearLayout(activity)
    mainLayout.setOrientation(LinearLayout.VERTICAL)
    mainLayout.setBackgroundColor(0xAA333333)
    mainLayout.setPadding(30, 30, 30, 30)

    imageView = luajava.newInstance("android.widget.ImageView", activity)
    imageView.setScaleType(ImageView.ScaleType.FIT_CENTER)
    imageView.setAdjustViewBounds(true)
    imageView.setLayoutParams(LinearLayout.LayoutParams(
        LinearLayout.LayoutParams.MATCH_PARENT,
        dpToPx(350)
    ))
    mainLayout.addView(imageView)

    local closeBtn = luajava.newInstance("android.widget.Button", activity)
    closeBtn.setText("❌ CLOSE EDITOR")
    closeBtn.setBackgroundColor(0xFFF44336)
    closeBtn.setTextColor(Color.WHITE)
    closeBtn.setTypeface(nil, Typeface.BOLD)
    closeBtn.setOnClickListener({
        onClick = function()
            activity.runOnUiThread(function()
                wm.removeView(mainLayout)
            end)
            gg.toast("Editor closed")
        end
    })
    mainLayout.addView(closeBtn)

    local params = luajava.new(WindowManagerLayoutParams)
    params.width = dpToPx(400)
    params.height = WindowManagerLayoutParams.WRAP_CONTENT
    params.format = PixelFormat.TRANSLUCENT
    params.type = WindowManagerLayoutParams.TYPE_APPLICATION_OVERLAY
    params.flags = WindowManagerLayoutParams.FLAG_NOT_FOCUSABLE
    params.gravity = Gravity.CENTER
    params.x = 0
    params.y = 0

    activity.runOnUiThread(function()
        wm.addView(mainLayout, params)
    end)
end

local function updateImage()
    activity.runOnUiThread(function()
        imageView.setImageBitmap(currentImage)
    end)
end

local function modificationMenu()
    while true do
        local choice = gg.choice({
            "🎨 ADJUST COLORS (RGB)",
            "⚫ BLACK AND WHITE",
            "🔄 INVERT COLORS",
            "💾 SAVE AND EXIT"
        }, nil, "IMAGE EDITOR - CHOOSE AN OPTION")
        
if not choice then gg.sleep(3000) end
        
        if choice == 1 then
            local values = gg.prompt({
                "Red (0-255):\n0=remove, 128=normal, 255=more",
                "Green (0-255):",
                "Blue (0-255):",
                "Operation:\n1=Set 2=Add 3=Multiply"
            }, {"128", "128", "128", "2"}, {"number", "number", "number", "number"})
            
            if values then
                local r, g, b, op = tonumber(values[1]), tonumber(values[2]), tonumber(values[3]), tonumber(values[4])
                
                local modifiedBitmap = originalImage.copy(Bitmap.Config.ARGB_8888, true)
                for y = 0, modifiedBitmap.getHeight()-1 do
                    for x = 0, modifiedBitmap.getWidth()-1 do
                        local pixel = modifiedBitmap.getPixel(x, y)
                        local a = Color.alpha(pixel)
                        local oldR = Color.red(pixel)
                        local oldG = Color.green(pixel)
                        local oldB = Color.blue(pixel)
                        
                        local newR = op == 1 and r or (op == 2 and (oldR + r) or (oldR * (r/255)))
                        local newG = op == 1 and g or (op == 2 and (oldG + g) or (oldG * (g/255)))
                        local newB = op == 1 and b or (op == 2 and (oldB + b) or (oldB * (b/255)))
                        
                        newR = math.max(0, math.min(255, newR))
                        newG = math.max(0, math.min(255, newG))
                        newB = math.max(0, math.min(255, newB))
                        
                        modifiedBitmap.setPixel(x, y, Color.argb(a, newR, newG, newB))
                    end
                end
                currentImage = modifiedBitmap
                updateImage()
            end
            
        elseif choice == 2 then
            local modifiedBitmap = originalImage.copy(Bitmap.Config.ARGB_8888, true)
            local matrix = ColorMatrix()
            matrix.setSaturation(0)
            
            local paint = Paint()
            paint.setColorFilter(ColorMatrixColorFilter(matrix))
            
            local canvas = Canvas(modifiedBitmap)
            canvas.drawBitmap(modifiedBitmap, 0, 0, paint)
            
            currentImage = modifiedBitmap
            updateImage()
            
        elseif choice == 3 then
            local modifiedBitmap = originalImage.copy(Bitmap.Config.ARGB_8888, true)
            for y = 0, modifiedBitmap.getHeight()-1 do
                for x = 0, modifiedBitmap.getWidth()-1 do
                    local pixel = modifiedBitmap.getPixel(x, y)
                    modifiedBitmap.setPixel(x, y, Color.argb(
                        Color.alpha(pixel),
                        255 - Color.red(pixel),
                        255 - Color.green(pixel),
                        255 - Color.blue(pixel)
                    ))
                end
            end
            currentImage = modifiedBitmap
            updateImage()
        elseif choice == 4 then saveAndExit() end
        end
        end

gg.toast("🔘 Select an image to edit")

local path = gg.prompt({"📂 Image path:"}, {"/sdcard/image.png"}, {"file"})
if not path then return end

local options = BitmapFactory.Options()
options.inPreferredConfig = Bitmap.Config.ARGB_8888
originalImage = BitmapFactory.decodeFile(path[1], options)

if not originalImage then
    gg.alert("❌ Failed to load image!\nCheck path and try again.")
    return
end

currentImage = originalImage.copy(Bitmap.Config.ARGB_8888, true)

createInterface()
updateImage()

modificationMenu()

activity.runOnUiThread(function()
    wm.removeView(mainLayout)
end)
gg.toast("Editor finished")