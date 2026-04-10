
function Batman(lib,batman,games) 
 
 local info = gg.getTargetInfo() 
localpack = info.nativeLibraryDir
 local t = gg.getRangesList(localpack.."/"..lib..".so") 
 
  for _, __ in pairs(t)
 
 do local t = gg.getValues({{address = __.start, flags = gg.TYPE_DWORD}, 
{address = __.start , flags = gg.TYPE_BYTE}})

 if t[1].value == 0x464C457F then batman = __["start"] + batman end 
 
assert(batman ~= nil,"[rwmem]: error, provided address is nil.") _rw = {}
 if type(games) == "number" then _ = "" for _ = 1, 
 
games do _rw[_] = {address = (batman + 4) + _, flags = gg.TYPE_BYTE} end 

for v, __ in ipairs(gg.getValues(_rw)) do _ = _ .. string.format("%02X", __.value & 0xFF) 
end return _ end Byte = {} games:gsub("..", function(x)  

--disloc 16 decimal 10 hex
Byte[#Byte ] = x _rw[#Byte] = {address = (batman + 16) + #Byte, flags = gg.TYPE_BYTE, value = x .. "h"}  end) 

gg.setValues(_rw) end  end



Batman("libunity",0x0,"00")
Batman("libunity",0x1,"00")
Batman("libunity",0x3,"80")
Batman("libunity",0x4,"BF")

gg.toast("ACTIVE ✔")


