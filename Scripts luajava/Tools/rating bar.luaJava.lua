gg.setVisible(false)

import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "android.graphics.*"
import "android.content.*"
import "android.graphics.PixelFormat"
import "android.view.WindowManager"
import "android.view.Gravity"
import "android.widget.GridLayout"
import "android.widget.RatingBar"
import "android.widget.Toast"
import "android.widget.ExpandableListView"
import "android.widget.ArrayAdapter"

local Context = luajava.bindClass("android.content.Context")
local WindowManager = luajava.bindClass("android.view.WindowManager")
local WindowManagerLayoutParams = luajava.bindClass("android.view.WindowManager$LayoutParams")
local Gravity = luajava.bindClass("android.view.Gravity")
local wm = activity.getSystemService(Context.WINDOW_SERVICE)

local avaliacao = 0

function Waterdropanimation(Controls, time)
    import "android.animation.ObjectAnimator"
    ObjectAnimator().ofFloat(Controls, "scaleX", {1, .8, 1.3, .9, 1}).setDuration(time).start()
    ObjectAnimator().ofFloat(Controls, "scaleY", {1, .8, 1.3, .9, 1}).setDuration(time).start()
end

function SimpleButton(view, bgColor, textColor)
    view.setBackgroundColor(bgColor)
    view.setTextColor(textColor)
    view.setPadding(30, 15, 30, 15)
end

local mainLayout = LinearLayout(activity)
mainLayout.setOrientation(LinearLayout.VERTICAL)
mainLayout.setBackgroundColor(0x88000000)
mainLayout.setPadding(20, 20, 20, 20)

local ratingBar = RatingBar(activity)
ratingBar.setNumStars(5)
ratingBar.setRating(3)
ratingBar.setStepSize(1)
ratingBar.setLayoutParams(LinearLayout.LayoutParams(
    LinearLayout.LayoutParams.WRAP_CONTENT,
    LinearLayout.LayoutParams.WRAP_CONTENT
))

ratingBar.setOnRatingBarChangeListener{
    onRatingChanged = function(ratingBar, rating, fromUser)
        avaliacao = rating
        Toast.makeText(activity, "avaliate: "..rating.." stars", Toast.LENGTH_SHORT).show()
    end
}
mainLayout.addView(ratingBar)

local btnExpandable = Button(activity)
btnExpandable.setText("Expandable List")
SimpleButton(btnExpandable, 0xFFE76E00, Color.WHITE)
--mainLayout.addView(btnExpandable)

local btnDrawer = Button(activity)
btnDrawer.setText("Drawer Menu")
SimpleButton(btnDrawer, 0xFFE76E00, Color.WHITE)
--mainLayout.addView(btnDrawer)

local btnStart = Button(activity)
btnStart.setText("Start")
SimpleButton(btnStart, 0xFF3646FF, Color.WHITE)
mainLayout.addView(btnStart)

local btnStop = Button(activity)
btnStop.setText("Stop")
SimpleButton(btnStop, 0xAA1046FF, Color.WHITE)
--mainLayout.addView(btnStop)

local btnExit = Button(activity)
btnExit.setText("Exit")
SimpleButton(btnExit, 0x500000FF, Color.WHITE)
mainLayout.addView(btnExit)

local btnMain = Button(activity)
btnMain.setText("Batman Menu")
SimpleButton(btnMain, 0xFF3646FF, Color.WHITE)
btnMain.setTextSize(16)

mainLayout.setVisibility(View.GONE)

btnMain.onClick = function(v)
    mainLayout.setVisibility(mainLayout.getVisibility() == View.VISIBLE and View.GONE or View.VISIBLE)
    Waterdropanimation(btnMain, 300)
end

btnStart.onClick = function(v)
    Toast.makeText(activity, "Start pressed", Toast.LENGTH_SHORT).show()
    Waterdropanimation(btnStart, 900)
end

btnStop.onClick = function(v)
    Toast.makeText(activity, "Stop pressed", Toast.LENGTH_SHORT).show()
    Waterdropanimation(btnStop, 300)
end

btnExit.onClick = function(v)
    activity.runOnUiThread(function()
        wm.removeView(btnMain)
        wm.removeView(mainLayout)
    end)
    os.exit()
end


