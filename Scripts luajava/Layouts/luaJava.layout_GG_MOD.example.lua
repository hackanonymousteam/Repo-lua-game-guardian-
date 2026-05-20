
if not activity then gg.alert("No activity") return end

if not luajava then gg.alert("No luajava") return end

if not ModLib then gg.alert("No ModLib") return end

local imports = {
    "android.*",
    "android.app.*",
    "android.content.*",
    "android.graphics.*",
    "android.graphics.drawable.*",
    "android.os.*",
    "android.view.*",
    "android.widget.*",
    "android.ext.*",
    "android.ext.Tools",
    "android.ext.MainService",
    "android.view.animation.*",
    "android.animation.ObjectAnimator",
    "java.io.File",
    "java.lang.*",
    "java.util.*",
    "luaj.lib.ModLib",
    "loadlayout"
}

for _, lib in ipairs(imports) do
    import(lib)
end

Gravity = luajava.bindClass("android.view.Gravity")
toast.setGravity(Gravity.BOTTOM)
toast.setMode(1)

local Colors = {
    primary = 0xFF8B0000,        -- Vermelho Sangue Escuro
    primaryDark = 0xFF1A0000,    -- Preto Avermelhado Profundo
    accent = 0xFFC41E3A,         -- Carmim Vibrante
    background = 0xFF0D0D0D,     -- Preto Noturno
    surface = 0xFF1A1A1A,        -- Cinza Gótico Escuro
    textPrimary = 0xFFD4C5B9,    -- Pergaminho Envelhecido
    textSecondary = 0xCC1A1A1A,  -- Bronze Antigo
    success = 0xFF2E0000,        -- Vinho Tinto Escuro
    error = 0xFFFF2400,          -- Escarlate Vívido
    warning = 0xFFB22222,        -- Tijolo de Fogo
    border = 0xFF3A0000,         -- Rubi Escurecido
}

ButtonAlert = function(button)
    gg.alert("This is a test alert dialog", "Got it")
end

On = function(button)
    On_Tips = Name .. " enabled successfully!"
    toast.success(On_Tips, 1500)
end

Off = function(button)
    Off_Tips = Name .. " disabled successfully!"
    toast.error(Off_Tips, 1500)
    gg.clearList()
    gg.clearResults()
end

local buttonStates = {}
local function Ui_Test(button)
    if buttonStates[button] == nil then
        buttonStates[button] = false
    end
    if buttonStates[button] == false then
        buttonStates[button] = true
        On(button)
    else
        buttonStates[button] = false
        Off(button)
    end
end

local HotPoint = luajava.bindClass("android.ext.HotPoint").getInstance()
gg.setVisible(false)

local context = activity
local window = context.getSystemService("window")
local mObjectAnimator, dObjectAnimator



local function zoom_animation(view)
    if not dObjectAnimator then
        dObjectAnimator = ObjectAnimator.ofFloat(view, "scaleX", 0.85, 1)
        dObjectAnimator.setDuration(350)
        dObjectAnimator.setInterpolator(OvershootInterpolator())
    end
end

local function zoom_startanimation()
    if dObjectAnimator then
        dObjectAnimator.start()
    end
end

local function sparkle_startanimation()
    if mObjectAnimator then
        mObjectAnimator.start()
    end
end

local function getLayoutParams()
    local LayoutParams = WindowManager.LayoutParams
    local layoutParams = luajava.new(LayoutParams)
    layoutParams.type = (Build.VERSION.SDK_INT >= 26) and LayoutParams.TYPE_APPLICATION_OVERLAY or LayoutParams.TYPE_PHONE
    layoutParams.format = PixelFormat.RGBA_8888
    layoutParams.flags = LayoutParams.FLAG_NOT_FOCUSABLE
    layoutParams.gravity = Gravity.TOP | Gravity.START
    layoutParams.width = LayoutParams.WRAP_CONTENT
    layoutParams.height = LayoutParams.WRAP_CONTENT
    return layoutParams
