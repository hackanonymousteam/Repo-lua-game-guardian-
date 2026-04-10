import "java.net.*"

local Class = luajava.bindClass
local new = luajava.new
local URL = Class("java.net.URL")

function downloadFileSimple(urlString, fileName)
    print("")
    print("=== SIMPLE DOWNLOAD ===")
    print("URL: " .. urlString)
    print("File: " .. fileName)
    
    local fullPath = "/sdcard/Download/" .. fileName
    print("Saving to: " .. fullPath)
    
    local success, err = pcall(function()
        local url = new(URL, urlString)
        local connection = url:openConnection()
        connection:setConnectTimeout(10000)
        connection:setReadTimeout(10000)
        connection:connect()
        
        local responseCode = connection:getResponseCode()
        print("HTTP: " .. responseCode)
        
        if responseCode ~= 200 then
            print("HTTP " .. responseCode)
        end
        
        local total = connection:getContentLength()
        print("Size: " .. total .. " bytes")
        
        local input = connection:getInputStream()
        local file = io.open(fullPath, "wb")
        
        if not file then
            print("Unable to create file: " .. fullPath)
        end
        
        local downloaded = 0
        local lastPercent = 0
        
        while true do
            local byte = input:read()
            if byte == -1 then break end
            
            local char = string.char(byte)
            file:write(char)
            
            downloaded = downloaded + 1
            
            if total > 0 then
                local percent = math.floor((downloaded / total) * 100)
                if percent >= lastPercent + 5 then
                    print("Progress: " .. percent .. "%")
                    lastPercent = percent
                end
            end
        end
        
        file:close()
        input:close()
        connection:disconnect()
        
        print("")
        print("DOWNLOAD COMPLETED")
        print("FILE: " .. fullPath)
        
        if fileName:match("%.apk$") then
            print("TO INSTALL: pm install " .. fullPath)
        end
    end)
    
    if not success then
        print("")
        print("ERROR: " .. tostring(err))
        return false
    end
    
    return true
end

function downloadMT()
    local url = "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSxEJK-yVod3zg6zSXabx_ju0TG91koZBc1NAYOwZgxng&s"
    local filename = "mt.png"
    
    print("Downloading image...")
    local ok = downloadFileSimple(url, filename)
    return ok
end

print("")
print("=== END ===")