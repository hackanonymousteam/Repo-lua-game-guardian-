gg.setVisible(false)

import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "android.webkit.*"
import "android.graphics.*"
import "android.content.*"
import "android.util.*"

-- Get screen dimensions
display = activity.getWindowManager().getDefaultDisplay()
size = Point()
display.getSize(size)
screenWidth = size.x
screenHeight = size.y
local WEBVIEW_WIDTH = 500  -- Largura reduzida em pixels
local WEBVIEW_HEIGHT = 900 -- Altura em pixels
local BUTTON_HEIGHT = 48   -- Altura dos botões em dp
local MARGIN = 5         -- Margem em dp

bCUI = luajava.bindClass
Context = bCUI("android.content.Context")
PixelFormat = bCUI("android.graphics.PixelFormat")
WindowManagerLayoutParams = bCUI("android.view.WindowManager$LayoutParams")
Gravity = bCUI("android.view.Gravity")
Build = bCUI("android.os.Build")
wm = activity.getSystemService(Context.WINDOW_SERVICE)

-- Function to create and show the WebView overlay
local function showWebView()
    -- Main layout that will contain both WebView and controls
    mainLayout = FrameLayout(activity)
    mainLayout.setBackgroundColor(Color.argb(150, 0, 0, 0))
    
    -- Container do WebView e controles
    container = LinearLayout(activity)
    container.setOrientation(LinearLayout.VERTICAL)
    container.setBackgroundColor(Color.WHITE)
    container.setElevation(dpToPx(8))
    
    -- LayoutParams para o container
    local containerParams = FrameLayout.LayoutParams(
        WEBVIEW_WIDTH,
        WEBVIEW_HEIGHT + dpToPx(BUTTON_HEIGHT) + dpToPx(MARGIN))
    containerParams.gravity = Gravity.CENTER
    container.setLayoutParams(containerParams)
    -- WebView configuration (FULL SCREEN)
    
    
    
mainLayout.setOnTouchListener(View.OnTouchListener{
        onTouch = function(v, event)
            local action = event.getAction()
            if action == MotionEvent.ACTION_DOWN then
                initialX = containerParams.x
                initialY = containerParams.y
                initialTouchX = event.getRawX()
                initialTouchY = event.getRawY()
                return true
            elseif action == MotionEvent.ACTION_MOVE then
                containerParams.x = initialX + (event.getRawX() - initialTouchX)
                containerParams.y = initialY + (event.getRawY() - initialTouchY)
                wm.updateViewLayout(mainLayout, lp)
                return true
            end
            return false
        end
    })
    
    
    
    
    webView = WebView(activity)
    webView.setLayoutParams(FrameLayout.LayoutParams(
        FrameLayout.LayoutParams.WRAP_CONTENT,
        FrameLayout.LayoutParams.WRAP_CONTENT))
    
    -- Enable JavaScript and other settings
    webSettings = webView.getSettings()
    webSettings.setJavaScriptEnabled(true)
    webSettings.setDomStorageEnabled(true)
    webSettings.setDatabaseEnabled(true)
    webSettings.setLoadWithOverviewMode(true)
    webSettings.setUseWideViewPort(true)
    webSettings.setBuiltInZoomControls(true)
    webSettings.setDisplayZoomControls(false)
    webSettings.setSupportZoom(true)
    webSettings.setDefaultFontSize(16)
    webSettings.setCacheMode(WebSettings.LOAD_DEFAULT)
    
    -- Enable text selection and proper rendering
    webView.setWebChromeClient(WebChromeClient())
    webView.setWebViewClient(WebViewClient())
    
    -- Load URL
    webView.loadUrl("https://youtu.be/QQDcOFBLzi4?si=is8M_YwiQnGIeBwt") -- Change to your desired URL
    
    -- Control panel (floating buttons)
    controls = LinearLayout(activity)
    controls.setOrientation(LinearLayout.HORIZONTAL)
    controls.setGravity(Gravity.CENTER)
    controls.setBackgroundResource(android.R.drawable.dialog_holo_light_frame)
    controls.setElevation(dpToPx(8))
    
    -- Layout parameters for controls (positioned at bottom)
    controlsLayoutParams = FrameLayout.LayoutParams(
        FrameLayout.LayoutParams.MATCH_PARENT,
        dpToPx(48),
        Gravity.BOTTOM)
    controls.setLayoutParams(controlsLayoutParams)
    
    -- Close button
    closeBtn = createButton("×", "#FF5252", function()
        wm.removeView(mainLayout)
        os.exit()
    end)
    
    -- Refresh button
    refreshBtn = createButton("↻", "#2196F3", function()
        webView.reload()
    end)
    
    -- Back button
    backBtn = createButton("←", "#9C27B0", function()
        if webView.canGoBack() then
            webView.goBack()
        end
    end)
    
    -- Forward button
    forwardBtn = createButton("→", "#9C27B0", function()
        if webView.canGoForward() then
            webView.goForward()
        end
    end)
    
    -- Copy button
    copyBtn = createButton("C", "#4CAF50", function()
        webView.evaluateJavascript(
            "(function(){return window.getSelection().toString()})();",
            {
                onReceiveValue = function(text)
                    if text ~= "null" and #text > 2 then
                        text = text:sub(2,-2) -- Remove quotes
                        clipboard = activity.getSystemService(Context.CLIPBOARD_SERVICE)
                        clip = ClipData.newPlainText("Copied Text", text)
                        clipboard.setPrimaryClip(clip)
                        Toast.makeText(activity, "Texto copiado!", Toast.LENGTH_SHORT).show()
                    else
                        Toast.makeText(activity, "Selecione texto primeiro", Toast.LENGTH_SHORT).show()
                    end
                end
            }
        )
    end)
    
    -- Add buttons to controls panel
    controls.addView(backBtn)
    controls.addView(forwardBtn)
    controls.addView(refreshBtn)
    controls.addView(copyBtn)
    controls.addView(closeBtn)
    
    -- Add views to main layout
    mainLayout.addView(webView)
    mainLayout.addView(controls)


