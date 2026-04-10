gg.setVisible(false)

local Color = luajava.bindClass("android.graphics.Color")
local Context = luajava.bindClass("android.content.Context")
local Gravity = luajava.bindClass("android.view.Gravity")
local PixelFormat = luajava.bindClass("android.graphics.PixelFormat")
local TypedValue = luajava.bindClass("android.util.TypedValue")
local WindowManager = luajava.bindClass("android.view.WindowManager")
local Build = luajava.bindClass("android.os.Build")
local Handler = luajava.bindClass("android.os.Handler")
local Looper = luajava.bindClass("android.os.Looper")

local TextView = luajava.bindClass("android.widget.TextView")
local FrameLayout = luajava.bindClass("android.widget.FrameLayout")

local ObjectAnimator = luajava.bindClass("android.animation.ObjectAnimator")
local AnimatorSet = luajava.bindClass("android.animation.AnimatorSet")
local ValueAnimator = luajava.bindClass("android.animation.ValueAnimator")
local ArgbEvaluator = luajava.bindClass("android.animation.ArgbEvaluator")

local LinearInterpolator = luajava.bindClass("android.view.animation.LinearInterpolator")
local AccelerateInterpolator = luajava.bindClass("android.view.animation.AccelerateInterpolator")

local GradientDrawable = luajava.bindClass("android.graphics.drawable.GradientDrawable")

local mWindowManager, mFloatingView, params
local iconView, gradientDrawable
local pulseAnim
local isVisible = false
local autoCloseHandler = Handler(Looper.getMainLooper())

local WHITE = Color.parseColor("#FFFFFFFF")
local PRIMARY = Color.parseColor("#FF03FF00")
local PRIMARY_LIGHT = Color.parseColor("#FFBB86FC")
local STROKE_COLOR = Color.parseColor("#FFFF4444")

local function dp(v)
    return TypedValue.applyDimension(
        TypedValue.COMPLEX_UNIT_DIP,
        v,
        activity.getResources().getDisplayMetrics()
    )
end

local function getWindowType()
    if Build.VERSION.SDK_INT >= 26 then
        return WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
    else
        return WindowManager.LayoutParams.TYPE_SYSTEM_ALERT
    end
end

local function removeViewSafely()
    if mFloatingView and mWindowManager then
        pcall(function()
            mWindowManager.removeView(mFloatingView)
        end)
    end
    mFloatingView = nil
    iconView = nil
    gradientDrawable = nil
    isVisible = false
end

local function closeEverything()
    if pulseAnim then
        pulseAnim.cancel()
        pulseAnim = nil
    end

    if iconView then
        local fadeOut = ObjectAnimator.ofFloat(iconView, "alpha", 1, 0)
        fadeOut.setDuration(300)

        fadeOut.addListener(
            luajava.createProxy(
                "android.animation.Animator$AnimatorListener",
                {
                    onAnimationStart=function() end,
                    onAnimationEnd=function()
                        removeViewSafely()
                    end,
                    onAnimationCancel=function()
                        removeViewSafely()
                    end,
                    onAnimationRepeat=function() end
                }
            )
        )

        fadeOut.start()
    else
        removeViewSafely()
    end
end

local function startPulse()
    pulseAnim = ValueAnimator.ofObject(
        ArgbEvaluator(),
        PRIMARY,
        PRIMARY_LIGHT,
        PRIMARY
    )

    pulseAnim.setDuration(1800)
    pulseAnim.setRepeatCount(ValueAnimator.INFINITE)
    pulseAnim.setInterpolator(LinearInterpolator())

    pulseAnim.addUpdateListener(
        luajava.createProxy(
            "android.animation.ValueAnimator$AnimatorUpdateListener",
            {
                onAnimationUpdate = function(anim)
                    local color = anim.getAnimatedValue()
                    if gradientDrawable then
                        gradientDrawable.setColor(color)
                    end
                end
            }
        )
    )

    pulseAnim.start()
end

local function animateEntry()
    iconView.setAlpha(0)
    iconView.setScaleX(0.5)
    iconView.setScaleY(0.5)

    local alpha = ObjectAnimator.ofFloat(iconView, "alpha", 0, 1)
    local scaleX = ObjectAnimator.ofFloat(iconView, "scaleX", 0.5, 1.1, 1)
    local scaleY = ObjectAnimator.ofFloat(iconView, "scaleY", 0.5, 1.1, 1)

    local set = AnimatorSet()
    set.playTogether(alpha, scaleX, scaleY)
    set.setDuration(400)
    set.setInterpolator(AccelerateInterpolator())
    set.start()
end

local function showIcon(seconds, palavra, posX, posY)
    if isVisible then
        closeEverything()
        return
    end

    local texto = palavra or "⚡"
    local x = posX or 50
    local y = posY or 100
    local tempo = seconds or 3

    activity.runOnUiThread(
        luajava.createProxy("java.lang.Runnable",{
            run=function()

                mFloatingView = FrameLayout(activity)

                iconView = TextView(activity)
                
                
                
                iconView.setLayoutParams(
                    FrameLayout.LayoutParams(dp(300), dp(70))
                )
                iconView.setText(texto)
                iconView.setGravity(Gravity.CENTER)
                iconView.setTextColor(WHITE)
                iconView.setTextSize(24)

                gradientDrawable = GradientDrawable()
                gradientDrawable.setShape(GradientDrawable.RECTANGLE)
                gradientDrawable.setCornerRadius(dp(15))
                gradientDrawable.setColor(PRIMARY)
                gradientDrawable.setStroke(dp(4), STROKE_COLOR)
                iconView.setBackground(gradientDrawable)

                mFloatingView.addView(iconView)

                mWindowManager = activity.getSystemService(Context.WINDOW_SERVICE)

                params = WindowManager.LayoutParams(
                    dp(300),
                    dp(70),
                    getWindowType(),
                    WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE,
                    PixelFormat.TRANSPARENT
                )

                params.gravity = Gravity.TOP + Gravity.LEFT
                params.x = dp(x)
                params.y = dp(y)

                mWindowManager.addView(mFloatingView, params)

                animateEntry()
                startPulse()

                isVisible = true

                autoCloseHandler.postDelayed(
                    luajava.createProxy("java.lang.Runnable",{
                        run=function()
                            closeEverything()
                        end
                    }),
                    tempo * 1000
                )

                
            end
        })
    )
end


showIcon(6, "fuck you", 50, 300)
