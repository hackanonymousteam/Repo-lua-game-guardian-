gg.setVisible(false)
if luajava == nil then gg.alert(' unavaliable please use gameguardian mod (suport luajava)') else end

if not activity then
    gg.alert("No activity available")
    return
end

local function bind(c)
    local ok, r = pcall(luajava.bindClass, c)
    if ok then return r end
    return nil
end

local TextView = bind("android.widget.TextView")
local Button = bind("android.widget.Button")
local Switch = bind("android.widget.Switch")
local SeekBar = bind("android.widget.SeekBar")
local CheckBox = bind("android.widget.CheckBox")
local RadioButton = bind("android.widget.RadioButton")
local RadioGroup = bind("android.widget.RadioGroup")
local Spinner = bind("android.widget.Spinner")
local EditText = bind("android.widget.EditText")
local ScrollView = bind("android.widget.ScrollView")
local LinearLayout = bind("android.widget.LinearLayout")
local RelativeLayout = bind("android.widget.RelativeLayout")
local FrameLayout = bind("android.widget.FrameLayout")
local ImageView = bind("android.widget.ImageView")
local ArrayAdapter = bind("android.widget.ArrayAdapter")
local WindowManager = bind("android.view.WindowManager")
local PixelFormat = bind("android.graphics.PixelFormat")
local Gravity = bind("android.view.Gravity")
local Color = bind("android.graphics.Color")
local Build = bind("android.os.Build")
local MotionEvent = bind("android.view.MotionEvent")
local View = bind("android.view.View")
local Html = bind("android.text.Html")
local Typeface = bind("android.graphics.Typeface")
local GradientDrawable = bind("android.graphics.drawable.GradientDrawable")
local ColorStateList = bind("android.content.res.ColorStateList")
local PorterDuff = bind("android.graphics.PorterDuff")
local Uri = bind("android.net.Uri")
local Intent = bind("android.content.Intent")
local InputType = bind("android.text.InputType")
local AlertDialog = bind("android.app.AlertDialog")
local TypedValue = bind("android.util.TypedValue")

local COLOR_TEXT = 0xFF82CAFD
local COLOR_TEXT_2 = 0xFFFFFFFF
local COLOR_BTN = 0xFF1C262D
local COLOR_MENU_BG = 0xEE1C2A35
local COLOR_FEATURE_BG = 0xDD141C22
local COLOR_TOGGLE_ON = 0xFF00FF00
local COLOR_TOGGLE_OFF = 0xFFFF0000
local COLOR_BTN_ON = 0xFF1b5e20
local COLOR_BTN_OFF = 0xFF7f0000
local COLOR_CATEGORY = 0xFF2F3D4C
local COLOR_SEEKBAR = 0xFF80CBC4
local COLOR_CHECKBOX = 0xFF80CBC4
local COLOR_RADIO = 0xFFFFFFFF

local MENU_WIDTH = 290
local MENU_HEIGHT = 210
local ICON_SIZE = 45

local windowManager
local rootLayout
local mainParams
local collapsedLayout
local expandedLayout
local scrollView
local patchesLayout
local isExpanded = false

local featureStates = {}

local function getLayoutType()
    if Build.VERSION.SDK_INT >= 26 then
        return 2038
    elseif Build.VERSION.SDK_INT >= 23 then
        return 2002
    else
        return 2003
    end
end

local function dp(value)
    if not TypedValue then
        local density = activity.getResources().getDisplayMetrics().density
        return value * density
    end
    local metrics = activity.getResources().getDisplayMetrics()
    return TypedValue.applyDimension(1, value, metrics)
end

local function getFeatureList()
    return {

        "Toggle_Unlimited Ammo", 
        "SeekBar_Damage_1_100",
        "ButtonOnOff_Aimbot",
        "CheckBox_Wallhack",
      --  "RadioButton_Team_Red,Blue,Green",
        "Category_=== Contact ===",
        "ButtonLink_Telegram_https://t.me/batmangamesS"
    }
end

local function createSwitch(text)
    local sw = luajava.new(Switch, activity)
    sw.setText(text)
    sw.setTextColor(COLOR_TEXT_2)
    
    featureStates[text] = featureStates[text] or false
    sw.setChecked(featureStates[text])
    
    sw.setOnCheckedChangeListener(luajava.createProxy("android.widget.CompoundButton$OnCheckedChangeListener", {
        onCheckedChanged = function(btn, isChecked)
            featureStates[text] = isChecked
            --gg.toast(text .. ": " .. (isChecked and "ON" or "OFF"))
      _unli = true
          end
    }))
    
    return sw
end

