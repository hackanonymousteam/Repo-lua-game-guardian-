gg.setVisible(true)

local b64 = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
local function base64_encode(t)
    local r = {}
    for i = 1, #t, 3 do
        local a, b, c = t:byte(i, i+2)
        local x = (a or 0) * 65536 + (b or 0) * 256 + (c or 0)
        r[#r+1] = b64:sub(bit32.rshift(x,18)%64+1,bit32.rshift(x,18)%64+1)
        r[#r+1] = b64:sub(bit32.rshift(x,12)%64+1,bit32.rshift(x,12)%64+1)
        r[#r+1] = b64:sub(bit32.rshift(x,6)%64+1,bit32.rshift(x,6)%64+1)
        r[#r+1] = b64:sub(x%64+1,x%64+1)
    end
    local p = (#t % 3)
    if p > 0 then for i = 1, 3 - p do r[#r-i+1] = '=' end end
    return table.concat(r)
end

local json = load(gg.makeRequest("https://raw.githubusercontent.com/rxi/json.lua/master/json.lua").content)()

local key = "YOUR_API_KEY"
local auth = "Basic " .. base64_encode("api:"..key)

local function optimize(f)
    local h = {["Authorization"]=auth,["Content-Type"]="application/octet-stream"}
    local fp = io.open(f,"rb")
    if not fp then return false,"file" end
    local d = fp:read("*a")
    fp:close()
    local r = gg.makeRequest("https://api.tinify.com/shrink",h,d)
    if not r or r.code ~= 201 then return false,"upload" end
    local j = json.decode(r.content)
    local u = gg.makeRequest(j.output.url,{["Authorization"]=auth})
    if not u or u.code ~= 200 then return false,"download" end
    return true,u.content,j
end

local function save(data,name)
    local p = "/sdcard/Download/"..name
    local f = io.open(p,"wb")
    if not f then return false end
    f:write(data)
    f:close()
    return p
end

while true do
    local i = gg.prompt({"png","name file output"},{"/sdcard/","optimized.webp"},{"file","text"})
    if not i then break end
    if not i[2]:match("%.") then i[2]=i[2]..".webp" end
    local ok,bin,info = optimize(i[1])
    if not ok then gg.alert("Erro"); break end
    local path = save(bin,i[2])
    if not path then gg.alert("Erro"); break end
    local o = info.input.size or 0
    local n = info.output.size or 0
    local r = math.floor((1-(info.output.ratio or 1))*100)
    gg.alert("Original: "..o.." bytes\nOtimized: "..n.." bytes\nreduce: "..r.."%\n\nSave in:\n"..path)
    local a = gg.alert("","new","exit")
    if a ~= 1 then break end
end

