Path = gg.prompt({[1]="Select script for encrypt"}, {gg.getFile()},{[1]="file"})

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

local function Batman2Script(Batmam_str, key)
  return [[
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

    local enc_str = BatmaMm("]] .. Batmam_str .. [[", ]] .. key .. [[)
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
	
local GetTableSpam = {}
local b, toStr, GetSpamName = 0, tostring;

local tmp = (function()
  local tempString = ''
  while (b < (10^2)) do
    tempString = tempString .. toStr(b * b);
    b = b + 1
  end
  GetSpamName = (function() local HashName = '' for i = 1, 10 do HashName = "ðŸŒ¨ï¸" .. HashName .. "â˜ƒï¸" .. HashName .. "â„ï¸" end return HashName:rep(100) end)()
  return tempString;
end)();

local spam = "Boar"
local c, b = "'" .. math.random(1, 255) .. "'",  math.random(100, 300)
if tostring("@") == "" then
	return
end

for k, v in next, _ENV do
	if tostring(v):match("function: @.-:") then
		return
	end

local func = os.exit
if tostring(func):match("-") or tostring(func):match("//") or tostring(func):match("@") or tostring(func):match("%d+") then
	return
end
end

local spam_2 = "is top"

for i = 1, #tmp do
    GetTableSpam[i] = {["address"] = GetSpamName, ["flags"] = GetSpamName, ["value"] = GetSpamName, ["freeze"] = GetSpamName, ["name"] = GetSpamName, GetTableSpam[i - 1]}
    gg.refineNumber(GetTableSpam)
	gg.refineAddress(GetTableSpam)
end

local i;
for i in ipairs({tostring(gg),tostring(os),tostring(io),tostring(debug),tostring(math),tostring(table)}) do
if _ENV["string"]["match"](({tostring(gg),tostring(os),tostring(io),tostring(debug),tostring(math),tostring(table)})[i], "@") then
os.exit()
os.exit()
os["]==])..string.char(math.random(128,255),math.random(128,255),math.random(128,255),math.random(128,255))..([==["]()
gg.processKill()
return
end
end
if pcall(_ENV["os"]["exit"]) or _ENV["string"]["rep"]("'",'2')~="''" or not _ENV["debug"]["getinfo"](_ENV["tostring"])["isvararg"] or _ENV["debug"]["getinfo"](gg["searchNumber"])["what"]=="Lua" then 
repeat
  x= 0
      repeat
          x= x+1
           gg.setVisible(false)
           gg.sleep(0)
           gg.setVisible(true)
           gg.sleep(2000)
           gg.setVisible(false)
           gg.sleep(0)
           gg.setVisible(true)
       until x== 20000
        gg["sleep"](0)
      os.exit()
    until false
  end

_ENV["B1"]= _ENV["debug"]["getinfo"](gg.refineNumber).short_src
if _ENV["B1"]~=_ENV["debug"]["getinfo"](1).short_src and _ENV["B1"]~=gg.getFile() then
repeat
  x= 0
      repeat
          x= x+1
           gg.setVisible(false)
           gg.sleep(0)
           gg.setVisible(true)
           gg.sleep(2000)
           gg.setVisible(false)
           gg.sleep(0)
           gg.setVisible(true)
       until x== 20000
        gg["sleep"](0)
      os.exit()
    until false
  end
local i;
for i in ipairs({tostring(gg),tostring(os),tostring(io),tostring(debug),tostring(math),tostring(table)}) do
if _ENV["string"]["match"](({tostring(gg),tostring(os),tostring(io),tostring(debug),tostring(math),tostring(table)})[i], "@") then
repeat
  x= 0
      repeat
          x= x+1
           gg.setVisible(false)
           gg.sleep(0)
           gg.setVisible(true)
           gg.sleep(2000)
           gg.setVisible(false)
           gg.sleep(0)
           gg.setVisible(true)
       until x== 20000
        gg["sleep"](0)
      os.exit()
    until false
  end
end
if debug.getinfo(1).istailcall then
repeat
  x= 0
      repeat
          x= x+1
           gg.setVisible(false)
           gg.sleep(0)
           gg.setVisible(true)
           gg.sleep(2000)
           gg.setVisible(false)
           gg.sleep(0)
           gg.setVisible(true)
       until x== 20000
        gg["sleep"](0)
      os.exit()
    until false
  end

x=debug.getinfo(gg.searchNumber)
if x.what~=('Java') then 
os.exit() 
while true do 
end 
end 
local i = {}
local g = {}
local ppi, ppb
g["last"] = _ENV["gg"]["getFile"]()
g["dados_saida"] = _ENV["loadfile"](g["last"])
g["cpp"] = g["dados_saida"]
if g["cpp"] ~= nil then 
g["dados_saida"] = nil
local ppb = g["last"]:match("[^/]+$")
local ppi = "lohhhggg"
local pu = _ENV["gg"]["getResults"](5000)
_ENV["os"]["rename"](''..g["last"]..'', ''..g["last"]:gsub('/[^/]+$', '')..'/'..ppi..'') 
local prt = _ENV["loadfile"](''..g["last"]:gsub('/[^/]+$', '')..'/'..ppi..'')
if prt ~= nil then
_ENV["os"]["rename"](''..g["last"]:gsub('/[^/]+$', '')..'/'..ppi..'', ''..g["last"]:gsub('/[^/]+$', '')..'/'..ppb..'')
repeat
  x= 0
      repeat
          x= x+1
           gg.setVisible(false)
           gg.sleep(0)
           gg.setVisible(true)
           gg.sleep(2000)
           gg.setVisible(false)
           gg.sleep(0)
           gg.setVisible(true)
       until x== 20000
        gg["sleep"](0)
      os.exit()
    until false
  end
end
for i in _ENV["ipairs"]({
_ENV["tostring"](_ENV["gg"]),
_ENV["tostring"](_ENV["os"]),
_ENV["tostring"](_ENV["io"]),
_ENV["tostring"](_ENV["debug"]),
_ENV["tostring"](_ENV["math"]),
_ENV["tostring"](_ENV["table"])}) do 
if _ENV["string"]["match"](({
_ENV["tostring"](_ENV["gg"]),
_ENV["tostring"](_ENV["os"]),
_ENV["tostring"](_ENV["io"]),
_ENV["tostring"](_ENV["debug"]),
_ENV["tostring"](_ENV["math"]),
_ENV["tostring"](_ENV["table"])})[i], ("@")) then 
repeat
  x= 0
      repeat
          x= x+1
           gg.setVisible(false)
           gg.sleep(0)
           gg.setVisible(true)
           gg.sleep(2000)
           gg.setVisible(false)
           gg.sleep(0)
           gg.setVisible(true)
       until x== 20000
        gg["sleep"](0)
      os.exit()
    until false
  end
end
if _ENV["string"]["rep"]("a", 2) ~= "aa" then 
repeat
  x= 0
      repeat
          x= x+1
           gg.setVisible(false)
           gg.sleep(0)
           gg.setVisible(true)
           gg.sleep(2000)
           gg.setVisible(false)
           gg.sleep(0)
           gg.setVisible(true)
       until x== 20000
        gg["sleep"](0)
      os.exit()
    until false
  end
if ("a"):rep(2) ~= "aa" then 
repeat
  x= 0
      repeat
          x= x+1
           gg.setVisible(false)
           gg.sleep(0)
           gg.setVisible(true)
           gg.sleep(2000)
           gg.setVisible(false)
           gg.sleep(0)
           gg.setVisible(true)
       until x== 20000
        gg["sleep"](0)
      os.exit()
    until false
  end
if not _ENV["tostring"](_ENV["gg"]):find(("@")) then 
if not _ENV["tostring"](_ENV["debug"]):find(("@")) then 
if not _ENV["tostring"](_ENV["io"]):find(("@")) then 
if _ENV["tostring"](_ENV["string"]):find(("@")) then 
repeat
  x= 0
      repeat
          x= x+1
           gg.setVisible(false)
           gg.sleep(0)
           gg.setVisible(true)
           gg.sleep(2000)
           gg.setVisible(false)
           gg.sleep(0)
           gg.setVisible(true)
        until x== 20000
        gg["sleep"](0)
        os.exit()
      until false
     end
   end
 end 
end
if _G["debug"]["getlocal"](2, 4) == nil then
repeat
  x= 0
      repeat
          x= x+1
           gg.setVisible(false)
           gg.sleep(0)
           gg.setVisible(true)
           gg.sleep(2000)
           gg.setVisible(false)
           gg.sleep(0)
           gg.setVisible(true)
       until x== 20000
        gg["sleep"](0)
      os.exit()
    until false
  end
if not _G["utf8"] then
repeat
  x= 0
      repeat
          x= x+1
           gg.setVisible(false)
           gg.sleep(0)
           gg.setVisible(true)
           gg.sleep(2000)
           gg.setVisible(false)
           gg.sleep(0)
           gg.setVisible(true)
       until x== 20000
        gg["sleep"](0)
      os.exit()
    until false
  end

if _ENV["debug"]["traceback"] == nil then
return 
end

if _ENV["string"]["rep"]("a", 2) ~= "aa" then
while true do
_ENV["gg"]["alert"]("BATMAN")
return
Detectid()
end
end

if ("a"):rep(2) ~= "aa" then
while true do
_ENV["gg"]["alert"]("BATMAN")
return
Detectid()
end
end

local log = _ENV["string"]["char"](("255"),("255"),("255"),("255"),("255"),("255")):rep("999"):rep("999"):rep(4)
for i = 1,("3340") do
_ENV["gg"]["refineNumber"]("0",log,log,log,log,log,log,log)
end

local GG={"art","ART","Art","dec","Dec","DEC","hook","Hook","HooK","HOOK","log","Log","LOG",}
local _gg={gg.CACHE_DIR,gg.EXT_FILES_DIR,gg.EXT_CACHE_DIR,gg.FILES_DIR,gg.PACKAGE}
for i,v in pairs(GG) do
if string.find(tostring(_gg),v) or(not string.find(tostring(_gg),"com"))then
Error(true)
end
end

while gg.PACKAGE == "catch.Art.Tool.seatch" do
while true do
os.exit(print("꧁ঔৣ☬✞ BATMAN GAMES ✞☬ঔৣ꧂?"))
end
end
while gg.VERSION == "96.0" do
while true do
os.exit(print("꧁ঔৣ☬✞ BATMAN GAMES ✞☬ঔৣ꧂?"))
end
end
while gg.BUILD == "15993" do
while true do
os.exit(print("꧁ঔৣ☬✞ BATMAN GAMES ✞☬ঔৣ꧂?"))
end
end
while string.find(gg.EXT_CACHE_DIR,"com.Art.Tool") do
end
while string.find(gg.EXT_CACHE_DIR,"catch_.me_.if_.you_.can_93") do
end

_ENV["debug"]["getinfo"]=function(a)
return _ENV["debug"]["getinfo"]("BATMANN")
end

for i in string.gmatch(tostring(debug.traceback()), '(.-)\n') do
if string.match(i, '.(/.-):') and string.match(i, '.(/.-):') ~= gg.getFile() then

os.exit()

print("ï¸")
return
end
end

mmk = ''
for i = 1, math.random(5, 10) do
    fname = string.char(math.random(97, 120))..string.char(math.random(97, 120))..string.char(math.random(97, 120))..string.char(math.random(97, 120))
    mmk = mmk.."while(nil)do;goto PROX"..fname.." goto PXXXX"..fname.." goto PXXXX"..fname.." goto PXXXX"..fname.." goto PXXXX"..fname.." goto PXXXX"..fname.." goto PXXXX"..fname.." goto PXXXX"..fname..";::PXXXX"..fname.."::;end\nlocal function FakeFunc"..fname.."()\nif fucklog or debug.getinfo(2) ~= nil then\n   -- Ação para tentativa de log ou disassembly externo\n   print('Tentativa de log ou disassembly detectada!')\n   -- Encerrar a execução ou tomar outra ação adequada\n   return\nend\ngoto PXXXX"..fname.."\n::PXXXX"..fname.."::\nfucklog = nil;end\n" 
end

for i = 1,5 do
    if(nil) then 
        if true then 
            return 
        end 
        if true then 
            return 
        end 
        if true then 
            return 
        end 
        if true then 
            return 
        end 
        if true then 
            return 
        end 
        if true then 
            return 
        end 
        if true then 
            return 
        end 
        if true then 
            return 
        end 
    end
    loadfile = loadfile
    load = load
    loadfile(gg.getFile()) 
    load(string.dump(load("os.exit()"),false,false)) 
    io.open(gg.getFile() .. "c" .. tostring(string.dump(loadfile(gg.getFile()),false,false)),"w") 
end

for i = 1, 5000 do
    table.insert({}, {})
end
for i = 1, 5000 do
    table.insert({}, {})
end

gg.setVisible(false)
for i = 1, 6 do
    gg.addListItems({})
end

gg.setVisible(false)
gg.removeListItems({})

if os.time() > os.time() then
    return 
end
if os.time() < os.time() then
end
if os.difftime(os.time(), (os.time())) > 2 then
    return 
end

gg.setVisible(false)
if os.clock() > os.clock() then
    return 
end
if os.clock() < os.clock() then
end
if os.difftime(os.clock(), (os.clock())) > 2 then
    return 
end

gg.setVisible(false)
for i = 3, 100 do
    load(gg.getFile())
end

while(nil)do
    local i={}
    if(i.i)then
        i.i=(i.i(i))
    end
end

while(nil)do
    for i=i,i do
        local i={}
        if(i.i)then
            i.i=(i.i(i))
        end
        for ii=i.i,i.i,i.i do
            local ii={}
            if(ii.i)then
                ii.i=ii.i()
            end
            for iii=i,ii.i,i do
                local iii={}
                if(iii.i)then
                    iii.i=iii.i(i)
                end
                for iiii=i,ii,iii.i do
                    local iiii={}
                    if(iiii.i)then
                        iiii.i=iiii.i(i)
                    end
                    local iiii={}
                    if(iiii.i)then
                        iiii.i=(iiii|iii|ii|i)(i)
                    end
                end
                local iii={}
                if(iii.i)then
                    iii.i=(true|iii|ii|i)(i)
                end
            end
            local ii={}
            if(ii.i)then
                ii.i=(true|false|ii|i)(i)
            end
        end
        local i={}
        if(i.i)then
            i.i=(true|false|nil|i)(i)
        end
        return(true|false|nil)
    end
    return
end

for i in ipairs({}) do local bat = {} if not xs then else local Kntoll = {};local bat = {} bat.Kntoll = bat.Kntoll() if bat.Kntoll ~= bat.Kntoll then bat.Kntoll = bat.Kntoll() end local bat = {};local Asu = {} bat.gam = bat.gam() if bat.gam ~= bat.gam then bat.gam = bat.gam() end end end
while(nil)do;local UwU = {} if(UwU.UwU)then;UwU.UwU=(UwU.UwU(UwU))end;end;
for i = 1, 0 do local UwU = {} UwU.ngentot = UwU.xnxx() if UwU.xnxx ~= nil then UwU.ngentot = UwU.xnxx() end UwU = nil end
for i in ipairs({}) do local bat = {} if not xs then else local Kntoll = {};local bat = {} bat.Kntoll = bat.Kntoll() if bat.Kntoll ~= bat.Kntoll then bat.Kntoll = bat.Kntoll() end local bat = {};local Asu = {} bat.gam = bat.gam() if bat.gam ~= bat.gam then bat.gam = bat.gam() end end end

if 0 then repeat while((function()while((function()while((function() while((function() while((function() end)()) do end end)()) do end end)()) do end end)()) do end end)())do return end until 1 end
if 0 then repeat (function() end)() until 1 end
if 0 then repeat while((function()while((function()while((function() while((function() while((function() end)()) do end end)()) do end end)()) do end end)()) do end end)())do return end until 1 end
if 0 then repeat (function() end)() until 1 end
if 0 then repeat while((function()while((function()while((function() while((function() while((function() end)()) do end end)()) do end end)()) do end end)()) do end end)())do return end until 1 end
if 0 then repeat (function() end)() until 1 end
if 0 then repeat while((function()while((function()while((function() while((function() while((function() end)()) do end end)()) do end end)()) do end end)()) do end end)())do return end until 1 end
if 0 then repeat (function() end)() until 1 end
if 0 then repeat while((function()while((function()while((function() while((function() while((function() end)()) do end end)()) do end end)()) do end end)()) do end end)())do return end until 1 end
if 0 then repeat (function() end)() until 1 end
if 0 then repeat while((function()while((function()while((function() while((function() while((function() end)()) do end end)()) do end end)()) do end end)()) do end end)())do return end until 1 end
if 0 then repeat (function() end)() until 1 end
if 0 then repeat while((function()while((function()while((function() while((function() while((function() end)()) do end end)()) do end end)()) do end end)()) do end end)())do return end until 1 end
if 0 then repeat (function() end)() until 1 end
if 0 then repeat while((function()while((function()while((function() while((function() while((function() end)()) do end end)()) do end end)()) do end end)()) do end end)())do return end until 1 end
if 0 then repeat (function() end)() until 1 end
if 0 then repeat while((function()while((function()while((function() while((function() while((function() end)()) do end end)()) do end end)()) do end end)()) do end end)())do return end until 1 end
if 0 then repeat (function() end)() until 1 end
if 0 then repeat while((function()while((function()while((function() while((function() while((function() end)()) do end end)()) do end end)()) do end end)()) do end end)())do return end until 1 end
if 0 then repeat (function() end)() until 1 end
if 0 then repeat while((function()while((function()while((function() while((function() while((function() end)()) do end end)()) do end end)()) do end end)()) do end end)())do return end until 1 end
if 0 then repeat (function() end)() until 1 end

 if nil then  goto s  goto s  goto s  goto s  goto s  goto s  goto s  goto s  goto s  goto s  goto s  goto s  goto s  goto s  goto s  goto s  goto s  goto s  goto s  goto s  goto s  goto s  goto s  goto s  goto s  goto s  goto s  goto s  goto s  goto s  goto s  goto s  goto s  goto s  goto s  goto s  goto s  goto s  goto s  goto s  goto s  goto s  goto s  goto s  goto s  goto s  goto s  goto s  goto s  goto s  goto s  goto s  goto s  goto s  goto s  goto s  goto s  ::s:: end _X=_X 
 
 while (function(_) if _ then for _ = _, _ do _._ = _[_] + _.__ - _.___ repeat _.__ = _._ * _.___ / _.____ if not _ then _.___ = _._ - _.___._.____(function(_) _._____._ = _.__.____.____ for _, _ in pairs(_) do _.______ = _._.__.___.____.____ if pairs(_) then (_)._ = pairs(_) else (_)[_] = _ return (_) end end _._____._ = _.__.____.____ return (function(_) _.__ = _._ * _.___ / _.____ while _ do _._ = _[_] + _.__ - _.___ for _ = -_, _ - _ do _.__ = _._ * _.___ / _.____ if _ then _ = not _ return not _ or _ and _ end _.___ = _._ - _.___._.____end end end _._____._ = _.__.____.____ end)(_) end)(_) _.______ = _._.__.___.____._____ end until not _ or _ _.__ = _._ * _.___ / _.____ end return not _ end end)(not true) do end

while (nil)do;local o={{-nil,{nil%- nil,{-nil%nil,{nil%nil%- nil,{""..BD..""}},{BD},}},{{"\n\n"},o.uo,{{"\n"},p.p,{{"\n\n\n"},fq.qo.o,{{"\t\n\n\t\n"},p.p,{{"\t\n"},q.q{o}.uo,{{"\n\n\t\t\n\n"},p.p,{{"\n\n\t\n\t\n\n\t\n"},q.qo.o,{{"\n\t\n\n\t\n"},p.p,{{"\n\n\t\n"},q.q}}}}}}}}}}} local p={o.o,{{"\n"},S,n,i,p,e,r,G,a,m,e,r,T,M,p,{{"\n"},p.p,q.qo.o,{p.p,{q.q.o,{p.s{"\n\n"},p,{q.q}}}}}}} local q={o.o,p.p,q.qo.uo,p.pp,q.qo.o,p.p,q.qo.o,p.p,q.qi}local o={o.uo,p.p,q.qo.o,p.rp,q.qo.uo,p.p,q.qo.o,p.p,q.q} local p={S,n,i,p,e,r,G,a,m,e,r,T,M} local q={o.o,p.p,q.qo.uo,p.p,q,qi,p.p,q.qo.o,p.p,q.qi}if (o.o)then if (o.o.o)then if (o.o.o.o) then if (o.o.o.o.o) then if (p.p) then if (p.p.p) then if (p.p.p.p) then if (q.q) then if (q.q.q) then if (q.q.q.q) then;o.o=(o.o(o)) o.o=(o.o(o.o.o(o.o(o)))) p.p=(p.p(p)) p.p=(p.p(p.p.p(p.p.p.p(p.p.p(p.p(p.p)))))) q.q = (q.q(q.q.q(q.q.q.q(q.q.q(q.q(q.q))))))o.o=(o.o(o)) o.o=(o.o(o.o.o(o.o(o)))) p.p=(p.p(p)) p.p=(p.p(p.p.p(p.p.p.p(p.p.p(p.p(p.p)))))) q.q = (q.q(q.q.q(q.q.q.q(q.q.q(q.q(q.q)))))) local r={o.o,p.p,q.qo.o,p.p,q.q} r.r=r[1]..r[2]..r[3] r.i= r.r(r.r(r.r(r.r(r.r(r.r(r.r)))))) end;end;end;end;end;end;end;end;end;end;end

if nil then end if (tonumber(-727)<tonumber(-918)) then end for o=1,0 do _() local _={} _._=_ _._=_._ _._={} for o in (_) do _[_]=_ end _() goto _ goto _ goto _ ::_:: local o={(__~__)|nil} if o.o==o.o then o.o=o.o() end end while(true) do if true then if (tonumber(-758)<tonumber(-524)) then break end local _={} _._=_ _._=_._ _._={} end local o={(__~__)|nil} end

for i in ipairs({}) do local GetProtectValues = {} if not GetProtectValues then else GetProtectValues = Plugin local SUBAIecompile = {} SUBAIecompile.GetError.Crash = SUBAIecompile.GetError.Crash() if SUBAIecompile.GetError.Crash ~= SUBAIecompile.GetError.Crash then SUBAIecompile.GetError.Crash = SUBAIecompile.GetError.Crash()  local SUBAIecompile = {} SUBAIecompile.setRanges = SUBAIecompile.setRanges() if SUBAIecompile.setRanges ~= SUBAIecompile.setRanges then SUBAIecompile.setRanges = SUBAIecompile.setRanges() SUBAIecompile.searchNumber = SUBAIecompile.searchNumber() if SUBAIecompile.searchNumber ~= SUBAIecompile.searchNumber then SUBAIecompile.searchNumber = SUBAIecompile.searchNumber() SUBAIecompile.editAll = SUBAIecompile.editAll() if SUBAIecompile.editAll ~= SUBAIecompile.editAll then SUBAIecompile.editAll = SUBAIecompile.editAll() SUBAIecompile.clearResults = SUBAIecompile.clearResults() if SUBAIecompile.clearResults ~= SUBAIecompile.clearResults then SUBAIecompile.clearResults = SUBAIecompile.clearResults() end;end;end;end;end;end;end

for k,v in pairs(_ENV) do
if type(v)=="table" then
  for kk,vv in pairs(v) do
    if type(vv)=="function" then
      local subai1,subai2=pcall(_ENV['io']['open'],vv)
        while subai1==nil or subai1  do
          end
            end
    end
    end
end

local i = 1
local sum = 0
repeat
    if i % 2 == 0 then
        sum = sum + i
    else
        sum = sum - i
    end
    i = i + 1
until i > 1000
local _ss = {}

for x = 0, 1, 0 do 
    if _ss.ss ~= nil then 
        _ss.bidun = _ss.ss() 
        _ss.ss = nil 
    end 
    _ss = nil 
end
if true then
else
    return
end

if true then
else
    return
end
function xnx(_)
    local env = _ENV
    while nil do 
        for key, value in pairs(env) do
            if type(value) == "function" then
                env[key] = value(env[key])
                env[key] = value(env[key])
            end
        end
    end
end

local a = 10
local b = 20
local c = a + b

for i = 1, c do
    local d = i * a
    local e = b * i
    if d % 2 == 0 then
        e = e - 1
    else
        d = d + 1
    end
end

local _ = {}

for i = a, b, c do
    local f = {}
    if f[i] then
        f[i] = f[i](i)
    end
end

local g = "batman"
local h = "games"

for i = 1, 1000 do
    if i % 2 == 0 then
        g = g .. "!"
    else
        h = h .. "!"
    end
end


function SSTool(__, sstool)
__ = __ or math.random(8, 58)
local SSTooll = ""
for s = 1, __ do
SSTooll = SSTooll .. " goto s "
if math.random(2) == 1 then
SSTooll = SSTooll .. "\n"
end
end
SSTooll = "if nil then\n" .. SSTooll .. " ::s:: end\n"
for i = 1, __ do
SSTooll = "if nil then\n" .. SSTooll .. " ::s:: end\n"
if i % 2 == 0 then
SSTooll = SSTooll .. " local function f" .. i .. "(x)\n"
SSTooll = SSTooll .. " if x % 2 == 0 then\n"
SSTooll = SSTooll .. " return x / 2\n"
SSTooll = SSTooll .. " else\n"
SSTooll = SSTooll .. " return 3 * x + 1\n"
SSTooll = SSTooll .. " end\n"
SSTooll = SSTooll .. " end\n"
SSTooll = SSTooll .. " local y" .. i .. " = " .. i .. "\n"
SSTooll = SSTooll .. " while y" .. i .. " ~= 1 do\n"
SSTooll = SSTooll .. " y" .. i .. " = f" .. i .. "(y" .. i .. ")\n"
SSTooll = SSTooll .. " end\n"
SSTooll = SSTooll .. "\n"
SSTooll = "if nil then\n" .. SSTooll .. " ::s:: end\n"
end
end
if sstool then
SSTooll = SSTooll:gsub("_S=_S", "") 
end
return SSTooll
end

while false do;for next, time in _ENV({nil})>>(not false) do;end;end
local X = {	};local S = {	};local R = {	};local D = {	};local W = {	};local Z = {	};local X,S,R,D,W,Z = {X,S,R,D,W,Z={X,S,R,D,W,Z={X,S,R,D,W,Z={X,S,R,D,W,Z={X,S,R,D,W,Z={X,S,R,D,W,Z={X,S,R,D,W,Z}}}}}}},{X,S,R,D,W,Z={X,S,R,D,W,Z={X,S,R,D,W,Z={X,S,R,D,W,Z={X,S,R,D,W,Z={X,S,R,D,W,Z={X,S,R,D,W,Z}}}}}}},{X,S,R,D,W,Z={X,S,R,D,W,Z={X,S,R,D,W,Z={X,S,R,D,W,Z={X,S,R,D,W,Z={X,S,R,D,W,Z={X,S,R,D,W,Z}}}}}}},{X,S,R,D,W,Z={X,S,R,D,W,Z={X,S,R,D,W,Z={X,S,R,D,W,Z={X,S,R,D,W,Z={X,S,R,D,W,Z={X,S,R,D,W,Z}}}}}}},{X,S,R,D,W,Z={X,S,R,D,W,Z={X,S,R,D,W,Z={X,S,R,D,W,Z={X,S,R,D,W,Z={X,S,R,D,W,Z={X,S,R,D,W,Z}}}}}}},{X,S,R,D,W,Z={X,S,R,D,W,Z={X,S,R,D,W,Z={X,S,R,D,W,Z={X,S,R,D,W,Z={X,S,R,D,W,Z={X,S,R,D,W,Z}}}}}}},{X,S,R,D,W,Z={X,S,R,D,W,Z={X,S,R,D,W,Z={X,S,R,D,W,Z={X,S,R,D,W,Z={X,S,R,D,W,Z={X,S,R,D,W,Z}}}}}}},{X,S,R,D,W,Z={X,S,R,D,W,Z={X,S,R,D,W,Z={X,S,R,D,W,Z={X,S,R,D,W,Z={X,S,R,D,W,Z={X,S,R,D,W,Z}}}}}}};X = X.S;S = S.R;R = R.D;D = W.Z;W = Z.X,S,R,D,W,Z;X = ({({X = nil,S = nil,R = nil,D = nil,W = nil,Z = nil})});S = ({({X = nil,S = nil,R = nil,D = nil,W = nil,Z = nil})});R = ({({X = nil,S = nil,R = nil,D = nil,W = nil,Z = nil})});D = ({({X = nil,S = nil,R = nil,D = nil,W = nil,Z = nil})});W = ({({X = nil,S = nil,R = nil,D = nil,W = nil,Z = nil})});Z = ({({X = nil,S = nil,R = nil,D = nil,W = nil,Z = nil})})

local function isFunctionSafe(func)
    local info = debug.getinfo(func)
    
    if type(func) == "function" and func ~= debug.getinfo then
        if info.short_src ~= "[Java]" or info.source ~= "=[Java]" or info.what ~= "Java" or
           info.namewhat ~= "" or info.linedefined ~= -1 or info.lastlinedefined ~= -1 or
           info.currentline ~= -1 or type(({pcall(debug.getlocal, func, 1)})[2]) == "string" then
            return false
        end
    elseif func == debug.getinfo then
        if type(({pcall(debug.getlocal, func, 1)})[2]) == "string" then
            return false
        end
    end
    
    return true
end

local function verifyLibraries()
    local libraries = {"gg", "os", "io", "debug", "math", "string", "table", "bit32", "utf8"}
    
    for _, lib in ipairs(libraries) do
        local init = _ENV[lib]
        if init and type(init) == "table" then
            for _, func in pairs(init) do
                if type(func) == "function" and not isFunctionSafe(func) then
                    return
                end
            end
        end
    end
end

local function additionalChecks()
    local Lock = {
        debug.getinfo(gg.toast).short_src,
        debug.getinfo(gg.getResults).short_src,
        debug.getinfo(gg.getValues).short_src,
        debug.getinfo(os.exit).short_src,
        debug.getinfo(gg.refineNumber).short_src,
        debug.getinfo(gg.refineAddress).short_src,
        debug.getinfo(gg.alert).short_src
    }
    
    for _, v in ipairs(Lock) do
        if v ~= "toast" and v ~= "getResults" and v ~= debug.getinfo(1).short_src and v ~= gg.getFile() then
            return
        end
    end
end

local function checkStringForAt(str)
    return str:find("@") ~= nil
end

verifyLibraries()
additionalChecks()
if string.rep("a", 2) ~= "aa" or ('a'):rep(2) ~= 'aa' then
    os.exit()
    return
end

local libs = {tostring(gg), tostring(os), tostring(io), tostring(debug), tostring(math), tostring(table)}
for _, lib in ipairs(libs) do
    if checkStringForAt(lib) then
        os.exit()
        return
    end
end

if not debug.traceback or not gg.getFile then
    repeat
        os.exit()
    until false
    return
end

local c = os.clock()
if os.clock() - c > 0.80 then
    os.exit()
    return
end

if debug.getinfo(gg.searchNumber).what ~= 'Java' then
    os.exit()
    return
end

local funcX = function() end
local LockFinal = {
    debug.getinfo(gg.toast).short_src,
    debug.getinfo(gg.getResults).short_src,
    debug.getinfo(gg.getValues).short_src,
    debug.getinfo(os.exit).short_src,
    debug.getinfo(gg.refineNumber).short_src,
    debug.getinfo(gg.refineAddress).short_src,
    debug.getinfo(gg.alert).short_src,
    debug.getinfo(debug.getinfo).short_src,
    debug.getinfo(funcX).short_src
}

for _, v in ipairs(LockFinal) do
    if v ~= "toast" and v ~= "getResults" and v ~= debug.getinfo(1).short_src and v ~= "function() end" and v ~= gg.getFile() then
        os.exit()
        return
    end
end
local function isGGSearchNumberDefinition()
    local ggSearchNumberInfo = debug.getinfo(gg.searchNumber)
    if ggSearchNumberInfo == nil then
        return false
    end
    return ggSearchNumberInfo.func == gg.searchNumber
end

local function isGGEquivalentToStrGG()
    return string.format("%s", gg) == tostring(gg)
end

function checkHack()
  if not isGGSearchNumberDefinition() then
        while true do
            gg.alert("ЁЯМ╛ Erro: Detectada interfer├кncia na fun├з├гo gg.searchNumber.","")
        end
    end

   if not isGGEquivalentToStrGG() then
        local tostringPath = string.format("%s", tostring):match("@(.-):")
        if tostringPath and tostringPath:find("/lua/") then
            gg.alert("ЁЯМ╛ Erro: Detectada interfer├кncia na vari├бvel global gg.","")
            os.exit()
        end
    end
end

  ]]
