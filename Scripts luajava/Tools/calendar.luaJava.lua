gg.setVisible(true)

local imports = {
    "android.app.*",
    "android.content.*",
    "android.graphics.*",
    "android.graphics.drawable.*",
    "android.os.*",
    "android.view.*",
    "android.widget.*",
    "java.io.File",
    "java.lang.*",
    "java.util.*"
}

for _, lib in ipairs(imports) do
    import(lib)
end

local TypedValue = luajava.bindClass("android.util.TypedValue")
local Gravity = luajava.bindClass("android.view.Gravity")
local PixelFormat = luajava.bindClass("android.graphics.PixelFormat")
local Context = luajava.bindClass("android.content.Context")
local WindowManager = luajava.bindClass("android.view.WindowManager")
local Build = luajava.bindClass("android.os.Build")
local MotionEvent = luajava.bindClass("android.view.MotionEvent")

local PRIMARY_COLOR = Color.parseColor("#FF5722")
local WHITE = Color.parseColor("#FFFFFF")
local BLACK = Color.parseColor("#000000")
local DARK_GRAY = Color.parseColor("#222222")
local RED = Color.parseColor("#F44336")
local GREEN = Color.parseColor("#4CAF50")
local BLUE = Color.parseColor("#2196F3")
local YELLOW = Color.parseColor("#FFEB3B")

local calendarView = nil
local windowManager = nil
local calendarParams = nil
local isCalendarVisible = false
local lastX, lastY, startX, startY = 0, 0, 0, 0
local CALENDAR_WIDTH = 320
local CALENDAR_HEIGHT = 380

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

local function getLayoutType()
    if Build.VERSION.SDK_INT >= 26 then
        return WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
    else
        return WindowManager.LayoutParams.TYPE_PHONE
    end
end

local function getMonthName(month)
    local monthNames = {
        "January", "February", "March", "April", "May", "June",
        "July", "August", "September", "October", "November", "December"
    }
    return monthNames[month] or "Unknown"
end

local function getDaysInMonth(month, year)
    local daysInMonth = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31}
    
    if month == 2 then
        if (year % 4 == 0 and year % 100 ~= 0) or (year % 400 == 0) then
            return 29
        end
    end
    return daysInMonth[month]
end

local function getFirstDayOfMonth(month, year)
    local date = os.date("*t", os.time{year=year, month=month, day=1})
    return date.wday
end

local function getWeekdayName(weekdayNum)
    local weekDays = {"Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"}
    return weekDays[weekdayNum] or "Unknown"
end

local function createCalendarContent()
    local weekDays = {"Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"}
    
    local currentDay = tonumber(os.date("%d"))
    local currentMonth = tonumber(os.date("%m"))
    local currentYear = tonumber(os.date("%Y"))
    
    local todayWeekday = tonumber(os.date("%w")) + 1
    if todayWeekday == 8 then todayWeekday = 1 end
    
    local content = ""
    content = content .. "┌────────────────────┐\n"
    content = content .. "│    " .. getMonthName(currentMonth) .. " " .. currentYear .. "    │\n"
    content = content .. "└────────────────────┘\n\n"
    
    local weekHeader = ""
    for i, day in ipairs(weekDays) do
        weekHeader = weekHeader .. string.format("%-4s", day)
    end
    content = content .. weekHeader .. "\n"
    
    local firstDay = getFirstDayOfMonth(currentMonth, currentYear)
    local totalDays = getDaysInMonth(currentMonth, currentYear)
    
    local daysCounter = 1
    local weekCounter = 1
    
    while daysCounter <= totalDays do
        local weekLine = ""
        for i = 1, 7 do
            if weekCounter == 1 and i < firstDay then
                weekLine = weekLine .. "    "
            elseif daysCounter <= totalDays then
                if daysCounter == currentDay then
                    weekLine = weekLine .. string.format("%2d ", daysCounter)
                else
                    weekLine = weekLine .. string.format("%2d  ", daysCounter)
                end
                daysCounter = daysCounter + 1
            else
                weekLine = weekLine .. "    "
            end
        end
        content = content .. weekLine .. "\n"
        weekCounter = weekCounter + 1
    end
    
    content = content .. "\n" .. string.rep("─", 20) .. "\n"
    content = content .. "Today: " .. currentDay .. " " .. getMonthName(currentMonth) .. " " .. currentYear .. "\n"
    content = content .. "Day: " .. getWeekdayName(todayWeekday)
    
    return content
end

