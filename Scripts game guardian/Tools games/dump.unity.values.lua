
 --------------------------------------------------------------------------------
--open game to run this script
--script created by Batman Games
--support  to search values unity games
-- this script is beta
--enjoy
--------------------------------------------------------------------------------
get = gg.getRangesList
un = get("libunity.so")[1].start
--------------------------------------------------------------------------------

function batHex(val)
return val>=0 and string.format("%X", tonumber(val)) or string.format("%X", (val~ 0xffffffffffffffff <<((math.floor(math.log(math.abs(val))/math.log(10)) + 1) *4)))
end
--------------------------------------------------------------------------------

MAIN = -1
function BATMAN()
gg.clearResults()
menu = gg.choice({

"Wallhack ",
"camera 360",
"dark mode",
" black sky",
" fast music",
" fly hack",
"EXIT"
},nil, "Please select function to dumper")

if menu == 0 then else
if menu == 1 then I() end
if menu == 2 then II() end
if menu == 3 then III() end
if menu == 4 then IV() end
if menu == 5 then V() end
if menu == 6 then VI() end
if menu == 7  then out() end
end
MAIN = -1
end
--------------------------------------------------------------------------------
function I()
    gg.setRanges(gg.REGION_CODE_APP)
    gg.searchNumber("-0.50347691774;9.99999997e-7:9", gg.TYPE_FLOAT)
    gg.refineNumber("9.99999997e-7", gg.TYPE_FLOAT)
    ro = gg.getResults(10)
    if gg.getResultsCount(1) == 0 then 
        gg.setRanges(gg.REGION_CODE_APP)
        gg.searchNumber("-0.50347091774~-0.50344071796;1e-6::5", gg.TYPE_FLOAT)
        gg.refineNumber("9.99999997e-7", gg.TYPE_FLOAT)
        ro = gg.getResults(10)
        if gg.getResultsCount(1) == 0 then
            gg.alert("VALUE NOT FOUND -_-")
            os.exit()
        end
    end
    print('< ---------VALUE WALLHACK LIBUNITY--------  >\n\n')
    for i, result in ipairs(ro) do
        local S = {}
        S[1] = result.address
        gg.setVisible(true)
        print('Offset '..i..': 0x'..batHex(S[1]-un)..' -- Hex reverse replace 000080BF or -1 float')
    end
    out() 
end
--------------------------------------------------------------------------------
function II()
    gg.setRanges(gg.REGION_CODE_APP)
    gg.searchNumber("-7.16042653e24;360;3.14159274101::9", gg.TYPE_FLOAT)
    gg.refineNumber("360", gg.TYPE_FLOAT)
    ro=gg.getResults(10)
    if gg.getResultsCount(1) == 0 then
        gg.searchNumber("-7.15917215e24;360;3.14159274101::9", gg.TYPE_FLOAT)
        gg.refineNumber("360", gg.TYPE_FLOAT)
        ro=gg.getResults(10)
        if gg.getResultsCount(1) == 0 then
            gg.searchNumber("360;3.14159274101::5", gg.TYPE_FLOAT)
            gg.refineNumber("360", gg.TYPE_FLOAT)
            ro=gg.getResults(10)
            if gg.getResultsCount(1) == 0 then
                gg.searchNumber("-7.16919215e24~-7.15917215e24;360;3.14159274101::9", gg.TYPE_FLOAT)
                gg.refineNumber("360", gg.TYPE_FLOAT)
                ro=gg.getResults(10)
                if gg.getResultsCount(1) == 0 then
                    gg.alert("VALUE NOT FOUND -_-")
                    os.exit()
                end
            end
        end
    end
    print('< ---------VALUE CAMERA 360 LIBUNITY--------  >\n\n')
    for i, result in ipairs(ro) do
        local S = {}
        S[1] = result.address
        gg.setVisible(true)
        print('Offset '..i..': 0x'..batHex(S[1]-un)..' -- Hex  reverse replace 00808943 or 275 float')
    end
    out() 
end
--------------------------------------------------------------------------------

function III()
  gg.setRanges(gg.REGION_CODE_APP)
gg.searchNumber("-7.16145955e24;0.00100000005::5", gg.TYPE_FLOAT)
gg.refineNumber("0.00100000005", gg.TYPE_FLOAT)
ro=gg.getResults(10)
if gg.getResultsCount(1) == 0 then
 gg.alert("VALUE NOT FOUND -_-")
os.exit()
end
print('< ---------VALUE DARK MODE LIBUNITY--------  >\n\n')
    for i, result in ipairs(ro) do
        local S = {}
        S[1] = result.address
        gg.setVisible(true)
        print('Offset '..i..': 0x'..batHex(S[1]-un)..' -- Hex  reverse replace 00c07944 & 00c079c4 or 999 & -999 float')
    end
    out() 
end
--------------------------------------------------------------------------------

function IV()
  gg.setRanges(gg.REGION_CODE_APP)
gg.searchNumber("0.99000000954;0.57735025883;0.00999999978;9.99999997e-7:13", gg.TYPE_FLOAT)
gg.refineNumber("9.99999997e-7", gg.TYPE_FLOAT)
ro=gg.getResults(10)
if gg.getResultsCount(1) == 0 then
 gg.alert("VALUE NOT FOUND -_-")
os.exit()
end

print('< ---------VALUE BLACK SKY  LIBUNITY--------  >\n\n')
    for i, result in ipairs(ro) do
        local S = {}
        S[1] = result.address
        gg.setVisible(true)
        print('Offset '..i..': 0x'..batHex(S[1]-un)..' -- Hex reverse replace 000080BF or -1 float')
    end
    out() 
end
--------------------------------------------------------------------------------
function V()
  gg.setRanges(gg.REGION_CODE_APP)
gg.searchNumber("-2188690589493493752;-2220275583137349632:25", gg.TYPE_QWORD)
gg.refineNumber("-2220275583137349632", gg.TYPE_QWORD)
ro=gg.getResults(10)
if gg.getResultsCount(1) == 0 then
 gg.alert("VALUE NOT FOUND -_-")
os.exit()
end
print('< ---------VALUE FAST MUSIC LIBUNITY--------  >\n\n')
    for i, result in ipairs(ro) do
        local S = {}
        S[1] = result.address
        gg.setVisible(true)
        print('Offset '..i..': 0x'..batHex(S[1]-un)..' -- Hex reverse replace 0200A0E31EFF2FE1 or -2220275583137349630 qword')
    end
    out() 
end
--------------------------------------------------------------------------------
function VI()
  gg.setRanges(gg.REGION_CODE_APP)
gg.searchNumber("-0.90289440155~-0.10289440155;0.00001::5", gg.TYPE_FLOAT)
gg.refineNumber("0.00001", gg.TYPE_FLOAT)
ro=gg.getResults(10)
if gg.getResultsCount(1) == 0 then
 gg.alert("VALUE NOT FOUND -_-")
os.exit()
end
print('< ---------VALUE FLY HACK LIBUNITY--------  >\n\n')
    for i, result in ipairs(ro) do
        local S = {}
        S[1] = result.address
        gg.setVisible(true)
        print('Offset '..i..': 0x'..batHex(S[1]-un)..' -- Hex reverse replace 00007041 or 15 float')
    end
    out() 
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
