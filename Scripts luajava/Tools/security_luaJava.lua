gg.setVisible(false)
if luajava == nil then gg.alert(' unavaliable please use gameguardian mod (suport luajava)') else end

if not activity then
    gg.alert("No activity")
    return
end

import("android.app.*")
import("android.os.*")
import("android.widget.*")
import("android.view.*")
import("android.content.Context")
import("android.graphics.Typeface")
import("android.view.animation.AlphaAnimation")
import("java.io.File")
import("android.net.ConnectivityManager")
import("android.view.WindowManager")
import("android.widget.Toast")

local function batmanToast(msg)
  msg = msg or "BATMAN SECURITY: ACTIVE"
  activity.runOnUiThread(function()
    Toast.makeText(activity, msg, Toast.LENGTH_LONG).show()
  end)
end

local banned_apps = {
  "re.frida.server",
  "org.lsposed.manager",
  "com.topjohnwu.magisk",
  "com.chelpus.lackypatch",
  "com.guoshi.httpcanary"
}

local banned_paths = {
  "/data/local/tmp/frida-server",
  "/sbin/magisk",
  "/system/bin/magisk",
  "/data/data/com.topjohnwu.magisk",
  "/data/local/tmp/re.frida.server"
}

local storage = activity.getSharedPreferences("BATMAN_SECURITY", Context.MODE_PRIVATE)

function checkNetwork()
  local cm = activity.getSystemService(Context.CONNECTIVITY_SERVICE)
  local info = cm.getActiveNetworkInfo()
  
  if not info or not info.isConnected() then
    return "NO_CONNECTION"
  end

  local type = info.getType()
  if type == ConnectivityManager.TYPE_VPN then
    return "VPN"
  end
  
  return "OK"
end

function checkMemoryAndPorts()
  local ok, mem_threat = pcall(function()
    local f = io.open("/proc/self/maps", "r")
    if f then
      local content = f:read("*a")
      f:close()
      if content:find("frida") then 
        return "Frida Process Hook" 
      end
      if content:find("gum%-js") then 
        return "Frida GumJS Engine" 
      end
      if content:find("libgadget") then 
        return "Frida Gadget Injection" 
      end      
    end
    return nil
  end)
  
  if ok and mem_threat then 
    return mem_threat 
  end
  
  local ok2, port_threat = pcall(function()
    local f = io.open("/proc/net/tcp", "r")
    if f then
      local content = f:read("*a")
      f:close()
      if content:find(":69A2") then 
        return "Frida Port 27042 Active" 
      end
    end
    return nil
  end)
  
  if ok2 and port_threat then 
    return port_threat 
  end
  
  return nil
end

function performDetection()
  local pm = activity.getPackageManager()
  
  for _, pkg in ipairs(banned_apps) do
    local ok, _ = pcall(function() 
      return pm.getPackageInfo(pkg, 0) 
    end)
    if ok then 
      return pkg 
    end
  end
  
  for _, path in ipairs(banned_paths) do
    local f = File(path)
    if f.exists() then 
      return path 
    end
  end
  
  local advanced_threat = checkMemoryAndPorts()
  if advanced_threat then 
    return advanced_threat 
  end
  
  return nil
end

function runSentinel()
  local net = checkNetwork()
  if net == "NO_CONNECTION" then
    gg.alert("NO INTERNET DETECTED\nTURN ON DATA OR WIFI.")
    return false
  elseif net == "VPN" then
    gg.alert("VPN DETECTED\nDISABLE VPN TO CONTINUE.")
    return false
  end

  local initial_threat = performDetection()
  if initial_threat then
    gg.alert("HOOK TOOL DETECTED\nDetected: " .. initial_threat)
    return false
  end
  
  return true
end

local is_safe = runSentinel()

if is_safe then
  gg.setVisible(false)
  batmanToast("BATMAN SECURITY: ACTIVE")
else
  gg.alert("System compromised!\nExiting script...")
  os.exit()
end