local function createSeekBar(text, min, max)
    local layout = luajava.new(LinearLayout, activity)
    layout.setOrientation(LinearLayout.VERTICAL)
    
    local label = luajava.new(TextView, activity)
    featureStates[text] = featureStates[text] or min
    label.setText(text .. ": " .. featureStates[text])
    label.setTextColor(COLOR_TEXT_2)
    layout.addView(label)
    
    local seekbar = luajava.new(SeekBar, activity)
    seekbar.setMax(max - min)
    seekbar.setProgress(featureStates[text] - min)
    
    seekbar.setOnSeekBarChangeListener(luajava.createProxy("android.widget.SeekBar$OnSeekBarChangeListener", {
        onProgressChanged = function(bar, progress, fromUser)
            local value = progress + min
            featureStates[text] = value
            label.setText(text .. ": " .. value)
            va = value
            _dama = true
            
            
        end,
        onStartTrackingTouch = function() end,
        onStopTrackingTouch = function() end
    }))
    
    layout.addView(seekbar)
    return layout
end

local function createButton(text)
    local btn = luajava.new(Button, activity)
    btn.setText(text)
    btn.setTextColor(COLOR_TEXT_2)
    btn.setBackgroundColor(COLOR_BTN)
    
    btn.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
        onClick = function(v)
            gg.toast(text .. " executed!")
        end
    }))
    
    return btn
end

local function createButtonOnOff(text)
    local btn = luajava.new(Button, activity)
    featureStates[text] = featureStates[text] or false
    
    local function updateButton()
        if featureStates[text] then
            btn.setText(text .. ": ON")
            btn.setBackgroundColor(COLOR_BTN_ON)
            
            _aimbotPending = true
        else
            btn.setText(text .. ": OFF")
            btn.setBackgroundColor(COLOR_BTN_OFF)
            

        end
    end
    
    updateButton()
    btn.setTextColor(COLOR_TEXT_2)
    
    btn.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
        onClick = function(v)
            featureStates[text] = not featureStates[text]
            updateButton()
            gg.toast(text .. ": " .. (featureStates[text] and "ON" or "OFF"))
        end
    }))
    
    return btn
end

local function createCheckBox(text)
    local cb = luajava.new(CheckBox, activity)
    cb.setText(text)
    cb.setTextColor(COLOR_TEXT_2)

    featureStates[text] = featureStates[text] or false
    cb.setChecked(featureStates[text])

    cb.setOnCheckedChangeListener(luajava.createProxy(
        "android.widget.CompoundButton$OnCheckedChangeListener",
        {
            onCheckedChanged = function(btn, isChecked)
                featureStates[text] = isChecked
                _wall = isChecked -- 🔥 aqui resolve
            end
        }
    ))

    return cb
end

local function createRadioButton(text, items)
    local layout = luajava.new(LinearLayout, activity)
    layout.setOrientation(LinearLayout.VERTICAL)
    
    local label = luajava.new(TextView, activity)
    label.setText(text)
    label.setTextColor(COLOR_TEXT_2)
    layout.addView(label)
    
    local radioGroup = luajava.new(RadioGroup, activity)
    radioGroup.setOrientation(LinearLayout.VERTICAL)
    
    featureStates[text] = featureStates[text] or 1
    
    for i = 1, #items do
        local radio = luajava.new(RadioButton, activity)
        radio.setText(items[i])
        radio.setTextColor(0xFFD3D3D3)
        
        if i == featureStates[text] then
            radio.setChecked(true)
        end
        
        radio.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
            onClick = function(v)
                featureStates[text] = i
                gg.toast(text .. ": " .. items[i])
            end
        }))
        
        radioGroup.addView(radio)
    end
    
    layout.addView(radioGroup)
    return layout
end

local function createCategory(text)
    local tv = luajava.new(TextView, activity)
    tv.setText(text)
    tv.setTextColor(COLOR_TEXT_2)
    tv.setBackgroundColor(COLOR_CATEGORY)
    tv.setGravity(Gravity.CENTER)
    tv.setPadding(0, 10, 0, 10)
    return tv
end

local function createButtonLink(text, url)
    local btn = luajava.new(Button, activity)
    btn.setText(text)
    btn.setTextColor(COLOR_TEXT_2)
    btn.setBackgroundColor(COLOR_BTN)
    
    btn.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
        onClick = function(v)
            local intent = luajava.new(Intent, Intent.ACTION_VIEW)
            intent.setData(Uri.parse(url))
            activity.startActivity(intent)
        end
    }))
    
    return btn
end

