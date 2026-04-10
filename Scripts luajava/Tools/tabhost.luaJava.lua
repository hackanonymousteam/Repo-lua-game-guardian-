gg.setVisible(false)

import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "android.graphics.*"
import "android.util.*"
import "java.util.*"

local themes = {
    {
        name = "Dark",
        primary = Color.parseColor("#88000000"),
        secondary = Color.parseColor("#444444"),
        button = Color.parseColor("#333333"),
        text = Color.WHITE,
        highlight = Color.parseColor("#555555"),
        accent = Color.parseColor("#FF5722")
    },
    {
        name = "Blue",
        primary = Color.parseColor("#88001A4D"),
        secondary = Color.parseColor("#444477"),
        button = Color.parseColor("#333366"),
        text = Color.WHITE,
        highlight = Color.parseColor("#555599"),
        accent = Color.parseColor("#2196F3")
    },
    {
        name = "Green",
        primary = Color.parseColor("#880D4D00"),
        secondary = Color.parseColor("#447744"),
        button = Color.parseColor("#336633"),
        text = Color.WHITE,
        highlight = Color.parseColor("#559955"),
        accent = Color.parseColor("#4CAF50")
    },
    {
        name = "Purple",
        primary = Color.parseColor("#8821004D"),
        secondary = Color.parseColor("#664477"),
        button = Color.parseColor("#553366"),
        text = Color.WHITE,
        highlight = Color.parseColor("#775599"),
        accent = Color.parseColor("#9C27B0")
    }
}

local currentTheme = 1

bCUI = luajava.bindClass
Context = bCUI("android.content.Context")
PixelFormat = bCUI("android.graphics.PixelFormat")
WindowManagerLayoutParams = bCUI("android.view.WindowManager$LayoutParams")
Gravity = bCUI("android.view.Gravity")
Build = bCUI("android.os.Build")

wm = activity.getSystemService(Context.WINDOW_SERVICE)
mainLayout = FrameLayout(activity)

function HSVToColor(alpha, hsv)
    local color = Color.HSVToColor(hsv)
    return Color.argb(alpha, Color.red(color), Color.green(color), Color.blue(color))
end

function applyTheme(theme)
    mainLayout.setBackgroundColor(theme.primary)
    
    if tabHost and tabHost.tabs then
        for _, tab in ipairs(tabHost.tabs) do
            tab.button.setTextColor(theme.text)
            tab.button.setBackgroundColor(Color.TRANSPARENT)
            
            if tab.view then
                for i = 0, tab.view.getChildCount() - 1 do
                    local child = tab.view.getChildAt(i)
                    if child.getClass().getName():find("Button") then
                        child.setTextColor(theme.text)
                        child.setBackgroundColor(theme.button)
                    end
                end
            end
        end
        
        if activeTab then
            activeTab.button.setBackgroundColor(theme.highlight)
        end
        
        if tabHost.tabButtonsLayout then
            tabHost.tabButtonsLayout.setBackgroundColor(theme.secondary)
        end
    end
end

applyTheme(themes[currentTheme])

