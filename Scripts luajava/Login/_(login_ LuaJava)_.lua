
if not luajava then
    print("LuaJava NOT Available!")
    return
end

if not activity then
    print("No activity available")
    return
end

local Color = luajava.bindClass("android.graphics.Color")
local Context = luajava.bindClass("android.content.Context")
local Typeface = luajava.bindClass("android.graphics.Typeface")
local GradientDrawable = luajava.bindClass("android.graphics.drawable.GradientDrawable")
local Build = luajava.bindClass("android.os.Build")
local Handler = luajava.bindClass("android.os.Handler")
local Looper = luajava.bindClass("android.os.Looper")
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
local EditText = luajava.bindClass("android.widget.EditText")
local Button = luajava.bindClass("android.widget.Button")
local ScrollView = luajava.bindClass("android.widget.ScrollView")
local Runnable = luajava.bindClass("java.lang.Runnable")
local Thread = luajava.bindClass("java.lang.Thread")
local URL = luajava.bindClass("java.net.URL")
local HttpURLConnection = luajava.bindClass("java.net.HttpURLConnection")
local BufferedReader = luajava.bindClass("java.io.BufferedReader")
local InputStreamReader = luajava.bindClass("java.io.InputStreamReader")
local URLEncoder = luajava.bindClass("java.net.URLEncoder")
local JSONObject = luajava.bindClass("org.json.JSONObject")
local InputType = luajava.bindClass("android.text.InputType")
local PasswordTransformationMethod = luajava.bindClass("android.text.method.PasswordTransformationMethod")
local Toast = luajava.bindClass("android.widget.Toast")
local InputMethodManager = luajava.bindClass("android.view.inputmethod.InputMethodManager")

--paste your url 

local SERVER_URL = "https://pastebin.com/raw/veVa8gLs"

--format expected 

--[[

{
  "users": [
    {
      "username": "batman",
      "password": "games"
    },
    {
      "username": "taiman",
      "password": "taiman"
          
    }
  ]
}


]]




local mainHandler = Handler(Looper.getMainLooper())

local windowManager = nil
local mParams = nil
local menuView = nil
local activeView = nil
local usernameInput, passwordInput
local statusText
local imm = nil

local UI = {
    BG = Color.parseColor("#0a0a0f"),
    CARD = Color.parseColor("#1a1a2e"),
    ACCENT = Color.parseColor("#e94560"),
    ACCENT2 = Color.parseColor("#0f3460"),
    TEXT = Color.parseColor("#eaeaea"),
    SUCCESS = Color.parseColor("#4ade80"),
    DANGER = Color.parseColor("#ef4444"),
    WARNING = Color.parseColor("#f59e0b"),
    WHITE = Color.parseColor("#FFFFFF"),
    GRAY = Color.parseColor("#999999"),
    BLACK = Color.parseColor("#000000"),
    CYAN = Color.parseColor("#00d4ff"),
}

local WIDTH = 340

local function dp(v)
    return math.floor(TypedValue.applyDimension(1, v, activity.getResources().getDisplayMetrics()))
end

local function getSkin(color, radius, strokeWidth, strokeColor)
    local draw = GradientDrawable()
    draw.setColor(color)
    draw.setCornerRadius(dp(radius))
    if strokeWidth and strokeColor then
        draw.setStroke(dp(strokeWidth), strokeColor)
    end
    return draw
end

local function showKeyboard(view)
    mainHandler.post(Runnable({
        run = function()
            pcall(function()
                if imm == nil then
                    imm = activity.getSystemService(Context.INPUT_METHOD_SERVICE)
                end
                if view and imm then
                    view.requestFocus()
                    imm.showSoftInput(view, InputMethodManager.SHOW_IMPLICIT)
                end
            end)
        end
    }))
end


local function hideKeyboard()
    mainHandler.post(Runnable({
        run = function()
            pcall(function()
                if imm == nil then
                    imm = activity.getSystemService(Context.INPUT_METHOD_SERVICE)
                end
                if activeView and imm then
                    imm.hideSoftInputFromWindow(activeView.getWindowToken(), 0)
                end
            end)
        end
    }))
end
local function updateStatus(text, color)
    if statusText then
        mainHandler.post(Runnable({
            run = function()
                pcall(function()
                    statusText.setText(text)
                    statusText.setTextColor(color or UI.TEXT)
                end)
            end
        }))
    end
end


local function showToast(message)
    mainHandler.post(Runnable({
        run = function()
            Toast.makeText(activity, message, Toast.LENGTH_SHORT):show()
        end
    }))
