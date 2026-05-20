gg.setVisible(false)
if luajava == nil then gg.alert(' unavaliable please use gameguardian mod (suport luajava)') else end

function setvalue(address, flags, value)
  local refinevalues = {}
  refinevalues[1] = {}
  refinevalues[1].address = address
  refinevalues[1].flags = flags
  refinevalues[1].value = value
  gg.setValues(refinevalues)
end

if not activity then
    gg.alert("No activity")
    return
end

local function bind(c)
    local ok, r = pcall(luajava.bindClass, c)
    if ok then return r end
    return nil
end
local NumberPicker = bind("android.widget.NumberPicker")


local TextView = bind("android.widget.TextView")
local Button = bind("android.widget.Button")
local LinearLayout = bind("android.widget.LinearLayout")
local Spinner = bind("android.widget.Spinner")
local ArrayAdapter = bind("android.widget.ArrayAdapter")
local ArrayList = bind("java.util.ArrayList")
local WindowManager = bind("android.view.WindowManager")
local PixelFormat = bind("android.graphics.PixelFormat")
local Gravity = bind("android.view.Gravity")
local Color = bind("android.graphics.Color")
local Build = bind("android.os.Build")
local MotionEvent = bind("android.view.MotionEvent")
local View = bind("android.view.View")

local GradientDrawable = bind("android.graphics.drawable.GradientDrawable")
local RippleDrawable = bind("android.graphics.drawable.RippleDrawable")
local ColorStateList = bind("android.content.res.ColorStateList")
local ValueAnimator = bind("android.animation.ValueAnimator")
local ArgbEvaluator = bind("android.animation.ArgbEvaluator")


local ScaleGestureDetector = bind("android.view.ScaleGestureDetector")


local floatMenuView = nil
local menuParams = nil
local windowManager = nil
local isMenuVisible = false
local menuScale = 1.0
local baseWidth = 250
local baseHeight = 400
local basePadding = 10


local bgColors = {
    0xFF12121F,
    0xFF1A1A2E,
    0xFF4361EE,
    0xFF3A0CA3,
    0xFF4CC9F0,
    0xFF7209B7,
    0xFF12121F
}

local function getType()
    if Build.VERSION.SDK_INT >= 26 then
        return 2038
    elseif Build.VERSION.SDK_INT >= 23 then
        return 2002
    else
        return 2003
    end
end

function dp(value)
    if value == nil then return 0 end
    local metrics = activity.getResources().getDisplayMetrics()
    if metrics == nil then return math.floor(value * 3.0) end
    return math.floor(value * metrics.density + 0.5)
end

local function toColor(hex)
    if not hex then return 0xFF888888 end
    hex = hex:gsub("#","")
    return tonumber("0xFF"..hex)
end

local function parse(xml)
    return {
        text = xml:match("text=([^\n\r]+)") or "BUTTON",
        color = xml:match("color=#?(%x+)"),
        startColor = xml:match("startColor=#?(%x+)"),
        radius = tonumber(xml:match("radius=(%d+)") or 12),
        padding = tonumber(xml:match("padding=(%d+)") or 10),
        strokeWidth = tonumber(xml:match("strokeWidth=(%d+)") or 0),
        strokeColor = xml:match("strokeColor=#?(%x+)")
    }
end

local function createRippleButton(activity, xml)
    local c = parse(xml)
    local btn = Button(activity)
    btn.setText(c.text)

    local shape = GradientDrawable()
    shape.setShape(GradientDrawable.RECTANGLE)
    shape.setCornerRadius(c.radius)
    shape.setColor(toColor(c.startColor or c.color or "666666"))

    if c.strokeWidth and c.strokeWidth > 0 then
        shape.setStroke(c.strokeWidth, toColor(c.strokeColor or "FFFFFF"))
    end

    local rippleColor = ColorStateList.valueOf(toColor(c.color or "FFFFFF"))

    local bg
    if Build.VERSION.SDK_INT >= 21 then
        bg = RippleDrawable(rippleColor, shape, nil)
    else
        bg = shape
    end

    btn.setBackground(bg)
    local p = c.padding or 10
    btn.setPadding(p, p/2, p, p/2)

    return btn
end


local RIPPLE_XML = [[
<ripple>
color=#66ca96
startColor=#9d6aff
radius=18
padding=20
strokeWidth=5
strokeColor=#ffffff
</ripple>
]]

function removeFloatingMenu()
    if floatMenuView ~= nil then
        activity.runOnUiThread(luajava.createProxy("java.lang.Runnable", {
            run = function()
                pcall(function()
                    if windowManager ~= nil and floatMenuView ~= nil then
                        windowManager.removeView(floatMenuView)
                    end
                end)
            end
        }))
    end
    isMenuVisible = false
    floatMenuView = nil
    gg.toast("Menu fechado")
end

function createFloatingMenu()
    if isMenuVisible then
        return
    end