end

local function getShapeBackground(color, radius, strokeColor, strokeWidth)
    local drawable = luajava.new(GradientDrawable)
    drawable.setShape(GradientDrawable.RECTANGLE)
    drawable.setColor(color)
    drawable.setCornerRadius(radius)
    if strokeColor and strokeWidth then
        drawable.setStroke(strokeWidth, strokeColor)
    end
    return drawable
end

local function getGradientBackground(colors, radius)
    local drawable = luajava.new(GradientDrawable)
    drawable.setShape(GradientDrawable.RECTANGLE)
  
    drawable.setGradientType(GradientDrawable.LINEAR_GRADIENT)
    drawable.setOrientation(GradientDrawable.Orientation.TL_BR)
    drawable.setCornerRadius(radius)
    return drawable
end

local function iOSwitch(isChecked)
    local trackColor = isChecked and Colors.success or Colors.border
    local radius = 14
    local thumbRadius = 11
    local width = 50
    local height = 26
    local trackDrawable = luajava.new(GradientDrawable)
    trackDrawable.setShape(GradientDrawable.RECTANGLE)
    trackDrawable.setColor(trackColor)
    trackDrawable.setCornerRadius(radius)
    trackDrawable.setSize(width, height)
    local thumbDrawable = luajava.new(GradientDrawable)
    thumbDrawable.setShape(GradientDrawable.OVAL)
    thumbDrawable.setColor(0xFFFFFFFF)
    thumbDrawable.setSize(thumbRadius * 2, thumbRadius * 2)
    return trackDrawable, thumbDrawable
end

function updateiOSwitch(switchView, isChecked)
    local trackDrawable, thumbDrawable = iOSwitch(isChecked)
    switchView.setTrackDrawable(trackDrawable)
    switchView.setThumbDrawable(thumbDrawable)
end

local log = function(text, color)
    local tmp = loadlayout {
        TextView,
        text = os.date("%H:%M:%S") .. " " .. text,
        textSize = '11sp',
        textColor = color or Colors.textSecondary,
        gravity = "center_vertical",
        layout_width = "match_parent",
        layout_height = "wrap_content",
        padding = "6dp",
        layout_marginTop = "2dp",
        layout_marginBottom = "2dp",
        background = getShapeBackground(0xFFF1F5F9, 8),
    }
    Runlog_list.addView(tmp, 0)
    Runlog.fullScroll(View.FOCUS_DOWN)
end

function ExitText(id, defaultText, labelText)
    return {
        LinearLayout;
        layout_marginStart = "12dp";
        layout_marginEnd = "12dp";
        layout_marginTop = "6dp";
        layout_marginBottom = "6dp";
        layout_height = "wrap_content";
        orientation = "vertical";
        layout_width = "match_parent";
        {
            TextView;
            text = labelText;
            textColor = Colors.textPrimary;
            textSize = "12sp";
            layout_marginBottom = "4dp";
        };
        {
            LinearLayout;
            layout_height = "44dp";
            orientation = "horizontal";
            layout_width = "match_parent";
            background = getShapeBackground(Colors.surface, 10, Colors.border, 1);
            {
                EditText;
                id = id;
                text = defaultText;
                textColor = Colors.textPrimary;
                hintTextColor = Colors.textSecondary;
                layout_width = "match_parent";
                layout_height = "match_parent";
                inputType = "text";
                imeOptions = "actionDone";
                padding = "10dp";
                background = getShapeBackground(0x00000000, 0);
            };
        };
    }
end

local function ButtonLayout(id, text, color)
    return {
        LinearLayout;
        layout_width = "match_parent";
        layout_height = "46dp";
        layout_marginStart = "12dp";
        layout_marginEnd = "12dp";
        layout_marginTop = "5dp";
        layout_marginBottom = "5dp";
        background = getShapeBackground(color or Colors.primary, 10);
        {
            TextView;
            layout_width = "match_parent";
            layout_height = "match_parent";
            id = id;
            text = text;
            textColor = 0xFFFFFFFF;
            textSize = "13sp";
            gravity = "center";
        };
    }
