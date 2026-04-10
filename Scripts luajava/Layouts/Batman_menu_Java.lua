gg.setVisible(false)

import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "android.graphics.*"
import "android.graphics.drawable.*"
import "android.util.TypedValue"
import "android.text.Html"
import "android.content.Context"
import "android.view.WindowManager"
import "android.view.Gravity"
import "android.content.res.Resources"
import "android.util.DisplayMetrics"
import "android.text.InputType"
import "android.text.method.DigitsKeyListener"
import "java.util.Arrays"
import "java.util.LinkedList"

SETTING_MENUE = 1
INFO_MENUE = 2
TABS = {"Dashboard", "Settings", "Info"}
TEXT_COLOR_2 = Color.WHITE
MENU_FEATURE_BG_COLOR = Color.parseColor("#95000000")
BTN_COLOR = Color.parseColor("#FFFF9700")
NumberTxtColor = "#41c300"
HintTxtColor = Color.parseColor("#FF171E24")
RadioColor = Color.WHITE
colorBtnNormal = "#313439"
colorBtnBlue = "#2833CB"

ctx = activity
windowManager = activity.getSystemService(Context.WINDOW_SERVICE)
screenWidth = 0
screenHeight = 0
dpi = 0
density = 0
g_mainLayout = nil
layoutParents = {}
isMenuVisible = true

function dp(value)
    return TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, value, activity.getResources().getDisplayMetrics())
end

function convertDipToPixels(dipValue)
    return math.floor((dipValue * activity.getResources().getDisplayMetrics().density) + 0.5)
end

function getLayoutType()
    if Build.VERSION.SDK_INT >= 26 then
        return WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
    else
        return WindowManager.LayoutParams.TYPE_PHONE
    end
end

function AddText(object, text, size, style, color, onClick)
    local textView = TextView(activity)
    textView.setText(text)
    textView.setTextColor(Color.parseColor(color))
    textView.setTypeface(nil, style)
    textView.setPadding(dp(5), dp(5), dp(5), dp(5))
    textView.setTextSize(TypedValue.COMPLEX_UNIT_SP, size)
    textView.setLayoutParams(LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT))
    
    if onClick then
        textView.setOnClickListener{
            onClick = function(v)
                onClick()
            end
        }
    end
    
    if type(object) == "number" then
        layoutParents[object].addView(textView)
    else
        object.addView(textView)
    end
end

function AddTextView(object, text, color, onClick)
    local textView = TextView(activity)
    textView.setText(text)
    textView.setTextColor(Color.parseColor(color))
    textView.setTypeface(Typeface.DEFAULT)
    textView.setPadding(dp(4), dp(1), dp(1), dp(1))
    textView.setTextSize(TypedValue.COMPLEX_UNIT_SP, 12)
    textView.setBackgroundColor(Color.parseColor(colorBtnNormal))
    
    if onClick then
        textView.setOnClickListener{
            onClick = function(v)
                onClick()
            end
        }
    end
    
    if type(object) == "number" then
        layoutParents[object].addView(textView)
    else
        object.addView(textView)
    end
end

function AddTextCenter(object, text, color, onClick)
    local textView = TextView(activity)
    textView.setText(text)
    textView.setGravity(Gravity.CENTER)
    textView.setTextColor(Color.parseColor(color))
    textView.setTypeface(Typeface.DEFAULT)
    textView.setPadding(dp(4), dp(1), dp(1), dp(1))
    textView.setTextSize(TypedValue.COMPLEX_UNIT_SP, 12)
    textView.setBackgroundColor(Color.parseColor(colorBtnNormal))
    
    if onClick then
        textView.setOnClickListener{
            onClick = function(v)
                onClick()
            end
        }
    end
    
    if type(object) == "number" then
        layoutParents[object].addView(textView)
    else
        object.addView(textView)
    end
end

function AddCategory(object, featureName, onClick)
    AddTextView(object, featureName, "#FFFFFFFF", onClick)
end

function AddCategoryCenter(object, featureName, onClick)
    AddTextCenter(object, featureName, "#FFFFFFFF", onClick)
end

