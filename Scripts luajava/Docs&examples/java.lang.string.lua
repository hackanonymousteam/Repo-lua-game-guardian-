print("=== JAVA lang.String - COMPLETE IMPLEMENTATION ===")

local String = luajava.bindClass("java.lang.String")
local Locale = luajava.bindClass("java.util.Locale")
local new = luajava.new

local testString = new(String, "Hello World")
local anotherString = new(String, " from LuaJava!")
local emptyString = new(String, "")
local spaceString = new(String, "   Hello   ")
local emailString = new(String, "user@example.com")
local numberString = new(String, "12345")
local mixedCaseString = new(String, "HeLLo WoRLd")

print("Test String: " .. testString:toString())
print("Another String: " .. anotherString:toString())
print("Empty String: " .. emptyString:toString())

print("Length: " .. testString:length())
print("Is empty? " .. tostring(emptyString:isEmpty()))
print("Is testString empty? " .. tostring(testString:isEmpty()))

local concatenated = testString:concat(anotherString)

print("Equals 'Hello World'? " .. tostring(testString:equals("Hello World")))
print("Equals 'hello world'? " .. tostring(testString:equals("hello world")))
print("Equals ignore case 'hello world'? " .. tostring(testString:equalsIgnoreCase("hello world")))

print("Contains 'World'? " .. tostring(testString:contains("World")))
print("Contains 'Universe'? " .. tostring(testString:contains("Universe")))
print("StartsWith 'Hello'? " .. tostring(testString:startsWith("Hello")))
print("EndsWith 'World'? " .. tostring(testString:endsWith("World")))

print("Index of 'W': " .. testString:indexOf("W"))
print("Index of 'o': " .. testString:indexOf("o"))
print("Index of 'o' from position 5: " .. testString:indexOf("o", 5))
print("Last index of 'l': " .. testString:lastIndexOf("l"))
print("Last index of 'l' before position 3: " .. testString:lastIndexOf("l", 3))

local lowerCase = testString:toLowerCase()
local upperCase = testString:toUpperCase()
print("Original: " .. testString:toString())

print("Mixed case original: " .. mixedCaseString:toString())


local replacedChar = testString:replace('l', 'L')
local replacedSequence = testString:replace("World", "Universe")



local emailPattern = "^[A-Za-z0-9+_.-]+@(.+)$"
print("Email matches pattern? " .. tostring(emailString:matches(emailPattern)))
print("Number matches digits? " .. tostring(numberString:matches("\\d+")))

local csvString = new(String, "apple,banana,orange,grape")
local fruits = csvString:split(",")
print("CSV String: " .. csvString:toString())
print("Split results:")
for i = 0, #fruits - 1 do
    print("  " .. (i + 1) .. ": " .. fruits[i]:toString())
end

local limitedSplit = csvString:split(",", 3)
print("Limited split (limit=3):")
for i = 0, #limitedSplit - 1 do
    print("  " .. (i + 1) .. ": " .. limitedSplit[i]:toString())
end






local demoText = new(String, "   Hello Java World! Welcome to LuaJava.   ")
print("Original: " .. demoText:toString())

local words = demoText:trim():split(" ")
print("Split into words:")
for i = 0, #words - 1 do

end

local str1 = new(String, "Hello")
local str2 = new(String, "Hello")
local interned1 = str1:intern()
local interned2 = str2:intern()
print("String interning - same object? " .. tostring(interned1 == interned2))

local StringBuffer = luajava.bindClass("java.lang.StringBuffer")
local buffer = new(StringBuffer, "Hello World")
print("Content equals StringBuffer? " .. tostring(testString:contentEquals(buffer)))

local complexString = new(String, "Hello 🌍 World")
print("Complex string: " .. complexString:toString())
print("Length: " .. complexString:length())
print("Offset by code points (2): " .. complexString:offsetByCodePoints(0, 2))

print("Hash code: " .. testString:hashCode())
print("Class: " .. testString:getClass():getName())

print("=== ✅ ALL STRING OPERATIONS COMPLETED SUCCESSFULLY ===")

local validationString = new(String, "Test String 123")
print("Validation String: " .. validationString:toString())
print("Length: " .. validationString:length())
print("Contains 'Test'? " .. tostring(validationString:contains("Test")))
print("Starts with 'Test'? " .. tostring(validationString:startsWith("Test")))
print("Ends with '123'? " .. tostring(validationString:endsWith("123")))