end

page1 = {
    LinearLayout;
    layout_width = "fill";
    layout_height = "fill";
    {
        LinearLayout;
        layout_height = "match_parent";
        layout_margin = "6dp";
        layout_width = "match_parent";
        {
            ScrollView;
            layout_height = "match_parent";
            layout_width = "match_parent";
            VerticalScrollBarEnabled = true;
            {
                LinearLayout;
                background = getShapeBackground(Colors.surface, 14);
                layout_height = "wrap_content";
                layout_width = "match_parent";
                orientation = "vertical";
                id = "FuncLayout";
                padding = "6dp";
            };
        };
    };
}

page2 = {
    LinearLayout;
    layout_height = "fill";
    orientation = "vertical";
    layout_width = "fill";
    {
        LinearLayout;
        layout_margin = "6dp";
        layout_height = "fill";
        orientation = "vertical";
        background = getShapeBackground(Colors.surface, 14);
        layout_width = "fill";
        padding = "10dp";
        {
            TextView;
            text = "Teleport Function";
            textColor = Colors.textPrimary;
            textSize = "16sp";
            layout_marginBottom = "6dp";
        };
        {
            TextView;
            text = "Get coordinate data first\nCustom modify character coordinates";
            textColor = Colors.textSecondary;
            textSize = "11sp";
            layout_marginBottom = "12dp";
        };
        ExitText("Zb_Xy", "0", "Enter X Coordinate");
        ExitText("Zb_Yx", "0", "Enter Y Coordinate");
        {
            TextView;
            text = "Get Coordinates";
            id = "Get_Zb_Data";
            background = getShapeBackground(Colors.accent, 10);
            layout_width = "match_parent";
            layout_marginTop = "6dp";
            layout_marginStart = "12dp";
            layout_marginEnd = "12dp";
            layout_height = "44dp";
            gravity = "center";
            textColor = 0xFFFFFFFF;
            textSize = "13sp";
        };
        {
            TextView;
            text = "Apply Teleport";
            id = "Hack_Zb_Data";
            background = getShapeBackground(Colors.primary, 10);
            layout_width = "match_parent";
            layout_marginTop = "6dp";
            layout_marginStart = "12dp";
            layout_marginEnd = "12dp";
            layout_height = "44dp";
            gravity = "center";
            textColor = 0xFFFFFFFF;
            textSize = "13sp";
        };
    };
}

page3 = {
    LinearLayout;
    layout_width = "fill";
    layout_height = "fill";
    {
        LinearLayout;
        layout_width = "match_parent";
        layout_height = "match_parent";
        layout_margin = "6dp";
        {
            ScrollView;
            layout_width = "match_parent";
            layout_height = "match_parent";
            VerticalScrollBarEnabled = false;
            {
                LinearLayout;
                layout_width = "match_parent";
                layout_height = "wrap_content";
                orientation = "vertical";
                background = getShapeBackground(Colors.surface, 14);
                padding = "6dp";
                ButtonLayout("Page_Button_1", "Button Example 1", Colors.primary),
                ButtonLayout("Page_Button_2", "Button Example 2", Colors.primary),
                ButtonLayout("Page_Button_3", "Button Example 3", Colors.primary),
                ButtonLayout("Page_Button_4", "Button Example 4", Colors.primary),
                ButtonLayout("Page_Button_5", "Button Example 5", Colors.primary),
            };
        };
    };
}

page4 = {
    LinearLayout;
    layout_width = "fill";
    layout_height = "fill";
    {
        LinearLayout;
        layout_height = "match_parent";
        layout_margin = "6dp";
        layout_width = "match_parent";
        {
            ScrollView;
            layout_height = "match_parent";
            layout_width = "match_parent";
            VerticalScrollBarEnabled = false;
            id = "Runlog";
            background = getShapeBackground(Colors.surface, 14);
            {
                LinearLayout;
                layout_margin = "6dp";
                layout_height = "wrap_content";
                layout_width = "match_parent";
                id = "Runlog_list";
                orientation = "vertical";
            };
        };
    };
}

