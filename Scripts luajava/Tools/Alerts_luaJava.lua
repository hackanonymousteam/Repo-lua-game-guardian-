gg.setVisible(true)

local TypedValue = luajava.bindClass("android.util.TypedValue")
local Gravity = luajava.bindClass("android.view.Gravity")
local PixelFormat = luajava.bindClass("android.graphics.PixelFormat")
local Color = luajava.bindClass("android.graphics.Color")
local GradientDrawable = luajava.bindClass("android.graphics.drawable.GradientDrawable")
local ColorDrawable = luajava.bindClass("android.graphics.drawable.ColorDrawable")
local Typeface = luajava.bindClass("android.graphics.Typeface")
local View = luajava.bindClass("android.view.View")
local MotionEvent = luajava.bindClass("android.view.MotionEvent")
local WindowManager = luajava.bindClass("android.view.WindowManager")
local Context = luajava.bindClass("android.content.Context")
local Build = luajava.bindClass("android.os.Build")
local LinearLayout = luajava.bindClass("android.widget.LinearLayout")
local TextView = luajava.bindClass("android.widget.TextView")
local Button = luajava.bindClass("android.widget.Button")
local ScrollView = luajava.bindClass("android.widget.ScrollView")

local PRIMARY_COLOR = Color.parseColor("#FF4500")
local SECONDARY_COLOR = Color.parseColor("#1E1E1E")
local DARK_BG = Color.parseColor("#121212")
local WHITE = Color.parseColor("#FFFFFF")
local BLACK = Color.parseColor("#000000")
local RED = Color.parseColor("#F44336")
local GREEN = Color.parseColor("#4CAF50")
local BLUE = Color.parseColor("#2196F3")
local PURPLE = Color.parseColor("#9C27B0")
local YELLOW = Color.parseColor("#FFC107")
local GRAY = Color.parseColor("#888888")

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

local windowManager = nil
local dialogWindow = nil
local dialogParams = nil
local isDialogShowing = false

function closeDialog()
    if dialogWindow ~= nil and windowManager ~= nil and isDialogShowing then
        activity.runOnUiThread(luajava.createProxy("java.lang.Runnable", {
            run = function()
                pcall(function()
                    windowManager.removeView(dialogWindow)
                    dialogWindow = nil
                    isDialogShowing = false
                end)
            end
        }))
    end
end

