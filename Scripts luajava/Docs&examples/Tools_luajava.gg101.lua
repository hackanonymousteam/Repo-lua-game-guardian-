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

local Tools = Class("android.ext.Tools")

local context = Tools.e()
print("Context:", context)

local context2 = Tools.f(context)

local context3 = Tools.o()

local pm = Tools.m()
print("Package Manager:", pm)

local prefs = Tools.s()
print("SharedPreferences:", prefs)

print("\n=== FILES ===")

Tools.a("/sdcard/my_file.txt")

Tools.a("/source.txt", "/sdcard/destination.txt")

--Tools.copy("/source.txt", "/sdcard/destination.txt")

Tools.a(file, 0644)

local dir1 = Tools.h()
print("Directory 1:", dir1)

local dir2 = Tools.i()
print("Directory 2:", dir2)

local dir3 = Tools.k()
print("Directory 3:", dir3)

local dir4 = Tools.l()
print("Directory 4:", dir4)

print("\n=== STRINGS ===")

local text = Tools.a("Text to process")
print("Processed text:", text)

local text2 = Tools.a("Another text", 10)
print("Text with parameter:", text2)

local combined = Tools.a("First", "Second", 5)
print("Combined:", combined)

local processedStr = Tools.c("string_to_process")
print("Processed string:", processedStr)

local str2 = Tools.g("another_string")
print("String 2:", str2)

local str3 = Tools.l("one_more")
print("String 3:", str3)

local str4 = Tools.m("last")
print("String 4:", str4)

local str5 = Tools.n("any_text")
print("String 5:", str5)

local noBreaks = Tools.removeNewLinesChars("text\nwith\nlines")
print("No breaks:", noBreaks)

print("\n=== CONVERSIONS ===")

local number = Tools.a(object)
print("Object number:", number)

local value1 = Tools.b()
print("Value 1:", value1)

local result = Tools.b(10, 5)
print("10 op 5 =", result)

local value2 = Tools.c()
print("Value 2:", value2)

local result2 = Tools.c(20, 3)
print("20 op 3 =", result2)

local value3 = Tools.e(100)
print("Value 3:", value3)

local decimal = Tools.f("123.45")
print("Decimal:", decimal)

local value4 = Tools.t()
print("Value 4:", value4)

print("\n=== PROCESSES ===")

local process = Tools.a(existingProcess)
print("Process:", process)

local env = Tools.a({"/system/bin/ls"}, {"/sdcard"}, directory)
print("Process with env:", env)

local procWithDir = Tools.a({"/system/bin/pwd"}, {}, directory)
print("Process with dir:", procWithDir)

local alive = Tools.b(process)
print("Process alive?", alive)

print("\n=== UTILITIES ===")

Tools.a(100, 200)

local equal = Tools.a(1000, 1000)
print("Longs equal?", equal)

local strContext = Tools.a(context, 123456789)
print("String context:", strContext)

Tools.a("prefix", 42)

Tools.a("key", "value")

local sb = new(Class("java.lang.StringBuilder"))
Tools.a("text", sb)

Tools.a("config", true)

local formatted = Tools.a("Hello %s! Age: %d", {"World", 25})
print("Formatted:", formatted)

Tools.b("Log message")

Tools.b("another_msg", 123)

Tools.d()

print("\n=== DRAWABLES ===")

local processedDrawable = Tools.a(myDrawable)
print("Processed drawable:", processedDrawable)

local drawableRes = Tools.b(0x7f020000)
print("Drawable resource:", drawableRes)

local appIcon = Tools.b(appInfo)
print("App icon:", appIcon)

local infoContext = Tools.d(context)
print("Info context:", infoContext)

local valid = Tools.d("test")
print("String valid?", valid)

local exists = Tools.e("something")
print("Exists?", exists)

local valid2 = Tools.h("other")
print("Valid 2?", valid2)

local condition = Tools.o("conditional")
print("Condition:", condition)

print("\n✅ ALL TOOLS TESTED!")