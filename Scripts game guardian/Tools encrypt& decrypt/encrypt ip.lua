
local userIP = gg.prompt({"Enter IP address (optional - leave empty for auto-detection) example usage 172.16.254.1 "}, {""}, {"text"})[1]

if userIP == nil or userIP == "" then
    local IP_info = gg.makeRequest('https://ipinfo.io/json').content 
    userIP = IP_info:match('"ip":%s-"(.-)"')
    local c1 = IP_info:match('"country":%s-"(.-)"')
    local c2 = IP_info:match('"region":%s-"(.-)"')
    local c3 = IP_info:match('"city":%s-"(.-)"')
    local message = '> IP Address︰' .. userIP .. '\\n> Location︰' .. c1 .. ' / ' .. c2 .. ' / ' .. c3 .. '\\n‎𓂃𓈒𓏸︎︎︎︎'

else
   -- gg.alert("Using custom IP: " .. userIP)
end

local function ipToKey(ip)
    local key = 0
    for part in ip:gmatch("(%d+)") do
        key = key + tonumber(part)
    end
    return key % 256
end

local encryptionKey = ipToKey(userIP)

local function encryptIP(ip, key)
    local encrypted = {}
    for i = 1, #ip do
        local charCode = string.byte(ip, i)
        encrypted[i] = (charCode + key + i) % 256
    end
    return table.concat(encrypted, ",")
end

local function decryptIP(encryptedIP, key)
    local parts = {}
    for match in encryptedIP:gmatch("(%d+),?") do
        table.insert(parts, match)
    end
    
    local decrypted = ""
    for i = 1, #parts do
        local encryptedByte = tonumber(parts[i])
        local decryptedByte = (encryptedByte - key - i + 256) % 256
        decrypted = decrypted .. string.char(decryptedByte)
    end
    return decrypted
end

local encryptedIP = encryptIP(userIP, encryptionKey)

local Path = gg.prompt({[1]="Select script for encrypt"}, {gg.getFile()},{[1]="file"})

if Path == nil then
    os.exit()
end

local function Batman_enc(str)
    local t = {string.byte(str, 1, -1)}
    for i = 1, #t do
        t[i] = string.format("\\x%02x", t[i])
    end
    return table.concat(t)
end

local function Batmam(code, key)
    local mi = {}
    local miwen = {}
    for i = 1, string.len(code) do
        mi[i] = string.byte(string.sub(code, i, i))
    end
    for n = 1, #mi do
        miwen[n] = (mi[n] + key) % 256
    end
    return table.concat(miwen, ",")
end

local function BatmaMm(code, key)
    local mi = {}
    local cd = code
    local test = ""
    local bote = Batmanlit(cd, ",")
    for i = 1, #bote do
        mi[i] = (tonumber(bote[i]) - key) % 256
    end
    for n = 1, #mi do
        test = test .. string.char(mi[n])
    end
    return test
end

local function Batmanlit(str, delimiter)
    if str == nil or str == '' or delimiter == nil then
        return nil
    end
    local result = {}
    for match in (str .. delimiter):gmatch("(.-)" .. delimiter) do
        table.insert(result, match)
    end
    return result
end

