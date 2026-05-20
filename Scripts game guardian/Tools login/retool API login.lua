local json = nil

if not pcall(function()
    json = load(
        gg.makeRequest(
            "https://raw.githubusercontent.com/rxi/json.lua/master/json.lua"
        ).content
    )()
end) then
    pcall(function()
        json = require("json")
    end)

    if not json then
        gg.alert("JSON library not available")
        os.exit()
    end
end


local SERVER_URL = ""

local input = gg.prompt(
    {
        "Username",
        "Password"
    },
    nil,
    {
        "text",
        "text"
    }
)

if not input then
    os.exit()
end

local username = tostring(input[1] or "")
local password = tostring(input[2] or "")

if username == "" or password == "" then
    gg.alert("Fill all fields")
    os.exit()
end

local response = gg.makeRequest(SERVER_URL)

if not response or not response.content then
    gg.alert("Connection error")
    os.exit()
end

local success, users = pcall(function()
    return json.decode(response.content)
end)

if not success or type(users) ~= "table" then
    gg.alert("Invalid server response")
    os.exit()
end

local valid = false
local account = nil

local i = 1

while i <= #users do
    local data = users[i]

    if tostring(data.user) == username
    and tostring(data.pass) == password then
        valid = true
        account = data
        break
    end

    i = i + 1
end

if not valid then
    gg.alert("Invalid login")
    os.exit()
end

gg.alert(
    "Login successful\n\n" ..
    "ID: " .. tostring(account.id) .. "\n" ..
    "User: " .. tostring(account.user)
)