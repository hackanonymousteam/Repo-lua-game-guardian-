
gg.setVisible(true)

local pasteUrl = nil

while true do
    local inicio = gg.choice({
        "❇️ Create Login ❇️",
        "❇️ Make Login ❇️",
        "❌ Exit ❌"
    }, nil, "Select an option")

    if not inicio then break end

    local function urlEncode(str)
        return (str:gsub("([^%w])", function(c)
            return string.format("%%%02X", string.byte(c))
        end):gsub(" ", "+"))
    end

    local function createLogin()
        
local info = gg.prompt(
    {"User", "Pass", "Validity [1;7]"},
    {"", "", "1"},
    {"text", "text", "number"}
)
        if not info then return end

        local user = info[1]
        local pass = info[2]
        local pos = tonumber(info[3]) or 1
        if pos < 1 then pos = 1 elseif pos > 7 then pos = 7 end

        local expire_days = tostring(pos)
        local jsonData = '{"user":"' .. user .. '","pass":"' .. pass .. '"}'

        local headers = {["Content-Type"] = "text/plain"}
        local response = gg.makeRequest("https://paste.rs", headers, jsonData)

        if type(response) ~= "table" or not response.content or not response.content:find("https://paste.rs/") then
            gg.alert("❌ Error creating paste:\n" .. (response.content or "No reply"))
            return
        end

        pasteUrl = response.content
        gg.alert("✅ Data saved!\nLink:\n" .. pasteUrl .. "\nValid for " .. expire_days .. " day(s)")
    end

    local function login()
        if not pasteUrl then
            gg.alert("❌ No paste URL available. Create a login first.")
            return
        end

        local loginInfo = gg.prompt({"Login User", "Login Pass"}, {}, {"text", "text"})
        if not loginInfo then return end

        local inUser, inPass = loginInfo[1], loginInfo[2]

        local raw = gg.makeRequest(pasteUrl)
        local ok = false
        if type(raw) == "table" and raw.content then
            local body = raw.content
            local savedUser = body:match('"user"%s*:%s*"(.-)"')
            local savedPass = body:match('"pass"%s*:%s*"(.-)"')
            if savedUser == inUser and savedPass == inPass then
                ok = true
            end
        end

        if ok then
            gg.alert("✅ Login success!")
            print("Script started.")
        else
            gg.alert("❌ Wrong user or password")
        end
    end

    if inicio == 1 then
        createLogin()
    elseif inicio == 2 then
        login()
    elseif inicio == 3 then
        break
    end
end



--[[
if g.info[4] == true then
    gg.setVisible(true)

    function urlEncode(str)
        return (str:gsub("([^%w])", function(c)
            return string.format("%%%02X", string.byte(c))
        end):gsub(" ", "+"))
    end

local info = gg.prompt(
    {"User", "Pass", "Validity [1;7]"},
    {"", "", "1"},
    {"text", "text", "number"}
)
    if not info then os.exit() end

    local user = info[1]
    local pass = info[2]
    local pos  = tonumber(info[3]) or 1

    local expire_days = "1"
    if pos == 1 then expire_days = "1"
    elseif pos == 2 then expire_days = "2"
    elseif pos == 3 then expire_days = "3"
    elseif pos == 4 then expire_days = "4"
    elseif pos == 5 then expire_days = "5"
    elseif pos == 6 then expire_days = "6"
    elseif pos == 7 then expire_days = "7"
    end

    local jsonData = '{"user":"' .. user .. '","pass":"' .. pass .. '"}'

    -- Envia para paste.rs
    local headers = {["Content-Type"]="text/plain"}
    local response = gg.makeRequest("https://paste.rs", headers, jsonData)
    if type(response) ~= "table" or not response.content or response.content:find("https://paste.rs/") == nil then
        gg.alert("❌ Error creating paste:\n" .. (response.content or "No reply"))
        os.exit()
    end

    local pasteUrl = response.content
    gg.alert("✅ Data saved!\nLink:\n" .. pasteUrl .. "\nValid for " .. expire_days .. " day(s)")

    
    local ZZ = '\nlocal CXY = "' .. pasteUrl .. '"\n' ..
               'local login = gg.prompt({"Login User","Login Pass"}, {}, {"text","text"})\n' ..
               'if not login then os.exit() end\n' ..
               'local inUser, inPass = login[1], login[2]\n' ..
               'local raw = gg.makeRequest(CXY)\n' ..
               'local ok = false\n' ..
               'if type(raw) == "table" and raw.content then\n' ..
               '  local body = raw.content\n' ..
               '  local savedUser = body:match(\'"user"%s*:%s*"(.-)"\')\n' ..
               '  local savedPass = body:match(\'"pass"%s*:%s*"(.-)"\')\n' ..
               '  if savedUser == inUser and savedPass == inPass then ok = true end\n' ..
               'end\n' ..
               'if ok then\n' ..
               '  gg.alert("✅ Login success!")\n' ..
               'else\n' ..
               '  gg.alert("❌ Wrong user or password")\n' ..
               '  os.exit()\n' ..
               'end\n'

    
    local file = io.open(g.out, "a")
    if file then
        file:write(ZZ)
        file:close()
    else
        gg.alert("❌ Error: Could not open file for writing.")
    end
end
]]