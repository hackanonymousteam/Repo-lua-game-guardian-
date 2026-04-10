import "android.ext.*"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "java.io.*"
import "java.security.*"
import "java.util.zip.CRC32"
import "java.math.BigInteger"

local Class = luajava.bindClass
local new = luajava.new
local astable = luajava.astable
local methods = luajava.methods

local Script = Class("android.ext.Script")
local LuaValue = Class("luaj.LuaValue")

Script.a(1000)
print("1 second elapsed")

local ArrayList = Class("java.util.ArrayList")
local constantList = new(ArrayList)
constantList:add("CONST_SPEED")
constantList:add("CONST_FORCE")
A = constantList:add("CONST_LIFE")

print("Starting sequence...")
Script.a(500)
print("0.5s elapsed")
Script.a(1000)
print("1.5s elapsed")
Script.a(2000)
print("3.5s total elapsed")

print("Starting counter...")
for i = 1, 5 do
    Script.a(1000)
    print("Count:", i)
end
print("Counter finished!")

local data = LuaValue.valueOf(50)
Script.a(500)
print(data)
Script.a(1000)

print("✅ SCRIPT COMPLETED SUCCESSFULLY!")
print(A)