import "java.io.*"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"

local Class = luajava.bindClass
local new = luajava.new
local astable = luajava.astable

print("=== 📁 COMPLETE JAVA I/O STREAMS TEST ===\n")

print("1. FileInputStream and FileOutputStream:")
local FileInputStream = Class("java.io.FileInputStream")
local FileOutputStream = Class("java.io.FileOutputStream")

local tempFile = "/sdcard/test_io.tmp"

print("2. BufferedReader and BufferedWriter:")
local BufferedReader = Class("java.io.BufferedReader")
local BufferedWriter = Class("java.io.BufferedWriter")
local FileReader = Class("java.io.FileReader")
local FileWriter = Class("java.io.FileWriter")

local textFile = "/sdcard/test_text.txt"

    local fw = new(FileWriter, textFile)
    local bw = new(BufferedWriter, fw)
    
    bw:write("First line")
    bw:newLine()
    bw:write("Second line with special characters: çãõ")
    bw:newLine()
    bw:write("Third line")
    bw:close()
    print("   ✅ Text written with BufferedWriter")

    local fr = new(FileReader, textFile)
    local br = new(BufferedReader, fr)
    
    local line
    local lineCount = 0
    print("   File content:")
    line = br:readLine()
    while line do
        lineCount = lineCount + 1
        print("     " .. lineCount .. ": " .. line)
        line = br:readLine()
    end
    br:close()
    print("   ✅ Total lines read:", lineCount)
    
    os.remove(textFile)

    print("   ❌ Error with BufferedReader/Writer:")

print()

print("3. InputStreamReader and OutputStreamWriter:")
local InputStreamReader = Class("java.io.InputStreamReader")
local OutputStreamWriter = Class("java.io.OutputStreamWriter")

    local testData = "Text with special characters: áéíóú ñ ç €"
    
    local ByteArrayInputStream = Class("java.io.ByteArrayInputStream")
    local ByteArrayOutputStream = Class("java.io.ByteArrayOutputStream")
    
    local baos = new(ByteArrayOutputStream)
    local osw = new(OutputStreamWriter, baos, "UTF-8")
    osw:write(testData)
    osw:close()
    
    local encodedBytes = baos:toByteArray()
    print("   ✅ Data encoded in UTF-8:", #encodedBytes, "bytes")
    
    local bais = new(ByteArrayInputStream, encodedBytes)
    local isr = new(InputStreamReader, bais, "UTF-8")
    
    local charBuffer = char[100]
    local charsRead = isr:read(charBuffer)
    
    print("   InputStreamReader encoding:", isr:getEncoding())
    isr:close()

    print("   ❌ Error with charset conversion:")

print()

print("4. ByteArrayInputStream and ByteArrayOutputStream:")
local ByteArrayInputStream = Class("java.io.ByteArrayInputStream")
local ByteArrayOutputStream = Class("java.io.ByteArrayOutputStream")

    local resultBytes = baos:toByteArray()
    print("   ✅ ByteArrayOutputStream:")
    print("     Bytes written:", #resultBytes)
    print("     As string:", String(resultBytes))

print("5. ObjectInputStream and ObjectOutputStream:")
local ObjectInputStream = Class("java.io.ObjectInputStream")
local ObjectOutputStream = Class("java.io.ObjectOutputStream")

    local baos = new(ByteArrayOutputStream)
    local oos = new(ObjectOutputStream, baos)
    
    oos:writeBoolean(true)
    oos:writeInt(42)
    oos:writeDouble(3.14159)
    oos:writeUTF("Hello Serialization!")
    oos:writeChar(65)
    
    oos:flush()
    local serializedData = baos:toByteArray()
    print("   ✅ Serialized data:", #serializedData, "bytes")
    
    local bais = new(ByteArrayInputStream, serializedData)
    local ois = new(ObjectInputStream, bais)
    
    print("   ✅ Deserialized data:")
    print("     Boolean:", ois:readBoolean())
    print("     Int:", ois:readInt())
    print("     Double:", ois:readDouble())
    print("     UTF:", ois:readUTF())
    print("     Char:", ois:readChar())
    
    ois:close()
    oos:close()

    print("   ❌ Error with Object streams:")
    print("   Note: Serialization may have limitations on Android")

print()

print("6. Advanced Combinations - Stream Pipelines:")

    local originalText = "This is a sample text to demonstrate I/O pipelines.\n" ..
                        "Second line of text.\n" ..
                        "Third final line."

    local baos = new(ByteArrayOutputStream)
    local osw = new(OutputStreamWriter, baos, "UTF-8")
    local bw = new(BufferedWriter, osw)
    
    bw:write(originalText)
    bw:close()
    
    local encodedData = baos:toByteArray()
    print("   ✅ Write pipeline:")
    print("     Original text:", #originalText, "characters")
    print("     Encoded bytes:", #encodedData, "bytes")

    local bais = new(ByteArrayInputStream, encodedData)
    local isr = new(InputStreamReader, bais, "UTF-8")
    local br = new(BufferedReader, isr)
    
    local reconstructed = {}
    local line = br:readLine()
    while line do
        table.insert(reconstructed, line)
        line = br:readLine()
    end
    br:close()
    
    print("   ✅ Read pipeline:")
    print("     Reconstructed lines:", #reconstructed)
    for i, ln in ipairs(reconstructed) do
        print("       " .. i .. ": " .. ln)
    end

    print("   ❌ Pipeline error:")

print()

print("7. Control and Navigation Operations:")

    local skipped = bais:skip(3)
    print("     Bytes skipped:", skipped)

    bais:reset()
    local afterReset = bais:read()
    print("     Byte after reset:", afterReset, "('" .. string.char(afterReset) .. "')")
    
    bais:close()

    print("   ❌ Control operations error:")

print()

print("8. Performance and Buffering:")

    local largeData = string.rep("X", 10000)

    local startTime2 = os.time()
    local baos2 = new(ByteArrayOutputStream)
    local osw2 = new(OutputStreamWriter, baos2, "UTF-8")
    local bw2 = new(BufferedWriter, osw2, 8192)
    
    for i = 1, 100 do
        bw2:write(largeData)
    end
    bw2:close()
    local result2 = baos2:toByteArray()
    local endTime2 = os.time()
    
    print("   ✅ Performance comparison:")
    print("     With buffer:", (endTime2 - startTime2) .. " time units")
    print("   ❌ Performance test error:")