local function processFeature(featureStr)
    local parts = {}
    for part in featureStr:gmatch("[^_]+") do
        table.insert(parts, part)
    end
    
    local featureType = parts[1]
    
    if featureType == "Toggle" then
        return createSwitch(parts[2])
        
    elseif featureType == "SeekBar" then
        return createSeekBar(parts[2], tonumber(parts[3]), tonumber(parts[4]))
        
    elseif featureType == "Button" then
        return createButton(parts[2])
        
    elseif featureType == "ButtonOnOff" then
        return createButtonOnOff(parts[2])
        
    
    elseif featureType == "CheckBox" then
        return createCheckBox(parts[2])
        
    elseif featureType == "RadioButton" then
        local items = {}
        for item in parts[3]:gmatch("[^,]+") do
            table.insert(items, item)
        end
        return createRadioButton(parts[2], items)
        
    elseif featureType == "Category" then
        return createCategory(parts[2])
        
    elseif featureType == "ButtonLink" then
        return createButtonLink(parts[2], parts[3])
    end
    
    return nil
end

local initialX, initialY, initialTouchX, initialTouchY

local touchListener = luajava.createProxy("android.view.View$OnTouchListener", {
    onTouch = function(v, event)
        local action = event.getAction()
        
        if action == MotionEvent.ACTION_DOWN then
            initialX = mainParams.x
            initialY = mainParams.y
            initialTouchX = event.getRawX()
            initialTouchY = event.getRawY()
            return true
            
        elseif action == MotionEvent.ACTION_MOVE then
            mainParams.x = initialX + (event.getRawX() - initialTouchX)
            mainParams.y = initialY + (event.getRawY() - initialTouchY)
            windowManager.updateViewLayout(rootLayout, mainParams)
            return true
            
        elseif action == MotionEvent.ACTION_UP then
            local diffX = math.abs(event.getRawX() - initialTouchX)
            local diffY = math.abs(event.getRawY() - initialTouchY)
            
            if diffX < 10 and diffY < 10 then
                if collapsedLayout.getVisibility() == View.VISIBLE then
                    collapsedLayout.setVisibility(View.GONE)
                    expandedLayout.setVisibility(View.VISIBLE)
                end
            end
            return true
        end
        
        return false
    end
})

local function buildMenu()
    windowManager = activity.getSystemService(activity.WINDOW_SERVICE)
    
    rootLayout = luajava.new(FrameLayout, activity)
    rootLayout.setOnTouchListener(touchListener)
    
    local container = luajava.new(RelativeLayout, activity)
    
    collapsedLayout = luajava.new(RelativeLayout, activity)
    collapsedLayout.setVisibility(View.VISIBLE)
    
    local iconView = luajava.new(TextView, activity)
    iconView.setText("🎮")
    iconView.setTextSize(30)
    iconView.setGravity(Gravity.CENTER)
    iconView.setBackgroundColor(0xFF2196F3)
    iconView.setWidth(dp(ICON_SIZE))
    iconView.setHeight(dp(ICON_SIZE))
    iconView.setOnTouchListener(touchListener)
    
    collapsedLayout.addView(iconView)
    
    expandedLayout = luajava.new(LinearLayout, activity)
    expandedLayout.setVisibility(View.GONE)
    expandedLayout.setOrientation(LinearLayout.VERTICAL)
    expandedLayout.setBackgroundColor(COLOR_MENU_BG)
    expandedLayout.setMinimumWidth(dp(MENU_WIDTH))
    
    local titleLayout = luajava.new(RelativeLayout, activity)
    titleLayout.setPadding(10, 10, 10, 10)
    
    local titleText = luajava.new(TextView, activity)
    titleText.setText("MOD MENU GG")
    titleText.setTextColor(COLOR_TEXT)
    titleText.setTextSize(18)
    titleText.setGravity(Gravity.CENTER)
    
    local titleParams = luajava.new(RelativeLayout.LayoutParams, -2, -2)
    titleText.setLayoutParams(titleParams)
    
    titleLayout.addView(titleText)
    expandedLayout.addView(titleLayout)
    
    scrollView = luajava.new(ScrollView, activity)
    scrollView.setBackgroundColor(COLOR_FEATURE_BG)
    
    local scrollParams = luajava.new(LinearLayout.LayoutParams, -1, dp(MENU_HEIGHT))
    scrollView.setLayoutParams(scrollParams)
    
    patchesLayout = luajava.new(LinearLayout, activity)
    patchesLayout.setOrientation(LinearLayout.VERTICAL)
    patchesLayout.setPadding(5, 5, 5, 5)
    
    local features = getFeatureList()
    for _, feature in ipairs(features) do
        local view = processFeature(feature)
        if view then
            patchesLayout.addView(view)
        end
    end
    
    scrollView.addView(patchesLayout)
    expandedLayout.addView(scrollView)
    
    local buttonLayout = luajava.new(LinearLayout, activity)
    buttonLayout.setOrientation(LinearLayout.HORIZONTAL)
    buttonLayout.setPadding(10, 5, 10, 10)
    
    local hideBtn = luajava.new(Button, activity)
    hideBtn.setText("HIDE")
    hideBtn.setTextColor(COLOR_TEXT)
    hideBtn.setBackgroundColor(0x00000000)
    
    hideBtn.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
        onClick = function(v)
            collapsedLayout.setVisibility(View.VISIBLE)
            collapsedLayout.setAlpha(0.3)
            expandedLayout.setVisibility(View.GONE)
        end
    }))
    
    local closeBtn = luajava.new(Button, activity)
    closeBtn.setText("MINIMIZE")
    closeBtn.setTextColor(COLOR_TEXT)
    closeBtn.setBackgroundColor(0x00000000)
    
    closeBtn.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
        onClick = function(v)
            collapsedLayout.setVisibility(View.VISIBLE)
            collapsedLayout.setAlpha(1.0)
            expandedLayout.setVisibility(View.GONE)
        end
    }))
    
    local exitBtn = luajava.new(Button, activity)
    exitBtn.setText("EXIT")
    exitBtn.setTextColor(0xFFFF0000)
    exitBtn.setBackgroundColor(0x00000000)
    
    exitBtn.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
        onClick = function(v)
            windowManager.removeView(rootLayout)
