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

local emojis = {"😊", "🔥", "💀", "⚡", "💎", "⭐", "🎯", "🔰", "👑", "🌙"}
local choice = gg.choice({
    "😊",
    "🔥",
    "💀",
    "⚡",
    "💎",
    "⭐",
    "🎯",
    "🔰",
    "👑",
    "🌙",
    "enter emoji"
}, nil, "select")

if choice == nil then return end

local emoji = "💀"
local sep = " "

if choice == 11 then
  local r = gg.prompt({"emoji:", "separator:"}, {"💀", " "}, {"text", "text"})
  if r then
    emoji = r[1]
    sep = r[2] ~= "" and r[2] or " "
  else
    return
  end
else
  emoji = emojis[choice]
end

local header_input = gg.prompt({
    "Enter header:"
}, {""}, {"text"})

if header_input == nil then return end
local header_text = header_input[1]

function encode(t, c, s)
  local r = {}
  for i = 1, #t do
    local b = string.byte(t, i)
    local block = ""
    for j = 1, b do block = block .. c end
    table.insert(r, block)
  end
  return table.concat(r, s)
end

while true do
  g.info = gg.prompt({
    'file:',
    'folder:'
  }, g.info, {
    'file',
    'path'
  })
  
  if g.info == nil then break end
  
  gg.saveVariable(g.info, g.config)
  g.last = g.info[1]
  
  if loadfile(g.last) == nil then
    gg.alert("error")
    return
  else
    g.out = g.last:match("[^/]+$")
    g.out = g.out:gsub(".lua", ".enc")
    g.out = g.info[2] .. "/" .. g.out .. ".lua"
  end
  
  local f = io.open(g.last, "r")
  local data = f:read('*a')
  f:close()
  
  local decode = string.format([[
local E="%s"
local S="%s"
function d(c)
 local r=""
 for b in string.gmatch(c,"[^"..S.."]+") do
  local cnt=0
  local p=1
  while true do
   local i,j=string.find(b,E,p,true)
   if not i then break end
   cnt=cnt+1
   p=j+1
  end
  r=r..string.char(cnt)
 end
 return r
end
]], emoji, sep)
  
  function eg(c) return 'gg[d("'..encode(c,emoji,sep)..'")](' end
  function eo(c) return 'os[d("'..encode(c,emoji,sep)..'")](' end
  function es(c) return 'string[d("'..encode(c,emoji,sep)..'")](' end
  function ev(c) return 'd("'..encode(c,emoji,sep)..'")' end
  function ei(c) return 'io[d("'..encode(c,emoji,sep)..'")](' end
  function em(c) return 'math[d("'..encode(c,emoji,sep)..'")](' end
  function et(c) return 'table[d("'..encode(c,emoji,sep)..'")](' end
  
  local p = data
  p = p:gsub('"([^"\n]-)"', ev)
  p = p:gsub("'([^'\n]-)'", ev)
  p = p:gsub("%[%[([^%]%]-)%]%]", ev)
  p = p:gsub("gg%.([%a_][%w_]*)%(", eg)
  p = p:gsub("string%.([%a_][%w_]*)%(", es)
  p = p:gsub("os%.([%a_][%w_]*)%(", eo)
  p = p:gsub("io%.([%a_][%w_]*)%(", ei)
  p = p:gsub("math%.([%a_][%w_]*)%(", em)
  p = p:gsub("table%.([%a_][%w_]*)%(", et)
  
  local final
  
  if header_text ~= "" then
    final = string.format([[
_G._ = [==[%s]==]


%s


%s
]], header_text, decode, p)
  else
    final = decode .. "\n" .. p
  end
  
  local compiled = string.dump(load(final), true)
  compiled = string.gsub(compiled, 'LuaR', 'LuaR', 1)
  
  local out_file = io.open(g.out, "wb")
  out_file:write(compiled)
  out_file:close()
  
  gg.alert("File saved to:\n" .. g.out)
  print(g.out)
  break
end