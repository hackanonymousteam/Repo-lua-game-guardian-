gg.setVisible(false)

if not activity then return end

local function bind(c) local ok,r=pcall(luajava.bindClass,c) if ok then return r end end

local ListView = bind("android.widget.ListView")
local ArrayAdapter = bind("android.widget.ArrayAdapter")
local ArrayList = bind("java.util.ArrayList")
local LinearLayout = bind("android.widget.LinearLayout")
local Button = bind("android.widget.Button")
local WindowManager = bind("android.view.WindowManager")
local PixelFormat = bind("android.graphics.PixelFormat")
local Gravity = bind("android.view.Gravity")
local Build = bind("android.os.Build")

local function getType()
    if Build.VERSION.SDK_INT >= 26 then return 2038
    elseif Build.VERSION.SDK_INT >= 23 then return 2002
    else return 2003 end
end

local root = LinearLayout(activity)
root.setOrientation(1)
root.setBackgroundColor(0xCC000000)

local list = ListView(activity)

local data = ArrayList()
data.add("Hack A")
data.add("Hack B")
data.add("Hack C")

local adapter = ArrayAdapter(activity, android.R.layout.simple_list_item_1, data)
list.setAdapter(adapter)

local close = Button(activity)
close.setText("✕")

root.addView(list)
root.addView(close)

local params = luajava.newInstance("android.view.WindowManager$LayoutParams",-2,-2,getType(),0x00000008,PixelFormat.TRANSLUCENT)
params.gravity = Gravity.CENTER

activity.runOnUiThread(luajava.createProxy("java.lang.Runnable", {
    run=function()
        local wm = activity.getWindowManager()
        wm.addView(root, params)

        list.setOnItemClickListener(luajava.createProxy("android.widget.AdapterView$OnItemClickListener", {
            onItemClick=function(p,v,pos,id)
                gg.toast(data.get(pos))
            end
        }))

        close.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
            onClick=function()
                wm.removeView(root)
            end
        }))
    end
}))