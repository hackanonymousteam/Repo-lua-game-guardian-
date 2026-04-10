g = {}
valuer = "0x87caa4"
g.info = nil
g.config = gg.EXT_CACHE_DIR .. "/" .. gg.getFile():match("[^/]+$") .. "cfg"
g.data = loadfile(g.config)
if g.data ~= nil then
  g.info = g.data()
  g.data = nil
end
if g.info == nil then
  g.info = {
    valuer,
    valuer:gsub("/[^/]+$", "")
  }
end

function floatToBits(floatValue)
  local sign = 0
  if floatValue < 0 then
    sign = 0x80000000
    floatValue = -floatValue
  end

  local mantissa, exponent = math.frexp(floatValue)
  mantissa = (mantissa * 2 - 1) * math.ldexp(0.5, 24)
  exponent = (exponent + 126) * 0x00800000
  return sign + exponent + math.floor(mantissa + 0.5)
end

function floatToHex(floatValue)
  if type(floatValue) ~= 'number' then
    gg.alert('invalid.')
    return
  end

  if floatValue < 1 or floatValue > 2000 then
    gg.alert('value float  1 and 2000.')
    return
  end

  local hexValue = string.format('%08X', floatToBits(floatValue))
  local thirdHex = hexValue:sub(3, 4)
  local lastHex = hexValue:sub(1, 2)
  local lastDigit = tonumber(lastHex, 16) % 16
  local replacedLastHex = string.format('%02X', lastDigit)

  local rest = 'E3 1E FF 2F E1'
  local additionalHex
  if floatValue >= 10 and floatValue <= 2000 then
    additionalHex = '44'
  elseif floatValue > 1 and floatValue < 2 then
    additionalHex = '43'
  else
    additionalHex = '00'
  end
  
 TEST= thirdHex .. replacedLastHex .. additionalHex .. rest

function libname(lib,batman,games) local info = gg.getTargetInfo() localpack = info.nativeLibraryDir local t = gg.getRangesList(localpack.."/lib"..lib..".so") for _, __ in pairs(t) do local t = gg.getValues({{address = __.start, flags = gg.TYPE_DWORD}, {address = __.start + 0x12, flags = gg.TYPE_WORD}}) if t[1].value == 0x464C457F then batman = __["start"] + batman end assert(batman ~= nil,"[rwmem]: error, provided address is nil.") _rw = {} if type(games) == "number" then _ = "" for _ = 1, games do _rw[_] = {address = (batman - 1) + _, flags = gg.TYPE_BYTE} end for v, __ in ipairs(gg.getValues(_rw)) do _ = _ .. string.format("%02X", __.value & 0xFF) end return _ end Byte = {} games:gsub("..", function(x)  Byte[#Byte + 1] = x _rw[#Byte] = {address = (batman - 1) + #Byte, flags = gg.TYPE_BYTE, value = x .. "h"}  end) gg.setValues(_rw) end  end 

libname("il2cpp", valuer, TEST)
 

  gg.toast("active")


  gg.setVisible(true)
 os.exit()
end

function intToHex(num)
  local hex = string.format("%02X", num)
  return hex
end

function generateSequence(num)
  num = tonumber(num)
  if not num then
    return "invalid."
  end

  if num <= 255 then
    return string.format("%02X 00 A0 E3 1E FF 2F E1", num)
  elseif num <= 65535 then
    local lowByte = num % 256
    local highByte = math.floor(num / 256)
    return string.format("%02X %02X 00 E3 1E FF 2F E1", lowByte, highByte)
  elseif num <= 16777215 then
    local byte1 = num % 256
    local byte2 = math.floor((num % 65536) / 256)
    local byte3 = math.floor(num / 65536)
    return string.format("%02X %02X %02X E3 1E FF 2F E1", byte1, byte2, byte3)
  else
    return "Erro"
  end
end

while true do
  local log = gg.prompt({
    "❦ insert offset here (example 0x87caa4)",
    "❦ hex Float",
    "❦ hex int"
    
  }, {0}, {"text", "checkbox", "checkbox"})

  if log == nil then
    return
  end

  valuer = log[1]

  if valuer == nil or valuer == "" then
    gg.alert("⚠️ empty ⚠️")
    return
  end

  g.info[1] = valuer
  gg.saveVariable(g.info, g.config)

    if log[2] then
    local sph = gg.prompt({
        "\n\nselect value float",
        
      },
      {0}, 
      {"number"} 
    )
    
    if sph == nil then
      return
    else
      local sphr = sph[1]
      
    local floatValue = tonumber(sphr)
      floatToHex(floatValue)
    end
  end
  end

  if log[3] then
    local bat = gg.prompt({
        "\n\nselect value float [0;19]",
        
      },
      {0}, 
    {"number"} 
  )
  
  if bat == nil then
    return
  else
    local batr = "100"  
    
        if bat[1] == "0" then
      batr = "0"
    elseif bat[1] == "1" then
      batr = "1"
    elseif bat[1] == "2" then
      batr = "2"
    elseif bat[1] == "3" then
      batr = "3"
    elseif bat[1] == "4" then
      batr = "4"
    elseif bat[1] == "5" then
      batr = "5"
    elseif bat[1] == "6" then
      batr = "6"
    elseif bat[1] == "7" then
      batr = "7"
    elseif bat[1] == "8" then
      batr = "8"
    elseif bat[1] == "9" then
      batr = "9"
    elseif bat[1] == "10" then
      batr = "10"
    elseif bat[1] == "11" then
      batr = "11"
    elseif bat[1] == "12" then
      batr = "12"
    elseif bat[1] == "13" then
      batr = "13"
    elseif bat[1] == "14" then
      batr = "14"
    elseif bat[1] == "15" then
      batr = "15"
    elseif bat[1] == "16" then
      batr = "16"
    elseif bat[1] == "17" then
      batr = "17"
    elseif bat[1] == "18" then
      batr = "18"
    elseif bat[1] == "19" then
      batr = "19"
    end
    
    local intvalue = tonumber(batr[1])
    local sequence = generateSequence(intvalue)

  end
  end