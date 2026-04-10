local key = "d5?;,.)(j+=@<>/&" 

local Secure = luajava.bindClass("android.provider.Settings$Secure")
local uid = Secure.getString(activity:getContentResolver(), Secure.ANDROID_ID)

if not string.AES then
gg.alert(" AES no avaliable.")
os.exit()
end

if fixedUID ~= nil then
local decoded = string.AES(fixedUID, key, "de")
if decoded ~= uid then
gg.alert("forbiden.")
os.exit()
else
gg.toast("sucess.")
end
return
end

local encoded = string.AES(uid, key, "en")
--gg.alert("UID encoded:\n\n" .. encoded)

local template = [[

function start()
gg.alert("welcome")
end

local key = "%s"
local fixedUID = "%s"

local Secure = luajava.bindClass("android.provider.Settings$Secure")
local uid = Secure.getString(activity:getContentResolver(), Secure.ANDROID_ID)

if not string.AES then
gg.alert(" AES no avaliable.")
os.exit()
end

if fixedUID ~= nil then
local decoded = string.AES(fixedUID, key, "de")
if decoded ~= uid then
gg.alert("device forbidden.")
os.exit()
else
gg.toast("sucess.")
--Start your script here
--example
start()

end
return
end

]]

local finalScript = string.format(template, key, encoded)

local path = "/sdcard/uid.lua"
local file = io.open(path, "w")
if file then
file:write(finalScript)
file:close()
else
gg.alert("Erro.")
end

local OBF_LEVEL = 5
local STRING_PROTECTION = true
local BYTECODE_OBFUSCATION = true

local function RandomName()
local parts = {}
for i = 1, math.random(5,10) do
parts[i] = string.char(math.random(97, 122))
end
return table.concat(parts)
end

local function EncodeBytecode(bc)
local encoded = {}
for i = 1, #bc do
encoded[i] = string.format("%03d", bc:byte(i))
end
return table.concat(encoded)
end

local LOADER_TEMPLATE = [[
local function _L()
local b = "%s"
if #b %% 3 ~= 0 then return nil end

local c = {}  
for i = 1, #b, 3 do  
    local byte_str = b:sub(i, i+2)  
    local byte_num = tonumber(byte_str)  
    if not byte_num or byte_num < 0 or byte_num > 255 then  
        return nil  
    end  
    c[#c+1] = string.char(byte_num)  
end  
local chunk = load(table.concat(c))  
if not chunk then return nil end  
return chunk()

end

_L()
]]

local chunk, err = loadfile(path)  
if not chunk then  
    gg.alert("❌ Erro: "..(err or "file error"))  
else  
      
    local bytecode = string.dump(chunk)  
      
    local encoded = EncodeBytecode(bytecode)  
      
    local protected = "--[[ Bytecode protected simple ]]--\n"  
    protected = protected..string.format(LOADER_TEMPLATE, encoded)  
    
    local f = io.open(path, "w")  
    if f then  
        f:write(protected)  
        f:close()  
        gg.alert("Your script work only  this device \n\n save in:  " .. path)
        os.exit()  
    else  
        gg.alert("❌ error")  
    end  
end

os.exit()
