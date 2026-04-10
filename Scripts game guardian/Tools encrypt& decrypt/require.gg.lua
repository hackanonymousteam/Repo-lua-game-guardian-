
local asser = (function()
    
    local g = (function()return gg end)()
    return function (boolen, msg)
        if not boolen then
            tris = nil
            if type(msg)=="string" then 
            gg.gotoBrowser("https://t.me/YOUR_Channel")
            g.alert(msg, "")            
            elseif type(msg)=="number" then
                error()
            end
            
            while (true) do gg.processKill(gg.setVisible(false)) end
        end
        return boolen
    end
end)()

local hookcc = (function()
    local minVersion = 101.1
    assert(gg.require(minVersion) == nil, 15)
    
    local validPackage = "BigN3ver.gg.lua"
    
    
    asser(gg.PACKAGE == validPackage, "📥 Please download GameGuardian (BigN3ver GG) on description!")
    local version = tonumber(gg.VERSION)
    local p, cnt = string.gsub(version,'[%d%.]','')
    local p_, m_ = string.gsub(version,"%.",'')
    local link="https://gameguardian.net/download"
    if (p ~= '' or (1 ~= m_ and m_ ~= 2)) then
        if gg.alert("Please do not use gameguardian mod version code.\n\nYou can download the gameguardian app here : "..link,"Copy Link","Cancel") == 1 then
            gg.copyText(link,false)
            gg.toast("Copy link done!")
        end
        while true do return os.exit() end
    end
    asser(version >= minVersion, 16)
    asser(cnt >= 1 or false, 17)
    asser(string.sub(tostring(gg.searchNumber("HelloWorld")),1,4)=="java", 18)
    asser(string.sub(tostring(gg.searchNumber(".")),1,7)=="android", 19)
    local getFile1 = string.gsub(gg.getFile(),"^/storage/emulated/0/", "/sdcard/")
    local getFile2 = string.gsub(gg.getFile(),"^/sdcard/","/storage/emulated/0/")
    asser(os.remove(getFile1)==true and os.remove(getFile2)==true, 20)
    asser(io.input(gg.getFile()), 21)io.close()
    asser(os.rename(gg.getFile(), "/sdcard/android/#")and io.open("/sdcard/android/#")==nil, 22)
    io.input(gg.getFile())local a,b,c=io.read(1, 6, 2);io.close()    
    end)()
local hookcc = (function()
    local ssethook,cnt,s=(function()return assert(debug.sethook, 6)end)(),nil,0
    local hook = (function()
        blooolean = false
        local tracebacks, getinfos
        local env = (function()return _ENV end)()
        local file = (function()return gg.getFile()end)()
        local traceback_ = (function()return debug.traceback end)()
        local getinfo_ = (function()return debug.getinfo end)()
        local gsub_ = (function()return assert(string.gsub) end)()
        asser(loadfile(file), 7)
        return function(why)
            tracebacks, cnt = gsub_(traceback_(),'.-%s+/','')
            tracebacks = gsub_(tracebacks,'([^\n]-):.-$','/%1')
            asser(cnt == 0 or tracebacks == asser(file, 8), 9)
            getinfos = asser(getinfo_(1), 10)
            asser(getinfos.func == getinfo_ and getinfos.source=="=[Java]", 11)
            s=s+1
         end
     end)()
     (hook, "c")
     asser(gg.getResults(3)==0 and assert(s==1), 12)
     asser(type(cnt)=="number", 13)
     debug.sethook()
end)()
gg.alert("")