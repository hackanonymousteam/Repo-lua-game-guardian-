local TOKEN = "YOUR_TOKEN_API"
local json = nil
pcall(function()
    json = load(
        gg.makeRequest(
            "https://raw.githubusercontent.com/rxi/json.lua/master/json.lua"
        ).content
    )()
end)
if not json then
    json = require("json")
end
if not json then
    gg.alert("❌ JSON library not available")
    return
end
local logado = false
local user = nil
local admin_mode = false
local function hash(texto)
    local h = 5381
    for i = 1, #texto do
        h = (h * 33 + string.byte(texto, i)) % 4294967296
    end
    return string.format("%x", h)
end
local function req_get(url)
    return gg.makeRequest(url, {
        ["Accept"] = "application/json",
        ["Authorization"] = "Bearer " .. TOKEN
    })
end
local function req_post(url, body)
    return gg.makeRequest(url, {
        ["Accept"] = "application/json",
        ["Authorization"] = "Bearer " .. TOKEN,
        ["Content-Type"] = "application/json"
    }, body)
end
local function req_delete(url)
    return gg.makeRequest(url, {
        ["Accept"] = "application/json",
        ["Authorization"] = "Bearer " .. TOKEN,
        ["X-HTTP-Method-Override"] = "DELETE"
    }, "")
end
local function listar_pastes()
    local r = req_get("https://pastecode.dev/api/pastes")
    if not r or r.code ~= 200 then return nil end
    return json.decode(r.content)
end
local function ver_todos_usuarios()
    local pastes = listar_pastes()
    if not pastes then
        gg.alert("Erro searching users")
        return
    end
    local lista = {}
    for _, p in ipairs(pastes) do
        if p.title and p.title:sub(1,5) == "USER_" then
            table.insert(lista, p.title:sub(6))
        end
    end
    if #lista == 0 then
        gg.alert("no found")
        return
    end
    local txt = "users (" .. #lista .. ")\n\n"
    for i, v in ipairs(lista) do
        txt = txt .. i .. ". " .. v .. "\n"
    end
    gg.alert(txt)
end
local function salvar_usuario(nome, senha)
    local dados = {
        nome = nome,
        senha = hash(senha),
        data = os.date("%d/%m/%Y")
    }
    local payload = {
        title = "USER_" .. nome,
        exposure = "unlisted",
        expiration = "never",
        pasteFiles = {{
            syntax = "json",
            code = json.encode(dados)
        }}
    }
    local r = req_post(
        "https://pastecode.dev/api/pastes",
        json.encode(payload)
    )
    return r and (r.code == 200 or r.code == 201)
end
local function buscar_usuario(nome)
    local pastes = listar_pastes()
    if not pastes then return nil end
    for _, p in ipairs(pastes) do
        if p.title == "USER_" .. nome then
            local r = req_get(
                "https://pastecode.dev/api/pastes/" .. p.uuid
            )
            if r and r.code == 200 then
                local data = json.decode(r.content)
                local u = json.decode(data.pasteFiles[1].code)
                u.uuid = p.uuid
                return u
            end
        end
    end
    return nil
end
local function apagar_usuario(uuid)
    req_delete("https://pastecode.dev/api/pastes/" .. uuid)
end
local function registrar()
    local i = gg.prompt({"user", "pass"}, {"", ""}, {"text", "text"})
    if not i or i[1] == "" or i[2] == "" then return end
    if buscar_usuario(i[1]) then
        gg.alert("User existing")
        return
    end
    if salvar_usuario(i[1], i[2]) then
        gg.alert("Register sucess")
    else
        gg.alert("Error in register")
    end
end
--------------------------------------------------
-- LOGIN
--------------------------------------------------
local function login()
    local i = gg.prompt({"user", "pass"}, {"", ""}, {"text", "text"})
    if not i then return end
    local u = buscar_usuario(i[1])
    if not u then
        gg.alert("User no found")
        return
    end
    if u.senha ~= hash(i[2]) then
        gg.alert("pass incorrect")
        return
    end
    logado = true
    user = u
    gg.alert("Logged: " .. u.nome)
end
local function mudar_senha()
    if not logado then return end
    local i = gg.prompt({"New pass"}, {""}, {"text"})
    if not i then return end
    apagar_usuario(user.uuid)
    if salvar_usuario(user.nome, i[1]) then
        gg.alert("pass changed")
        logado = false
        user = nil
    else
        gg.alert("Error in save")
    end
end
--------------------------------------------------
-- MENU
--------------------------------------------------
local function menu()
    while true do
        local op, titulo
        if admin_mode then
            titulo = "MODE ADMIN"
            op = {"get users", "back"}
        elseif logado then
            titulo = "user: " .. user.nome
            op = {"my account", "change pass", "exit"}
        else
            titulo = "System LOGIN"
            op = {"Register", "Login", "mode Admin", "exit"}
        end
        local c = gg.choice(op, nil, titulo)
        if not c then break end
        if admin_mode then
            if c == 1 then ver_todos_usuarios()
            elseif c == 2 then admin_mode = false end
        elseif logado then
            if c == 1 then
                gg.alert("user: " .. user.nome .. "\nDate: " .. user.data)
            elseif c == 2 then
                mudar_senha()
            elseif c == 3 then
                logado = false
                user = nil
            end
        else
            if c == 1 then registrar()
            elseif c == 2 then login()
            elseif c == 3 then admin_mode = true
            elseif c == 4 then break end
        end
    end
end
menu()