gg.setVisible(false)
gg.sleep(1500)
gg.alert("click in gg for on/off exit script                  (click interrupt)")

gg.setRanges(gg.REGION_C_ALLOC)
gg.searchNumber("2.0", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, -0, -1, -0)
gg.refineNumber("2.0", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, -0, -1, -0)
gg.getResults(2)
gg.addListItems(gg.getResults(gg.getResultsCount()))
gg.saveList("/storage/emulated/0/Android/Function.off.txt", 0)
gg.editAll("5", gg.TYPE_FLOAT)
gg.addListItems(gg.getResults(gg.getResultsCount()))
gg.saveList("/storage/emulated/0/Android/Function.on.txt", 0)
gg.editAll("2.0", gg.TYPE_FLOAT)
 

Status=false
function Main()
if Status == false then
gg.loadList("/storage/emulated/0/Android/Function.on.txt", gg.LOAD_VALUES_FREEZE)
gg.sleep(50)
gg.toast(" 👻 Function ON 👻")

Status=true
elseif Status == true then
gg.loadList("/storage/emulated/0/Android/Function.off.txt", gg.LOAD_VALUES_FREEZE)
gg.sleep(50)
gg.toast(" ❌ Function OFF❌")

Status=false
end
Batman = -1
end
while true do
if gg.isVisible(true) then
Batman = 1
gg.setVisible(false)
end
if Batman == 1 then Main() end
end
