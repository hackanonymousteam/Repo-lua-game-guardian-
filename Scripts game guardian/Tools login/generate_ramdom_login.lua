local function generateRandomString(length)
    local charset = {} 
    for i = 48, 57 do table.insert(charset, string.char(i)) end   -- 0-9
    for i = 65, 90 do table.insert(charset, string.char(i)) end   -- A-Z
    for i = 97, 122 do table.insert(charset, string.char(i)) end  -- a-z

    local result = {}
    for i = 1, length do
        local randomIndex = math.random(1, #charset)
        table.insert(result, charset[randomIndex])
    end

    return table.concat(result)
end

local password = math.random(10000, 99999)

local username = generateRandomString(8) 

gg.alert('Username: ' .. username)
gg.alert('password: ' .. password)

gg.copyText(username, true)
--gg.copyText(password, true)

local hmn = gg.prompt(
    {
        'username:',
        'password:'
    },
    {[1]='', [2]=''},
    {[1]='number', [2]='text'}
)

if not hmn then
    os.exit()
end

if hmn[1] == username and hmn[2] ==  
tostring(password) then
    gg.alert('correct!')
else
    gg.alert('error!')
    os.exit()
end