page5 = {
    LinearLayout;
    layout_width = "fill";
    layout_height = "fill";
    {
        LinearLayout;
        layout_height = "match_parent";
        layout_margin = "6dp";
        layout_width = "match_parent";
        orientation = "vertical";
        {
            ScrollView;
            layout_height = "wrap_content";
            layout_width = "match_parent";
            VerticalScrollBarEnabled = true;
            background = getShapeBackground(Colors.surface, 14);
            {
                LinearLayout;
                layout_height = "wrap_content";
                orientation = "vertical";
                layout_width = "match_parent";
                padding = "14dp";
                {
                    TextView;
                    text = "About";
                    textColor = Colors.textPrimary;
                    textSize = "18sp";
                    layout_marginBottom = "12dp";
                };
                {
                    LinearLayout;
                    layout_height = "wrap_content";
                    orientation = "vertical";
                    layout_width = "match_parent";
                    {
                        TextView;
                        text = "UI MODIFIED";
                        textColor = Colors.primary;
                        textSize = "15sp";
                    };
                    {
                        TextView;
                        text = "BY @batmangamesS";
                        textColor = Colors.textSecondary;
                        textSize = "13sp";
                        layout_marginTop = "4dp";
                    };
                    {
                        TextView;
                        text = "2026";
                        textColor = Colors.textSecondary;
                        textSize = "11sp";
                        layout_marginTop = "6dp";
                    };
                };
            };
        };
    };
}

