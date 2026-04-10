import 'android.app.*'
import 'android.os.*'
import 'android.widget.*'
import 'android.view.*'
import 'android.content.*'

gg.setVisible(false)

function createBall()
    local wm = activity.getSystemService(Context.WINDOW_SERVICE)
    local screen = activity.getResources().getDisplayMetrics()  
    local params = luajava.new(WindowManager.LayoutParams)
    params.width = 200
    params.height = 200
    params.x = screen.widthPixels - 700
    params.y = screen.heightPixels -7000
    
    if Build.VERSION.SDK_INT >= 26 then
        params.type = WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
    else
        params.type = WindowManager.LayoutParams.TYPE_SYSTEM_ALERT
    end
    
    params.format = 1
    params.flags = bit32.bor(
        WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE,
        WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL
    )
    params.gravity = Gravity.LEFT | Gravity.TOP
    
   
    local layout = {
        LinearLayout,
        layout_width = "400dp",
        layout_height = "400dp",
        {
            CardView,
            layout_width = "match_parent",
            layout_height = "match_parent",
            radius = "200dp",
            elevation = "32dp",
            backgroundColor = "#FF6200EE",
            {
                TextView,
                text = "Batman",
                textColor = "#FFFFFF",
                textSize = "24sp",
                gravity = "center",
                layout_width = "match_parent",
                layout_height = "match_parent",
            },
        },
    }
    
    local view = loadlayout(layout)
    wm.addView(view, params)
    

    local startX, startY, paramX, paramY
    local dragging = false
    
    view.setOnTouchListener(View.OnTouchListener {
        onTouch = function(v, event)
            local action = event.getAction()
            
            if action == MotionEvent.ACTION_DOWN then
                startX = event.getRawX()
                startY = event.getRawY()
                paramX = params.x
                paramY = params.y
                dragging = false
                return true
                
            elseif action == MotionEvent.ACTION_MOVE then
                local dx = event.getRawX() - startX
                local dy = event.getRawY() - startY
                
                if math.abs(dx) > 5 or math.abs(dy) > 5 then
                    dragging = true
                end
                
                params.x = paramX + dx
                params.y = paramY + dy
                wm.updateViewLayout(view, params)
                return true               
            elseif action == MotionEvent.ACTION_UP then
                if not dragging then
                    gg.toast("done")
wm.removeView(view, params)
    
                end
                return true
            end
            
            return false
        end
    })
    
end

local handler = Handler(Looper.getMainLooper())
handler.post(function()
    pcall(createBall)
end)

