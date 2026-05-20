

if luajava == nil then gg.alert(' unavaliable please use gameguardian mod (suport luajava)') else end

if not activity then
    gg.alert("No activity available")
    return
end

local TypedValue = luajava.bindClass("android.util.TypedValue")
local Gravity = luajava.bindClass("android.view.Gravity")
local PixelFormat = luajava.bindClass("android.graphics.PixelFormat")
local Color = luajava.bindClass("android.graphics.Color")
local View = luajava.bindClass("android.view.View")
local MotionEvent = luajava.bindClass("android.view.MotionEvent")
local WindowManager = luajava.bindClass("android.view.WindowManager")
local Context = luajava.bindClass("android.content.Context")
local Build = luajava.bindClass("android.os.Build")
local WebView = luajava.bindClass("android.webkit.WebView")
local WebViewClient = luajava.bindClass("android.webkit.WebViewClient")
local WebChromeClient = luajava.bindClass("android.webkit.WebChromeClient")
local Handler = luajava.bindClass("android.os.Handler")
local Looper = luajava.bindClass("android.os.Looper")

local TRANSPARENT = Color.parseColor("#00000000")

local function dp(v)
    local resources = activity.getResources()
    if resources then
        return TypedValue.applyDimension(
            TypedValue.COMPLEX_UNIT_DIP,
            v,
            resources.getDisplayMetrics()
        )
    else
        return v * 3
    end
end

local windowManager
local webView
local layoutParams

local isExpanded = true
local currentPage = "styles"
local dragMode = false
local dragStartX, dragStartY = 0, 0
local initialMenuX, initialMenuY = 0, 0

local menuXPx = dp(0)
local menuYPx = dp(100)

local MENU_WIDTH_PX = dp(300)
local MENU_HEIGHT_PX = dp(320)
local TOGGLE_SIZE_PX = dp(45)
local GROUPS_WIDTH_PX = dp(90)

local menuState = {
    autoKill = false,
    exploseAll = false,
    disableHotbar = false,
    stopMovement = false,
    autoJump = false,
    exploseVehicles = false,
    deleteVehicles = false,
    lockVehicles = false,
    breakControl = false,
    driveAll = false,
    opacity = 10,
    bgColor = "#000000",
    colorPreset = "orange"
}

local themeColors = { r = 255, g = 165, b = 0 }

local colorPresets = {
    { name = "Orange", r = 255, g = 165, b = 0 },
    { name = "Red", r = 255, g = 50, b = 50 },
    { name = "Blue", r = 50, g = 150, b = 255 },
    { name = "Green", r = 50, g = 255, b = 50 },
    { name = "Purple", r = 180, g = 50, b = 255 }
}

local GROUPS = {
    { name = "styles", display = "Styles" },
    { name = "players", display = "Players" },
    { name = "vehicles", display = "Vehicles" },
    { name = "info", display = "Info" },
    { name = "exit", display = "Exit" }
}

