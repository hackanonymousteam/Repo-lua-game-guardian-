b= [[
20674
Var #8E85F360|8e85f360|10|477046c0|0|0|0|0|r-xp|/data/app/com.dts.freefireth/lib/libanort.so|9b360
Var #8E85F364|8e85f364|10|477046c0|0|0|0|0|r-xp|/data/app/com.dts.freefireth/lib/libanort.so|9b364
]]
fileData = gg.EXT_STORAGE .. '/[#].dat'
  io.output(fileData):write(b):close()
  gg.loadList(fileData, gg.LOAD_APPEND)
  gg.sleep(50)
  r = gg.getListItems()
  getReset = gg.getValues(r)
   
function TEST()
  menuchA= gg.multiChoice({
"➣  FUNCTION ON ", 
"➣  FUNCTION OFF", 
"VOLTAR"})

if menuchA == nil then else
if menuchA[1] == true then AT1() end
if menuchA[2] == true then AT2() end
if menuchA[3] == true then start () end
end
end

function AT1() 
gg.loadList("/storage/emulated/0/[#].dat")
gg.clearList()
gg.toast(" on") 
end

function AT2() 
gg.loadList("/storage/emulated/0/[#].dat")
if revert ~= nil then gg.setValues(revert) end
gg.clearList()
gg.toast(" off") 
end

function EXIT() 
os.exit() 
end

while true do
if gg.isVisible(true) then BATMAN = 1
gg.setVisible(false)
gg.clearResults() end
if BATMAN == 1 then TEST() end end 