function showThreeButtonDialog()
    if isDialogShowing then closeDialog() end
    
    activity.runOnUiThread(luajava.createProxy("java.lang.Runnable", {
        run = function()
            local mainLayout = LinearLayout(activity)
            mainLayout.setLayoutParams(LinearLayout.LayoutParams(dp(320), LinearLayout.LayoutParams.WRAP_CONTENT))
            mainLayout.setOrientation(LinearLayout.VERTICAL)
            mainLayout.setBackground(getShapeBackground(DARK_BG, 20))
            mainLayout.setPadding(dp(20), dp(20), dp(20), dp(20))
            
            local titleView = TextView(activity)
            titleView.setLayoutParams(LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT))
            titleView.setText("Three Button Dialog")
            titleView.setTextColor(WHITE)
            titleView.setTextSize(TypedValue.COMPLEX_UNIT_SP, 22)
            titleView.setTypeface(Typeface.DEFAULT_BOLD)
            titleView.setGravity(Gravity.CENTER)
            titleView.setPadding(0, 0, 0, dp(15))
            mainLayout.addView(titleView)
            
            local messageView = TextView(activity)
            messageView.setLayoutParams(LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT))
            messageView.setText("This is a basic three button dialog with styled buttons.")
            messageView.setTextColor(WHITE)
            messageView.setTextSize(TypedValue.COMPLEX_UNIT_SP, 16)
            messageView.setGravity(Gravity.CENTER)
            messageView.setPadding(0, 0, 0, dp(25))
            mainLayout.addView(messageView)
            
            local buttonLayout = LinearLayout(activity)
            buttonLayout.setLayoutParams(LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT))
            buttonLayout.setOrientation(LinearLayout.HORIZONTAL)
            
            local acceptBtn = Button(activity)
            acceptBtn.setLayoutParams(LinearLayout.LayoutParams(0, dp(45), 1))
            acceptBtn.setText("Accept")
            acceptBtn.setTextColor(WHITE)
            acceptBtn.setBackground(getShapeBackground(GREEN, 15))
            acceptBtn.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
                onClick = function(v)
                    gg.toast("Accept button clicked")
                    closeDialog()
                end
            }))
            
            local declineBtn = Button(activity)
            declineBtn.setLayoutParams(LinearLayout.LayoutParams(0, dp(45), 1))
            declineBtn.setText("Decline")
            declineBtn.setTextColor(WHITE)
            declineBtn.setBackground(getShapeBackground(RED, 15))
            declineBtn.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
                onClick = function(v)
                    gg.toast("Decline button clicked")
                    closeDialog()
                end
            }))
            
            local laterBtn = Button(activity)
            laterBtn.setLayoutParams(LinearLayout.LayoutParams(0, dp(45), 1))
            laterBtn.setText("Later")
            laterBtn.setTextColor(WHITE)
            laterBtn.setBackground(getShapeBackground(GRAY, 15))
            laterBtn.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
                onClick = function(v)
                    gg.toast("Later button clicked")
                    closeDialog()
                end
            }))
            
            buttonLayout.addView(acceptBtn)
            buttonLayout.addView(declineBtn)
            buttonLayout.addView(laterBtn)
            mainLayout.addView(buttonLayout)
            
            local closeBtn = Button(activity)
            closeBtn.setLayoutParams(LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, dp(40)))
            closeBtn.setText("Close")
            closeBtn.setTextColor(WHITE)
            closeBtn.setBackground(getShapeBackground(PURPLE, 15))
            closeBtn.setPadding(0, dp(10), 0, dp(10))
            closeBtn.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
                onClick = function(v)
                    closeDialog()
                end
            }))
            mainLayout.addView(closeBtn, LinearLayout.LayoutParams.MATCH_PARENT, dp(40))
            
            windowManager = activity.getSystemService(Context.WINDOW_SERVICE)
            dialogParams = WindowManager.LayoutParams(
                WindowManager.LayoutParams.WRAP_CONTENT,
                WindowManager.LayoutParams.WRAP_CONTENT,
                getLayoutType(),
                WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN,
                PixelFormat.TRANSLUCENT
            )
            dialogParams.gravity = Gravity.CENTER
            
            dialogWindow = mainLayout
            windowManager.addView(dialogWindow, dialogParams)
            isDialogShowing = true
        end
    }))
end

