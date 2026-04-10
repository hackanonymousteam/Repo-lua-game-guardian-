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

while true do
  g.info = gg.prompt({
    '📂 Select file :', -- 1
    '📂 Select folder  :' -- 2
  }, g.info, {
    'file', -- 1
    'path' -- 2
  })

  gg.saveVariable(g.info, g.config)
  g.last = g.info[1]
  if loadfile(g.last) == nil then
    gg.alert("⚠️ Script not Found! ⚠️")
    return
  else
    g.out = g.last:match("[^/]+$")
    g.out = g.out:gsub(".lua", ".Batman")
    g.out = g.info[2] .. "/" .. g.out .. ".lua"
  end

  local file = io.open(g.last, "r")
  local DATA = file:read('*a')
  file:close()

function encode_string(str)
    local encoded_data = ""
    for i = 1, #str do
        local char = str:sub(i, i)
        encoded_data = encoded_data .. string.format("%02X", string.byte(char))
    end
    return encoded_data
end
DATA = encode_string(DATA)

  local descript_code = [[
x=function () end 
if (nil) then x(x(x(x(x(x(x(x(x(x(x(x(x(x(x(1))))))))))))))) end
x=math.random
if (nil) then x(x(x(x(x(x(x(x(x(x(x(x(x(x(x(10))))))))))))))) end
while(false)do LOADK={} if LOADK.LOADK.LOADK.LOADK~=LOADK.LOADK.LOADK.LOADK then LOADK=LOADK(LOADK) LOADK.LOADK=LOADK.LOADK(LOADK) LOADK.LOADK.LOADK=LOADK.LOADK.LOADK(LOADK) LOADK.LOADK.LOADK.LOADK=LOADK.LOADK.LOADK.LOADK(LOADK)
LOADK.LOADK.LOADK.LOADK=LOADK.LOADK.LOADK.LOADK() end end
x=function () end 
if (nil) then x(x(x(x(x(x(x(x(x(x(x(x(x(x(x(1))))))))))))))) end
x=math.random
if (nil) then x(x(x(x(x(x(x(x(x(x(x(x(x(x(x(10))))))))))))))) end
file,err=io.open("/sdcard/Android/data/com.eidymumcghpfeeeavps")
  jg=err:match("%((.-)%)")
if jg=="Is a directory" then 
gg.alert("ERROR")
os.exit() 
elseif jg=="No such file or directory" then  
end
while(false)do LOADK={} if LOADK.LOADK.LOADK.LOADK~=LOADK.LOADK.LOADK.LOADK then LOADK=LOADK(LOADK) LOADK.LOADK=LOADK.LOADK(LOADK) LOADK.LOADK.LOADK=LOADK.LOADK.LOADK(LOADK) LOADK.LOADK.LOADK.LOADK=LOADK.LOADK.LOADK.LOADK(LOADK)
LOADK.LOADK.LOADK.LOADK=LOADK.LOADK.LOADK.LOADK() end end
x=function () end 
if (nil) then x(x(x(x(x(x(x(x(x(x(x(x(x(x(x(1))))))))))))))) end
x=math.random
if (nil) then x(x(x(x(x(x(x(x(x(x(x(x(x(x(x(10))))))))))))))) end
file,err=io.open("/sdcard/Android/data/cn.lovesong.luadec")
  jg=err:match("%((.-)%)")
if jg=="Is a directory" then 
gg.alert("ERROR")
os.exit() 
elseif jg=="No such file or directory" then  
end
while(false)do LOADK={} if LOADK.LOADK.LOADK.LOADK~=LOADK.LOADK.LOADK.LOADK then LOADK=LOADK(LOADK) LOADK.LOADK=LOADK.LOADK(LOADK) LOADK.LOADK.LOADK=LOADK.LOADK.LOADK(LOADK) LOADK.LOADK.LOADK.LOADK=LOADK.LOADK.LOADK.LOADK(LOADK)
LOADK.LOADK.LOADK.LOADK=LOADK.LOADK.LOADK.LOADK() end end
x=function () end 
if (nil) then x(x(x(x(x(x(x(x(x(x(x(x(x(x(x(1))))))))))))))) end
x=math.random
if (nil) then x(x(x(x(x(x(x(x(x(x(x(x(x(x(x(10))))))))))))))) end
file,err=io.open("/sdcard/Android/data/com.guoshi.httpcanary.premium")
  jg=err:match("%((.-)%)")
if jg=="Is a directory" then 
gg.alert("ERROR")
os.exit() 
elseif jg=="No such file or directory" then  
end
while(false)do LOADK={} if LOADK.LOADK.LOADK.LOADK~=LOADK.LOADK.LOADK.LOADK then LOADK=LOADK(LOADK) LOADK.LOADK=LOADK.LOADK(LOADK) LOADK.LOADK.LOADK=LOADK.LOADK.LOADK(LOADK) LOADK.LOADK.LOADK.LOADK=LOADK.LOADK.LOADK.LOADK(LOADK)
LOADK.LOADK.LOADK.LOADK=LOADK.LOADK.LOADK.LOADK() end end
x=function () end 
if (nil) then x(x(x(x(x(x(x(x(x(x(x(x(x(x(x(1))))))))))))))) end
x=math.random
if (nil) then x(x(x(x(x(x(x(x(x(x(x(x(x(x(x(10))))))))))))))) end
file,err=io.open("/sdcard/Android/data/com.guoshi.httpcanary")
  jg=err:match("%((.-)%)")
if jg=="Is a directory" then 
gg.alert("ERROR")
os.exit() 
elseif jg=="No such file or directory" then  
end
while(false)do LOADK={} if LOADK.LOADK.LOADK.LOADK~=LOADK.LOADK.LOADK.LOADK then LOADK=LOADK(LOADK) LOADK.LOADK=LOADK.LOADK(LOADK) LOADK.LOADK.LOADK=LOADK.LOADK.LOADK(LOADK) LOADK.LOADK.LOADK.LOADK=LOADK.LOADK.LOADK.LOADK(LOADK)
LOADK.LOADK.LOADK.LOADK=LOADK.LOADK.LOADK.LOADK() end end
x=function () end 
if (nil) then x(x(x(x(x(x(x(x(x(x(x(x(x(x(x(1))))))))))))))) end
x=math.random
if (nil) then x(x(x(x(x(x(x(x(x(x(x(x(x(x(x(10))))))))))))))) end
file,err=io.open("/sdcard/Android/data/cn.coldsong.fusionapp")
  jg=err:match("%((.-)%)")
if jg=="Is a directory" then 
gg.alert("ERROR")
os.exit() 
elseif jg=="No such file or directory" then  
end
while(false)do LOADK={} if LOADK.LOADK.LOADK.LOADK~=LOADK.LOADK.LOADK.LOADK then LOADK=LOADK(LOADK) LOADK.LOADK=LOADK.LOADK(LOADK) LOADK.LOADK.LOADK=LOADK.LOADK.LOADK(LOADK) LOADK.LOADK.LOADK.LOADK=LOADK.LOADK.LOADK.LOADK(LOADK)
LOADK.LOADK.LOADK.LOADK=LOADK.LOADK.LOADK.LOADK() end end
x=function () end 
if (nil) then x(x(x(x(x(x(x(x(x(x(x(x(x(x(x(1))))))))))))))) end
x=math.random
if (nil) then x(x(x(x(x(x(x(x(x(x(x(x(x(x(x(10))))))))))))))) end
file,err=io.open("/sdcard/Android/data/com.nwdxlgzs.luatools")
  jg=err:match("%((.-)%)")
if jg=="Is a directory" then 
gg.alert("ERROR")
os.exit() 
elseif jg=="No such file or directory" then  
end
while(false)do LOADK={} if LOADK.LOADK.LOADK.LOADK~=LOADK.LOADK.LOADK.LOADK then LOADK=LOADK(LOADK) LOADK.LOADK=LOADK.LOADK(LOADK) LOADK.LOADK.LOADK=LOADK.LOADK.LOADK(LOADK) LOADK.LOADK.LOADK.LOADK=LOADK.LOADK.LOADK.LOADK(LOADK)
LOADK.LOADK.LOADK.LOADK=LOADK.LOADK.LOADK.LOADK() end end
x=function () end 
if (nil) then x(x(x(x(x(x(x(x(x(x(x(x(x(x(x(1))))))))))))))) end
x=math.random
if (nil) then x(x(x(x(x(x(x(x(x(x(x(x(x(x(x(10))))))))))))))) end
file,err=io.open("/sdcard/Android/data/com.sink.hooklua")
  jg=err:match("%((.-)%)")
if jg=="Is a directory" then 
gg.alert("ERROR")
os.exit() 
elseif jg=="No such file or directory" then  
end
while(false)do LOADK={} if LOADK.LOADK.LOADK.LOADK~=LOADK.LOADK.LOADK.LOADK then LOADK=LOADK(LOADK) LOADK.LOADK=LOADK.LOADK(LOADK) LOADK.LOADK.LOADK=LOADK.LOADK.LOADK(LOADK) LOADK.LOADK.LOADK.LOADK=LOADK.LOADK.LOADK.LOADK(LOADK)
LOADK.LOADK.LOADK.LOADK=LOADK.LOADK.LOADK.LOADK() end end
x=function () end 
if (nil) then x(x(x(x(x(x(x(x(x(x(x(x(x(x(x(1))))))))))))))) end
x=math.random
if (nil) then x(x(x(x(x(x(x(x(x(x(x(x(x(x(x(10))))))))))))))) end
file,err=io.open("/sdcard/Android/data/com.mrbimc.selinux")
  jg=err:match("%((.-)%)")
if jg=="Is a directory" then 
gg.alert("ERROR")
os.exit() 
elseif jg=="No such file or directory" then  
end
while(false)do LOADK={} if LOADK.LOADK.LOADK.LOADK~=LOADK.LOADK.LOADK.LOADK then LOADK=LOADK(LOADK) LOADK.LOADK=LOADK.LOADK(LOADK) LOADK.LOADK.LOADK=LOADK.LOADK.LOADK(LOADK) LOADK.LOADK.LOADK.LOADK=LOADK.LOADK.LOADK.LOADK(LOADK)
LOADK.LOADK.LOADK.LOADK=LOADK.LOADK.LOADK.LOADK() end end
x=function () end 
if (nil) then x(x(x(x(x(x(x(x(x(x(x(x(x(x(x(1))))))))))))))) end
x=math.random
if (nil) then x(x(x(x(x(x(x(x(x(x(x(x(x(x(x(10))))))))))))))) end
file,err=io.open("/sdcard/Android/data/com.tc")
  jg=err:match("%((.-)%)")
if jg=="Is a directory" then 
gg.alert("ERROR")
os.exit() 
elseif jg=="No such file or directory" then  
end
while(false)do LOADK={} if LOADK.LOADK.LOADK.LOADK~=LOADK.LOADK.LOADK.LOADK then LOADK=LOADK(LOADK) LOADK.LOADK=LOADK.LOADK(LOADK) LOADK.LOADK.LOADK=LOADK.LOADK.LOADK(LOADK) LOADK.LOADK.LOADK.LOADK=LOADK.LOADK.LOADK.LOADK(LOADK)
LOADK.LOADK.LOADK.LOADK=LOADK.LOADK.LOADK.LOADK() end end
x=function () end 
if (nil) then x(x(x(x(x(x(x(x(x(x(x(x(x(x(x(1))))))))))))))) end
x=math.random
if (nil) then x(x(x(x(x(x(x(x(x(x(x(x(x(x(x(10))))))))))))))) end
file,err=io.open("/sdcard/Android/data/com.killerlua.dgz")
  jg=err:match("%((.-)%)")
if jg=="Is a directory" then 
gg.alert("ERROR")
os.exit() 
elseif jg=="No such file or directory" then  
end
while(false)do LOADK={} if LOADK.LOADK.LOADK.LOADK~=LOADK.LOADK.LOADK.LOADK then LOADK=LOADK(LOADK) LOADK.LOADK=LOADK.LOADK(LOADK) LOADK.LOADK.LOADK=LOADK.LOADK.LOADK(LOADK) LOADK.LOADK.LOADK.LOADK=LOADK.LOADK.LOADK.LOADK(LOADK)
LOADK.LOADK.LOADK.LOADK=LOADK.LOADK.LOADK.LOADK() end end
x=function () end 
if (nil) then x(x(x(x(x(x(x(x(x(x(x(x(x(x(x(1))))))))))))))) end
x=math.random
if (nil) then x(x(x(x(x(x(x(x(x(x(x(x(x(x(x(10))))))))))))))) end
file,err=io.open("/sdcard/Android/data/un.lua53.dgz")
  jg=err:match("%((.-)%)")
if jg=="Is a directory" then 
gg.alert("ERROR")
os.exit() 
elseif jg=="No such file or directory" then  
end
while(false)do LOADK={} if LOADK.LOADK.LOADK.LOADK~=LOADK.LOADK.LOADK.LOADK then LOADK=LOADK(LOADK) LOADK.LOADK=LOADK.LOADK(LOADK) LOADK.LOADK.LOADK=LOADK.LOADK.LOADK(LOADK) LOADK.LOADK.LOADK.LOADK=LOADK.LOADK.LOADK.LOADK(LOADK)
LOADK.LOADK.LOADK.LOADK=LOADK.LOADK.LOADK.LOADK() end end
x=function () end 
if (nil) then x(x(x(x(x(x(x(x(x(x(x(x(x(x(x(1))))))))))))))) end
x=math.random
if (nil) then x(x(x(x(x(x(x(x(x(x(x(x(x(x(x(10))))))))))))))) end
file,err=io.open("/sdcard/Android/data/com.unlual")
  jg=err:match("%((.-)%)")
if jg=="Is a directory" then 
gg.alert("ERROR")
os.exit() 
elseif jg=="No such file or directory" then  
end
while(false)do LOADK={} if LOADK.LOADK.LOADK.LOADK~=LOADK.LOADK.LOADK.LOADK then LOADK=LOADK(LOADK) LOADK.LOADK=LOADK.LOADK(LOADK) LOADK.LOADK.LOADK=LOADK.LOADK.LOADK(LOADK) LOADK.LOADK.LOADK.LOADK=LOADK.LOADK.LOADK.LOADK(LOADK)
LOADK.LOADK.LOADK.LOADK=LOADK.LOADK.LOADK.LOADK() end end
x=function () end 
if (nil) then x(x(x(x(x(x(x(x(x(x(x(x(x(x(x(1))))))))))))))) end
x=math.random
if (nil) then x(x(x(x(x(x(x(x(x(x(x(x(x(x(x(10))))))))))))))) end
file,err=io.open("/sdcard/Android/data/com.luakillerpro.dgz")
  jg=err:match("%((.-)%)")
if jg=="Is a directory" then 
gg.alert("ERROR")
os.exit() 
elseif jg=="No such file or directory" then  
end
while(false)do LOADK={} if LOADK.LOADK.LOADK.LOADK~=LOADK.LOADK.LOADK.LOADK then LOADK=LOADK(LOADK) LOADK.LOADK=LOADK.LOADK(LOADK) LOADK.LOADK.LOADK=LOADK.LOADK.LOADK(LOADK) LOADK.LOADK.LOADK.LOADK=LOADK.LOADK.LOADK.LOADK(LOADK)
LOADK.LOADK.LOADK.LOADK=LOADK.LOADK.LOADK.LOADK() end end
x=function () end 
if (nil) then x(x(x(x(x(x(x(x(x(x(x(x(x(x(x(1))))))))))))))) end
x=math.random
if (nil) then x(x(x(x(x(x(x(x(x(x(x(x(x(x(x(10))))))))))))))) end
file,err=io.open("/sdcard/Android/data/com.sstoolvip.by.Zylern")
  jg=err:match("%((.-)%)")
if jg=="Is a directory" then 
gg.alert("ERROR")
os.exit() 
elseif jg=="No such file or directory" then  
end
while(false)do LOADK={} if LOADK.LOADK.LOADK.LOADK~=LOADK.LOADK.LOADK.LOADK then LOADK=LOADK(LOADK) LOADK.LOADK=LOADK.LOADK(LOADK) LOADK.LOADK.LOADK=LOADK.LOADK.LOADK(LOADK) LOADK.LOADK.LOADK.LOADK=LOADK.LOADK.LOADK.LOADK(LOADK)
LOADK.LOADK.LOADK.LOADK=LOADK.LOADK.LOADK.LOADK() end end
x=function () end 
if (nil) then x(x(x(x(x(x(x(x(x(x(x(x(x(x(x(1))))))))))))))) end
x=math.random
if (nil) then x(x(x(x(x(x(x(x(x(x(x(x(x(x(x(10))))))))))))))) end
file,err=io.open("/sdcard/Android/data/com.lua.decompile")
  jg=err:match("%((.-)%)")
if jg=="Is a directory" then 
gg.alert("ERROR")
os.exit() 
elseif jg=="No such file or directory" then  
end
while(false)do LOADK={} if LOADK.LOADK.LOADK.LOADK~=LOADK.LOADK.LOADK.LOADK then LOADK=LOADK(LOADK) LOADK.LOADK=LOADK.LOADK(LOADK) LOADK.LOADK.LOADK=LOADK.LOADK.LOADK(LOADK) LOADK.LOADK.LOADK.LOADK=LOADK.LOADK.LOADK.LOADK(LOADK)
LOADK.LOADK.LOADK.LOADK=LOADK.LOADK.LOADK.LOADK() end end
x=function () end 
if (nil) then x(x(x(x(x(x(x(x(x(x(x(x(x(x(x(1))))))))))))))) end
x=math.random
if (nil) then x(x(x(x(x(x(x(x(x(x(x(x(x(x(x(10))))))))))))))) end
while(false)do LOADK={} if LOADK.LOADK.LOADK.LOADK~=LOADK.LOADK.LOADK.LOADK then LOADK=LOADK(LOADK) LOADK.LOADK=LOADK.LOADK(LOADK) LOADK.LOADK.LOADK=LOADK.LOADK.LOADK(LOADK) LOADK.LOADK.LOADK.LOADK=LOADK.LOADK.LOADK.LOADK(LOADK)
LOADK.LOADK.LOADK.LOADK=LOADK.LOADK.LOADK.LOADK() end end
  
local function hex_decode(hex)
    return (hex:gsub("(%x%x)", function(cc)
        return string.char(tonumber(cc, 16))
    end))
end

local d = "66756E6374696F6E206128737472290A202020206C6F63616C20726573756C74203D2022220A20202020666F722069203D20312C202373747220646F0A20202020202020206C6F63616C206F627363757265645F62797465203D207374723A627974652869290A20202020202020206C6F63616C206F726967696E616C5F62797465203D20286F627363757265645F62797465202B20313029202F20320A2020202020202020726573756C74203D20726573756C74202E2E20737472696E672E63686172286F726967696E616C5F62797465290A20202020656E640A2020202072657475726E20726573756C740A656E64200A66756E6374696F6E206228737472290A202020206C6F63616C206465636F6465645F64617461203D2022220A20202020666F722069203D20312C20237374722C203220646F0A20202020202020206C6F63616C2062797465203D20746F6E756D626572287374723A73756228692C2069202B2031292C203136290A20202020202020206465636F6465645F64617461203D206465636F6465645F64617461202E2E20737472696E672E636861722862797465290A20202020656E640A2020202072657475726E206465636F6465645F646174610A656E640A"

local e = hex_decode(d)

local loaded_code = load(e)
loaded_code()

local c = "]] .. DATA .. [["
local f, err = load(b(c))

if f then
f()
else
end
  ]]
  DATA = descript_code

io.open(g.out,"w"):write(DATA):close()

ClU = '📂 File Saved To: '..g.out..'\n'
gg.alert(ClU, '')
print("\n▬▬▬▬▬▬▬▬▬▬▬▬▬\n📂 File Saved To :" .. g.out .. "\n▬▬▬▬▬▬▬▬▬▬▬▬▬")
return 
end