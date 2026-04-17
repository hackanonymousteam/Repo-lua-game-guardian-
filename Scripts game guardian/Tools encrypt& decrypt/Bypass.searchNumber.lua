while ""=="RlRlRR" do RlRlRR=(function()end)("lRlRlR") end 
Len = _ENV["string"]["len"]
suB = _ENV["string"]["sub"]
gmatchs = _ENV["string"]["gmatch"]
concats = _ENV["table"]["concat"]
TabInsert = _ENV["table"]["insert"]
pari = _ENV["pairs"]
char = string.char
ToNumber = tonumber
setRanges = _ENV["gg"]["setRanges"]
getResults = _ENV["gg"]["getResults"]
searchNumber = _ENV["gg"]["searchNumber"]
editAll = _ENV["gg"]["editAll"]
local getResultsCount, getValues, loadResults, clearResults, setValues = _ENV["gg"]["getResultsCount"], _ENV["gg"]["getValues"], _ENV["gg"]["loadResults"], _ENV["gg"]["clearResults"], _ENV["gg"]["setValues"]
local AddRess, Flag, VALUE, plug = "address", "flags", "value", getResultsCount
local Ran_dom = _ENV["math"]["random"]
local Rep = _ENV["string"]["rep"]
local Clock = _ENV["os"]["clock"]
local zero = Rep("0", "25")
local Ten_Thousand = ToNumber("10000")
local Zero = ToNumber("0")
local Nine = ToNumber("9")
local Ei_Thousand = ToNumber("8000")
local Two = ToNumber("2")
local function numBrush()
    local re = {}
    for i = 1, Ten_Thousand do
        re[#re + 1] = Ran_dom(Zero, Nine)
    end
    re = concats(re)
    return zero .. Rep(re, "10")
end
local Brush__ = numBrush()
local Brush = function(num)
    num = string.gsub(num, "%.0", char())
    return num .. "." .. Brush__
end
local getValue = function(Tab)
    local clock = Clock()
    for i = #Tab + 1, #Tab + Ei_Thousand do
        Tab[i] = {
            [AddRess] = Tab[1][AddRess],
            [Flag] = Tab[1][Flag]
        }
    end
    local jg = getValues(Tab)
    while Clock() - clock > Two do
    
        
        os.exit()
        
        CZNB()
    end
    return jg
end
local SetValue = function(Tab)
    local clock = Clock()
    for i = #Tab + 1, #Tab + Ei_Thousand do
        Tab[i] = {
            [AddRess] = Tab[1][AddRess],
            [Flag] = Tab[1][Flag],
            [VALUE] = Tab[1][VALUE]
        }
    end
    setValues(Tab)
    while Clock() - clock > Two do

        
        os.exit()
        
        CZNB()
    end
end
local loadResult = function(Tab, Star)
    local clock = Clock()
    for i = 1, Ei_Thousand do
        Tab[#Tab + 1] = {
            [AddRess] = Tab[1][AddRess],
            [Flag] = Tab[1][Flag]
        }
    end
    local jg = loadResults(Tab)
    while Clock() - clock > Two do

        
        os.exit()
        
        CZNB()
    end
    return jg
end

local convert_num = function(Ty)
    local tab = {
        ["D"] = ToNumber("4"),
        ["d"] = ToNumber("4"),
        ["F"] = ToNumber("16"),
        ["f"] = ToNumber("16"),
        ["E"] = ToNumber("64"),
        ["e"] = ToNumber("64"),
        ["B"] = 1,
        ["b"] = 1,
        ["A"] = ToNumber("127"),
        ["a"] = ToNumber("127"),
        ["Q"] = ToNumber("32"),
        ["q"] = ToNumber("32"),
        ["X"] = ToNumber("8"),
        ["x"] = ToNumber("8"),
        ["W"] = Two,
        ["w"] = Two
    }
    return tab[Ty]
end
local function split(str, reps)
    local resultStrList = {}
    string.gsub(str, "[^" .. reps .. "]+", function(w)
        if string.find(suB(w, -1, -1), "[ABDEFQWXabdefqwx]") then
            TabInsert(resultStrList, {suB(w, Zero, -Two), convert_num(suB(w, -1, -1))})
        else
            TabInsert(resultStrList, {w})
        end
    end)
    return resultStrList
end
_ENV["gg"]["searchNumber"] = function(a, b, c, d, e, f, g)
    local Convert_Type = function(value, ty)
        local conf = {
            [ToNumber("4")] = "i4",
            [ToNumber("16")] = "f",
            [ToNumber("64")] = "d",
            [1] = "i1",
            [Two] = "i2",
            [ToNumber("32")] = "i8"
        }
        local fmt = conf[ty]
        local data = string.pack(fmt, value)
        data = {string.byte(data, 1, #data)}
        local search = {}
        for i, k in pari(data) do
            search[i] = char(k)
        end
        return data, concats(search), #data
    end
    local check = function(num)
        if num < ToNumber("0") then
            num = num + ToNumber("256")
        end
        return char(num)
    end
    d = d or _ENV["gg"]["SIGN_EQUAL"]
    e = e or Zero
    f = f or -1
    g = g or Zero
    local rp = Rep(Zero, ToNumber("1024") ^ Two)
    b = Brush(b)
    d = d .. "." .. rp
    e = e .. "." .. rp
    f = f .. "." .. rp
    g = g .. "." .. rp
    if not ToNumber(a) then
        return searchNumber(a, b, c, d, e, f, g)
    end
    if getResultsCount() == Zero and ToNumber(a) ~= Zero and ToNumber(b) ~= 1 and ToNumber(b) ~= Two and ToNumber(b) ~= ToNumber("8") then
        local x1, x2, x3 = Convert_Type(ToNumber(a), ToNumber(b))
        gg.setVisible(false)
        gg.internal1(x2)
        gg.setVisible(false)
        local rr = gg.getResults(getResultsCount())
        local n1, n2 = ToNumber("4"), Zero
        local Star
        local Raep = {}
        for i = 1, #rr, x3 do
            if rr[i][AddRess] % n1 == n2 then
                Raep[#Raep + 1] = {
                    [AddRess] = rr[i][AddRess],
                    [Flag] = b
                }
            else
                rr[i] = nil
            end
            for ii = 1, x3 - 1 do
                rr[i + ii] = nil
            end
        end
        if Raep[1] then
            gg.setVisible(false)
            loadResult(Raep)
            gg.setVisible(false)
        end
    else
        searchNumber(a, b, c, d, e, f, g)
    end
end
_ENV["gg"]["editAll"] = function(a, b)
    local m2, m3, m4 = 1, Zero, Two
    if type(plug) == "function" then
        plug = plug()
    end
    gg.setVisible(false)
    local sear = gg.getResults(plug)
    if sear[1] == nil then
        return gg.sleep(0)
    end
    if string.find(a, ";") then
        a = split(a, ";")
        local Try, _Nt = m3, m3
        while _Nt < #sear do
            Try, _Nt = Try + m2, _Nt + m2
            if Try > #a then
                Try = m2
            end
            sear[_Nt][VALUE] = a[Try][m2]
            if a[Try][m4] then
                sear[_Nt][Flag] = Brush(a[Try][m4])
            else
                sear[_Nt][Flag] = Brush(b)
            end
        end
    else
        for i, k in pairs(sear) do
            sear[i][VALUE] = a
            sear[i][Flag] = Brush(b)
        end
    end
    return SetValue(sear)
end


--how to use
gg.searchNumber("20",16)
gg.getResults(100)
gg.editAll("30",16)