function AddToggle(object, featureName, onClick)
    local switchButton = Switch(activity)
    switchButton.setText(featureName)
    switchButton.setTextColor(Color.WHITE)
    switchButton.setTextSize(TypedValue.COMPLEX_UNIT_SP, 12)
    switchButton.setTypeface(Typeface.DEFAULT)
    switchButton.setPadding(dp(4), dp(4), dp(4), dp(4))
    switchButton.setLayoutParams(LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT))
    
    switchButton.getTrackDrawable().setColorFilter(Color.parseColor("#000000"), PorterDuff.Mode.SRC_IN)
    switchButton.getThumbDrawable().setColorFilter(Color.WHITE, PorterDuff.Mode.SRC_IN)
    
    switchButton.setOnCheckedChangeListener{
        onCheckedChanged = function(compoundButton, isChecked)
            if isChecked then
                switchButton.getTrackDrawable().setColorFilter(Color.parseColor(colorBtnBlue), PorterDuff.Mode.SRC_IN)
                switchButton.getThumbDrawable().setColorFilter(Color.parseColor(colorBtnBlue), PorterDuff.Mode.SRC_IN)
            else
                switchButton.getTrackDrawable().setColorFilter(Color.parseColor("#000000"), PorterDuff.Mode.SRC_IN)
                switchButton.getThumbDrawable().setColorFilter(Color.WHITE, PorterDuff.Mode.SRC_IN)
            end
            if onClick then
                onClick(isChecked)
            end
        end
    }
    
    if type(object) == "number" then
        layoutParents[object].addView(switchButton)
    else
        object.addView(switchButton)
    end   
    return switchButton
end

function AddButton(object, text, onClick)
    local button = Button(activity)
    button.setText(text)
    button.setTextColor(Color.WHITE)
    button.setOnClickListener{
        onClick = function(v)
            if onClick then
                onClick()
            end
        end
    }
    button.setLayoutParams(LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT))
    
    local gradientDrawable = GradientDrawable()
    gradientDrawable.setColor(Color.parseColor("#FF343434"))
    gradientDrawable.setStroke(2, Color.BLACK)
    gradientDrawable.setCornerRadius(dp(5))
    button.setBackgroundDrawable(gradientDrawable)
    
    if type(object) == "number" then
        layoutParents[object].addView(button)
    else
        object.addView(button)
    end  
    return button
end

function AddSeekbar(object, featureName, start, first, last, onChange)
    local linearLayout = LinearLayout(activity)
    linearLayout.setLayoutParams(LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT))
    linearLayout.setOrientation(LinearLayout.HORIZONTAL)
    linearLayout.setPadding(dp(5), dp(5), dp(5), dp(5))
    
    local textView = TextView(activity)
    textView.setText(featureName .. ":")
    textView.setTextSize(TypedValue.COMPLEX_UNIT_SP, 12.5)
    textView.setPadding(dp(10), dp(5), dp(10), dp(5))
    textView.setTextColor(Color.WHITE)
    textView.setLayoutParams(LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT))
    textView.setGravity(Gravity.START)
    
    local seekBar = SeekBar(activity)
    seekBar.setMax(last)
    
    if Build.VERSION.SDK_INT >= 26 then
        seekBar.setMin(first)
    end
    seekBar.setProgress(start)
    
    local seekbarDrawable = GradientDrawable()
    seekbarDrawable.setShape(GradientDrawable.RECTANGLE)
    seekbarDrawable.setColor(Color.WHITE)
    seekbarDrawable.setStroke(dp(2), Color.WHITE)
    seekbarDrawable.setCornerRadius(300.0)
    seekBar.setThumb(seekbarDrawable)
    seekBar.getProgressDrawable().setColorFilter(Color.GREEN, PorterDuff.Mode.SRC_IN)
    
    seekBar.setPadding(dp(15), dp(5), dp(15), dp(5))
    
    local textView2 = TextView(activity)
    textView2.setText(tostring(start))
    textView2.setGravity(Gravity.END)
    textView2.setTextSize(TypedValue.COMPLEX_UNIT_SP, 12.5)
    textView2.setLayoutParams(LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT))
    textView2.setPadding(dp(15), dp(5), dp(15), dp(5))
    textView2.setTextColor(Color.WHITE)
    
    seekBar.setOnSeekBarChangeListener{
        onProgressChanged = function(seekBar, progress, fromUser)
            if progress < first then
                progress = first
                seekBar.setProgress(progress)
            end
            textView2.setText(tostring(progress))
            if onChange and fromUser then
                onChange(progress)
            end
        end,
        
        onStartTrackingTouch = function(seekBar)
        end,
        
        onStopTrackingTouch = function(seekBar)
        end
    }
    
    linearLayout.addView(textView)
    linearLayout.addView(textView2)    
    if type(object) == "number" then
        layoutParents[object].addView(linearLayout)
        layoutParents[object].addView(seekBar)
    else
        object.addView(linearLayout)
        object.addView(seekBar)
    end   
    return seekBar
