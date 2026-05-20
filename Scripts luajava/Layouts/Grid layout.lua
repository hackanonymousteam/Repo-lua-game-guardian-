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

local LinearLayout = bind("android.widget.LinearLayout")
local GridLayout = bind("android.widget.GridLayout")
local Button = bind("android.widget.Button")
local WindowManager = bind("android.view.WindowManager")
local PixelFormat = bind("android.graphics.PixelFormat")
local Gravity = bind("android.view.Gravity")
local Color = bind("android.graphics.Color")
local Build = bind("android.os.Build")

local function getType()
    if Build.VERSION.SDK_INT >= 26 then
        return 2038
    elseif Build.VERSION.SDK_INT >= 23 then
        return 2002
    else
        return 2003
    end
end


local root = LinearLayout(activity)
root.setOrientation(1)
root.setPadding(20,20,20,20)
root.setBackgroundColor(0xCC000000)


local btnClose = Button(activity)
btnClose.setText("X")
btnClose.setTextColor(Color.WHITE)


local grid = GridLayout(activity)
grid.setColumnCount(2)
grid.setRowCount(2)


local function createButton(text)
    local btn = Button(activity)
    btn.setText(text)
    btn.setTextColor(Color.WHITE)
    return btn
end

local b1 = createButton("A")
local b2 = createButton("B")
local b3 = createButton("C")
local b4 = createButton("D")


b1.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
    onClick = function(v)
        gg.toast("Pressed A")
    end
}))

b2.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
    onClick = function(v)
        gg.toast("Pressed B")
    end
}))

b3.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
    onClick = function(v)
        gg.toast("Pressed C")
    end
}))

b4.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
    onClick = function(v)
        gg.toast("Pressed D")
    end
}))

btnClose.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
    onClick = function(v)
        pcall(function()
            local wm = activity.getWindowManager()
            wm.removeView(root)
        end)
        gg.toast("Closed")
    end
}))


grid.addView(b1)
grid.addView(b2)
grid.addView(b3)
grid.addView(b4)

root.addView(btnClose)
root.addView(grid)

local params = luajava.newInstance(
    "android.view.WindowManager$LayoutParams",
    -2,
    -2,
    getType(),
    0x00000008,
    PixelFormat.TRANSLUCENT
)

params.gravity = Gravity.CENTER

activity.runOnUiThread(luajava.createProxy("java.lang.Runnable", {
    run = function()
        local wm = activity.getWindowManager()
        wm.addView(root, params)
    end
}))