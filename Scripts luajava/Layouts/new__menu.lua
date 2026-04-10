gg.setVisible(true)

import "android.app.*"
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

local PRIMARY_COLOR = Color.parseColor("#6200EE")
local ACCENT_COLOR = Color.parseColor("#03DAC5")
local BG_COLOR = Color.parseColor("#121212")
local CARD_COLOR = Color.parseColor("#1E1E1E")
local TEXT_COLOR = Color.parseColor("#FFFFFF")
local TEXT_SECONDARY = Color.parseColor("#B0B0B0")
local RED = Color.parseColor("#CF6679")
local ORANGE = Color.parseColor("#FF8A65")
local GREEN = Color.parseColor("#4CAF50")
local BLUE = Color.parseColor("#2196F3")
local RIPPLE_COLOR = Color.parseColor("#3700B3")

local listplayer_open = false
local isMenuVisible = false
local floatingMenuView = nil
local floatingListView = nil
local box_functions = nil
local box_list_player_functions = nil
local windowManager = nil
local menuParams = nil
local listParams = nil
local handler = Handler(Looper.getMainLooper())
local initialX, initialY = 0, 0
local initialTouchX, initialTouchY = 0.0, 0.0
local shouldExit = false
local menuInitialized = false

local function dp(value)
    return TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, value, activity.getResources().getDisplayMetrics())
end

local function getWindowType()
    if Build.VERSION.SDK_INT >= 26 then
        return WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
    else
        return WindowManager.LayoutParams.TYPE_PHONE
    end
end

local function getShapeBackground(color, radius)
    local drawable = GradientDrawable()
    drawable.setShape(GradientDrawable.RECTANGLE)
    drawable.setColor(color)
    drawable.setCornerRadius(radius)
    return drawable
end

local function getBorderBackground(bgColor, borderColor, borderWidth, radius)
    local drawable = GradientDrawable()
    drawable.setShape(GradientDrawable.RECTANGLE)
    drawable.setColor(bgColor)
    drawable.setStroke(borderWidth, borderColor)
    drawable.setCornerRadius(radius)
    return drawable
end

local function getRippleDrawable(color, radius)
    if Build.VERSION.SDK_INT >= 21 then
        local content = getShapeBackground(color, radius)
        local mask = getShapeBackground(Color.WHITE, radius)
        local ripple = RippleDrawable(ColorStateList.valueOf(RIPPLE_COLOR), content, mask)
        return ripple
    else
        return getShapeBackground(color, radius)
    end
end

local function initializeSystemWindows()
    if menuInitialized then return end
    
    windowManager = activity.getSystemService(Context.WINDOW_SERVICE)
    menuParams = WindowManager.LayoutParams(
        dp(200),
        WindowManager.LayoutParams.WRAP_CONTENT,
        getWindowType(),
        WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE,
        PixelFormat.TRANSLUCENT
    )
    menuParams.gravity = Gravity.TOP | Gravity.START
    menuParams.x = 50
    menuParams.y = 50
    listParams = WindowManager.LayoutParams(
        dp(280),
        dp(400),
        getWindowType(),
        WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE,
        PixelFormat.TRANSLUCENT
    )
    listParams.gravity = Gravity.TOP | Gravity.START
    listParams.x = 350
    listParams.y = 50
    
    menuInitialized = true
end

local function createFloatingIcon()
    local iconLayout = LinearLayout(activity)
    iconLayout.setLayoutParams(LinearLayout.LayoutParams(dp(40), dp(40)))
    iconLayout.setOrientation(LinearLayout.VERTICAL)
    iconLayout.setGravity(Gravity.CENTER)
    iconLayout.setBackground(getShapeBackground(PRIMARY_COLOR, dp(30)))
    
    local iconText = TextView(activity)
    iconText.setLayoutParams(LinearLayout.LayoutParams(
        LinearLayout.LayoutParams.WRAP_CONTENT,
        LinearLayout.LayoutParams.WRAP_CONTENT
    ))
    iconText.setText("M")
    iconText.setTextColor(TEXT_COLOR)
    iconText.setTextSize(TypedValue.COMPLEX_UNIT_SP, 20)
    iconText.setTypeface(Typeface.DEFAULT_BOLD)
    
    iconLayout.addView(iconText)
    
    iconLayout.setOnTouchListener(View.OnTouchListener{
        onTouch = function(v, event)
            local action = event.getAction()
            
            if action == MotionEvent.ACTION_DOWN then
                initialX = menuParams.x
                initialY = menuParams.y
                initialTouchX = event.getRawX()
                initialTouchY = event.getRawY()
                v.setBackground(getShapeBackground(ACCENT_COLOR, dp(30)))
                return true
                
            elseif action == MotionEvent.ACTION_MOVE then
                local newX = initialX + (event.getRawX() - initialTouchX)
                local newY = initialY + (event.getRawY() - initialTouchY)
                
                menuParams.x = newX
                menuParams.y = newY
                windowManager.updateViewLayout(floatingMenuView, menuParams)
                return true
                
            elseif action == MotionEvent.ACTION_UP then
                v.setBackground(getShapeBackground(PRIMARY_COLOR, dp(30)))
                hideMenu()
                gg.sleep(50)
                showFullMenu()
                return true
            end
            
            return false
        end
    })
    
    return iconLayout
