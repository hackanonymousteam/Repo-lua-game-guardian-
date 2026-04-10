import "android.ext.*"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "android.content.res.AssetManager"
import "java.io.*"
import "java.util.zip.ZipFile"
import "java.util.Enumeration"
import "java.security.*"
import "java.util.zip.CRC32"
import "java.math.BigInteger"

local Class = luajava.bindClass
local new = luajava.new
local astable = luajava.astable
local methods = luajava.methods

local Script = Class("android.ext.Script")
local LuaValue = Class("luaj.LuaValue")

local function readFileFromAPK(filePath)
    local apkPath = activity.getPackageCodePath()
    local zipFile = ZipFile(apkPath)
    local entry = zipFile.getEntry(filePath)
    
    if entry == nil then
        zipFile.close()
        return nil
    end
    
    local inputStream = zipFile.getInputStream(entry)
    local reader = InputStreamReader(inputStream)
    local buffer = BufferedReader(reader)
    local content = ""
    local line = buffer:readLine()
    
    while line ~= nil do
        content = content .. line .. "\n"
        line = buffer:readLine()
    end
    
    buffer:close()
    reader:close()
    inputStream:close()
    zipFile:close()
    
    return content
end

local function listLuaFilesInAPK()
    local apkPath = activity.getPackageCodePath()
    local zipFile = ZipFile(apkPath)
    local entries = zipFile.entries()
    local luaFiles = {}
    
    while entries.hasMoreElements() do
        local entry = entries.nextElement()
        local name = entry.getName()
        
   if name:match("%.lua$") and not name:match("^META-INF/") then
              local displayName = name:gsub("^assets/", "")
            table.insert(luaFiles, {
                fullPath = name,
                displayName = displayName
            })
        end
    end
    
    zipFile.close()
    return luaFiles
end

local scripts = listLuaFilesInAPK()

if #scripts == 0 then
    gg.alert("⚠️ no files lua!")
    return
end

local displayList = {}
for i, script in ipairs(scripts) do
    table.insert(displayList, script.displayName)
end

table.insert(displayList, "❌ exit")

local selected = gg.choice(displayList, nil, "📦 Selecione um script do APK")

if selected == nil or selected == #displayList then
    return
end

local selectedScript = scripts[selected]
local scriptPath = selectedScript.fullPath
local scriptName = selectedScript.displayName

local DATA = readFileFromAPK(scriptPath)

if DATA == nil then
    gg.alert("⚠️ Erro read script: " .. scriptName)
    return
end

local scriptInstance = Script(DATA, 0, "")
gg.setVisible(true)
scriptInstance:c_()