end

function AddEditText(object, featureName, isNumeric, onChange)
    local linearLayout = LinearLayout(activity)
    linearLayout.setOrientation(LinearLayout.VERTICAL)
    linearLayout.setPadding(dp(5), dp(5), dp(5), dp(5))   
    local textView = TextView(activity)
    textView.setText(featureName)
    textView.setTextColor(Color.WHITE)
    textView.setTextSize(TypedValue.COMPLEX_UNIT_SP, 12)
    
    local editText = EditText(activity)
    editText.setTextColor(Color.WHITE)
    editText.setHintTextColor(HintTxtColor)
    editText.setBackgroundColor(Color.parseColor("#333333"))
    editText.setPadding(dp(10), dp(5), dp(10), dp(5))
    
    if isNumeric then
        editText.setInputType(InputType.TYPE_CLASS_NUMBER)
        editText.setKeyListener(DigitsKeyListener.getInstance("0123456789"))
    end
    
    editText.addTextChangedListener{
        afterTextChanged = function(editable)
            if onChange then
                onChange(editText.getText().toString())
            end
        end
    }
    
    linearLayout.addView(textView)
    linearLayout.addView(editText)
    
    if type(object) == "number" then
        layoutParents[object].addView(linearLayout)
    else
        object.addView(linearLayout)
    end    
    return editText
end

function AddSpinner(object, featureName, list, onSelect)
    local lists = LinkedList(Arrays.asList(list:split(",")))
    
    local linearLayout = LinearLayout(activity)
    linearLayout.setOrientation(LinearLayout.VERTICAL)
    linearLayout.setPadding(dp(5), dp(5), dp(5), dp(5))   
    local textView = TextView(activity)
    textView.setText(featureName)
    textView.setTextColor(Color.WHITE)
    textView.setTextSize(TypedValue.COMPLEX_UNIT_SP, 12)
    
    local spinner = Spinner(activity)
    local adapter = ArrayAdapter(activity, android.R.layout.simple_spinner_item, lists)
    adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item)
    spinner.setAdapter(adapter)
    
    spinner.setOnItemSelectedListener{
        onItemSelected = function(parent, view, position, id)
            if onSelect then
                onSelect(lists.get(position))
            end
        end,
        onNothingSelected = function(parent)
        end
    }
    
    linearLayout.addView(textView)
    linearLayout.addView(spinner)
    
    if type(object) == "number" then
        layoutParents[object].addView(linearLayout)
    else
        object.addView(linearLayout)
    end
    
    return spinner
end

function AddRadioButton(object, featureName, list, onSelect)
    local lists = LinkedList(Arrays.asList(list:split(",")))
    
    local linearLayout = LinearLayout(activity)
    linearLayout.setOrientation(LinearLayout.VERTICAL)
    linearLayout.setPadding(dp(5), dp(5), dp(5), dp(5))
    
    local textView = TextView(activity)
    textView.setText(featureName)
    textView.setTextColor(Color.WHITE)
    textView.setTextSize(TypedValue.COMPLEX_UNIT_SP, 12)
    
    local radioGroup = RadioGroup(activity)
    radioGroup.setOrientation(LinearLayout.VERTICAL)
    
    for i = 0, lists.size() - 1 do
        local radioButton = RadioButton(activity)
        radioButton.setText(lists.get(i))
        radioButton.setTextColor(Color.LTGRAY)
        
        if Build.VERSION.SDK_INT >= 21 then
        end
        
        radioButton.setOnClickListener(function()
            if onSelect then
                onSelect(lists.get(i))
            end
        end)
        
        radioGroup.addView(radioButton)
    end
    
    linearLayout.addView(textView)
    linearLayout.addView(radioGroup)
    
    if type(object) == "number" then
        layoutParents[object].addView(linearLayout)
    else
        object.addView(linearLayout)
    end
    
    return radioGroup
