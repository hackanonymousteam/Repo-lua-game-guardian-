function SHA256(str)
  import "java.security.MessageDigest"
  import "android.text.TextUtils"
  import "java.lang.StringBuffer"
  
  local sb = StringBuffer()
  local sha256 = MessageDigest.getInstance("SHA-256")
  local bytes = sha256.digest(String(str).getBytes("UTF-8"))
  local by = luajava.astable(bytes)
  
  for k, n in ipairs(by) do
    import "java.lang.Integer"
    local temp = Integer.toHexString(n & 255)
    
    if #temp == 1 then
      sb.append("0")
    end
    sb.append(temp)
  end
  
  return sb.toString()
end

local hash = SHA256("gg.alert('Batman the best')")
print("SHA-256: " .. hash)


function Hash(str, algorithm)
  import "java.security.MessageDigest"
  import "android.text.TextUtils"
  import "java.lang.StringBuffer"
  
  local algorithms = {
    MD5 = "MD5",
    SHA1 = "SHA-1",
    SHA256 = "SHA-256",
    SHA384 = "SHA-384",
    SHA512 = "SHA-512"
  }
  
  local algo = algorithms[algorithm] or "SHA-256"
  
  local sb = StringBuffer()
  local digest = MessageDigest.getInstance(algo)
  local bytes = digest.digest(String(str).getBytes("UTF-8"))
  local by = luajava.astable(bytes)
  
  for k, n in ipairs(by) do
    import "java.lang.Integer"
    local temp = Integer.toHexString(n & 255)
    
    if #temp == 1 then
      sb.append("0")
    end
    sb.append(temp)
  end
  
  return {
    hash = sb.toString(),
    algorithm = algo,
    length = #by
  }
end

print("MD5: " .. Hash("gg.alert('Batman the best')", "MD5").hash)
print("SHA1: " .. Hash("gg.alert('Batman the best')", "SHA1").hash)
print("SHA256: " .. Hash("gg.alert('Batman the best')", "SHA256").hash)
print("SHA512: " .. Hash("gg.alert('Batman the best')", "SHA512").hash)

function HashBase64(str, algorithm)
  import "java.security.MessageDigest"
  import "android.util.Base64"
  
  local algo = algorithm or "SHA-256"
  local digest = MessageDigest.getInstance(algo)
  local bytes = digest.digest(String(str).getBytes("UTF-8"))
  
  
  local base64Hash = Base64.encodeToString(bytes, Base64.NO_WRAP)
  
  return base64Hash
end

print("SHA-256 Base64: " .. HashBase64("gg.alert('Batman the best')"))


function ComputeHash(str, options)
  import "java.security.MessageDigest"
  import "android.text.TextUtils"
  import "java.lang.StringBuffer"
  import "android.util.Base64"
  
  local config = {
    algorithm = "SHA-256",
    output = "hex", -- "hex" or "base64"
    encoding = "UTF-8"
  }
  
  if options then
    for k, v in pairs(options) do
      config[k] = v
    end
  end
  
  local digest = MessageDigest.getInstance(config.algorithm)
  local bytes = digest.digest(String(str).getBytes(config.encoding))
  
  if config.output == "base64" then
    return Base64.encodeToString(bytes, Base64.NO_WRAP)
  else
   
    local sb = StringBuffer()
    local by = luajava.astable(bytes)
    
    for k, n in ipairs(by) do
      import "java.lang.Integer"
      local temp = Integer.toHexString(n & 255)
      
      if #temp == 1 then
        sb.append("0")
      end
      sb.append(temp)
    end
    
    return sb.toString()
  end
end

print("SHA-256 (hex): " .. ComputeHash("gg.alert('Batman the best')"))
print("SHA-512 (base64): " .. ComputeHash("gg.alert('Batman the best')", {
  algorithm = "SHA-512",
  output = "base64"
}))


