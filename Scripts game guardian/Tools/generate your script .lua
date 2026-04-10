

get = gg.getRangesList
un = get("libunity.so")[1].start

function batHex(val)
return val>=0 and string.format("%X", tonumber(val)) or string.format("%X", (val~ 0xffffffffffffffff <<((math.floor(math.log(math.abs(val))/math.log(10)) + 1) *4)))
end
 
 -- create by Batman Games 
 -- telegram @batmangamesS
g = {}
g.last = "/sdcard"
g.info = nil
g.config = gg.EXT_CACHE_DIR .. "/" .. gg.getFile():match("[^/]+$") .. "cfg"
g.data = loadfile(g.config)
if g.data ~= nil then
  g.info = g.data()
  g.data = nil
end
if g.info == nil then
  g.info = {
    g.last,
    g.last:gsub("/[^/]+$", "")
  }
end

while true do
  
  g.info = gg.prompt({
    ' Select folder to save script:', -- 1
    ' name script', -- 2
    ' create script', -- 4
  }, g.info, {
    'path', -- 1
    'text', -- 2
    'checkbox', -- 3
      })
  
  gg.saveVariable(g.info, g.config)
  g.last = g.info[1]
  if g.last == nil or g.last == "" then
    return gg.alert("⚠️ Folder cannot be empty! ⚠️")
  end

  g.out = g.last .. '/' .. g.info[2] .. '.lua'
  

local DATA = ""

if g.info[3] == true then

    gg.setRanges(gg.REGION_CODE_APP)
gg.searchNumber("-0.50347691774;9.99999997e-7:9", gg.TYPE_FLOAT)
gg.refineNumber("9.99999997e-7", gg.TYPE_FLOAT)
local ro = gg.getResults(10)

if #ro == 0 then
    gg.setRanges(gg.REGION_CODE_APP)
    gg.searchNumber("-0.50347091774~-0.50344071796;1e-6::5", gg.TYPE_FLOAT)
    gg.refineNumber("9.99999997e-7", gg.TYPE_FLOAT)
    ro = gg.getResults(10)

    if #ro == 0 then
        gg.alert("VALUE NOT FOUND -_-")
        os.exit()
    end
end

local S = {}
for i, result in ipairs(ro) do
    S[i] = result.address
end

local Wall = nil
if #S > 0 then
    Wall = batHex(S[1] - un)
    wallhex = "000080BF"
else
    Wall = 0x0
    wallhex = "7F454C46"
end

gg.setRanges(gg.REGION_CODE_APP)
gg.searchNumber("-7.16042653e24;360;3.14159274101::9", gg.TYPE_FLOAT)
gg.refineNumber("360", gg.TYPE_FLOAT)
ro = gg.getResults(10)

if gg.getResultsCount() == 0 then
    gg.searchNumber("-7.15917215e24;360;3.14159274101::9", gg.TYPE_FLOAT)
    gg.refineNumber("360", gg.TYPE_FLOAT)
    ro = gg.getResults(10)
    
    if gg.getResultsCount() == 0 then
        gg.searchNumber("360;3.14159274101::5", gg.TYPE_FLOAT)
        gg.refineNumber("360", gg.TYPE_FLOAT)
        ro = gg.getResults(10)
        
        if gg.getResultsCount() == 0 then
            gg.searchNumber("-7.16919215e24~-7.15917215e24;360;3.14159274101::9", gg.TYPE_FLOAT)
            gg.refineNumber("360", gg.TYPE_FLOAT)
            ro = gg.getResults(10)
            
            if gg.getResultsCount() == 0 then
                
            end
        end
    end
end

local T = {}
for i, result in ipairs(ro) do
    T[i] = result.address
end

local cam = nil
if #T > 0 then
    cam = batHex(T[1] - un)
    camhex = "00808943"
else
    cam = 0x0
    camhex = "7F454C46"
end

gg.setRanges(gg.REGION_CODE_APP)
gg.searchNumber("-7.16145955e24;0.00100000005::5", gg.TYPE_FLOAT)
gg.refineNumber("0.00100000005", gg.TYPE_FLOAT)
ro = gg.getResults(10)

local U = {}
for i, result in ipairs(ro) do
    U[i] = result.address
end

local dark = nil
if #U > 0 then
    dark = batHex(U[1] - un)
    darkhex = "00C07944"
else
    dark = 0x0
    darkhex = "7F454C46"
end

gg.setRanges(gg.REGION_CODE_APP)
gg.searchNumber("0.99000000954;0.57735025883;0.00999999978;9.99999997e-7:13", gg.TYPE_FLOAT)
gg.refineNumber("9.99999997e-7", gg.TYPE_FLOAT)
ro = gg.getResults(10)

if gg.getResultsCount() == 0 then
    
end

local V = {}
for i, result in ipairs(ro) do
    V[i] = result.address
end

local sky = nil
if #V > 0 then
    sky = batHex(V[1] - un)
else
    sky = 0x0
end

gg.setRanges(gg.REGION_CODE_APP)
gg.searchNumber("-2188690589493493752;-2220275583137349632:25", gg.TYPE_QWORD)
gg.refineNumber("-2220275583137349632", gg.TYPE_QWORD)
ro = gg.getResults(10)

local X = {}
for i, result in ipairs(ro) do
    X[i] = result.address
end

local fast = nil
if #X > 0 then
    fast = batHex(X[1] - un)
    fasthex = "0200A0E31EFF2FE1"
 
