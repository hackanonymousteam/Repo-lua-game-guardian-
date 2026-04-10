
local request = gg.makeRequest('https://worldtimeapi.org/api/timezone/Etc/UTC')

if request == nil or request.content == nil then
    print('Error getting reply.')
    return
end

local response = request.content

local unixtime = ""
for match in response:gmatch('"unixtime":(%d+)') do
    unixtime = match
    break
end

if unixtime == "" then
    print('Error: unixtime not found.')
else
    print('unixtime: ' .. unixtime)
    
    gg.sleep(4000)
    
    
    local recentTime = os.time()
    
    
    if recentTime then
    if recentTime == unixtime then
       gg.alert("verify time sucess")
    else
        gg.alert("time modified")
        os.exit()
    end
else
    print("Erro: " .. err)
end
    
    
end