end

local function createFullMenu()
    local mainLayout = LinearLayout(activity)
    mainLayout.setLayoutParams(LinearLayout.LayoutParams(
        dp(300),
        WindowManager.LayoutParams.WRAP_CONTENT
    ))
    mainLayout.setOrientation(LinearLayout.VERTICAL)
    mainLayout.setBackground(getBorderBackground(BG_COLOR, PRIMARY_COLOR, dp(2), dp(8)))
    mainLayout.setPadding(0, 0, 0, 0)
    
    local header = LinearLayout(activity)
    header.setLayoutParams(LinearLayout.LayoutParams(
        LinearLayout.LayoutParams.MATCH_PARENT,
        dp(40)
    ))
    header.setBackgroundColor(PRIMARY_COLOR)
    header.setGravity(Gravity.CENTER)
    
    local titleText = TextView(activity)
    titleText.setLayoutParams(LinearLayout.LayoutParams(
        LinearLayout.LayoutParams.WRAP_CONTENT,
        LinearLayout.LayoutParams.WRAP_CONTENT
    ))
    titleText.setText("GAME HACK")
    titleText.setTextColor(TEXT_COLOR)
    titleText.setTextSize(TypedValue.COMPLEX_UNIT_SP, 16)
    titleText.setTypeface(Typeface.DEFAULT_BOLD)
    
    header.setOnTouchListener(View.OnTouchListener{
        onTouch = function(v, event)
            local action = event.getAction()
            
            if action == MotionEvent.ACTION_DOWN then
                initialX = menuParams.x
                initialY = menuParams.y
                initialTouchX = event.getRawX()
                initialTouchY = event.getRawY()
                return true
                
            elseif action == MotionEvent.ACTION_MOVE then
                local newX = initialX + (event.getRawX() - initialTouchX)
                local newY = initialY + (event.getRawY() - initialTouchY)
                
                menuParams.x = newX
                menuParams.y = newY
                windowManager.updateViewLayout(floatingMenuView, menuParams)
                return true
            end
            
            return true
        end
    })
    
    header.addView(titleText)
    mainLayout.addView(header)
    
    local scrollView = ScrollView(activity)
    scrollView.setLayoutParams(LinearLayout.LayoutParams(
        LinearLayout.LayoutParams.MATCH_PARENT,
        dp(400)
    ))
    scrollView.setBackgroundColor(Color.TRANSPARENT)
    
    local contentLayout = LinearLayout(activity)
    contentLayout.setLayoutParams(LinearLayout.LayoutParams(
        LinearLayout.LayoutParams.MATCH_PARENT,
        LinearLayout.LayoutParams.WRAP_CONTENT
    ))
    contentLayout.setOrientation(LinearLayout.VERTICAL)
    contentLayout.setPadding(dp(8), dp(8), dp(8), dp(8))
    
    local cat1 = TextView(activity)
    cat1.setLayoutParams(LinearLayout.LayoutParams(
        LinearLayout.LayoutParams.MATCH_PARENT,
        LinearLayout.LayoutParams.WRAP_CONTENT
    ))
    cat1.setPadding(dp(12), dp(6), dp(12), dp(6))
    cat1.setText("GENERAL HACKS")
    cat1.setTextColor(ACCENT_COLOR)
    cat1.setGravity(Gravity.CENTER)
    cat1.setBackground(getBorderBackground(CARD_COLOR, ACCENT_COLOR, dp(1), dp(6)))
    cat1.setTextSize(TypedValue.COMPLEX_UNIT_SP, 14)
    cat1.setTypeface(Typeface.DEFAULT_BOLD)
    contentLayout.addView(cat1)
    
    local switch1Container = LinearLayout(activity)
    switch1Container.setLayoutParams(LinearLayout.LayoutParams(
        LinearLayout.LayoutParams.MATCH_PARENT,
        dp(45)
    ))
    switch1Container.setOrientation(LinearLayout.HORIZONTAL)
    switch1Container.setGravity(Gravity.CENTER_VERTICAL)
    switch1Container.setBackground(getShapeBackground(CARD_COLOR, dp(6)))
    switch1Container.setPadding(dp(10), 0, dp(10), 0)
    
    local switch1Text = TextView(activity)
    switch1Text.setLayoutParams(LinearLayout.LayoutParams(
        LinearLayout.LayoutParams.WRAP_CONTENT,
        LinearLayout.LayoutParams.WRAP_CONTENT
    ))
    switch1Text.setText("GOD MODE")
    switch1Text.setTextSize(TypedValue.COMPLEX_UNIT_SP, 13)
    switch1Text.setTextColor(TEXT_COLOR)
    switch1Text.setTypeface(nil, Typeface.BOLD)
    
    local switch1View = Switch(activity)
    if Build.VERSION.SDK_INT >= 21 then
        switch1View.setTrackTintList(ColorStateList.valueOf(Color.parseColor("#555555")))
        switch1View.setThumbTintList(ColorStateList.valueOf(PRIMARY_COLOR))
    end
    
    switch1View.setOnCheckedChangeListener(CompoundButton.OnCheckedChangeListener{
        onCheckedChanged = function(buttonView, isChecked)
            if isChecked then
                if Build.VERSION.SDK_INT >= 21 then
                    switch1View.setTrackTintList(ColorStateList.valueOf(Color.parseColor("#BB86FC")))
                    switch1View.setThumbTintList(ColorStateList.valueOf(PRIMARY_COLOR))
                end
_speedHackPending = true
                gg.toast("GOD MODE ACTIVATED")
            else
                if Build.VERSION.SDK_INT >= 21 then
                    switch1View.setTrackTintList(ColorStateList.valueOf(Color.parseColor("#555555")))
                    switch1View.setThumbTintList(ColorStateList.valueOf(PRIMARY_COLOR))
                end
                gg.toast("GOD MODE DEACTIVATED")
            end
        end
    })
    
    switch1Container.addView(switch1Text)
    switch1Container.addView(switch1View)
    contentLayout.addView(switch1Container)
    
    local switch2Container = LinearLayout(activity)
    switch2Container.setLayoutParams(LinearLayout.LayoutParams(
        LinearLayout.LayoutParams.MATCH_PARENT,
        dp(45)
    ))
    switch2Container.setOrientation(LinearLayout.HORIZONTAL)
    switch2Container.setGravity(Gravity.CENTER_VERTICAL)
    switch2Container.setBackground(getShapeBackground(CARD_COLOR, dp(6)))
    switch2Container.setPadding(dp(10), 0, dp(10), 0)
    
    local switch2Text = TextView(activity)
    switch2Text.setLayoutParams(LinearLayout.LayoutParams(
        LinearLayout.LayoutParams.WRAP_CONTENT,
        LinearLayout.LayoutParams.WRAP_CONTENT
    ))
    switch2Text.setText("AIMBOT")
    switch2Text.setTextSize(TypedValue.COMPLEX_UNIT_SP, 13)
    switch2Text.setTextColor(TEXT_COLOR)
    switch2Text.setTypeface(nil, Typeface.BOLD)
    
    local switch2View = Switch(activity)
    if Build.VERSION.SDK_INT >= 21 then
        switch2View.setTrackTintList(ColorStateList.valueOf(Color.parseColor("#555555")))
        switch2View.setThumbTintList(ColorStateList.valueOf(PRIMARY_COLOR))
    end
    
    switch2View.setOnCheckedChangeListener(CompoundButton.OnCheckedChangeListener{
        onCheckedChanged = function(buttonView, isChecked)
            if isChecked then
                if Build.VERSION.SDK_INT >= 21 then
                    switch2View.setTrackTintList(ColorStateList.valueOf(Color.parseColor("#BB86FC")))
                    switch2View.setThumbTintList(ColorStateList.valueOf(PRIMARY_COLOR))
                end
                gg.toast("AIMBOT ACTIVATED")
            else
                gg.toast("AIMBOT DEACTIVATED")
            end
        end
    })
    
    switch2Container.addView(switch2Text)
    switch2Container.addView(switch2View)
    contentLayout.addView(switch2Container)
    
    local switch3Container = LinearLayout(activity)
    switch3Container.setLayoutParams(LinearLayout.LayoutParams(
        LinearLayout.LayoutParams.MATCH_PARENT,
        dp(45)
    ))
    switch3Container.setOrientation(LinearLayout.HORIZONTAL)
    switch3Container.setGravity(Gravity.CENTER_VERTICAL)
    switch3Container.setBackground(getShapeBackground(CARD_COLOR, dp(6)))
    switch3Container.setPadding(dp(10), 0, dp(10), 0)
    
    local switch3Text = TextView(activity)
    switch3Text.setLayoutParams(LinearLayout.LayoutParams(
        LinearLayout.LayoutParams.WRAP_CONTENT,
        LinearLayout.LayoutParams.WRAP_CONTENT
    ))
    switch3Text.setText("WALLHACK")
    switch3Text.setTextSize(TypedValue.COMPLEX_UNIT_SP, 13)
    switch3Text.setTextColor(TEXT_COLOR)
    switch3Text.setTypeface(nil, Typeface.BOLD)
    
    local switch3View = Switch(activity)
    if Build.VERSION.SDK_INT >= 21 then
        switch3View.setTrackTintList(ColorStateList.valueOf(Color.parseColor("#555555")))
        switch3View.setThumbTintList(ColorStateList.valueOf(PRIMARY_COLOR))
    end
    
    switch3View.setOnCheckedChangeListener(CompoundButton.OnCheckedChangeListener{
        onCheckedChanged = function(buttonView, isChecked)
            if isChecked then
                if Build.VERSION.SDK_INT >= 21 then
                    switch3View.setTrackTintList(ColorStateList.valueOf(Color.parseColor("#BB86FC")))
                    switch3View.setThumbTintList(ColorStateList.valueOf(PRIMARY_COLOR))
                end
                gg.toast("WALLHACK ACTIVATED")
            else
                gg.toast("WALLHACK DEACTIVATED")
            end
        end
    })
    
    switch3Container.addView(switch3Text)
    switch3Container.addView(switch3View)
    contentLayout.addView(switch3Container)
    
    local seekContainer1 = LinearLayout(activity)
    seekContainer1.setLayoutParams(LinearLayout.LayoutParams(
        LinearLayout.LayoutParams.MATCH_PARENT,
        LinearLayout.LayoutParams.WRAP_CONTENT
    ))
    seekContainer1.setPadding(dp(10), dp(8), dp(10), dp(8))
    seekContainer1.setOrientation(LinearLayout.VERTICAL)
    seekContainer1.setBackground(getShapeBackground(CARD_COLOR, dp(6)))
    
    local seekText1 = TextView(activity)
    seekText1.setLayoutParams(LinearLayout.LayoutParams(
        LinearLayout.LayoutParams.MATCH_PARENT,
        LinearLayout.LayoutParams.WRAP_CONTENT
    ))
    seekText1.setText("SPEED: 50")
    seekText1.setTextSize(TypedValue.COMPLEX_UNIT_SP, 13)
    seekText1.setTextColor(TEXT_COLOR)
    seekText1.setPadding(0, 0, 0, dp(6))
    
    local seekBar1 = SeekBar(activity)
    seekBar1.setLayoutParams(LinearLayout.LayoutParams(
        LinearLayout.LayoutParams.MATCH_PARENT,
        LinearLayout.LayoutParams.WRAP_CONTENT
    ))
    
    if Build.VERSION.SDK_INT >= 21 then
        seekBar1.setThumbTintList(ColorStateList.valueOf(PRIMARY_COLOR))
        seekBar1.setProgressTintList(ColorStateList.valueOf(ACCENT_COLOR))
    end
    
    seekBar1.setProgress(50)
    seekBar1.setMax(100)
    
    seekBar1.setOnSeekBarChangeListener(SeekBar.OnSeekBarChangeListener{
        onProgressChanged = function(seekBar, progress, fromUser)
            seekText1.setText("SPEED: " .. progress)
            gg.toast("SPEED: " .. progress)
        end,
        onStartTrackingTouch = function(seekBar) end,
        onStopTrackingTouch = function(seekBar) end
    })
    
    seekContainer1.addView(seekText1)
    seekContainer1.addView(seekBar1)
    contentLayout.addView(seekContainer1)
    
    local cat2 = TextView(activity)
    cat2.setLayoutParams(LinearLayout.LayoutParams(
        LinearLayout.LayoutParams.MATCH_PARENT,
        LinearLayout.LayoutParams.WRAP_CONTENT
    ))
    cat2.setPadding(dp(12), dp(6), dp(12), dp(6))
    cat2.setText("AMMUNITION")
    cat2.setTextColor(GREEN)
    cat2.setGravity(Gravity.CENTER)
    cat2.setBackground(getBorderBackground(CARD_COLOR, GREEN, dp(1), dp(6)))
    cat2.setTextSize(TypedValue.COMPLEX_UNIT_SP, 14)
    cat2.setTypeface(Typeface.DEFAULT_BOLD)
    contentLayout.addView(cat2)
    
    local btn1 = Button(activity)
    btn1.setLayoutParams(LinearLayout.LayoutParams(
        LinearLayout.LayoutParams.MATCH_PARENT,
        dp(40)
    ))
    btn1.setText("INFINITE AMMO")
    btn1.setTextColor(TEXT_COLOR)
    btn1.setTextSize(TypedValue.COMPLEX_UNIT_SP, 13)
    btn1.setAllCaps(false)
    btn1.setTypeface(nil, Typeface.BOLD)
    btn1.setBackground(getRippleDrawable(GREEN, dp(6)))
    
    btn1.onClick = function(v)
        gg.toast("INFINITE AMMO ACTIVATED!")
    end
    
    contentLayout.addView(btn1)
    
    local btn2 = Button(activity)
    btn2.setLayoutParams(LinearLayout.LayoutParams(
        LinearLayout.LayoutParams.MATCH_PARENT,
        dp(40)
    ))
    btn2.setText("NO RELOAD")
    btn2.setTextColor(TEXT_COLOR)
    btn2.setTextSize(TypedValue.COMPLEX_UNIT_SP, 13)
    btn2.setAllCaps(false)
    btn2.setTypeface(nil, Typeface.BOLD)
    btn2.setBackground(getRippleDrawable(ORANGE, dp(6)))
    
    btn2.onClick = function(v)
        gg.toast("NO RELOAD ACTIVATED!")
    end
    
    contentLayout.addView(btn2)
    
    local cat3 = TextView(activity)
    cat3.setLayoutParams(LinearLayout.LayoutParams(
        LinearLayout.LayoutParams.MATCH_PARENT,
        LinearLayout.LayoutParams.WRAP_CONTENT
    ))
    cat3.setPadding(dp(12), dp(6), dp(12), dp(6))
    cat3.setText("VISUALS")
    cat3.setTextColor(BLUE)
    cat3.setGravity(Gravity.CENTER)
    cat3.setBackground(getBorderBackground(CARD_COLOR, BLUE, dp(1), dp(6)))
    cat3.setTextSize(TypedValue.COMPLEX_UNIT_SP, 14)
    cat3.setTypeface(Typeface.DEFAULT_BOLD)
    contentLayout.addView(cat3)
    
    local switch4Container = LinearLayout(activity)
    switch4Container.setLayoutParams(LinearLayout.LayoutParams(
        LinearLayout.LayoutParams.MATCH_PARENT,
        dp(45)
    ))
    switch4Container.setOrientation(LinearLayout.HORIZONTAL)
    switch4Container.setGravity(Gravity.CENTER_VERTICAL)
    switch4Container.setBackground(getShapeBackground(CARD_COLOR, dp(6)))
    switch4Container.setPadding(dp(10), 0, dp(10), 0)
    
    local switch4Text = TextView(activity)
    switch4Text.setLayoutParams(LinearLayout.LayoutParams(
        LinearLayout.LayoutParams.WRAP_CONTENT,
        LinearLayout.LayoutParams.WRAP_CONTENT
    ))
    switch4Text.setText("ESP BOX")
    switch4Text.setTextSize(TypedValue.COMPLEX_UNIT_SP, 13)
    switch4Text.setTextColor(TEXT_COLOR)
    switch4Text.setTypeface(nil, Typeface.BOLD)
    
    local switch4View = Switch(activity)
    if Build.VERSION.SDK_INT >= 21 then
        switch4View.setTrackTintList(ColorStateList.valueOf(Color.parseColor("#555555")))
        switch4View.setThumbTintList(ColorStateList.valueOf(BLUE))
    end
    
    switch4View.setOnCheckedChangeListener(CompoundButton.OnCheckedChangeListener{
        onCheckedChanged = function(buttonView, isChecked)
            if isChecked then
                if Build.VERSION.SDK_INT >= 21 then
                    switch4View.setTrackTintList(ColorStateList.valueOf(Color.parseColor("#64B5F6")))
                    switch4View.setThumbTintList(ColorStateList.valueOf(BLUE))
                end
                gg.toast("ESP BOX ACTIVATED")
            else
                gg.toast("ESP BOX DEACTIVATED")
            end
        end
    })
    
    switch4Container.addView(switch4Text)
    switch4Container.addView(switch4View)
    contentLayout.addView(switch4Container)
    
    local switch5Container = LinearLayout(activity)
    switch5Container.setLayoutParams(LinearLayout.LayoutParams(
        LinearLayout.LayoutParams.MATCH_PARENT,
        dp(45)
    ))
    switch5Container.setOrientation(LinearLayout.HORIZONTAL)
    switch5Container.setGravity(Gravity.CENTER_VERTICAL)
    switch5Container.setBackground(getShapeBackground(CARD_COLOR, dp(6)))
    switch5Container.setPadding(dp(10), 0, dp(10), 0)
    
    local switch5Text = TextView(activity)
    switch5Text.setLayoutParams(LinearLayout.LayoutParams(
        LinearLayout.LayoutParams.WRAP_CONTENT,
        LinearLayout.LayoutParams.WRAP_CONTENT
    ))
    switch5Text.setText("ESP LINES")
    switch5Text.setTextSize(TypedValue.COMPLEX_UNIT_SP, 13)
    switch5Text.setTextColor(TEXT_COLOR)
    switch5Text.setTypeface(nil, Typeface.BOLD)
    
    local switch5View = Switch(activity)
    if Build.VERSION.SDK_INT >= 21 then
        switch5View.setTrackTintList(ColorStateList.valueOf(Color.parseColor("#555555")))
        switch5View.setThumbTintList(ColorStateList.valueOf(BLUE))
    end
    
    switch5View.setOnCheckedChangeListener(CompoundButton.OnCheckedChangeListener{
        onCheckedChanged = function(buttonView, isChecked)
            if isChecked then
                if Build.VERSION.SDK_INT >= 21 then
                    switch5View.setTrackTintList(ColorStateList.valueOf(Color.parseColor("#64B5F6")))
                    switch5View.setThumbTintList(ColorStateList.valueOf(BLUE))
                end
                gg.toast("ESP LINES ACTIVATED")
            else
                gg.toast("ESP LINES DEACTIVATED")
            end
        end
    })
    
    switch5Container.addView(switch5Text)
    switch5Container.addView(switch5View)
    contentLayout.addView(switch5Container)
    
    local seekContainer2 = LinearLayout(activity)
    seekContainer2.setLayoutParams(LinearLayout.LayoutParams(
        LinearLayout.LayoutParams.MATCH_PARENT,
        LinearLayout.LayoutParams.WRAP_CONTENT
    ))
    seekContainer2.setPadding(dp(10), dp(8), dp(10), dp(8))
    seekContainer2.setOrientation(LinearLayout.VERTICAL)
    seekContainer2.setBackground(getShapeBackground(CARD_COLOR, dp(6)))
    
    local seekText2 = TextView(activity)
    seekText2.setLayoutParams(LinearLayout.LayoutParams(
        LinearLayout.LayoutParams.MATCH_PARENT,
        LinearLayout.LayoutParams.WRAP_CONTENT
    ))
    seekText2.setText("FOV: 90")
    seekText2.setTextSize(TypedValue.COMPLEX_UNIT_SP, 13)
    seekText2.setTextColor(TEXT_COLOR)
    seekText2.setPadding(0, 0, 0, dp(6))
    
    local seekBar2 = SeekBar(activity)
    seekBar2.setLayoutParams(LinearLayout.LayoutParams(
        LinearLayout.LayoutParams.MATCH_PARENT,
        LinearLayout.LayoutParams.WRAP_CONTENT
    ))
    
    if Build.VERSION.SDK_INT >= 21 then
        seekBar2.setThumbTintList(ColorStateList.valueOf(BLUE))
        seekBar2.setProgressTintList(ColorStateList.valueOf(Color.parseColor("#64B5F6")))
    end
    
    seekBar2.setProgress(90)
    seekBar2.setMax(120)
    
    seekBar2.setOnSeekBarChangeListener(SeekBar.OnSeekBarChangeListener{
        onProgressChanged = function(seekBar, progress, fromUser)
            seekText2.setText("FOV: " .. progress)
            gg.toast("FOV: " .. progress)
        end,
        onStartTrackingTouch = function(seekBar) end,
        onStopTrackingTouch = function(seekBar) end
    })
    
    seekContainer2.addView(seekText2)
    seekContainer2.addView(seekBar2)
    contentLayout.addView(seekContainer2)
    
    local closeBtn = Button(activity)
    closeBtn.setLayoutParams(LinearLayout.LayoutParams(
        LinearLayout.LayoutParams.MATCH_PARENT,
        dp(35)
    ))
    closeBtn.setText("CLOSE MENU")
    closeBtn.setTextColor(TEXT_COLOR)
    closeBtn.setTextSize(TypedValue.COMPLEX_UNIT_SP, 12)
    closeBtn.setBackground(getRippleDrawable(RED, dp(6)))
    
    closeBtn.onClick = function(v)
        hideMenu()
        
        gg.sleep(50)
      --  showIconOnly()
    end
    
    contentLayout.addView(closeBtn)
    