Context = activity 
    windowManager = activity.getSystemService(Context.WINDOW_SERVICE)

    
    floatMenuView = LinearLayout(activity)
    floatMenuView.setOrientation(LinearLayout.VERTICAL)
    floatMenuView.setPadding(dp(basePadding), dp(basePadding), dp(basePadding), dp(basePadding))

  local shimmerAnimator = ValueAnimator.ofInt(table.unpack(bgColors))
    shimmerAnimator.setEvaluator(ArgbEvaluator())
    shimmerAnimator.setDuration(3000)
    shimmerAnimator.setRepeatCount(ValueAnimator.INFINITE)
    shimmerAnimator.setRepeatMode(ValueAnimator.RESTART)
    shimmerAnimator.addUpdateListener(luajava.createProxy(
        "android.animation.ValueAnimator$AnimatorUpdateListener",
        {
            onAnimationUpdate = function(a)
                local color = a.getAnimatedValue()
                local bg = GradientDrawable()
                bg.setShape(GradientDrawable.RECTANGLE)
                bg.setCornerRadius(dp(16))
                bg.setColor(color)
                bg.setStroke(dp(2), 0xFF4361EE)
                floatMenuView.setBackgroundDrawable(bg)
            end
        }
    ))

    
    local headerLayout = LinearLayout(activity)
    headerLayout.setOrientation(LinearLayout.HORIZONTAL)
    headerLayout.setGravity(Gravity.CENTER_VERTICAL)
    headerLayout.setPadding(dp(16), dp(12), dp(16), dp(12))

    local headerBg = GradientDrawable()
    headerBg.setShape(GradientDrawable.RECTANGLE)
    headerBg.setCornerRadius(dp(12))
    headerBg.setColor(0xFF4361EE)
    headerLayout.setBackgroundDrawable(headerBg)

    local titleText = TextView(activity)
    titleText.setText("BATMAN PRO         ")
    titleText.setTextColor(Color.WHITE)
    titleText.setTextSize(16)
    titleText.setTypeface(Typeface.DEFAULT_BOLD)

    
    local textColors = {
        0xFF6EE7F9, 0xFF8B5CF6, 0xFFEC4899,
        0xFFF59E0B, 0xFF10B981, 0xFF3B82F6, 0xFFA78BFA
    }
    local textAnimator = ValueAnimator.ofInt(table.unpack(textColors))
    textAnimator.setEvaluator(ArgbEvaluator())
    textAnimator.setDuration(2000)
    textAnimator.setRepeatCount(ValueAnimator.INFINITE)
    textAnimator.setRepeatMode(ValueAnimator.RESTART)
    textAnimator.addUpdateListener(luajava.createProxy(
        "android.animation.ValueAnimator$AnimatorUpdateListener",
        {
            onAnimationUpdate = function(a)
                titleText.setTextColor(a.getAnimatedValue())
            end
        }
    ))

    local closeButton = Button(activity)
closeButton.setText("X")
closeButton.setTextColor(Color.WHITE)
closeButton.setTextSize(14)
closeButton.setTypeface(Typeface.DEFAULT_BOLD)

local closeBg = GradientDrawable()
closeBg.setShape(GradientDrawable.OVAL)
closeBg.setColor(Color.RED)

closeButton.setBackgroundDrawable(closeBg)

local size = dp(36)

local params = LinearLayout.LayoutParams(size, size)
closeButton.setLayoutParams(params)

closeButton.setPadding(0, 0, 0, 0)

closeButton.setOnClickListener({
    onClick = function()
        removeFloatingMenu()
    end
})

    headerLayout.addView(titleText)
    
    local spacerView = View(activity)
    local spacerLayoutParams = LinearLayout.LayoutParams(0, 0, 1.0)
    spacerView.setLayoutParams(spacerLayoutParams)
    headerLayout.addView(spacerView)
    
    headerLayout.addView(closeButton)
    floatMenuView.addView(headerLayout)

    
    local space1 = View(activity)
    space1.setLayoutParams(LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, dp(10)))
    floatMenuView.addView(space1)

       local btn1 = createRippleButton(activity, RIPPLE_XML)
    btn1.setText("🎯 Aimbot")
    btn1.setTextColor(Color.WHITE)
    btn1.setOnClickListener({
        onClick = function()
            so = gg.getRangesList('libunity.so')[1].start
            setvalue(so + 0x76E767, 4, "h 6A FE FB 9F 17 A1 D6 D7")
            setvalue(so + 0xFC5E65, 4, "h 6A FE FB 9F 17 A1 D6 D7")
            gg.toast("Aimbot Ativado!")
        end
    })
    floatMenuView.addView(btn1)

    local space2 = View(activity)
    space2.setLayoutParams(LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, dp(5)))
    floatMenuView.addView(space2)

    
    local btn2 = createRippleButton(activity, RIPPLE_XML)
    btn2.setText("👁 ESP")
    btn2.setTextColor(Color.WHITE)
    btn2.setOnClickListener({
        onClick = function()
            gg.toast("ESP Ativado!")
        end
    })
    floatMenuView.addView(btn2)

    local space3 = View(activity)
    space3.setLayoutParams(LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, dp(5)))
    floatMenuView.addView(space3)

    
