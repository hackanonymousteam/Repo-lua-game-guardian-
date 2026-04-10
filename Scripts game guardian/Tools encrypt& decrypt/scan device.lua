local function readFile(path)
    local file = io.open(path, "r")  
    if not file then return nil end
    local content = file:read("*a") 
    file:close()
    return content
end

local function processContent(content)
    
    content = content:gsub("ro.odm.product.cpu.abilist=", "ARM=  ")
    content = content:gsub("ro.odm.build.version.sdk=", "SDK VERSION=  ")
    content = content:gsub("ro.product.odm.model=", "model= ")

    for line in content:gmatch("[^\r\n]+") do
          if line:match("^ARM=") or line:match("^SDK VERSION=") or line:match("^model=") then
            
            print(line)
        end
    end
end

local filePath = "/system/vendor/odm/etc/build.prop"

local fileContent = readFile(filePath)

if fileContent then
    
    processContent(fileContent)
else
    print("failed open file")
end