end

function setupMenuContent()
    AddCategoryCenter(0, "Batman Mod Menu", function()
        gg.toast("Menu Title Clicked")
    end)
    
    AddToggle(0, "God Mode", function(state)
        if state then

    _speedHackPending = true



--toggleMenuVisibility()
        else
            gg.toast("God Mode OFF")
        end
    end)
    
    AddToggle(0, "Unlimited Ammo", function(state)
        if state then
            gg.toast("Unlimited Ammo ON")
        else
            gg.toast("Unlimited Ammo OFF")
        end
    end)
    
    AddToggle(0, "No Recoil", function(state)
        if state then
            gg.toast("No Recoil ON")
        else
            gg.toast("No Recoil OFF")
        end
    end)
    
    AddRadioButton(0, "Weapon Selection", "Pistol,Shotgun,Assault Rifle,Sniper", function(weapon)
        gg.toast("Selected: " .. weapon)
    end)
    
    AddSpinner(0, "Game Mode", "Easy,Normal,Hard,Extreme", function(mode)
       -- gg.toast("Mode: " .. mode)
    end)
    
    AddSeekbar(0, "Player Speed", 50, 0, 100, function(value)
        gg.toast("Speed: " .. value)
    end)
    
    AddSeekbar(0, "Damage Multiplier", 100, 50, 500, function(value)
        gg.toast("Damage: " .. value .. "%")
    end)
    
    AddButton(0, "Exit", function()
      --  gg.toast("")
      
      closeAlt()
    end)
   
end

function closeAlt()
    toggleMenuVisibility()
    if floatingMenuView ~= nil and windowManager ~= nil then
        local handler = Handler(Looper.getMainLooper())
        handler.post(function()
            pcall(function()
                g_mainLayout.setVisibility(View.VISIBLE)
                g_mainLayout = nil
                windowManager = nil
               -- isMenuVisible = false
                shouldExit = true  
            end)
        end)
    else
        shouldExit = true 
    end   
    local timer = Timer()
    timer.schedule(TimerTask({
        run = function()
            os.exit()
        end
    }), 100)
end


function toggleMenuVisibility()
    if g_mainLayout then
        if isMenuVisible then
            g_mainLayout.setVisibility(View.GONE)
            isMenuVisible = false
        else
            g_mainLayout.setVisibility(View.VISIBLE)
            isMenuVisible = true
        end
    end
end