function showSingleChoiceSimpleDialog()
    if isDialogShowing then closeDialog() end
    
    activity.runOnUiThread(luajava.createProxy("java.lang.Runnable", {
        run = function()
            local items = {"Option A", "Option B"}
            
            local mainLayout = LinearLayout(activity)
            mainLayout.setLayoutParams(LinearLayout.LayoutParams(dp(300), LinearLayout.LayoutParams.WRAP_CONTENT))
            mainLayout.setOrientation(LinearLayout.VERTICAL)
            mainLayout.setBackground(getShapeBackground(DARK_BG, 20))
            mainLayout.setPadding(dp(20), dp(20), dp(20), dp(20))
            
            local titleView = TextView(activity)
            titleView.setLayoutParams(LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT))
            titleView.setText("Simple Choice")
            titleView.setTextColor(WHITE)
            titleView.setTextSize(TypedValue.COMPLEX_UNIT_SP, 22)
            titleView.setTypeface(Typeface.DEFAULT_BOLD)
            titleView.setGravity(Gravity.CENTER)
            titleView.setPadding(0, 0, 0, dp(20))
            mainLayout.addView(titleView)
            
            for i, item in ipairs(items) do
                local optionLayout = LinearLayout(activity)
                optionLayout.setLayoutParams(LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, dp(50)))
                optionLayout.setOrientation(LinearLayout.HORIZONTAL)
                optionLayout.setGravity(Gravity.CENTER_VERTICAL)
                optionLayout.setPadding(dp(15), 0, dp(15), 0)
                optionLayout.setBackground(getBorderBackground(SECONDARY_COLOR, GRAY, 1, 10))
                if i > 1 then
                    local params = optionLayout.getLayoutParams()
                    params.topMargin = dp(8)
                    optionLayout.setLayoutParams(params)
                end
                
                local radioView = TextView(activity)
                radioView.setLayoutParams(LinearLayout.LayoutParams(dp(30), dp(30)))
                radioView.setText("○")
                radioView.setTextColor(WHITE)
                radioView.setTextSize(TypedValue.COMPLEX_UNIT_SP, 20)
                radioView.setGravity(Gravity.CENTER)
                
                local textView = TextView(activity)
                textView.setLayoutParams(
    LinearLayout.LayoutParams(
        LinearLayout.LayoutParams.MATCH_PARENT,
        LinearLayout.LayoutParams.WRAP_CONTENT
    )
)
                textView.setText(item)
                textView.setTextColor(WHITE)
                textView.setTextSize(TypedValue.COMPLEX_UNIT_SP, 16)
                textView.setPadding(dp(10), 0, 0, 0)
                
                optionLayout.addView(radioView)
                optionLayout.addView(textView)
                
                optionLayout.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
                    onClick = function(v)
                        gg.toast("Selected: " .. item)
                        closeDialog()
                    end
                }))
                
                mainLayout.addView(optionLayout)
            end
            
            local closeBtn = Button(activity)
            closeBtn.setLayoutParams(LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, dp(40)))
            closeBtn.setText("Close")
            closeBtn.setTextColor(WHITE)
            closeBtn.setBackground(getShapeBackground(GRAY, 15))
            closeBtn.setPadding(0, dp(10), 0, dp(10))
            closeBtn.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
                onClick = function(v)
                    closeDialog()
                end
            }))
            mainLayout.addView(closeBtn, LinearLayout.LayoutParams.MATCH_PARENT, dp(40))
            
            windowManager = activity.getSystemService(Context.WINDOW_SERVICE)
            dialogParams = WindowManager.LayoutParams(
                WindowManager.LayoutParams.WRAP_CONTENT,
                WindowManager.LayoutParams.WRAP_CONTENT,
                getLayoutType(),
                WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE,
                PixelFormat.TRANSLUCENT
            )
            dialogParams.gravity = Gravity.CENTER
            
            dialogWindow = mainLayout
            windowManager.addView(dialogWindow, dialogParams)
            isDialogShowing = true
        end
    }))
end

