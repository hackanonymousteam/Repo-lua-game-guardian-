gg.setVisible(true)

local Color = luajava.bindClass("android.graphics.Color")
local Context = luajava.bindClass("android.content.Context")
local Typeface = luajava.bindClass("android.graphics.Typeface")
local GradientDrawable = luajava.bindClass("android.graphics.drawable.GradientDrawable")
local Build = luajava.bindClass("android.os.Build")
local Handler = luajava.bindClass("android.os.Handler")
local Looper = luajava.bindClass("android.os.Looper")
local TypedValue = luajava.bindClass("android.util.TypedValue")
local Gravity = luajava.bindClass("android.view.Gravity")
local MotionEvent = luajava.bindClass("android.view.MotionEvent")
local View = luajava.bindClass("android.view.View")
local WindowManager = luajava.bindClass("android.view.WindowManager")
local LayoutParams = luajava.bindClass("android.view.WindowManager$LayoutParams")
local LinearLayout = luajava.bindClass("android.widget.LinearLayout")
local LinLayoutParams = luajava.bindClass("android.widget.LinearLayout$LayoutParams")
local TextView = luajava.bindClass("android.widget.TextView")
local EditText = luajava.bindClass("android.widget.EditText")
local Button = luajava.bindClass("android.widget.Button")
local CheckBox = luajava.bindClass("android.widget.CheckBox")
local ScrollView = luajava.bindClass("android.widget.ScrollView")
local FrameLayout = luajava.bindClass("android.widget.FrameLayout")
local Runnable = luajava.bindClass("java.lang.Runnable")
local InputMethodManager = luajava.bindClass("android.view.inputmethod.InputMethodManager")
local ClipboardManager = luajava.bindClass("android.content.ClipboardManager")
local ClipData = luajava.bindClass("android.content.ClipData")
local ObjectAnimator = luajava.bindClass("android.animation.ObjectAnimator")
local AnimatorSet = luajava.bindClass("android.animation.AnimatorSet")
local AccelerateDecelerateInterpolator = luajava.bindClass("android.view.animation.AccelerateDecelerateInterpolator")

local mainHandler = Handler(Looper.getMainLooper())

local KEYS_FILE = "/sdcard/_Keys.json"
local JSON_PATH = "/sdcard/json.lua"

local function ensureJson()
    local f = io.open(JSON_PATH, "r")
    if not f then
        local req = gg.makeRequest("https://raw.githubusercontent.com/rxi/json.lua/master/json.lua")
        if req and req.content then
            local out = io.open(JSON_PATH, "w")
            out:write(req.content)
            out:close()
        end
    else
        f:close()
    end
end
ensureJson()
local json = loadfile(JSON_PATH)()

local UI = {
    BG = Color.parseColor("#0d061f"),
    CARD = Color.parseColor("#1a0f30"),
    ACCENT = Color.parseColor("#a42cff"),
    ACCENT_PINK = Color.parseColor("#ff33cc"),
    TEXT = Color.parseColor("#d1baff"),
    DANGER = Color.parseColor("#ff4444"),
    SUCCESS = Color.parseColor("#6aff6a"),
    BTN_DARK = Color.parseColor("#2e1c50"),
    BTN_LIGHT = Color.parseColor("#3d2666"),
    WHITE = Color.parseColor("#FFFFFF"),
    BLACK = Color.parseColor("#000000"),
    RADIUS = 25
}

local WIDTH = 300
local exit = false
local menuView = nil
local activeView = nil
local windowManager = nil
local mParams = nil
local pendingScript = nil

local keyInput, generatedKeyInput
local lengthInput, expirationInput
local uppercaseCheck, lowercaseCheck, numbersCheck, symbolsCheck

local function dp(v)
    return math.floor(TypedValue.applyDimension(1, v, activity.getResources().getDisplayMetrics()))
end

local function getSkin(color, radius, strokeWidth, strokeColor)
    local draw = GradientDrawable()
    draw.setColor(color)
    draw.setCornerRadius(dp(radius))
    if strokeColor then 
        draw.setStroke(dp(strokeWidth or 1), strokeColor) 
    end
    return draw
end

local function saveKeys(keys)
    local file = io.open(KEYS_FILE, "w")
    if file then
        file:write(json.encode(keys))
        file:close()
    end