local function hitTest(rawX, rawY)
    if rawX < menuXPx or rawX > menuXPx + MENU_WIDTH_PX or
       rawY < menuYPx or rawY > menuYPx + MENU_HEIGHT_PX then
        return nil
    end
    
    local localX = rawX - menuXPx
    local localY = rawY - menuYPx
    
    if localX <= TOGGLE_SIZE_PX and localY <= TOGGLE_SIZE_PX then
        return { type = "toggle" }
    end
    
    if not isExpanded then
        return nil
    end
    
    if localX <= GROUPS_WIDTH_PX and localY >= dp(50) and localY <= dp(280) then
        local groupIndex = math.floor((localY - dp(50)) / dp(42)) + 1
        if groupIndex >= 1 and groupIndex <= #GROUPS then
            return {
                type = "group",
                name = GROUPS[groupIndex].name,
                display = GROUPS[groupIndex].display
            }
        end
    end
    
    if localX > GROUPS_WIDTH_PX and localY >= dp(100) then
        local elementY = localY - dp(100)
        local rowHeight = dp(62)
        local rowIndex = math.floor(elementY / rowHeight)
        
        if currentPage == "styles" then
            if rowIndex == 0 then
                return { type = "slider", action = "setOpacity", label = "Opacity", value = menuState.opacity }
            elseif rowIndex == 1 then
                return { type = "input", action = "setBGColor", label = "BG Color" }
            elseif rowIndex >= 2 and rowIndex < 7 then
                local presetIndex = rowIndex - 1
                if presetIndex <= #colorPresets then
                    return { type = "checkbox", action = "setColorPreset" .. presetIndex, label = colorPresets[presetIndex].name }
                end
            end
            
        elseif currentPage == "players" then
            local items = {
                { action = "toggleAutoKill", label = "Auto Kill" },
                { action = "toggleExploseAll", label = "Explode All" },
                { action = "toggleDisableHotbar", label = "Disable Hotbar" },
                { action = "toggleStopMovement", label = "Stop Movement" },
                { action = "toggleAutoJump", label = "Auto Jump" }
            }
            if rowIndex < 5 then
                return { type = "checkbox", action = items[rowIndex + 1].action, label = items[rowIndex + 1].label }
            end
            
        elseif currentPage == "vehicles" then
            local items = {
                { action = "toggleExploseVehicles", label = "Explode Vehicles" },
                { action = "toggleDeleteVehicles", label = "Delete Vehicles" },
                { action = "toggleLockVehicles", label = "Lock Vehicles" },
                { action = "toggleBreakControl", label = "Break Control" },
                { action = "toggleDriveAll", label = "Drive All" }
            }
            if rowIndex < 5 then
                return { type = "checkbox", action = items[rowIndex + 1].action, label = items[rowIndex + 1].label }
            end
            
        elseif currentPage == "info" then
            return nil
            
        elseif currentPage == "exit" then
            return { type = "exit" }
        end
    end
    
    return nil
end

local function executeAutoKill()
_wall = true
    gg.toast("Auto Kill Activated")
    
end

local function executeExploseAll()
    gg.toast("Explode All Activated")
end

local function executeDisableHotbar()
    gg.toast("Disable Hotbar Activated")
end

local function executeStopMovement()
    gg.toast("Stop Movement Activated")
end

local function executeAutoJump()
    gg.toast("Auto Jump Activated")
end

local function executeExploseVehicles()
    gg.toast("Explode Vehicles Activated")
end

local function executeDeleteVehicles()
    gg.toast("Delete Vehicles Activated")
end

local function executeLockVehicles()
    gg.toast("Lock Vehicles Activated")
end

local function executeBreakControl()
    gg.toast("Break Control Activated")
end

local function executeDriveAll()
    gg.toast("Drive All Activated")
end

local function toggleState(key, label)
    menuState[key] = not menuState[key]
    local status = menuState[key] and "✅" or "❌"
    
    if menuState[key] then
        if key == "autoKill" then executeAutoKill()
        elseif key == "exploseAll" then executeExploseAll()
        elseif key == "disableHotbar" then executeDisableHotbar()
        elseif key == "stopMovement" then executeStopMovement()
        elseif key == "autoJump" then executeAutoJump()
        elseif key == "exploseVehicles" then executeExploseVehicles()
        elseif key == "deleteVehicles" then executeDeleteVehicles()
        elseif key == "lockVehicles" then executeLockVehicles()
        elseif key == "breakControl" then executeBreakControl()
        elseif key == "driveAll" then executeDriveAll()
        end
    else
        gg.toast(label .. " Disabled")
    end
    
    local js = string.format([[
        (function() {
            var labels = document.querySelectorAll('.checkbox-label');
            for(var i = 0; i < labels.length; i++) {
                if(labels[i].textContent.trim() === '%s') {
                    var parent = labels[i].parentElement;
                    if(parent) {
                        var cb = parent.querySelector('.checkbox');
                        if(cb) cb.textContent = '%s';
                    }
                }
            }
        })();
    ]], label, status)
    
    pcall(function() webView.evaluateJavascript(js, nil) end)
end

