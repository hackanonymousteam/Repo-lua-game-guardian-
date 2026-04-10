--------------------------------------------------------------------------------
--open game to run this script
--script created by Batman Games
--support  to detect change of 1 value
--detect change of float values
-- this script is beta
--support for libil2cpp, libunity.

--------------------------------------------------------------------------------
get = gg.getRangesList
un = get("libunity.so")[1].start
so = get("libil2cpp.so")[1].start

--ano = get("libanogs.so")[1].start
--------------------------------------------------------------------------------

function batHex(val)
return val>=0 and string.format("%X", tonumber(val)) or string.format("%X", (val~ 0xffffffffffffffff <<((math.floor(math.log(math.abs(val))/math.log(10)) + 1) *4)))
end

--------------------------------------------------------------------------------

MAIN = -1
function BATMAN()
menu = gg.choice({

"LIBIL2CPP",
"LIBUNITY",

"EXIT"
},nil, "Please select the library")

if menu == 0 then else
if menu == 1 then I() end
if menu == 2 then Il() end
if menu == 3  then out() end
end
MAIN = -1
end

--------------------------------------------------------------------------------

function I()
  menuchx= gg.multiChoice({
     "SEARCH VALUES LIBIL2CPP",
     "GET VALUES CHANGED LIBIL2CPP",
     "BACK"})

if menuchx == nil then else
if menuchx[1] == true then  search() end
if menuchx[2] == true then  getValues() end
if menuchx[3] == true then START () end
end
end


function search()
gg.setRanges(gg.REGION_CODE_APP)
gg.startFuzzy(gg.TYPE_FLOAT, 0, -1, 0)
end

function getValues()
gg.setRanges(gg.REGION_CODE_APP)
gg.searchFuzzy('0', gg.SIGN_FUZZY_NOT_EQUAL)

-- value changed add

ro=gg.getResults(1)

if gg.getResultsCount(1) == 0 then
 gg.alert("VALUE NOT CHANGED -_-")

os.exit()
end


local S={}
S[1]=ro[1].address

--[[
S[2]=ro[2].address
S[3]=ro[3].address
S[4]=ro[4].address
S[5]=ro[5].address
S[6]=ro[6].address
S[7]=ro[7].address
S[8]=ro[8].address
S[9]=ro[9].address
S[10]=ro[10].address
S[11]=ro[11].address
S[12]=ro[12].address
S[13]=ro[13].address
S[14]=ro[14].address
S[15]=ro[15].address
]]--

--output
--gg.alert('< ---------VALUE CHANGED LIBIL2CPP--------  >\n\n>OFFSET :  0x'..batHex(S[1]-so)..'')
 
--\n>OFFSET :  0x'..batHex(S[1]-so)..'\n>OFFSET :  0x'..batHex(S[2]-so)..'\n>OFFSET :  0x'..batHex(S[3]-so)..'\n>OFFSET :  0x'..batHex(S[4]-so)..'\n>OFFSET :  0x'..batHex(S[5]-so)..'\n>OFFSET :  0x'..batHex(S[6]-so)..'\n>OFFSET :  0x'..batHex(S[7]-so)..'\n>OFFSET :  0x'..batHex(S[8]-so)..'\n>OFFSET :  0x'..batHex(S[9]-so)..'\n>OFFSET :  0x'..batHex(S[10]-so)..'\n>OFFSET :  0x'..batHex(S[11]-so)..'\n>OFFSET :  0x'..batHex(S[12]-so)..'\n>OFFSET :  0x'..batHex(S[13]-so)..'\n>OFFSET :  0x'..batHex(S[14]-so)..'

gg.setVisible(true)
print('< ---------VALUE CHANGED LIBIL2CPP--------  >\n\n>OFFSET :  0x'..batHex(S[1]-so)..'')
out()

end

--------------------------------------------------------------------------------

function Il()
  menuchx= gg.multiChoice({
     "SEARCH VALUES LIBUNITY",
     "GET VALUES CHANGED LIBUNITY",
      "BACK"})

if menuchx == nil then else
if menuchx[1] == true then  searchuni() end
if menuchx[2] == true then  getValuesuni() end
if menuchx[3] == true then START () end
end
end


function searchuni()
gg.setRanges(gg.REGION_CODE_APP)
gg.startFuzzy(gg.TYPE_FLOAT, 0, -1, 0)
end

function getValuesuni()
gg.setRanges(gg.REGION_CODE_APP)
gg.searchFuzzy('0', gg.SIGN_FUZZY_NOT_EQUAL)

-- value changed add

ro=gg.getResults(1)
if gg.getResultsCount(1) == 0 then
 gg.alert("VALUE NOT CHANGED -_-")

os.exit()
end


local S={}
S[1]=ro[1].address

--output
--gg.alert('< ---------VALUE CHANGED LIBUNITY--------  >\n\n>OFFSET :  0x'..batHex(S[1]-un)..'')

gg.setVisible(true)
print('< ---------VALUE CHANGED LIBUNITY--------  >\n\n>OFFSET :  0x'..batHex(S[1]-un)..'')
out() 

end


--------------------------------------------------------------------------------

function III()
  menuchx= gg.multiChoice({
     "SEARCH VALUES LIBANOGS",
     "GET VALUES CHANGED LIBANOGS",
      "BACK"})

if menuchx == nil then else
if menuchx[1] == true then  searchuano() end
if menuchx[2] == true then  getValuesano() end
if menuchx[3] == true then START () end
end
end


function searchano()
gg.setRanges(gg.REGION_CODE_APP)
gg.startFuzzy(gg.TYPE_FLOAT, 0, -1, 0)
end

function getValuesano()
gg.setRanges(gg.REGION_CODE_APP)
gg.searchFuzzy('0', gg.SIGN_FUZZY_NOT_EQUAL)

-- value changed add

ro=gg.getResults(1)
if gg.isVisible(true) then
gg.clearResults()
gg.alert("VALUE NOT FOUND -_-")
out()
end

local S={}
S[1]=ro[1].address

--output
gg.alert('< ---------VALUE CHANGED LIBANOGS--------  > \n\n>OFFSET :  0x'..batHex(S[1]-ano)..'')

--gg.setVisible(true)
--print('< ---------VALUE CHANGED LIBANOGS--------  > \n\n>OFFSET :  0x'..batHex(S[1]-ano)..'')
--out() 

end

--------------------------------------------------------------------------------
function out() 
os.exit() 
end

--------------------------------------------------------------------------------

while true do
if gg.isVisible(true) then
MAIN = 1
gg.setVisible(false)
end
if MAIN == 1 then
BATMAN()
end
end
