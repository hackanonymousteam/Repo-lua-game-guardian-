gg.setVisible(false)

if not activity then
    gg.alert("No activity")
    return
end

local function bind(c)
    local ok, r = pcall(luajava.bindClass, c)
    if ok then
        return r
    end
    return nil
end

local Bitmap = bind("android.graphics.Bitmap")
local Canvas = bind("android.graphics.Canvas")
local Paint = bind("android.graphics.Paint")
local SweepGradient = bind("android.graphics.SweepGradient")

local ImageView = bind("android.widget.ImageView")
local TextView = bind("android.widget.TextView")
local LinearLayout = bind("android.widget.LinearLayout")
local Button = bind("android.widget.Button")

local Gravity = bind("android.view.Gravity")
local MotionEvent = bind("android.view.MotionEvent")
local PixelFormat = bind("android.graphics.PixelFormat")
local Color = bind("android.graphics.Color")
local Build = bind("android.os.Build")

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

params.gravity = Gravity.CENTER

local function rgbToHex(r, g, b)
    return string.format("#%02X%02X%02X", r, g, b)
end

local function hsvToRgb(h, s, v)

    local r = 0
    local g = 0
    local b = 0

    local i = math.floor(h * 6)
    local f = h * 6 - i

    local p = v * (1 - s)
    local q = v * (1 - f * s)
    local t = v * (1 - (1 - f) * s)

    i = i % 6

    if i == 0 then
        r = v
        g = t
        b = p

    elseif i == 1 then
        r = q
        g = v
        b = p

    elseif i == 2 then
        r = p
        g = v
        b = t

    elseif i == 3 then
        r = p
        g = q
        b = v

    elseif i == 4 then
        r = t
        g = p
        b = v

    elseif i == 5 then
        r = v
        g = p
        b = q
    end

    return
        math.floor(r * 255),
        math.floor(g * 255),
        math.floor(b * 255)
end

local function createColorWheel(size)

    local bmp = Bitmap.createBitmap(
        size,
        size,
        Bitmap.Config.ARGB_8888
    )

    local cx = size / 2
    local cy = size / 2
    local radius = size / 2

    for y = 0, size - 1 do
        for x = 0, size - 1 do

            local dx = x - cx
            local dy = y - cy

            local dist = math.sqrt(
                dx * dx + dy * dy
            )

            if dist <= radius then

                local angle = math.atan2(dy, dx)

                local hue =
                    (angle / (math.pi * 2)) + 0.5

                local saturation =
                    dist / radius

                local r, g, b =
                    hsvToRgb(
                        hue,
                        saturation,
                        1
                    )

                bmp.setPixel(
                    x,
                    y,
                    Color.rgb(r, g, b)
                )

            else

                bmp.setPixel(
                    x,
                    y,
                    Color.TRANSPARENT
                )
            end
        end
    end

    return bmp
end

local function createLayout()

    local root = LinearLayout(activity)
    root.setOrientation(1)
    root.setPadding(30,30,30,30)
    root.setBackgroundColor(
        Color.parseColor("#DD202020")
    )

    local title = TextView(activity)
    title.setText("COLOR PICKER")
    title.setTextColor(Color.WHITE)
    title.setTextSize(16)

    root.addView(title)

    local wheel = ImageView(activity)

    local bitmap = createColorWheel(500)

    wheel.setImageBitmap(bitmap)

    root.addView(wheel)

    local info = TextView(activity)
    info.setTextColor(Color.WHITE)
    info.setTextSize(14)
    info.setPadding(0,20,0,20)

    root.addView(info)

    wheel.setOnTouchListener(
        luajava.createProxy(
            "android.view.View$OnTouchListener",
            {
                onTouch = function(v, event)

                    local action = event.getAction()

                    if action == MotionEvent.ACTION_DOWN or
                       action == MotionEvent.ACTION_MOVE then

                        local x = math.floor(event.getX())
                        local y = math.floor(event.getY())

                        if x >= 0 and
                           y >= 0 and
                           x < bitmap.getWidth() and
                           y < bitmap.getHeight() then

                            local pixel = bitmap.getPixel(x, y)

                            if pixel ~= Color.TRANSPARENT then

                                local r = Color.red(pixel)
                                local g = Color.green(pixel)
                                local b = Color.blue(pixel)

                                local hex = rgbToHex(r,g,b)

                                root.setBackgroundColor(
                                    Color.rgb(r,g,b)
                                )

                                info.setText(
                                    "RGB: "..r..","..g..","..b..
                                    "\nHEX: "..hex
                                )
                            end
                        end
                    end

                    return true
                end
            }
        )
    )

    local close = Button(activity)

    close.setText("CLOSE")

    root.addView(close)

    local wm = activity.getWindowManager()

    wm.addView(root, params)

    close.setOnClickListener(
        luajava.createProxy(
            "android.view.View$OnClickListener",
            {
                onClick = function(v)
                    wm.removeView(root)
                end
            }
        )
    )
end

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