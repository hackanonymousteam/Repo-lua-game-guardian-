import "android.ext.*"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "java.io.*"
import "java.security.*"
import "java.util.zip.CRC32"
import "java.math.BigInteger"

local Class = luajava.bindClass
local new = luajava.new
local astable = luajava.astable
local methods = luajava.methods

local Script = Class("android.ext.Script")
local LuaValue = Class("luaj.LuaValue")


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
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

while true do
  g.info = gg.prompt({
    '📂 Select file :' -- 1

  }, g.info, {
    'file' -- 1
  -- 2
  })
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

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
  
local scriptInstance = Script(DATA, 0, "")

gg.setVisible(true)
scriptInstance:c_()


 return 
end







