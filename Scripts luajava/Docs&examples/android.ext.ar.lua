import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "java.lang.ref.*"
import "java.util.*"
import "android.ext.*"

local Class = luajava.bindClass
local new = luajava.new

local ExtAr = Class("android.ext.ar")

print("=== PRACTICAL USE OF android.ext.ar CLASS ===\n")

print("1. STATIC UTILITY METHODS:\n")

print("1.1 b() -> String (static)")
local staticResult = ExtAr.b()
print("   Result:", tostring(staticResult))

print("\n1.2 h() -> void (static)")

--restart app
--ExtAr.h()
print("   Method executed")




print("\n1.4 useUID(boolean) -> void (static)")
ExtAr.useUID(false)

ExtAr.useUID(false)

print("\n2. INSTANCE METHODS:\n")

print("2.1 getHandler() -> Handler")
local arInstance = nil
local success, instance = pcall(function()
    return new(ExtAr)
end)

if success and instance then
    arInstance = instance
    local handler = arInstance:getHandler()
    print("   Handler obtained:", tostring(handler))
    
    if handler then
        handler:post(function()
            print("   📨 Message posted to Handler")
        end)
    end
else
    print("   ⚠️ Instance not available for testing")
end

print("\n2.2 i() -> boolean")
if arInstance then
    local result = arInstance:i()
    print("   Result:", result)
end

print("\n2.3 j() -> void")
if arInstance then
    arInstance:j()
    print("   Method executed")
end

print("\n2.4 l() -> void")
if arInstance then
    arInstance:l()
    print("   Method executed")
end

print("\n3. LUA FUNCTION CONTROL METHODS:\n")

print("3.1 postFunc(LuaFunction) -> void")
if arInstance then
    local LuaFunction = Class("luaj.LuaFunction")
    local luaFunc = {
        call = function()
            gg.alert("5")
            print("   📞 Lua function executed in UI thread")
            return 1
        end
    }
    
    local luaFuncInstance = luajava.createProxy(LuaFunction, luaFunc)
    arInstance:postFunc(luaFuncInstance)
    print("   Lua function posted")
end

print("\n3.2 stopFunc() -> void")
if arInstance then
    arInstance:stopFunc()
    print("   Functions stopped")
end

print("\n4. EVENT METHODS:\n")

if arInstance then
    local handled = arInstance:dispatchKeyEvent(keyEvent)
    print("   KeyEvent dispatched, handled:", handled)
end

print("\n4.3 onKeyUp(int, KeyEvent) -> boolean")
if arInstance then
    local keyUpEvent = KeyEvent.obtain(
        os.time() * 1000,
        os.time() * 1000 + 200,
        KeyEvent.ACTION_UP,
        KeyEvent.KEYCODE_VOLUME_UP,
        0
    )
    
    local result = arInstance:onKeyUp(KeyEvent.KEYCODE_VOLUME_UP, keyUpEvent)
    print("   onKeyUp returned:", result)
end

print("\n5. LIFECYCLE METHODS (simulation):\n")

print("5.1 onCreate(Bundle)")
local Bundle = Class("android.os.Bundle")
local bundle = new(Bundle)
bundle:putString("test_key", "test_value")

if arInstance then
    arInstance:onCreate(bundle)
    print("   onCreate executed with Bundle")
end

print("\n5.2 onDestroy()")
if arInstance then
    arInstance:onDestroy()
    print("   onDestroy executed")
end

print("\n5.3 onPause()")
if arInstance then
    arInstance:onPause()
    print("   onPause executed")
end

print("\n5.4 onResume()")
if arInstance then
    arInstance:onResume()
    print("   onResume executed")
end

print("\n5.5 onStop()")
if arInstance then
    arInstance:onStop()
    print("   onStop executed")
end

print("\n6. PERMISSION METHOD:\n")

print("6.1 onRequestPermissionsResult(int, String[], int[])")
if arInstance then
    local permissions = luajava.newInstance("[Ljava.lang.String;", 2)
    permissions[0] = "android.permission.CAMERA"
    permissions[1] = "android.permission.READ_CONTACTS"
    
    local grantResults = luajava.newInstance("[I", 2)
    grantResults[0] = PackageManager.PERMISSION_GRANTED
    grantResults[1] = PackageManager.PERMISSION_DENIED
    
    arInstance:onRequestPermissionsResult(1001, permissions, grantResults)
    print("   Permission result processed")
end

print("\n7. PRACTICAL USE SCENARIOS:\n")

print("📋 SCENARIO 1: Safe execution in UI thread")

local function runOnUIThread(func)
    if arInstance then
        local LuaFunction = luajava.bindClass("luaj.LuaFunction")
        local proxyFunc = luajava.createProxy(LuaFunction, {
            call = func
        })
        arInstance:postFunc(proxyFunc)
    end
end

runOnUIThread(function()
    print("Executing in UI thread")
end)


print("\n📋 SCENARIO 2: Script execution control")

local function controlScripts()
    for i = 1, 5 do
        local func = luajava.createProxy(LuaFunction, {
            call = function()
                print("Script " .. i .. " executing")
                return i
            end
        })
        arInstance:postFunc(func)
    end
    
    Timer():schedule({
        run = function()
            print("Stopping all scripts")
            arInstance:stopFunc()
        end
    }, 3000)
end


print("\n📋 SCENARIO 3: Event interception")

local function setupEventInterception()
    if arInstance then
        local keyHandler = {
            onKeyUp = function(keyCode, event)
                print("Key pressed:", keyCode)
                
                if keyCode == KeyEvent.KEYCODE_BACK then
                    print("Back button intercepted")
                    return true
                end
                return false
            end,
            
            onClick = function(view)
                print("View clicked:", view:getId())
            end
        }
    end
end


print("\n📋 SCENARIO 4: Integration with GG/Daemon")

local function setupDaemonIntegration()
    ExtAr.useUID(true)
    
    local config = ExtAr.b()
    print("Configuration:", config)
    
    ExtAr.h()
end


print("\n8. IDENTIFIED SPECIFIC FUNCTIONALITIES:\n")

print("🎯 1. Lua Thread Management")
print("   • postFunc() - Posts Lua functions to UI thread")
print("   • stopFunc() - Stops function execution")
print("   • getHandler() - Gets Handler for execution")

print("\n🎯 2. Event Control")
print("   • dispatchKeyEvent() - Dispatches keyboard events")
print("   • onClick() - Handles clicks")
print("   • onKeyUp() - Key release events")
print("   • onBackPressed() - Back button control")

print("\n🎯 3. State Management")
print("   • i() - State verification")
print("   • j() - Specific operation")
print("   • l() - Specific operation")
print("   • Lifecycle methods")

print("\n🎯 4. Static Utilities")
print("   • b() - Returns configuration/utility string")
print("   • h() - Helper/utility method")
print("   • iii() - View processing")
print("   • useUID() - UID configuration")

print("\n9. COMPLETE INTEGRATION EXAMPLE:\n")

local function integrateWithSystem()
    ExtAr.useUID(true)
    
    local systemInfo = ExtAr.b()
    print("System information:", systemInfo)
    
    ExtAr.h()
    
    local success, arInst = pcall(function()
        return new(ExtAr)
    end)
    
    if success and arInst then
        local handler = arInst:getHandler()
        
        for i = 1, 3 do
            handler:postDelayed(function()
                print("Task " .. i .. " executed")
            end, i * 1000)
        end
        
        handler:postDelayed(function()
            print("Finishing execution")
            arInst:stopFunc()
        end, 5000)
    end
    
    local view = new(TextView, activity)
    ExtAr.iii(view)
end