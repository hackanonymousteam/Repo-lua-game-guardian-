
gg.setVisible(false)
local function getFileSizeBytes(path)
    local file, err = io.open(path, "rb")
    if not file then
        return nil, "Error opening file: " .. err
    end
    
    local content = file:read("*a")
    file:close()
    
    if not content then
        return nil, "File empty or unable to load content."
    end    
    return #content, nil
end

local function formatFileSize(bytes)
    local units = {"B", "KB", "MB", "GB", "TB"}
    local unitIndex = 1
    local size = bytes
    
    while size >= 1024 and unitIndex < #units do
        size = size / 1024
        unitIndex = unitIndex + 1
    end
    return string.format("%.2f %s", size, units[unitIndex])
end

local function script_to_bytes(content)
    local bytes = {}
    for i = 1, #content do
        bytes[i] = string.byte(content, i)
    end
    return bytes
end

local function encode_content(content)
    local bytes = script_to_bytes(content)
    
    local obfuscated_template = "local I,II=_G,_ENV local print_func=_ENV[\"print\"]local string_lib=_ENV[\"string\"]for _a=0,1,0 do local _b={}if _b.a~=nil then _b.d=_b.a()_b.a=nil-_a+_a-_a*_a/nil%_a~_a~~~_a%#_a end _b=nil-_a+_a-_a*_a/nil%_a~_a~~~_a%#_a end while not true do for _,_ in pairs(_ENV or {nil})do repeat until false end for _=1,1 do if(function()return false end)()then break end end for __,___ in next,({[1]=nil})do end end local _={}for i=1,1000 do if((function(x)local v=x if v==2 then elseif v==1 or v then v=not v or v v=1 end return v end)(\"BLOCKED_KEY\"))then end end local xxx=setmetatable({},{__index=function(_,k)return function(...)return k..tostring(...)..tostring(math.random())end end})for _=1,1000 do while false do for _,__ in ipairs({nil})do if not false then break end end end end function xnx(_ENV)for _=1,1 do local _={}if #_>0 then for k,v in pairs(_)do _[k]=v*2 end end end while false do local _=function()return \"nil\" end if _()==\"nil\" then break end end return table.concat({xxx[1](nil),tostring(nil),math.random(100),tostring(nil),xxx[2](math.huge)},\"|\")end local _R,_C,_T,_D=math.random,os.time,table.concat,string.char local _=_R(_C())local __=function(n,k)local r=\"\"for i=1,n do r=r.._D((_R(97,122)+k)%255)end return r end for _=1,0 do S='Blocker[Spam](Spam2)'if({}).N then({}).N=({}).N()end local v=_ENV[35]for i=1,24 do v=_ENV[v]v={v,v}end for _=1,9 do for _=1,4 do goto s::s::end for _={},0,{}do goto t::t::end for _={},{},{}do goto u::u::end end end for _=1,0 do for i=1,12 do local v=_ENV[35]v=_ENV[v]v={v,v,false}end end while nil do local o,_o_,po={},{}for _=1,3 do _=_[_]or _(_)o.po=o._o_ and o._o_()or nil end if o._o_~=_[nil]then for _=1,3 do _=_[_]or _(_)o.po=o._o_ and o._o_()or nil end o._o_,o.po=_[nil],_[nil]end o,po,_o_=_[nil],_[nil],_[nil]end if nil then while _ do return end end if nil then if true then else goto x end::x::if nil then while _ do return end end end local Batman_Games=209 for Batman_Games=Batman_Games,53 do pcall(function()_ENV[\"setmetatable\"](false)_ENV[\"warn\"](\"Warning: \"..Batman_Games+Batman_Games..\" - Suspicious activity detected\",true)_ENV[\"collectgarbage\"](\"collect\")_ENV[\"setreadonly\"](\"v\"..log[1],\"16\",false,_ENV[\"newproxy\"],\"0\",-1)_ENV[\"setreadonly\"](log,\"16\",true,_ENV[\"checkcaller\"],\"0\",-1)end)end local ktrep={}ktrep[1]=\"xyz\"II={}for cInW=1,1024 do II[cInW]=II end II=nil local getinfo=_ENV[\"debug\"][\"getinfo\"]local tables,strings={},{}local tI=_ENV[\"table\"][\"insert\"]for x=0,1,0 do local _m={}if _m.data~=nil then _m.bidun=_m.data()_m.data=nil end _m=nil end for x=0,1,0 do if nil~=nil then end local x={}x[\"\"]=x local t=(x)(x,x)t[1]=1 end while\"\"==\"NOP\"do BAT=(function()end)(\"OK\")end if luajava==nil then gg.alert('Unavailable! Please use GameGuardian Mod')return end if _G[string.char(116,104,114,101,97,100)]==nil then gg.alert('Unavailable! Please use GameGuardian Mod')return end local Batman_Games=_G[string.char(116,104,114,101,97,100)]Batman_Games(function()pcall(load(string.char(table.unpack({__BYTES__}))))end)"
    
    return obfuscated_template:gsub("__BYTES__", table.concat(bytes, ","))
