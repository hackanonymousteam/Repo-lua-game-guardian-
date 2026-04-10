local Link = "https://pastebin.com/raw/5cE5Ehd5"

local response = gg.makeRequest(Link)
if response.content == nil then
    os.exit()
end

local getInfos = {}

for line in response.content:gmatch("[^\r\n]+") do
    local key, value = line:match("^%s*\"([^\"]+)\"%s*:%s*\"([^\"]+)\"%s*$")
    if key and value then
        getInfos[key] = value
    end
end

local gg = gg or nil  

local g = {}
g.info = gg.prompt({
    'Insert password:'
    
}, nil, {
    'text' -- 1
})

if g.info and g.info[1] ~= nil and type(g.info[1]) == 'string' then
    
    gg.saveVariable("password", g.info[1])  
    local password = g.info[1]  
    if password == getInfos.password then
        gg.alert("Correct password. Access permitted!")
    else
        gg.alert("Incorrect password. Access denied.")
    end
else
    gg.alert("empty password")
end