xfc = {
    LinearLayout;
    layout_height = "fill";
    orientation = "vertical";
    id = "touch";
    layout_width = "fill";
    {
        LinearLayout;
        layout_height = "300dp";
        background = getGradientBackground({0xFFFFFFFF, 0xFFF8FAFC}, 20);
        orientation = "horizontal";
        id = "ooo";
        layout_width = "340dp";
        {
            LinearLayout;
            layout_height = "match_parent";
            orientation = "vertical";
            layout_width = "75dp";
            background = getShapeBackground(Colors.primary, 0);
            gravity = "center_horizontal";
            padding = "6dp";
            {
                LinearLayout;
                layout_width = "50dp";
                layout_height = "50dp";
                layout_marginTop = "12dp";
                layout_marginBottom = "6dp";
                gravity = "center";
                background = getShapeBackground(0xFFFFFFFF, 25);
                {
                    ImageView;
                    layout_width = "42dp";
                    layout_height = "42dp";
                    id = "control";
                    scaleType = "fitCenter";
                };
            };
            {
                TextView;
                layout_width = "wrap_content";
                layout_height = "wrap_content";
                text = "Batman";
                textSize = "10sp";
                id = "UserName";
                textColor = Colors.primary;
                gravity = "center";
                layout_marginBottom = "10dp";
            };
            {
                ScrollView;
                layout_width = "match_parent";
                VerticalScrollBarEnabled = false;
                layout_height = "match_parent";
                {
                    LinearLayout;
                    layout_height = "wrap_content";
                    orientation = "vertical";
                    layout_width = "match_parent";
                    {
                        LinearLayout;
                        layout_width = "match_parent";
                        layout_marginTop = "3dp";
                        layout_marginBottom = "3dp";
                        layout_height = "30dp";
                        background = getShapeBackground(0xFFE8EAF6, 14);
                        gravity = "center";
                        {
                            TextView;
                            layout_width = "match_parent";
                            layout_height = "match_parent";
                            id = "Page_Switch";
                            text = "Switches";
                            textSize = "10sp";
                            textColor = Colors.primary;
                            gravity = "center";
                        };
                    };
                    {
                        LinearLayout;
                        layout_width = "match_parent";
                        layout_marginTop = "3dp";
                        layout_marginBottom = "3dp";
                        layout_height = "30dp";
                        gravity = "center";
                        {
                            TextView;
                            layout_width = "match_parent";
                            layout_height = "match_parent";
                            id = "Page_EditText";
                            text = "Input";
                            textSize = "10sp";
                            textColor = Colors.textSecondary;
                            gravity = "center";
                        };
                    };
                    {
                        LinearLayout;
                        layout_width = "match_parent";
                        layout_marginTop = "3dp";
                        layout_marginBottom = "3dp";
                        layout_height = "30dp";
                        gravity = "center";
                        {
                            TextView;
                            layout_width = "match_parent";
                            layout_height = "match_parent";
                            id = "Page_Button";
                            text = "Buttons";
                            textSize = "10sp";
                            textColor = Colors.textSecondary;
                            gravity = "center";
                        };
                    };
                    {
                        LinearLayout;
                        layout_width = "match_parent";
                        layout_marginTop = "3dp";
                        layout_marginBottom = "3dp";
                        layout_height = "30dp";
                        gravity = "center";
                        {
                            TextView;
                            layout_width = "match_parent";
                            layout_height = "match_parent";
                            id = "Page_Runlog";
                            text = "Logs";
                            textSize = "10sp";
                            textColor = Colors.textSecondary;
                            gravity = "center";
                        };
                    };
                    {
                        LinearLayout;
                        layout_width = "match_parent";
                        layout_marginTop = "3dp";
                        layout_marginBottom = "3dp";
                        layout_height = "30dp";
                        gravity = "center";
                        {
                            TextView;
                            layout_width = "match_parent";
                            layout_height = "match_parent";
                            id = "Page_About";
                            text = "About";
                            textSize = "10sp";
                            textColor = Colors.textSecondary;
                            gravity = "center";
                        };
                    };
                    {
                        LinearLayout;
                        layout_width = "match_parent";
                        layout_marginTop = "10dp";
                        layout_marginBottom = "6dp";
                        layout_height = "32dp";
                        visibility= "gone";
                        background = getShapeBackground(Colors.error, 16);
                        gravity = "center";
                        id = "Exit_Button";
                        {
                            TextView;
                            layout_width = "wrap_content";
                            layout_height = "wrap_content";
                            text = "Exit";
                            textColor = 0xFFFFFFFF;
                            
                            textSize = "11sp";
                        };
                    };
                    {
                        LinearLayout;
                        layout_width = "match_parent";
                        layout_marginTop = "3dp";
                        layout_marginBottom = "6dp";
                        layout_height = "32dp";
                        background = getShapeBackground(Colors.warning, 16);
                        gravity = "center";
                        id = "Minimize_Button";
                        {
                            TextView;
                            layout_width = "wrap_content";
                            layout_height = "wrap_content";
                            text = "Exit";
                            textColor = 0xFFFFFFFF;
                            textSize = "11sp";
                        };
                    };
                };
            };
        };
        {
            LinearLayout;
            layout_height = "match_parent";
            orientation = "vertical";
background = getShapeBackground(Colors.warning, 16);
                   
            layout_width = "match_parent";
            {
                LinearLayout;
                layout_height = "40dp";
                orientation = "horizontal";
                layout_width = "match_parent";
                {
                    RelativeLayout;
                    layout_width = "match_parent";
                    layout_height = "match_parent";
                    {
                        TextView;
                        layout_width = "match_parent";
                        layout_height = "match_parent";
                        id = "center_Title";
                        text = "Floating UI";
                        textColor = Colors.textPrimary;
                        textSize = "15sp";
                        gravity = "center";
                    };
                    {
                        TextView;
                        layout_width = "wrap_content";
                        layout_height = "match_parent";
                        visibility = "gone";
                        id = "right_Title";
                        background = getShapeBackground(Colors.warning, 16);
                   
                        text = "Mod 1.70";
                        textColor = Colors.primary;
                        textSize = "11sp";
                        gravity = "center|right";
                        layout_marginEnd = "10dp";
                    };
                };
            };
            {
                LinearLayout;
                layout_height = "match_parent";
                layout_width = "match_parent";
                {
                    PageView;
                    layout_width = "match_parent";
                    id = "page_main";
                    layout_height = "match_parent";
                    pages = {
                        page1,
                        page2,
                        page3,
                        page4,
                        page5,
                    };
                };
            };
        };
    };
}