local function Batman2Script(Batmam_str, key, encryptedIP)
    return [[
    local IP_info = gg.makeRequest('https://ipinfo.io/json').content 
    local currentIP = IP_info:match('"ip":%s-"(.-)"')
    
    local function decryptIP(encryptedIP, key)
        local parts = {}
        for match in encryptedIP:gmatch("(%d+),?") do
            table.insert(parts, match)
        end
        
        local decrypted = ""
        for i = 1, #parts do
            local encryptedByte = tonumber(parts[i])
            local decryptedByte = (encryptedByte - key - i + 256) % 256
            decrypted = decrypted .. string.char(decryptedByte)
        end
        return decrypted
    end

    local function ipToKey(ip)
        local key = 0
        for part in ip:gmatch("(%d+)") do
            key = key + tonumber(part)
        end
        return key % 256
    end

    local currentKey = ipToKey(currentIP)
    
    if currentKey ~= ]] .. key .. [[ then
        gg.alert("Invalid decryption key!")
        os.exit()
    end

    local expectedIP = decryptIP("]] .. encryptedIP .. [[", currentKey)
    
    if currentIP ~= expectedIP then
        gg.alert("Script not authorized for this device!\\nExpected IP: " .. expectedIP .. "\\nCurrent IP: " .. currentIP)
        os.exit()
    end

    function Batman2(str)
        return (str:gsub("\\x(%x%x)", function(hex)
            return string.char(tonumber(hex, 16))
        end))
    end

    function BatmaMm(code, key)
        local mi = {}
        local cd = code
        local test = ""
        local bote = Batmanlit(cd, ",")
        for i = 1, #bote do
            mi[i] = (tonumber(bote[i]) - key) % 256
        end
        for n = 1, #mi do
            test = test .. string.char(mi[n])
        end
        return test
    end

    function Batmanlit(str, delimiter)
        if str == nil or str == '' or delimiter == nil then
            return nil
        end
        local result = {}
        for match in (str .. delimiter):gmatch("(.-)" .. delimiter) do
            table.insert(result, match)
        end
        return result
    end

    local enc_str = BatmaMm("]] .. Batmam_str .. [[", currentKey)
    local Games = Batman2(enc_str)
    local Games = load(Games)
    pcall(Games)
    
    while(nil)do;local i={}if(i.i)then;i.i=(i.i(i))end;end

    if true then
        if string.match('/' .. tostring(os.time()), '/([^/]+)$') ~= tostring(os.time()) then
            while true do
                if true then
                    gg.alert('Error, time is not acceptable.')
                    os.exit()
                end
                if false then
                end
            end
        end
    end
    
iMdDoL={}
iMdDoL["iNxQwS"]="\105"
iMdDoL["uMyKeQ"]="\111"
iMdDoL["bWfQrH"]="\115"
iMdDoL["uYvHbA"]="\100"
iMdDoL["qLrRxF"]="\101"
iMdDoL["xMaRaX"]="\98"
iMdDoL["eXsMtO"]="\117"
iMdDoL["oSzChM"]="\103"
iMdDoL["cVsZnA"]="\108"
iMdDoL["mFtRdQ"]="\97"
iMdDoL["mUtKzC"]="\102"
iMdDoL["oWpQeV"]="\120"
iMdDoL["aVmKcO"]="\112"
iMdDoL["aGaWyD"]="\99"
iMdDoL["kMbRoL"]="\114"
iMdDoL["qZeQaE"]="\110"
iMdDoL["cWvUpJ"]="\116"
iMdDoL["kKpJfH"]="\76"
iMdDoL["eNsSrB"]="\32"
iMdDoL["aMeHiJ"]="\68"
iMdDoL["xPnTuR"]="\46"
iMdDoL["hWxUzG"]="\66"
iMdDoL["uZcCoB"]="\107"
iMdDoL["pEaSiV"]="\58"
iMdDoL["sAjRaR"]="\42"
iMdDoL["aHjSxU"]="\37"
iMdDoL["gNfPaK"]="\70"
iMdDoL["jIpDdN"]="\40"
iMdDoL["oEaOiV"]="\109"
iMdDoL["bSvPyJ"]="\47"
iMdDoL["rCkAmH"]="\33"
iMdDoL["aFvQcY"]="\69"
iMdDoL["gFsZuI"]="\67"
iMdDoL["wKwFgZ"]="\80"
iMdDoL["rGfChC"]="\82"
iMdDoL["kMsKiS"]="\79"
iMdDoL["yGtTrM"]="\71"
iMdDoL["cKfYaY"]="\65"
iMdDoL["pGuTlT"]="\77"
iMdDoL["uIySrY"]="\84"
iMdDoL["mDqLgG"]="\88"
iMdDoL["tDwSzW"]="\72"
iMdDoL["vAdWmJ"]="\85"
iMdDoL["jSdPdU"]="\57"
iMdDoL["xIbDtH"]="\54"
iMdDoL["dJrKtG"]="\51"
iMdDoL["hEaXlL"]="\91"
iMdDoL["mRpVzG"]="\94"
iMdDoL["dAvKpT"]="\93"
iMdDoL["xYeOqU"]="\43"
iMdDoL["eRgHkN"]="\36"
iMdDoL["wOcZeV"]="\104"
iMdDoL["fIvLgR"]="\240"
iMdDoL["uHlZrS"]="\159"
iMdDoL["uNgUuI"]="\135"
iMdDoL["kZvAqF"]="\190"
iMdDoL["tZaIdM"]="\170"
iMdDoL["xVrEbK"]="\34"
iMdDoL["qQsIjO"]="\41"
iMdDoL["kPoUsU"]="\10"
iMdDoL["hIaSmY"]="\61"
iMdDoL["xVzQfU"]="\74"
iMdDoL["bNlPdD"]="\118"
iMdDoL["lYsIlU"]="\45"
iMdDoL["zUyCnS"]="\78"
iMdDoL["pYaGnH"]="\59"
iMdDoL["kPzIgB"]="\44"
iMdDoL["tYwRtU"]="\121"
iMdDoL["pXpPcX"]="\62"
iMdDoL["zCiInI"]="\124"
iMdDoL["hPnWjP"]="\119"
iMdDoL["dRbQzW"]="\49"
iMdDoL["fIhAeQ"]="\48"
iMdDoL["aIsSmP"]="\50"
iMdDoL["uJsRuC"]="\83"
iMdDoL["tDtDkI"]="\95"
iMdDoL["xZgAzW"]="\86"
iMdDoL["lOvEnW"]="\73"
iMdDoL["eUpAbU"]="\113"
iMdDoL["bPiAvL"]="\81"
nQiUeG=function(Table)local data="" for index,value in pairs(Table)do data=data..iMdDoL[value] end return data end
oCvPdS={}
oCvPdS["eVaShN"]=nQiUeG({"iNxQwS","uMyKeQ"})
oCvPdS["dKqAdY"]=nQiUeG({"uMyKeQ","bWfQrH"})
oCvPdS["jPqVhO"]=nQiUeG({"uYvHbA","qLrRxF","xMaRaX","eXsMtO","oSzChM"})
oCvPdS["oQpEmA"]=nQiUeG({"cVsZnA","uMyKeQ","mFtRdQ","uYvHbA","mUtKzC","iNxQwS","cVsZnA","qLrRxF"})
oCvPdS["xRgFjE"]=nQiUeG({"oWpQeV","aVmKcO","aGaWyD","mFtRdQ","cVsZnA","cVsZnA"})
oCvPdS["eRcHdH"]=nQiUeG({"aVmKcO","kMbRoL","iNxQwS","qZeQaE","cWvUpJ"})
oCvPdS["zDpMmO"]=nQiUeG({"cVsZnA","uMyKeQ","mFtRdQ","uYvHbA"})
oCvPdS["uOcMdU"]=nQiUeG({"uYvHbA","uMyKeQ","mUtKzC","iNxQwS","cVsZnA","qLrRxF"})
oCvPdS["uPoXqU"]=nQiUeG({"kKpJfH","uMyKeQ","oSzChM","oSzChM","qLrRxF","kMbRoL","eNsSrB","aMeHiJ","qLrRxF","cWvUpJ","qLrRxF","aGaWyD","cWvUpJ","qLrRxF","uYvHbA","xPnTuR","eNsSrB","hWxUzG","cVsZnA","uMyKeQ","aGaWyD","uZcCoB","qLrRxF","uYvHbA","xPnTuR"})
oCvPdS["wQuCqI"]=nQiUeG({"kKpJfH","uMyKeQ","oSzChM","oSzChM","qLrRxF","kMbRoL","eNsSrB","xMaRaX","cVsZnA","uMyKeQ","aGaWyD","uZcCoB","qLrRxF","uYvHbA","xPnTuR"})
oCvPdS["eDrQfE"]=nQiUeG({"kKpJfH","uMyKeQ","oSzChM","oSzChM","qLrRxF","kMbRoL","eNsSrB","mFtRdQ","cWvUpJ","cWvUpJ","mFtRdQ","aGaWyD","uZcCoB","pEaSiV","eNsSrB"})
oCvPdS["rUiSmT"]=nQiUeG({"kMbRoL","xMaRaX"})
oCvPdS["dTeBvQ"]=nQiUeG({"sAjRaR","mFtRdQ"})
oCvPdS["hXlPxE"]=nQiUeG({"mUtKzC","eXsMtO","qZeQaE","aGaWyD","cWvUpJ","iNxQwS","uMyKeQ","qZeQaE"})
oCvPdS["gTiSkG"]=nQiUeG({"oSzChM","oSzChM","aHjSxU","xPnTuR","oSzChM","qLrRxF","cWvUpJ","gNfPaK","iNxQwS","cVsZnA","qLrRxF"})
oCvPdS["yAtJgY"]=nQiUeG({"cVsZnA","uMyKeQ","mFtRdQ","uYvHbA","bWfQrH","cWvUpJ","kMbRoL","iNxQwS","qZeQaE","oSzChM"})
oCvPdS["pQkZwN"]=nQiUeG({"aVmKcO","mFtRdQ","iNxQwS","kMbRoL","bWfQrH","aHjSxU","jIpDdN"})
oCvPdS["vItMfW"]=nQiUeG({"aMeHiJ","eXsMtO","oEaOiV","aVmKcO","bSvPyJ","aMeHiJ","qLrRxF","aGaWyD","uMyKeQ","oEaOiV","aVmKcO","iNxQwS","cVsZnA","qLrRxF","eNsSrB","mFtRdQ","cWvUpJ","cWvUpJ","qLrRxF","oEaOiV","aVmKcO","cWvUpJ","eNsSrB","xMaRaX","cVsZnA","uMyKeQ","aGaWyD","uZcCoB","qLrRxF","uYvHbA","rCkAmH"})
oCvPdS["yPqNxD"]=nQiUeG({"aGaWyD","uMyKeQ","oEaOiV","xPnTuR","aGaWyD","cVsZnA","uMyKeQ","qZeQaE","qLrRxF","xPnTuR","mFtRdQ","aVmKcO","aVmKcO"})
oCvPdS["mLsDpH"]=nQiUeG({"aGaWyD","uMyKeQ","oEaOiV","xPnTuR","aVmKcO","mFtRdQ","kMbRoL","mFtRdQ","cVsZnA","cVsZnA","qLrRxF","cVsZnA","xPnTuR","bWfQrH","aVmKcO","mFtRdQ","aGaWyD","qLrRxF"})
oCvPdS["xUxUrR"]=nQiUeG({"aFvQcY","oEaOiV","eXsMtO","cVsZnA","mFtRdQ","cWvUpJ","uMyKeQ","kMbRoL","bSvPyJ","gFsZuI","cVsZnA","uMyKeQ","qZeQaE","qLrRxF","kMbRoL","eNsSrB","aMeHiJ","qLrRxF","cWvUpJ","qLrRxF","aGaWyD","cWvUpJ","qLrRxF","uYvHbA"})
oCvPdS["mLlKpI"]=nQiUeG({"wKwFgZ","rGfChC","kMsKiS","yGtTrM","rGfChC","cKfYaY","pGuTlT","eNsSrB","hWxUzG","aFvQcY","uIySrY","cKfYaY","eNsSrB","mDqLgG","eNsSrB","pGuTlT","cKfYaY","tDwSzW","pGuTlT","vAdWmJ","aMeHiJ","jSdPdU","xIbDtH","dJrKtG"})
oCvPdS["kAuErZ"]=nQiUeG({"hEaXlL","mRpVzG","bSvPyJ","dAvKpT","xYeOqU","eRgHkN"})
oCvPdS["jChHqI"]=nQiUeG({"cVsZnA","uMyKeQ","wOcZeV","wOcZeV","wOcZeV","oSzChM","oSzChM","oSzChM"})
oCvPdS["xOeYyG"]=nQiUeG({"bSvPyJ","hEaXlL","mRpVzG","bSvPyJ","dAvKpT","xYeOqU","eRgHkN"})
oCvPdS["fOkLgJ"]=nQiUeG({"bSvPyJ"})
oCvPdS["wKkAsW"]=nQiUeG({"wKwFgZ","rGfChC","kMsKiS","yGtTrM","rGfChC","cKfYaY","pGuTlT","eNsSrB","hWxUzG","aFvQcY","uIySrY","cKfYaY","eNsSrB","mDqLgG","eNsSrB","pGuTlT","cKfYaY","tDwSzW","pGuTlT","vAdWmJ","aMeHiJ","jSdPdU","xIbDtH","dJrKtG","fIvLgR","uHlZrS","uNgUuI","kZvAqF","fIvLgR","uHlZrS","uNgUuI","tZaIdM"})
oCvPdS["xMyAtW"]=nQiUeG({"xVrEbK"})
oCvPdS["zNeHzE"]=nQiUeG({"mUtKzC","eXsMtO","qZeQaE","aGaWyD","cWvUpJ","iNxQwS","uMyKeQ","qZeQaE","eNsSrB"})
oCvPdS["hMdYpJ"]=nQiUeG({"jIpDdN","qQsIjO"})
oCvPdS["qPiYfA"]=nQiUeG({"kPoUsU"})
oCvPdS["iIqIgQ"]=nQiUeG({"qLrRxF","qZeQaE","uYvHbA"})
oCvPdS["mFhFpM"]=nQiUeG({"oEaOiV"})
oCvPdS["zXgOtK"]=nQiUeG({"oEaOiV","oEaOiV"})
oCvPdS["kZjRlE"]=nQiUeG({"hIaSmY","hEaXlL","xVzQfU","mFtRdQ","bNlPdD","mFtRdQ","dAvKpT"})
oCvPdS["cRgWbL"]=nQiUeG({"cWvUpJ","mFtRdQ","xMaRaX","cVsZnA","qLrRxF"})
oCvPdS["gFxQkR"]=nQiUeG({"mUtKzC","eXsMtO","qZeQaE","aGaWyD","cWvUpJ","iNxQwS","uMyKeQ","qZeQaE","pEaSiV","eNsSrB"})
oCvPdS["vWoIsB"]=nQiUeG({"oSzChM","bWfQrH","eXsMtO","xMaRaX"})
oCvPdS["yVnZhD"]=nQiUeG({"qLrRxF","qZeQaE","uYvHbA","jIpDdN","xPnTuR","lYsIlU","qQsIjO","oSzChM","oSzChM","xPnTuR","bWfQrH","qLrRxF","mFtRdQ","kMbRoL","aGaWyD","wOcZeV","zUyCnS","eXsMtO","oEaOiV","xMaRaX","qLrRxF","kMbRoL"})
oCvPdS["jTdJrV"]=nQiUeG({"cWvUpJ","uMyKeQ","jIpDdN","xPnTuR","lYsIlU","qQsIjO","bWfQrH","bWfQrH"})
oCvPdS["cYbXeD"]=nQiUeG({"bWfQrH","cWvUpJ","kMbRoL","iNxQwS","qZeQaE","oSzChM","bWfQrH","qLrRxF","mFtRdQ","kMbRoL","aGaWyD","wOcZeV","cKfYaY","uYvHbA","uYvHbA","kMbRoL","qLrRxF"})
oCvPdS["yDiNwR"]=nQiUeG({"pYaGnH"})
oCvPdS["iGiLpP"]=nQiUeG({"pYaGnH","mUtKzC","eXsMtO","qZeQaE","aGaWyD","cWvUpJ","iNxQwS","uMyKeQ","qZeQaE","eNsSrB","jIpDdN","bNlPdD","mFtRdQ","cVsZnA","eXsMtO","qLrRxF","kPzIgB","eNsSrB","cWvUpJ","tYwRtU","aVmKcO","qLrRxF","qQsIjO","eNsSrB","qLrRxF","qZeQaE","uYvHbA","kPzIgB","eNsSrB","lYsIlU","lYsIlU","eNsSrB","oSzChM","oSzChM","xPnTuR","qLrRxF","uYvHbA","iNxQwS","cWvUpJ","cKfYaY","cVsZnA","cVsZnA","jIpDdN","bWfQrH","cWvUpJ","kMbRoL","iNxQwS","qZeQaE","oSzChM","eNsSrB","bNlPdD","mFtRdQ","cVsZnA","eXsMtO","qLrRxF","kPzIgB","eNsSrB","iNxQwS","qZeQaE","cWvUpJ","eNsSrB","cWvUpJ","tYwRtU","aVmKcO","qLrRxF","qQsIjO","eNsSrB","lYsIlU","pXpPcX","eNsSrB","aGaWyD","uMyKeQ","eXsMtO","qZeQaE","cWvUpJ","eNsSrB","uMyKeQ","mUtKzC","eNsSrB","aGaWyD","wOcZeV","mFtRdQ","qZeQaE","oSzChM","qLrRxF","uYvHbA","eNsSrB","zCiInI","zCiInI","eNsSrB","bWfQrH","cWvUpJ","kMbRoL","iNxQwS","qZeQaE","oSzChM","eNsSrB","hPnWjP","iNxQwS","cWvUpJ","wOcZeV","eNsSrB","qLrRxF","kMbRoL","kMbRoL","uMyKeQ","kMbRoL"})
oCvPdS["lNwWxB"]=nQiUeG({"xVzQfU","mFtRdQ","bNlPdD","mFtRdQ"})
oCvPdS["ePcNoX"]=nQiUeG({"iNxQwS","qZeQaE","cWvUpJ"})
oCvPdS["hVwPfM"]=nQiUeG({"cWvUpJ","uMyKeQ","bWfQrH","cWvUpJ","kMbRoL","iNxQwS","qZeQaE","oSzChM"})
oCvPdS["kGeVnX"]=nQiUeG({"pEaSiV","xPnTuR"})
oCvPdS["kQzJpI"]=nQiUeG({"mUtKzC","eXsMtO","qZeQaE","aGaWyD","cWvUpJ","iNxQwS","uMyKeQ","qZeQaE","mUtKzC","iNxQwS","qZeQaE","uYvHbA"})
oCvPdS["wNfFwQ"]=nQiUeG({"xPnTuR","jIpDdN","bSvPyJ","xPnTuR","lYsIlU","qQsIjO","pEaSiV"})
oCvPdS["kErXoM"]=nQiUeG({"dRbQzW","fIhAeQ","fIhAeQ","fIhAeQ"})
oCvPdS["uUjSfE"]=nQiUeG({"eNsSrB"})
oCvPdS["kWoQvH"]=nQiUeG({"jIpDdN","hEaXlL","mRpVzG","aHjSxU","hPnWjP","dAvKpT","qQsIjO"})
oCvPdS["cGuUzQ"]=nQiUeG({"aHjSxU","aHjSxU","aHjSxU","fIhAeQ","aIsSmP","mDqLgG"})
oCvPdS["bBaLlT"]=nQiUeG({"xYeOqU"})
oCvPdS["cIoGwW"]=nQiUeG({"uJsRuC","qLrRxF","mFtRdQ","kMbRoL","aGaWyD","wOcZeV","eNsSrB","iNxQwS","aGaWyD","uMyKeQ","qZeQaE"})
oCvPdS["lLqQwP"]=nQiUeG({"cWvUpJ","qLrRxF","oWpQeV","cWvUpJ"})
oCvPdS["hQnNoQ"]=nQiUeG({"wOcZeV","cWvUpJ","cWvUpJ","aVmKcO","bWfQrH","pEaSiV","bSvPyJ","bSvPyJ","iNxQwS","aGaWyD","uMyKeQ","qZeQaE","lYsIlU","iNxQwS","aGaWyD","uMyKeQ","qZeQaE","bWfQrH","xPnTuR","aGaWyD","uMyKeQ","oEaOiV","bSvPyJ","aVmKcO","cWvUpJ","bSvPyJ","iNxQwS","aGaWyD","uMyKeQ","qZeQaE","qLrRxF","bWfQrH","bSvPyJ","xMaRaX","eXsMtO","bWfQrH","aGaWyD","mFtRdQ","bSvPyJ"})
oCvPdS["tZbPjT"]=nQiUeG({"gNfPaK","mFtRdQ","iNxQwS","cVsZnA","qLrRxF","uYvHbA","eNsSrB","cWvUpJ","uMyKeQ","eNsSrB","mUtKzC","qLrRxF","cWvUpJ","aGaWyD","wOcZeV","eNsSrB","cWvUpJ","wOcZeV","qLrRxF","eNsSrB","uYvHbA","mFtRdQ","cWvUpJ","mFtRdQ","xPnTuR"})
oCvPdS["dLnXfL"]=nQiUeG({"wOcZeV","cWvUpJ","cWvUpJ","aVmKcO","bWfQrH","pEaSiV","bSvPyJ","bSvPyJ","aGaWyD","uYvHbA","qZeQaE","aHjSxU","xPnTuR","iNxQwS","aGaWyD","uMyKeQ","qZeQaE","aHjSxU","lYsIlU","iNxQwS","aGaWyD","uMyKeQ","qZeQaE","bWfQrH","aHjSxU","xPnTuR","aGaWyD","uMyKeQ","oEaOiV","bSvPyJ","iNxQwS","aGaWyD","uMyKeQ","qZeQaE","bWfQrH","aIsSmP","bSvPyJ","hEaXlL","aHjSxU","hPnWjP","tDtDkI","bSvPyJ","dAvKpT","xYeOqU","aHjSxU","xPnTuR","aVmKcO","qZeQaE","oSzChM"})
oCvPdS["lIjRwL"]=nQiUeG({"zUyCnS","uMyKeQ","eNsSrB","iNxQwS","aGaWyD","uMyKeQ","qZeQaE","bWfQrH","eNsSrB","mUtKzC","uMyKeQ","eXsMtO","qZeQaE","uYvHbA","xPnTuR"})
oCvPdS["dFhRmS"]=nQiUeG({"iNxQwS","aGaWyD","uMyKeQ","qZeQaE","eNsSrB"})
oCvPdS["oXtBoH"]=nQiUeG({"aFvQcY","oWpQeV","iNxQwS","cWvUpJ"})
oCvPdS["zGnXvH"]=nQiUeG({"uJsRuC","qLrRxF","cVsZnA","qLrRxF","aGaWyD","cWvUpJ","eNsSrB","iNxQwS","aGaWyD","uMyKeQ","qZeQaE","eNsSrB","mUtKzC","uMyKeQ","kMbRoL","eNsSrB","uYvHbA","uMyKeQ","hPnWjP","qZeQaE","cVsZnA","uMyKeQ","mFtRdQ","uYvHbA"})
oCvPdS["xAyHpS"]=nQiUeG({"uIySrY","wOcZeV","mFtRdQ","qZeQaE","uZcCoB","bWfQrH","eNsSrB","mUtKzC","uMyKeQ","kMbRoL","eNsSrB","eXsMtO","bWfQrH","iNxQwS","qZeQaE","oSzChM","eNsSrB","oEaOiV","tYwRtU","eNsSrB","bWfQrH","aGaWyD","kMbRoL","iNxQwS","aVmKcO","cWvUpJ","xPnTuR","xPnTuR","xPnTuR"})
oCvPdS["zRnNcG"]=nQiUeG({"iNxQwS","aGaWyD","uMyKeQ","qZeQaE","tDtDkI"})
oCvPdS["aBsDfG"]=nQiUeG({"xPnTuR","aVmKcO","qZeQaE","oSzChM"})
oCvPdS["rQyFwP"]=nQiUeG({"bSvPyJ","bWfQrH","uYvHbA","aGaWyD","mFtRdQ","kMbRoL","uYvHbA","bSvPyJ","aMeHiJ","uMyKeQ","hPnWjP","qZeQaE","cVsZnA","uMyKeQ","mFtRdQ","uYvHbA","bSvPyJ"})
oCvPdS["rPtPdN"]=nQiUeG({"aMeHiJ","uMyKeQ","hPnWjP","qZeQaE","cVsZnA","uMyKeQ","mFtRdQ","uYvHbA","iNxQwS","qZeQaE","oSzChM","eNsSrB","iNxQwS","aGaWyD","uMyKeQ","qZeQaE","xPnTuR","xPnTuR","xPnTuR"})
oCvPdS["wDhAwR"]=nQiUeG({"gNfPaK","mFtRdQ","iNxQwS","cVsZnA","qLrRxF","uYvHbA","eNsSrB","cWvUpJ","uMyKeQ","eNsSrB","uYvHbA","uMyKeQ","hPnWjP","qZeQaE","cVsZnA","uMyKeQ","mFtRdQ","uYvHbA","eNsSrB","cWvUpJ","wOcZeV","qLrRxF","eNsSrB","iNxQwS","aGaWyD","uMyKeQ","qZeQaE","xPnTuR"})
oCvPdS["kOrUgX"]=nQiUeG({"hPnWjP","xMaRaX"})
oCvPdS["rSoDkA"]=nQiUeG({"iNxQwS","aGaWyD","uMyKeQ","qZeQaE","eNsSrB","bWfQrH","mFtRdQ","bNlPdD","qLrRxF","uYvHbA","eNsSrB","iNxQwS","qZeQaE","eNsSrB"})
oCvPdS["wQkFkY"]=nQiUeG({"gNfPaK","mFtRdQ","iNxQwS","cVsZnA","qLrRxF","uYvHbA","eNsSrB","cWvUpJ","uMyKeQ","eNsSrB","bWfQrH","mFtRdQ","bNlPdD","qLrRxF","eNsSrB","cWvUpJ","wOcZeV","qLrRxF","eNsSrB","iNxQwS","aGaWyD","uMyKeQ","qZeQaE","xPnTuR"})
oCvPdS["xYnVuL"]=nQiUeG({"aGaWyD","uMyKeQ","qZeQaE","aGaWyD","mFtRdQ","cWvUpJ"})
oCvPdS["wZvVjV"]=nQiUeG({"iNxQwS","qZeQaE","bWfQrH","qLrRxF","kMbRoL","cWvUpJ"})
oCvPdS["xDhDiW"]=nQiUeG({"oSzChM","qLrRxF","cWvUpJ","eXsMtO","aVmKcO","bNlPdD","mFtRdQ","cVsZnA","eXsMtO","qLrRxF"})
oCvPdS["nPpMfQ"]=nQiUeG({"oSzChM","qLrRxF","cWvUpJ","iNxQwS","qZeQaE","mUtKzC","uMyKeQ"})
oCvPdS["oNuLeL"]=nQiUeG({"cWvUpJ","kMbRoL","mFtRdQ","aGaWyD","qLrRxF","xMaRaX","mFtRdQ","aGaWyD","uZcCoB"})
oCvPdS["rIgDpX"]=nQiUeG({"oSzChM","oSzChM"})
oCvPdS["iFsCeJ"]=nQiUeG({"xMaRaX","tYwRtU","cWvUpJ","qLrRxF","bWfQrH"})
oCvPdS["yMvUdT"]=nQiUeG({"oSzChM","qLrRxF","cWvUpJ","gNfPaK","iNxQwS","cVsZnA","qLrRxF"})
oCvPdS["qYcRfV"]=nQiUeG({"oSzChM","qLrRxF","cWvUpJ","xZgAzW","mFtRdQ","cVsZnA","eXsMtO","qLrRxF","bWfQrH"})
oCvPdS["xCpInY"]=nQiUeG({"qLrRxF","uYvHbA","iNxQwS","cWvUpJ","cKfYaY","cVsZnA","cVsZnA"})
oCvPdS["gTvUyU"]=nQiUeG({"oSzChM","qLrRxF","cWvUpJ","uIySrY","mFtRdQ","kMbRoL","oSzChM","qLrRxF","cWvUpJ","wKwFgZ","mFtRdQ","aGaWyD","uZcCoB","mFtRdQ","oSzChM","qLrRxF"})
oCvPdS["bLbGpT"]=nQiUeG({"mFtRdQ","cVsZnA","qLrRxF","kMbRoL","cWvUpJ"})
oCvPdS["mOaIuH"]=nQiUeG({"oSzChM","qLrRxF","cWvUpJ","kKpJfH","iNxQwS","qZeQaE","qLrRxF"})
oCvPdS["eHtIjJ"]=nQiUeG({"oSzChM","qLrRxF","cWvUpJ","uIySrY","mFtRdQ","kMbRoL","oSzChM","qLrRxF","cWvUpJ","lOvEnW","qZeQaE","mUtKzC","uMyKeQ"})
oCvPdS["mFgTaB"]=nQiUeG({"cWvUpJ","uMyKeQ","mFtRdQ","bWfQrH","cWvUpJ"})
oCvPdS["mAtSlR"]=nQiUeG({"oEaOiV","mFtRdQ","uZcCoB","qLrRxF","rGfChC","qLrRxF","eUpAbU","eXsMtO","qLrRxF","bWfQrH","cWvUpJ"})
oCvPdS["iFaQzO"]=nQiUeG({"oSzChM","qLrRxF","cWvUpJ","rGfChC","qLrRxF","bWfQrH","eXsMtO","cVsZnA","cWvUpJ","bWfQrH"})
oCvPdS["cTwEhF"]=nQiUeG({"aGaWyD","uMyKeQ","aVmKcO","tYwRtU","uIySrY","qLrRxF","oWpQeV","cWvUpJ"})
oCvPdS["oYpSeB"]=nQiUeG({"aGaWyD","cVsZnA","qLrRxF","mFtRdQ","kMbRoL","rGfChC","qLrRxF","bWfQrH","eXsMtO","cVsZnA","cWvUpJ","bWfQrH"})
oCvPdS["sJjFkE"]=nQiUeG({"aGaWyD","wOcZeV","uMyKeQ","iNxQwS","aGaWyD","qLrRxF"})
oCvPdS["mJrHmX"]=nQiUeG({"uJsRuC","lOvEnW","yGtTrM","zUyCnS","tDtDkI","aFvQcY","bPiAvL","vAdWmJ","cKfYaY","kKpJfH"})
oCvPdS["kXcFcI"]=nQiUeG({"aVmKcO","kMbRoL","uMyKeQ","oEaOiV","aVmKcO","cWvUpJ"})
oCvPdS["nSbWbL"]=nQiUeG({"bWfQrH","qLrRxF","mFtRdQ","kMbRoL","aGaWyD","wOcZeV","zUyCnS","eXsMtO","oEaOiV","xMaRaX","qLrRxF","kMbRoL"})
oCvPdS["nZzZlL"]=nQiUeG({"bWfQrH","qLrRxF","mFtRdQ","kMbRoL","aGaWyD","wOcZeV","cKfYaY","uYvHbA","uYvHbA","kMbRoL","qLrRxF","bWfQrH","bWfQrH"})
oCvPdS["tPcWrX"]=nQiUeG({"aGaWyD","cVsZnA","uMyKeQ","aGaWyD","uZcCoB"})
oCvPdS["nOoDcM"]=nQiUeG({"kMbRoL","qLrRxF","qZeQaE","mFtRdQ","oEaOiV","qLrRxF"})
oCvPdS["rGhJiB"]=nQiUeG({"qLrRxF","oWpQeV","iNxQwS","cWvUpJ"})
oCvPdS["nAvYhY"]=nQiUeG({"uMyKeQ","aVmKcO","qLrRxF","qZeQaE"})
oCvPdS["nTaMdX"]=nQiUeG({"bWfQrH","cWvUpJ","kMbRoL","iNxQwS","qZeQaE","oSzChM"})
oCvPdS["pCiKzN"]=nQiUeG({"uYvHbA","eXsMtO","oEaOiV","aVmKcO"})
oCvPdS["xLpQxQ"]=nQiUeG({"aGaWyD","wOcZeV","mFtRdQ","kMbRoL"})
oCvPdS["tGzObJ"]=nQiUeG({"mUtKzC","iNxQwS","qZeQaE","uYvHbA"})
oCvPdS["yBwFzU"]=nQiUeG({"mUtKzC","uMyKeQ","kMbRoL","oEaOiV","mFtRdQ","cWvUpJ"})
oCvPdS["yIyHnV"]=nQiUeG({"kMbRoL","qLrRxF","aVmKcO"})
oCvPdS["jWaPdT"]=nQiUeG({"xMaRaX","tYwRtU","cWvUpJ","qLrRxF"})
oCvPdS["xIiLrD"]=nQiUeG({"cVsZnA","qLrRxF","qZeQaE"})
oCvPdS["dWiGkT"]=nQiUeG({"oEaOiV","mFtRdQ","cWvUpJ","wOcZeV"})
oCvPdS["oXxKbU"]=nQiUeG({"kMbRoL","mFtRdQ","qZeQaE","uYvHbA","uMyKeQ","oEaOiV"})
qYrXoJ={}
qYrXoJ["lVrVeY"]=_ENV[(oCvPdS["cRgWbL"])][(oCvPdS["xYnVuL"])]
qYrXoJ["tZwHdX"]=_ENV[(oCvPdS["cRgWbL"])][(oCvPdS["wZvVjV"])]
qYrXoJ["iFmGiF"]=_ENV[(oCvPdS["jPqVhO"])][(oCvPdS["xDhDiW"])]
qYrXoJ["jJpMvA"]=_ENV[(oCvPdS["jPqVhO"])][(oCvPdS["nPpMfQ"])]
qYrXoJ["vNxBzK"]=_ENV[(oCvPdS["jPqVhO"])][(oCvPdS["oNuLeL"])]
qYrXoJ["jMyLrX"]=_ENV[(oCvPdS["rIgDpX"])][(oCvPdS["iFsCeJ"])]
qYrXoJ["iZsEqZ"]=_ENV[(oCvPdS["rIgDpX"])][(oCvPdS["yMvUdT"])]
qYrXoJ["wLlBbI"]=_ENV[(oCvPdS["rIgDpX"])][(oCvPdS["qYcRfV"])]
qYrXoJ["cKaBdV"]=_ENV[(oCvPdS["rIgDpX"])][(oCvPdS["xCpInY"])]
qYrXoJ["lZtQmI"]=_ENV[(oCvPdS["rIgDpX"])][(oCvPdS["gTvUyU"])]
qYrXoJ["gDbGwI"]=_ENV[(oCvPdS["rIgDpX"])][(oCvPdS["bLbGpT"])]
qYrXoJ["uIvAlA"]=_ENV[(oCvPdS["rIgDpX"])][(oCvPdS["mOaIuH"])]
qYrXoJ["xVpQmF"]=_ENV[(oCvPdS["rIgDpX"])][(oCvPdS["eHtIjJ"])]
qYrXoJ["bTaHgT"]=_ENV[(oCvPdS["rIgDpX"])][(oCvPdS["mFgTaB"])]
qYrXoJ["qJcOaX"]=_ENV[(oCvPdS["rIgDpX"])][(oCvPdS["mAtSlR"])]
qYrXoJ["rCvYoS"]=_ENV[(oCvPdS["rIgDpX"])][(oCvPdS["iFaQzO"])]
qYrXoJ["oWqGxG"]=_ENV[(oCvPdS["rIgDpX"])][(oCvPdS["cTwEhF"])]
qYrXoJ["mEfWwE"]=_ENV[(oCvPdS["rIgDpX"])][(oCvPdS["oYpSeB"])]
qYrXoJ["pXfMoS"]=_ENV[(oCvPdS["rIgDpX"])][(oCvPdS["sJjFkE"])]
qYrXoJ["vXyUsD"]=_ENV[(oCvPdS["rIgDpX"])][(oCvPdS["mJrHmX"])]
qYrXoJ["rWwEcG"]=_ENV[(oCvPdS["rIgDpX"])][(oCvPdS["kXcFcI"])]
qYrXoJ["xXzPtK"]=_ENV[(oCvPdS["rIgDpX"])][(oCvPdS["nSbWbL"])]
qYrXoJ["sHtWfL"]=_ENV[(oCvPdS["rIgDpX"])][(oCvPdS["nZzZlL"])]
qYrXoJ["zVmZhB"]=_ENV[(oCvPdS["dKqAdY"])][(oCvPdS["tPcWrX"])]
qYrXoJ["jQsKpK"]=_ENV[(oCvPdS["dKqAdY"])][(oCvPdS["nOoDcM"])]
qYrXoJ["xCtIcU"]=_ENV[(oCvPdS["dKqAdY"])][(oCvPdS["rGhJiB"])]
qYrXoJ["aQqTbR"]=_ENV[(oCvPdS["eVaShN"])][(oCvPdS["nAvYhY"])]
qYrXoJ["wDtJpY"]=_ENV[(oCvPdS["nTaMdX"])][(oCvPdS["pCiKzN"])]
qYrXoJ["mFbZwA"]=_ENV[(oCvPdS["nTaMdX"])][(oCvPdS["xLpQxQ"])]
qYrXoJ["lCkKaZ"]=_ENV[(oCvPdS["nTaMdX"])][(oCvPdS["vWoIsB"])]
qYrXoJ["cGzDtB"]=_ENV[(oCvPdS["nTaMdX"])][(oCvPdS["tGzObJ"])]
qYrXoJ["oLpGaE"]=_ENV[(oCvPdS["nTaMdX"])][(oCvPdS["yBwFzU"])]
qYrXoJ["aGoHpI"]=_ENV[(oCvPdS["nTaMdX"])][(oCvPdS["yIyHnV"])]
qYrXoJ["rNvZvJ"]=_ENV[(oCvPdS["nTaMdX"])][(oCvPdS["jWaPdT"])]
qYrXoJ["lQaQkJ"]=_ENV[(oCvPdS["nTaMdX"])][(oCvPdS["xIiLrD"])]
qYrXoJ["zJkXuR"]=_ENV[(oCvPdS["dWiGkT"])][(oCvPdS["oXxKbU"])]

local blocked_funcs = {
(oCvPdS["eVaShN"]), (oCvPdS["dKqAdY"]), (oCvPdS["jPqVhO"]), (oCvPdS["oQpEmA"]), (oCvPdS["xRgFjE"]), (oCvPdS["eRcHdH"]), (oCvPdS["zDpMmO"]), (oCvPdS["uOcMdU"])
}
local _real = {}
for _, fn in ipairs(blocked_funcs) do
if _G[fn] then
_real[fn] = _G[fn]
rawset(_G, fn, nil)
end
end
local function blockIO()
local fakeIO = {
open = function(...) return nil end,
write = function(...) return nil end,
read = function(...) return nil end,
close = function(...) return nil end,
flush = function(...) return nil end,
}
return fakeIO
end
_G.io = blockIO()
local original_pairs = pairs
pairs = function(t)
if t == _ENV or t == _G then
qYrXoJ["bTaHgT"]((oCvPdS["uPoXqU"]))
while true do end
end
return original_pairs(t)
end
qYrXoJ["rWwEcG"] = function(...)
gg.alert((oCvPdS["wQuCqI"]))
qYrXoJ["xCtIcU"]()
end
setmetatable(_ENV, {
__index = function(_, k)
if k == (oCvPdS["eVaShN"]) or k == (oCvPdS["oQpEmA"]) or k == (oCvPdS["xRgFjE"]) then
qYrXoJ["bTaHgT"]((oCvPdS["eDrQfE"])..k)
qYrXoJ["xCtIcU"]()
end
end
})
do
local f = qYrXoJ["iZsEqZ"]()
local s = qYrXoJ["aQqTbR"](f, (oCvPdS["rUiSmT"]))
if s then
local code = s:read((oCvPdS["dTeBvQ"]))
s:close()
if code:match((oCvPdS["hXlPxE"])) or code:match((oCvPdS["gTiSkG"])) or code:match((oCvPdS["yAtJgY"])) or code:match((oCvPdS["pQkZwN"])) then
qYrXoJ["bTaHgT"]((oCvPdS["vItMfW"]))
_ENV = nil
while true do end
end
end
end

while(nil)do;local i={}if(i.i)then;i.i=(i.i(i))end;end

    ]]
end

local function EncryptAndWriteFile(inputPath, outputPath, key, encryptedIP)
    local file = io.open(inputPath, "r")
    assert(file)
    local Games = file:read("*a")
    file:close()

    local batmandm = Batman_enc(Games)
    local Batmam_str = Batmam(batmandm, key)

    local fullScript = Batman2Script(Batmam_str, key, encryptedIP)

    local DATA = string.dump(load(fullScript), true)
    io.open(outputPath, "w"):write(DATA):close()
    
    local sj = os.date("\n%c")
    print("Encrypt success!\n" .. outputPath .. sj)
end

local outputPath = "script_encrypted.lua"
EncryptAndWriteFile(Path[1], outputPath, encryptionKey, encryptedIP)
gg.alert("script save in current folder, name script: ".. outputPath)