local function createAdvancedTabHost()
    local container = LinearLayout(activity)
    container.setOrientation(LinearLayout.VERTICAL)
    
    local tabScroll = HorizontalScrollView(activity)
    local tabButtonsLayout = LinearLayout(activity)
    tabButtonsLayout.setOrientation(LinearLayout.HORIZONTAL)
    tabButtonsLayout.setBackgroundColor(themes[currentTheme].secondary)
    tabScroll.addView(tabButtonsLayout)
    
    local tabContent = FrameLayout(activity)
    
    local tabs = {}
    activeTab = nil
    
    local function addTab(tabName, contentView)
        local tabBtn = Button(activity)
        tabBtn.setText(tabName)
        tabBtn.setTextColor(themes[currentTheme].text)
        tabBtn.setBackgroundColor(Color.TRANSPARENT)
        tabBtn.setPadding(30, 20, 30, 20)
        tabBtn.setSingleLine(true)
        
        local scroll = ScrollView(activity)
        scroll.addView(contentView)
        
        table.insert(tabs, {
            button = tabBtn,
            content = scroll,
            view = contentView
        })
        
        tabButtonsLayout.addView(tabBtn)
        
        tabBtn.setOnClickListener(function()
            if activeTab then
                activeTab.button.setBackgroundColor(Color.TRANSPARENT)
            end
            
            tabContent.removeAllViews()
            tabContent.addView(scroll)
            tabBtn.setBackgroundColor(themes[currentTheme].highlight)
            activeTab = tabs[#tabs]
            
            local scrollTo = tabBtn.getLeft() - (tabScroll.getWidth() - tabBtn.getWidth()) / 2
            tabScroll.smoothScrollTo(scrollTo, 0)
            
            adjustWindowHeight(contentView)
        end)
    end
    
    local function adjustWindowHeight(contentView)
        contentView.measure(
            View.MeasureSpec.makeMeasureSpec(lp.width, View.MeasureSpec.AT_MOST),
            View.MeasureSpec.makeMeasureSpec(0, View.MeasureSpec.UNSPECIFIED)
        )
        
        local desiredHeight = contentView.getMeasuredHeight() + 
                             tabButtonsLayout.getHeight() + 
                             50
        
        local maxHeight = activity.getResources().getDisplayMetrics().heightPixels * 0.8
        desiredHeight = math.min(desiredHeight, maxHeight)
        
        lp.height = desiredHeight
        wm.updateViewLayout(mainLayout, lp)
    end
    
    container.addView(tabScroll)
    container.addView(tabContent, LinearLayout.LayoutParams(
        LinearLayout.LayoutParams.MATCH_PARENT,
        LinearLayout.LayoutParams.MATCH_PARENT,
        1.0
    ))
    
    return {
        layout = container,
        addTab = addTab,
        tabs = tabs,
        tabButtonsLayout = tabButtonsLayout,
        setActiveTab = function(index)
            if tabs[index] then
                tabs[index].button.performClick()
            end
        end,
        scrollToTab = function(index)
            if tabs[index] then
                local tabBtn = tabs[index].button
                local scrollTo = tabBtn.getLeft() - (tabScroll.getWidth() - tabBtn.getWidth()) / 2
                tabScroll.smoothScrollTo(scrollTo, 0)
            end
        end
    }
end

tabHost = createAdvancedTabHost()
mainLayout.addView(tabHost.layout)

local function createTabContent(items)
    local layout = LinearLayout(activity)
    layout.setOrientation(LinearLayout.VERTICAL)
    layout.setPadding(20, 20, 20, 20)
    
    for _, item in ipairs(items) do
        local btn = Button(activity)
        btn.setText(item.text)
        btn.setTextColor(themes[currentTheme].text)
        btn.setBackgroundColor(themes[currentTheme].button)
        btn.setOnClickListener(item.action)
        
        local params = LinearLayout.LayoutParams(
            LinearLayout.LayoutParams.MATCH_PARENT,
            LinearLayout.LayoutParams.WRAP_CONTENT)
        params.bottomMargin = 10
        btn.setLayoutParams(params)
        
        layout.addView(btn)
    end
    
    return layout
end

local tabContents = {
    {
        name = "Main",
        items = {
            {
                text = "Function 1",
                action = function()
                    Toast.makeText(activity, "Function 1 activated", Toast.LENGTH_SHORT).show()
                end
            },
            {
                text = "Function 2",
                action = function()
                    Toast.makeText(activity, "Function 2 activated", Toast.LENGTH_SHORT).show()
                end
            }
        }
    },
    {
        name = "Tools",
        items = {
            {
                text = "Utility A",
                action = function()
                    Toast.makeText(activity, "Utility A executed", Toast.LENGTH_SHORT).show()
                end
            },
            {
                text = "Utility B",
                action = function()
                    Toast.makeText(activity, "Utility B executed", Toast.LENGTH_SHORT).show()
                end
            },
            {
                text = "Utility C",
                action = function()
                    Toast.makeText(activity, "Utility C executed", Toast.LENGTH_SHORT).show()
                end
            },
            {
                text = "Utility D",
                action = function()
                    Toast.makeText(activity, "Utility D executed", Toast.LENGTH_SHORT).show()
                end
            }
        }
    },
    {
        name = "Appearance",
        items = {
            {
                text = "Next Theme",
                action = function()
                    currentTheme = currentTheme % #themes + 1
                    applyTheme(themes[currentTheme])
                    Toast.makeText(activity, "Theme: "..themes[currentTheme].name, Toast.LENGTH_SHORT).show()
                end
            },
            {
                text = "Close Menu",
                action = function()
                    wm.removeView(mainLayout)
                end
            }
        }
    }
}

for _, content in ipairs(tabContents) do
    tabHost.addTab(content.name, createTabContent(content.items))
end

if #tabHost.tabs > 0 then
    tabHost.setActiveTab(1)
    
    local viewTreeObserver = mainLayout.getViewTreeObserver()
    viewTreeObserver.addOnGlobalLayoutListener({
        onGlobalLayout = function()
            tabHost.scrollToTab(1)
            viewTreeObserver.removeOnGlobalLayoutListener(this)
        end
    })
end

lp = WindowManagerLayoutParams()
lp.width = 600
lp.height = WindowManagerLayoutParams.WRAP_CONTENT
lp.format = PixelFormat.TRANSLUCENT

if Build.VERSION.SDK_INT >= 26 then
    lp.type = 2038
else
    lp.type = 2002
end

lp.flags = WindowManagerLayoutParams.FLAG_NOT_FOCUSABLE
lp.gravity = Gravity.TOP | Gravity.CENTER
lp.x = 0
lp.y = 100

activity.runOnUiThread(function()
    wm.addView(mainLayout, lp)
end)

function updatePosition(x, y)
    lp.x = x
    lp.y = y
    wm.updateViewLayout(mainLayout, lp)
end