function showSingleChoiceWithButtonsDialog()
    if isDialogShowing then closeDialog() end
    
    activity.runOnUiThread(luajava.createProxy("java.lang.Runnable", {
        run = function()
            local items = {"Function 1", "Function 2"}
            local selectedItem = nil
            
            local mainLayout = LinearLayout(activity)
            mainLayout.setLayoutParams(LinearLayout.LayoutParams(dp(300), LinearLayout.LayoutParams.WRAP_CONTENT))
            mainLayout.setOrientation(LinearLayout.VERTICAL)
            mainLayout.setBackground(getShapeBackground(DARK_BG, 20))
            mainLayout.setPadding(dp(20), dp(20), dp(20), dp(20))
            
            local titleView = TextView(activity)
            titleView.setLayoutParams(LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT))
            titleView.setText("Choice With Buttons")
            titleView.setTextColor(WHITE)
            titleView.setTextSize(TypedValue.COMPLEX_UNIT_SP, 22)
            titleView.setTypeface(Typeface.DEFAULT_BOLD)
            titleView.setGravity(Gravity.CENTER)
            titleView.setPadding(0, 0, 0, dp(20))
            mainLayout.addView(titleView)
            
            for i, item in ipairs(items) do
                local optionLayout = LinearLayout(activity)
                optionLayout.setLayoutParams(LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, dp(50)))
                optionLayout.setOrientation(LinearLayout.HORIZONTAL)
                optionLayout.setGravity(Gravity.CENTER_VERTICAL)
                optionLayout.setPadding(dp(15), 0, dp(15), 0)
                optionLayout.setBackground(getBorderBackground(SECONDARY_COLOR, GRAY, 1, 10))
                if i > 1 then
                    local params = optionLayout.getLayoutParams()
                    params.topMargin = dp(8)
                    optionLayout.setLayoutParams(params)
                end
                
                local radioView = TextView(activity)
                radioView.setLayoutParams(LinearLayout.LayoutParams(dp(30), dp(30)))
                
                
                radioView.setText("○")
                radioView.setTextColor(WHITE)
                radioView.setTextSize(TypedValue.COMPLEX_UNIT_SP, 20)
                
                local textView = TextView(activity)
                textView.setLayoutParams(
    LinearLayout.LayoutParams(
        LinearLayout.LayoutParams.MATCH_PARENT,
        LinearLayout.LayoutParams.WRAP_CONTENT
    )
)
                textView.setText(item)
                textView.setTextColor(WHITE)
                textView.setTextSize(TypedValue.COMPLEX_UNIT_SP, 16)
                textView.setPadding(dp(10), 0, 0, 0)
                
                optionLayout.addView(radioView)
                optionLayout.addView(textView)
                
                optionLayout.itemText = item
                
                optionLayout.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
                    onClick = function(v)
                        selectedItem = v.itemText
                        gg.toast("Selected: " .. selectedItem)
                    end
                }))
                
                mainLayout.addView(optionLayout)
            end
            
            local buttonLayout = LinearLayout(activity)
            buttonLayout.setLayoutParams(LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT))
            buttonLayout.setOrientation(LinearLayout.HORIZONTAL)
            buttonLayout.setPadding(0, dp(20), 0, dp(10))
            
            local yesBtn = Button(activity)
            yesBtn.setLayoutParams(LinearLayout.LayoutParams(0, dp(45), 1))
            yesBtn.setText("Yes")
            yesBtn.setTextColor(WHITE)
            yesBtn.setBackground(getShapeBackground(GREEN, 15))
            yesBtn.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
                onClick = function(v)
                    if selectedItem then
                        gg.toast("Confirmed: " .. selectedItem)
                    else
                        gg.toast("No item selected")
                    end
                    closeDialog()
                end
            }))
            
            local noBtn = Button(activity)
            noBtn.setLayoutParams(LinearLayout.LayoutParams(0, dp(45), 1))
            noBtn.setText("No")
            noBtn.setTextColor(WHITE)
            noBtn.setBackground(getShapeBackground(RED, 15))
            noBtn.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
                onClick = function(v)
                    gg.toast("Cancelled")
                    closeDialog()
                end
            }))
            
            buttonLayout.addView(yesBtn)
            buttonLayout.addView(noBtn)
            mainLayout.addView(buttonLayout)
            
            local closeBtn = Button(activity)
            closeBtn.setLayoutParams(LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, dp(40)))
            closeBtn.setText("Close")
            closeBtn.setTextColor(WHITE)
            closeBtn.setBackground(getShapeBackground(GRAY, 15))
            closeBtn.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
                onClick = function(v)
                    closeDialog()
                end
            }))
            mainLayout.addView(closeBtn, LinearLayout.LayoutParams.MATCH_PARENT, dp(40))
            
            windowManager = activity.getSystemService(Context.WINDOW_SERVICE)
            dialogParams = WindowManager.LayoutParams(
                WindowManager.LayoutParams.WRAP_CONTENT,
                WindowManager.LayoutParams.WRAP_CONTENT,
                getLayoutType(),
                WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE,
                PixelFormat.TRANSLUCENT
            )
            dialogParams.gravity = Gravity.CENTER
            
            dialogWindow = mainLayout
            windowManager.addView(dialogWindow, dialogParams)
            isDialogShowing = true
        end
    }))
end