local exitBtn = Button(activity)
    exitBtn.setLayoutParams(LinearLayout.LayoutParams(
        LinearLayout.LayoutParams.MATCH_PARENT,
        dp(35)
    ))
    exitBtn.setText("Exit MENU")
    exitBtn.setTextColor(TEXT_COLOR)
    exitBtn.setTextSize(TypedValue.COMPLEX_UNIT_SP, 12)
    exitBtn.setBackground(getRippleDrawable(WHITE, dp(6)))
    
    exitBtn.onClick = function(v)
windowManager.removeView(mainLayout)
shouldExit = true
os.exit()
        gg.sleep(50)
      --  showIconOnly()
    end
    
    contentLayout.addView(exitBtn)
  
    scrollView.addView(contentLayout)
    mainLayout.addView(scrollView)
    
    return mainLayout
end

function closeIcon()
    handler.post(function()
        pcall(function()
            if floatingMenuView ~= nil and windowManager ~= nil then
                windowManager.removeView(floatingMenuView)
                floatingMenuView = nil
                isMenuVisible = false
                gg.toast("Menu closed")
            end
        end)
    end)
    shouldExit = true
end

function showIconOnly()
    if not menuInitialized then
        initializeSystemWindows()
    end
    
    handler.post(function()
        pcall(function()
            if floatingMenuView ~= nil then
                windowManager.removeView(floatingMenuView)
            end
            floatingMenuView = createFloatingIcon()
            windowManager.addView(floatingMenuView, menuParams)
            isMenuVisible = true
        end)
    end)
