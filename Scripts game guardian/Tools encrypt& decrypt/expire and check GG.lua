
local dias = 3
local validade_ms = dias * 24 * 60 * 60 * 1000
local agora_ms = os.time() * 1000
local data_inicial_ms = os.time({
    year = 2025,
    month = 12,
    day = 3,
    hour = 0,
    min = 0,
    sec = 0
}) * 1000

if agora_ms > data_inicial_ms + validade_ms then
    gg.alert("❌ Script expired")
    os.exit()
else
end

if luajava == nil then
  gg.alert(" unavaliable please use gameguardian mod (suport luajava)")
else
  gg.toast("🎉 doneا 🎉")
end

local period = 10    
local digits_min, digits_max = 1000, 9999
 
local function gen_code()
  local window = math.floor(os.time() / period)
  local n = (window * 1664525 + 1013904223) % (digits_max - digits_min + 1)
  return tostring(n + digits_min)   
end
 
local function remaining_seconds()
  return period - (os.time() % period)
end
 
local code = gen_code()
local rem = remaining_seconds()
 
local prompt_msg = "🔐 Verification — enter code below to unlock 🔓\n\nCode:  " .. code ..
                   "\nExpires in: " .. tostring(rem) .. "s\n\n(Type the code exactly 💯)"
 
local res = gg.prompt({prompt_msg}, {""}, {"text"})
if not res or not res[1] or res[1] == "" then
  gg.alert("Cancelled — ERROR 404 ⚠️")
  os.exit()
end
 
if tostring(res[1]) == code then
  gg.alert("✅ Correct — opening Script")
else
  gg.alert("❌ Wrong Password ⚠️")
  os.exit()
end

--start your code here

--gg.setRanges(gg.REGION_CODE_APP)
--gg.searchNumber("55", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 1)