else
    fast = 0x0
    fasthex = "7F454C46"
end
   local start = gg.prompt({
        "✏️ Wallhack",
        "✏️ camera hack",
        "✏️ Dark mode",
        "✏️ Black sky",
        "✏️ Fast music", 
        "✏️ exit",
        "✏️ script by: your name",
        "✏️ Your libname",
    }, {
        "Wallhack",
        "camera hack ",
        "Dark mode",
        "Black sky",
        "Fast music",
        "exit",
        "script by: your name",
        "libname",
    }, {
        "text",
        "text",
        "text",
        "text",
        "text",
        "text",
        "text",
        "text",
    })
    
    if not start then
        gg.setVisible(true)
        return
    elseif #start < 8 then
        gg.alert("⚠️ Function names cannot be empty!")
        gg.setVisible(true)
        return
    else
        
        DATA = '\nfunction ' .. start[8] .. '(lib,batman,games) local info = gg.getTargetInfo() localpack = info.nativeLibraryDir local t = gg.getRangesList(localpack.."/lib"..lib..".so") for _, __ in pairs(t) do local t = gg.getValues({{address = __.start, flags = gg.TYPE_DWORD}, {address = __.start + 0x12, flags = gg.TYPE_WORD}}) if t[1].value == 0x464C457F then batman = __["start"] + batman end assert(batman ~= nil,"[rwmem]: error, provided address is nil.") _rw = {} if type(games) == "number" then _ = "" for _ = 1, games do _rw[_] = {address = (batman - 1) + _, flags = gg.TYPE_BYTE} end for v, __ in ipairs(gg.getValues(_rw)) do _ = _ .. string.format("%02X", __.value & 0xFF) end return _ end Byte = {} games:gsub("..", function(x)  Byte[#Byte + 1] = x _rw[#Byte] = {address = (batman - 1) + #Byte, flags = gg.TYPE_BYTE, value = x .. "h"}  end) gg.setValues(_rw) end  end \n' ..

        '\nfunction START()\n  menu = gg.choice({\n' ..
        '    "' .. start[1] .. '",\n' ..
        '    "' .. start[2] .. '",\n' ..
        '    "' .. start[3] .. '",\n' ..
        '    "' .. start[4] .. '",\n' ..
        '    "' .. start[5] .. '",\n' ..
        '    "' .. start[6] .. '"\n  }, nil, "' .. start[7] .. '")\n\n' ..
        '  if menu == 1 then a() end\n' ..
        '  if menu == 2 then b() end\n' ..
        '  if menu == 3 then c() end\n' ..
        '  if menu == 4 then d() end\n' ..
        '  if menu == 5 then e() end\n' ..
        '  if menu == 6 then exit() end\n  XGCK = -1\nend\n' ..
        'function a()\n  ' .. start[8] .. '("unity", 0x' .. Wall .. ',"'..wallhex..'") \n  gg.toast(\'function "' .. start[1] .. '" active\')\nend\n' ..
        'function b()\n  ' .. start[8] .. '("unity", 0x' .. cam .. ',"'..camhex..'") \n  gg.toast(\'function "' .. start[2] .. '" active\')\nend\n' ..
        'function c()\n  ' .. start[8] .. '("unity", 0x' .. dark .. ',"'..darkhex..'") \n  gg.toast(\'function "' .. start[3] .. '" active\')\nend\n' ..
        'function d()\n  ' .. start[8] .. '("unity", 0x' .. sky .. ',"'..wallhex..'") \n  gg.toast(\'function "' .. start[4] .. '" active\')\nend\n' ..
        'function e()\n  ' .. start[8] .. '("unity", 0x' .. fast .. ',"'..fasthex..'") \n  gg.toast(\'function "' .. start[5] .. '" active\')\nend\n' ..
        'function exit()\n  --insert code here\n  \n' ..
        '  gg.toast("🇧🇷exit Script🇧🇷")\n' ..
        '  print("☆┌─┐   .─┐☆")\n' ..
        '  print("    │▒│ /▒/      ")\n' ..
        '  print("    │▒│/▒/       ")\n' ..
        '  print("    │▒/▒/─┬─┐")\n' ..
        '  print("    │▒│▒|▒│▒│ ")\n' ..
        '  print("┌┴─┴─┐-┘─┘  ")\n' ..
        '  print("│▒┌──┘▒▒▒│ ")\n' ..
        '  print("└┐▒▒▒▒▒▒┌┘")\n' ..
        '  print("    └┐▒▒▒▒┌┘")\n' ..
        '  gg.clearResults()\n' ..
        '  os.exit()\n' ..
        'end\n' ..
        'while true do\n' ..
        '  if gg.isVisible(true) then\n' ..
        '    XGCK = 1\n' ..
        '    gg.setVisible(false)\n' ..
        '  end\n' ..
        '  if XGCK == 1 then\n' ..
        '    START()\n' ..
        '  end\n' ..
        '  XGCK = -1\n' ..
        'end\n' .. DATA
    end

    io.open(g.out, "w"):write(DATA):close()
    gg.clearResults()
    local ClU = '📂 File Saved To: ' .. g.out .. '\n'
    gg.alert(ClU, '')
    print("\n▬▬▬▬▬▬▬▬▬▬▬▬▬\n📂 File Saved To :" .. g.out .. "\n▬▬▬▬▬▬▬▬▬▬▬▬▬")
return 
end
end 