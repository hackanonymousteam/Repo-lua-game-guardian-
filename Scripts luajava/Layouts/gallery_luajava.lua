gg.setVisible(false)
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "android.graphics.*"
import "android.graphics.drawable.*"
import "android.util.TypedValue"
import "android.content.Context"
import "android.view.WindowManager"
import "android.view.Gravity"
import "android.content.res.ColorStateList"
import "android.widget.*"
import "android.view.*"
import "android.graphics.*"
import "android.net.Uri"
import "java.io.File"
import "android.content.Context"
import "android.view.WindowManager"
import "android.view.WindowManager$LayoutParams"
local handler = Handler(Looper.getMainLooper())

local Context = luajava.bindClass("android.content.Context")
local WindowManager = luajava.bindClass("android.view.WindowManager")
local WindowManagerLayoutParams = luajava.bindClass("android.view.WindowManager$LayoutParams")

local wm = activity.getSystemService(Context.WINDOW_SERVICE)

local mainLayout
local scroll
local galleryLayout

local function dpToPx(dp)
    local metrics = activity.getResources().getDisplayMetrics()
    return math.floor(dp * (metrics.densityDpi / 160))
end

local function isImage(name)
    name = string.lower(name)
    return name:match("%.png$") or name:match("%.jpg$") or name:match("%.jpeg$")
end

local function scanDir(dir, result)
    local list = dir:listFiles()
    if list == nil then return end

    local len = list.length
    for i = 0, len - 1 do
        local f = list[i]
        if f ~= nil then
            if f:isDirectory() then
                scanDir(f, result)
            elseif f:isFile() then
                local name = f:getName()
                if isImage(name) then
                    table.insert(result, f:getAbsolutePath())
                end
            end
        end
    end
end

local function listImages(path)
    local result = {}
    scanDir(File(path), result)
    return result
end

local images = listImages("/sdcard/Pictures/")

function showGallery()
    galleryLayout.removeAllViews()

    for i = 1, #images do
        local img = ImageView(activity)
        img.setImageURI(Uri.parse("file://" .. images[i]))
        img.setAdjustViewBounds(true)
        img.setMaxHeight(dpToPx(200))
img.setMaxWidth(dpToPx(200))
        img.setOnClickListener({
            onClick = function()
                showFull(images[i])
            end
        })
activity.runOnUiThread(function()
        galleryLayout.addView(img)
    end)
        
    end
end

function showFull(path)
    mainLayout.removeAllViews()

    local root = LinearLayout(activity)
    root.setOrientation(LinearLayout.VERTICAL)

    local header = LinearLayout(activity)
    header.setOrientation(LinearLayout.HORIZONTAL)

    local btnBack = Button(activity)
    btnBack.setText("←")

    local btne = Button(activity)
    btne.setText("exit")
    local paramsBtn = LinearLayout.LayoutParams(
    300,  -- width  px
    120   -- height  px
)

btnBack.setLayoutParams(paramsBtn)
btne.setLayoutParams(paramsBtn)

    header.addView(btnBack)
    header.addView(btne)

    local full = ImageView(activity)
    full.setImageURI(Uri.parse("file://" .. path))
    full.setAdjustViewBounds(true)

    root.addView(header)
    root.addView(full)

    mainLayout.addView(root)

    btnBack.setOnClickListener({
        onClick = function()
            mainLayout.removeAllViews()
            mainLayout.addView(scroll)
gg.toast(path)
          --  mainLayout.addView(createExitButton())
        end
    })

    btne.setOnClickListener({
        onClick = function()
            activity.runOnUiThread(function()
                wm.removeView(mainLayout)
                
            end)
        end
    })
    
end

function createInterface()
    mainLayout = LinearLayout(activity)
    mainLayout.setOrientation(LinearLayout.VERTICAL)
    mainLayout.setBackgroundColor(0xAA222222)
    mainLayout.setPadding(20,20,20,20)

    scroll = ScrollView(activity)
    galleryLayout = LinearLayout(activity)
    galleryLayout.setOrientation(LinearLayout.VERTICAL)

    scroll.addView(galleryLayout)
    mainLayout.addView(scroll)
   
    local params = luajava.new(WindowManagerLayoutParams)
    params.width = dpToPx(600)
    params.height = dpToPx(600)
    params.format = PixelFormat.TRANSLUCENT
    params.type = WindowManagerLayoutParams.TYPE_APPLICATION_OVERLAY
    params.flags = WindowManagerLayoutParams.FLAG_NOT_FOCUSABLE
    params.gravity = Gravity.CENTER

    activity.runOnUiThread(function()
        wm.addView(mainLayout, params)        
    end)
end
        pcall(function()
            createInterface()
showGallery()
    end)