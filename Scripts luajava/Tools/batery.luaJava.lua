gg.setVisible(false)

import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "android.graphics.*"
import "android.graphics.drawable.*"
import "android.util.TypedValue"
import "android.content.Context"
import "android.view.WindowManager"
import "android.view.Gravity"
import "android.content.Intent"
import "android.content.IntentFilter"
import "android.content.BroadcastReceiver"
import "java.util.Timer"
import "java.util.TimerTask"

ctx = activity
windowManager = activity.getSystemService(Context.WINDOW_SERVICE)
batteryLayout = nil
batteryText = nil

function dp(value)
    return TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, value, activity.getResources().getDisplayMetrics())
end

function getLayoutType()
    if Build.VERSION.SDK_INT >= 26 then
        return WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
    else
        return WindowManager.LayoutParams.TYPE_PHONE
    end
end

function getBatteryLevel()
    local intentFilter = IntentFilter(Intent.ACTION_BATTERY_CHANGED)
    local batteryIntent = activity.registerReceiver(nil, intentFilter)
    if batteryIntent then
        local level = batteryIntent.getIntExtra(BatteryManager.EXTRA_LEVEL, -1)
        local scale = batteryIntent.getIntExtra(BatteryManager.EXTRA_SCALE, -1)
        if level >= 0 and scale > 0 then
            return math.floor((level * 100) / scale)
        end
    end
    return 50
end

function createBatteryFloat()
    local batteryPercent = getBatteryLevel()
    batteryLayout = LinearLayout(activity)
    batteryLayout.setOrientation(LinearLayout.HORIZONTAL)
    batteryLayout.setGravity(Gravity.CENTER_VERTICAL)
    batteryLayout.setPadding(dp(10), dp(5), dp(10), dp(5))
    
    local gradientDrawable = GradientDrawable()
    gradientDrawable.setColor(Color.parseColor("#CC000000")) 
    gradientDrawable.setCornerRadius(dp(10))
    gradientDrawable.setStroke(dp(1), Color.parseColor("#FFFF9700"))
    batteryLayout.setBackgroundDrawable(gradientDrawable)
    
    batteryText = TextView(activity)
    batteryText.setText("Batery: " .. batteryPercent .. "%")
    batteryText.setTextColor(Color.WHITE)
    batteryText.setTextSize(TypedValue.COMPLEX_UNIT_SP, 14)
    batteryText.setTypeface(Typeface.DEFAULT_BOLD)
    batteryText.setPadding(0, 0, dp(10), 0)
    
    local closeButton = Button(activity)
    closeButton.setText("OK")
    closeButton.setTextColor(Color.WHITE)
    closeButton.setBackgroundColor(Color.parseColor("#FFCC0000"))
    closeButton.setTextSize(TypedValue.COMPLEX_UNIT_SP, 12)
    closeButton.setLayoutParams(LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT))
    
    closeButton.setOnClickListener(function(view)
        if batteryLayout then
            windowManager.removeView(batteryLayout)
            batteryLayout = nil
            batteryText = nil
        end
    end)
   
    batteryLayout.addView(batteryText)
    batteryLayout.addView(closeButton)
    local windowParams = WindowManager.LayoutParams(
        WindowManager.LayoutParams.WRAP_CONTENT,
        WindowManager.LayoutParams.WRAP_CONTENT,
        getLayoutType(),
        WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE | WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS,
        PixelFormat.TRANSLUCENT
    )
    
    windowParams.gravity = Gravity.TOP | Gravity.START
    windowParams.x = 10
    windowParams.y = 10
    windowManager.addView(batteryLayout, windowParams)
end
function updateBatteryText()
    if batteryText and batteryText.isShown() then
        local batteryPercent = getBatteryLevel()
        batteryText.setText("Batery: " .. batteryPercent .. "%")
    end
end

activity.runOnUiThread(function()
    createBatteryFloat()
    local timer = Timer()
    timer.scheduleAtFixedRate(TimerTask({
        run = function()
            activity.runOnUiThread(function()
                updateBatteryText()
            end)
        end
    }), 0, 5000) 
end)


