local DB = "/sdcard/users.db"

gg.execSQL(DB, [[
CREATE TABLE IF NOT EXISTS users(
  username TEXT PRIMARY KEY,
  password TEXT
)]]

)

local function esc(str)
  return str:gsub("'", "''")
end

function register()
  local input = gg.prompt({"user", "pass:"}, nil, {"text", "text"})
  if not input then return end

  local username = esc(input[1] or "")
  local password = esc(input[2] or "")

  if username == "" or password == "" then
    gg.toast("enter all fields")
    return
  end

  local check_sql = string.format("SELECT * FROM users WHERE username = '%s'", username)
  local existing = gg.querySQL(DB, check_sql)

  if existing and #existing > 0 then
    gg.toast("Users exists")
    return
  end

  local insert_sql = string.format("INSERT INTO users VALUES ('%s', '%s')", username, password)
  local success = pcall(function()
    gg.execSQL(DB, insert_sql)
  end)

  if success then
    gg.toast(" sucess!")
  else
    gg.toast("Error")
  end
end

function login()
  local input = gg.prompt({"User:", "pass:"}, nil, {"text", "text"})
  if not input then return false end

  local username = input[1]
  local password = input[2]

  if username == "" or password == "" then
    gg.toast("enter all fields")
    return false
  end

  local query_sql = [[
    SELECT username, password, '', username FROM users WHERE username = ']] .. username .. [[' AND password = ']] .. password .. [[';
  ]]

  local data = gg.querySQL(DB, query_sql, 0)

  if data and #data > 0 then
    gg.toast("Login done! Welcome " .. data[1])
    return true
  else
    gg.toast("invalid credentials")
    return false
  end
end

local opcao = gg.choice({"Register", "Login", "Exit"})
if opcao == 1 then
  register()
elseif opcao == 2 then
  login()
end
