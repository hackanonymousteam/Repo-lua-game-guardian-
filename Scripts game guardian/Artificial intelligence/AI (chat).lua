gg.setVisible(true)

local json = load(gg.makeRequest("https://raw.githubusercontent.com/rxi/json.lua/master/json.lua").content)()

local FILE = "/sdcard/ai_chat.json"

local models = {

    qwen = {
        provider = "dashscope",
        model = "qwen3.5-plus",
        url = "https://coding-intl.dashscope.aliyuncs.com/v1/chat/completions",
        key = "sk-sp-your_api_key",
        name = "Qwen 3.5"
    },
    glm = {
        provider = "dashscope",
        model = "glm-5",
        url = "https://coding-intl.dashscope.aliyuncs.com/v1/chat/completions",
        key = "sk-sp-your_api_key",
        name = "GLM-5"
    }
}

local current = "qwen"

local function read()
    local f = io.open(FILE, "r")
    if not f then return {} end
    local c = f:read("*a")
    f:close()
    return json.decode(c) or {}
end

local function save(t)
    local f = io.open(FILE, "w")
    f:write(json.encode(t))
    f:close()
end

local function buildPayload(modelKey, history)
    local m = models[modelKey]

    

    if m.provider == "dashscope" then
        return {
            model = m.model,
            messages = history,
          
        }
    end
end

local function parseResponse(content)
    local ok, data = pcall(json.decode, content)
    if not ok or not data then return content end

    if data.choices and data.choices[1] then
        return data.choices[1].message.content
    end

    if data.output and data.output.text then
        return data.output.text
    end

    return content
end

local function chat(msg)
    local hist = read()

    if msg == "clear" then
        save({})
        return "History cleared"
    end

    if msg == "history" then
        local txt = ""
        for _,v in ipairs(hist) do
            txt = txt .. v.role .. ": " .. v.content .. "\n\n"
        end
        return txt ~= "" and txt or "Empty"
    end

    table.insert(hist, {role="user", content=msg})

    local payload = buildPayload(current, hist)

    local res = gg.makeRequest(
        models[current].url,
        {
            ["Authorization"] = "Bearer " .. models[current].key,
            ["Content-Type"] = "application/json"
        },
        json.encode(payload),
        "POST"
    )

    if type(res) ~= "table" or res.code ~= 200 then
        return "Error:\n" .. (res and res.content or "request failed")
    end

    local reply = parseResponse(res.content)

    table.insert(hist, {role="assistant", content=reply})

    while #hist > 20 do table.remove(hist,1) end

    save(hist)

    return reply
end

local function chooseModel()
    local names = {}
    local keys = {}

    for k,v in pairs(models) do
        table.insert(names, v.name)
        table.insert(keys, k)
    end

    local c = gg.choice(names, nil, "Select Model")
    if c then current = keys[c] end
end

while true do
    local c = gg.choice({
        "Chat",
        "Model: "..models[current].name,
        "Exit"
    }, nil, "AI SDK")

    if c == 1 then
        local p = gg.prompt({"Message"}, {""}, {"text"})
        if p and p[1] ~= "" then
            gg.toast("Processing...")
            local r = chat(p[1])
            gg.alert(models[current].name .. "\n\n" .. r)
            print(r)
        end
    elseif c == 2 then
        chooseModel()
    else
        break
    end
end