btnExpandable.onClick = function(v)
    Waterdropanimation(btnExpandable, 300)
    
    activity.runOnUiThread(function()
        local layout = LinearLayout(activity)
        layout.setOrientation(LinearLayout.VERTICAL)
        layout.setBackgroundColor(0x88000000)
        
        local expandableListView = ExpandableListView(activity)
        
        
        local grupos = {"Grupo 1", "Grupo 2", "Grupo 3"}
        local itens = {
            {"Item 1.1", "Item 1.2", "Item 1.3"},
            {"Item 2.1", "Item 2.2"},
            {"Item 3.1", "Item 3.2", "Item 3.3"}
        }
        
       
        local adapter = {
            getGroupCount = function() return #grupos end,
            getChildrenCount = function(groupPosition) return #itens[groupPosition+1] end,
            getGroup = function(groupPosition) return grupos[groupPosition+1] end,
            getChild = function(groupPosition, childPosition) return itens[groupPosition+1][childPosition+1] end,
            getGroupId = function(groupPosition) return groupPosition end,
            getChildId = function(groupPosition, childPosition) return childPosition end,
            hasStableIds = function() return false end,
            getGroupView = function(groupPosition, isExpanded, convertView, parent)
                local textView = TextView(activity)
                textView.setText(grupos[groupPosition+1])
                textView.setPadding(100, 30, 0, 30)
                textView.setTextColor(Color.WHITE)
                textView.setTextSize(18)
                return textView
            end,
            getChildView = function(groupPosition, childPosition, isLastChild, convertView, parent)
                local textView = TextView(activity)
                textView.setText(itens[groupPosition+1][childPosition+1])
                textView.setPadding(150, 20, 0, 20)
                textView.setTextColor(Color.WHITE)
                return textView
            end,
            isChildSelectable = function(groupPosition, childPosition) return true end
        }
        
        setmetatable(adapter, {__index = luajava.bindClass("android.widget.BaseExpandableListAdapter")})
        expandableListView.setAdapter(adapter)
        layout.addView(expandableListView)
        
        local btnClose = Button(activity)
        btnClose.setText("Fechar")
        SimpleButton(btnClose, 0xFFE76E00, Color.WHITE)
        btnClose.onClick = function() 
            activity.runOnUiThread(function()
                wm.removeView(layout)
            end)
        end
        layout.addView(btnClose)
        
        local lp = WindowManagerLayoutParams()
        lp.width = 600
        lp.height = 800
        lp.format = PixelFormat.TRANSLUCENT
        lp.type = WindowManagerLayoutParams.TYPE_APPLICATION_OVERLAY
        lp.flags = WindowManagerLayoutParams.FLAG_NOT_FOCUSABLE
        lp.gravity = Gravity.CENTER
        
        wm.addView(layout, lp)
    end)
end

btnDrawer.onClick = function(v)
    Waterdropanimation(btnDrawer, 300)
    
    activity.runOnUiThread(function()
        local layout = LinearLayout(activity)
        layout.setOrientation(LinearLayout.VERTICAL)
        layout.setBackgroundColor(0xFF222222)
        layout.setLayoutParams(LinearLayout.LayoutParams(300, LinearLayout.LayoutParams.MATCH_PARENT))
        
        local items = {"Opção 1", "Opção 2", "Opção 3", "Fechar"}
        for _, item in ipairs(items) do
            local btn = Button(activity)
            btn.setText(item)
            SimpleButton(btn, 0x00FFFFFF, Color.WHITE)
            btn.setGravity(Gravity.START)
            btn.onClick = function()
                if item == "Fechar" then
                    activity.runOnUiThread(function()
                        wm.removeView(layout)
                    end)
                else
                    Toast.makeText(activity, item.." selecionada", Toast.LENGTH_SHORT).show()
                end
            end
            layout.addView(btn)
        end
        
        local lp = WindowManagerLayoutParams()
        lp.width = 300
        lp.height = WindowManagerLayoutParams.MATCH_PARENT
        lp.format = PixelFormat.TRANSLUCENT
        lp.type = WindowManagerLayoutParams.TYPE_APPLICATION_OVERLAY
        lp.flags = WindowManagerLayoutParams.FLAG_NOT_FOCUSABLE
        lp.gravity = Gravity.START
        
        wm.addView(layout, lp)
    end)
end

local btnMainLp = WindowManagerLayoutParams()
btnMainLp.width = WindowManagerLayoutParams.WRAP_CONTENT
btnMainLp.height = WindowManagerLayoutParams.WRAP_CONTENT
btnMainLp.format = PixelFormat.TRANSLUCENT
btnMainLp.type = WindowManagerLayoutParams.TYPE_APPLICATION_OVERLAY
btnMainLp.flags = WindowManagerLayoutParams.FLAG_NOT_FOCUSABLE
btnMainLp.gravity = Gravity.TOP | Gravity.LEFT
btnMainLp.x = 200
btnMainLp.y = 400

local mainLp = WindowManagerLayoutParams()
mainLp.width = 400
mainLp.height = WindowManagerLayoutParams.WRAP_CONTENT
mainLp.format = PixelFormat.TRANSLUCENT
mainLp.type = WindowManagerLayoutParams.TYPE_APPLICATION_OVERLAY
mainLp.flags = WindowManagerLayoutParams.FLAG_NOT_FOCUSABLE
mainLp.gravity = Gravity.TOP | Gravity.LEFT
mainLp.x = 150
mainLp.y = 500

activity.runOnUiThread(function()
    wm.addView(btnMain, btnMainLp)
    wm.addView(mainLayout, mainLp)
end)