gg.setVisible(false)

if not activity then
    gg.alert("No activity")
    return
end

local function bind(c)
    local ok, r = pcall(luajava.bindClass, c)
    if ok then return r end
    return nil
end

local Button = bind("android.widget.Button")
local LinearLayout = bind("android.widget.LinearLayout")

local GradientDrawable = bind("android.graphics.drawable.GradientDrawable")
local RippleDrawable = bind("android.graphics.drawable.RippleDrawable")
local ColorStateList = bind("android.content.res.ColorStateList")
local Build = bind("android.os.Build")

local Gravity = bind("android.view.Gravity")
local PixelFormat = bind("android.graphics.PixelFormat")


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


local function createButton(activity, xml)

    local c = parse(xml)

    local btn = Button(activity)
    btn.setText(c.text)

 local shape = GradientDrawable()
    shape.setShape(GradientDrawable.RECTANGLE)
    shape.setCornerRadius(c.radius)

    shape.setColor(toColor(c.startColor or c.color or "666666"))

   if c.strokeWidth and c.strokeWidth > 0 then
        shape.setStroke(
            c.strokeWidth,
            toColor(c.strokeColor or "FFFFFF")
        )
    end


    local rippleColor = ColorStateList.valueOf(
        toColor(c.color or "FFFFFF")
    )

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


local layout = LinearLayout(activity)
layout.setOrientation(1)


local XML = [[
<ripple>
color=#66ca96
startColor=#9d6aff
radius=18
padding=20
strokeWidth=5
strokeColor=#ffffff
</ripple>
]]

local btn = createButton(activity, XML)
btn.setText("click me")
local btn2 = createButton(activity, XML)
btn2.setText("exit")



layout.addView(btn)
layout.addView(btn2)

activity.runOnUiThread(luajava.createProxy("java.lang.Runnable", {
    run = function()

        local wm = activity.getWindowManager()

        local params = luajava.newInstance(
            "android.view.WindowManager$LayoutParams",
            -2,
            -2,
            Build.VERSION.SDK_INT >= 26 and 2038 or 2002,
            0x00000008,
            PixelFormat.TRANSLUCENT
        )

        params.gravity = Gravity.CENTER

        wm.addView(layout, params)

        btn.setOnClickListener(luajava.createProxy(
        "android.view.View$OnClickListener",
        {
            onClick = function()
                gg.toast("XML BUTTON CLICKED 🔥")
            end
        }))
        
                btn2.setOnClickListener(luajava.createProxy(
        "android.view.View$OnClickListener",
        {
            onClick = function()
                                    wm.removeView(layout)
            end
        }))
    
    end
}))