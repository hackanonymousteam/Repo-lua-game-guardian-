
local n, startAddress, endAddress = nil, 0, 0

local function name(lib)
	if n == lib then
		return startAddress, endAddress end
	local ranges = gg.getRangesList(lib)
	for i, v in ipairs(ranges) do
		if v.state == "Xa" then
			startAddress = v.start
			endAddress = ranges[#ranges]['end']
			break
		end end
		
	return startAddress, endAddress end
	
local function setHex(libname, offset, hex)
	name(libname)
	local t, total = {}, 0
	for h in string.gmatch(hex, "%S%S") do
	    table.insert(t, {
	        address = startAddress + offset + total,
	        flags = gg.TYPE_BYTE,
	        value = h .. "r"
	    })
	    total = total + 1
	end
	local res = gg.setValues(t)
	if type(res) ~= 'string' then
		return true
	else
		gg.alert(res)
		return false
	end end
	
function floatToHexReversed(num)
    local packed = string.pack("<f", num)  
    local hex = packed:gsub(".", function(c)
        return string.format("%02X", string.byte(c))
    end)
    return hex
end

function colorm()

    local sph = gg.prompt({
"Select speed [0;10]","exit"
}, {0}, {"number","checkbox"})

  if sph == nil then
    return
  else
    if sph[1] == "0" then
    gg.toast('value 0')
    setHex("libil2cpp.so", 0x4, floatToHexReversed(0.0))
    end
    
    if sph[1] == "1" then
      gg.toast("value 1")
      setHex("libil2cpp.so", 0x4, floatToHexReversed(1.0))
    end
    
    if sph[1] == "2" then
    setHex("libil2cpp.so", 0x4, floatToHexReversed(2.0))
      gg.toast("value 2")
    end
    
    if sph[1] == "3" then
    setHex("libil2cpp.so", 0x4, floatToHexReversed(3.0))
      gg.toast("value 3")
    end
    
    if sph[1] == "4" then
    setHex("libil2cpp.so", 0x4, floatToHexReversed(4.0))
      gg.toast("value 4")
    end
    
    if sph[1] == "5" then
    setHex("libil2cpp.so", 0x4, floatToHexReversed(5.0))
      gg.toast("value 5")
    end
    
    if sph[1] == "6" then
    setHex("libil2cpp.so", 0x4, floatToHexReversed(6.0))
      gg.toast("value 6")
    end
    
    if sph[1] == "7" then
    setHex("libil2cpp.so", 0x4, floatToHexReversed(7.0))
      gg.toast("value 7")
      end
      
      if sph[1] == "8" then
      setHex("libil2cpp.so", 0x4, floatToHexReversed(8.0))
      gg.toast("value 8")
    end
    
    if sph[1] == "9" then
    setHex("libil2cpp.so", 0x4, floatToHexReversed(9.0))
      gg.toast("value 9")
    end
    
    if sph[1] == "10" then
    setHex("libil2cpp.so", 0x4, floatToHexReversed(10.0))
      gg.toast("value 10")
    end
    
    if sph[2] then
 os.exit()
else 
end

end
end
    
while true do
    if gg.isVisible(true) then
        gg.setVisible(false)
        colorm()
    end
end