end

local function encode_with_iterations(content, iterations)
    local final_code = content
    
    if iterations > 0 then
        gg.toast("Starting encoding... 0%")
        for i = 1, iterations do
            local percent = math.floor((i / iterations) * 100)
            gg.toast(percent .. "%")
            final_code = encode_content(final_code)
        end
        gg.toast("Encoding completed! 100%")
    end
    
    return final_code
end

local function determine_iterations(file_size_bytes)
    local MAX_LIMIT = 10354
    local LIMIT_4KB = 4.03 * 1024
    
    if file_size_bytes > MAX_LIMIT then
        return nil
    elseif file_size_bytes > LIMIT_4KB then
        return 6
    else
        return 7
    end
end

g = {}
g.last = "/sdcard/"
g.info = nil
g.config = gg.EXT_CACHE_DIR .. "/" .. gg.getFile():match("[^/]+$") .. "cfg"
g.data = loadfile(g.config)

if g.data ~= nil then
    g.info = g.data()
    g.data = nil
end

if g.info == nil then
    g.info = { g.last }
end

while true do
    g.info = gg.prompt({
        'Select .lua file:'
    }, g.info, {
        'file'
    })
    
    if not g.info or not g.info[1] then
        gg.alert("No file selected!")
        return
    end
    
    gg.saveVariable(g.info, g.config)
    g.last = g.info[1]
    
    if loadfile(g.last) == nil then
        gg.alert("Please select a valid .lua file!")
        return
    end
    
    local file_size_bytes, err = getFileSizeBytes(g.last)
    if not file_size_bytes then
        gg.alert("Error reading file:\n" .. err)
        return
    end
    
    local file_size_formatted = formatFileSize(file_size_bytes)
    local file_name = g.last:match("[^/]+$")
    
    if file_size_bytes > 10354 then
        gg.alert("❌ FILE TOO LARGE!\n\n" ..
                 "📂 File: " .. file_name .. "\n" ..
                 "📏 Size: " .. file_size_formatted .. "\n" ..
                 "⚠️  Maximum limit: 10 KB\n\n" ..
                 "❌ Encoding cancelled!")
        return
    end
    
    local num_iterations = determine_iterations(file_size_bytes)
    
    if not num_iterations then
        return
    end
        
    local f = io.open(g.last, "r")
    if not f then
        gg.alert("Error opening file for reading!")
        return
    end
    
    local data = f:read('*a')
    f:close()
    
    if not data or data == "" then
        gg.alert("File is empty!")
        return
    end
    
    g.out = g.last:match("[^/]+$")
    g.out = g.out:gsub("%.lua$", "")
    g.out = g.info[2] and (g.info[2] .. "/" .. g.out .. ".encoded.lua") or ("/sdcard/" .. g.out .. ".encoded.lua")    

    local final_code = encode_with_iterations(data, num_iterations)    
    local encoded_size_bytes = #final_code
    local encoded_size_formatted = formatFileSize(encoded_size_bytes)    
    DATA = string.dump(load(final_code), true)
    io.open(g.out, "w"):write(DATA):close()
    
    gg.alert("✅ ENCODING COMPLETED!\n\n" ..
             "📂  file:\n" ..
             "*" .. file_name ..".encoded.lua\n\n" ..
             "by batman games")    
    break
end