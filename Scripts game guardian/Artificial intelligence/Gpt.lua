gg.setVisible(true)

local apiKey = "sk-your-api-key-here"  -- Substitua pela sua chave real
local baseUrl = "https://api.proxyapi.ru/openai/v1"
local USERS_FILE = "chatgpt_conversations.json"

local model = "gpt-4o-mini"

-- JSON
local json = load(gg.makeRequest(
    "https://raw.githubusercontent.com/rxi/json.lua/master/json.lua"
).content)()

function string.trim(s)
    return s:match("^%s*(.-)%s*$")
end

local function readUsers()
    local f = io.open(USERS_FILE, "r")
    if not f then return {} end
    local c = f:read("*a")
    f:close()
    local ok, d = pcall(json.decode, c)
    return ok and d or {}
end

local function saveUsers(d)
    local f = io.open(USERS_FILE, "w")
    f:write(json.encode(d))
    f:close()
end

function getHistory(uid)
    return readUsers()[uid] or {}
end

function saveHistory(uid, h)
    local u = readUsers()
    if #h > 20 then
        h = {unpack(h, #h - 19)}
    end
    u[uid] = h
    saveUsers(u)
end

function chatGPT(prompt, uid)
    local history = getHistory(uid)

    table.insert(history, { role = "user", content = prompt })

    local payload = {
        model = model,
        messages = {
            { role = "system", content = "Responda em português de forma clara." }
        }
    }

    for _, m in ipairs(history) do
        table.insert(payload.messages, m)
    end

    local headers = {
        ["Authorization"] = "Bearer " .. apiKey,
        ["Content-Type"] = "application/json",
        ["Accept"] = "application/json"
    }

  
    local r = gg.makeRequest(
        baseUrl .. "/chat/completions",
        headers,
        json.encode(payload)
    )

    if r.code ~= 200 then
        return "API ERROR " .. r.code .. "\n" .. (r.content or "")
    end

    local data = json.decode(r.content)
    local ans = data.choices[1].message.content

    table.insert(history, { role = "assistant", content = ans })
    saveHistory(uid, history)

    return ans
end

while true do
    local p = gg.prompt(
        {"Message:", "User ID:"},
        {"", "user123"},
        {"text", "text"}
    )
    if not p then os.exit() end
    gg.alert(chatGPT(p[1], p[2]))
end