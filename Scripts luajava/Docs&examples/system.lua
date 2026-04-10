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

local System = Class("java.lang.System")

print("1. getProperties():")
local props = System.getProperties()
print("system:", props:toString())

print("2. getProperty(String):")
print("OS Name:", System.getProperty("os.name"))

print("3. hashCode():")
local obj = new(Class("java.lang.Object"))
print("Hash code:", obj:hashCode())

print("4. identityHashCode(Object):")
local str1 = new(Class("java.lang.String"), "test")
local str2 = new(Class("java.lang.String"), "test")
print("Identity Hash Code str1:", System.identityHashCode(str1))
print("Identity Hash Code str2:", System.identityHashCode(str2))
print("Same object?", System.identityHashCode(str1) == System.identityHashCode(str2))

local lineSep = System.lineSeparator()
print("Line separator:", string.format("%q", lineSep))
print("Test:" .. "Line 1" .. lineSep .. "Line 2")

print("5. nanoTime():")
local startTime = System.nanoTime()
for i = 1, 1000 do end
local endTime = System.nanoTime()
print("Start time (ns):", startTime)
print("End time (ns):", endTime)
print("Duration (ns):", endTime - startTime)

print("6. runFinalization():")
System.runFinalization()
print("Finalizers executed")

print("7. runFinalizersOnExit(boolean):")
System.runFinalizersOnExit(true)
print("Finalizers on exit: ENABLED")
System.runFinalizersOnExit(false)
print("Finalizers on exit: DISABLED")

print("8. setErr(PrintStream):")
local FileOutputStream = Class("java.io.FileOutputStream")
local PrintStream = Class("java.io.PrintStream")
local fos = new(FileOutputStream, "/sdcard/error.log")
local ps = new(PrintStream, fos)
System.setErr(ps)
print("(stderr redirection)")

print("9. setOut(PrintStream):")
System.setOut(ps)
print("(stdout redirection)")

print("10. setProperties(Properties):")
local currentProps = System.getProperties()
System.setProperties(currentProps)
print("Properties can be set")

print("11. setProperty(String, String):")
local oldValue = System.setProperty("my.property", "my value")
print("Property set: my.property = my value")
print("Previous value:", oldValue or "null")
print("Current value:", System.getProperty("my.property"))

print("12. setSecurityManager(SecurityManager):")
System.setSecurityManager(nil)
print("(Security Manager change)")

print("13. setUnchangeableSystemProperty(String, String):")
System.setUnchangeableSystemProperty("immutable.prop", "fixed value")
print("Unchangeable property set")

print("\n=== SYSTEM PROPERTIES SUMMARY ===")
local properties = {
    "java.version", "java.vendor", "java.home",
    "os.name", "os.arch", "os.version", 
    "user.name", "user.home", "user.dir",
    "java.io.tmpdir", "path.separator", "file.separator"
}

for i, prop in ipairs(properties) do
    local value = System.getProperty(prop)
    print(string.format("%-20s: %s", prop, value or "not defined"))
end

print("\n=== TIMESTAMPS ===")
print("Current Time Millis:", System.currentTimeMillis())
print("Nano Time:", System.nanoTime())