function PBKDF2(password, salt, iterations)
  import "javax.crypto.SecretKeyFactory"
  import "javax.crypto.spec.PBEKeySpec"
  import "java.lang.StringBuffer"
  
  local factory = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256")
  local spec = PBEKeySpec(
    String(password).toCharArray(),
    String(salt).getBytes("UTF-8"),
    iterations or 10000,
    256
  )
  
  local key = factory.generateSecret(spec)
  local bytes = key.getEncoded()
  local by = luajava.astable(bytes)
  local sb = StringBuffer()
  
  for k, n in ipairs(by) do
    import "java.lang.Integer"
    local temp = Integer.toHexString(n & 255)
    
    if #temp == 1 then
      sb.append("0")
    end
    sb.append(temp)
  end
  
  return sb.toString()
end

print("PBKDF2: " .. PBKDF2("minha_senha", "salt_aleatorio", 10000))


function HMAC(str, key, algorithm)
  import "javax.crypto.Mac"
  import "javax.crypto.spec.SecretKeySpec"
  import "java.lang.StringBuffer"
  
  local algo = algorithm or "HmacSHA256"
  local secretKey = SecretKeySpec(String(key).getBytes("UTF-8"), algo)
  local mac = Mac.getInstance(algo)
  mac.init(secretKey)
  
  local bytes = mac.doFinal(String(str).getBytes("UTF-8"))
  local by = luajava.astable(bytes)
  local sb = StringBuffer()
  
  for k, n in ipairs(by) do
    import "java.lang.Integer"
    local temp = Integer.toHexString(n & 255)
    
    if #temp == 1 then
      sb.append("0")
    end
    sb.append(temp)
  end
  
  return sb.toString()
end

local chave = "minha_chave_secreta"
print("HMAC-SHA256: " .. HMAC("gg.alert('Batman the best')", chave, "HmacSHA256"))
print("HMAC-SHA1: " .. HMAC("gg.alert('Batman the best')", chave, "HmacSHA1"))
print("HMAC-MD5: " .. HMAC("gg.alert('Batman the best')", chave, "HmacMD5"))

function HashWithProvider(str, algorithm)
  import "java.security.MessageDigest"
  import "java.security.Security"
  import "org.bouncycastle.jce.provider.BouncyCastleProvider"
  import "java.lang.StringBuffer"
  
    local success, _ = pcall(function()
    Security.addProvider(BouncyCastleProvider())
  end)
  
  local sb = StringBuffer()
  local digest = MessageDigest.getInstance(algorithm)
  local bytes = digest.digest(String(str).getBytes("UTF-8"))
  local by = luajava.astable(bytes)
  
  for k, n in ipairs(by) do
    import "java.lang.Integer"
    local temp = Integer.toHexString(n & 255)
    
    if #temp == 1 then
      sb.append("0")
    end
    sb.append(temp)
  end
  
  return sb.toString()
end

local bcAlgorithms = {
  "GOST3411",        -- Padrão russo
  "Tiger",           -- Algoritmo antigo
  "Whirlpool",       -- Padrão ISO
  "RIPEMD128",       -- Família RIPEMD
  "RIPEMD160",       -- Usado no Bitcoin
  "RIPEMD256",       -- Variante RIPEMD
  "RIPEMD320",       -- Variante RIPEMD
}



function HashAdvanced(str, algorithm)
  import "java.security.MessageDigest"
  import "java.lang.StringBuffer"
  import "java.security.Security"
  
  local sb = StringBuffer()
  
  local success, digest = pcall(function()
    return MessageDigest.getInstance(algorithm)
  end)
  
  if not success then
    return nil, "no suport: " .. algorithm
  end
  
  local bytes = digest.digest(String(str).getBytes("UTF-8"))
  local by = luajava.astable(bytes)
  
  for k, n in ipairs(by) do
    import "java.lang.Integer"
    local temp = Integer.toHexString(n & 255)
    
    if #temp == 1 then
      sb.append("0")
    end
    sb.append(temp)
  end
  
  return sb.toString()
end

local algorithms = {
 "MD5",          -- Conhecido, inseguro
  "SHA-1",        -- Básico
  "SHA-224",      -- Variante SHA-2
  "SHA-256",      -- SHA-2 256-bit
  "SHA-384",      -- SHA-2 384-bit
  "SHA-512",      -- SHA-2 512-bit

}

for _, algo in ipairs(algorithms) do
  local hash, err = HashAdvanced("teste", algo)
  if hash then
    print(string.format("%-15s: %s...", algo, string.sub(hash, 1, 20)))
  else
    print(algo .. " não disponível")
  end
  
end

