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

local LinearLayout = bind("android.widget.LinearLayout")
local FrameLayout = bind("android.widget.FrameLayout")
local TextView = bind("android.widget.TextView")
local SeekBar = bind("android.widget.SeekBar")
local Button = bind("android.widget.Button")
local WindowManager = bind("android.view.WindowManager")
local PixelFormat = bind("android.graphics.PixelFormat")
local Gravity = bind("android.view.Gravity")
local Color = bind("android.graphics.Color")
local Build = bind("android.os.Build")
local GradientDrawable = bind("android.graphics.drawable.GradientDrawable")

local function dp(v)
    local d = activity.getResources().getDisplayMetrics().density
    return math.floor(v * d + 0.5)
end

local function getType()
    if Build.VERSION.SDK_INT >= 26 then
        return 2038
    elseif Build.VERSION.SDK_INT >= 23 then
        return 2002
    else
        return 2003
    end
end

local function bg(color, radius, stroke, strokeSize)
    local g = GradientDrawable()
    g.setShape(GradientDrawable.RECTANGLE)
    g.setCornerRadius(dp(radius))
    g.setColor(color)

    if stroke then
        g.setStroke(dp(strokeSize or 1), stroke)
    end

    return g
end

local function createUI()

    local root = LinearLayout(activity)
    root.setOrientation(LinearLayout.VERTICAL)
    root.setGravity(Gravity.CENTER_HORIZONTAL)
    root.setPadding(dp(25), dp(25), dp(25), dp(25))

    root.setBackgroundDrawable(
        bg(
            Color.BLACK,
            28,
            Color.argb(255, 40, 40, 40),
            2
        )
    )

    local title = TextView(activity)
    title.setText("SEEK BAR")
    title.setTextColor(Color.WHITE)
    title.setTextSize(21)
    title.setGravity(Gravity.CENTER)
    title.setPadding(0, 0, 0, dp(25))

    root.addView(title)

    local value = TextView(activity)
    value.setText("50")
    value.setTextSize(30)
    value.setTextColor(Color.WHITE)
    value.setGravity(Gravity.CENTER)
    value.setPadding(dp(22), dp(10), dp(22), dp(10))

    value.setBackgroundDrawable(
        bg(
            Color.argb(255, 0, 170, 255),
            100
        )
    )

    local valueParams = LinearLayout.LayoutParams(-2, -2)
    value.setLayoutParams(valueParams)

    root.addView(value)

    local space1 = TextView(activity)
    space1.setPadding(0, dp(20), 0, 0)
    root.addView(space1)

    local seekHolder = FrameLayout(activity)

    local seekBg = LinearLayout(activity)
    seekBg.setBackgroundDrawable(
        bg(
            Color.argb(255, 25, 25, 25),
            100
        )
    )

    local seekBgParams = FrameLayout.LayoutParams(dp(320), dp(16))
    seekBg.setLayoutParams(seekBgParams)

    seekHolder.addView(seekBg)

    local seekBar = SeekBar(activity)
    seekBar.setMax(100)
    seekBar.setProgress(50)

    local seekParams = FrameLayout.LayoutParams(dp(320), -2)
    seekBar.setLayoutParams(seekParams)

    seekHolder.addView(seekBar)

    root.addView(seekHolder)

    local labels = LinearLayout(activity)
    labels.setOrientation(LinearLayout.HORIZONTAL)

    local labelsParams = LinearLayout.LayoutParams(dp(320), -2)
    labels.setLayoutParams(labelsParams)

    local values = {0, 25, 50, 75, 100}

    for i = 1, #values do

        local t = TextView(activity)
        t.setText(tostring(values[i]))
        t.setTextColor(Color.argb(255, 120, 120, 120))
        t.setTextSize(11)
        t.setGravity(Gravity.CENTER)

        local lp = LinearLayout.LayoutParams(0, -2, 1)
        t.setLayoutParams(lp)

        labels.addView(t)
    end

    root.addView(labels)

    local info = TextView(activity)
    info.setText("PROGRESS 50%")
    info.setTextColor(Color.argb(255, 0, 170, 255))
    info.setTextSize(13)
    info.setGravity(Gravity.CENTER)
    info.setPadding(0, dp(20), 0, dp(20))

    root.addView(info)

    local buttons = LinearLayout(activity)
    buttons.setOrientation(LinearLayout.HORIZONTAL)
    buttons.setGravity(Gravity.CENTER)

    local reset = Button(activity)
    reset.setText("RESET")
    reset.setTextColor(Color.WHITE)
    reset.setAllCaps(false)

    reset.setBackgroundDrawable(
        bg(
            Color.argb(255, 35, 35, 35),
            14
        )
    )

    local close = Button(activity)
    close.setText("FECHAR")
    close.setTextColor(Color.WHITE)
    close.setAllCaps(false)

    close.setBackgroundDrawable(
        bg(
            Color.argb(255, 200, 40, 40),
            14
        )
    )

    local resetParams = LinearLayout.LayoutParams(dp(130), dp(45))
    reset.setLayoutParams(resetParams)

    local spacer = TextView(activity)
    spacer.setPadding(dp(10), 0, 0, 0)

    local closeParams = LinearLayout.LayoutParams(dp(130), dp(45))
    close.setLayoutParams(closeParams)

    buttons.addView(reset)
    buttons.addView(spacer)
    buttons.addView(close)

    root.addView(buttons)

    return {
        root = root,
        seekBar = seekBar,
        value = value,
        info = info,
        reset = reset,
        close = close
    }
