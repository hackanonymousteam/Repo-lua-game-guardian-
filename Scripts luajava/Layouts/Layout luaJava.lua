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

local wmManager = activity.getSystemService(Context.WINDOW_SERVICE)
local Cmods_Frames, collapseView, DevTeam, Dev_cmods, BUTÃO_LAYOUT
local params
local isMenuCreated = false 

function dp(value)
  return TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, value, activity.getResources().getDisplayMetrics())
end

function showMessage(txt)
  Toast.makeText(activity, txt, Toast.LENGTH_SHORT).show()
end

function toastC4F(c, msg, textColor, textSize, bgColor, cornerRadius, position)
  activity.runOnUiThread(function()
    local c4f = Toast.makeText(c, msg, Toast.LENGTH_SHORT)
    local vw = c4f.getView()
    local textView = vw.findViewById(android.R.id.message)
    textView.setTextSize(textSize)
    textView.setTextColor(textColor)
    textView.setGravity(Gravity.CENTER)
    
    local gD = GradientDrawable()
    gD.setColor(bgColor)
    gD.setCornerRadius(cornerRadius)
    vw.setBackgroundDrawable(gD)
    vw.setPadding(15, 10, 15, 10)
    vw.setElevation(10)
    
    if position == 1 then
      c4f.setGravity(Gravity.TOP, 0, 150)
    elseif position == 2 then
      c4f.setGravity(Gravity.CENTER, 0, 0)
    elseif position == 3 then
      c4f.setGravity(Gravity.BOTTOM, 0, 150)
    end
    
    c4f.show()
  end)
end

function VerColapso()
  return Cmods_Frames == nil or collapseView.getVisibility() == View.VISIBLE
end

function removeView()
  if Cmods_Frames ~= nil and wmManager ~= nil then
    activity.runOnUiThread(function()
      wmManager.removeView(Cmods_Frames)
      Cmods_Frames = nil
      isMenuCreated = false 
    end)
  end
end

function addSwitch(name, listener)
  activity.runOnUiThread(function()
    local sw = CheckBox(activity)
    sw.setLayoutParams(LinearLayout.LayoutParams(
      LinearLayout.LayoutParams.MATCH_PARENT, 
      dp(40)
    ))
    sw.setGravity(Gravity.CENTER_VERTICAL)
    sw.getButtonDrawable().setColorFilter(Color.parseColor("#00CAFF"), PorterDuff.Mode.SRC_IN)
    sw.setText(name)
    sw.setTextColor(Color.WHITE) 
    sw.setTextSize(16.0) 
    sw.setPadding(dp(15), dp(8), dp(15), dp(8))
    sw.setTypeface(Typeface.DEFAULT_BOLD) 
    
    sw.setOnCheckedChangeListener{
      onCheckedChanged = function(buttonView, isChecked)
        listener.OnWrite(isChecked)
      end
    }
    
    local line1 = View(activity)
    local lineParams = LinearLayout.LayoutParams(
      LinearLayout.LayoutParams.MATCH_PARENT, 
      dp(1) 
    )
    line1.setLayoutParams(lineParams)
    line1.setBackgroundColor(Color.parseColor("#404040"))
    
    BUTÃO_LAYOUT.addView(sw)
    BUTÃO_LAYOUT.addView(line1)
  end)
end

function MrEzCheatsYT()
  BUTÃO_LAYOUT.removeAllViews()
  
  addSwitch("Device info", {
    OnWrite = function(isChecked)
      if isChecked then
        _speedHackPending = true
        -- Device info functionality
      end
    end
  })
  
  addSwitch("Toast color", {
    OnWrite = function(isChecked)
      if isChecked then
        toastC4F(activity, "TOAST COLORIDO", Color.CYAN, 18, Color.parseColor("#1A1A2E"), 25, 3)
      end
    end
  })
  
  addSwitch("Open alert", {
    OnWrite = function(isChecked)
      if isChecked then
        -- Open alert functionality
      end
    end
  })
  
  addSwitch("Exit", { 
    OnWrite = function(isChecked)
      if isChecked then
        removeView() 
        closeAlt()
      end
    end
  })
end

