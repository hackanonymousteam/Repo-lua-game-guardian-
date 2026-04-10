import "java.net.*"
import "java.io.*"
import "java.util.*"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"

local Class = luajava.bindClass
local new = luajava.new
local astable = luajava.astable

print("3. HttpURLConnection - Client HTTP Advanced:")
local URL = Class("java.net.URL")
local HttpURLConnection = Class("java.net.HttpURLConnection")

local httpSuccess, httpError = pcall(function()
    local testUrl = new(URL, "https://httpbin.org/get")
    local connection = testUrl:openConnection()
    
    print("   ✅ HTTP created:")
    print("     URL:", connection:getURL():toString())
    
    connection:setConnectTimeout(10000)
    connection:setReadTimeout(10000)
    connection:setRequestProperty("User-Agent", "LuaJava-HTTP-Client")
    connection:setRequestProperty("Accept", "application/json")
    
    print("     Timeout:", connection:getConnectTimeout() .. "ms")
    print("     User-Agent set")
    
    connection:connect()
    
    local responseCode = connection:getResponseCode()
    local responseMessage = connection:getResponseMessage()
    
    print("   📡 reply HTTP:")
    print("     code:", responseCode)
    print("     message:", responseMessage)
    print("     content:", connection:getContentType())
    print("     size content:", connection:getContentLength())
    
    local inputStream = connection:getInputStream()
    local reader = new(BufferedReader, new(InputStreamReader, inputStream))
    
    local responseBody = {}
    local line = reader:readLine()
    while line do
        table.insert(responseBody, line)
        line = reader:readLine()
    end
    
    print("   📄 body reply (" .. #responseBody .. " linhas):")
    for i = 1, math.min(3, #responseBody) do
        print("     " .. responseBody[i])
    end
    if #responseBody > 3 then
        print("     ... (mais " .. (#responseBody - 3) .. " linhas)")
    end
    
    connection:disconnect()
end)

if not httpSuccess then
    print("   ❌ Erro HTTP:", httpError)
end
print()