end

local params = luajava.newInstance(
    "android.view.WindowManager$LayoutParams",
    dp(300), -- largura
    dp(400), -- altura
    getType(),
    0x00000008,
    PixelFormat.OPAQUE
)

params.gravity = Gravity.CENTER

local function start()

    local ui = createUI()
    local wm = activity.getWindowManager()

    activity.runOnUiThread(
        luajava.createProxy(
            "java.lang.Runnable",
            {
                run = function()
                    wm.addView(ui.root, params)
                end
            }
        )
    )

    ui.seekBar.setOnSeekBarChangeListener(
        luajava.createProxy(
            "android.widget.SeekBar$OnSeekBarChangeListener",
            {

                onProgressChanged = function(bar, progress, fromUser)

                    ui.value.setText(tostring(progress))
                    ui.info.setText("PROGRESS " .. progress .. "%")

                    ui.value.animate()
                        .scaleX(1.08)
                        .scaleY(1.08)
                        .setDuration(60)
                        .withEndAction(
                            luajava.createProxy(
                                "java.lang.Runnable",
                                {
                                    run = function()
                                        ui.value.animate()
                                            .scaleX(1)
                                            .scaleY(1)
                                            .setDuration(60)
                                            .start()
                                    end
                                }
                            )
                        )
                        .start()
                end,

                onStartTrackingTouch = function(bar)

                    ui.value.setBackgroundDrawable(
                        bg(
                            Color.WHITE,
                            100
                        )
                    )

                    ui.value.setTextColor(Color.BLACK)
                end,

                onStopTrackingTouch = function(bar)

                    ui.value.setBackgroundDrawable(
                        bg(
                            Color.argb(255, 0, 170, 255),
                            100
                        )
                    )

                    ui.value.setTextColor(Color.WHITE)
                end
            }
        )
    )

    ui.reset.setOnClickListener(
        luajava.createProxy(
            "android.view.View$OnClickListener",
            {
                onClick = function(v)
                    ui.seekBar.setProgress(50)
                end
            }
        )
    )

    ui.close.setOnClickListener(
        luajava.createProxy(
            "android.view.View$OnClickListener",
            {
                onClick = function(v)
                    wm.removeView(ui.root)
                end
            }
        )
    )
end

start()