function showRadioSelectionDialog()
    if isDialogShowing then closeDialog() end
    
    activity.runOnUiThread(luajava.createProxy("java.lang.Runnable", {
        run = function()
            local items = {"Low", "Medium", "High", "Maximum"}
            local selectedIndex = 1
            
            local mainLayout = LinearLayout(activity)
            mainLayout.setLayoutParams(LinearLayout.LayoutParams(dp(300), LinearLayout.LayoutParams.WRAP_CONTENT))
            mainLayout.setOrientation(LinearLayout.VERTICAL)
            mainLayout.setBackground(getShapeBackground(DARK_BG, 20))
            mainLayout.setPadding(dp(20), dp(20), dp(20), dp(20))
            
            local titleView = TextView(activity)
            titleView.setLayoutParams(LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT))
            titleView.setText("Radio Selection")
            titleView.setTextColor(WHITE)
            titleView.setTextSize(TypedValue.COMPLEX_UNIT_SP, 22)
            titleView.setTypeface(Typeface.DEFAULT_BOLD)
            titleView.setGravity(Gravity.CENTER)
            titleView.setPadding(0, 0, 0, dp(20))
            mainLayout.addView(titleView)
            
            local optionViews = {}
            for i, item in ipairs(items) do
                local optionLayout = LinearLayout(activity)
                optionLayout.setLayoutParams(LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, dp(50)))
                optionLayout.setOrientation(LinearLayout.HORIZONTAL)
                optionLayout.setGravity(Gravity.CENTER_VERTICAL)
                optionLayout.setPadding(dp(15), 0, dp(15), 0)
                optionLayout.setBackground(getBorderBackground(SECONDARY_COLOR, GRAY, 1, 10))
                if i > 1 then
                    local params = optionLayout.getLayoutParams()
                    params.topMargin = dp(8)
                    optionLayout.setLayoutParams(params)
                end
                
                local radioView = TextView(activity)
                radioView.setLayoutParams(LinearLayout.LayoutParams(dp(30), dp(30)))
                radioView.setText(i == selectedIndex and "●" or "○")
                radioView.setTextColor(i == selectedIndex and BLUE or WHITE)
                radioView.setTextSize(TypedValue.COMPLEX_UNIT_SP, 24)
                radioView.setGravity(Gravity.CENTER)
                
                local textView = TextView(activity)
                textView.setLayoutParams(
                    LinearLayout.LayoutParams(
                        LinearLayout.LayoutParams.MATCH_PARENT,
                        LinearLayout.LayoutParams.WRAP_CONTENT
                    )
                )
                textView.setText(item)
                textView.setTextColor(WHITE)
                textView.setTextSize(TypedValue.COMPLEX_UNIT_SP, 16)
                textView.setPadding(dp(10), 0, 0, 0)
                
                optionLayout.addView(radioView)
                optionLayout.addView(textView)
                
                optionLayout.index = i
                optionLayout.radioView = radioView
                optionLayout.itemText = item
                table.insert(optionViews, {layout = optionLayout, radio = radioView})
                
                optionLayout.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
                    onClick = function(v)
                        selectedIndex = v.index
                        for idx, opt in ipairs(optionViews) do
                            if idx == selectedIndex then
                                opt.radio.setText("●")
                                opt.radio.setTextColor(BLUE)
                            else
                                opt.radio.setText("○")
                                opt.radio.setTextColor(WHITE)
                            end
                        end
                        gg.toast("Selected: " .. v.itemText)
                    end
                }))
                
                mainLayout.addView(optionLayout)
            end
            
            local buttonLayout = LinearLayout(activity)
            buttonLayout.setLayoutParams(LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT))
            buttonLayout.setOrientation(LinearLayout.HORIZONTAL)
            buttonLayout.setPadding(0, dp(20), 0, dp(10))
            
            local confirmBtn = Button(activity)
            confirmBtn.setLayoutParams(LinearLayout.LayoutParams(0, dp(45), 1))
            confirmBtn.setText("Confirm")
            confirmBtn.setTextColor(WHITE)
            confirmBtn.setBackground(getShapeBackground(GREEN, 15))
            confirmBtn.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
                onClick = function(v)
                    gg.toast("Confirmed: " .. items[selectedIndex])
                    closeDialog()
                end
            }))
            
            local cancelBtn = Button(activity)
            cancelBtn.setLayoutParams(LinearLayout.LayoutParams(0, dp(45), 1))
            cancelBtn.setText("Cancel")
            cancelBtn.setTextColor(WHITE)
            cancelBtn.setBackground(getShapeBackground(RED, 15))
            cancelBtn.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
                onClick = function(v)
                    gg.toast("Cancelled")
                    closeDialog()
                end
            }))
            
            buttonLayout.addView(confirmBtn)
            buttonLayout.addView(cancelBtn)
            mainLayout.addView(buttonLayout)
            
            local closeBtn = Button(activity)
            closeBtn.setLayoutParams(LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, dp(40)))
            closeBtn.setText("Close")
            closeBtn.setTextColor(WHITE)
            closeBtn.setBackground(getShapeBackground(GRAY, 15))
            closeBtn.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
                onClick = function(v)
                    closeDialog()
                end
            }))
            mainLayout.addView(closeBtn, LinearLayout.LayoutParams.MATCH_PARENT, dp(40))
            
            windowManager = activity.getSystemService(Context.WINDOW_SERVICE)
            dialogParams = WindowManager.LayoutParams(
                WindowManager.LayoutParams.WRAP_CONTENT,
                WindowManager.LayoutParams.WRAP_CONTENT,
                getLayoutType(),
                WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE,
                PixelFormat.TRANSLUCENT
            )
            dialogParams.gravity = Gravity.CENTER
            
            dialogWindow = mainLayout
            windowManager.addView(dialogWindow, dialogParams)
            isDialogShowing = true
        end
    }))
