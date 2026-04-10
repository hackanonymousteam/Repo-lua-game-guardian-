gg.setVisible(false)

local AlertDialog = luajava.bindClass("android.app.AlertDialog$Builder")
local Color = luajava.bindClass("android.graphics.Color")
local Context = luajava.bindClass("android.content.Context")
local Gravity = luajava.bindClass("android.view.Gravity")
local MotionEvent = luajava.bindClass("android.view.MotionEvent")
local PixelFormat = luajava.bindClass("android.graphics.PixelFormat")
local TypedValue = luajava.bindClass("android.util.TypedValue")
local View = luajava.bindClass("android.view.View")
local WindowManager = luajava.bindClass("android.view.WindowManager")
local Build = luajava.bindClass("android.os.Build")
local Typeface = luajava.bindClass("android.graphics.Typeface")
local Handler = luajava.bindClass("android.os.Handler")
local Looper = luajava.bindClass("android.os.Looper")

local Button = luajava.bindClass("android.widget.Button")
local EditText = luajava.bindClass("android.widget.EditText")
local FrameLayout = luajava.bindClass("android.widget.FrameLayout")
local LinearLayout = luajava.bindClass("android.widget.LinearLayout")
local ScrollView = luajava.bindClass("android.widget.ScrollView")
local TextView = luajava.bindClass("android.widget.TextView")

local mWindowManager, mFloatingView, params = nil, nil, nil
local collapsedView, expandedView, patchContainer = nil, nil, nil
local titleTextView, closeButton = nil, nil
local isMenuVisible = false
local menuX, menuY = 50, 100
local menuWidth, menuHeight = 280, 400
local minWidth, minHeight = 60, 60

local WHITE = Color.parseColor("#FFFFFFFF")
local PRIMARY = Color.parseColor("#FF6200EE")
local DARK = Color.parseColor("#FF2D3133")
local GRAY = Color.parseColor("#66333333")

local function dp(value)
    return TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, value, activity.getResources().getDisplayMetrics())
end

local function getWindowType()
    if Build.VERSION.SDK_INT >= 26 then
        return WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
    else
        return WindowManager.LayoutParams.TYPE_SYSTEM_ALERT
    end
end

