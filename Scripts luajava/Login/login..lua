
if gg.loadLibsLuaJava() == nil then gg.alert(' unavaliable please use gameguardian by batman Games') else end


local opened = false

local test = [[

local ActivityThread = luajava.bindClass("android.app.ActivityThread")
local LinearLayout = luajava.bindClass("android.widget.LinearLayout")
local Button = luajava.bindClass("android.widget.Button")
local EditText = luajava.bindClass("android.widget.EditText")
local TextView = luajava.bindClass("android.widget.TextView")
local Color = luajava.bindClass("android.graphics.Color")
local Gravity = luajava.bindClass("android.view.Gravity")
local WindowManager = luajava.bindClass("android.view.WindowManager")
local LayoutParams = luajava.bindClass("android.view.WindowManager$LayoutParams")
local PixelFormat = luajava.bindClass("android.graphics.PixelFormat")
local InputType = luajava.bindClass("android.text.InputType")
local InputMethodManager = luajava.bindClass("android.view.inputmethod.InputMethodManager")
local Handler = luajava.bindClass("android.os.Handler")
local Looper = luajava.bindClass("android.os.Looper")
local Toast = luajava.bindClass("android.widget.Toast")

local context = ActivityThread.currentApplication()
if not context then
    return
end

local wm = context.getSystemService("window")
local imm = context.getSystemService("input_method")

local handler = Handler(Looper.getMainLooper())

local USER = "admin"
local PASS = "1234"

local layout = LinearLayout(context)
layout.setOrientation(1)
layout.setGravity(Gravity.CENTER)
layout.setBackgroundColor(Color.BLACK)
layout.setPadding(80, 80, 80, 80)

local function toast(msg)
    handler.post(
        luajava.createProxy("java.lang.Runnable", {
            run = function()
                Toast.makeText(context, msg, 0).show()
            end
        })
    )
end

local function showKeyboard(v)
    handler.post(
        luajava.createProxy("java.lang.Runnable", {
            run = function()
                v.setFocusable(true)
                v.setFocusableInTouchMode(true)
                v.requestFocus()
                imm.showSoftInput(v, InputMethodManager.SHOW_IMPLICIT)
            end
        })
    )
end

local function hideKeyboard(v)
    imm.hideSoftInputFromWindow(v.getWindowToken(), 0)
end

local title = TextView(context)
title.setText("LOGIN")
title.setTextColor(Color.WHITE)
title.setGravity(Gravity.CENTER)
layout.addView(title)

local userInput = EditText(context)
userInput.setHint("USER")
userInput.setTextColor(Color.WHITE)
userInput.setHintTextColor(Color.GRAY)
userInput.setSingleLine(true)
layout.addView(userInput)

local passInput = EditText(context)
passInput.setHint("PASS")
passInput.setTextColor(Color.WHITE)
passInput.setHintTextColor(Color.GRAY)
passInput.setSingleLine(true)
passInput.setInputType(InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_VARIATION_PASSWORD)
layout.addView(passInput)

local btn = Button(context)
btn.setText("LOGIN")

local function close()
    hideKeyboard(userInput)
    hideKeyboard(passInput)
    wm.removeView(layout)
end

userInput.setOnClickListener(
    luajava.createProxy("android.view.View$OnClickListener", {
        onClick = function(v)
            showKeyboard(userInput)
        end
    })
)

passInput.setOnClickListener(
    luajava.createProxy("android.view.View$OnClickListener", {
        onClick = function(v)
            showKeyboard(passInput)
        end
    })
)

btn.setOnClickListener(
    luajava.createProxy("android.view.View$OnClickListener", {
        onClick = function(v)

            local u = tostring(userInput.getText())
            local p = tostring(passInput.getText())

            if u == USER and p == PASS then
                toast("LOGIN OK")
                close()
            else
                toast("LOGIN ERRADO")
            end
        end
    })
)

layout.addView(btn)

local params = LayoutParams()
params.width = LayoutParams.MATCH_PARENT
params.height = LayoutParams.MATCH_PARENT
params.gravity = Gravity.CENTER
params.format = PixelFormat.RGBA_8888
params.type = LayoutParams.TYPE_APPLICATION_OVERLAY
params.flags = LayoutParams.FLAG_LAYOUT_IN_SCREEN

wm.addView(layout, params)

handler.post(
    luajava.createProxy("java.lang.Runnable", {
        run = function()
            userInput.setFocusable(true)
            userInput.setFocusableInTouchMode(true)
            userInput.requestFocus()
            imm.showSoftInput(userInput, InputMethodManager.SHOW_IMPLICIT)
        end
    })
)

]]

if not opened then
    opened = true
    gg.setVisible(false)
    gg.loadLibsLuaJava(test)
end