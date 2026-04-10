import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "java.io.File"
import "java.io.FileInputStream"
import "java.security.*"
import "java.util.zip.CRC32"
import "java.math.BigInteger"

local EXPECTED_SHA256 = "18c2052857f66104aeb3501c003df39196cf55b14665ac46c30edc713cefeb24"
local EXPECTED_SHA1 = "148bfa562012af544fb61df3cfa4920ec333d57b"
local EXPECTED_MD5 = "a01d4024ea5201d7cdd36012465b5636"
local EXPECTED_CRC32 = "4e1ecd15"

Batman = luajava.bindClass
Context = Batman("android.content.Context")

function calculateCRC32(filePath)
  local success, result = pcall(function()
    local crc = CRC32.new()
    local fis = FileInputStream(File(filePath))
    local buffer = byte[8192]
    local bytesRead = fis.read(buffer)
    
    while (bytesRead ~= -1) do
      crc.update(buffer, 0, bytesRead)
      bytesRead = fis.read(buffer)
    end
    
    fis.close()
    local checksum = crc.getValue()
    
    return string.format("%08x", checksum)
  end)
  
  if success then
    return result
  else
    return nil
  end
end

function calculateMD5(filePath)
  local success, result = pcall(function()
    local digest = MessageDigest.getInstance("MD5")
    local fis = FileInputStream(File(filePath))
    local buffer = byte[8192]
    local bytesRead = fis.read(buffer)
    
    while (bytesRead ~= -1) do
      digest.update(buffer, 0, bytesRead)
      bytesRead = fis.read(buffer)
    end
    
    fis.close()
    local hashBytes = digest.digest()
    
    local hexString = BigInteger(1, hashBytes).toString(16)
    
    while (#hexString < 32) do
      hexString = "0" .. hexString
    end
    
    return hexString
  end)
  
  if success then
    return result
  else
    return nil
  end
end

function calculateSHA1(filePath)
  local success, result = pcall(function()
    local digest = MessageDigest.getInstance("SHA-1")
    local fis = FileInputStream(File(filePath))
    local buffer = byte[8192]
    local bytesRead = fis.read(buffer)
    
    while (bytesRead ~= -1) do
      digest.update(buffer, 0, bytesRead)
      bytesRead = fis.read(buffer)
    end
    
    fis.close()
    local hashBytes = digest.digest()
    
    local hexString = BigInteger(1, hashBytes).toString(16)
    
    while (#hexString < 40) do
      hexString = "0" .. hexString
    end
    
    return hexString
  end)
  
  if success then
    return result
  else
    return nil
  end
end

function calculateSHA256(filePath)
  local success, result = pcall(function()
    local digest = MessageDigest.getInstance("SHA-256")
    local fis = FileInputStream(File(filePath))
    local buffer = byte[8192]
    local bytesRead = fis.read(buffer)
    
    while (bytesRead ~= -1) do
      digest.update(buffer, 0, bytesRead)
      bytesRead = fis.read(buffer)
    end
    
    fis.close()
    local hashBytes = digest.digest()
    
    local hexString = BigInteger(1, hashBytes).toString(16)
    
    while (#hexString < 64) do
      hexString = "0" .. hexString
    end
    return hexString
  end)
  
  if success then
    return result
  else
    return nil
  end
end

function getAppPath()
  local success, result = pcall(function()
    local packageManager = activity.getPackageManager()
    local packageName = activity.getPackageName()
    local packageInfo = packageManager.getPackageInfo(packageName, 0)
    return packageInfo.applicationInfo.sourceDir
  end)
  
  if success then
    return result
  else
    return nil
  end
end

function verifyAllHashes()
  local appPath = getAppPath()
  if appPath == nil then
    gg.alert("❌ Erro")
    return false
  end
  
  gg.toast("🔍 starting...")
  
  local currentCRC32 = calculateCRC32(appPath)
  local currentMD5 = calculateMD5(appPath)
  local currentSHA1 = calculateSHA1(appPath)
  local currentSHA256 = calculateSHA256(appPath)
  
  local results = {
    CRC32 = {current = currentCRC32, expected = EXPECTED_CRC32, valid = false},
    MD5 = {current = currentMD5, expected = EXPECTED_MD5, valid = false},
    SHA1 = {current = currentSHA1, expected = EXPECTED_SHA1, valid = false},
    SHA256 = {current = currentSHA256, expected = EXPECTED_SHA256, valid = false}
  }
  
  local allValid = true
  for algo, data in pairs(results) do
    if data.current == nil then
      gg.alert("❌ Error " .. algo)
      data.valid = false
      allValid = false
    elseif data.current:lower() == data.expected:lower() then
      gg.alert("✅ " .. algo .. " ok")
      data.valid = true
    else
      gg.alert("⚠️ " .. algo .. " invalid!")
      data.valid = false
      allValid = false
    end
  end
  return allValid
end

function showCurrentHashes()
  local appPath = getAppPath()
  
  if appPath then
    
    return {
      CRC32 = crc32,
      MD5 = md5,
      SHA1 = sha1,
      SHA256 = sha256
    }
  else
    gg.alert("❌ Error")
    return nil
  end
end

function main()

  local isIntegrityValid = verifyAllHashes()
  
  if isIntegrityValid then
    gg.alert("🎉 done..")
    
    while true do
      if gg.isVisible() then 
        while true do os.exit() end
      end
    end
  else
    gg.alert("🚫 gg blocked!")
    os.exit()
    
gg.sleep(3000)
end
end
main()