local function initFloating()
    mFloatingView = FrameLayout(activity)
    
    collapsedView = FrameLayout(activity)
    collapsedView.setLayoutParams(FrameLayout.LayoutParams(dp(60), dp(60)))
    
    local iconView = TextView(activity)
    iconView.setLayoutParams(FrameLayout.LayoutParams(dp(50), dp(50)))
    iconView.setGravity(Gravity.CENTER)
    iconView.setText("⚡")
    iconView.setTextSize(TypedValue.COMPLEX_UNIT_SP, 30)
    iconView.setTextColor(WHITE)
    iconView.setBackgroundColor(PRIMARY)
    
    local iconWrapper = FrameLayout(activity)
    iconWrapper.setLayoutParams(FrameLayout.LayoutParams(dp(60), dp(60)))
    iconWrapper.setPadding(dp(5), dp(5), dp(5), dp(5))
    iconWrapper.addView(iconView)
    collapsedView.addView(iconWrapper)
    
    expandedView = LinearLayout(activity)
    expandedView.setLayoutParams(LinearLayout.LayoutParams(dp(menuWidth), dp(menuHeight)))
    expandedView.setOrientation(LinearLayout.VERTICAL)
    expandedView.setBackgroundColor(DARK)
    expandedView.setVisibility(View.GONE)
    
    local headerLayout = LinearLayout(activity)
    headerLayout.setLayoutParams(LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, dp(45)))
    headerLayout.setOrientation(LinearLayout.HORIZONTAL)
    headerLayout.setGravity(Gravity.CENTER_VERTICAL)
    headerLayout.setBackgroundColor(PRIMARY)
    headerLayout.setPadding(dp(10), 0, dp(5), 0)
    
    titleTextView = TextView(activity)
    titleTextView.setLayoutParams(LinearLayout.LayoutParams(0, LinearLayout.LayoutParams.WRAP_CONTENT, 1))
    titleTextView.setText("⚡ MAIN MENU")
    titleTextView.setTextColor(WHITE)
    titleTextView.setTextSize(TypedValue.COMPLEX_UNIT_SP, 16)
    titleTextView.setTypeface(Typeface.DEFAULT_BOLD)
    titleTextView.setGravity(Gravity.CENTER)
    
    closeButton = TextView(activity)
    closeButton.setLayoutParams(LinearLayout.LayoutParams(dp(35), dp(35)))
    closeButton.setText("✕")
    closeButton.setTextColor(WHITE)
    closeButton.setTextSize(TypedValue.COMPLEX_UNIT_SP, 18)
    closeButton.setGravity(Gravity.CENTER)
    closeButton.setBackgroundColor(Color.argb(80, 0, 0, 0))
    headerLayout.addView(titleTextView)
    headerLayout.addView(closeButton)
    expandedView.addView(headerLayout)
    
    local scrollView = ScrollView(activity)
    scrollView.setLayoutParams(
        LinearLayout.LayoutParams(
            LinearLayout.LayoutParams.MATCH_PARENT,
            LinearLayout.LayoutParams.MATCH_PARENT
        )
    )
    scrollView.setVerticalScrollBarEnabled(true)
    
    patchContainer = LinearLayout(activity)
    patchContainer.setLayoutParams(LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT))
    patchContainer.setOrientation(LinearLayout.VERTICAL)
    patchContainer.setPadding(dp(10), dp(10), dp(10), dp(10))
    
    scrollView.addView(patchContainer)
    expandedView.addView(scrollView)
    
    mFloatingView.addView(collapsedView)
    mFloatingView.addView(expandedView)
    
    mWindowManager = activity.getSystemService(Context.WINDOW_SERVICE)
    params = WindowManager.LayoutParams(
        dp(60), dp(60),
        getWindowType(),
        WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE,
        PixelFormat.TRANSPARENT
    )
    params.gravity = Gravity.TOP + Gravity.LEFT
    params.x = dp(menuX)
    params.y = dp(menuY)
    
    mWindowManager.addView(mFloatingView, params)
    
    local startX, startY, touchX, touchY = 0, 0, 0, 0
    
    mFloatingView.setOnTouchListener(luajava.createProxy("android.view.View$OnTouchListener", {
        onTouch = function(view, event)
            local action = event.getAction()
            
            if action == MotionEvent.ACTION_DOWN then
                startX = params.x
                startY = params.y
                touchX = event.getRawX()
                touchY = event.getRawY()
                return true
                
            elseif action == MotionEvent.ACTION_UP then
                local dx = math.abs(event.getRawX() - touchX)
                local dy = math.abs(event.getRawY() - touchY)
                
                if dx < 10 and dy < 10 then
                    if collapsedView.getVisibility() == View.VISIBLE then
                        params.width = dp(menuWidth)
                        params.height = dp(menuHeight)
                        mWindowManager.updateViewLayout(mFloatingView, params)
                        collapsedView.setVisibility(View.GONE)
                        expandedView.setVisibility(View.VISIBLE)
                    end
                end
                return true
                
            elseif action == MotionEvent.ACTION_MOVE then
                params.x = startX + (event.getRawX() - touchX)
                params.y = startY + (event.getRawY() - touchY)
                mWindowManager.updateViewLayout(mFloatingView, params)
                return true
            end
            return false
        end
    }))
    
    closeButton.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
        onClick = function()
            params.width = dp(60)
            params.height = dp(60)
            mWindowManager.updateViewLayout(mFloatingView, params)
            expandedView.setVisibility(View.GONE)
            collapsedView.setVisibility(View.VISIBLE)
        end
    }))
    
    isMenuVisible = true
    
    activity.runOnUiThread(luajava.createProxy("java.lang.Runnable", {
        run = function()
            addCategory("🚀 MAIN FUNCTIONS")
            addButton("AIMBOT", function() _speedHackPending = true end)
            addButton("WALLHACK", function() end)
            addButton("NO RECOIL", function() end)
            
            addCategory("⚙️ SETTINGS")
            addEditText("SHADER", function(val) end)
            
            addCategory("🎮 OTHER")
            addButton("EXIT", function() 
                closeMenu()
               -- gg.exit()
            end)
        end
    }))
end

