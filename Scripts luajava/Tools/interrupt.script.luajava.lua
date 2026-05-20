if luajava == nil then gg.alert(' unavaliable please use gameguardian mod (suport luajava)') else end
if gg.VERSION_INT < 10100 then
    gg.alert("use GameGuardian 101.1 luajava")
    os.exit()
    return
end
local Class = luajava.bindClass
local new = luajava.new
local astable = luajava.astable
local methods = luajava.methods

local Script = Class("android.ext.Script")

local path = gg.getFile()
local file = io.open(path, "r")

if not file then
    error("Failed to open file")
end

local code = file:read("*a")
file:close()

local scriptInstance = Script(code, 0, "")
gg.toast("done")
scriptInstance:self():interrupt()