end

function showMultiChoiceDialog()
    if isDialogShowing then closeDialog() end
    
    activity.runOnUiThread(luajava.createProxy("java.lang.Runnable", {
        run = function()
            local items = {"Choice 1", "Choice 2"}
            local checked = {false, false}
            
            local mainLayout = LinearLayout(activity)
            mainLayout.setLayoutParams(LinearLayout.LayoutParams(dp(300), LinearLayout.LayoutParams.WRAP_CONTENT))
            mainLayout.setOrientation(LinearLayout.VERTICAL)
            mainLayout.setBackground(getShapeBackground(DARK_BG, 20))
            mainLayout.setPadding(dp(20), dp(20), dp(20), dp(20))
            
            local titleView = TextView(activity)
            titleView.setLayoutParams(LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT))
            titleView.setText("Multi Choice")
            titleView.setTextColor(WHITE)
            titleView.setTextSize(TypedValue.COMPLEX_UNIT_SP, 22)
            titleView.setTypeface(Typeface.DEFAULT_BOLD)
            titleView.setGravity(Gravity.CENTER)
            titleView.setPadding(0, 0, 0, dp(20))
            mainLayout.addView(titleView)
            
            local checkViews = {}
            for i, item in ipairs(items) do
                local optionLayout = LinearLayout(activity)
                optionLayout.setLayoutParams(LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, dp(50)))
                optionLayout.setOrientation(LinearLayout.HORIZONTAL)
                optionLayout.setGravity(Gravity.CENTER_VERTICAL)
                optionLayout.setPadding(dp(15), 0, dp(15), 0)
                optionLayout.setBackground(getBorderBackground(SECONDARY_COLOR, GRAY, 1, 10))
                if i > 1 then
                    local params = optionLayout.getLayoutParams()
                    params.topMargin = dp(8)
                    optionLayout.setLayoutParams(params)
                end
                
                local checkView = TextView(activity)
                checkView.setLayoutParams(LinearLayout.LayoutParams(dp(30), dp(30)))
                checkView.setText(checked[i] and "☑" or "☐")
                checkView.setTextColor(checked[i] and BLUE or WHITE)
                checkView.setTextSize(TypedValue.COMPLEX_UNIT_SP, 24)
                checkView.setGravity(Gravity.CENTER)
                
                local textView = TextView(activity)
                textView.setLayoutParams(
                    LinearLayout.LayoutParams(
                        LinearLayout.LayoutParams.MATCH_PARENT,
                        LinearLayout.LayoutParams.WRAP_CONTENT
                    )
                )
                textView.setText(item)
                textView.setTextColor(WHITE)
                textView.setTextSize(TypedValue.COMPLEX_UNIT_SP, 16)
                textView.setPadding(dp(10), 0, 0, 0)
                
                optionLayout.addView(checkView)
                optionLayout.addView(textView)
                
                optionLayout.index = i
                optionLayout.checkView = checkView
                optionLayout.itemText = item
                checkViews[i] = checkView
                
                optionLayout.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
                    onClick = function(v)
                        checked[v.index] = not checked[v.index]
                        v.checkView.setText(checked[v.index] and "☑" or "☐")
                        v.checkView.setTextColor(checked[v.index] and BLUE or WHITE)
                        
                        local status = checked[v.index] and "checked" or "unchecked"
                        gg.toast(v.itemText .. " " .. status)
                    end
                }))
                
                mainLayout.addView(optionLayout)
            end
            
            local buttonLayout = LinearLayout(activity)
            buttonLayout.setLayoutParams(LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT))
            buttonLayout.setOrientation(LinearLayout.HORIZONTAL)
            buttonLayout.setPadding(0, dp(20), 0, dp(10))
            
            local confirmBtn = Button(activity)
            confirmBtn.setLayoutParams(LinearLayout.LayoutParams(0, dp(45), 1))
            confirmBtn.setText("Confirm")
            confirmBtn.setTextColor(WHITE)
            confirmBtn.setBackground(getShapeBackground(GREEN, 15))
            confirmBtn.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
                onClick = function(v)
                    local selectedItems = {}
                    for i, item in ipairs(items) do
                        if checked[i] then
                            table.insert(selectedItems, item)
                        end
                    end
                    
                    if #selectedItems > 0 then
                        gg.toast("Selected: " .. table.concat(selectedItems, ", "))
                    else
                        gg.toast("No items selected")
                    end
                    closeDialog()
                end
            }))
            
            local cancelBtn = Button(activity)
            cancelBtn.setLayoutParams(LinearLayout.LayoutParams(0, dp(45), 1))
            cancelBtn.setText("Cancel")
            cancelBtn.setTextColor(WHITE)
            cancelBtn.setBackground(getShapeBackground(RED, 15))
            cancelBtn.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
                onClick = function(v)
                    gg.toast("Cancelled")
                    closeDialog()
                end
            }))
            
            buttonLayout.addView(confirmBtn)
            buttonLayout.addView(cancelBtn)
            mainLayout.addView(buttonLayout)
            
            local closeBtn = Button(activity)
            closeBtn.setLayoutParams(LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, dp(40)))
            closeBtn.setText("Close")
            closeBtn.setTextColor(WHITE)
            closeBtn.setBackground(getShapeBackground(RED, 15))
