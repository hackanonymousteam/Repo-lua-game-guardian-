if not luajava or not activity then
    print("LuaJava/Activity indisponível")
    return
end

gg.setVisible(false)

local function bind(c)
    local ok, r = pcall(luajava.bindClass, c)
    if ok then
        return r
    end
end

local LinearLayout = bind("android.widget.LinearLayout")
local TextView = bind("android.widget.TextView")
local ImageView = bind("android.widget.ImageView")
local Button = bind("android.widget.Button")
local Context = bind("android.content.Context")
local Gravity = bind("android.view.Gravity")
local Color = bind("android.graphics.Color")
local Build = bind("android.os.Build")
local MotionEvent = bind("android.view.MotionEvent")
local WindowManagerParams = bind("android.view.WindowManager$LayoutParams")
local PixelFormat = bind("android.graphics.PixelFormat")
local GradientDrawable = bind("android.graphics.drawable.GradientDrawable")
local BitmapFactory = bind("android.graphics.BitmapFactory")
local Typeface = bind("android.graphics.Typeface")

local function getWindowType()
    if Build.VERSION.SDK_INT >= 26 then
        return 2038
    elseif Build.VERSION.SDK_INT >= 23 then
        return 2002
    end
    return 2003
end

local r = gg.prompt(
    {"Insert link for QR Code"},
    {""},
    {"text"}
)

if not r then
    gg.setVisible(true)
    return
end

local link = r[1]

local req = gg.makeRequest(
    "https://api.qrserver.com/v1/create-qr-code/?data=" .. link
)

if not req or not req.content then
    print("Falha ao gerar QR")
    gg.setVisible(true)
    return
end

local path = "/sdcard/Qr_code.png"

local f = io.open(path, "wb")
f:write(req.content)
f:close()

local bitmap = BitmapFactory.decodeFile(path)

activity.runOnUiThread(
    luajava.createProxy(
        "java.lang.Runnable",
        {
            run = function()

                local wm =
                    activity.getSystemService(
                        Context.WINDOW_SERVICE
                    )

                local root =
                    LinearLayout(activity)

                root.setOrientation(
                    LinearLayout.VERTICAL
                )

                root.setGravity(
                    Gravity.CENTER
                )

                root.setPadding(
                    30,
                    30,
                    30,
                    30
                )

                local bg =
                    GradientDrawable()

                bg.setColor(
                    Color.parseColor(
                        "#1a1a2e"
                    )
                )

                bg.setCornerRadius(40)

                bg.setStroke(
                    4,
                    Color.parseColor(
                        "#0091FE"
                    )
                )

                root.setBackground(bg)

                local title =
                    TextView(activity)

                title.setText(
                    "QR Code Generated"
                )

                title.setTextSize(20)

                title.setTextColor(
                    Color.parseColor(
                        "#F9B947"
                    )
                )

                if Typeface then
                    title.setTypeface(
                        Typeface.DEFAULT_BOLD
                    )
                end

                title.setGravity(
                    Gravity.CENTER
                )

                root.addView(title)

                local img =
                    ImageView(activity)

                if bitmap then
                    img.setImageBitmap(
                        bitmap
                    )
                end

                local imgParams =
                    luajava.newInstance(
                        "android.widget.LinearLayout$LayoutParams",
                        500,
                        500
                    )

                imgParams.topMargin = 20
                imgParams.bottomMargin = 20

                img.setLayoutParams(
                    imgParams
                )

                root.addView(img)

                local text =
                    TextView(activity)

                text.setText(link)

                text.setTextColor(
                    Color.parseColor(
                        "#a0a0a0"
                    )
                )

                text.setGravity(
                    Gravity.CENTER
                )

                root.addView(text)

                local close =
                    Button(activity)

                close.setText("CLOSE")

                local closeBg =
                    GradientDrawable()

                closeBg.setColor(
                    Color.parseColor(
                        "#8b0000"
                    )
                )

                closeBg.setCornerRadius(
                    50
                )

                closeBg.setStroke(
                    3,
                    Color.parseColor(
                        "#ff4444"
                    )
                )

                close.setBackground(
                    closeBg
                )

                local closeParams =
                    luajava.newInstance(
                        "android.widget.LinearLayout$LayoutParams",
                        -1,
                        -2
                    )

                closeParams.topMargin = 30

                close.setLayoutParams(
                    closeParams
                )

                root.addView(close)

                local params =
                    WindowManagerParams(
                        -2,
                        -2,
                        getWindowType(),
                        0x00000028,
                        PixelFormat.TRANSLUCENT
                    )

                params.gravity =
                    Gravity.CENTER

                local windowView = root

                close.setOnClickListener(
    luajava.createProxy(
        "android.view.View$OnClickListener",
        {
            onClick = function()

                pcall(function()
                    root.setOnTouchListener(nil)
                end)

                pcall(function()
                    wm.removeView(root)
                end)

                root = nil

                

            end
        }
    )
)

                local startX = 0
                local startY = 0
                local touchX = 0
                local touchY = 0

                root.setOnTouchListener(
                    luajava.createProxy(
                        "android.view.View$OnTouchListener",
                        {
                            onTouch = function(
                                v,
                                e
                            )

                                local a =
                                    e.getAction()

                                if a == MotionEvent.ACTION_DOWN then

                                    startX =
                                        params.x

                                    startY =
                                        params.y

                                    touchX =
                                        e.getRawX()

                                    touchY =
                                        e.getRawY()

                                    return true

                                elseif a == MotionEvent.ACTION_MOVE then

                                    params.x =
                                        math.floor(
                                            startX +
                                            (
                                                e.getRawX()
                                                - touchX
                                            )
                                        )

                                    params.y =
                                        math.floor(
                                            startY +
                                            (
                                                e.getRawY()
                                                - touchY
                                            )
                                        )

                                    pcall(function()
                                        wm.updateViewLayout(
                                            root,
                                            params
                                        )
                                    end)

                                    return true
                                end

                                return false
                            end
                        }
                    )
                )

                wm.addView(
                    root,
                    params
                )

            end
        }
    )
)