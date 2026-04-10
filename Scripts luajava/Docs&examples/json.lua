import "org.json.JSONObject"
import "org.json.JSONArray"

local Class = luajava.bindClass
local new = luajava.new

print("=== JSON FUNCTIONAL TEST ===")

print("1. Basic JSONObject creation:")

local success1, result1 = pcall(function()
    local JSONObject = Class("org.json.JSONObject")
    local jsonObj = new(JSONObject)
    
    jsonObj:put("name", "John Smith")
    jsonObj:put("age", 30)
    jsonObj:put("active", true)
    
    local jsonString = jsonObj:toString()
    print("Result:", jsonString)
    
    return jsonString
end)

if not success1 then
    print("Error:", result1)
end

print("2. Different data types:")

local success2, result2 = pcall(function()
    local JSONObject = Class("org.json.JSONObject")
    local jsonObj = new(JSONObject)
    
    jsonObj:put("string", "simple text")
    jsonObj:put("integer", 100)
    jsonObj:put("decimal", 99.99)
    jsonObj:put("boolean_true", true)
    jsonObj:put("boolean_false", false)
    
    local jsonString = jsonObj:toString()
    print("Result:", jsonString)
    
    return jsonString
end)

if not success2 then
    print("Error:", result2)
end

print("3. JSON string parsing:")

local success3, result3 = pcall(function()
    local JSONObject = Class("org.json.JSONObject")
    
    local jsonString = '{"user": "admin", "level": 5}'
    local parsedObj = new(JSONObject, jsonString)
    local parsedString = parsedObj:toString()
    
    print("Result:", parsedString)
    
    return parsedString
end)

if not success3 then
    print("Error:", result3)
end

print("4. Nested structure:")

local success4, result4 = pcall(function()
    local JSONObject = Class("org.json.JSONObject")
    local JSONArray = Class("org.json.JSONArray")
   
    local user = new(JSONObject)
    user:put("id", 1)
    user:put("name", "Mary")
    
    local preferences = new(JSONArray)
    preferences:put("reading")
    preferences:put("music")
    
    user:put("preferences", preferences)
    
    local result = user:toString()
    print("Result:", result)
    
    return result
end)

if not success4 then
    print("Error:", result4)
end

print("5. Opt methods:")

local success5, result5 = pcall(function()
    local JSONObject = Class("org.json.JSONObject")
    local jsonObj = new(JSONObject)
    
    jsonObj:put("existing_field", "value")
    
    local value1 = jsonObj:optString("existing_field", "default")
    local value2 = jsonObj:optString("non_existing_field", "default_value")
    local number = jsonObj:optInt("non_existing_number", 999)
    
    print("Existing field:", value1)
    print("Non-existing field:", value2)
    print("Default number:", number)
    
    return true
end)

if not success5 then
    print("Error:", result5)
end