local spinnerItems = {
    {name = "Option 1", action = function() gg.toast("Option 1 selected") end},
    {name = "Option 2", action = function() gg.toast("Option 2 selected") end},
    {name = "Option 3", action = function() gg.toast("Option 3 selected") end},
    {name = "Batman Mode 😎", action = function() gg.toast("Batman Mode activated") end}
}

local spinner = Spinner(activity)
local items = ArrayList()

for i, item in ipairs(spinnerItems) do
    items.add(item.name)
end

local adapter = ArrayAdapter(activity, android.R.layout.simple_spinner_item, items)
adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item)
spinner.setAdapter(adapter)

local spinnerBg = GradientDrawable()
spinnerBg.setShape(GradientDrawable.RECTANGLE)
spinnerBg.setCornerRadius(18)
spinnerBg.setColor(0x9D6AFF)
spinnerBg.setStroke(5, 0xFFFFFFFF)
spinner.setBackground(spinnerBg)
spinner.setPadding(20, 10, 20, 10)

spinner.setOnItemSelectedListener(luajava.createProxy("android.widget.AdapterView$OnItemSelectedListener", {
    onItemSelected = function(parent, view, position, id)
        spinnerItems[position + 1].action()
    end,
    onNothingSelected = function(parent)
    end
}))

floatMenuView.addView(spinner)

local np = NumberPicker(activity)
np.setMinValue(1)
np.setMaxValue(10)

local ok = Button(activity)
ok.setText("OK")



ok.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
    onClick = function(v)
        local val = np.getValue()
        gg.toast("Selected: "..val)
    end
}))


    local spaceEnd = View(activity)
    spaceEnd.setLayoutParams(LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, dp(10)))
    floatMenuView.addView(spaceEnd)

    menuParams = WindowManager.LayoutParams()
    if Build.VERSION.SDK_INT >= Build.VERSION_CODES.O then
        menuParams.type = WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
    else
        menuParams.type = WindowManager.LayoutParams.TYPE_PHONE
    end
    menuParams.format = PixelFormat.RGBA_8888
    menuParams.flags = WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE |
                      WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN |
                      WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL
    menuParams.width = dp(baseWidth)
    menuParams.height = WindowManager.LayoutParams.WRAP_CONTENT
    menuParams.gravity = Gravity.CENTER


    local startX, startY = 0, 0
    local initialX, initialY = 0, 0
    local isMoving = false
    local moveThreshold = dp(8)

    headerLayout.setOnTouchListener({
        onTouch = function(v, event)
            local action = event.getAction()
            local rawX = event.getRawX()
            local rawY = event.getRawY()

            if action == MotionEvent.ACTION_DOWN then
                startX = rawX
                startY = rawY
                initialX = menuParams.x
                initialY = menuParams.y
                isMoving = false
                return true
            elseif action == MotionEvent.ACTION_MOVE then
                local dx = rawX - startX
                local dy = rawY - startY
                
                if not isMoving and (math.abs(dx) > moveThreshold or math.abs(dy) > moveThreshold) then
                    isMoving = true
                end
                
                if isMoving then
                    menuParams.x = initialX + dx
                    menuParams.y = initialY + dy
                    
                    local dm = activity.getResources().getDisplayMetrics()
                    local screenW = dm.widthPixels
                    local screenH = dm.heightPixels
                    
                    menuParams.x = math.max(-dp(100), math.min(menuParams.x, screenW - dp(150)))
                    menuParams.y = math.max(0, math.min(menuParams.y, screenH - dp(200)))
                    
                    pcall(function()
                        if floatMenuView ~= nil and windowManager ~= nil then
                            windowManager.updateViewLayout(floatMenuView, menuParams)
                        end
                    end)
                end
                return true
            elseif action == MotionEvent.ACTION_UP or action == MotionEvent.ACTION_CANCEL then
                isMoving = false
                return true
            end
            return false
        end
    })

        local detector = ScaleGestureDetector(activity,
        luajava.createProxy("android.view.ScaleGestureDetector$OnScaleGestureListener", {
            onScale = function(d)
                menuScale = menuScale * d.getScaleFactor()
                menuScale = math.max(0.5, math.min(menuScale, 2.0))
                
                menuParams.width = dp(baseWidth * menuScale)
                titleText.setTextSize(16 * menuScale)
                
                pcall(function()
                    if floatMenuView ~= nil and windowManager ~= nil then
                        windowManager.updateViewLayout(floatMenuView, menuParams)
                    end
                end)
                return true
            end,
            onScaleBegin = function() return true end,
            onScaleEnd = function() end
        })
    )

 floatMenuView.setOnTouchListener(luajava.createProxy("android.view.View$OnTouchListener", {
        onTouch = function(v, event)
            detector.onTouchEvent(event)
                  return false
        end
    }))

    activity.runOnUiThread(luajava.createProxy("java.lang.Runnable", {
        run = function()
            pcall(function()
                windowManager.addView(floatMenuView, menuParams)
                isMenuVisible = true
                shimmerAnimator.start()
                textAnimator.start()
                
            end)
        end
    }))
end

activity.runOnUiThread(luajava.createProxy("java.lang.Runnable", {
    run = function()
       createFloatingMenu()
    end
}))


--createFloatingMenu()