end

local function loadKeys()
    local file = io.open(KEYS_FILE, "r")
    if file then
        local content = file:read("*all")
        file:close()
        if content and content ~= "" then
            local success, data = pcall(json.decode, content)
            if success then return data end
        end
    end
    return {}
end

local function forceShowKeyboard(inputField)
    if inputField then
        inputField.requestFocus()
        inputField.post(Runnable({
            run = function()
                local imm = activity.getSystemService(Context.INPUT_METHOD_SERVICE)
                imm.showSoftInput(inputField, InputMethodManager.SHOW_FORCED)
            end
        }))
    end
end

local function pasteFromClipboard(inputField)
    pcall(function()
        local clipboard = activity.getSystemService(Context.CLIPBOARD_SERVICE)
        local clip = clipboard.getPrimaryClip()
        if clip and clip.getItemCount() > 0 then
            local pastedText = clip.getItemAt(0).getText()
            if pastedText and inputField then
                inputField.setText(pastedText)
                inputField.setSelection(#pastedText)
                gg.toast("Pasted")
                forceShowKeyboard(inputField)
            end
        else
            gg.toast("Clipboard empty")
        end
    end)
end

local function copyToClipboard(text)
    if text and text ~= "" then
        local clipboard = activity.getSystemService(Context.CLIPBOARD_SERVICE)
        local clip = ClipData.newPlainText("key", text)
        clipboard.setPrimaryClip(clip)
        gg.toast("Copied")
    end
end

local function animateViewIn(view)
    if not view then return end
    pcall(function()
        local scaleX = ObjectAnimator.ofFloat(view, "scaleX", {0.7, 1.05, 1.0})
        local scaleY = ObjectAnimator.ofFloat(view, "scaleY", {0.7, 1.05, 1.0})
        local alpha = ObjectAnimator.ofFloat(view, "alpha", {0.0, 1.0})
        scaleX.setDuration(300)
        scaleY.setDuration(300)
        alpha.setDuration(300)
        local set = AnimatorSet()
        set.playTogether({scaleX, scaleY, alpha})
        set.setInterpolator(AccelerateDecelerateInterpolator())
        set.start()
    end)
end

local function generateRandomKey(length, useUpper, useLower, useNumbers, useSymbols)
    local chars = ""
    if useUpper then chars = chars .. "ABCDEFGHIJKLMNOPQRSTUVWXYZ" end
    if useLower then chars = chars .. "abcdefghijklmnopqrstuvwxyz" end
    if useNumbers then chars = chars .. "0123456789" end
    if useSymbols then chars = chars .. "!@#$%^&*" end
    
    if chars == "" then return nil end
    
    local key = ""
    for i = 1, length do
        local rand = math.random(1, #chars)
        key = key .. chars:sub(rand, rand)
    end
    return key
end

local function generateAndSaveKey()
    local length = tonumber(lengthInput.getText().toString()) or 12
    length = math.max(8, math.min(64, length))
    
    local useUpper = uppercaseCheck.isChecked()
    local useLower = lowercaseCheck.isChecked()
    local useNumbers = numbersCheck.isChecked()
    local useSymbols = symbolsCheck.isChecked()
    
    if not (useUpper or useLower or useNumbers or useSymbols) then
        gg.toast("Select at least one type")
        return
    end
    
    local key = generateRandomKey(length, useUpper, useLower, useNumbers, useSymbols)
    if not key then
        gg.toast("Error generating key")
        return
    end
    
    local days = tonumber(expirationInput.getText().toString()) or 30
    local expirationTime = os.time() + (days * 86400)
    
    local keys = loadKeys()
    table.insert(keys, {
        key = key,
        expiration = expirationTime
    })
    saveKeys(keys)
    
    generatedKeyInput.setText(key)
    gg.toast("Key generated")
end

local function loginWithKey()
    local inputKey = keyInput.getText().toString()
    if inputKey == "" then
        gg.toast("Enter a key")
        return
    end
    
    local keys = loadKeys()
    local now = os.time()
    
    for _, keyData in ipairs(keys) do
        if keyData.key == inputKey then
            if keyData.expiration > now then
                gg.toast("Login successful")
                pendingScript = [[
                    gg.alert("Access Granted\n\nWelcome")
                ]]
                forceClose()
                return
            else
                gg.toast("Key expired")
                return
            end
        end
    end
    
    gg.toast("Invalid key")
end

function createMenuView()
    local root = FrameLayout(activity)
    root.setLayoutParams(FrameLayout.LayoutParams(dp(WIDTH), -2))
    root.setFocusable(true)
    root.setFocusableInTouchMode(true)
    
    local scroll = ScrollView(activity)
    scroll.setLayoutParams(FrameLayout.LayoutParams(-1, dp(480)))
    
    local main = LinearLayout(activity)
    main.setOrientation(1)
    main.setBackground(getSkin(UI.BG, UI.RADIUS, 2, UI.ACCENT))
    main.setPadding(dp(16), dp(14), dp(16), dp(14))
    
    local header = LinearLayout(activity)
    header.setOrientation(0)
    header.setGravity(Gravity.CENTER_VERTICAL)
    header.setPadding(0, 0, 0, dp(10))
    
    local title = TextView(activity)
    title.setText("KEY SYSTEM")
    title.setTextColor(UI.ACCENT)
    title.setTextSize(1, 18)
    title.setTypeface(Typeface.create("sans-serif-black", Typeface.BOLD))
    title.setLayoutParams(LinLayoutParams(0, -2, 1.0))
    header.addView(title)
    
    local closeBtn = TextView(activity)
    closeBtn.setText("X")
    closeBtn.setTextSize(1, 18)
    closeBtn.setTextColor(UI.TEXT)
    closeBtn.setBackground(getSkin(UI.BTN_DARK, 10))
    closeBtn.setPadding(dp(10), dp(2), dp(10), dp(2))
    closeBtn.setFocusable(true)
    closeBtn.setClickable(true)
    closeBtn.setOnClickListener(View.OnClickListener({ onClick = function() forceClose() end }))
    header.addView(closeBtn)
    main.addView(header)
    
    local sx, sy, lx, ly
    header.setOnTouchListener(View.OnTouchListener{
        onTouch = function(v, ev)
            if ev.getAction() == 0 then
                sx, sy = ev.getRawX(), ev.getRawY()
                lx, ly = mParams.x, mParams.y
                return true
            elseif ev.getAction() == 2 then
                mParams.x = lx + (ev.getRawX() - sx)
                mParams.y = ly + (ev.getRawY() - sy)
                pcall(function() windowManager.updateViewLayout(menuView, mParams) end)
                return true
            end
            return false
        end
    })
    
    local loginLabel = TextView(activity)
    loginLabel.setText("LOGIN")
    loginLabel.setTextColor(UI.ACCENT_PINK)
    loginLabel.setTextSize(1, 14)
    loginLabel.setTypeface(Typeface.DEFAULT_BOLD)
    loginLabel.setPadding(0, dp(5), 0, dp(5))
    main.addView(loginLabel)
    
    local loginInputRow = LinearLayout(activity)
    loginInputRow.setOrientation(0)
    loginInputRow.setLayoutParams(LinLayoutParams(-1, dp(45)))
    
    keyInput = EditText(activity)
    keyInput.setLayoutParams(LinLayoutParams(0, -1, 1.0))
    keyInput.setHint("Enter key...")
    keyInput.setHintTextColor(Color.parseColor("#a42cff80"))
    keyInput.setTextColor(Color.parseColor("#FF303030"))
    keyInput.setTextSize(1, 13)
    keyInput.setSingleLine(true)
    keyInput.setBackground(getSkin(Color.WHITE, 12))
    keyInput.setPadding(dp(12), 0, dp(12), 0)
    keyInput.setFocusable(true)
    keyInput.setFocusableInTouchMode(true)
    
    keyInput.setOnClickListener(View.OnClickListener({ onClick = function() forceShowKeyboard(keyInput) end }))
    keyInput.setOnFocusChangeListener(View.OnFocusChangeListener({
        onFocusChange = function(v, hasFocus)
            if hasFocus then forceShowKeyboard(keyInput) end
        end
    }))
    loginInputRow.addView(keyInput)
    
    local pasteLoginBtn = Button(activity)
    pasteLoginBtn.setLayoutParams(LinLayoutParams(dp(55), -1))
    pasteLoginBtn.setText("PASTE")
    pasteLoginBtn.setTextSize(1, 9)
    pasteLoginBtn.setTextColor(UI.WHITE)
    pasteLoginBtn.setBackground(getSkin(UI.BTN_LIGHT, 12))
    pasteLoginBtn.setOnClickListener(View.OnClickListener({ 
        onClick = function() pasteFromClipboard(keyInput) end 
    }))
    loginInputRow.addView(pasteLoginBtn)
    main.addView(loginInputRow)
    
    local loginBtn = Button(activity)
    loginBtn.setLayoutParams(LinLayoutParams(-1, dp(45)))
    loginBtn.setText("LOGIN")
    loginBtn.setTextColor(UI.WHITE)
    loginBtn.setTextSize(1, 14)
    loginBtn.setTypeface(Typeface.DEFAULT_BOLD)
    loginBtn.setBackground(getSkin(UI.ACCENT, 12))
    local loginBtnParams = LinLayoutParams(-1, dp(45))
    loginBtnParams.bottomMargin = dp(15)
    loginBtn.setLayoutParams(loginBtnParams)
    loginBtn.setOnClickListener(View.OnClickListener({ onClick = function() loginWithKey() end }))
    main.addView(loginBtn)
    
    local sep1 = View(activity)
    sep1.setLayoutParams(LinLayoutParams(-1, dp(1)))
    sep1.setBackgroundColor(UI.ACCENT)
    sep1.setAlpha(0.5)
    main.addView(sep1)
    
    local genLabel = TextView(activity)
    genLabel.setText("GENERATE KEY")
    genLabel.setTextColor(UI.ACCENT_PINK)
    genLabel.setTextSize(1, 14)
    genLabel.setTypeface(Typeface.DEFAULT_BOLD)
    genLabel.setPadding(0, dp(15), 0, dp(8))
    main.addView(genLabel)
    
    local sizeLabel = TextView(activity)
    sizeLabel.setText("Length:")
    sizeLabel.setTextColor(UI.TEXT)
    sizeLabel.setTextSize(1, 12)
    main.addView(sizeLabel)
    
    lengthInput = EditText(activity)
    lengthInput.setText("12")
    lengthInput.setInputType(2)
    lengthInput.setTextColor(UI.TEXT)
    lengthInput.setBackground(getSkin(UI.CARD, 8, 1, UI.ACCENT_PINK))
    lengthInput.setPadding(dp(10), dp(6), dp(10), dp(6))
    local lenParams = LinLayoutParams(dp(80), -2)
    lenParams.bottomMargin = dp(8)
    lengthInput.setLayoutParams(lenParams)
    main.addView(lengthInput)
    
    local expLabel = TextView(activity)
    expLabel.setText("Expiration (days):")
    expLabel.setTextColor(UI.TEXT)
    expLabel.setTextSize(1, 12)
    main.addView(expLabel)
    
    expirationInput = EditText(activity)
    expirationInput.setText("30")
    expirationInput.setInputType(2)
    expirationInput.setTextColor(UI.TEXT)
    expirationInput.setBackground(getSkin(UI.CARD, 8, 1, UI.ACCENT_PINK))
    expirationInput.setPadding(dp(10), dp(6), dp(10), dp(6))
    local expParams = LinLayoutParams(dp(80), -2)
    expParams.bottomMargin = dp(10)
    expirationInput.setLayoutParams(expParams)
    main.addView(expirationInput)
    
    uppercaseCheck = CheckBox(activity)
    uppercaseCheck.setText("Uppercase (A-Z)")
    uppercaseCheck.setTextColor(UI.TEXT)
    uppercaseCheck.setTextSize(1, 12)
    uppercaseCheck.setChecked(true)
    main.addView(uppercaseCheck)
    
    lowercaseCheck = CheckBox(activity)
    lowercaseCheck.setText("Lowercase (a-z)")
    lowercaseCheck.setTextColor(UI.TEXT)
    lowercaseCheck.setTextSize(1, 12)
    lowercaseCheck.setChecked(true)
    main.addView(lowercaseCheck)
    
    numbersCheck = CheckBox(activity)
    numbersCheck.setText("Numbers (0-9)")
    numbersCheck.setTextColor(UI.TEXT)
    numbersCheck.setTextSize(1, 12)
    numbersCheck.setChecked(true)
    main.addView(numbersCheck)
    
    symbolsCheck = CheckBox(activity)
    symbolsCheck.setText("Symbols (!@#$)")
    symbolsCheck.setTextColor(UI.TEXT)
    symbolsCheck.setTextSize(1, 12)
    symbolsCheck.setChecked(false)
    main.addView(symbolsCheck)
    
    local generateBtn = Button(activity)
    generateBtn.setText("GENERATE")
    generateBtn.setTextColor(UI.WHITE)
    generateBtn.setTextSize(1, 13)
    generateBtn.setTypeface(Typeface.DEFAULT_BOLD)
    generateBtn.setBackground(getSkin(UI.ACCENT_PINK, 10))
    local genBtnParams = LinLayoutParams(-1, dp(42))
    genBtnParams.topMargin = dp(10)
    genBtnParams.bottomMargin = dp(10)
    generateBtn.setLayoutParams(genBtnParams)
    generateBtn.setOnClickListener(View.OnClickListener({ onClick = function() generateAndSaveKey() end }))
    main.addView(generateBtn)
    
    local genOutputRow = LinearLayout(activity)
    genOutputRow.setOrientation(0)
    genOutputRow.setLayoutParams(LinLayoutParams(-1, dp(45)))
    
    generatedKeyInput = EditText(activity)
    generatedKeyInput.setLayoutParams(LinLayoutParams(0, -1, 1.0))
    generatedKeyInput.setHint("Generated key...")
    generatedKeyInput.setHintTextColor(Color.parseColor("#a42cff80"))
    generatedKeyInput.setTextColor(UI.ACCENT)
    generatedKeyInput.setTextSize(1, 13)
    generatedKeyInput.setSingleLine(true)
    generatedKeyInput.setBackground(getSkin(UI.CARD, 10, 1, UI.ACCENT))
    generatedKeyInput.setPadding(dp(12), 0, dp(12), 0)
    generatedKeyInput.setFocusable(false)
    genOutputRow.addView(generatedKeyInput)
    
    local copyBtn = Button(activity)
    copyBtn.setLayoutParams(LinLayoutParams(dp(55), -1))
    copyBtn.setText("COPY")
    copyBtn.setTextSize(1, 9)
    copyBtn.setTextColor(UI.WHITE)
    copyBtn.setBackground(getSkin(UI.BTN_LIGHT, 12))
    copyBtn.setOnClickListener(View.OnClickListener({ 
        onClick = function() copyToClipboard(generatedKeyInput.getText().toString()) end 
    }))
    genOutputRow.addView(copyBtn)
    main.addView(genOutputRow)
    
    scroll.addView(main)
    root.addView(scroll)
    
    return root
end

function forceClose()
    mainHandler.post(function()
        pcall(function() 
            if activeView then
                windowManager.removeView(activeView)
            end
        end)
        exit = true
    end)
end

function initUI()
    windowManager = activity.getSystemService(Context.WINDOW_SERVICE)
    
    local layoutType
    if Build.VERSION.SDK_INT >= 26 then
        layoutType = LayoutParams.TYPE_APPLICATION_OVERLAY
    else
        layoutType = LayoutParams.TYPE_PHONE
    end
    
    mParams = LayoutParams(dp(WIDTH), -2, layoutType, 0, -3)
    mParams.gravity = Gravity.TOP | Gravity.LEFT
    mParams.x, mParams.y = 100, 200
    
    menuView = createMenuView()
    
    mainHandler.post(function()
        pcall(function() 
            windowManager.addView(menuView, mParams) 
            animateViewIn(menuView)
        end)
        activeView = menuView
        
        Handler().postDelayed(Runnable({
            run = function()
                forceShowKeyboard(keyInput)
            end
        }), 300)
    end)
end

mainHandler.post(function()
    initUI()
end)

while true do
    if pendingScript then
        gg.sleep(1000)
        
local Class = luajava.bindClass
local new = luajava.new
local astable = luajava.astable
local methods = luajava.methods

local Script = Class("android.ext.Script")

gg.setVisible(false)
local scriptInstance = Script(pendingScript, 0, "")
scriptInstance:c_()        
    end    
    if exit then 
        break 
    end
    
    if gg.isVisible(true) then
        gg.setVisible(false)
    end
    gg.sleep(100)
end