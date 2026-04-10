local function antilog()

vpn=gg.makeRequest("https://time.tianqi.com/")["headers"]["Date"]
Hour,Montie,Second=vpn[1]:match("(%d+):(%d+):(%d+)")
if Hour=="00" then
Hour=24
end
time1=Hour*3600+Montie*60+Second
m=_ENV
local g=m["string"]["rep"]('\n',20000) 
local d=m["string"]["rep"](g,1000)
local c=m["string"]["rep"]("\n",104857)
while #d~="20000000" or #g~="20000" or #c~="104857" do
m["os"]["exit"]()
end
local O0={}
for d=1,1024 do
O0[d]=c
end 
m["__"]=function(...)
m["pcall"](...,O0)
m["xpcall"](...,m,O0)
end
local hook=function()
m["gg"]["getResults"](1) 
m["gg"]["editAll"](d,4)
m["gg"]["searchNumber"](g,4)
end
m["debug"]["sethook"](hook,"r")
for b, d in m["pairs"]({
m["gg"]["toast"],
m["gg"]["alert"],
m["gg"]["bytes"],
m["gg"]["editAll"],
m["gg"]["copyText"],
m["gg"]["searchAddress"],
m["gg"]["searchNumber"],
m["gg"]["loadResults"],
m["gg"]["getListItems"],
m["gg"]["addListItems"],
}) do
m["__"](d)
end
m["debug"]["sethook"]()

vpn=gg.makeRequest("https://time.tianqi.com/")["headers"]["Date"]
Hour,Montie,Second=vpn[1]:match("(%d+):(%d+):(%d+)")
if Hour=="00" then
Hour=24
end
time2=Hour*3600+Montie*60+Second
while time2-time1>7 do
--print(time2-time1)
--m["os"]["exit"]()
end

end


antilog()

--code by asura

