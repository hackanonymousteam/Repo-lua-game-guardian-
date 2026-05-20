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
local Button = bind("android.widget.Button")
local LinearLayout = bind("android.widget.LinearLayout")
local Paint = bind("android.graphics.Paint")
local Path = bind("android.graphics.Path")
local Canvas = bind("android.graphics.Canvas")
local Bitmap = bind("android.graphics.Bitmap")
local MotionEvent = bind("android.view.MotionEvent")
local File = bind("java.io.File")
local FileOutputStream = bind("java.io.FileOutputStream")
local Environment = bind("android.os.Environment")
local SimpleDateFormat = bind("java.text.SimpleDateFormat")
local Date = bind("java.util.Date")

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
params.x = 10
params.y = 100

local function createLayout()
    local mPaint = Paint()
    mPaint.setAntiAlias(true)
    mPaint.setDither(true)
    mPaint.setColor(Color.BLACK)
    mPaint.setStyle(Paint.Style.STROKE)
    mPaint.setStrokeJoin(Paint.Join.ROUND)
    mPaint.setStrokeCap(Paint.Cap.ROUND)
    mPaint.setStrokeWidth(12)
    
    local layout = LinearLayout(activity)
    layout.setOrientation(LinearLayout.VERTICAL)
    layout.setBackgroundColor(Color.parseColor("#FF1A1A1A"))
    layout.setPadding(20, 20, 20, 20)

    local titleView = TextView(activity)
    titleView.setText("DRAWING CANVAS")
    titleView.setTextColor(Color.parseColor("#FF00E5FF"))
    titleView.setTextSize(16)
    titleView.setPadding(10, 10, 10, 15)
    titleView.setGravity(Gravity.CENTER)
    layout.addView(titleView)

    local ImageView = bind("android.widget.ImageView")
    local drawView = ImageView(activity)
    drawView.setBackgroundColor(Color.WHITE)
    drawView.setMinimumHeight(500)
    drawView.setMinimumWidth(600)
    
    local mBitmap = Bitmap.createBitmap(600, 500, Bitmap.Config.ARGB_8888)
    local mCanvas = Canvas(mBitmap)
    mCanvas.drawColor(Color.WHITE)
    drawView.setImageBitmap(mBitmap)
    
    local mPath = Path()
    local circlePaint = Paint()
    local circlePath = Path()
    local mX = 0
    local mY = 0
    local TOUCH_TOLERANCE = 4
    
    circlePaint.setAntiAlias(true)
    circlePaint.setColor(Color.BLUE)
    circlePaint.setStyle(Paint.Style.STROKE)
    circlePaint.setStrokeJoin(Paint.Join.MITER)
    circlePaint.setStrokeWidth(4)
    
    local function saveDrawing()
        local success = false
        local message = ""
        
        local ok, err = pcall(function()
            local picturesDir = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES)
            local drawFolder = File(picturesDir, "Drawings")
            if not drawFolder.exists() then
                drawFolder.mkdirs()
            end
            
            local dateFormat = SimpleDateFormat("yyyyMMdd_HHmmss")
            local currentDate = Date()
            local fileName = "Drawing_" .. dateFormat.format(currentDate) .. ".png"
            local file = File(drawFolder, fileName)
            
            local stream = FileOutputStream(file)
            mBitmap.compress(Bitmap.CompressFormat.PNG, 100, stream)
            stream.flush()
            stream.close()
            
            success = true
            message = "Saved to:\nPictures/Drawings/" .. fileName
        end)
        
        if success then
            gg.toast(message)
        else
            gg.toast("Error saving: " .. tostring(err))
        end
    end
    
    drawView.setOnTouchListener(luajava.createProxy("android.view.View$OnTouchListener", {
        onTouch = function(v, event)
            local x = event.getX()
            local y = event.getY()
            
            local action = event.getAction()
            if action == MotionEvent.ACTION_DOWN then
                mPath.reset()
                mPath.moveTo(x, y)
                mX = x
                mY = y
            elseif action == MotionEvent.ACTION_MOVE then
                local dx = math.abs(x - mX)
                local dy = math.abs(y - mY)
                if dx >= TOUCH_TOLERANCE or dy >= TOUCH_TOLERANCE then
                    mPath.quadTo(mX, mY, (x + mX)/2, (y + mY)/2)
                    mX = x
                    mY = y
                    circlePath.reset()
                    circlePath.addCircle(mX, mY, 30, Path.Direction.CW)
                end
            elseif action == MotionEvent.ACTION_UP then
                mPath.lineTo(mX, mY)
                circlePath.reset()
                mCanvas.drawPath(mPath, mPaint)
                mPath.reset()
            end
            
            local tempBitmap = mBitmap.copy(Bitmap.Config.ARGB_8888, true)
            local tempCanvas = Canvas(tempBitmap)
            tempCanvas.drawPath(mPath, mPaint)
            tempCanvas.drawPath(circlePath, circlePaint)
            drawView.setImageBitmap(tempBitmap)
            
            return true
        end
    }))
    
    layout.addView(drawView)

    local buttonLayout1 = LinearLayout(activity)
    buttonLayout1.setOrientation(LinearLayout.HORIZONTAL)
    buttonLayout1.setGravity(Gravity.CENTER)
    buttonLayout1.setPadding(0, 15, 0, 10)
    
    local clearButton = Button(activity)
    clearButton.setText("CLEAR")
    clearButton.setTextColor(Color.WHITE)
    clearButton.setBackgroundColor(Color.parseColor("#FFFF6600"))
    clearButton.setPadding(15, 15, 15, 15)
    clearButton.setTextSize(13)
    clearButton.setAllCaps(false)
    buttonLayout1.addView(clearButton)
    
    local spacer1 = TextView(activity)
    spacer1.setWidth(10)
    buttonLayout1.addView(spacer1)
    
    local saveButton = Button(activity)
    saveButton.setText("SAVE")
    saveButton.setTextColor(Color.WHITE)
    saveButton.setBackgroundColor(Color.parseColor("#FF4CAF50"))
    saveButton.setPadding(15, 15, 15, 15)
    saveButton.setTextSize(13)
    saveButton.setAllCaps(false)
    buttonLayout1.addView(saveButton)
    
    layout.addView(buttonLayout1)
    
    local buttonLayout2 = LinearLayout(activity)
    buttonLayout2.setOrientation(LinearLayout.HORIZONTAL)
    buttonLayout2.setGravity(Gravity.CENTER)
    buttonLayout2.setPadding(0, 5, 0, 0)
    
    local closeButton = Button(activity)
    closeButton.setText("CLOSE")
    closeButton.setTextColor(Color.WHITE)
    closeButton.setBackgroundColor(Color.parseColor("#FFFF1744"))
    closeButton.setPadding(15, 15, 15, 15)
    closeButton.setTextSize(13)
    closeButton.setAllCaps(false)
    buttonLayout2.addView(closeButton)
    
    layout.addView(buttonLayout2)
    
    local wm = activity.getWindowManager()
    wm.addView(layout, params)

    clearButton.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
        onClick = function(v)
            mCanvas.drawColor(Color.WHITE)
            mPath.reset()
            circlePath.reset()
            drawView.setImageBitmap(mBitmap)
            gg.toast("Canvas cleared!")
        end
    }))

    saveButton.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
        onClick = function(v)
            saveDrawing()
        end
    }))

    closeButton.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
        onClick = function(v)
            wm.removeView(layout)
            gg.toast("Closed!")
        end
    }))

    gg.toast("Drawing canvas opened!")
end

local function startUI()
    activity.runOnUiThread(
        luajava.createProxy(
            "java.lang.Runnable",
            {
                run = function()
                    createLayout()
                end
            }
        )
    )
end

startUI()