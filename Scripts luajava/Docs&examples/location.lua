import "java.util.logging.*"
import "java.text.*"
import "java.util.*"
import "android.app.*"
import "android.os.*"

local Class = luajava.bindClass
local new = luajava.new

local ResourceBundle = Class("java.util.ResourceBundle")
local ListResourceBundle = Class("java.util.ListResourceBundle")
local Locale = Class("java.util.Locale")

local bundleSuccess, bundleError = pcall(function()
    
    local locales = Locale:getAvailableLocales()
    
    print("   🌍 Locales avaliables:", #locales)
    
   
    local defaultLocale = Locale:getDefault()
    print("   ✅ Locale padrão:")
    print("     Idiom:", defaultLocale:getLanguage())
    print("     country:", defaultLocale:getCountry())
    print("     name:", defaultLocale:getDisplayName())
    
    
   
end)

if not bundleSuccess then print("   ❌ ResourceBundle:", bundleError) end
print()

