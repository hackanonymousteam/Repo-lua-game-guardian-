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

local File = Class("java.io.File")

print("=== 📁 COMPLETE FILE CLASS TEST ===\n")

local testFile = new(File, "/sdcard/test_file.txt")
local testDir = new(File, "/sdcard/test_directory")
local subDir = new(File, "/sdcard/test_directory/subdirectory")

print("1. deleteOnExit():")
testFile:deleteOnExit()
print("   File marked for deletion on program exit")
print()

print("2. equals(Object):")
local anotherFile = new(File, "/sdcard/test_file.txt")
print("   Are they equal?", testFile:equals(anotherFile))
print("   Same path?", testFile:getPath() == anotherFile:getPath())
print()

print("3. exists():")
print("   File exists?", testFile:exists())
print("   Directory exists?", testDir:exists())
print()

print("4. getAbsoluteFile():")
local absFile = testFile:getAbsoluteFile()
print("   Absolute file:", absFile:toString())
print()

print("5. getAbsolutePath():")
local absPath = testFile:getAbsolutePath()
print("   Absolute path:", absPath)
print()

print("6. getCanonicalFile():")
local ok, canonicalFile = pcall(function() return testFile:getCanonicalFile() end)
if ok then
    print("   Canonical file:", canonicalFile:toString())
else
    print("   Error getting canonical file")
end
print()

print("7. getCanonicalPath():")
local ok, canonicalPath = pcall(function() return testFile:getCanonicalPath() end)
if ok then
    print("   Canonical path:", canonicalPath)
else
    print("   Error getting canonical path")
end
print()

print("8. getFreeSpace():")
local freeSpace = testFile:getFreeSpace()
print("   Free space (bytes):", freeSpace)
print("   Free space (MB):", string.format("%.2f", freeSpace / (1024 * 1024)))
print()

print("9. getName():")
print("   File name:", testFile:getName())
print("   Directory name:", testDir:getName())
print()

print("10. getParent():")
print("   File parent:", testFile:getParent())
print("   Directory parent:", testDir:getParent())
print()

print("11. getParentFile():")
local parentFile = testFile:getParentFile()
print("   Parent file:", parentFile:toString())
print("   Parent path:", parentFile:getPath())
print()

print("12. getPath():")
print("   File path:", testFile:getPath())
print()

print("13. getTotalSpace():")
local totalSpace = testFile:getTotalSpace()
print("   Total space (bytes):", totalSpace)
print("   Total space (GB):", string.format("%.2f", totalSpace / (1024 * 1024 * 1024)))
print()

print("14. getUsableSpace():")
local usableSpace = testFile:getUsableSpace()
print("   Usable space (bytes):", usableSpace)
print("   Usable space (MB):", string.format("%.2f", usableSpace / (1024 * 1024)))
print()

print("15. hashCode():")
print("   File hash code:", testFile:hashCode())
print()

print("16. isAbsolute():")
print("   Is absolute path?", testFile:isAbsolute())
local relative = new(File, "relative_file.txt")
print("   Is relative file absolute?", relative:isAbsolute())
print()

print("17. isDirectory():")
print("   Is file a directory?", testFile:isDirectory())
print("   Is directory a directory?", testDir:isDirectory())
print()

print("18. isFile():")
print("   Is file a file?", testFile:isFile())
print("   Is directory a file?", testDir:isFile())
print()

print("19. isHidden():")
print("   Is file hidden?", testFile:isHidden())
print()

print("20. lastModified():")
local lastMod = testFile:lastModified()
print("   Last modified (timestamp):", lastMod)
if lastMod > 0 then
    local date = new(Class("java.util.Date"), lastMod)
    print("   Last modified (date):", date:toString())
end
print()

print("21. length():")
local size = testFile:length()
print("   File size (bytes):", size)
print()

print("22. list():")
local nameList = testDir:list()
if nameList then
    print("   Name list in directory:")
    for i, name in ipairs(luajava.astable(nameList)) do
        print("     " .. i .. ": " .. name)
    end
else
    print("   Not a directory or empty")
end
print()

print("23. listFiles():")
local fileList = testDir:listFiles()
if fileList then
    print("   File list in directory:")
    for i, fileObj in ipairs(luajava.astable(fileList)) do
        print("     " .. i .. ": " .. fileObj:getName() .. " (" .. (fileObj:isDirectory() and "DIR" or "FILE") .. ")")
    end
else
    print("   Not a directory or empty")
end
print()

print("24. listRoots():")
local roots = File.listRoots()
print("   File system roots:")
for i, root in ipairs(luajava.astable(roots)) do
    print("     " .. i .. ": " .. root:getPath() .. 
          " (Free: " .. string.format("%.2f", root:getFreeSpace() / (1024*1024*1024)) .. " GB)")
end
print()

print("25. mkdir():")
local mkdirResult = testDir:mkdir()
print("   Directory created?", mkdirResult)
print("   Directory exists now?", testDir:exists())
print()

print("26. mkdirs():")
local mkdirsResult = subDir:mkdirs()
print("   Subdirectory created?", mkdirsResult)
print("   Subdirectory exists now?", subDir:exists())
print()

print("27. notify() and notifyAll():")
print("   (Thread synchronization methods)")
print()

print("28. renameTo(File):")
local newName = new(File, "/sdcard/renamed_file.txt")
local renamed = testFile:renameTo(newName)
print("   File renamed?", renamed)
if renamed then
    print("   Original name exists?", testFile:exists())
    print("   New name exists?", newName:exists())
end
print()

print("29. setExecutable(boolean):")
local executable = newName:setExecutable(true)
print("   Execute permission set?", executable)
print()

print("30. setExecutable(boolean, boolean):")
local executableOwner = newName:setExecutable(true, true)
print("   Execute permission (owner only) set?", executableOwner)
print()

print("31. setReadOnly():")
local readonly = newName:setReadOnly()
print("   File set to read-only?", readonly)
print()

print("32. setReadable(boolean):")
local readable = newName:setReadable(true)
print("   Read permission set?", readable)
print()

print("33. setReadable(boolean, boolean):")
local readableOwner = newName:setReadable(true, true)
print("   Read permission (owner only) set?", readableOwner)
print()

print("34. setWritable(boolean):")
local writable = newName:setWritable(true)
print("   Write permission set?", writable)
print()

print("35. setWritable(boolean, boolean):")
local writableOwner = newName:setWritable(true, true)
print("   Write permission (owner only) set?", writableOwner)
print()

print("36. toPath():")
local path = newName:toPath()
print("   Path object:", path:toString())
print()

print("37. toString():")
print("   File string:", newName:toString())
print()

print("38. toURI():")
local uri = newName:toURI()
print("   URI:", uri:toString())
print()

print("39. toURL():")
local ok, url = pcall(function() return newName:toURL() end)
if ok then
    print("   URL:", url:toString())
else
    print("   Error creating URL")
end
print()

print("40. wait() methods:")
print("   (Thread wait methods)")
print()

print("=== ✅ COMPLETE TEST FINISHED ===")

print("\n=== 🧹 CLEANUP ===")
newName:delete()
testDir:delete()
print("   Test files removed")