local function applyColorPreset(preset)
    themeColors.r = preset.r
    themeColors.g = preset.g
    themeColors.b = preset.b
    menuState.colorR = preset.r
    menuState.colorG = preset.g
    menuState.colorB = preset.b
    
    local js = string.format([[
        (function() {
            var r = %d, g = %d, b = %d;
            var color = 'rgb(' + r + ',' + g + ',' + b + ')';
            document.documentElement.style.setProperty('--primary-color', color);
            
            var checkboxes = document.querySelectorAll('.checkbox');
            var labels = document.querySelectorAll('.checkbox-label');
            for(var i = 0; i < labels.length; i++) {
                if(labels[i].textContent.trim() === '%s') {
                    checkboxes[i].textContent = '✅';
                } else if(labels[i].textContent.includes('Orange') || 
                          labels[i].textContent.includes('Red') || 
                          labels[i].textContent.includes('Blue') || 
                          labels[i].textContent.includes('Green') || 
                          labels[i].textContent.includes('Purple')) {
                    checkboxes[i].textContent = '❌';
                }
            }
        })();
    ]], themeColors.r, themeColors.g, themeColors.b, preset.name)
    
    pcall(function() webView.evaluateJavascript(js, nil) end)
    gg.toast("Theme Color: " .. preset.name)
end

local LuaActions = {
    toggle = function()
        isExpanded = not isExpanded
        local js = isExpanded and 
            "document.getElementById('menuPanel').style.display = 'block';" or
            "document.getElementById('menuPanel').style.display = 'none';"
        pcall(function() webView.evaluateJavascript(js, nil) end)
    end,
    
    switchPage = function(pageName, displayName)
        currentPage = pageName
        local js = string.format([[
            (function() {
                document.getElementById('pageTitle').textContent = '%s';
                var pages = document.querySelectorAll('.page');
                for(var i = 0; i < pages.length; i++) {
                    pages[i].style.display = 'none';
                }
                var active = document.querySelector('.page-%s');
                if(active) active.style.display = 'block';
            })();
        ]], displayName, pageName)
        pcall(function() webView.evaluateJavascript(js, nil) end)
        gg.toast(displayName)
    end,
    
    setOpacity = function(v)
        local val = tonumber(v) or 10
        menuState.opacity = val
        webView.setAlpha(val / 10)
        gg.toast("Opacity: " .. val)
        
        local js = string.format([[
            (function() {
                var sliders = document.querySelectorAll('input[type="range"]');
                for(var i = 0; i < sliders.length; i++) {
                    var label = sliders[i].parentElement.querySelector('.slider-label');
                    if(label && label.textContent.trim() === 'Opacity') {
                        sliders[i].value = %d;
                    }
                }
            })();
        ]], val)
        pcall(function() webView.evaluateJavascript(js, nil) end)
    end,
    
    setBGColor = function()
        --gg.prompt({"Enter Background Color (hex):"}, {menuState.bgColor}, {"text"})
    end,
    
    setColorPreset1 = function() applyColorPreset(colorPresets[1]) end,
    setColorPreset2 = function() applyColorPreset(colorPresets[2]) end,
    setColorPreset3 = function() applyColorPreset(colorPresets[3]) end,
    setColorPreset4 = function() applyColorPreset(colorPresets[4]) end,
    setColorPreset5 = function() applyColorPreset(colorPresets[5]) end,
    
    toggleAutoKill = function() toggleState("autoKill", "Auto Kill") end,
    toggleExploseAll = function() toggleState("exploseAll", "Explode All") end,
    toggleDisableHotbar = function() toggleState("disableHotbar", "Disable Hotbar") end,
    toggleStopMovement = function() toggleState("stopMovement", "Stop Movement") end,
    toggleAutoJump = function() toggleState("autoJump", "Auto Jump") end,
    
    toggleExploseVehicles = function() toggleState("exploseVehicles", "Explode Vehicles") end,
    toggleDeleteVehicles = function() toggleState("deleteVehicles", "Delete Vehicles") end,
    toggleLockVehicles = function() toggleState("lockVehicles", "Lock Vehicles") end,
    toggleBreakControl = function() toggleState("breakControl", "Break Control") end,
    toggleDriveAll = function() toggleState("driveAll", "Drive All") end,
    
    exit = function()
        if windowManager and webView then
            pcall(function() windowManager.removeView(webView) end)
            webView = nil
        end
        gg.toast("Menu Closed!")
    end
}

