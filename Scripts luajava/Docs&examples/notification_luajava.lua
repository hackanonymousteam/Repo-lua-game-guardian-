gg.setVisible(false)

local TypedValue = luajava.bindClass("android.util.TypedValue")
local Gravity = luajava.bindClass("android.view.Gravity")
local PixelFormat = luajava.bindClass("android.graphics.PixelFormat")
local Color = luajava.bindClass("android.graphics.Color")
local GradientDrawable = luajava.bindClass("android.graphics.drawable.GradientDrawable")
local Typeface = luajava.bindClass("android.graphics.Typeface")
local View = luajava.bindClass("android.view.View")
local MotionEvent = luajava.bindClass("android.view.MotionEvent")
local WindowManager = luajava.bindClass("android.view.WindowManager")
local Context = luajava.bindClass("android.content.Context")
local Build = luajava.bindClass("android.os.Build")
local LinearLayout = luajava.bindClass("android.widget.LinearLayout")
local TextView = luajava.bindClass("android.widget.TextView")
local Button = luajava.bindClass("android.widget.Button")
local Handler = luajava.bindClass("android.os.Handler")
local Looper = luajava.bindClass("android.os.Looper")

local PRIMARY_COLOR = Color.parseColor("#FF8C00")
local WHITE = Color.parseColor("#FFFFFF")
local BLACK = Color.parseColor("#000000")
local RED = Color.parseColor("#F44336")
local GREEN = Color.parseColor("#4CAF50")
local BLUE = Color.parseColor("#2196F3")

local function dp(value)
    return TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, value, activity.getResources().getDisplayMetrics())
end

local function getShapeBackground(color, radius)
    local drawable = GradientDrawable()
    drawable.setShape(GradientDrawable.RECTANGLE)
    drawable.setColor(color)
    drawable.setCornerRadius(dp(radius))
    return drawable
end

local function getStatusBarHeight()
    local resourceId = activity.getResources().getIdentifier(
        "status_bar_height",
        "dimen",
        "android"
    )

    if resourceId > 0 then
        return activity.getResources().getDimensionPixelSize(resourceId)
    end

    return 0
end

local function getBorderBackground(bgColor, borderColor, borderWidth, radius)
    local drawable = GradientDrawable()
    drawable.setShape(GradientDrawable.RECTANGLE)
    drawable.setColor(bgColor)
    drawable.setStroke(dp(borderWidth), borderColor)
    drawable.setCornerRadius(dp(radius))
    return drawable
end

function getLayoutType()
    if Build.VERSION.SDK_INT >= 26 then
        return WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
    else
        return WindowManager.LayoutParams.TYPE_PHONE
    end
end

local windowManager = activity.getSystemService(Context.WINDOW_SERVICE)

local notificacoesAtivas = {}

function showNotification(mensagem, tipo, tempo)

    local corBg, corTexto, icone

    if tipo == "sucess" then
        corBg = GREEN
        corTexto = WHITE
        icone = "✓"
    elseif tipo == "error" then
        corBg = RED
        corTexto = WHITE
        icone = "✗"
    elseif tipo == "alert" then
        corBg = PRIMARY_COLOR
        corTexto = WHITE
        icone = "⚠"
    else
        corBg = BLUE
        corTexto = WHITE
        icone = "ℹ"
    end

    tempo = tempo or 3

    local metrics = activity.getResources().getDisplayMetrics()
    local larguraTela = metrics.widthPixels

    local layout = LinearLayout(activity)
    layout.setOrientation(LinearLayout.HORIZONTAL)
    layout.setGravity(Gravity.CENTER)
    layout.setPadding(dp(20), dp(15), dp(20), dp(15))
    layout.setBackground(getShapeBackground(corBg, 18))

    layout.setLayoutParams(
        LinearLayout.LayoutParams(
            larguraTela - dp(20),
            WindowManager.LayoutParams.WRAP_CONTENT
        )
    )

    local iconView = TextView(activity)
    iconView.setText(icone)
    iconView.setTextColor(corTexto)
    iconView.setTextSize(TypedValue.COMPLEX_UNIT_SP, 18)
    iconView.setTypeface(Typeface.DEFAULT_BOLD)
    iconView.setPadding(0, 0, dp(15), 0)
    layout.addView(iconView)

    local msgView = TextView(activity)
    msgView.setText(mensagem)
    msgView.setTextColor(corTexto)
    msgView.setTextSize(TypedValue.COMPLEX_UNIT_SP, 14)
    msgView.setTypeface(Typeface.DEFAULT_BOLD)
    layout.addView(msgView)

    local params = WindowManager.LayoutParams(
        larguraTela - dp(20),
        WindowManager.LayoutParams.WRAP_CONTENT,
        getLayoutType(),
        WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE,
        PixelFormat.TRANSLUCENT
    )

    params.gravity = Gravity.TOP | Gravity.CENTER_HORIZONTAL
    params.y = getStatusBarHeight()

    windowManager.addView(layout, params)

    layout.setTranslationY(-dp(120))
    layout.setAlpha(0)

    layout.animate()
        .translationY(0)
        .alpha(1)
        .setDuration(350)
        .start()

    local handler = Handler(Looper.getMainLooper())

    handler.postDelayed(luajava.createProxy("java.lang.Runnable", {
        run = function()
            layout.animate()
                .translationY(-dp(120))
                .alpha(0)
                .setDuration(300)
                .withEndAction(
                    luajava.createProxy("java.lang.Runnable", {
                        run = function()
                            pcall(function()
                                if layout.getParent() ~= nil then
                                    windowManager.removeView(layout)
                                end
                            end)
                        end
                    })
                )
                .start()
        end
    }), tempo * 1000)
end

function clearAllNotifications()
    for i, n in ipairs(notificacoesAtivas) do
        pcall(function()
            if n.layout.getParent() ~= nil then
                windowManager.removeView(n.layout)
            end
        end)
    end
    notificacoesAtivas = {}
end

if not windowManager then
    return
end

activity.runOnUiThread(function()
    showNotification("Speed Hack on", "sucess", 3)
end)