end


local function httpRequest(urlString)
    local urlConnection = nil
    local reader = nil
    local result = nil
    
    local success = pcall(function()
        local url = URL(urlString)
        urlConnection = url.openConnection()
        urlConnection.setRequestMethod("GET")
        urlConnection.setConnectTimeout(10000)
        urlConnection.setReadTimeout(10000)
        urlConnection.setRequestProperty("User-Agent", "XCIPTV-Android")
        urlConnection.connect()
        
        local responseCode = urlConnection.getResponseCode()
        
        if responseCode == 200 then
            local inputStream = urlConnection.getInputStream()
            reader = BufferedReader(InputStreamReader(inputStream))
            local buffer = {}
            local line = reader.readLine()
            while line do
                table.insert(buffer, line)
                line = reader.readLine()
            end
            result = table.concat(buffer, "\n")
        end
    end)
    
    if urlConnection then
        pcall(function() urlConnection.disconnect() end)
    end
    if reader then
        pcall(function() reader.close() end)
    end
    
    if success and result then
        return result
    end
    return nil
end


local function checkCredentials(username, password)
    hideKeyboard()
    updateStatus("Verifying...", UI.WARNING)
    
    Thread(Runnable({
        run = function()
                  local response = httpRequest(SERVER_URL)
            
            if response then
               
                local parseSuccess, jsonData = pcall(function()
                    return JSONObject(response)
                end)
                
                if parseSuccess then
                    local users = jsonData.optJSONArray("users")
                    
                    if users then
                        local found = false
                        local userInfo = nil
                        
                        for i = 0, users.length() - 1 do
                            local user = users.getJSONObject(i)
                            local storedUser = user.optString("username", "")
                            local storedPass = user.optString("password", "")
                            
                            if storedUser == username and storedPass == password then
                                found = true
                                userInfo = user
                                break
                            end
                        end
                        
                        if found then
                            local role = userInfo.optString("role", "user")
                            local expires = userInfo.optString("expires", "never")
                            
                            mainHandler.post(Runnable({
                                run = function()
                                    updateStatus("✅ LOGIN SUCCESS!", UI.SUCCESS)
                                    showToast("Welcome " .. username)
                                    
                                    mainHandler.postDelayed(Runnable({
                                        run = function()
                                            closeUI()
                                        end
                                    }), 2000)
                                end
                            }))
                        else
                            mainHandler.post(Runnable({
                                run = function()
                                    updateStatus("❌ Invalid credentials", UI.DANGER)
                                    showToast("Username or password incorrect")
                                end
                            }))
                        end
                    else
                        mainHandler.post(Runnable({
                            run = function()
                                updateStatus("❌ Invalid data format", UI.DANGER)
                                showToast("Server data format error")
                            end
                        }))
                    end
                else
                            mainHandler.post(Runnable({
                        run = function()
                            if username == "batman" and password == "games" then
                                updateStatus("✅ LOGIN SUCCESS!", UI.SUCCESS)
                                showToast("Welcome Batman!\nAccess Granted")
                                mainHandler.postDelayed(Runnable({
                                    run = function()
                                        closeUI()
                                    end
                                }), 2000)
                            else
                                updateStatus("❌ Invalid credentials", UI.DANGER)
                                showToast("Username or password incorrect")
                            end
                        end
                    }))
                end
            else
                        mainHandler.post(Runnable({
                    run = function()
                        if username == "batman" and password == "games" then
                            updateStatus("✅ LOGIN SUCCESS! (Offline)", UI.SUCCESS)
                            showToast("Welcome Batman!\nOffline mode")
                            mainHandler.postDelayed(Runnable({
                                run = function()
                                    closeUI()
                                end
                            }), 2000)
                        else
                            updateStatus("❌ Invalid credentials", UI.DANGER)
                            showToast("Username or password incorrect")
                        end
                    end
                }))
            end
        end
    })).start()
end

local function doLogin()
    local username = usernameInput.getText().toString():trim()
    local password = passwordInput.getText().toString():trim()
    
    if username == "" then
        showToast("Please enter username")
        showKeyboard(usernameInput)
        return
    end
    
    if password == "" then
        showToast("Please enter password")
        showKeyboard(passwordInput)
        return
    end
    
    checkCredentials(username, password)
end

