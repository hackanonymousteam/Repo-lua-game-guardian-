import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "android.content.pm.*"
import "java.io.*"
import "java.text.SimpleDateFormat"
import "java.util.*"
import "java.lang.Runtime"

local Runtime = luajava.bindClass("java.lang.Runtime")
local runtime = Runtime.getRuntime()

function getPackageNameOnly()
  local success, result = pcall(function()
    return activity.getPackageName()
  end)
  if success then
    return result
  else
    return nil
  end
end

--local TARGET_PACKAGE = "com.my.gg"
local TARGET_PACKAGE = "catch_.me_.if_.you_.can_"

local currentPackage = getPackageNameOnly()

if currentPackage then
  if currentPackage == TARGET_PACKAGE then
    gg.alert("✅ checked!")
  else
    print("❌ invslid gg!")
    gg.alert("❌ APP INCORRET! use my gg")
runtime:halt(1)
 runtime:exit(0)  
  end
else
 -- print("❌ Erro getting package name")
  gg.alert("❌ Erro getting info app")
end