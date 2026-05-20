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
local ColorDrawable = luajava.bindClass("android.graphics.drawable.ColorDrawable")
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
local Button = luajava.bindClass("android.widget.Button")
local ListView = luajava.bindClass("android.widget.ListView")
local ArrayAdapter = luajava.bindClass("android.widget.ArrayAdapter")
local AdapterView = luajava.bindClass("android.widget.AdapterView")
local File = luajava.bindClass("java.io.File")
local Environment = luajava.bindClass("android.os.Environment")
local ArrayList = luajava.bindClass("java.util.ArrayList")
local Runnable = luajava.bindClass("java.lang.Runnable")
local Toast = luajava.bindClass("android.widget.Toast")

local AndroidR = luajava.bindClass("android.R$layout")
local simpleListItem = AndroidR.simple_list_item_1

local mainHandler = Handler(Looper.getMainLooper())

local currentFile = nil
local currentDirectory = nil
local filePickerView = nil
local activeView = nil
local windowManager = nil
local mParams = nil

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

local WIDTH = 350
local HEIGHT = 700

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

local function showToast(message)
    mainHandler.post(Runnable({
        run = function()
            Toast.makeText(activity, message, Toast.LENGTH_SHORT):show()
        end
    }))
end

local function openDirectory(dir, pathView, listView)
    currentDirectory = dir
    pathView.setText(dir.getAbsolutePath())
    
    local files = dir.listFiles()
    if files == nil then
        return
    end
    
    local filesTable = luajava.astable(files)
    
    local fileList = ArrayList()
    for i = 1, #filesTable do
        local file = filesTable[i]
        local name = file.getName()
        if file.isDirectory() then
            name = " " .. name
        else
            name = " " .. name
        end
        fileList.add(name)
    end
    
    local adapter = ArrayAdapter(activity, simpleListItem, fileList)
    listView.setAdapter(adapter)
    
    local clickListener = AdapterView.OnItemClickListener({
        onItemClick = function(parent, view, position, id)
            local selectedFile = filesTable[position + 1]
            if selectedFile.isDirectory() then
                openDirectory(selectedFile, pathView, listView)
            else
                currentFile = selectedFile
                showToast("Selected: " .. selectedFile.getName())
                mainHandler.postDelayed(Runnable({
                    run = function()
                        closeUI()
                    end
                }), 300)
            end
        end
    })
    listView.setOnItemClickListener(clickListener)
end