local function createLoginScreen()
    local root = FrameLayout(activity)
    root.setLayoutParams(FrameLayoutParams(dp(WIDTH), ViewGroup.LayoutParams.WRAP_CONTENT))
    
    local scroll = ScrollView(activity)
    scroll.setLayoutParams(FrameLayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, dp(520)))
    scroll.setFillViewport(true)
    
    local main = LinearLayout(activity)
    main.setOrientation(LinearLayout.VERTICAL)
    main.setBackground(getSkin(UI.BG, 20, 2, UI.ACCENT))
    main.setPadding(dp(20), dp(20), dp(20), dp(20))
    
        local topBar = LinearLayout(activity)
    topBar.setOrientation(LinearLayout.HORIZONTAL)
    topBar.setGravity(Gravity.CENTER_VERTICAL)
    topBar.setPadding(0, 0, 0, dp(16))
    

    local header = LinearLayout(activity)
    header.setOrientation(LinearLayout.HORIZONTAL)
    header.setGravity(Gravity.CENTER_VERTICAL)
    local headerParams = LinLayoutParams(0, ViewGroup.LayoutParams.WRAP_CONTENT, 1.0)
    header.setLayoutParams(headerParams)
    
    local titleArea = LinearLayout(activity)
    titleArea.setOrientation(LinearLayout.VERTICAL)
    
    local icon = TextView(activity)
    icon.setText("")
    icon.setTextSize(1, 24)
    icon.setPadding(0, 0, dp(8), 0)
    titleArea.addView(icon)
    
    local title = TextView(activity)
    title.setText("Login")
    title.setTextColor(UI.ACCENT)
    title.setTextSize(1, 20)
    title.setTypeface(Typeface.create("sans-serif-black", Typeface.BOLD))
    titleArea.addView(title)
    
    local subtitle = TextView(activity)
    subtitle.setText("Authentication System")
    subtitle.setTextColor(UI.GRAY)
    subtitle.setTextSize(1, 10)
    subtitle.setAlpha(0.6)
 --   titleArea.addView(subtitle)
    
    header.addView(titleArea)
    topBar.addView(header)
    
    
    local closeBtn = Button(activity)
    closeBtn.setText("✕")
    closeBtn.setTextColor(UI.WHITE)
    closeBtn.setTextSize(1, 18)
    closeBtn.setBackground(getSkin(Color.parseColor("#FF0000"), 50))
    local closeParams = LinLayoutParams(dp(44), dp(44))
    closeBtn.setLayoutParams(closeParams)
    closeBtn.setPadding(0, 0, 0, 0)
    closeBtn.setAllCaps(false)
    closeBtn.setOnClickListener(View.OnClickListener({
        onClick = function(v)
            hideKeyboard()
            mainHandler.postDelayed(Runnable({
                run = function()
                    closeUI()
                end
            }), 100)
        end
    }))
    topBar.addView(closeBtn)
    
    main.addView(topBar)
    
    
    local sep = View(activity)
    sep.setLayoutParams(LinLayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, dp(2)))
    sep.setBackgroundColor(UI.ACCENT)
    sep.setAlpha(0.5)
    main.addView(sep)
    
    
    local spacer1 = View(activity)
    spacer1.setLayoutParams(LinLayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, dp(16)))
    main.addView(spacer1)
    

    local serverInfo = TextView(activity)
    serverInfo.setText("🌐 Server: Connected")
    serverInfo.setTextColor(UI.CYAN)
    serverInfo.setTextSize(1, 10)
    serverInfo.setGravity(Gravity.CENTER)
    serverInfo.setPadding(0, 0, 0, dp(16))
    main.addView(serverInfo)
    

    local userLabel = TextView(activity)
    userLabel.setText("👤 USERNAME")
    userLabel.setTextColor(UI.ACCENT)
    userLabel.setTextSize(1, 11)
    userLabel.setTypeface(Typeface.DEFAULT_BOLD)
    userLabel.setPadding(0, 0, 0, dp(6))
    main.addView(userLabel)
    
    
    usernameInput = EditText(activity)
    local userParams = LinLayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, dp(50))
    usernameInput.setLayoutParams(userParams)
    usernameInput.setHint("Enter username")
    usernameInput.setHintTextColor(Color.parseColor("#555555"))
    usernameInput.setTextColor(UI.TEXT)
    usernameInput.setTextSize(1, 16)
    usernameInput.setSingleLine(true)
    usernameInput.setInputType(InputType.TYPE_CLASS_TEXT)
    usernameInput.setBackground(getSkin(UI.CARD, 10, 1, UI.ACCENT))
    usernameInput.setPadding(dp(16), dp(14), dp(16), dp(14))
    usernameInput.setFocusable(true)
    usernameInput.setFocusableInTouchMode(true)
    userParams.bottomMargin = dp(14)
    main.addView(usernameInput)
    
    
    local passLabel = TextView(activity)
    passLabel.setText("🔒 PASSWORD")
    passLabel.setTextColor(UI.ACCENT)
    passLabel.setTextSize(1, 11)
    passLabel.setTypeface(Typeface.DEFAULT_BOLD)
    passLabel.setPadding(0, 0, 0, dp(6))
    main.addView(passLabel)
    
    passwordInput = EditText(activity)
    local passParams = LinLayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, dp(50))
    passwordInput.setLayoutParams(passParams)
    passwordInput.setHint("Enter password")
    passwordInput.setHintTextColor(Color.parseColor("#555555"))
    passwordInput.setTextColor(UI.TEXT)
    passwordInput.setTextSize(1, 16)
    passwordInput.setSingleLine(true)
    passwordInput.setInputType(InputType.TYPE_CLASS_TEXT + InputType.TYPE_TEXT_VARIATION_PASSWORD)
    passwordInput.setTransformationMethod(PasswordTransformationMethod.getInstance())
    passwordInput.setBackground(getSkin(UI.CARD, 10, 1, UI.ACCENT))
    passwordInput.setPadding(dp(16), dp(14), dp(16), dp(14))
    passwordInput.setFocusable(true)
    passwordInput.setFocusableInTouchMode(true)
    passParams.bottomMargin = dp(20)
    main.addView(passwordInput)
    
    
    statusText = TextView(activity)
    statusText.setText("")
    statusText.setTextColor(UI.TEXT)
    statusText.setTextSize(1, 12)
    statusText.setGravity(Gravity.CENTER)
    statusText.setPadding(0, 0, 0, dp(14))
    statusText.setMinHeight(dp(30))
    main.addView(statusText)
    
    
    local loginBtn = Button(activity)
    loginBtn.setText("🚀 LOGIN")
    loginBtn.setTextColor(UI.WHITE)
    loginBtn.setTextSize(1, 18)
    loginBtn.setTypeface(Typeface.DEFAULT_BOLD)
    loginBtn.setBackground(getSkin(UI.ACCENT, 12))
    loginBtn.setAllCaps(false)
    local loginBtnParams = LinLayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, dp(54))
    loginBtnParams.bottomMargin = dp(10)
    loginBtn.setLayoutParams(loginBtnParams)
    loginBtn.setOnClickListener(View.OnClickListener({
        onClick = function(v)
            doLogin()
        end
    }))
    main.addView(loginBtn)
    
    
    local helpText = TextView(activity)
    helpText.setText(" batman / games")
    helpText.setTextColor(UI.GRAY)
    helpText.setTextSize(1, 10)
    helpText.setAlpha(0.5)
    helpText.setGravity(Gravity.CENTER)
    helpText.setPadding(0, dp(4), 0, 0)
    main.addView(helpText)  
    scroll.addView(main)
    root.addView(scroll)    
    return root
