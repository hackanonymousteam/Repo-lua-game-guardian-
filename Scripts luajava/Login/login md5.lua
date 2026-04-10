
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "android.graphics.Color"
import "android.content.Context"
import "android.content.Intent"
import "android.net.Uri"
import "android.provider.Settings"
import "android.content.pm.PackageManager"
import "android.graphics.Typeface"
import "android.graphics.drawable.ColorDrawable"
import "android.graphics.drawable.GradientDrawable"
import "android.app.ActivityManager"
import "android.widget.Toast"
import "java.io.File"

function checkGG(app)
local targetPackageName = app
  local activityManager = activity.getSystemService(Context.ACTIVITY_SERVICE)
  local runningApps = activityManager.getRunningAppProcesses()
    for i = 0, runningApps.size() - 1 do
      local appInfo = runningApps.get(i)
      if appInfo.processName ~= targetPackageName then
    gg.alert("use correct gg")
    gg.sleep(200)
   gg.exit()
    os.exit()
        break
      end
    end
  end
  if isRunning then
  end

function MD5(str)
  import "java.security.MessageDigest"
  import "java.lang.StringBuffer"
  import "java.lang.Integer"
  local md5 = MessageDigest.getInstance("MD5")
  local bytes = md5.digest(String(str).getBytes())
  local sb = StringBuffer()
  local by = luajava.astable(bytes)
  for i, n in ipairs(by) do
    local temp = Integer.toHexString(n & 0xff)
    if #temp == 1 then sb.append("0") end
    sb.append(temp)
  end
  return tostring(sb)
end

local login = gg.prompt({'user','pass'},{'',''},{'text','text'})
if not login then return end

local log1 = tostring(login[1])
local log2 = tostring(login[2])

local rev1 = "4a4566696cc81c6053ec708975767498"
local rev2 = "251bd8143891238ecedc306508e29017"

--user Batman
--pass Games

local conv1 = MD5(log1)
local conv2 = MD5(log2)

checkGG("com.game.guardian")

if conv1 ~= rev1 or conv2 ~= rev2 then
  gg.alert("error login")
  os.exit()
else
  gg.alert("login correct")
end