gg.setVisible(true)

local CONFIG_FILE = "ollama.cfg"
local HISTORY_FILE = "ollama_history.json"

local json = load(gg.makeRequest(
  "https://raw.githubusercontent.com/rxi/json.lua/master/json.lua"
).content)()

local defaultConfig = {
  url = "https://ollama.com/api/generate",
  model = "gpt-oss:120b",
  api_key = "YOUR_API_KEY_HERE",
  max = 10,
  system = "You are a helpful AI assistant."
}

local function readFile(p)
  local f = io.open(p, "r")
  if not f then return nil end
  local c = f:read("*a")
  f:close()
  return c
end

local function writeFile(p, d)
  local f = io.open(p, "w")
  if not f then return end
  f:write(d)
  f:close()
end

local function loadConfig()
  local c = readFile(CONFIG_FILE)
  if not c then
    writeFile(CONFIG_FILE, json.encode(defaultConfig))
    return defaultConfig
  end
  local ok, v = pcall(json.decode, c)
  return ok and v or defaultConfig
end

local function loadHistory()
  local c = readFile(HISTORY_FILE)
  if not c then return {} end
  local ok, v = pcall(json.decode, c)
  return ok and v or {}
end

local function saveHistory(h)
  writeFile(HISTORY_FILE, json.encode(h))
end

local function ask(prompt)
  local cfg = loadConfig()
  local res = gg.makeRequest(
    cfg.url,
    {
      ["Content-Type"] = "application/json",
      ["Authorization"] = "Bearer " .. cfg.api_key
    },
    json.encode({
      model = cfg.model,
      prompt = prompt,
      stream = false
    }),
    "POST"
  )
  if type(res) ~= "table" or res.code ~= 200 then
    return "Request failed"
  end
  local data = json.decode(res.content)
  return data and data.response or "Invalid response"
end

local function chat()
  local input = gg.prompt(
    {"Message:", "User ID:"},
    {"", "user"},
    {"text", "text"}
  )
  if not input or input[1] == "" then return end

  local msg = input[1]
  local uid = input[2]

  local hist = loadHistory()
  hist[uid] = hist[uid] or {}

  table.insert(hist[uid], "User: " .. msg)
  while #hist[uid] > loadConfig().max * 2 do
    table.remove(hist[uid], 1)
  end

  local prompt = loadConfig().system .. "\n" .. table.concat(hist[uid], "\n") .. "\nAI:"
  gg.toast("Processing...")
  local reply = ask(prompt)

  table.insert(hist[uid], "AI: " .. reply)
  saveHistory(hist)

  local c = gg.alert("AI:\n\n" .. reply, "Copy", "Clear History", "Back")
  if c == 1 and gg.copyText then gg.copyText(reply) end
  if c == 2 then hist[uid] = {}; saveHistory(hist) end
end

local function setup()
  local c = loadConfig()
  local i = gg.prompt(
    {"API URL:", "Model:", "API Key:", "Max History:", "System Prompt:"},
    {c.url, c.model, c.api_key, tostring(c.max), c.system},
    {"text","text","text","number","text"}
  )
  if not i then return end
  writeFile(CONFIG_FILE, json.encode({
    url = i[1],
    model = i[2],
    api_key = i[3],
    max = tonumber(i[4]) or 10,
    system = i[5]
  }))
  gg.toast("Saved")
end

while true do
  local m = gg.choice(
    {"Chat", "Setup", "Clear All", "Exit"},
    nil,
    "Ollama AI"
  )
  if m == 1 then chat()
  elseif m == 2 then setup()
  elseif m == 3 then saveHistory({}); gg.toast("History cleared")
  else break end
end