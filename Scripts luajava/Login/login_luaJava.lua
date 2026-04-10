URL = luajava.bindClass("java.net.URL")
BufferedReader = luajava.bindClass("java.io.BufferedReader")
InputStreamReader = luajava.bindClass("java.io.InputStreamReader")


function getCredentials(urlStr)
  local url = URL(urlStr)
  local reader = BufferedReader(InputStreamReader(url:openStream()))
  local line
  local content = ""
  while true do
    line = reader:readLine()
    if line == nil then break end
    content = content .. line .. "\n"
  end
  reader:close()
  return content
end

function isExpired(expireDate)
  local y, m, d = expireDate:match("(%d+)%-(%d+)%-(%d+)")
  local expireTime = os.time{year=tonumber(y), month=tonumber(m), day=tonumber(d)}
  return os.time() > expireTime
end

function login(username, password, raw_url)
  local creds = getCredentials(raw_url)
  for line in creds:gmatch("[^\r\n]+") do
    local user, pass, expire = line:match("([^:]+):([^:]+):([^:]+)")
    if username == user and password == pass then
      if isExpired(expire) then
        print("Account expired")
        return false
      else
        print("Login successful")
        return true
      end
    end
  end
  print("Invalid credentials")
  return false
end

login("55", "44", "https://pastebin.com/raw/GGeb92uZ")