local function getMenuHTML()
    return [[
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
  <style>
    :root {
      --primary-color: rgb(255, 165, 0);
    }
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }
    body {
      width: 360px;
      height: 320px;
      background: transparent;
      font-family: monospace;
      font-size: 12px;
      color: white;
      user-select: none;
      overflow: hidden;
    }
    #menuToggle {
      position: absolute;
      left: 0;
      top: 0;
      width: 45px;
      height: 45px;
      display: flex;
      align-items: center;
      justify-content: center;
      background: rgba(0,0,0,0.95);
      border: 3px solid var(--primary-color);
      border-radius: 8px;
      color: var(--primary-color);
      font-weight: bold;
      font-size: 16px;
      box-shadow: 0 0 12px var(--primary-color);
      z-index: 10;
      cursor: move;
    }
    #menuPanel {
      position: absolute;
      left: 0;
      top: 0;
      width: 360px;
      height: 320px;
      background: rgba(0,0,0,0.95);
      border: 3px solid var(--primary-color);
      border-radius: 8px;
      box-shadow: 0 0 15px var(--primary-color);
      display: block;
    }
    .menu-header {
      position: absolute;
      left: 55px;
      top: 12px;
      color: var(--primary-color);
      font-size: 18px;
      font-weight: bold;
      text-shadow: 0 0 8px var(--primary-color);
    }
    #groupsPanel {
      position: absolute;
      left: 5px;
      top: 55px;
      width: 90px;
      height: 250px;
      border: 2px solid var(--primary-color);
      border-radius: 5px;
      background: rgba(10,10,10,0.9);
      overflow-y: auto;
      padding: 5px;
    }
    .group-item {
      color: var(--primary-color);
      background: linear-gradient(90deg, #000, #2a2a2a);
      border: 2px solid var(--primary-color);
      border-radius: 5px;
      padding: 12px 5px;
      margin: 3px 0;
      text-align: center;
      font-size: 13px;
      font-weight: bold;
      cursor: pointer;
      transition: all 0.2s;
    }
    .group-item:hover {
      background: var(--primary-color);
      color: black;
    }
    #pagesPanel {
      position: absolute;
      left: 100px;
      top: 55px;
      width: 250px;
      height: 250px;
      border: 2px solid var(--primary-color);
      border-radius: 5px;
      background: rgba(10,10,10,0.9);
      display: flex;
      flex-direction: column;
    }
    #pageTitle {
      color: var(--primary-color);
      background: linear-gradient(90deg, #1a1a1a, #2a2a2a);
      padding: 8px;
      text-align: center;
      border-bottom: 2px solid var(--primary-color);
      font-weight: bold;
      font-size: 15px;
      flex-shrink: 0;
    }
    #pagesContainer {
      flex: 1;
      overflow-y: auto;
      padding: 8px;
    }
    
    #pagesContainer::-webkit-scrollbar,
    #groupsPanel::-webkit-scrollbar {
      width: 6px;
    }
    #pagesContainer::-webkit-scrollbar-track,
    #groupsPanel::-webkit-scrollbar-track {
      background: #111;
      border-radius: 3px;
    }
    #pagesContainer::-webkit-scrollbar-thumb,
    #groupsPanel::-webkit-scrollbar-thumb {
      background: var(--primary-color);
      border-radius: 3px;
    }
    
    .page {
      display: none;
    }
    .page-styles {
      display: block;
    }
    .menu-row {
      display: flex;
      align-items: center;
      padding: 6px 5px;
      margin: 3px 0;
      border: 2px solid #444;
      border-radius: 5px;
      background: rgba(0,0,0,0.5);
      min-height: 35px;
    }
    .checkbox {
      width: 22px;
      height: 22px;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      background: #0a0a0a;
      border: 2px solid var(--primary-color);
      border-radius: 5px;
      margin-right: 8px;
      color: var(--primary-color);
      font-size: 14px;
      flex-shrink: 0;
    }
    .checkbox-label {
      color: #eee;
      font-size: 12px;
      flex: 1;
    }
    input[type="range"] {
      -webkit-appearance: none;
      width: 100px;
      height: 6px;
      background: #1a1a1a;
      border: 2px solid var(--primary-color);
      border-radius: 5px;
      margin-left: 8px;
      flex-shrink: 0;
      pointer-events: auto;
    }
    input[type="range"]::-webkit-slider-thumb {
      -webkit-appearance: none;
      width: 18px;
      height: 18px;
      background: var(--primary-color);
      border-radius: 50%;
      border: 2px solid white;
      cursor: pointer;
    }
    input[type="text"] {
      width: 80px;
      background: #0a0a0a;
      border: 2px solid var(--primary-color);
      color: var(--primary-color);
      padding: 5px 6px;
      font-size: 11px;
      margin-left: 8px;
      border-radius: 5px;
    }
    .slider-label {
      color: var(--primary-color);
      margin-right: 6px;
      font-size: 11px;
      min-width: 50px;
      font-weight: bold;
    }
    .color-preset-row {
      display: flex;
      align-items: center;
      padding: 6px 5px;
      margin: 3px 0;
      border: 2px solid #444;
      border-radius: 5px;
      background: rgba(0,0,0,0.5);
      min-height: 35px;
    }
    .color-preview {
      width: 20px;
      height: 20px;
      border-radius: 4px;
      margin-right: 8px;
      border: 2px solid var(--primary-color);
    }
    .info-text {
      color: #ccc;
      font-size: 11px;
      padding: 12px;
      line-height: 1.6;
    }
    .info-text b {
      color: var(--primary-color);
    }
  </style>