local function createFilePickerScreen()
    local root = FrameLayout(activity)
    root.setLayoutParams(FrameLayoutParams(dp(WIDTH), dp(HEIGHT)))
    
    local main = LinearLayout(activity)
    main.setOrientation(LinearLayout.VERTICAL)
    main.setBackground(getSkin(UI.BG, 20, 2, UI.ACCENT))
    main.setPadding(dp(16), dp(16), dp(16), dp(16))
    
    local topBar = LinearLayout(activity)
    topBar.setOrientation(LinearLayout.HORIZONTAL)
    topBar.setGravity(Gravity.CENTER_VERTICAL)
    topBar.setPadding(0, 0, 0, dp(12))
    
    local header = LinearLayout(activity)
    header.setOrientation(LinearLayout.HORIZONTAL)
    header.setGravity(Gravity.CENTER_VERTICAL)
    local headerParams = LinLayoutParams(0, ViewGroup.LayoutParams.WRAP_CONTENT, 1.0)
    header.setLayoutParams(headerParams)
    
    local titleArea = LinearLayout(activity)
    titleArea.setOrientation(LinearLayout.VERTICAL)
    
    local title = TextView(activity)
    title.setText("File Picker")
    title.setTextColor(UI.ACCENT)
    title.setTextSize(1, 18)
    title.setTypeface(Typeface.create("sans-serif-black", Typeface.BOLD))
    titleArea.addView(title)
    
    local subtitle = TextView(activity)
    subtitle.setText("Select a file")
    subtitle.setTextColor(UI.GRAY)
    subtitle.setTextSize(1, 10)
    subtitle.setAlpha(0.6)
    titleArea.addView(subtitle)
    
    header.addView(titleArea)
    topBar.addView(header)
    
    local closeBtn = Button(activity)
    closeBtn.setText("X")
    closeBtn.setTextColor(UI.WHITE)
    closeBtn.setTextSize(1, 18)
    closeBtn.setBackground(getSkin(Color.parseColor("#FF0000"), 50))
    local closeParams = LinLayoutParams(dp(44), dp(44))
    closeBtn.setLayoutParams(closeParams)
    closeBtn.setPadding(0, 0, 0, 0)
    closeBtn.setAllCaps(false)
    closeBtn.setOnClickListener(View.OnClickListener({
        onClick = function(v)
            currentFile = nil
            closeUI()
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
    spacer1.setLayoutParams(LinLayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, dp(12)))
    main.addView(spacer1)
    
    local pathView = TextView(activity)
    pathView.setTextColor(UI.CYAN)
    pathView.setTextSize(1, 11)
    pathView.setPadding(dp(8), dp(8), dp(8), dp(8))
    pathView.setBackground(getSkin(UI.CARD, 8))
    pathView.setLayoutParams(LinLayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT))
    main.addView(pathView)
    
    local spacer2 = View(activity)
    spacer2.setLayoutParams(LinLayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, dp(8)))
    main.addView(spacer2)
    
    local listView = ListView(activity)
    listView.setBackground(getSkin(UI.CARD, 10))
    listView.setDivider(ColorDrawable(Color.parseColor("#333333")))
    listView.setDividerHeight(1)
    listView.setPadding(0, dp(4), 0, dp(4))
    local listParams = LinLayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, 0, 1.0)
    listView.setLayoutParams(listParams)
    main.addView(listView)
    
    local spacer3 = View(activity)
    spacer3.setLayoutParams(LinLayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, dp(8)))
    main.addView(spacer3)
    
    local backButton = Button(activity)
    backButton.setText("Back")
    backButton.setTextColor(UI.WHITE)
    backButton.setTextSize(1, 14)
    backButton.setTypeface(Typeface.DEFAULT_BOLD)
    backButton.setBackground(getSkin(UI.ACCENT2, 10))
    backButton.setAllCaps(false)
    local backBtnParams = LinLayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, dp(48))
    backButton.setLayoutParams(backBtnParams)
    backButton.setOnClickListener(View.OnClickListener({
        onClick = function(v)
            if currentDirectory ~= nil then
                local parentFile = currentDirectory.getParentFile()
                if parentFile ~= nil then
                    openDirectory(parentFile, pathView, listView)
                end
            end
        end
    }))
    main.addView(backButton)
    
    local spacer4 = View(activity)
    spacer4.setLayoutParams(LinLayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, dp(6)))
    main.addView(spacer4)
    
    local cancelButton = Button(activity)
    cancelButton.setText("Cancel")
    cancelButton.setTextColor(UI.WHITE)
    cancelButton.setTextSize(1, 14)
    cancelButton.setBackground(getSkin(UI.GRAY, 10))
    cancelButton.setAllCaps(false)
    local cancelBtnParams = LinLayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, dp(48))
    cancelButton.setLayoutParams(cancelBtnParams)
    cancelButton.setOnClickListener(View.OnClickListener({
        onClick = function(v)
            currentFile = nil
            closeUI()
        end
    }))
    main.addView(cancelButton)
    
    root.addView(main)
    
    local rootDir = Environment.getExternalStorageDirectory()
    openDirectory(rootDir, pathView, listView)
    
    return root
end

local function showUI()
    windowManager = activity.getSystemService(Context.WINDOW_SERVICE)
    
    local layoutType
    if Build.VERSION.SDK_INT >= 26 then
        layoutType = LayoutParams.TYPE_APPLICATION_OVERLAY
    else
        layoutType = LayoutParams.TYPE_PHONE
    end
    
    mParams = LayoutParams(dp(WIDTH), dp(HEIGHT), layoutType, 
        LayoutParams.FLAG_NOT_TOUCH_MODAL + LayoutParams.FLAG_WATCH_OUTSIDE_TOUCH, -3)
    mParams.gravity = Gravity.CENTER
    mParams.x = 0
    mParams.y = 0
    
    filePickerView = createFilePickerScreen()
    
    mainHandler.post(Runnable({
        run = function()
            pcall(function()
                windowManager.addView(filePickerView, mParams)
                activeView = filePickerView
            end)
        end
    }))
end

function closeUI()
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

function getSelectedFile()
    return currentFile
end

function getSelectedFilePath()
    if currentFile ~= nil then
        return currentFile.getAbsolutePath()
    end
    return nil
end

showUI()

return {
    showUI = showUI,
    closeUI = closeUI,
    getSelectedFile = getSelectedFile,
    getSelectedFilePath = getSelectedFilePath
}