function TEKASHI_TEAM()
  if isMenuCreated then
 activity.runOnUiThread(function()
      if Cmods_Frames ~= nil then
        Cmods_Frames.setVisibility(View.VISIBLE)
        collapseView.setVisibility(View.VISIBLE)
        Dev_cmods.setVisibility(View.GONE)
        MrEzCheatsYT() 
      end
    end)
    return
  end
  
  activity.runOnUiThread(function()
  
    Cmods_Frames = FrameLayout(activity)
    local fraLayoutParams = FrameLayout.LayoutParams(
      FrameLayout.LayoutParams.WRAP_CONTENT, 
      FrameLayout.LayoutParams.WRAP_CONTENT
    )
    Cmods_Frames.setLayoutParams(fraLayoutParams)

    local Subs_Relative = RelativeLayout(activity)
    local relative_Sub = RelativeLayout.LayoutParams(
      RelativeLayout.LayoutParams.WRAP_CONTENT,
      RelativeLayout.LayoutParams.WRAP_CONTENT
    )
    Subs_Relative.setLayoutParams(relative_Sub)
    
    collapseView = RelativeLayout(activity)
    collapseView.setLayoutParams(relative_Sub)
    
    DevTeam = ImageView(activity)
    local CMODSDEV = LinearLayout.LayoutParams(dp(59), dp(59))
    DevTeam.setLayoutParams(CMODSDEV)
    DevTeam.setImageDrawable(activity.getResources().getDrawable(android.R.drawable.ic_menu_manage))
    DevTeam.setClickable(true)
    
  DevTeam.setBackgroundDrawable(createRoundedDrawable(Color.parseColor("#16213E"), 15))
    DevTeam.setPadding(dp(10), dp(10), dp(10), dp(10))
    DevTeam.setElevation(dp(8))
    
    collapseView.addView(DevTeam)
    
    DevTeam.setOnClickListener{
      onClick = function(view)
        if Dev_cmods.getVisibility() == View.VISIBLE then
          Dev_cmods.setVisibility(View.GONE)
          collapseView.setVisibility(View.VISIBLE)
        else
          collapseView.setVisibility(View.GONE)
          Dev_cmods.setVisibility(View.VISIBLE)
        end
      end
    }
        
    Dev_cmods = LinearLayout(activity)
    Dev_cmods.setVisibility(View.GONE)
    Dev_cmods.setAlpha(0.95) 
    Dev_cmods.setGravity(Gravity.CENTER)
    Dev_cmods.setOrientation(LinearLayout.VERTICAL)
    Dev_cmods.setLayoutParams(LinearLayout.LayoutParams(dp(350), dp(350)))
    
   Dev_cmods.setBackgroundDrawable(createRoundedDrawable(Color.parseColor("#1A1A2E"), 20))
    Dev_cmods.setElevation(dp(16))
    
    local relativeLayout = LinearLayout(activity)
    relativeLayout.setLayoutParams(LinearLayout.LayoutParams(dp(205), dp(54)))
    relativeLayout.setPadding(dp(10), dp(10), dp(10), dp(10))
    relativeLayout.setGravity(Gravity.CENTER)
    relativeLayout.setOrientation(LinearLayout.HORIZONTAL)
    relativeLayout.setBackgroundDrawable(createRoundedDrawable(Color.parseColor("#0F3460"), 15))
    
    local close_menu = TextView(activity)
    local layoutParams = LinearLayout.LayoutParams(dp(205), dp(95))
    layoutParams.gravity = Gravity.CENTER
    close_menu.setLayoutParams(layoutParams)

    close_menu.setText("Hide")
    close_menu.setGravity(Gravity.CENTER)
    close_menu.setTextColor(Color.WHITE)
    close_menu.setTextSize(16)
    close_menu.setTypeface(Typeface.DEFAULT_BOLD)
    close_menu.setBackgroundDrawable(createRoundedDrawable(Color.parseColor("#16213E"), 12))
    close_menu.setPadding(0, dp(10), 0, dp(10))
    
    relativeLayout.addView(close_menu)

    close_menu.setOnClickListener{
      onClick = function(view)
        collapseView.setVisibility(View.VISIBLE)
        Dev_cmods.setVisibility(View.GONE)
      end
    }
    
    local Layout_Principal = LinearLayout(activity)
    local layout_LinearLayout_Principal = LinearLayout.LayoutParams(dp(205), dp(205))
    Layout_Principal.setLayoutParams(layout_LinearLayout_Principal)
    Layout_Principal.setOrientation(LinearLayout.VERTICAL)
    Layout_Principal.setBackgroundDrawable(createRoundedDrawable(Color.parseColor("#0F3460"), 15))
    
    local deslizamento = ScrollView(activity)
    local scrollView_Params = LinearLayout.LayoutParams(dp(205), dp(205))
    deslizamento.setLayoutParams(scrollView_Params)
    deslizamento.setVerticalScrollBarEnabled(false) 
    
    local Borda_do_Titulo = LinearLayout(activity)
    Borda_do_Titulo.setLayoutParams(LinearLayout.LayoutParams(dp(205), dp(54)))
    Borda_do_Titulo.setGravity(Gravity.CENTER)
    Borda_do_Titulo.setBackgroundDrawable(createRoundedDrawable(Color.parseColor("#E94560"), 15))
    Borda_do_Titulo.setPadding(0, 0, 0, dp(5))
    
    local Titulo_do_Menu = TextView(activity)
    local layoutParamsxx = LinearLayout.LayoutParams(160, dp(54))
    Titulo_do_Menu.setLayoutParams(layoutParamsxx)
    Titulo_do_Menu.setText("Inject")
    Titulo_do_Menu.setTextColor(Color.WHITE)
    Titulo_do_Menu.setTypeface(Typeface.DEFAULT_BOLD)
    Titulo_do_Menu.setTextSize(22.0)
    Titulo_do_Menu.setPadding(10, 10, 10, 15)
    Titulo_do_Menu.setGravity(Gravity.CENTER)
    Borda_do_Titulo.addView(Titulo_do_Menu)
    
    local borda_1 = LinearLayout(activity)
    borda_1.setLayoutParams(LinearLayout.LayoutParams(dp(205), dp(3)))
    borda_1.setBackgroundColor(Color.parseColor("#E94560")) 
    borda_1.setPadding(0, 0, 0, 10)
    
    local CoRingaModz_YT = LinearLayout(activity)
    CoRingaModz_YT.setLayoutParams(LinearLayout.LayoutParams(
      LinearLayout.LayoutParams.MATCH_PARENT, 
      100
    ))
    CoRingaModz_YT.setOrientation(LinearLayout.VERTICAL)
    
    local borda_2 = LinearLayout(activity)
    borda_2.setLayoutParams(LinearLayout.LayoutParams(dp(205), dp(3)))
    borda_2.setBackgroundColor(Color.parseColor("#E94560")) 
    borda_2.setPadding(0, 0, 0, 10)
    
    BUTÃO_LAYOUT = LinearLayout(activity)
    BUTÃO_LAYOUT.setLayoutParams(LinearLayout.LayoutParams(dp(205), dp(200)))
    BUTÃO_LAYOUT.setOrientation(LinearLayout.VERTICAL)
    BUTÃO_LAYOUT.setPadding(dp(10), dp(10), dp(10), dp(10))
    
    CoRingaModz_YT.addView(BUTÃO_LAYOUT)
    Dev_cmods.addView(Borda_do_Titulo)
    Dev_cmods.addView(borda_1)
    deslizamento.addView(CoRingaModz_YT)
    Layout_Principal.addView(deslizamento)
    Dev_cmods.addView(Layout_Principal)
    Dev_cmods.addView(borda_2)
    Subs_Relative.addView(collapseView)
    Dev_cmods.addView(relativeLayout)
    Subs_Relative.addView(Dev_cmods)
    Cmods_Frames.addView(Subs_Relative)
    
    MrEzCheatsYT()
    
    local flag
    if Build.VERSION.SDK_INT > Build.VERSION_CODES.N_MR1 then
      flag = WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
    else
      flag = WindowManager.LayoutParams.TYPE_PHONE
    end
    
    params = WindowManager.LayoutParams(
      WindowManager.LayoutParams.WRAP_CONTENT,
      WindowManager.LayoutParams.WRAP_CONTENT,
      flag, 
      WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE,
      PixelFormat.TRANSLUCENT
    )
    params.gravity = Gravity.TOP | Gravity.LEFT
    params.x = 0
    params.y = 100
    
    wmManager.addView(Cmods_Frames, params)
    
    Cmods_Frames.setOnTouchListener{
      initialX = 0,
      initialY = 0,
      initialTouchX = 0,
      initialTouchY = 0,
      isLongClick = false,
      handler_longClick = Handler(),
      
      runnable_longClick = function()
        isLongClick = true
        Close_segurar()
      end,
      
      onTouch = function(v, event)
        local action = event.getAction()
        
        if action == MotionEvent.ACTION_DOWN then
          initialX = params.x
          initialY = params.y
          initialTouchX = event.getRawX()
          initialTouchY = event.getRawY()
          handler_longClick.postDelayed(runnable_longClick, 2000)
          return true
          
        elseif action == MotionEvent.ACTION_UP then
          local Xdiff = event.getRawX() - initialTouchX
          local Ydiff = event.getRawY() - initialTouchY
          handler_longClick.removeCallbacks(runnable_longClick)
          
          if Xdiff < 10 and Ydiff < 10 then
            if VerColapso() then
              collapseView.setVisibility(View.GONE)
              Dev_cmods.setVisibility(View.VISIBLE)
            end
          end
          return true
          
        elseif action == MotionEvent.ACTION_MOVE then
          params.x = initialX + (event.getRawX() - initialTouchX)
          params.y = initialY + (event.getRawY() - initialTouchY)
          wmManager.updateViewLayout(Cmods_Frames, params)
          return true
        end
        
        return false
      end
    }
    
    isMenuCreated = true 
  end)
end

function createRoundedDrawable(color, radius)
  local gd = GradientDrawable()
  gd.setColor(color)
  gd.setCornerRadius(dp(radius))
  return gd
end

function closeAlt()
  shouldExit = true 
end

XGCK1 = -1
shouldExit = false

while true do
  if shouldExit then 
    removeView()    break 
  end
  
  if gg.isVisible(true) then
    XGCK1 = 1
    gg.setVisible(false)
    gg.clearResults()
  end
  
  if _speedHackPending then
    _speedHackPending = false
    gg.setRanges(gg.REGION_CODE_APP)
    gg.searchNumber("-0.50344371796;9.99999997e-7;-0.50291442871::9", gg.TYPE_FLOAT)
    gg.refineNumber("9.99999997e-7", gg.TYPE_FLOAT)
    gg.getResults(100)
    gg.editAll("-1", gg.TYPE_FLOAT)
    gg.clearResults()
    gg.toast("HACK ATIVADO")
  end
  
  if XGCK1 == 1 then    
    TEKASHI_TEAM()
  end  
  XGCK1 = -1
  gg.sleep(100)
end