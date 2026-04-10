local Strlen = 0
local IsFirst = true
String={}
Str={}
function Enc_value(str)
if str=="" then return "\34\34"end
XXX=String[str]
if not XXX then
xXx=str
byte = {string.byte(str,1,-1)}
for i,v in pairs(byte) do
    if IsFirst then
        Str[#Str + 1] = "a[br]="..v
        IsFirst = false
    else
        Str[#Str + 1] = "a[#a+br]=bs a[#a]="..v
    end
end
Newlen = Strlen + #str
str = "(GCN(brt*0+"..(Strlen + 1)..",brt*0+"..Newlen.."))"
Strlen = Newlen
String[xXx]=str
return str
else
return XXX
end
end



local Min_num = function(...)
local arm = {...}
local num = nil
for i, v in pairs(arm) do
if v ~= nil then
if not num then
num = v
elseif num > v then
num = v
end
end
end
return num
end
Enc_Str=function(data)
	local gr = {}
	repeat
		local s1, ss1, x1, xx1, n1, n2, str
		s1 = string.find(data, "\034")--单引号
		ss1 = string.find(data, "\039")--双引号
		x1 = string.find(data, "%[[=]*%[")--中括号
		xx1 = string.find(data, "%-%-")--注释
		
		str = Min_num(s1, ss1, x1, xx1)
		
		if str == nil then
			break
		end
		
		if str == s1 then
			data = data:gsub("(.-)(\034.-\034)",function(t1, t2)
				gr[#gr + 1] = t1
				t2 = string.gsub(t2, "\\\\","\\092")
				t2 = string.gsub(t2, "\\\034", "\\034")
				
				if t2:sub(-1, -1) ~= "\034" then
					return t2
				end
				t3 = load("return "..t2)
				
				if not t3 then
					gg.alert("\034ERROR\n"..t2)
					os.exit()
				end
				gr[#gr + 1] = Enc_value(t3(),true)
				return ""
			end, 1)
			
		elseif str == ss1 then
			data = data:gsub("(.-)(\039.-\039)",function(t1, t2)
				gr[#gr + 1] = t1
				t2 = string.gsub(t2, "\\\\","\\092")
				t2 = string.gsub(t2, "\\\039", "\\039")
				
				if t2:sub(-1, -1) ~= "\039" then
					return t2
				end
				t3 = load("return "..t2)
				
				if not t3 then
					gg.alert("\039ERROR\n"..t2)
					os.exit()
				end
				gr[#gr + 1] = Enc_value(t3(),true)
				return ""
			end, 1)
			
		elseif str == x1 then
			local g1 = string.match(data,"%[([=]*)%[")
			data=data:gsub("(.-)(%["..g1.."%[.-%]"..g1.."%])",function(t1, t2)
				gr[#gr + 1] = t1
				t3 = load("return "..t2)
				
				if not t3 then
				gg.alert("[[ERROR\n"..t2)
				os.exit()
			end
				gr[#gr + 1] = Enc_value(t3(),true)
				return ""
			end, 1)
			
		elseif str == xx1 then
			d1, d2, d3, d4 = string.find(data, "%-%-(%[([=]*)%[)")
			
			if d1 == xx1 then
				data = string.gsub(data, "(.-)%-%-%[" .. d4 .. "%[.-%]" .. d4 .. "%]", function(txt1)
					gr[#gr + 1] = txt1
					return " "
				end, 1)
			else
				data = string.gsub(data, "(.-)%-%-[^\n]*", function(txt1)
					gr[#gr + 1] = txt1
					return ""
				end, 1)
				
			end
			
		else
			break
		end
		
	until not str
	gr[#gr+1]=data
	gr = table.concat(gr):gsub("return%s+end","return 0\nend")
	gr = gr:gsub("%-%-%[%[.-%]%]",""):gsub("%-%-[^\n]+", "")
return gr
end


local g,rl = {}
g.last = _ENV["gg"]["getFile"]()
g.info = nil
g.config = '/storage/emulated/0/Android/By.CitMau.cfx'
data = _ENV['loadfile'](g.config)
if data ~= nil then
g.info = data()
data = nil
end
if g.info == nil then
g.info = {g.last}
end

g.info = _ENV["gg"]["prompt"]({
'📁 Select file',
'Increased defense',
'Strengthen encryption(slow)',
'Strengthen encryption V2(quick)',
},g.info,{
'file',
'checkbox',
'checkbox',
'checkbox'
})
if g.info then 
else 
_ENV["gg"]["alert"]('')
_ENV["print"]("f")
_ENV["os"]["exit"]()
_ENV["error"]()
end

if _ENV["loadfile"](g.info[1]) then 
else 
_ENV["gg"]["alert"]('ERROR') 
_ENV["os"]["exit"]()
_ENV["error"]()
end
_ENV["gg"]["saveVariable"](g.info, g.config)
_ENV["输出"] =g.info[1]:gsub('%.lua$', '').."-[wi].Lua"
data=io.open(g.info[1],"r"):read("*a")


if g.info[2] == true then

FY = [=[



]=]
data = FY..data
end



if g.info[3]==true then

function MD5(strss)
  local HexTable = {"0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F"}
  local A = 0x67452301
  local B = 0xefcdab89
  local C = 0x98badcfe
  local D = 0x10325476

  local S11 = 7
  local S12 = 12
  local S13 = 17
  local S14 = 22
  local S21 = 5
  local S22 = 9
  local S23 = 14
  local S24 = 20
  local S31 = 4
  local S32 = 11
  local S33 = 16
  local S34 = 23
  local S41 = 6
  local S42 = 10
  local S43 = 15
  local S44 = 21

  local function F(x,y,z)
    return (x & y) | ((~x) & z)
  end
  local function G(x,y,z)
    return (x & z) | (y & (~z))
  end
  local function H(x,y,z)
    return x ~ y ~ z
  end
  local function I(x,y,z)
    return y ~ (x | (~z))
  end
  local function FF(a,b,c,d,x,s,ac)
    a = a + F(b,c,d) + x + ac
    a = (((a & 0xffffffff) << s) | ((a & 0xffffffff) >> 32 - s)) + b
    return a & 0xffffffff
  end
  local function GG(a,b,c,d,x,s,ac)
    a = a + G(b,c,d) + x + ac
    a = (((a & 0xffffffff) << s) | ((a & 0xffffffff) >> 32 - s)) + b
    return a & 0xffffffff
  end
  local function HH(a,b,c,d,x,s,ac)
    a = a + H(b,c,d) + x + ac
    a = (((a & 0xffffffff) << s) | ((a & 0xffffffff) >> 32 - s)) + b
    return a & 0xffffffff
  end
  local function II(a,b,c,d,x,s,ac)
    a = a + I(b,c,d) + x + ac
    a = (((a & 0xffffffff) << s) | ((a & 0xffffffff) >> 32 - s)) + b
    return a & 0xffffffff
  end



  local function MD5StringFill(s)
    local len = #s
    local mod512 = len * 8 % 512
    local fillSize = (448 - mod512) // 8
    if mod512 > 448 then
      fillSize = (960 - mod512) // 8
    end

    local rTab = {}
    local byteIndex = 1
    for i = 1,len do
      local index = (i - 1) // 4 + 1
      rTab[index] = rTab[index] or 0
      rTab[index] = rTab[index] | (s:byte(i) << (byteIndex - 1) * 8)
      byteIndex = byteIndex + 1
      if byteIndex == 5 then
        byteIndex = 1
      end
    end
    local b0x80 = false
    local tLen = #rTab
    if byteIndex ~= 1 then
      rTab[tLen] = rTab[tLen] | 0x80 << (byteIndex - 1) * 8
      b0x80 = true
    end
    for i = 1,fillSize // 4 do
      if not b0x80 and i == 1 then
        rTab[tLen + i] = 0x80
       else
        rTab[tLen + i] = 0x0
      end
    end
    local bitLen = math.floor(len * 8)
    tLen = #rTab
    rTab[tLen + 1] = bitLen & 0xffffffff
    rTab[tLen + 2] = bitLen >> 32

    return rTab
  end

   string.md5 = function(s)
    local fillTab = MD5StringFill(s)
    local result = {A,B,C,D}
    for i = 1,#fillTab // 16 do
      local a = result[1]
      local b = result[2]
      local c = result[3]
      local d = result[4]
      local offset = (i - 1) * 16 + 1
      a = FF(a, b, c, d, fillTab[offset + 0], S11, 0xd76aa478)
      d = FF(d, a, b, c, fillTab[offset + 1], S12, 0xe8c7b756)
      c = FF(c, d, a, b, fillTab[offset + 2], S13, 0x242070db)
      b = FF(b, c, d, a, fillTab[offset + 3], S14, 0xc1bdceee)
      a = FF(a, b, c, d, fillTab[offset + 4], S11, 0xf57c0faf)
      d = FF(d, a, b, c, fillTab[offset + 5], S12, 0x4787c62a)
      c = FF(c, d, a, b, fillTab[offset + 6], S13, 0xa8304613)
      b = FF(b, c, d, a, fillTab[offset + 7], S14, 0xfd469501)
      a = FF(a, b, c, d, fillTab[offset + 8], S11, 0x698098d8)
      d = FF(d, a, b, c, fillTab[offset + 9], S12, 0x8b44f7af)
      c = FF(c, d, a, b, fillTab[offset + 10], S13, 0xffff5bb1)
      b = FF(b, c, d, a, fillTab[offset + 11], S14, 0x895cd7be)
      a = FF(a, b, c, d, fillTab[offset + 12], S11, 0x6b901122)
      d = FF(d, a, b, c, fillTab[offset + 13], S12, 0xfd987193)
      c = FF(c, d, a, b, fillTab[offset + 14], S13, 0xa679438e)
      b = FF(b, c, d, a, fillTab[offset + 15], S14, 0x49b40821)
      a = GG(a, b, c, d, fillTab[offset + 1], S21, 0xf61e2562)
      d = GG(d, a, b, c, fillTab[offset + 6], S22, 0xc040b340)
      c = GG(c, d, a, b, fillTab[offset + 11], S23, 0x265e5a51)
      b = GG(b, c, d, a, fillTab[offset + 0], S24, 0xe9b6c7aa)
      a = GG(a, b, c, d, fillTab[offset + 5], S21, 0xd62f105d)
      d = GG(d, a, b, c, fillTab[offset + 10], S22, 0x2441453)
      c = GG(c, d, a, b, fillTab[offset + 15], S23, 0xd8a1e681)
      b = GG(b, c, d, a, fillTab[offset + 4], S24, 0xe7d3fbc8)
      a = GG(a, b, c, d, fillTab[offset + 9], S21, 0x21e1cde6)
      d = GG(d, a, b, c, fillTab[offset + 14], S22, 0xc33707d6)
      c = GG(c, d, a, b, fillTab[offset + 3], S23, 0xf4d50d87)
      b = GG(b, c, d, a, fillTab[offset + 8], S24, 0x455a14ed)
      a = GG(a, b, c, d, fillTab[offset + 13], S21, 0xa9e3e905)
      d = GG(d, a, b, c, fillTab[offset + 2], S22, 0xfcefa3f8)
      c = GG(c, d, a, b, fillTab[offset + 7], S23, 0x676f02d9)
      b = GG(b, c, d, a, fillTab[offset + 12], S24, 0x8d2a4c8a)
      a = HH(a, b, c, d, fillTab[offset + 5], S31, 0xfffa3942)
      d = HH(d, a, b, c, fillTab[offset + 8], S32, 0x8771f681)
      c = HH(c, d, a, b, fillTab[offset + 11], S33, 0x6d9d6122)
      b = HH(b, c, d, a, fillTab[offset + 14], S34, 0xfde5380c)
      a = HH(a, b, c, d, fillTab[offset + 1], S31, 0xa4beea44)
      d = HH(d, a, b, c, fillTab[offset + 4], S32, 0x4bdecfa9)
      c = HH(c, d, a, b, fillTab[offset + 7], S33, 0xf6bb4b60)
      b = HH(b, c, d, a, fillTab[offset + 10], S34, 0xbebfbc70)
      a = HH(a, b, c, d, fillTab[offset + 13], S31, 0x289b7ec6)
      d = HH(d, a, b, c, fillTab[offset + 0], S32, 0xeaa127fa)
      c = HH(c, d, a, b, fillTab[offset + 3], S33, 0xd4ef3085)
      b = HH(b, c, d, a, fillTab[offset + 6], S34, 0x4881d05)
      a = HH(a, b, c, d, fillTab[offset + 9], S31, 0xd9d4d039)
      d = HH(d, a, b, c, fillTab[offset + 12], S32, 0xe6db99e5)
      c = HH(c, d, a, b, fillTab[offset + 15], S33, 0x1fa27cf8)
      b = HH(b, c, d, a, fillTab[offset + 2], S34, 0xc4ac5665)
      a = II(a, b, c, d, fillTab[offset + 0], S41, 0xf4292244)
      d = II(d, a, b, c, fillTab[offset + 7], S42, 0x432aff97)
      c = II(c, d, a, b, fillTab[offset + 14], S43, 0xab9423a7)
      b = II(b, c, d, a, fillTab[offset + 5], S44, 0xfc93a039)
      a = II(a, b, c, d, fillTab[offset + 12], S41, 0x655b59c3)
      d = II(d, a, b, c, fillTab[offset + 3], S42, 0x8f0ccc92)
      c = II(c, d, a, b, fillTab[offset + 10], S43, 0xffeff47d)
      b = II(b, c, d, a, fillTab[offset + 1], S44, 0x85845dd1)
      a = II(a, b, c, d, fillTab[offset + 8], S41, 0x6fa87e4f)
      d = II(d, a, b, c, fillTab[offset + 15], S42, 0xfe2ce6e0)
      c = II(c, d, a, b, fillTab[offset + 6], S43, 0xa3014314)
      b = II(b, c, d, a, fillTab[offset + 13], S44, 0x4e0811a1)
      a = II(a, b, c, d, fillTab[offset + 4], S41, 0xf7537e82)
      d = II(d, a, b, c, fillTab[offset + 11], S42, 0xbd3af235)
      c = II(c, d, a, b, fillTab[offset + 2], S43, 0x2ad7d2bb)
      b = II(b, c, d, a, fillTab[offset + 9], S44, 0xeb86d391)
      result[1] = result[1] + a
      result[2] = result[2] + b
      result[3] = result[3] + c
      result[4] = result[4] + d
      result[1] = result[1] & 0xffffffff
      result[2] = result[2] & 0xffffffff
      result[3] = result[3] & 0xffffffff
      result[4] = result[4] & 0xffffffff
    end
    local retStr = ""
    for i = 1,4 do
      for _ = 1,4 do
        local temp = result[i] & 0x0F
        local str = HexTable[temp + 1]
        result[i] = result[i] >> 4
        temp = result[i] & 0x0F
        retStr = retStr .. HexTable[temp + 1] .. str
        result[i] = result[i] >> 4
      end
    end

    return retStr
  end

  return "_ENV['"..string.md5(strss).."']=nil"
end

local function rneaw()
local qrw = MD5(string.char(tostring(math.random(46,80))))
return qrw
end

local function wqez(CitMau)
local REW = [[
local _x = {}
local result = 0
local function evaluateExpression(expression)
end
_x[-(nil << -true) >> nil] = function(a)
    return _x[nil / false](x[nil * nil >> true < nil])
end
while (_x[(nil ~ true) >> -false](evaluateExpression(_x[-(#true - nil)]()))) do
    local index = x[nil ~ -true ~ false][-nil % -false % nil]
    _x[index] = nil + nil % #-true
    result = (nil / -nil) % (true ~ -false)
end
]]
CitMau = CitMau:gsub("if .- then",function (a)
return a .. "\nfor i = 1, 0 do local b = {120,71,113,82,128,130} if b.d ~= nil then a.d = bj.g() end break end\n" .. rneaw() .. "\n\n"
end)
CitMau = CitMau:gsub("if .- then",function (i)
return "\nif false then\n" .. REW .. "\n" .. rneaw() .. "\n" .. REW .. "\nend\n" .. i
end)
return CitMau
end
data=wqez(data)
end


if g.info[4] == true then
local function TW(CitMau)
for i = 1, 2 do
if i == 1 then
CitMau=CitMau:gsub("if .- then",function(a)
return a .. "\nfunction iiiaw(s) if s ~= nil then local a = {s} if a ~= true then local rr = #tostring(s)+#tostring(a) end end end\n"
end)
end
if i == 2 then
local AS = "\nif (false) then if (not true) then end local aandw = #tostring(gg.searchNumber) ^ 6 * 9 + 0 - 1 + 4 if (false) then local jja = {} jja[#jja+1] = jja if nil then jooo=table.unpack(jja) * 97 end end end\n"
data=data:gsub("if .- then",function (a)
return AS .. a
end)
end
end
return CitMau
end
data = TW(data)
end



for k, v in pairs(_ENV)
do
Y = type(v)
if Y == "table" then
for kk, vv in pairs(v) do
data = data:gsub("gg.getRangesList","_ENV['gg']['getRangesList']")
data = data:gsub(k .. "%s*%.%s*" .. kk, "_ENV['" .. k .. "']['" .. kk .. "']")
end
elseif Y == "function" then
data = data:gsub("gg.getRangesList","_ENV['gg']['getRangesList']")
data = data:gsub(k .. "%s*%(", "_ENV['" .. k .. "'](")
end
end

data = Enc_Str(data)

Dedata =[=[

FGVV=1 
local bs,br='',FGVV
local brt=255
local smain={} smain[1]=function ()local a={}
]=]..table.concat(Str," ")..[=[ 
return a end 

local charbase={}
for i=0,255 do
charbase[i]=string.char(i)
bs=bs..charbase[i]
end

for i=1,12 do
bs=bs..bs
end

local Mta,sei=smain[1](),{}
for i=2,#smain do
    local s=smain[i]()
    for j=1,#s do
        Mta[#Mta+1]=s[j]
    end
end
local function GCN(a,b)
local s=sei[""..a..b]
if not s then
s=""
for i=a,b do
s=s..charbase[Mta[i]]
end
sei[""..a..b]=s
end
return s
end


]=]

data = Dedata..data


logo=[=[

Encryption level:⭐️⭐️⭐️
🇮‌ 🇼‌🇦‌🇳‌🇹‌ 🇹‌🇴‌ 🇫‌🇺‌🇨‌🇰‌ 🇹‌🇭‌🇦‌🇹‌ 🇬‌🇮‌🇷‌🇱
🅘 🅦🅐🅝🅣 🅣🅞 🅕🅤🅒🅚 🅣🅗🅐🅣 🅖🅘🅡🅛
เ ฬคภՇ Շ๏ Ŧยςк ՇђคՇ ﻮเгɭ


]=]
data = "local LOGO = [==["..logo.."]==]\n"..string.rep("\n;(function(); \n",5)..data..string.rep("\n end)()\n",5)


path="/sdcard/lasm"
data=string.dump(load(data),true)
local res = gg.internal2(load(data), path)
if not res then print("ERROR!") end
data=io.open(path,"r"):read("*a")

local function CitMau_zl(CitMau)
    CitMau = CitMau:gsub("LOADK[^\n]+",function(a)
        return "NEWTABLE v"..math.random(90,120).." "..math.random(90,120).." "..math.random(90,120).."\n"..a
    end)
    CitMau = CitMau:gsub("MOD[^\n]+", function(a)
        return a .. "\nLOADK v" .. math.random(90,120) .. " " .. math.random(90,120) .. "\n"
    end)
    CitMau = CitMau:gsub("UNM[^\n]+", function(a)
        return a .. "\nLOADK v" .. math.random(90,120) .. " " .. math.random(90,120) .. "\n"
    end)
    CitMau = CitMau:gsub("ADD[^\n]+", function(a)
        return a .. "\nVARARG v" .. math.random(90,120) .. "\n"
    end)
    CitMau = CitMau:gsub("RETURN[^\n]+", function(a)
        return a .. "\nEQ " .. math.random(90,120) .. " " .. math.random(90,120) .. " " .. math.random(90,120) .. "\n"
    end)
    return CitMau
end
data = CitMau_zl(data)
local My_Name="CitMau"
data=data:gsub('(\n%s*RETURN [^\n]*)','%1\nRETURN v250..v250;'..My_Name..'\n')
local shkvj = "\nNEWTABLE v"..math.random(120,150).." "..math.random(120,150).." 34\n"..'RETURN v'..math.random(130,160)..'..v'..math.random(130,160)..';'..My_Name..''
data=data:gsub("RETURN [^\n]+",function (a)
return a .. shkvj
end)

local process, rand, max, _sc, _tu = { }, math.random, math.maxinteger, string.char, table.unpack;

local function jmp(str)
    local n = string.sub(max, 1, 9)
    str = str:gsub("\n\t+%u+", function(x)
        if x:match("%u+") ~= "JMP" then
            x = "\n:goto_" .. n + 0 .. "\nJMP :goto_" .. n + 1 .. "  ; +0 ↓\n\n:goto_" .. n + 1 .. x
            n = n + 2
        end
        return x
    end)
    return str
end

data = jmp(data,true)

local g = {}
saa = string.char(math.random(128,255))..string.char(math.random(128,255))..string.char(math.random(128,255))..string.char(math.random(128,255))

local CitMauB = function(len)
    len = len or 1
    local Table1 = {saa}
    local CitMauB = ''
    for i=1,len do
        CitMauB = CitMauB..Table1[math.random(1,#Table1)]
    end
    return CitMauB
end

g.ASM = {
['LOADK'] = 2,
['LOADKX'] = 2,
['EXTRAARG'] = 2,
['MOVE'] = 2,
['UNM'] = 2,
['NOT'] = 2,
['LEN'] = 2,
['ADD'] = 2,
['SUB'] = 2,
['MUL'] = 2,
['DIV'] = 2,
['MOD'] = 2,
['POW'] = 2,
['GETTABLE'] = 2,
['SETTABLE'] = 2,
['NEWTABLE'] = 2,
['SELF'] = 2,
['SETLIST'] = 2,
['LOADNIL'] = 2,
['CONCAT'] = 2,
['CALL'] = 2,
['VARARG'] = 2,
['TAILCALL'] = 2,
['TFORCALL'] = 2,
['GETUPVAL'] = 2,
['SETUPVAL'] = 2,
['GETTABUP'] = 2,
['SETTABUP'] = 2,
['CLOSURE'] = 2
}

g.jmp1 = 1000000

CitMau_con = function()

    local GH = {
        "\nTEST v137 0\nEQ " .. math.random(46,80) .. " " .. math.random(46,80) .. " " .. math.random(46,80) .. "\n",
        
        "\nADD v" .. math.random(46,80) .. " v" .. math.random(46,80) .. " v131\nEQ " .. math.random(56,80) .. " v" .. math.random(56,80) .. " " .. math.random(56,80) .. "\n",
        "\nEQ 186 v167 v676\nLE 165 55 57\n",
        
        "\nLOADK v" .. math.random(86,120) .. " " .. math.random(86,120) .. "\nLOADBOOL v97 " .. math.random(46,80) .. "\nMOVE v" .. math.random(46,80) .. " v" .. math.random(46,80) .. "\n",
        
        "\nLEN v" .. math.random(46,80) .. " v0\nTEST v" .. math.random(46,80) .. " 1\n",
    }
    
    return GH[math.random(1,#GH)]
end

gg.toast("😃")

data2 = {}

local CitMauQ = ''

for k,v in pairs({string.byte(CitMauB(),1,-1)})do
    CitMauQ = CitMauQ .. '\\' .. v
end

for text in string.gmatch(data, '[^\n]+') do
    if text ~= '' then
        g.txt1 = string.match(text, '%S+')
        if g.ASM[g.txt1] then
            g.jmp2 = g.jmp1 + 1
            g.jmp3 = g.jmp2 + 1
            text = "\nLOADK v" .. math.random(42,160) .. " " .. math.random(42,160) .. "\nJMP :goto_" .. g.jmp1 .. "\nADD v" .. math.random(46,80) .. " v134 v" .. math.random(46,80) .. "\n:goto_" .. g.jmp2 .. "\n" .. text .. "\nJMP :goto_" .. g.jmp3 .. "\n"..CitMau_con().."\n:goto_" .. g.jmp1 .. "\nJMP :goto_" ..  g.jmp2 .. "\nTEST v" .. math.random(46,50) .. " 1" .. "\n:goto_" .. g.jmp3 .. "\nMOVE v" .. math.random(56,160) .. " v" .. math.random(56,160) .. "\n"
            g.jmp1 = g.jmp3 + 1
        end
        data2[#data2 + 1] = text
    end
end

data = table.concat(data2, '\n')

data = data:gsub("linedefined [^\n]+", "linedefined 0")
    :gsub("lastlinedefined [^\n]+", "lastlinedefined 0")
    :gsub("%.numparams %d+%s+%.is_vararg (%d+)%s+%.maxstacksize %d+", function(vararg)
        if tonumber(vararg) == 1 then
            return ".numparams 0\n.is_vararg 250\n.maxstacksize 250"
        else
            return ".numparams 250\n.is_vararg 250\n.maxstacksize 250"
        end
    end)


local cuowu = [[
.upval u1 "" ; u1
.upval u9 "" ; u2
.upval u10 "" ; u3
.upval u0 "" ; u4
.upval v0 "" ; u5
.upval u11 "" ; u6
.upval u12 "" ; u7
.upval u13 "" ; u8
.upval u14 "" ; u9
.upval u15 "" ; u10
.upval u16 "" ; u11
]]

data = string.gsub(data, "%.upval v0 nil ; u0\n", "%0" .. cuowu, 1)

data = data:gsub("\x00\x00\x00\x00\x00\x00\x00\x00\xFA\xFA\xFA(....)\x17...",function(y)
	        return "\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFA\xFA\xFA"..y.."\x63\xBD"..string.char(math.random(250,255),math.random(95,127))
	    end):gsub("\x00\x00\x00\x00\x00\x00\x00\x00\xFA\xFA\xFA(....)\x17...",function(y)
	        return "\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFA\xFA\xFA"..y.."\x63\xBD"..string.char(math.random(250,255),math.random(95,127))
	    end)
data=string.gsub(data, string.char(0x04, 0x07, 0x00, 0x00, 0x00, 0x44, 0x51, 0x44, 0x51, 0x44, 0x51),(function() local tab={} table.insert(tab,string.char(0x04, 0x11, 0x27, 0x00, 0x00)) for i=1,10000 do table.insert(tab,string.char(math.random(58,126))) end return table.concat(tab) end))
	data = string.gsub(data, string.char(0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xFA, 0xFA, 0xFA), string.char(0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFA, 0xFA, 0xFA))
	data = string.gsub(data, string.char(0x04, 0x07, 0x00, 0x00, 0x00, 0x6C, 0x52, 0x6C, 0x52, 0x6C, 0x52, 0x00), string.char(0x04, 0x00, 0x00, 0x00, 0x00))

    zjmhx = function()
        local tab = {}
        for i = 1, 12 do
            tab[i] = string.char(math.random(0, 255))
        end
        return table.concat(tab)
    end
    data = string.gsub(data, string.rep(string.char(0x1F, 0x00, 0x80, 0x00), 3), zjmhx)

data=string.gsub(data,string.char(0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xFA, 0xFA, 0xFA),
				string.char(0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFA, 0xFA, 0xFA))
data=string.gsub(data,string.char(0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFA, 0xFA, 0xFA), function()
			return string.char(math.random(200, 255), math.random(200, 255), math.random(200, 255), math.random(200, 255), 
						math.random(200, 255), math.random(200, 255), math.random(200, 255), math.random(200, 255), 0xFA, 0xFA, 0xFA) end)
              
data,error=data:gsub(string.char(0x1B,0x00,0x00, 0x00, 0x17, 0x00 ,0x00 ,0x80,0x01),string.char(0x1B, 0x00, 0x00, 0x00 ,0x17, 0x00 ,0x00 ,0x80 ,0x17))

data,error=data:gsub(string.char(0x1B,0x00,0x00, 0x00, 0x17, 0x40 ,0x00 ,0x80,0x01),string.char(0x1B, 0x00, 0x00, 0x00 ,0x17, 0x40 ,0x00 ,0x80 ,0x99))

data,error=data:gsub(string.char(0x17 ,0x80 ,0xFE ,0x7F ,0x06),
string.char(0x17 ,0x80 ,0x1B ,0x7F ,0x06))

data,error=data:gsub(string.char(0x1F ,0x00 ,0x80 ,0x00 ),
string.char(0x1F ,0x00 ,0x80 ,0xAB))

data=string.dump(load(data),true)
io.open(_ENV["输出"],"w"):write(data):close()
gg.alert("Finish😎")