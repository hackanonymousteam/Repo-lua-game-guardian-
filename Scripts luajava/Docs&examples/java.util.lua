import "java.util.*"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"

local Class = luajava.bindClass
local new = luajava.new
local astable = luajava.astable

print("=== 📚 JAVA.UTIL COLLECTIONS TEST ===\n")

print("1. ArrayList:")
local ArrayList = Class("java.util.ArrayList")
local list = new(ArrayList)
list:add("First")
list:add("Second")
list:add("Third")
print("   List size:", list:size())