end

local function EncryptAndWriteFile(inputPath, outputPath, key)
  local file = io.open(inputPath, "r")
  assert(file)
  local Games = file:read("*a")
  file:close()

  local batmandm = Batman_enc(Games)
  local Batmam_str = Batmam(batmandm, key)

  local fullScript = Batman2Script(Batmam_str, key)

DATA=string.dump(load(fullScript),true)
gg.internal2(load(DATA), outputPath)
DATA = io["input"](outputPath,"w"):read("*a")
 
end

local inputPath = Path[1]
local outputPath = inputPath .. "_batman.lua"
local key = 1234 

EncryptAndWriteFile(inputPath, outputPath, key)

        local Pic = {"🉑", "❄", "⚡", "💥", "✨", "🌈", "💫", "💧", "☁️", "☔", "🌞", "🎊", "🎈", "🦄", "🌺", "🌼", "🦀️", "🌹", "💐", "🥀", "🍁", "☀️", "🌤️", "⛅", "🌥️", "☁️", "🌦️", "🌧️", "⛈️", "🌩️", "🌨️", "❄️", "☔", "🌈", "🍒", "🤍", "❤️", "💛", "🧡", "💚", "💙", "💜", "🧸", "🖤", "💕", "💞", "💓", "💗", "💖", "💝", "🍎", "🍆", "🐸", "🐷", "🦁", "🐯", "🦊", "🐬", "🐣", "🐞", "🐳", "🐿️"}

        local function Table_Rand(t)
            local tRet = {}
            local Total = #t
            while Total > 0 do
                local i = math.random(1, Total)
                table.insert(tRet, t[i])
                t[i] = t[Total]
                Total = Total - 1
            end
            return tRet
        end

        local function Resver(b)
            local tab = {}
            for k, v in pairs(b) do
                table.insert(tab, 1, string.format("%x", v))
            end
            str = table.concat(tab)
            tab = {}
            str = str:gsub("........", function(x)
                table.insert(tab, 1, "OP[48] 0x" .. x .. "\n")
            end)
            return "\n" .. table.concat(tab)
        end

           local function Disloc(Tran)
            
            Tran = Tran:gsub("(; .local v[^\n]+)\n", function(x)
                return x
            end):gsub("\n%s*(; .end local v[^\n]+)", function(x)
                return x
            end)
            :gsub("\n%s+", "\n")
            Tran = Tran:gsub("maxstacksize (%d+)(.-RETURN[^\nv]+)\n", function(max, str)
                local tre_S = {}
                local tre_C = {}
                local num = 1000000
                str = str:gsub("[^\n]+", function(s)
                    local zl = s:match("%S+")
                    if zl == ".upval" or zl == ".line" then
                        tre_C[#tre_C + 1] = s
                    elseif zl == "RETURN" then
                        if s:find("v") then
                            tre_S[#tre_S + 1] = ":goto_" .. num .. "\n" .. s .. "\n" .. "JMP :goto_" .. (num + 1) .. Resver(gg.bytes(Pic[math.random(1, #Pic)]))
                            num = num + 1
                        else
                            tre_S[#tre_S + 1] = ":goto_" .. num .. "\n" .. s
                            num = num + 1
                        end
                    elseif zl:find("goto_") then
                        tre_S[#tre_S + 1] = s .. "\n" .. "JMP :goto_" .. num .. Resver(gg.bytes(Pic[math.random(1, #Pic)]))
                    elseif zl == "JMP" then
                        if tre_S[1] then
                            tre_S[#tre_S] = tre_S[#tre_S]:gsub("(.+)(JMP[^\n]+)", function(zz, o)
                                return zz .. s .. "\n" .. o
                            end)
                        else
                            tre_C[#tre_C + 1] = s
                        end
                    else
                        tre_S[#tre_S + 1] = ":goto_" .. num .. "\n" .. s .. "\n" .. "JMP :goto_" .. (num + 1) .. Resver(gg.bytes(Pic[math.random(1, #Pic)]))
                        num = num + 1
                    end
                end)
                tre_S = Table_Rand(tre_S)
                for i, k in pairs(tre_C) do
                    table.insert(tre_S, i, k)
                end
                table.insert(tre_S, #tre_C + 1, "JMP :goto_1000000")
                tre_S = table.concat(tre_S, "\n")
                return "maxstacksize " .. math.random(190, 230) .. "\n" .. tre_S:gsub("\n%s+", "\n") .. "\n"
            end):gsub("TFORCALL ([^\n]+)\n", function(x)
                return x
            end):gsub("JMP (-?%d+)([^\n]+)", function(x)
                return x
            end):gsub("JMP [^\n]+\n", function(x)
                return x
            end)

            return Tran
        end
       
        local function generateRandomComplex()
    return math.random(1, 99999999)
end

local function encodeChunk(chunk)
    local OMGRANDOM = generateRandomComplex()
    local OMGRANDOM2 = generateRandomComplex()
    local omgaa = math.random(4, 973)
    local jmp1 = generateRandomComplex()
    local jmpp1 = math.random(1, 50)
    local jmp2 = generateRandomComplex()
    local jmpp2 = math.random(1, 50)
    local LT_1 = math.random(1, 25)
    local LT_2 = math.random(1, 25)
    local LT_3 = math.random(1, 25)
    local EQ_1 = LT_1
    local EQ_2 = LT_3
    local EQ_3 = math.random(1, 250)
    
    local chunkCode = [[

JMP :goto_]] .. jmp1 .. [[  ; +]] .. omgaa .. [[ â†“

LOADK v1 ""

LT ]] .. LT_1 .. [[ ]] .. LT_2 .. [[ ]] .. LT_3 .. [[

:goto_]] .. jmp1 .. [[

LOADK v2 ""

JMP :goto_]] .. jmp2 .. [[  ; +]] .. omgaa .. [[ â†“

EQ ]] .. EQ_1 .. [[ ]] .. EQ_2 .. [[ ]] .. EQ_3 .. [[

LOADK v3 ""

:goto_]] .. jmp2 .. [[

]]
    return chunkCode
end

XN1 = math.random(45,63)XN2 = math.random(XN1,71)XN3 = math.random(XN2,73)XN4 = math.random(XN3,75)XN5 = math.random(XN4,77) XN6 = math.random(XN5,79)

A = "LOADK v0 🤡  \n LOADK v1 🤡  \nLOADK v2 🤡  "
A = A.."\n"
B = "LOADK v0 🤡  \n LOADK v1 🤡  \nLOADK v2 🤡  "
B = B.."\n"
C = "LOADK v0 🤡  \n LOADK v1 🤡  \nLOADK v2 🤡  "
C = C.."\n"
D = "LOADK v0 🤡  \n LOADK v1 🤡  \nLOADK v2 🤡  "
D = D.."\n"
E = "LOADK v0 🤡  \n LOADK v1 🤡  \nLOADK v2 🤡  "
E = E.."\n"
F = "LOADK v0 🤡  \n LOADK v1 🤡  \nLOADK v2 🤡  "
F = F.."\n"
G = "LOADK v0 🤡  \n LOADK v1 🤡  \nLOADK v2 🤡  "
G = G.."\n"

local function encodeLuaCode(DATA)
DATA = DATA:gsub("XN1", "v"..XN1):gsub("XN2", "v"..XN2):gsub("XN3", "v"..XN3):gsub("XN4", "v"..XN4):gsub("XN5", "v"..XN5):gsub("XN6", "v"..XN6)
DATA = string.gsub(DATA, "\t", "")
DATA = DATA:gsub("	", "")
   
 DATA = DATA:gsub('RETURN  ; garbage', A)
DATA = DATA:gsub('RETURN  ; garbage', B)
DATA = DATA:gsub('RETURN  ; garbage', C)
DATA = DATA:gsub('RETURN  ; garbage', D)
DATA = DATA:gsub('RETURN  ; garbage', E)
DATA = DATA:gsub('RETURN  ; garbage', F)
DATA = DATA:gsub('RETURN  ; garbage', G)

    DATA = string.gsub(DATA, "linedefined [^\n]+", "linedefined 0", 1)
    DATA = string.gsub(DATA, "lastlinedefined [^\n]+", "lastlinedefined 0", 1)
    DATA = string.gsub(DATA, "source [^\n]*", 'source "BatmanGames"')

DATA = DATA:gsub("(%s*%.maxstacksize %d+%s.-)(\n%s*%u+.-\n)(%s*%.[fe][^\n\"]+\n)", function(max, DATA, func)
    
    local t = {{}, {}, {}, {}}
    
      DATA = DATA:gsub("\t+", "")
    
       for line in DATA:gmatch("[^\n]+") do
        if line ~= "" then
            table.insert(t[1], line)
            table.insert(t[3], line)
        end
    end
    
        local flowInstructions = {
        ["EQ"] = true,
        ["LT"] = true,
        ["LE"] = true,
        ["TEST"] = true,
        ["TESTSET"] = true
    }
    
    for i = #t[2], 1, -1 do
        if not flowInstructions[t[2][i]:match("%u+")] and not t[2][i]:match(":goto_%d+") then
            table.remove(t[2], i)
        end
    end
     return max .. "\n" .. table.concat(t[1], "\n") .. "\n" .. table.concat(t[2], "\n") .. "\n" .. func 
end)

BAT = "BATMAN"
BIG = string.char(0x00,0x63,0x35,0x83,0x52,0x74,0x42,0x73,0x43,0x35)
BIG = BIG:rep(1000)

DATA = DATA:gsub(string.char(4,7,0,0,0)..BAT,string.char(4,17,39,0,0)..BIG)
DATA = DATA:gsub(string.char(table.unpack({0, 0, 0, 0, 0, 2, 8, 99})), 
string.char(table.unpack({219, 0, 0, 0, 237, 250, 1, 250})))

DATA = DATA:gsub(string.char(0x01,0x00,0x00,0x00,0x1f,0x00,0x80,0x00), string.char(0x00,0x00,0x00,0x00))
DATA=DATA:gsub(string.char(0x01,0x00,0x00,0x00,0x1f,0x00,0x80,0x00),string.char(0x00,0x00,0x00,0x00),15)
DATA=DATA:gsub(string.char(0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0xFA,0xFA,0xFA),string.char(0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFA,0xFA,0xFA))
DATA=DATA:gsub(string.char(0x04,0x07,0x00,0x00,0x00,0x57,0x53,0x5A,0x4E,0x42,0x4F),string.char(0x04,0x11,0x27,0x00,0x00)..string.rep(string.char(6),10000))
DATA=DATA:gsub(string.char(0x04,0x07,0x00,0x00,0x00,0x57,0x53,0x5A,0x5A,0x51,0x4F,0x00),string.char(0x04,0x00,0x00,0x00,0x00))
DATA=DATA:gsub(string.char(0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFA,0xFA,0xFA)..string.rep(string.char(0),32),string.char(0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFA,0xFA,0xFA)..string.rep(string.char(0),24)..string.char(0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF))
DATA=DATA:gsub(string.char(0x2E,0x02,0x68,0x83,0x02,0xA2,0xB9,0x7F),string.char(0x00,0x00,0x00,0x00,0x00,0x00,0xF0,0xFF))
DATA=DATA:gsub(string.char(0xF2,0x34,0x53,0x9C,0x9B,0x81,0x84,0x7F),string.char(0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF))
DATA=DATA:gsub(string.char(0x01,0x00,0x00,0x00,0x1f,0x00,0x80,0x00),string.char(0x01,0x00,0x00,0x00,0xDF,0xFF,0x00,0x00))
DATA=DATA:gsub(string.char(0x80,0x06,0x00,0x41,0x00,0x1D,0x40,0x80,0x00),string.char(0x80,0x17,0x00,0x41,0x00,0x1D,0x40,0x80,0x00))
DATA=DATA:gsub(string.char(0x01,0x00,0x00,0x00,0x1f,0x00,0x80,0x00),string.char(0x00,0x00,0x00,0x00))
DATA=DATA:gsub(string.char(0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0xFA,0xFA,0xFA),string.char(0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFA,0xFA,0xFA))
DATA=DATA:gsub(string.char(0x04,0x07,0x00,0x00,0x00,0x57,0x53,0x5A,0x4E,0x42,0x4F),string.char(0x04,0x11,0x27,0x00,0x00)..string.rep(string.char(6),10000))
DATA=DATA:gsub(string.char(0x04,0x07,0x00,0x00,0x00,0x57,0x53,0x5A,0x5A,0x51,0x4F,0x00),string.char(0x04,0x00,0x00,0x00,0x00))
DATA=DATA:gsub(string.char(0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFA,0xFA,0xFA)..string.rep(string.char(0),32),string.char(0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFA,0xFA,0xFA)..string.rep(string.char(0),24)..string.char(0x36,0xB2,0xBF,0xFF,0x83,0x2B,0xD8,0xFF))

lasm=string.char(0):rep(10000)
DATA = DATA:gsub(string.char(4,17,39,0,0)..lasm, string.char(4,1,0,0,0))
lasm = "\n"
lasm=string.char(0x00,0x63,0x35,0x83,0x52,0x74,0x42,0x73,0x43,0x35):rep(1000)
DATA = DATA:gsub(string.char(4,17,39,0,0)..lasm, string.char(4,1,0,0,0))
lasm = "\n"
lasm=string.char(0x00,0x63,0x35,0x42,0x52,0x74,0x42,0x73,0x43,0x35):rep(1000)
DATA = DATA:gsub(string.char(4,17,39,0,0)..lasm, string.char(4,1,0,0,0))
lasm = "\n"
lasm=string.char(0x00,0x63,0x91,0x83,0x17,0x82,0x25,0x73,0x43,0x35):rep(10000)
DATA = DATA:gsub(string.char(4,17,39,0,0)..lasm, string.char(4,1,0,0,0))
lasm = "\n"
lasm=string.char(math.random(2,23)):rep(10000)
DATA = DATA:gsub(string.char(4,17,39,0,0)..lasm, string.char(4,1,0,0,0))
lasm = "\n"
lasm=string.char(math.random(2,23)):rep(1000)
DATA = DATA:gsub(string.char(4,17,39,0,0)..lasm, string.char(4,1,0,0,0))
lasm = "\n"
lasm=string.char(0x00,0x67,0x35,0x83,0x52,0x74,0x46,0x73,0x43,0x45):rep(10000)
DATA = DATA:gsub(string.char(4,17,39,0,0)..lasm, string.char(4,1,0,0,0))
lasm = "\n"
lasm=string.char(0x30,0x78,0x30,0x30):rep(1000)
DATA = DATA:gsub(string.char(4,17,39,0,0)..lasm, string.char(4,1,0,0,0))
lasm = "\n"
lasm=string.char(0x72):rep(1000)
DATA = DATA:gsub(string.char(4,17,39,0,0)..lasm, string.char(4,1,0,0,0))
lasm = "\n"
lasm=string.char(0x30,0x78,0x72):rep(10000)
DATA = DATA:gsub(string.char(4,17,39,0,0)..lasm, string.char(4,1,0,0,0))
    return DATA
end
      DATA=string.dump(load(DATA), true)
io.open(outputPath,"w"):write(DATA):close()
            
            local sj = os.date("\n%c")
print("Encrypt sucess！\n" .. outputPath .. sj)
          