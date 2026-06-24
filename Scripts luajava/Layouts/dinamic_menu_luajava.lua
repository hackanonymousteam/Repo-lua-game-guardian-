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
local Switch = luajava.bindClass("android.widget.Switch")
local Point = luajava.bindClass("android.graphics.Point")
local CompoundButton = luajava.bindClass("android.widget.CompoundButton")
local MotionEvent = luajava.bindClass("android.view.MotionEvent")

function randomColors()
    local chars = "0123456789ABCDEF"
    local color = "#"
    for i = 1, 6 do
        local randomIndex = math.random(1, #chars)
        color = color .. chars:sub(randomIndex, randomIndex)
    end
    return color
end

local themes = {
    minimal = {
        padding = {16, 20, 24},
        textTitle = {18, 20, 22},
        textNormal = {13, 14, 15},
        textSmall = {10, 11, 12},
        corner = {12, 16, 20},
        border = {1, 2},
        elevation = {2, 4, 6},
        margin = {8, 12, 16},
        alpha = {0.85, 0.90, 0.95}
    },
    modern = {
        padding = {20, 24, 28},
        textTitle = {20, 22, 24},
        textNormal = {14, 15, 16},
        textSmall = {11, 12, 13},
        corner = {16, 20, 24},
        border = {2, 3},
        elevation = {4, 6, 8},
        margin = {12, 16, 20},
        alpha = {0.90, 0.95, 1.0}
    },
    compact = {
        padding = {12, 14, 16},
        textTitle = {16, 18, 20},
        textNormal = {12, 13, 14},
        textSmall = {9, 10, 11},
        corner = {8, 10, 12},
        border = {1, 1.5},
        elevation = {1, 2, 3},
        margin = {6, 8, 10},
        alpha = {0.80, 0.85, 0.90}
    },
    elegant = {
        padding = {24, 28, 32},
        textTitle = {22, 24, 26},
        textNormal = {15, 16, 17},
        textSmall = {12, 13, 14},
        corner = {20, 24, 28},
        border = {2, 3, 4},
        elevation = {6, 8, 10},
        margin = {16, 20, 24},
        alpha = {0.95, 1.0}
        },
        

    minimal = {
        padding = {16, 20, 24},
        textTitle = {18, 20, 22},
        textNormal = {13, 14, 15},
        textSmall = {10, 11, 12},
        corner = {12, 16, 20},
        border = {1, 2},
        elevation = {2, 4, 6},
        margin = {8, 12, 16},
        alpha = {0.85, 0.90, 0.95}
    },

    modern = {
        padding = {20, 24, 28},
        textTitle = {20, 22, 24},
        textNormal = {14, 15, 16},
        textSmall = {11, 12, 13},
        corner = {16, 20, 24},
        border = {2, 3},
        elevation = {4, 6, 8},
        margin = {12, 16, 20},
        alpha = {0.90, 0.95, 1.00}
    },

    compact = {
        padding = {12, 14, 16},
        textTitle = {16, 18, 20},
        textNormal = {12, 13, 14},
        textSmall = {9, 10, 11},
        corner = {8, 10, 12},
        border = {1, 1.5},
        elevation = {1, 2, 3},
        margin = {6, 8, 10},
        alpha = {0.80, 0.85, 0.90}
    },

    elegant = {
        padding = {24, 28, 32},
        textTitle = {22, 24, 26},
        textNormal = {15, 16, 17},
        textSmall = {12, 13, 14},
        corner = {20, 24, 28},
        border = {2, 3, 4},
        elevation = {6, 8, 10},
        margin = {16, 20, 24},
        alpha = {0.95, 0.98, 1.00}
    },

    glass = {
        padding = {18, 22, 26},
        textTitle = {19, 21, 23},
        textNormal = {13, 14, 15},
        textSmall = {10, 11, 12},
        corner = {24, 28, 32},
        border = {1, 2, 3},
        elevation = {8, 10, 12},
        margin = {10, 14, 18},
        alpha = {0.65, 0.75, 0.85}
    },

    neon = {
        padding = {16, 20, 24},
        textTitle = {21, 23, 25},
        textNormal = {14, 15, 16},
        textSmall = {11, 12, 13},
        corner = {10, 14, 18},
        border = {2, 3, 4},
        elevation = {8, 12, 16},
        margin = {10, 14, 18},
        alpha = {0.90, 0.95, 1.00}
    },

    luxury = {
        padding = {28, 32, 36},
        textTitle = {24, 26, 28},
        textNormal = {16, 17, 18},
        textSmall = {13, 14, 15},
        corner = {18, 22, 26},
        border = {3, 4, 5},
        elevation = {8, 12, 16},
        margin = {18, 22, 26},
        alpha = {0.95, 0.98, 1.00}
    },

    card = {
        padding = {14, 18, 22},
        textTitle = {18, 20, 22},
        textNormal = {13, 14, 15},
        textSmall = {10, 11, 12},
        corner = {14, 18, 22},
        border = {1, 2, 3},
        elevation = {4, 6, 8},
        margin = {8, 12, 16},
        alpha = {0.88, 0.93, 0.98}
    },

    rounded = {
        padding = {18, 22, 26},
        textTitle = {19, 21, 23},
        textNormal = {13, 14, 15},
        textSmall = {10, 11, 12},
        corner = {28, 36, 44},
        border = {1, 2},
        elevation = {3, 5, 7},
        margin = {10, 14, 18},
        alpha = {0.90, 0.95, 1.00}
    },

    ultraCompact = {
        padding = {8, 10, 12},
        textTitle = {14, 16, 18},
        textNormal = {10, 11, 12},
        textSmall = {8, 9, 10},
        corner = {4, 6, 8},
        border = {1, 1},
        elevation = {0, 1, 2},
        margin = {4, 6, 8},
        alpha = {0.75, 0.80, 0.85}
    },

    soft = {
        padding = {20, 24, 28},
        textTitle = {20, 22, 24},
        textNormal = {14, 15, 16},
        textSmall = {11, 12, 13},
        corner = {22, 26, 30},
        border = {1, 2, 2},
        elevation = {2, 3, 4},
        margin = {12, 16, 20},
        alpha = {0.92, 0.96, 1.00}
    },

    material = {
        padding = {16, 20, 24},
        textTitle = {20, 22, 24},
        textNormal = {14, 15, 16},
        textSmall = {11, 12, 13},
        corner = {12, 16, 20},
        border = {1, 2},
        elevation = {2, 6, 12},
        margin = {8, 12, 16},
        alpha = {0.90, 0.95, 1.00}
    

     
        
          
    }
}

local themeNames = {"minimal", "modern", "compact", "elegant"}
local chosenTheme = themes[themeNames[math.random(1, #themeNames)]]

function pickFromTheme(category)
    local values = chosenTheme[category]
    return values[math.random(1, #values)]
end

function generateHarmonicColors()
    local baseColor = randomColors()
    local r = tonumber(baseColor:sub(2,3), 16) or 100
    local g = tonumber(baseColor:sub(4,5), 16) or 100
    local b = tonumber(baseColor:sub(6,7), 16) or 100
    
    local function adjustColor(color, factor)
        return math.max(0, math.min(255, math.floor(color * factor)))
    end
    
    local colors = {
        bg = string.format("#%02X%02X%02X", adjustColor(r, 0.3), adjustColor(g, 0.3), adjustColor(b, 0.3)),
        card = string.format("#%02X%02X%02X", adjustColor(r, 0.5), adjustColor(g, 0.5), adjustColor(b, 0.5)),
        accent = string.format("#%02X%02X%02X", adjustColor(r, 0.7), adjustColor(g, 0.7), adjustColor(b, 0.7)),
        text = "#FFFFFF",
        subtext = string.format("#%02X%02X%02X", adjustColor(r, 0.8), adjustColor(g, 0.8), adjustColor(b, 0.8)),
        switch_on = string.format("#%02X%02X%02X", adjustColor(r, 0.9), adjustColor(g, 0.9), adjustColor(b, 0.9)),
        switch_off = string.format("#%02X%02X%02X", adjustColor(r, 0.2), adjustColor(g, 0.2), adjustColor(b, 0.2)),
        button = string.format("#%02X%02X%02X", adjustColor(r, 0.6), adjustColor(g, 0.6), adjustColor(b, 0.6))
    }
    
    return colors
end

local themeColors = generateHarmonicColors()
local BG_COLOR = Color.parseColor(themeColors.bg)
local CARD_COLOR = Color.parseColor(themeColors.card)
local ACCENT_COLOR = Color.parseColor(themeColors.accent)
local WHITE_COLOR = Color.parseColor(themeColors.text)
local GRAY_COLOR = Color.parseColor(themeColors.subtext)
local SWITCH_ON_COLOR = Color.parseColor(themeColors.switch_on)
local SWITCH_OFF_COLOR = Color.parseColor(themeColors.switch_off)
local BUTTON_COLOR = Color.parseColor(themeColors.button)

local PADDING = pickFromTheme("padding")
local TEXT_TITLE = pickFromTheme("textTitle")
local TEXT_NORMAL = pickFromTheme("textNormal")
local TEXT_SMALL = pickFromTheme("textSmall")
local CORNER = pickFromTheme("corner")
local BORDER = pickFromTheme("border")
local ELEVATION = pickFromTheme("elevation")
local MARGIN = pickFromTheme("margin")
local ALPHA = pickFromTheme("alpha")

function god_mode_on()
    gg.setRanges(gg.REGION_CODE_APP)
    gg.searchNumber("-0.50344371796;9.99999997e-7;-0.50291442871::9", gg.TYPE_FLOAT)
    gg.refineNumber("9.99999997e-7", gg.TYPE_FLOAT)
    gg.getResults(100)
    gg.editAll("-1", gg.TYPE_FLOAT)
    gg.clearResults()
    gg.toast("✅ God Mode ATIVADO")
end

function god_mode_off()
    gg.setRanges(gg.REGION_CODE_APP)
    gg.searchNumber("-0.50344371796;9.99999997e-7;-0.50291442871::9", gg.TYPE_FLOAT)
    gg.refineNumber("9.99999997e-7", gg.TYPE_FLOAT)
    gg.getResults(100)
    gg.editAll("-1", gg.TYPE_FLOAT)
    gg.clearResults()
    gg.toast("❌ God Mode DESATIVADO")
end

function Infinite_Ammo_on()
    gg.setRanges(gg.REGION_CODE_APP)
    gg.searchNumber("-0.50344371796;9.99999997e-7;-0.50291442871::9", gg.TYPE_FLOAT)
    gg.refineNumber("9.99999997e-7", gg.TYPE_FLOAT)
    gg.getResults(100)
    gg.editAll("-1", gg.TYPE_FLOAT)
    gg.clearResults()
    gg.toast("✅ Munição Infinita ATIVADA")
end

function Infinite_Ammo_off()
    gg.setRanges(gg.REGION_CODE_APP)
    gg.searchNumber("-0.50344371796;9.99999997e-7;-0.50291442871::9", gg.TYPE_FLOAT)
    gg.refineNumber("9.99999997e-7", gg.TYPE_FLOAT)
    gg.getResults(100)
    gg.editAll("-1", gg.TYPE_FLOAT)
    gg.clearResults()
    gg.toast("❌ Munição Infinita DESATIVADA")
end

function Speed_Hack_on()
    gg.setRanges(gg.REGION_CODE_APP)
    gg.searchNumber("-0.50344371796;9.99999997e-7;-0.50291442871::9", gg.TYPE_FLOAT)
    gg.refineNumber("9.99999997e-7", gg.TYPE_FLOAT)
    gg.getResults(100)
    gg.editAll("-1", gg.TYPE_FLOAT)
    gg.clearResults()
    gg.toast("✅ Speed Hack ATIVADO")
end

function Speed_Hack_off()
    gg.setRanges(gg.REGION_CODE_APP)
    gg.searchNumber("-0.50344371796;9.99999997e-7;-0.50291442871::9", gg.TYPE_FLOAT)
    gg.refineNumber("9.99999997e-7", gg.TYPE_FLOAT)
    gg.getResults(100)
    gg.editAll("-1", gg.TYPE_FLOAT)
    gg.clearResults()
    gg.toast("❌ Speed Hack DESATIVADO")
end

function Wall_Hack_on()
    gg.setRanges(gg.REGION_CODE_APP)
    gg.searchNumber("-0.50344371796;9.99999997e-7;-0.50291442871::9", gg.TYPE_FLOAT)
    gg.refineNumber("9.99999997e-7", gg.TYPE_FLOAT)
    gg.getResults(100)
    gg.editAll("-1", gg.TYPE_FLOAT)
    gg.clearResults()
    gg.toast("✅ Wall Hack ATIVADO")
end

function Wall_Hack_off()
    gg.setRanges(gg.REGION_CODE_APP)
    gg.searchNumber("-0.50344371796;9.99999997e-7;-0.50291442871::9", gg.TYPE_FLOAT)
    gg.refineNumber("9.99999997e-7", gg.TYPE_FLOAT)
    gg.getResults(100)
    gg.editAll("-1", gg.TYPE_FLOAT)
    gg.clearResults()
    gg.toast("❌ Wall Hack DESATIVADO")
end

function ESP_Radar_on()
    gg.setRanges(gg.REGION_CODE_APP)
    gg.searchNumber("-0.50344371796;9.99999997e-7;-0.50291442871::9", gg.TYPE_FLOAT)
    gg.refineNumber("9.99999997e-7", gg.TYPE_FLOAT)
    gg.getResults(100)
    gg.editAll("-1", gg.TYPE_FLOAT)
    gg.clearResults()
    gg.toast("✅ ESP/Radar ATIVADO")
end

function ESP_Radar_off()
    gg.setRanges(gg.REGION_CODE_APP)
    gg.searchNumber("-0.50344371796;9.99999997e-7;-0.50291442871::9", gg.TYPE_FLOAT)
    gg.refineNumber("9.99999997e-7", gg.TYPE_FLOAT)
    gg.getResults(100)
    gg.editAll("-1", gg.TYPE_FLOAT)
    gg.clearResults()
    gg.toast("❌ ESP/Radar DESATIVADO")
end

local function dp(v)
    return math.floor(
        TypedValue.applyDimension(
            TypedValue.COMPLEX_UNIT_DIP,
            v,
            activity.getResources().getDisplayMetrics()
        )
    )
end

local function getFbl()
    local wm = activity.getSystemService(Context.WINDOW_SERVICE)
    local point = Point()
    wm.getDefaultDisplay().getRealSize(point)
    return { width = point.x, height = point.y }
end

local function createSwitch(parent, label, onEnable, onDisable)
    local container = LinearLayout(activity)
    container.setOrientation(LinearLayout.HORIZONTAL)
    container.setGravity(Gravity.CENTER_VERTICAL)
    container.setPadding(dp(PADDING/2), dp(MARGIN/2), dp(PADDING/2), dp(MARGIN/2))

    local text = TextView(activity)
    text.setText(label)
    text.setTextColor(WHITE_COLOR)
    text.setTextSize(1, TEXT_NORMAL)
    text.setTypeface(Typeface.DEFAULT)
    text.setLayoutParams(
        LinLayoutParams(0, ViewGroup.LayoutParams.WRAP_CONTENT, 1.0)
    )

    local switchBtn = Switch(activity)
    switchBtn.setChecked(false)
    switchBtn.setText("")
    switchBtn.setTextOn("")
    switchBtn.setTextOff("")
    switchBtn.setSwitchMinWidth(dp(45))
    switchBtn.setSwitchPadding(dp(3))

    local thumbDrawable = GradientDrawable()
    thumbDrawable.setShape(GradientDrawable.OVAL)
    thumbDrawable.setColor(Color.WHITE)
    thumbDrawable.setSize(dp(22), dp(22))
    switchBtn.setThumbDrawable(thumbDrawable)

    local trackDrawable = GradientDrawable()
    trackDrawable.setShape(GradientDrawable.RECTANGLE)
    trackDrawable.setCornerRadius(dp(CORNER/2))
    trackDrawable.setColor(SWITCH_OFF_COLOR)
    switchBtn.setTrackDrawable(trackDrawable)

    switchBtn.setOnCheckedChangeListener(
        luajava.createProxy(
            "android.widget.CompoundButton$OnCheckedChangeListener",
            {
                onCheckedChanged = function(buttonView, isChecked)
                    local thumb = GradientDrawable()
                    thumb.setShape(GradientDrawable.OVAL)
                    thumb.setColor(Color.WHITE)
                    thumb.setSize(dp(22), dp(22))
                    buttonView.setThumbDrawable(thumb)

                    local track = GradientDrawable()
                    track.setShape(GradientDrawable.RECTANGLE)
                    track.setCornerRadius(dp(CORNER/2))

                    if isChecked then
                        track.setColor(SWITCH_ON_COLOR)
                        buttonView.setTrackDrawable(track)
                        if onEnable then
                                  thread(onEnable)
                        end
                    else
                        track.setColor(SWITCH_OFF_COLOR)
                        buttonView.setTrackDrawable(track)
                        if onDisable then
                                    thread(onDisable)
                        end
                    end
                end
            }
        )
    )

    container.addView(text)
    container.addView(switchBtn)
    parent.addView(container)
    return switchBtn
end

local function createLayout(layoutWidth, layoutHeight)
    local root = FrameLayout(activity)
    root.setLayoutParams(FrameLayoutParams(layoutWidth, layoutHeight))

    local main = LinearLayout(activity)
    main.setOrientation(LinearLayout.VERTICAL)
    main.setPadding(dp(PADDING), dp(PADDING), dp(PADDING), dp(PADDING))
    main.setGravity(Gravity.CENTER_HORIZONTAL)

    local bgDrawable = GradientDrawable()
    bgDrawable.setColor(BG_COLOR)
    bgDrawable.setCornerRadius(dp(CORNER))
    bgDrawable.setStroke(dp(BORDER), ACCENT_COLOR)
    main.setBackground(bgDrawable)

    main.setLayoutParams(
        FrameLayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT)
    )

    local title = TextView(activity)
    title.setText("⚡ Script Menu ⚡")
    title.setTextColor(WHITE_COLOR)
    title.setTextSize(1, TEXT_TITLE)
    title.setTypeface(Typeface.DEFAULT_BOLD)
    title.setGravity(Gravity.CENTER)
    title.setPadding(0, 0, 0, dp(MARGIN/2))
    title.setLayoutParams(
        LinLayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT)
    )
    main.addView(title)

    
    local subtitle = TextView(activity)
    subtitle.setText("by @batmangamesS")
    subtitle.setTextColor(GRAY_COLOR)
    subtitle.setTextSize(1, TEXT_SMALL)
    subtitle.setGravity(Gravity.CENTER)
    subtitle.setPadding(0, 0, 0, dp(MARGIN))
    main.addView(subtitle)

    
    local card = LinearLayout(activity)
    card.setOrientation(LinearLayout.VERTICAL)
    card.setPadding(dp(PADDING), dp(PADDING), dp(PADDING), dp(PADDING))
    card.setElevation(dp(ELEVATION))

    local cardDrawable = GradientDrawable()
    cardDrawable.setColor(CARD_COLOR)
    cardDrawable.setCornerRadius(dp(CORNER))
    cardDrawable.setAlpha(math.floor(255 * ALPHA))
    card.setBackground(cardDrawable)

    card.setLayoutParams(
        LinLayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, 0, 1.0)
    )

        createSwitch(card, "🎮 God Mode", god_mode_on, god_mode_off)
    createSwitch(card, "🔫 Infinite Ammo", Infinite_Ammo_on, Infinite_Ammo_off)
    createSwitch(card, "⚡ Speed Hack", Speed_Hack_on, Speed_Hack_off)
    createSwitch(card, "🧱 Wall Hack", Wall_Hack_on, Wall_Hack_off)
    createSwitch(card, "📍 ESP / Radar", ESP_Radar_on, ESP_Radar_off)
    
    main.addView(card)


    local closeBtn = Button(activity)
    closeBtn.setText("✖ Sair")
    closeBtn.setAllCaps(false)
    closeBtn.setTextColor(WHITE_COLOR)
    closeBtn.setTextSize(1, TEXT_NORMAL)
    closeBtn.setTypeface(Typeface.DEFAULT_BOLD)
    closeBtn.setPadding(dp(PADDING * 2), dp(MARGIN), dp(PADDING * 2), dp(MARGIN))
    closeBtn.setElevation(dp(ELEVATION))

    local btnDrawable = GradientDrawable()
    btnDrawable.setColor(BUTTON_COLOR)
    btnDrawable.setCornerRadius(dp(CORNER * 2))
    btnDrawable.setStroke(dp(BORDER), WHITE_COLOR)
    closeBtn.setBackground(btnDrawable)

    local btnParams = LinLayoutParams(
        ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT
    )
    btnParams.topMargin = dp(MARGIN)
    closeBtn.setLayoutParams(btnParams)

    main.addView(closeBtn)
    root.addView(main)

    return root, closeBtn
end

local wm = activity.getSystemService(Context.WINDOW_SERVICE)
local screen = getFbl()
local screenWidth = screen.width
local screenHeight = screen.height

local layoutWidth = math.floor(screenWidth * 0.85)
local layoutHeight = math.floor(screenHeight * 0.55)

local layoutType
if Build.VERSION.SDK_INT >= 26 then
    layoutType = LayoutParams.TYPE_APPLICATION_OVERLAY
else
    layoutType = LayoutParams.TYPE_PHONE
end

local params = LayoutParams(
    layoutWidth, layoutHeight, layoutType,
    LayoutParams.FLAG_NOT_FOCUSABLE,
    -3
)
params.gravity = Gravity.CENTER

local layout, closeBtn = createLayout(layoutWidth, layoutHeight)

local initialX = 0
local initialY = 0
local initialTouchX = 0
local initialTouchY = 0
local isMoving = false

local function onTouch(v, event)
    local action = event.getAction()
    
    if action == MotionEvent.ACTION_DOWN then
        initialX = params.x
        initialY = params.y
        initialTouchX = event.getRawX()
        initialTouchY = event.getRawY()
        isMoving = false
        return true
    elseif action == MotionEvent.ACTION_MOVE then
        local deltaX = event.getRawX() - initialTouchX
        local deltaY = event.getRawY() - initialTouchY
        
        if math.abs(deltaX) > 10 or math.abs(deltaY) > 10 then
            isMoving = true
        end
        
        if isMoving then
            params.x = initialX + deltaX
            params.y = initialY + deltaY
            pcall(function()
                wm.updateViewLayout(layout, params)
            end)
        end
        
        return true
    elseif action == MotionEvent.ACTION_UP then
        return isMoving
    end
    
    return false
end

activity.runOnUiThread(
    luajava.createProxy(
        "java.lang.Runnable",
        {
            run = function()
                layout.setOnTouchListener(
                    luajava.createProxy(
                        "android.view.View$OnTouchListener",
                        {
                            onTouch = onTouch
                        }
                    )
                )
        
                closeBtn.setOnClickListener(
                    luajava.createProxy(
                        "android.view.View$OnClickListener",
                        {
                            onClick = function()
                                pcall(function()
                                    wm.removeView(layout)
                                end)
                            end
                        }
                    )
                )

                pcall(function()
                    wm.addView(layout, params)
                end)
            end
        }
    )
)