function onCreate()
    if activity == nil then
        print("Activity not available")
        return
    end
    
    local displayMetrics = DisplayMetrics()
    activity.getWindowManager().getDefaultDisplay().getMetrics(displayMetrics)
    screenWidth = displayMetrics.widthPixels
    screenHeight = displayMetrics.heightPixels
    dpi = displayMetrics.densityDpi
    density = displayMetrics.density
    
    for i = 0, 2 do
        layoutParents[i] = LinearLayout(activity)
        layoutParents[i].setOrientation(LinearLayout.VERTICAL)
        layoutParents[i].setLayoutParams(LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT))
        layoutParents[i].setVisibility(View.GONE)
    end
    
    g_mainLayout = LinearLayout(activity)
    g_mainLayout.setOrientation(LinearLayout.VERTICAL)
    g_mainLayout.setLayoutParams(LinearLayout.LayoutParams(convertDipToPixels(320), LinearLayout.LayoutParams.WRAP_CONTENT))
    g_mainLayout.setPadding(dp(10), dp(10), dp(10), dp(10))
    
    local gradientDrawable = GradientDrawable()
    gradientDrawable.setColor(Color.parseColor("#FF343331"))
    gradientDrawable.setCornerRadius(dp(10))
    gradientDrawable.setStroke(2, Color.parseColor("#FF8800FF"))
    g_mainLayout.setBackgroundDrawable(gradientDrawable)
    
    local headerLayout = LinearLayout(activity)
    headerLayout.setOrientation(LinearLayout.HORIZONTAL)
    headerLayout.setLayoutParams(LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, convertDipToPixels(40)))
    headerLayout.setGravity(Gravity.CENTER_VERTICAL)
    
    local titleText = TextView(activity)
    titleText.setText("Batman Menu")
    titleText.setTextColor(Color.parseColor("#FFFF9700"))
    titleText.setTextSize(TypedValue.COMPLEX_UNIT_SP, 16)
    titleText.setTypeface(Typeface.DEFAULT_BOLD)
    titleText.setLayoutParams(LinearLayout.LayoutParams(0, LinearLayout.LayoutParams.MATCH_PARENT, 1.0))
    titleText.setGravity(Gravity.CENTER_VERTICAL)
    titleText.setPadding(dp(10), 0, 0, 0)
    
    local closeButton = Button(activity)
    closeButton.setText("X")
    closeButton.setTextColor(Color.WHITE)
    closeButton.setBackgroundColor(Color.parseColor("#FFCC0000"))
    closeButton.setLayoutParams(LinearLayout.LayoutParams(convertDipToPixels(50), convertDipToPixels(40)))
    closeButton.setOnClickListener(function(view)
        toggleMenuVisibility()
    end)
    
    headerLayout.addView(titleText)
    headerLayout.addView(closeButton)
    
    local tabLayout = LinearLayout(activity)
    tabLayout.setOrientation(LinearLayout.HORIZONTAL)
    tabLayout.setLayoutParams(LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, convertDipToPixels(35)))
    tabLayout.setGravity(Gravity.CENTER)
    
    for i, tabName in ipairs(TABS) do
        local tabButton = Button(activity)
        tabButton.setText(tabName)
        tabButton.setTextColor(Color.WHITE)
        tabButton.setLayoutParams(LinearLayout.LayoutParams(0, LinearLayout.LayoutParams.MATCH_PARENT, 1.0))
        tabButton.setBackgroundColor(Color.parseColor("#181818"))
        tabButton.setTag(i-1)
        
        tabButton.setOnClickListener(function(view)
            local tabIndex = tonumber(tostring(view.getTag()))
            for j = 0, 2 do
                if j == tabIndex then
                    layoutParents[j].setVisibility(View.VISIBLE)
                    tabButton.setBackgroundColor(Color.parseColor("#FF8800FF"))
                else
                    layoutParents[j].setVisibility(View.GONE)
                    local otherButton = view.getParent().getChildAt(j)
                    otherButton.setBackgroundColor(Color.parseColor("#181818"))
                end
            end
        end)
        
        tabLayout.addView(tabButton)
    end
    
    local scrollView = ScrollView(activity)
    scrollView.setLayoutParams(LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, convertDipToPixels(300)))
    
    local contentLayout = LinearLayout(activity)
    contentLayout.setOrientation(LinearLayout.VERTICAL)
    contentLayout.setLayoutParams(LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT))
    
    for i = 0, 2 do
        contentLayout.addView(layoutParents[i])
    end
    
    scrollView.addView(contentLayout)
    
    g_mainLayout.addView(headerLayout)
    g_mainLayout.addView(tabLayout)
    g_mainLayout.addView(scrollView)
    
    setupMenuContent()
    layoutParents[0].setVisibility(View.VISIBLE)
    tabLayout.getChildAt(0).setBackgroundColor(Color.parseColor("#FF8800FF"))
    
    local windowParams = WindowManager.LayoutParams(
        convertDipToPixels(320),
        WindowManager.LayoutParams.WRAP_CONTENT,
        getLayoutType(),
        WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE | WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS,
        PixelFormat.TRANSLUCENT
    )
    
    windowParams.gravity = Gravity.TOP | Gravity.START
    windowParams.x = 50
    windowParams.y = 100
    
    local success, err = pcall(function()
        windowManager.addView(g_mainLayout, windowParams)
    end)
end

onCreate()

function onStart()
    activity.runOnUiThread(function()
        local success, err = pcall(onCreate)
        if not success then
            print("Error in onCreate: " .. tostring(err))
        end
    end)
end

local success, err = pcall(onStart)
if not success then
    onCreate()
end

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
    gg.toast(" HACK ACTIVATED")
  end
  
  if XGCK1 == 1 then
pcall(onStart)
  end
  
  XGCK1 = -1
  gg.sleep(100)
end