closeBtn.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
                onClick = function(v)
                    closeDialog()
                end
            }))
            mainLayout.addView(closeBtn)
            
            windowManager = activity.getSystemService(Context.WINDOW_SERVICE)
            dialogParams = WindowManager.LayoutParams(
                WindowManager.LayoutParams.WRAP_CONTENT,
                WindowManager.LayoutParams.WRAP_CONTENT,
                getLayoutType(),
                WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE,
                PixelFormat.TRANSLUCENT
            )
            dialogParams.gravity = Gravity.CENTER
            
            dialogWindow = mainLayout
            windowManager.addView(dialogWindow, dialogParams)
            isDialogShowing = true
        end
    }))
end
function showListActionDialog()
    if isDialogShowing then closeDialog() end
    
    activity.runOnUiThread(luajava.createProxy("java.lang.Runnable", {
        run = function()
            local items = {"Settings", "Profile", "Help", "Exit"}
            
            local mainLayout = LinearLayout(activity)
            mainLayout.setLayoutParams(LinearLayout.LayoutParams(dp(300), LinearLayout.LayoutParams.WRAP_CONTENT))
            mainLayout.setOrientation(LinearLayout.VERTICAL)
            mainLayout.setBackground(getShapeBackground(DARK_BG, 20))
            mainLayout.setPadding(dp(20), dp(20), dp(20), dp(20))
            
            local titleView = TextView(activity)
            titleView.setLayoutParams(LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT))
            titleView.setText("List Menu")
            titleView.setTextColor(WHITE)
            titleView.setTextSize(TypedValue.COMPLEX_UNIT_SP, 22)
            titleView.setTypeface(Typeface.DEFAULT_BOLD)
            titleView.setGravity(Gravity.CENTER)
            titleView.setPadding(0, 0, 0, dp(20))
            mainLayout.addView(titleView)
            
            for i, item in ipairs(items) do
                local itemLayout = LinearLayout(activity)
                itemLayout.setLayoutParams(LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, dp(50)))
                itemLayout.setOrientation(LinearLayout.HORIZONTAL)
                itemLayout.setGravity(Gravity.CENTER_VERTICAL)
                itemLayout.setPadding(dp(15), 0, dp(15), 0)
                itemLayout.setBackground(getBorderBackground(SECONDARY_COLOR, GRAY, 1, 10))
                if i > 1 then
                    local params = itemLayout.getLayoutParams()
                    params.topMargin = dp(8)
                    itemLayout.setLayoutParams(params)
                end
                
                local iconMap = {"⚙️", "👤", "❓", "🚪"}
                
                local iconView = TextView(activity)
                iconView.setLayoutParams(LinearLayout.LayoutParams(dp(30), dp(30)))
                iconView.setText(iconMap[i])
                iconView.setTextColor(WHITE)
                iconView.setTextSize(TypedValue.COMPLEX_UNIT_SP, 20)
                iconView.setGravity(Gravity.CENTER)
                
                local textView = TextView(activity)
                textView.setLayoutParams(
    LinearLayout.LayoutParams(
        LinearLayout.LayoutParams.MATCH_PARENT,
        LinearLayout.LayoutParams.WRAP_CONTENT
    )
)
                textView.setText(item)
                textView.setTextColor(WHITE)
                textView.setTextSize(TypedValue.COMPLEX_UNIT_SP, 16)
                textView.setPadding(dp(10), 0, 0, 0)
                
                local arrowView = TextView(activity)
                arrowView.setText("›")
                arrowView.setTextColor(WHITE)
                arrowView.setTextSize(TypedValue.COMPLEX_UNIT_SP, 20)
                
                itemLayout.addView(iconView)
                itemLayout.addView(textView)
                itemLayout.addView(arrowView)
                
                itemLayout.index = i
                
                itemLayout.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
                    onClick = function(v)
                        if v.index == 4 then
                            closeDialog()
                            gg.toast("Exiting...")
                            os.exit()
                        else
                            gg.toast("Selected: " .. items[v.index])
                            closeDialog()
                        end
                    end
                }))
                
                mainLayout.addView(itemLayout)
            end
            
            local cancelBtn = Button(activity)
            cancelBtn.setLayoutParams(LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, dp(45)))
            cancelBtn.setText("Cancel")
            cancelBtn.setTextColor(WHITE)
            cancelBtn.setBackground(getShapeBackground(GRAY, 15))
            cancelBtn.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
                onClick = function(v)
                    closeDialog()
                end
            }))
            mainLayout.addView(cancelBtn, LinearLayout.LayoutParams.MATCH_PARENT, dp(45))
            
            windowManager = activity.getSystemService(Context.WINDOW_SERVICE)
            dialogParams = WindowManager.LayoutParams(
                WindowManager.LayoutParams.WRAP_CONTENT,
                WindowManager.LayoutParams.WRAP_CONTENT,
                getLayoutType(),
                WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE,
                PixelFormat.TRANSLUCENT
            )
            dialogParams.gravity = Gravity.CENTER
            
            dialogWindow = mainLayout
            windowManager.addView(dialogWindow, dialogParams)
            isDialogShowing = true
        end
    }))
end

local menuItems = {
    "Three Button Dialog",
    "Simple Single Choice",
    "Single Choice with Buttons",
    "Radio Selection Dialog",
    "Multi Choice Dialog",
    "List Action Dialog",
  "Close Current Dialog",
    "Exit"
}

while true do
    if gg.isVisible(true) then
        gg.setVisible(false)
        
        local choice = gg.choice(menuItems, nil, "Dialog Examples - All Text Visible")
        
        if choice == nil then
        elseif choice == 1 then
            showThreeButtonDialog()
        elseif choice == 2 then
            showSingleChoiceSimpleDialog()
        elseif choice == 3 then
            showSingleChoiceWithButtonsDialog()
        elseif choice == 4 then
            showRadioSelectionDialog()
        elseif choice == 5 then
            showMultiChoiceDialog()
        elseif choice == 6 then
            showListActionDialog()
        elseif choice == 7 then
            
            closeDialog()
            gg.toast("Dialog closed")
        elseif choice == 8 then
            closeDialog()
            gg.toast("Exiting...")
            os.exit()
        end
    end
    
    gg.sleep(100)
end