local function setupCalendar()
    windowManager = activity.getSystemService(Context.WINDOW_SERVICE)
    
    calendarParams = WindowManager.LayoutParams(
        dp(CALENDAR_WIDTH),
        dp(CALENDAR_HEIGHT),
        getLayoutType(),
        WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE | 
        WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS |
        WindowManager.LayoutParams.FLAG_WATCH_OUTSIDE_TOUCH,
        PixelFormat.TRANSLUCENT
    )
    
    calendarParams.gravity = Gravity.TOP | Gravity.LEFT
    calendarParams.x = dp(50)
    calendarParams.y = dp(50)
    
    local mainLayout = LinearLayout(activity)
    mainLayout.setOrientation(LinearLayout.VERTICAL)
    mainLayout.setLayoutParams(LinearLayout.LayoutParams(
        dp(CALENDAR_WIDTH),
        dp(CALENDAR_HEIGHT)
    ))
    mainLayout.setBackground(getBorderBackground(DARK_GRAY, PRIMARY_COLOR, 3, 15))
    mainLayout.setPadding(dp(8), dp(8), dp(8), dp(8))
    
    local headerLayout = LinearLayout(activity)
    headerLayout.setOrientation(LinearLayout.HORIZONTAL)
    headerLayout.setGravity(Gravity.CENTER_VERTICAL)
    headerLayout.setLayoutParams(LinearLayout.LayoutParams(
        LinearLayout.LayoutParams.MATCH_PARENT, 
        dp(40)
    ))
    headerLayout.setBackground(getShapeBackground(Color.TRANSPARENT, 8))
    
    local dragIcon = TextView(activity)
    dragIcon.setText("📅 FLOATING CALENDAR")
    dragIcon.setTextColor(PRIMARY_COLOR)
    dragIcon.setTextSize(TypedValue.COMPLEX_UNIT_SP, 14)
    dragIcon.setTypeface(Typeface.DEFAULT_BOLD)
    dragIcon.setGravity(Gravity.CENTER)
    dragIcon.setPadding(dp(10), 0, 0, 0)
    dragIcon.setLayoutParams(LinearLayout.LayoutParams(
        0,
        LinearLayout.LayoutParams.MATCH_PARENT,
        1.0
    ))
    
    local closeBtn = TextView(activity)
    closeBtn.setText("✕")
    closeBtn.setTextColor(RED)
    closeBtn.setTextSize(TypedValue.COMPLEX_UNIT_SP, 16)
    closeBtn.setTypeface(Typeface.DEFAULT_BOLD)
    closeBtn.setGravity(Gravity.CENTER)
    closeBtn.setLayoutParams(LinearLayout.LayoutParams(
        dp(40),
        LinearLayout.LayoutParams.MATCH_PARENT
    ))
    
    closeBtn.onClick = function()
        if windowManager and calendarView then
            windowManager.removeView(calendarView)
            isCalendarVisible = false
        end
    end
    
    headerLayout.addView(dragIcon)
    headerLayout.addView(closeBtn)
    
    local separator = View(activity)
    separator.setLayoutParams(LinearLayout.LayoutParams(
        LinearLayout.LayoutParams.MATCH_PARENT, 
        dp(1)
    ))
    separator.setBackgroundColor(PRIMARY_COLOR)
    
    local scrollView = ScrollView(activity)
    scrollView.setLayoutParams(LinearLayout.LayoutParams(
        LinearLayout.LayoutParams.MATCH_PARENT,
        LinearLayout.LayoutParams.MATCH_PARENT
    ))
    scrollView.setVerticalScrollBarEnabled(true)
    
    local contentLayout = LinearLayout(activity)
    contentLayout.setOrientation(LinearLayout.VERTICAL)
    contentLayout.setLayoutParams(LinearLayout.LayoutParams(
        LinearLayout.LayoutParams.MATCH_PARENT,
        LinearLayout.LayoutParams.WRAP_CONTENT
    ))
    contentLayout.setPadding(dp(5), dp(10), dp(5), dp(10))
    
    local calendarText = TextView(activity)
    calendarText.setText(createCalendarContent())
    calendarText.setTextColor(YELLOW)
    calendarText.setTextSize(TypedValue.COMPLEX_UNIT_SP, 12)
    calendarText.setTypeface(Typeface.MONOSPACE)
    calendarText.setLineSpacing(0, 1.1)
    
    contentLayout.addView(calendarText)
    scrollView.addView(contentLayout)
    
    mainLayout.addView(headerLayout)
    mainLayout.addView(separator)
    mainLayout.addView(scrollView)
    
    calendarView = mainLayout
    
    headerLayout.setOnTouchListener(View.OnTouchListener{
        onTouch = function(v, event)
            local action = event.getAction()
            
            if action == MotionEvent.ACTION_DOWN then
                startX = event.getRawX()
                startY = event.getRawY()
                lastX = calendarParams.x
                lastY = calendarParams.y
                v.setBackground(getBorderBackground(Color.parseColor("#333333"), PRIMARY_COLOR, 2, 8))
                return true
                
            elseif action == MotionEvent.ACTION_MOVE then
                local dx = event.getRawX() - startX
                local dy = event.getRawY() - startY
                
                calendarParams.x = lastX + dx
                calendarParams.y = lastY + dy
                
                if windowManager and calendarView then
                    windowManager.updateViewLayout(calendarView, calendarParams)
                end
                return true
                
            elseif action == MotionEvent.ACTION_UP then
                v.setBackground(getShapeBackground(Color.TRANSPARENT, 8))
                return true
            end
            
            return false
        end
    })
end

local function showCalendar()
    if calendarView == nil then
        setupCalendar()
    end   
    if calendarView ~= nil and windowManager ~= nil and not isCalendarVisible then
        activity.runOnUiThread(Runnable{
            run = function()
                pcall(function()
                    windowManager.addView(calendarView, calendarParams)
                    isCalendarVisible = true
                    gg.toast("Calendar opened")
                end)
            end
        })
    end
end

local function hideCalendar()
    if calendarView ~= nil and windowManager ~= nil and isCalendarVisible then
        activity.runOnUiThread(Runnable{
            run = function()
                pcall(function()
                    windowManager.removeView(calendarView)
                    isCalendarVisible = false
                    gg.toast("Calendar closed")
                end)
            end
        })
    end
end

local function closeCalendar()
    hideCalendar()
    if calendarView ~= nil and windowManager ~= nil then
        activity.runOnUiThread(Runnable{
            run = function()
                pcall(function()
                    windowManager.removeView(calendarView)
                    calendarView = nil
                    windowManager = nil
                    isCalendarVisible = false
                end)
            end
        })
    end
end

showCalendar()