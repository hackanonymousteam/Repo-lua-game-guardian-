gg.setVisible(true)

local json = nil
if not pcall(function()
    json = load(gg.makeRequest("https://raw.githubusercontent.com/rxi/json.lua/master/json.lua").content)()
end) then
    json = require("json")
    if not json then gg.alert("JSON library error") return end
end

local FILE = "chat.json"

local function read()
    local f = io.open(FILE, "r")
    if not f then return {} end
    local c = f:read("*a")
    f:close()
    if not c or c == "" then return {} end
    local ok, d = pcall(json.decode, c)
    if ok then return d else return {} end
end

local function write(d)
    local f = io.open(FILE, "w")
    if not f then return end
    f:write(json.encode(d))
    f:close()
end

local function request(messages)
    local body = {
        model = "gpt-3.5-turbo",
        messages = messages
    }

    local headers = {
        ["Content-Type"] = "application/json"
    }

    local r = gg.makeRequest(
        "https://chateverywhere.app/api/chat",
        headers,
        json.encode(body),
        "POST"
    )

    if type(r) ~= "table" or r.code ~= 200 then
        return "Request error"
    end

    local t = r.content or ""
    t = t:gsub("\\n", "\n"):gsub("\\\"", "\""):gsub("\\\\", "\\")
    return t
end

local function chat()
    local id = gg.prompt({"User ID"}, {""}, {"text"})
    if not id then return end

    local uid = id[1]
    if uid == "" then uid = "default" end

    local data = read()
    if not data[uid] then
        data[uid] = {}
    end

    while true do
        local p = gg.prompt({"Message"}, {""}, {"text"})
        if not p then break end

        local msg = p[1]
        if msg == "" then
            gg.toast("Empty message")
        elseif msg:lower() == "exit" then
            break
        elseif msg:lower() == "clear" then
            data[uid] = {}
            write(data)
            gg.toast("Chat cleared")
        else
            table.insert(data[uid], {role = "user", content = msg})

            local res = request(data[uid])

            table.insert(data[uid], {role = "assistant", content = res})

            if #data[uid] > 20 then
                local n = {}
                for i = #data[uid] - 19, #data[uid] do
                    table.insert(n, data[uid][i])
                end
                data[uid] = n
            end

            write(data)

            local c = gg.alert(res, "Close")

        end
    end
end

chat()