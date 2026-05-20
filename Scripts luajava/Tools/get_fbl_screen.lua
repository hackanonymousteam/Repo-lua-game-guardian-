if not luajava then
    print("LuaJava NOT Available!")
    return
end

if not activity then
    print("No activity available")
    return
end

gg.setVisible(false)

local Color = luajava.bindClass("android.graphics.Color")
local Context = luajava.bindClass("android.content.Context")
local Typeface = luajava.bindClass("android.graphics.Typeface")
local GradientDrawable = luajava.bindClass("android.graphics.drawable.GradientDrawable")
local Build = luajava.bindClass("android.os.Build")
local Handler = luajava.bindClass("android.os.Handler")
local Looper = luajava.bindClass("android.os.Looper")
local TypedValue = luajava.bindClass("android.util.TypedValue")
local Gravity = luajava.bindClass("android.view.Gravity")
local View = luajava.bindClass("android.view.View")
local ViewGroup = luajava.bindClass("android.view.ViewGroup")
local WindowManager = luajava.bindClass("android.view.WindowManager")
local LayoutParams = luajava.bindClass("android.view.WindowManager$LayoutParams")
local LinearLayout = luajava.bindClass("android.widget.LinearLayout")
local LinLayoutParams = luajava.bindClass("android.widget.LinearLayout$LayoutParams")
local FrameLayout = luajava.bindClass("android.widget.FrameLayout")
local FrameLayoutParams = luajava.bindClass("android.widget.FrameLayout$LayoutParams")
local TextView = luajava.bindClass("android.widget.TextView")
local Button = luajava.bindClass("android.widget.Button")
local Point = luajava.bindClass("android.graphics.Point")
local Runnable = luajava.bindClass("java.lang.Runnable")

local mainHandler = Handler(Looper.getMainLooper())

local windowManager = nil
local activeView = nil

local UI = {
    BG = Color.parseColor("#0f1117"),
    CARD = Color.parseColor("#1b1f2a"),
    ACCENT = Color.parseColor("#e94560"),
    WHITE = Color.parseColor("#FFFFFF"),
    GRAY = Color.parseColor("#9f9f9f")
}

local function dp(v)
    return math.floor(
        TypedValue.applyDimension(
            TypedValue.COMPLEX_UNIT_DIP,
            v,
            activity.getResources().getDisplayMetrics()
        )
    )
end

local function getSkin(color, radius, strokeWidth, strokeColor)
    local drawable = GradientDrawable()

    drawable.setColor(color)
    drawable.setCornerRadius(dp(radius))

    if strokeWidth and strokeColor then
        drawable.setStroke(dp(strokeWidth), strokeColor)
    end

    return drawable
end

local function getFbl()
    local wm = activity.getSystemService(Context.WINDOW_SERVICE)

    local point = Point()

    wm.getDefaultDisplay().getRealSize(point)

    return {
        width = point.x,
        height = point.y
    }
end