</head>
<body>

  <div id="menuPanel">
    <div class="menu-header">BATMAN v2.0</div>
    
    <div id="groupsPanel">
      <div class="group-item">Players</div>
      <div class="group-item">Vehicle</div>
      <div class="group-item">Exit</div>
  </div>
    
    <div id="pagesPanel">
      <div id="pageTitle">info</div>
      <div id="pagesContainer">
        
          <div class="info-text">
            <b>Batman Mod Menu v2.0</b><br><br>
            Created: 11/06/2025<br>
            Owner: Batman Games<br>
            
            <span style="color: #0f0;">Update 2.0 Released!</span><br><br>
            <span style="color: var(--primary-color);">
              © copyright 2026
            </span>
          </div>
        </div>
        <div class="page page-players">
          <div class="menu-row"><span class="checkbox">❌</span><span class="checkbox-label">Auto Kill</span></div>
          <div class="menu-row"><span class="checkbox">❌</span><span class="checkbox-label">Explode All</span></div>
          <div class="menu-row"><span class="checkbox">❌</span><span class="checkbox-label">Disable Hotbar</span></div>
          <div class="menu-row"><span class="checkbox">❌</span><span class="checkbox-label">Stop Movement</span></div>
          <div class="menu-row"><span class="checkbox">❌</span><span class="checkbox-label">Auto Jump</span></div>
        </div>
        
        <div class="page page-vehicles">
          <div class="menu-row"><span class="checkbox">❌</span><span class="checkbox-label">Explode Vehicles</span></div>
          <div class="menu-row"><span class="checkbox">❌</span><span class="checkbox-label">Delete Vehicles</span></div>
          <div class="menu-row"><span class="checkbox">❌</span><span class="checkbox-label">Lock Vehicles</span></div>
          <div class="menu-row"><span class="checkbox">❌</span><span class="checkbox-label">Break Control</span></div>
          <div class="menu-row"><span class="checkbox">❌</span><span class="checkbox-label">Drive All</span></div>
        </div>
        
        <div class="page page-info">
            <div class="info-text">
            <b>Batman Mod Menu v2.0</b><br><br>
            Created: 11/06/2025<br>
            Owner: Batman Games<br>
            
            <span style="color: #0f0;">Update 2.0 Released!</span><br><br>
            <span style="color: var(--primary-color);">
              © copyright 2026
            </span>
          </div>
        </div>
        
        <div class="page page-exit">
          <div style="padding: 30px; text-align: center;">
            <div style="color: #f00; font-size: 20px; font-weight: bold; margin-bottom: 15px;">EXIT</div>
            <div style="color: var(--primary-color); font-size: 12px;">
              Click anywhere to close<br>
              the menu
            </div>
          </div>
        </div>
        
      </div>
    </div>
  </div>
  
  <script>
    document.querySelectorAll('input[type="range"]').forEach(function(slider) {
      slider.addEventListener('input', function(e) {
        e.stopPropagation();
      });
      
      slider.addEventListener('touchstart', function(e) {
        e.stopPropagation();
      });
      
      slider.addEventListener('touchmove', function(e) {
        e.stopPropagation();
        var touch = e.touches[0];
        var rect = this.getBoundingClientRect();
        var percent = (touch.clientX - rect.left) / rect.width;
        percent = Math.max(0, Math.min(1, percent));
        this.value = Math.round(percent * (this.max - this.min) + parseInt(this.min));
        this.dispatchEvent(new Event('input', { bubbles: true }));
      });
    });
    
    document.addEventListener('touchmove', function(e) {
      if (e.target.type !== 'range') {
        e.preventDefault();
      }
    }, { passive: false });
    
    document.addEventListener('touchstart', function(e) {
      if (e.target.tagName === 'INPUT' && e.target.type !== 'range') {
        e.stopPropagation();
      }
    }, { passive: false });
  </script>
