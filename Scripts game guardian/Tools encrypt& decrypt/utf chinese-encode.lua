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
    ' Select file :', -- 1
    'Select folder  :'
  }, g.info, {
    'file', 
    'path'
  })
  gg.saveVariable(g.info, g.config)
  g.last = g.info[1]
  if loadfile(g.last) == nil then
    gg.alert("Script not Found!")
    return
  else
    g.out = g.last:match("[^/]+$")
    g.out = g.out:gsub(".lua", ".china")
    g.out = g.info[2] .. "" .. g.out .. ".lua"
     checkk= g.out:match("^.+/(.+)$")
  end
  local file = io.open(g.last, "r")
  local DATA = file:read('*a')
  file:close()

local function __y(str)
    local Nm = {}
    for i, ii in utf8.codes(str) do
        local A = utf8.char(ii + 30000)  
        table.insert(Nm, A)
    end
    return table.concat(Nm, "")
end

local DEC =[[
local __x = function(str) local Nm = {} ; local A = "" for i,ii in utf8.codes(str) do A = utf8.char(ii - 30000) ; table.insert(Nm,A) end return (''..table.concat(Nm,"")..'') end
]]

 function encodegg(code)
return 'gg[__x("' .. __y(code) .. '")]('
end

function encodeos(code)
return 'os[__x("' .. __y(code) ..'")]('
end

function encodestr(code)
return 'string[__x(' .. __y(code) .. ')]('
end

function encvalues(code)
return '__x("' .. __y(code) .. '")'
end

DATA = DATA:gsub('%".-(.-)%"', encvalues)
DATA = DATA:gsub("%'.-(.-)%'", encvalues)
DATA = DATA:gsub('%[%[.-(.-)%]%]', encvalues)
DATA = DATA:gsub("gg%.(%a+)%(", encodegg)
DATA = DATA:gsub("string%.(%a+)%(", encodestr)
DATA = DATA:gsub("os%.(%a+)%(", encodeos)

GG = DEC..DATA

io.open(g.out,"w"):write(GG):close()

alertBatman = '📂 File Saved To: '..g.out..'\n'
gg.alert(alertBatman, '')
return 
end