function addCategory(text)
    if not patchContainer then return end
    
    local tv = TextView(activity)
    tv.setLayoutParams(LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT))
    tv.setText("  " .. text)
    tv.setTextColor(PRIMARY)
    tv.setTextSize(TypedValue.COMPLEX_UNIT_SP, 16)
    tv.setTypeface(Typeface.DEFAULT_BOLD)
    tv.setPadding(0, dp(15), 0, dp(5))
    patchContainer.addView(tv)
end

function addButton(text, callback)
    if not patchContainer then return end
    
    local btn = Button(activity)
    btn.setLayoutParams(LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, dp(45)))
    btn.setText(text)
    btn.setTextColor(WHITE)
    btn.setTextSize(TypedValue.COMPLEX_UNIT_SP, 15)
    btn.setBackgroundColor(PRIMARY)
    btn.setPadding(dp(10), 0, dp(10), 0)
    btn.setAllCaps(false)
    
    btn.setOnTouchListener(luajava.createProxy("android.view.View$OnTouchListener", {
        onTouch = function(v, event)
            if event.getAction() == MotionEvent.ACTION_DOWN then
                v.setAlpha(0.7)
            elseif event.getAction() == MotionEvent.ACTION_UP or event.getAction() == MotionEvent.ACTION_CANCEL then
                v.setAlpha(1.0)
            end
            return false
        end
    }))
    
    btn.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
        onClick = function()
            if callback then callback() end
        end
    }))
    
    local params = LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, dp(45))
    params.bottomMargin = dp(5)
    btn.setLayoutParams(params)
    
    patchContainer.addView(btn)
end

function addEditText(label, callback)
    if not patchContainer then return end
    
    local container = LinearLayout(activity)
    container.setOrientation(LinearLayout.VERTICAL)
    container.setPadding(0, dp(5), 0, dp(5))
    
    local labelView = TextView(activity)
    labelView.setText(label)
    labelView.setTextColor(WHITE)
    labelView.setTextSize(TypedValue.COMPLEX_UNIT_SP, 14)
    labelView.setPadding(dp(5), 0, 0, dp(3))
    container.addView(labelView)
    
    local btn = Button(activity)
    btn.setLayoutParams(LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, dp(40)))
    btn.setText("[ CLICK TO EDIT ]")
    btn.setTextColor(WHITE)
    btn.setTextSize(TypedValue.COMPLEX_UNIT_SP, 14)
    btn.setBackgroundColor(GRAY)
    btn.setAllCaps(false)
    
    btn.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
        onClick = function()
            local alert = luajava.newInstance("android.app.AlertDialog$Builder", activity)
            alert.setTitle("ENTER VALUE")
            
            local input = EditText(activity)
            input.setSingleLine(true)
            input.setHint(label)
            alert.setView(input)
            
            alert.setPositiveButton("OK", luajava.createProxy("android.content.DialogInterface$OnClickListener", {
                onClick = function(dialog, which)
                    local value = input.getText().toString()
                    btn.setText(value:len() > 0 and value or "[ EMPTY ]")
                    if callback then callback(value) end
                end
            }))
            
            alert.setNegativeButton("CANCEL", nil)
            
            local dialog = alert.create()
            dialog.getWindow().setType(getWindowType())
            dialog.show()
        end
    }))
    
    container.addView(btn)
    patchContainer.addView(container)
end

function closeMenu()
    if mWindowManager and mFloatingView then
        pcall(function()
            mWindowManager.removeView(mFloatingView)
        end)
        mFloatingView = nil
        isMenuVisible = false
    end
end

if not isMenuVisible then
    activity.runOnUiThread(luajava.createProxy("java.lang.Runnable", {
        run = function()
           local success, err = pcall(initFloating)
            if not success then
                print("ERROR: " .. tostring(err))
            end
        end
    }))
end

while true do
  if shouldExit then break end
  
  if _speedHackPending then
    _speedHackPending = false
    gg.setRanges(gg.REGION_CODE_APP)
    gg.searchNumber("-0.50344371796;9.99999997e-7;-0.50291442871::9", gg.TYPE_FLOAT)
    gg.refineNumber("9.99999997e-7", gg.TYPE_FLOAT)
    gg.getResults(100)
    gg.editAll("-1", gg.TYPE_FLOAT)
    gg.clearResults()
    gg.toast("⚡ SPEED HACK ACTIVATED")
  end
  end
  
