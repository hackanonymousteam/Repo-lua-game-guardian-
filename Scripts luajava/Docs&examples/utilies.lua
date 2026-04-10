import "java.util.*"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"

local Class = luajava.bindClass
local new = luajava.new
local astable = luajava.astable

print("=== 🛠️ JAVA.UTIL UTILITIES TEST ===\n")

print("1. TimeZone - Time Zones:")
local TimeZone = Class("java.util.TimeZone")

local defaultTZ = TimeZone.getDefault()
print("   Default TimeZone:", defaultTZ:getID())
print("   Display name:", defaultTZ:getDisplayName())
print("   Raw offset (ms):", defaultTZ:getRawOffset())
print("   Uses daylight saving?", defaultTZ:useDaylightTime())

local utcTZ = TimeZone.getTimeZone("UTC")
local nyTZ = TimeZone.getTimeZone("America/New_York")
print("   UTC TimeZone:", utcTZ:getID())
print("   NY TimeZone:", nyTZ:getID(), "- Offset:", nyTZ:getRawOffset())

local timezones = {
    "GMT",
    "Europe/London", 
    "Asia/Tokyo",
    "Brazil/East"
}

print("   Some TimeZones:")
for i, tzId in ipairs(timezones) do
    local tz = TimeZone.getTimeZone(tzId)
    print("     - " .. tzId .. ": " .. tz:getDisplayName())
end
print()

print("2. Locale - Internationalization:")
local Locale = Class("java.util.Locale")

local defaultLocale = Locale.getDefault()
print("   Default Locale:", defaultLocale:toString())
print("   Language:", defaultLocale:getLanguage())
print("   Country:", defaultLocale:getCountry())
print("   Display name:", defaultLocale:getDisplayName())

local locales = {
    Locale.US,
    Locale.UK,
    Locale.FRANCE,
    Locale.JAPAN,
    Locale("pt", "BR")
}

print("   Different Locales:")
for i, locale in ipairs(locales) do
    print("     - " .. locale:toString() .. 
          ": " .. locale:getDisplayName() ..
          " (" .. locale:getDisplayCountry(locale) .. ")")
end

print("   Current locale details:")
print("     Language (ISO3):", defaultLocale:getISO3Language())
print("     Country (ISO3):", defaultLocale:getISO3Country())
print("     Variant:", defaultLocale:getVariant() or "not defined")
print("     Script:", defaultLocale:getScript() or "not defined")
print()

print("3. UUID - Unique Identifiers:")
local UUID = Class("java.util.UUID")

local uuid1 = UUID.randomUUID()
local uuid2 = UUID.randomUUID()
print("   Random UUID 1:", uuid1:toString())
print("   Random UUID 2:", uuid2:toString())
print("   Are they equal?", uuid1:equals(uuid2))

print("   UUID analysis:")
print("     Version:", uuid1:version())
print("     Variant:", uuid1:variant())

print()

print("4. Random - Random Generation:")
local Random = Class("java.util.Random")

local randomWithSeed = new(Random, 12345)
local randomDefault = new(Random)

print("   Integer numbers:")
print("     nextInt():", randomDefault:nextInt())
print("     nextInt(100):", randomDefault:nextInt(100))
print("     nextInt(1000):", randomDefault:nextInt(1000))

print("   Decimal numbers:")
print("     nextDouble():", randomDefault:nextDouble())
print("     nextFloat():", randomDefault:nextFloat())

print("   Booleans and bytes:")
print("     nextBoolean():", randomDefault:nextBoolean())

print("5. Practical Combinations:")

print("   Localization examples:")
local localesTest = {Locale.US, Locale.FRANCE, Locale.JAPAN}
for i, loc in ipairs(localesTest) do
    print("     " .. loc:getDisplayName() .. 
          " - Country: " .. loc:getDisplayCountry(loc) ..
          ", Language: " .. loc:getDisplayLanguage(loc))
end

local sessionId = UUID.randomUUID()
print("   Generated session ID:", sessionId:toString())

local passwordChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
local password = ""
for i = 1, 8 do
    local index = randomDefault:nextInt(#passwordChars) + 1
    password = password .. passwordChars:sub(index, index)
end
print("   Random password:", password)
print()

print("6. Advanced Tests:")

print("   UUID uniqueness test:")
local uuidSet = {}
local duplicates = 0
for i = 1, 100 do
    local uuid = UUID.randomUUID():toString()
    if uuidSet[uuid] then
        duplicates = duplicates + 1
    else
        uuidSet[uuid] = true
    end
end
print("     Generated 100 UUIDs, duplicates:", duplicates)

print("   TimeZones with daylight saving:")
local dstTimeZones = {
    "America/New_York",
    "Europe/London", 
    "Australia/Sydney"
}
for i, tzId in ipairs(dstTimeZones) do
    local tz = TimeZone.getTimeZone(tzId)
    print("     " .. tzId .. ": " .. (tz:useDaylightTime() and "Yes" or "No"))
end
print()

print("=== 📊 UTILITIES SUMMARY ===")

print("   TimeZone:")
print("     Default: " .. defaultTZ:getID() .. " (" .. defaultTZ:getDisplayName() .. ")")
print("     Offset: " .. (defaultTZ:getRawOffset() / 3600000) .. " hours")

print("   Locale:")
print("     Default: " .. defaultLocale:toString())
print("     Language: " .. defaultLocale:getDisplayLanguage())
print("     Country: " .. defaultLocale:getDisplayCountry())

local sampleUUID = UUID.randomUUID()
print("   UUID:")
print("     Example: " .. sampleUUID:toString())
print("     Version: " .. sampleUUID:version())

print("   Random:")
print("     Integer: " .. randomDefault:nextInt(100))
print("     Double: " .. randomDefault:nextDouble())

print("\n=== 🎯 PRACTICAL USE CASES ===")
print("   • TimeZone: multi-timezone applications")
print("   • Locale: internationalization and localization")
print("   • UUID: unique IDs for databases, sessions")
print("   • Random: games, cryptography, tests")
print("   • Combinations: timestamped logs, international users")