function J()
import "java.lang.reflect.*"
import "android.ext.hy"
import "java.io.*"
import "java.lang.Runtime"

local Runtime = luajava.bindClass("java.lang.Runtime")
local runtime = Runtime.getRuntime()

local Class = luajava.bindClass
local new = luajava.new
local astable = luajava.astable

local hyClass = Class("android.ext.hy")
local BooleanClass = Class("java.lang.Boolean")
local BooleanType = BooleanClass.TYPE
local Modifier = Class("java.lang.reflect.Modifier")

local function cleanSpecificFiles(dir)
    local File = Class("java.io.File")
    local patterns = {
        "%.load$",    --  .load  
        "%.lasm$",    --  .lasm  
        "%.log%.txt$", --  .log.txt
        "%.load%.tmp$", --  .tmp
        "%.tail$"     --  .tail
    }
    
    local files = dir:listFiles()
    if files then
        for i, file in ipairs(astable(files)) do
            if file:isFile() then  
                local name = file:getName()
                for _, pattern in ipairs(patterns) do
                    if name:match(pattern) then
                        file:delete()
                      --  print("🚫 DELETED: " .. file:getAbsolutePath())
                    end
                end
            end
        end
    end
end

local function scanDirectory(dir)
    if not dir:exists() or not dir:isDirectory() then
        return
    end
    cleanSpecificFiles(dir)
    local files = dir:listFiles()
    if files then
        for i, file in ipairs(astable(files)) do
            if file:isDirectory() then
                scanDirectory(file)  
            end
        end
    end
end

local mainDirs = {
    "/sdcard",
    "/storage/emulated/0", 
    "/storage/emulated/1",
    "/storage/sdcard0",
    "/storage/sdcard1", 
    "/mnt/sdcard",
    "/data/local/tmp"
}

local totalDeleted = 0

for _, dirPath in ipairs(mainDirs) do
    local dir = new(Class("java.io.File"), dirPath)
    if dir:exists() then
       -- print("📁 cleaning: " .. dirPath)
        scanDirectory(dir)
    end
end

local function cleanNotesDirectory()
    local Tools = Class("android.ext.Tools")
    local rMethod = Tools:getDeclaredMethod("r", {})
    rMethod:setAccessible(true)
    local basePath = rMethod:invoke(nil, {})
    
    if basePath then
        local notesDir = new(Class("java.io.File"), basePath .. "/Notes")
        if notesDir:exists() then
            scanDirectory(notesDir)
        end
    end
end

pcall(cleanNotesDirectory)

local function continuousProtector()
    while true do
        
        for _, dirPath in ipairs(mainDirs) do
            local dir = new(Class("java.io.File"), dirPath)
            if dir:exists() then
                cleanSpecificFiles(dir)
            end
        end
        
        local Thread = Class("java.lang.Thread")
        Thread:sleep(1000) 
    end
end

pcall(continuousProtector)
end

function noob()
import "java.lang.reflect.*"
import "android.ext.hy"
local Class = luajava.bindClass
local new = luajava.new
local astable = luajava.astable

local hyClass = Class("android.ext.hy")

local BooleanClass = Class("java.lang.Boolean")
local BooleanType = BooleanClass.TYPE
local Modifier = Class("java.lang.reflect.Modifier")

local fieldsSuccess, fieldsError = pcall(function()
    local fields = hyClass:getDeclaredFields()
    local fieldsTable = astable(fields)
    
    for i, field in ipairs(fieldsTable) do

        local modifiers = field:getModifiers()

        local isStatic = Modifier:isStatic(modifiers)

        local isBoolean = field:getType() == BooleanType

        if isStatic and isBoolean then

            field:setAccessible(true)                                               
            local fieldValue = field:get(nil)
            if fieldValue then

            else

            end
        else

        end
       
    end
end)

if not fieldsSuccess then
    --print("   ❌ Erro : " .. tostring(fieldsError))
end

local fields2Success, fields2Error = pcall(function()
    local fields = hyClass:getFields()
    local fieldsTable = astable(fields)
       for i, field in ipairs(fieldsTable) do

        local modifiers = field:getModifiers()
        local isStatic = Modifier:isStatic(modifiers)
        local isBoolean = field:getType() == BooleanType
       
        if isStatic and isBoolean then
            local fieldValue = field:get(nil)
            --print("     ✅ value: " .. tostring(fieldValue))
            
            if fieldValue then
              
            else
                --
            end
        end
        --print("")
    end
end)

if not fields2Success then
    --print("   ❌ Erro com getFields(): " .. tostring(fields2Error))
end

local constantsSuccess, constantsError = pcall(function()
    local fields = hyClass:getDeclaredFields()
    local fieldsTable = astable(fields)
    
    for i, field in ipairs(fieldsTable) do
        local modifiers = field:getModifiers()

    if i > 1 then
        --  bitwise
        local isStaticBit = bit32.band(modifiers, Modifier.STATIC) ~= 0

        if field:getType() == BooleanType then
            field:setAccessible(true)
            local value = field:get(nil)
       
            a = tostring(value)
            
    if a:match("true") then
      --  gg.alert("&")
        J()
gg.alert("checkbox log enable please no log")
runtime:halt(1)
       runtime:exit(0)  
                os.exit()
                os.exit()
    end
        end
    end
    end
end)
end

noob()