xfq = {
    LinearLayout;
    layout_height = "fill";
    layout_width = "fill";
    {
        LinearLayout;
        layout_width = "52dp";
        layout_height = "52dp";
        background = getShapeBackground(Colors.primary, 26);
        {
            ImageView;
            layout_width = "match_parent";
            layout_margin = "6dp";
            layout_height = "match_parent";
            id = "suspended_ball";
            scaleType = "fitCenter";
        };
    };
}

mainLayoutParams = getLayoutParams()

Logo = loadbitmap("https://icons.iconarchive.com/icons/icons8/windows-8/128/Cinema-Batman-Old-icon.png")
Author1 = loadbitmap("https://icons.iconarchive.com/icons/icons8/windows-8/128/Cinema-Batman-Old-icon.png")
Author2 = loadbitmap("https://icons.iconarchive.com/icons/icons8/windows-8/128/Cinema-Batman-Old-icon.png")

invoke = function()
    xfq = loadlayout(xfq)
    xfc = loadlayout(xfc)
    suspended_ball.setImageBitmap(Author1)
    control.setImageBitmap(Author1)

    local isMinimized = false
    Minimize_Button.onClick = function()
        if isMinimized then
            window.removeView(xfq)
            zoom_animation(ooo)
            zoom_startanimation()
            state.isFocusable = true
            window.addView(xfc, mainLayoutParams)
            refreshState()
            isMinimized = false
            Minimize_Button.TextView.setText("Minimize")
        else
            window.removeView(xfc)
          
            state.isFocusable = false
            window.addView(xfq, mainLayoutParams)
            refreshState()
            isMinimized = true
            Minimize_Button.TextView.setText("Expand")
        end
    end

    Exit_Button.onClick = function()
        local dialog = AlertDialog.Builder(activity)
        dialog.setTitle("Exit")
        dialog.setMessage("Are you sure you want to exit?")
        dialog.setPositiveButton("Yes", {
            onClick = function()
                window.removeView(xfc)
                window.removeView(xfq)
                Lock.unUi()
                os.exit()
            end
        })
        dialog.setNegativeButton("No", nil)
        dialog.show()
    end

    local function Ret_Zb_Data(element, callback)
        element.onClick = function(v)
            local ZbX = Zb_Xy.getText().toString()
            local ZbY = Zb_Yx.getText().toString()
            log('X Coordinate: ' .. ZbX .. ' acquired', Colors.success)
            log('Y Coordinate: ' .. ZbY .. ' acquired', Colors.success)
            log('Get Coordinates clicked', Colors.accent)
            local runnable = {
                run = function()
                    pcall(callback, value)
                end,
            }
            rx.b(runnable)
        end
    end
    Ret_Zb_Data(Get_Zb_Data, ButtonAlert)

    local function Set_Zb_Data(element, callback)
        element.onClick = function(v)
            local ZbX = Zb_Xy.getText().toString()
            local ZbY = Zb_Yx.getText().toString()
            log('X coordinate modified to ' .. ZbX, Colors.warning)
            log('Y coordinate modified to ' .. ZbY, Colors.warning)
            log('Apply Teleport clicked', Colors.accent)
            local runnable = {
                run = function()
                    pcall(callback, value)
                end,
            }
            rx.b(runnable)
        end
    end
    Set_Zb_Data(Hack_Zb_Data, ButtonAlert)

    local state = { isFocusable = false }
    local mainLayoutParams = getLayoutParams()
    local function refreshState()
        mainLayoutParams.flags = state.isFocusable and WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL or WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE
        window.updateViewLayout(xfq, mainLayoutParams)
        window.updateViewLayout(xfc, mainLayoutParams)
    end

    local function onControlClick(v)
        toast.hint("Floating window hidden")
        window.removeView(xfc)
      
        state.isFocusable = false
        window.addView(xfq, mainLayoutParams)
        refreshState()
        isMinimized = true
        Minimize_Button.TextView.setText("Expand")
    end

    local function onControlLongClick(v)
        toast.error("Exiting...", 1500)
        HotPoint.d()
        window.removeView(xfc)
        window.removeView(xfq)
        Lock.unUi()
        os.exit()
    end

    suspended_ball.onTouch = function(v, event)
        local action = event.getAction()
        if action == MotionEvent.ACTION_DOWN then
            isMove = false
            RawX = event.getRawX()
            RawY = event.getRawY()
            x = mainLayoutParams.x
            y = mainLayoutParams.y
        elseif action == MotionEvent.ACTION_MOVE then
            isMove = true
            mainLayoutParams.x = x + (event.getRawX() - RawX)
            mainLayoutParams.y = y + (event.getRawY() - RawY)
            window.updateViewLayout(xfq, mainLayoutParams)
        end
    end

    touch.onTouch = function(v, event)
        local action = event.getAction()
        if action == MotionEvent.ACTION_DOWN then
            isMove = false
            RawX = event.getRawX()
            RawY = event.getRawY()
            x = mainLayoutParams.x
            y = mainLayoutParams.y
        elseif action == MotionEvent.ACTION_MOVE then
            isMove = true
            mainLayoutParams.x = x + (event.getRawX() - RawX)
            mainLayoutParams.y = y + (event.getRawY() - RawY)
            window.updateViewLayout(xfc, mainLayoutParams)
        end
    end

    suspended_ball.onClick = function(v)
        window.removeView(xfq)
        zoom_animation(ooo)
        zoom_startanimation()
        state.isFocusable = true
        window.addView(xfc, mainLayoutParams)
        refreshState()
        isMinimized = false
        Minimize_Button.TextView.setText("Minimize")
    end

    control.onClick = onControlClick
    control.onLongClick = onControlLongClick

    local function page_onClick(page, index)
        page.onClick = function()
            page_main.showPage(index)
        end
    end

    local pages = {
        Page_Switch,
        Page_EditText,
        Page_Button,
        Page_Runlog,
        Page_About,
    }
    for i, page in ipairs(pages) do
        page_onClick(page, i - 1)
    end

    local isProcessing = false
    local function setButtonClickEvent(button, eventFunction)
        button.onClick = function()
            Name = button.text
            if isProcessing then return end
            isProcessing = true
            log(button.text .. ' clicked', Colors.accent)
            local runnable = {
                run = function()
                    pcall(eventFunction, button)
                    isProcessing = false
                end,
            }
            rx.b(runnable)
        end
    end

    local buttons = {
        Page_Button_1,
        Page_Button_2,
        Page_Button_3,
        Page_Button_4,
        Page_Button_5,
    }
    for _, button in ipairs(buttons) do
        setButtonClickEvent(button, Ui_Test)
    end

    local function setBackgroundForPages(selectedIndex)
        for i, page in ipairs(pages) do
            local color = (i - 1 == selectedIndex) and 0xFFE8EAF6 or 0x00000000
            page.setBackgroundDrawable(getShapeBackground(color, 14))
        end
    end

    page_main.setOnPageChangeListener(PageView.OnPageChangeListener{
        onPageSelected = function(v)
            setBackgroundForPages(v)
        end
    })

  

    local tabs = {
        [1] = {
            text = "Function Example 1",
            open = function(self)
                Name = self.text
                local runnable = {
                    run = function()
                        pcall(On, self.value)
                    end,
                }
                rx.b(runnable)
            end,
            close = function(self)
                Name = self.text
                local runnable = {
                    run = function()
                        pcall(Off, self.value)
                    end,
                }
                rx.b(runnable)
            end,
        },
        [2] = {
            text = "Function Example 2",
            open = function(self)
                Name = self.text
                local runnable = {
                    run = function()
                        pcall(On, self.value)
                    end,
                }
                rx.b(runnable)
            end,
            close = function(self)
                Name = self.text
                local runnable = {
                    run = function()
                        pcall(Off, self.value)
                    end,
                }
                rx.b(runnable)
            end,
        },
        [3] = {
            text = "Function Example 3",
            open = function(self)
                Name = self.text
                local runnable = {
                    run = function()
                        pcall(On, self.value)
                    end,
                }
                rx.b(runnable)
            end,
            close = function(self)
                Name = self.text
                local runnable = {
                    run = function()
                        pcall(Off, self.value)
                    end,
                }
                rx.b(runnable)
            end,
        },
        [4] = {
            text = "Function Example 4",
            open = function(self)
                Name = self.text
                local runnable = {
                    run = function()
                        pcall(On, self.value)
                    end,
                }
                rx.b(runnable)
            end,
            close = function(self)
                Name = self.text
                local runnable = {
                    run = function()
                        pcall(Off, self.value)
                    end,
                }
                rx.b(runnable)
            end,
        },
        [5] = {
            text = "Function Example 5",
            open = function(self)
                Name = self.text
                local runnable = {
                    run = function()
                        pcall(On, self.value)
                    end,
                }
                rx.b(runnable)
            end,
            close = function(self)
                Name = self.text
                local runnable = {
                    run = function()
                        pcall(Off, self.value)
                    end,
                }
                rx.b(runnable)
            end,
        },
    }

    function setUi(arr, func)
        if type(arr) ~= 'table' then
            return error('Parameter must be a table')
        end

        local colorValues = {
            text = function(i)
                return string.format('Function Example %d', i)
            end,
            textColor = Colors.textPrimary,
        }
        for i = 1, #arr do
            local value = arr[i]
            for key, colorDefault in pairs(colorValues) do
                if not value[key] then
                    value[key] = type(colorDefault) == "function" and colorDefault(i) or colorDefault
                end
            end

            local isChecked = false
            local trackDrawable, thumbDrawable = iOSwitch(isChecked)
            local fun = {
                LinearLayout;
                orientation = "horizontal";
                layout_width = "match_parent";
                layout_height = "wrap_content";
                padding = "10dp";
                background = getShapeBackground(Colors.surface, 10);
                layout_marginTop = "3dp";
                layout_marginBottom = "3dp";
                {
                    TextView;
                    id = "TabText";
                    text = value.text;
                    textColor = value.textColor;
                    layout_width = "0dp";
                    layout_weight = 1;
                    layout_gravity = "center_vertical";
                    textSize = "12sp";
                };
                {
                    Switch;
                    id = "switch_" .. i;
                    layout_width = "wrap_content";
                    layout_height = "wrap_content";
                    checked = isChecked;
                    trackDrawable = trackDrawable;
                    thumbDrawable = thumbDrawable;
                    onCheckedChangeListener = function(view, isChecked)
                        local mode = isChecked and "open" or "close"
                        local func = value[mode]
                        runnable = {
                            run = function()
                                pcall(func, value)
                            end,
                        }
                        updateiOSwitch(view, isChecked)
                        log(value.text .. ' ' .. (isChecked and 'enabled' or 'disabled'), isChecked and Colors.success or Colors.error)
                        rx.b(runnable)
                    end;
                };
            }
            fun = loadlayout(fun)
            func.addView(fun)
        end
    end
    setUi(tabs, FuncLayout)
    window.addView(xfq, mainLayoutParams)
end

Lock.Ui(invoke)