isMenuVisible = true
             gg.toast("Menu closed")
            os.exit()
        end
    }))
    
    local space = luajava.new(TextView, activity)
    space.setText(" ")
    
    buttonLayout.addView(hideBtn)
    buttonLayout.addView(space)
    buttonLayout.addView(closeBtn)    
    buttonLayout.addView(exitBtn)
    
    expandedLayout.addView(buttonLayout)
    
    container.addView(collapsedLayout)
    container.addView(expandedLayout)
    rootLayout.addView(container)
    
    mainParams = luajava.newInstance(
        "android.view.WindowManager$LayoutParams",
        -2,
        -2,
        getLayoutType(),
        0x00000008,
        PixelFormat.TRANSLUCENT
    )
    
    mainParams.gravity = Gravity.TOP + Gravity.LEFT
    mainParams.x = 0
    mainParams.y = 100
    
    activity.runOnUiThread(luajava.createProxy("java.lang.Runnable", {
        run = function()
            windowManager.addView(rootLayout, mainParams)
isMenuVisible = false
            gg.toast("Menu loaded successfully!")
        end
    }))
end

    while true do
  if isMenuVisible then break end
   if gg.isVisible(true) then
    XGCK1 = 1
    gg.setVisible(false)
    gg.clearResults()
  end
  
  
  
    if _unli then
    _unli = false
    gg.setRanges(gg.REGION_CODE_APP)
    gg.searchNumber("-0.50344371796;9.99999997e-7;-0.50291442871::9", gg.TYPE_FLOAT)
    gg.refineNumber("9.99999997e-7", gg.TYPE_FLOAT)
    gg.getResults(100)
    gg.editAll("-1", gg.TYPE_FLOAT)
    gg.clearResults()
    gg.toast("HACK ON")
  end
  
if _dama then
    _dama = false
    gg.setRanges(gg.REGION_CODE_APP)
    gg.searchNumber(va, gg.TYPE_FLOAT)
    gg.refineNumber("9.99999997e-7", gg.TYPE_FLOAT)
    gg.getResults(100)
    gg.editAll("-1", gg.TYPE_FLOAT)
    gg.clearResults()
    gg.toast("HACK on")
  end
  
  if _aimbotPending then
    _aimbotPending = false
    gg.setRanges(gg.REGION_CODE_APP)
    gg.searchNumber("-0.50344371796;9.99999997e-7;-0.50291442871::9", gg.TYPE_FLOAT)
    gg.refineNumber("9.99999997e-7", gg.TYPE_FLOAT)
    gg.getResults(100)
    gg.editAll("-1", gg.TYPE_FLOAT)
    gg.clearResults()
    gg.toast("HACK ON")
  end
  
  
  
  
  if _wall then
    _wall = false
    gg.setRanges(gg.REGION_CODE_APP)
    gg.searchNumber("-0.50344371796;9.99999997e-7;-0.50291442871::9", gg.TYPE_FLOAT)
    gg.refineNumber("9.99999997e-7", gg.TYPE_FLOAT)
    gg.getResults(100)
    gg.editAll("-1", gg.TYPE_FLOAT)
    gg.clearResults()
    gg.toast("HACK on")
  end
  
if XGCK1 == 0 then    
buildMenu()
  end  
  if XGCK1 == 1 then    

buildMenu()
  end  
  XGCK1 = -1
end
  

