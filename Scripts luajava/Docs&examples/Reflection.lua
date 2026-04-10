import "java.lang.reflect.Method"
import "java.lang.reflect.Field"
import "java.lang.reflect.Constructor"
import "java.lang.reflect.Array"
import "java.lang.reflect.Modifier"

local Class = luajava.bindClass
local new = luajava.new

print("=== JAVA REFLECTION FIXED TEST ===")

print("1. Class reflection:")
local success1, result1 = pcall(function()
    local StringClass = Class("java.lang.String")
    
    print("Class name:", StringClass:getName())
    print("Simple name:", StringClass:getSimpleName())
    print("Is interface:", StringClass:isInterface())
    print("Modifiers:", StringClass:getModifiers())
    
    return true
end)

if not success1 then print("Error:", result1) end

print("9. Modifier checking (working correctly):")
local success9, result9 = pcall(function()
    local ModifierClass = Class("java.lang.reflect.Modifier")
    local StringClass = Class("java.lang.String")
    
    local modifiers = StringClass:getModifiers()
    
    print("String class modifiers:", modifiers)
    print("Is public:", ModifierClass:isPublic(modifiers))
    print("Is final:", ModifierClass:isFinal(modifiers))
    print("Is abstract:", ModifierClass:isAbstract(modifiers))
    
    return modifiers
end)

if not success9 then print("Error:", result9) end

print("=== REFLECTION TEST COMPLETE ===")