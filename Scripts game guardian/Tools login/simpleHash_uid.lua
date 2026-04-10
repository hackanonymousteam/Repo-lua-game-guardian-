-- SHA-256 (versi aman pengganti simpleHash)
local function simpleHash(str)
  local k = {
    0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5,
    0x3956c25b,0x59f111f1,0x923f82a4,0xab1c5ed5,
    0xd807aa98,0x12835b01,0x243185be,0x550c7dc3,
    0x72be5d74,0x80deb1fe,0x9bdc06a7,0xc19bf174,
    0xe49b69c1,0xefbe4786,0x0fc19dc6,0x240ca1cc,
    0x2de92c6f,0x4a7484aa,0x5cb0a9dc,0x76f988da,
    0x983e5152,0xa831c66d,0xb00327c8,0xbf597fc7,
    0xc6e00bf3,0xd5a79147,0x06ca6351,0x14292967,
    0x27b70a85,0x2e1b2138,0x4d2c6dfc,0x53380d13,
    0x650a7354,0x766a0abb,0x81c2c92e,0x92722c85,
    0xa2bfe8a1,0xa81a664b,0xc24b8b70,0xc76c51a3,
    0xd192e819,0xd6990624,0xf40e3585,0x106aa070,
    0x19a4c116,0x1e376c08,0x2748774c,0x34b0bcb5,
    0x391c0cb3,0x4ed8aa4a,0x5b9cca4f,0x682e6ff3,
    0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208,
    0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2
  }
  local function rrotate(x,n)
    return ((x >> n) | (x << (32-n))) & 0xffffffff
  end
  local function preprocess(msg)
    local len = #msg * 8
    msg = msg .. "\128"
    while (#msg * 8) % 512 ~= 448 do
      msg = msg .. "\0"
    end
    for i = 1, 8 do
      msg = msg .. string.char((len >> ((8 - i) * 8)) & 0xff)
    end
    return msg
  end
  local function bytesToWords(msg)
    local words = {}
    for i = 1, #msg, 4 do
      local b1,b2,b3,b4 = msg:byte(i,i+3)
      words[#words+1] = ((b1<<24)|(b2<<16)|(b3<<8)|b4) & 0xffffffff
    end
    return words
  end
  local function padHex(n)
    return string.format("%08x", n)
  end

  local h = {
    0x6a09e667,
    0xbb67ae85,
    0x3c6ef372,
    0xa54ff53a,
    0x510e527f,
    0x9b05688c,
    0x1f83d9ab,
    0x5be0cd19
  }

  local msg = preprocess(str)
  local w = {}

  for i = 1, #msg, 64 do
    local chunk = msg:sub(i, i+63)
    local words = bytesToWords(chunk)
    for j = 17, 64 do
      local s0 = rrotate(words[j-15],7) ~ rrotate(words[j-15],18) ~ (words[j-15] >> 3)
      local s1 = rrotate(words[j-2],17) ~ rrotate(words[j-2],19) ~ (words[j-2] >> 10)
      words[j] = (words[j-16] + s0 + words[j-7] + s1) & 0xffffffff
    end

    local a,b,c,d,e,f,g,h0 = table.unpack(h)

    for j = 1, 64 do
      local S1 = rrotate(e,6) ~ rrotate(e,11) ~ rrotate(e,25)
      local ch = (e & f) ~ ((~e) & g)
      local temp1 = (h0 + S1 + ch + k[j] + words[j]) & 0xffffffff
      local S0 = rrotate(a,2) ~ rrotate(a,13) ~ rrotate(a,22)
      local maj = (a & b) ~ (a & c) ~ (b & c)
      local temp2 = (S0 + maj) & 0xffffffff

      h0 = g
      g = f
      f = e
      e = (d + temp1) & 0xffffffff
      d = c
      c = b
      b = a
      a = (temp1 + temp2) & 0xffffffff
    end

    h[1] = (h[1] + a) & 0xffffffff
    h[2] = (h[2] + b) & 0xffffffff
    h[3] = (h[3] + c) & 0xffffffff
    h[4] = (h[4] + d) & 0xffffffff
    h[5] = (h[5] + e) & 0xffffffff
    h[6] = (h[6] + f) & 0xffffffff
    h[7] = (h[7] + g) & 0xffffffff
  end

  return table.concat({
    padHex(h[1]), padHex(h[2]), padHex(h[3]), padHex(h[4]),
    padHex(h[5]), padHex(h[6]), padHex(h[7]), padHex(h[8])
  })
end

-- Fingerprint perangkat (berbasis info unik)
local function generateUUID()
  local info = gg.getTargetInfo()
  local fingerprint = table.concat({
    info.packageName,
    tostring(info.versionCode),
    tostring(info.targetSdkVersion),
    tostring(info.abi),
    tostring(info.dataDir or ""),
    tostring(info.nativeLibraryDir or ""),
  }, "#")
  return simpleHash(fingerprint)
end

-- Ambil IP publik
local function getPublicIP()
  local res = gg.makeRequest("https://api.ipify.org")
  if res and res.code == 200 then
    return res.content
  else
    return "UNKNOWN"
  end
end

-- Validasi UUID ke server
local function validateUUID(uuid, ip)
  local url = "https://script.google.com/macros/s/AKfycbx_Cv99-yzkKzedWyWhWotJXqjpDyjvC7dggwMjYxokSpBQ3GAQ4ejNCY_WuM3ZUpIf/exec"
  local fullURL = url .. "?uuid=" .. uuid .. "&ip=" .. ip
  local res = gg.makeRequest(fullURL)

if not res or res.code ~= 200 then
    gg.alert("❌ Gagal menghubungi server.\nKode: " .. tostring(res.code or "nil"))
    return false
  end

  local content = res.content:upper():gsub("%s+","")
  return content == "VALID"
end

-- ==== MAIN ====
local uuid = generateUUID()
local ip = getPublicIP()

--gg.alert("UUID Anda: " .. uuid .. "\nIP: " .. ip)

if validateUUID(uuid, ip) then
  gg.toast("✅ UUID is valid, access granted.")
else
  gg.alert("❌ UUID is invalid, expired, not yet active, or rejected.\n\nAccess denied.\n\nchat admin for activation.\ntelegram @cxsnernero")
  local errorMsg = "❌Your UUID:\n\n" .. uuid
  gg.copyText(errorMsg)
  gg.alert(errorMsg .. "\n\n📋 This text has been copied to the clipboard.")
return
  os.exit()
end