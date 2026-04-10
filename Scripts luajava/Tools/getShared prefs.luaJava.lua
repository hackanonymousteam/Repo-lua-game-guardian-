import "android.content.Context"
import "java.io.*"

function getSharedPrefsViaAPI(prefsName)
    local sharedPrefs = activity.getSharedPreferences(prefsName, Context.MODE_PRIVATE)
    local allEntries = sharedPrefs.getAll()
    
    if allEntries.size() == 0 then
        print("data no found: "..prefsName)
        return {}
    end
    
    local result = {}
    local it = allEntries.entrySet().iterator()
    while it.hasNext() do
        local entry = it.next()
        result[entry.getKey()] = entry.getValue()
    end
    
    return result
end

function getSharedPrefsViaFile(packageName)
    local context = activity.getApplicationContext()
    local prefsDir = context.getFilesDir().getParent().."/shared_prefs/"
    local prefsFile = prefsDir..packageName.."_preferences.xml"
    
    local file = File(prefsFile)
    if not file.exists() then
        print("file no found: "..prefsFile)
        return nil
    end
    
    local content = ""
    local fis, reader
    
    local success, err = pcall(function()
        fis = FileInputStream(file)
        reader = BufferedReader(InputStreamReader(fis))
        local line = reader.readLine()
        
        while line ~= nil do
            content = content..line.."\n"
            line = reader.readLine()
        end
    end)
    
    if reader then
        reader.close()
    end
    if fis then
        fis.close()
    end
    
    if not success then
        print("Error read file: "..tostring(err))
        return nil
    end
    
    return content
end
function printPrefs(data, isXml)
    if isXml then
        print("\nConteúdo do arquivo XML:")
        print("----------------------------------------")
        print(data)
        print("----------------------------------------")
    else
        print("\nValues")
        print("----------------------------------------")
        for k,v in pairs(data) do
            local valueType = type(v)
            local formattedValue
            
            if valueType == "boolean" then
                formattedValue = tostring(v)
            elseif valueType == "number" then
                formattedValue = string.format("%.2f", v)
            elseif valueType == "string" then
                formattedValue = "\""..v.."\""
            else
                formattedValue = "["..valueType.."] "..tostring(v)
            end
            
            print(string.format("%-25s = %s", k, formattedValue))
        end
        print("----------------------------------------")
    end
end

local PREFS_NAME = gg.PACKAGE.."_preferences"

local prefsData = getSharedPrefsViaAPI(PREFS_NAME)
printPrefs(prefsData, false)

local xmlContent = getSharedPrefsViaFile(gg.PACKAGE)
if xmlContent then
    --printPrefs(xmlContent, true)
end