end

local function showUI()
    windowManager = activity.getSystemService(Context.WINDOW_SERVICE)
    imm = activity.getSystemService(Context.INPUT_METHOD_SERVICE)

    local layoutType
    if Build.VERSION.SDK_INT >= 26 then
        layoutType = LayoutParams.TYPE_APPLICATION_OVERLAY
    else
        layoutType = LayoutParams.TYPE_PHONE
    end

    mParams = LayoutParams(dp(WIDTH), ViewGroup.LayoutParams.WRAP_CONTENT, layoutType, 
        LayoutParams.FLAG_NOT_TOUCH_MODAL + LayoutParams.FLAG_WATCH_OUTSIDE_TOUCH, -3)
    mParams.gravity = Gravity.CENTER
    mParams.x = 0
    mParams.y = 0

    menuView = createLoginScreen()

    mainHandler.post(Runnable({
        run = function()
            pcall(function()
                windowManager.addView(menuView, mParams)
                activeView = menuView
                
     mainHandler.postDelayed(Runnable({
                    run = function()
                        showKeyboard(usernameInput)
                    end
                }), 300)
            end)
        end
    }))
end

function closeUI()
    hideKeyboard()
    mainHandler.postDelayed(Runnable({
        run = function()
            pcall(function()
                if activeView and windowManager then
                    windowManager.removeView(activeView)
                    activeView = nil
                end
            end)
        end
    }), 150)
end

showUI()

return {
    showUI = showUI,
    closeUI = closeUI,
    doLogin = doLogin
}