-- Configurações de tamanho (no início do script)
local WEBVIEW_WIDTH_PX = 600   -- Largura em pixels
local WEBVIEW_HEIGHT_PX = 700  -- Altura em pixels
local USE_PERCENTAGE = false   -- Se true, usa porcentagem em vez de pixels fixos
local WIDTH_PERCENT = 0.8      -- 80% da largura
local HEIGHT_PERCENT = 0.6     -- 60% da altura

-- No seu código onde define os parâmetros:
lp = WindowManagerLayoutParams()

if USE_PERCENTAGE then
    display = activity.getWindowManager().getDefaultDisplay()
    size = Point()
    display.getSize(size)
    lp.width = math.floor(size.x * WIDTH_PERCENT)
    lp.height = math.floor(size.y * HEIGHT_PERCENT)
else
    lp.width = WEBVIEW_WIDTH_PX
    lp.height = WEBVIEW_HEIGHT_PX
end

lp.format = PixelFormat.TRANSLUCENT



    -- Window parameters (FULL SCREEN)

    if Build.VERSION.SDK_INT >= 26 then
        lp.type = 2038 -- TYPE_APPLICATION_OVERLAY
    else
        lp.type = 2002 -- TYPE_PHONE
    end
    
    lp.flags = WindowManagerLayoutParams.FLAG_NOT_FOCUSABLE |
               WindowManagerLayoutParams.FLAG_LAYOUT_IN_SCREEN |
               WindowManagerLayoutParams.FLAG_LAYOUT_NO_LIMITS
    
    lp.gravity = Gravity.CENTER
    
    -- Add to window manager
    wm.addView(mainLayout, lp)
end

-- Helper function to create styled buttons
function createButton(text, color, onClick)
    local btn = Button(activity)
    btn.setText(text)
    btn.setTextColor(Color.WHITE)
    btn.setBackgroundColor(Color.parseColor(color))
    btn.setLayoutParams(LinearLayout.LayoutParams(
        dpToPx(48),
        dpToPx(48),
        1))
    btn.setOnClickListener(View.OnClickListener{
        onClick = onClick
    })
    return btn
end

-- Convert dp to pixels
function dpToPx(dp)
    return TypedValue.applyDimension(
        TypedValue.COMPLEX_UNIT_DIP, 
        dp, 
        activity.getResources().getDisplayMetrics())
end

-- Run on UI thread
activity.runOnUiThread(showWebView)

-- Keep script alive
--while true do os.execute("sleep 1") end