</body>
</html>
]]
end

local function createWebView()
    local wv = WebView(activity)
    wv.setLayerType(View.LAYER_TYPE_HARDWARE, nil)
    wv.setBackgroundColor(TRANSPARENT)
    
    local settings = wv.getSettings()
    settings.setJavaScriptEnabled(true)
    settings.setDomStorageEnabled(true)
    settings.setLoadWithOverviewMode(true)
    settings.setUseWideViewPort(true)
    
    if Build.VERSION.SDK_INT >= 21 then
        settings.setMixedContentMode(0)
    end
    
    wv.setWebViewClient(WebViewClient())
    wv.setWebChromeClient(WebChromeClient())
    
    wv.loadDataWithBaseURL("https://local/", getMenuHTML(), "text/html", "UTF-8", nil)
    
    wv.setOnTouchListener(luajava.createProxy("android.view.View$OnTouchListener", {
        onTouch = function(v, event)
            local action = event.getAction()
            local rawX = event.getRawX()
            local rawY = event.getRawY()
            
            if action == MotionEvent.ACTION_DOWN then
                local hit = hitTest(rawX, rawY)
                if hit and hit.type == "toggle" then
                    dragMode = true
                    dragStartX = rawX
                    dragStartY = rawY
                    initialMenuX = menuXPx
                    initialMenuY = menuYPx
                    return true
                end
                
            elseif action == MotionEvent.ACTION_MOVE then
                if dragMode then
                    menuXPx = initialMenuX + (rawX - dragStartX)
                    menuYPx = initialMenuY + (rawY - dragStartY)
                    layoutParams.x = menuXPx
                    layoutParams.y = menuYPx
                    pcall(function() windowManager.updateViewLayout(webView, layoutParams) end)
                    return true
                end
                
            elseif action == MotionEvent.ACTION_UP then
                if dragMode then
                    dragMode = false
                    if math.abs(rawX - dragStartX) < 20 and math.abs(rawY - dragStartY) < 20 then
                        LuaActions.toggle()
                    end
                    return true
                end
                
                local hit = hitTest(rawX, rawY)
                if hit then
                    if hit.type == "group" then
                        if hit.name == "exit" then
                            LuaActions.exit()
                        else
                            LuaActions.switchPage(hit.name, hit.display)
                        end
                    elseif hit.type == "checkbox" then
                        local action = LuaActions[hit.action]
                        if action then action() end
                    elseif hit.type == "slider" then
                        local action = LuaActions[hit.action]
                        if action then
                            local js = string.format([[
                                (function() {
                                    var sliders = document.querySelectorAll('input[type="range"]');
                                    for(var i = 0; i < sliders.length; i++) {
                                        var label = sliders[i].parentElement.querySelector('.slider-label');
                                        if(label && label.textContent.trim() === '%s') {
                                            return sliders[i].value;
                                        }
                                    }
                                    return 0;
                                })();
                            ]], hit.label)
                            
                            local value = 0
                            pcall(function()
                                value = tonumber(wv.evaluateJavascript(js, nil)) or 0
                            end)
                            
                            action(value)
                        end
                    elseif hit.type == "input" then
                        LuaActions.setBGColor()
                    elseif hit.type == "exit" then
                        LuaActions.exit()
                    end
                    return true
                end
            end
            
            return true
        end
    }))
    
    return wv
