
gg.alert([[

📌 Armeabi-v7a (32-Bit) 📌
 
by Batman Games🍿 
My telegram @batmangamesS 
]])

function values() 
enc = gg.choice({
"INT TO HEX for mods unity 32 bit",
"FLOAT CONVERSION for mods unity 32 bit",
"OTHERS VALUES",
"exit",
},0,"")
if enc == 1 then value1() end
if enc == 2 then value2() end
if enc == 3 then others() end
if enc == 4 then os.exit() end

BATMAN = -1
end

function intToHex(num)
    local hex = string.format("%02X", num)
    return hex
end

function generateSequence(num)
    num = tonumber(num)  
    if not num then
        return "insert value int valid"
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
        return "error"
    end
end

function value1()
local input = gg.prompt({"insert number int"}, {""}, {"number"})

if input and input[1] then
    local sequence = generateSequence(input[1])
  print(sequence)  
  gg.alert(sequence)  
    gg.setVisible(true)
    os.exit()
else
    gg.alert("please insert number int")
end
end

function value2()
local input = gg.prompt({"insert value float"}, {""}, {"text"})


if input and input[1] then
    local result = generateValue(input[1])
    gg.alert(result)  
else
    gg.alert("please insert value float")
end
end

function floatToHex(floatValue)
    
    if type(floatValue) ~= 'number' then
        gg.alert('invalid number.')
        return
    end
    
      if floatValue < 1 or floatValue > 2000 then
        gg.alert('please value float  1 and 2000.')
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
print('\n' .. thirdHex .. ' ' .. replacedLastHex .. ' ' .. additionalHex.. ' ' .. rest)
    gg.alert('\n' .. thirdHex .. ' ' .. replacedLastHex .. ' ' .. additionalHex.. ' ' .. rest)
      gg.setVisible(true)
    os.exit()
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

   function  value2()
    local values = gg.prompt({'Insert value float'}, nil, {'float'})
    if not values then
        return
    end

    local floatValue = tonumber(values[1])

        floatToHex(floatValue)
    
end

function others()
menucustom = gg.multiChoice({

"BOOLEAN TRUE",
"BOOLEAN FALSE",
"NOP CODE",
"↩️ back"}, nil, 
"♦️by Batman Games♦️")

if menucustom == nil then else
if menucustom[1] ==  true then tru() end
if menucustom[2] ==  true then fal() end
if menucustom[3] ==  true then nop() end
if menucustom[4] == true then values () end end end

     function tru()
      print("01 00 A0 E3 1E FF 2F E1")
    gg.alert("01 00 A0 E3 1E FF 2F E1")
    gg.setVisible(true)
    os.exit()
    end 
    
     function fal()
      print("00 00 A0 E3 1E FF 2F E1")
    gg.alert("00 00 A0 E3 1E FF 2F E1")
    gg.setVisible(true)
    os.exit()
    end  
    
    function nop()
      print("00 F0 20 E3 1E FF 2F E1")
    gg.alert("00 F0 20 E3 1E FF 2F E1")
    gg.setVisible(true)
    os.exit()
    end  
   
  --__________________________________________________
  
while(true)do if gg.isVisible(true)then BATMAN = 1 gg.setVisible(false)end
if BATMAN == 1 then values()end
end