end

function showFullMenu()
    if not menuInitialized then
        initializeSystemWindows()
    end
    
    handler.post(function()
        pcall(function()
            if floatingMenuView ~= nil then
                windowManager.removeView(floatingMenuView)
            end
            floatingMenuView = createFullMenu()
            windowManager.addView(floatingMenuView, menuParams)
            isMenuVisible = true
        end)
    end)
end

function hideMenu()
    handler.post(function()
        pcall(function()
            if floatingMenuView ~= nil and windowManager ~= nil then
                windowManager.removeView(floatingMenuView)
                floatingMenuView = nil
            end
            isMenuVisible = false
        end)
    end)
end

function isMenuOpen()
    return isMenuVisible
end

showFullMenu()

    while true do
  if shouldExit then break end
  
  if gg.isVisible(true) then
    XGCK1 = 1
    gg.setVisible(false)
    gg.clearResults()
  end
  
  if _speedHackPending then
    _speedHackPending = false
    gg.setRanges(gg.REGION_CODE_APP)
    gg.searchNumber("-0.50344371796;9.99999997e-7;-0.50291442871::9", gg.TYPE_FLOAT)
    gg.refineNumber("9.99999997e-7", gg.TYPE_FLOAT)
    gg.getResults(100)
    gg.editAll("-1", gg.TYPE_FLOAT)
    gg.clearResults()
    gg.toast("HACK ATIVADO")
  end
  
  if XGCK1 == 1 then    
showFullMenu()
  end  
  XGCK1 = -1
  gg.sleep(100)
end
  
  
  