end

local function initUI()
    windowManager = activity.getSystemService(Context.WINDOW_SERVICE)
    webView = createWebView()
    
    local flag = (Build.VERSION.SDK_INT >= 26) and
        WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY or
        WindowManager.LayoutParams.TYPE_PHONE
    
    layoutParams = WindowManager.LayoutParams(
        MENU_WIDTH_PX, MENU_HEIGHT_PX, flag,
        WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE 
            + WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL
            + WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS,
        PixelFormat.TRANSLUCENT
    )
    
    layoutParams.gravity = Gravity.TOP | Gravity.LEFT
    layoutParams.x = menuXPx
    layoutParams.y = menuYPx
    
    windowManager.addView(webView, layoutParams)
    gg.toast("Batman Menu v2.0 Expanded Started!")
end

gg.setVisible(false)

activity.runOnUiThread(luajava.createProxy("java.lang.Runnable", {
    run = function()
        pcall(initUI)
    end
}))

function cleanup()
    if windowManager and webView then
        pcall(function() windowManager.removeView(webView) end)
    end
end


isMenuVisible = false
    while true do
  if isMenuVisible then break end
   if gg.isVisible(true) then
    XGCK1 = 1
    gg.setVisible(false)
    gg.clearResults()
  end
  
    if _unli then
    _unli = false
    gg.setRanges(gg.REGION_CODE_APP)
    gg.searchNumber("-0.50344371796;9.99999997e-7;-0.50291442871::9", gg.TYPE_FLOAT)
    gg.refineNumber("9.99999997e-7", gg.TYPE_FLOAT)
    gg.getResults(100)
    gg.editAll("-1", gg.TYPE_FLOAT)
    gg.clearResults()
    gg.toast("HACK ON")
  end
  
if _dama then
    _dama = false
    gg.setRanges(gg.REGION_CODE_APP)
    gg.searchNumber(va, gg.TYPE_FLOAT)
    gg.refineNumber("9.99999997e-7", gg.TYPE_FLOAT)
    gg.getResults(100)
    gg.editAll("-1", gg.TYPE_FLOAT)
    gg.clearResults()
    gg.toast("HACK on")
  end
  
  if _aimbotPending then
    _aimbotPending = false
    gg.setRanges(gg.REGION_CODE_APP)
    gg.searchNumber("-0.50344371796;9.99999997e-7;-0.50291442871::9", gg.TYPE_FLOAT)
    gg.refineNumber("9.99999997e-7", gg.TYPE_FLOAT)
    gg.getResults(100)
    gg.editAll("-1", gg.TYPE_FLOAT)
    gg.clearResults()
    gg.toast("HACK ON")
  end
 
  if _wall then
    _wall = false
    gg.setRanges(gg.REGION_CODE_APP)
    gg.searchNumber("-0.50344371796;9.99999997e-7;-0.50291442871::9", gg.TYPE_FLOAT)
    gg.refineNumber("9.99999997e-7", gg.TYPE_FLOAT)
    gg.getResults(100)
    gg.editAll("-1", gg.TYPE_FLOAT)
    gg.clearResults()
    gg.toast("HACK on")
  end
  
if XGCK1 == 0 then    
os.exit()
  end  
  if XGCK1 == 1 then    
os.exit()
  end  
  XGCK1 = -1
end
  