local function createLayout(layoutWidth, layoutHeight)
    local root = FrameLayout(activity)

    root.setLayoutParams(
        FrameLayoutParams(
            layoutWidth,
            layoutHeight
        )
    )

    local main = LinearLayout(activity)

    main.setOrientation(LinearLayout.VERTICAL)
    main.setPadding(dp(18), dp(18), dp(18), dp(18))
    main.setGravity(Gravity.CENTER_HORIZONTAL)
    main.setBackground(getSkin(UI.BG, 18, 2, UI.ACCENT))

    main.setLayoutParams(
        FrameLayoutParams(
            ViewGroup.LayoutParams.MATCH_PARENT,
            ViewGroup.LayoutParams.MATCH_PARENT
        )
    )

    local title = TextView(activity)

    title.setText("Simple Layout")
    title.setTextColor(UI.ACCENT)
    title.setTextSize(1, 20)
    title.setTypeface(Typeface.DEFAULT_BOLD)
    title.setGravity(Gravity.CENTER)

    title.setLayoutParams(
        LinLayoutParams(
            ViewGroup.LayoutParams.MATCH_PARENT,
            ViewGroup.LayoutParams.WRAP_CONTENT
        )
    )

    main.addView(title)

    local subtitle = TextView(activity)

    subtitle.setText("by batman")
    subtitle.setTextColor(UI.GRAY)
    subtitle.setTextSize(1, 13)
    subtitle.setGravity(Gravity.CENTER)

    subtitle.setPadding(
        0,
        dp(6),
        0,
        dp(18)
    )

    main.addView(subtitle)

    local infoCard = LinearLayout(activity)

    infoCard.setOrientation(LinearLayout.VERTICAL)
    infoCard.setPadding(dp(14), dp(14), dp(14), dp(14))
    infoCard.setBackground(getSkin(UI.CARD, 14))

    local cardParams = LinLayoutParams(
        ViewGroup.LayoutParams.MATCH_PARENT,
        0,
        1.0
    )

    infoCard.setLayoutParams(cardParams)

    local screen = getFbl()

    local txt1 = TextView(activity)
    txt1.setText("Width: " .. tostring(screen.width))
    txt1.setTextColor(UI.WHITE)
    txt1.setTextSize(1, 14)

    infoCard.addView(txt1)

    local txt2 = TextView(activity)
    txt2.setText("Height: " .. tostring(screen.height))
    txt2.setTextColor(UI.WHITE)
    txt2.setTextSize(1, 14)

    txt2.setPadding(0, dp(8), 0, 0)

    infoCard.addView(txt2)

    main.addView(infoCard)

    local closeBtn = Button(activity)

    closeBtn.setText("FECHAR")
    closeBtn.setAllCaps(false)
    closeBtn.setTextColor(UI.WHITE)
    closeBtn.setTextSize(1, 14)

    closeBtn.setBackground(
        getSkin(UI.ACCENT, 50)
    )

    local btnParams = LinLayoutParams(
        ViewGroup.LayoutParams.WRAP_CONTENT,
        ViewGroup.LayoutParams.WRAP_CONTENT
    )

    btnParams.topMargin = dp(18)

    closeBtn.setLayoutParams(btnParams)

    closeBtn.setPadding(
        dp(28),
        dp(10),
        dp(28),
        dp(10)
    )

    closeBtn.setOnClickListener(
        View.OnClickListener({
            onClick = function(v)
                closeUI()
            end
        })
    )

    main.addView(closeBtn)

    root.addView(main)

    return root
end

function showUI()
    mainHandler.post(
        Runnable({
            run = function()
                windowManager = activity.getSystemService(
                    Context.WINDOW_SERVICE
                )

                local screen = getFbl()

                local screenWidth = screen.width
                local screenHeight = screen.height

                local layoutWidth = math.floor(screenWidth * 0.70)
                local layoutHeight = math.floor(screenHeight * 0.35)

                local layoutType

                if Build.VERSION.SDK_INT >= 26 then
                    layoutType = LayoutParams.TYPE_APPLICATION_OVERLAY
                else
                    layoutType = LayoutParams.TYPE_PHONE
                end

                local params = LayoutParams(
                    layoutWidth,
                    layoutHeight,
                    layoutType,
                    LayoutParams.FLAG_LAYOUT_IN_SCREEN,
                    -3
                )

                params.gravity = Gravity.CENTER

                local layout = createLayout(
                    layoutWidth,
                    layoutHeight
                )

                pcall(function()
                    windowManager.addView(layout, params)
                    activeView = layout
                end)
            end
        })
    )
end

function closeUI()
    mainHandler.post(
        Runnable({
            run = function()
                pcall(function()
                    if activeView ~= nil then
                        windowManager.removeView(activeView)
                        activeView = nil
                    end
                end)
            end
        })
    )
end

showUI()

return {
    showUI = showUI,
    closeUI = closeUI
}