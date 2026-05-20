if not luajava then
    print("LuaJava NOT Available!")
    return
end

if not activity then
    print("No activity available")
    return
end
gg.setVisible(false)
Link = "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQVBv2rEyZOkrGV3P3voAWy-dvvW4vWtFYEBWjMlMqu0w&s=10"
path = "/sdcard/"
Name = "Photo_For_Test.png"
local fullPath = path .. Name
bat = gg.makeRequest(Link).content
if bat == nil then
os.exit() end
io.open(path .. "/" .. Name, "w"):write(bat)

local BitmapFactory = luajava.bindClass("android.graphics.BitmapFactory")
local Bitmap = luajava.bindClass("android.graphics.Bitmap")
local Canvas = luajava.bindClass("android.graphics.Canvas")
local Paint = luajava.bindClass("android.graphics.Paint")
local PorterDuffXfermode = luajava.bindClass("android.graphics.PorterDuffXfermode")
local PorterDuffMode = luajava.bindClass("android.graphics.PorterDuff$Mode")
local Rect = luajava.bindClass("android.graphics.Rect")
local RectF = luajava.bindClass("android.graphics.RectF")

local Context = luajava.bindClass("android.content.Context")
local WindowManager = luajava.bindClass("android.view.WindowManager")
local LayoutParams = luajava.bindClass("android.view.WindowManager$LayoutParams")
local Gravity = luajava.bindClass("android.view.Gravity")
local PixelFormat = luajava.bindClass("android.graphics.PixelFormat")
local Build = luajava.bindClass("android.os.Build")
local Handler = luajava.bindClass("android.os.Handler")
local Looper = luajava.bindClass("android.os.Looper")
local ImageView = luajava.bindClass("android.widget.ImageView")

local mainHandler = Handler(Looper.getMainLooper())

local animationView = nil
local windowManager = nil
local params = nil

local isAnimating = false

local screenW = 600
local screenH = 1000

local posX = 0
local posY = 0

local velX = 12
local velY = 12

local originalLogo = BitmapFactory.decodeFile(fullPath)

if originalLogo == nil then
    print("Erro l")
    return
end

local function createCircularBitmap(bitmap)

    local size =
        math.min(
            bitmap.getWidth(),
            bitmap.getHeight()
        )

    local output =
        Bitmap.createBitmap(
            size,
            size,
            Bitmap.Config.ARGB_8888
        )

    local canvas =
        Canvas.new(output)

    local paint = Paint.new()

    paint.setAntiAlias(true)

    local rect =
        Rect.new(
            0,
            0,
            size,
            size
        )

    local rectF =
        RectF.new(rect)

    canvas.drawARGB(0, 0, 0, 0)

    canvas.drawOval(rectF, paint)

    paint.setXfermode(
        PorterDuffXfermode.new(
            PorterDuffMode.SRC_IN
        )
    )

    canvas.drawBitmap(
        bitmap,
        rect,
        rect,
        paint
    )

    return output
end

local logo =
    createCircularBitmap(
        originalLogo
    )

local function advance(pos, vel, max)

    pos = pos + vel

    if pos <= 0 then
        pos = 0
        vel = math.abs(vel)
    elseif pos >= max then
        pos = max
        vel = -math.abs(vel)
    end

    return pos, vel
end

local function updateAnimation()

    local lw = logo.getWidth()
    local lh = logo.getHeight()

    posX, velX =
        advance(
            posX,
            velX,
            screenW - lw
        )

    posY, velY =
        advance(
            posY,
            velY,
            screenH - lh
        )
end

local function render()

    if animationView == nil then
        return
    end

    local vw =
        animationView.getWidth()

    local vh =
        animationView.getHeight()

    if vw <= 0 or vh <= 0 then
        return
    end

    screenW = vw
    screenH = vh

    local frame =
        Bitmap.createBitmap(
            vw,
            vh,
            Bitmap.Config.ARGB_8888
        )

    local canvas =
        Canvas.new(frame)

    canvas.drawARGB(0, 0, 0, 0)

    canvas.drawBitmap(
        logo,
        posX,
        posY,
        nil
    )

    animationView.setImageBitmap(frame)
end

local drawRunnable

drawRunnable =
    luajava.createProxy(
        "java.lang.Runnable",
        {

            run = function()

                if not isAnimating then
                    return
                end

                pcall(function()

                    updateAnimation()

                    render()

                    mainHandler.postDelayed(
                        drawRunnable,
                        16
                    )
                end)
            end
        }
    )

function closeAnimation()

    isAnimating = false

    mainHandler.post(
        luajava.createProxy(
            "java.lang.Runnable",
            {

                run = function()

                    pcall(function()

                        if animationView ~= nil and
                            windowManager ~= nil then

                            windowManager.removeView(
                                animationView
                            )

                            animationView = nil
                        end
                    end)
                end
            }
        )
    )
end

function showAnimation()

    windowManager =
        activity.getSystemService(
            Context.WINDOW_SERVICE
        )

    local layoutType

    if Build.VERSION.SDK_INT >= 26 then
        layoutType =
            LayoutParams.TYPE_APPLICATION_OVERLAY
    else
        layoutType =
            LayoutParams.TYPE_PHONE
    end

    params = LayoutParams()

    params.type = layoutType

    params.format =
        PixelFormat.TRANSLUCENT

    params.flags =
        LayoutParams.FLAG_NOT_FOCUSABLE +
        LayoutParams.FLAG_NOT_TOUCHABLE +
        LayoutParams.FLAG_LAYOUT_IN_SCREEN

    params.width =
        LayoutParams.MATCH_PARENT

    params.height =
        LayoutParams.MATCH_PARENT

    params.gravity =
        Gravity.TOP + Gravity.LEFT

    params.x = 0
    params.y = 0

    animationView =
        ImageView(activity)

    animationView.setScaleType(
        ImageView.ScaleType.FIT_XY
    )

    mainHandler.post(
        luajava.createProxy(
            "java.lang.Runnable",
            {

                run = function()

                    pcall(function()

                        windowManager.addView(
                            animationView,
                            params
                        )

                        isAnimating = true

                        mainHandler.post(
                            drawRunnable
                        )
                    end)
                end
            }
        )
    )
end

showAnimation()

gg.sleep(30000)

closeAnimation()