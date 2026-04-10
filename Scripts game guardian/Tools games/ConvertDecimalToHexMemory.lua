function ValueToHexConverter(value, asDouble, formatType)
  if type(value) ~= "number" then return nil end

  local function packFloat(n)
    local s = n < 0 and 1 or 0
    n = math.abs(n)
    local m, e = math.frexp(n)
    e = e + 126
    m = math.floor((m * 2 - 1) * 0x800000)
    local b4 = (s << 7) | (e >> 1)
    local b3 = ((e & 1) << 7) | ((m >> 16) & 0x7F)
    local b2 = (m >> 8) & 0xFF
    local b1 = m & 0xFF
    return {b1, b2, b3, b4}
  end

  local function packDouble(n)
    local s = n < 0 and 1 or 0
    n = math.abs(n)
    local m, e = math.frexp(n)
    e = e + 1022
    m = math.floor((m * 2 - 1) * 0x10000000000000)
    local high = (s << 11) | (e & 0x7FF)
    local b8 = (high >> 8) & 0xFF
    local b7 = high & 0xFF
    local b6 = (m >> 40) & 0xFF
    local b5 = (m >> 32) & 0xFF
    local b4 = (m >> 24) & 0xFF
    local b3 = (m >> 16) & 0xFF
    local b2 = (m >> 8) & 0xFF
    local b1 = m & 0xFF
    return {b1, b2, b3, b4, b5, b6, b7, b8}
  end

  if value ~= value then
    return formatType == "dword" and "0xFFC00000" or "h00 00 C0 FF"
  elseif value == math.huge then
    return formatType == "dword" and "0x7F800000" or "h00 00 80 7F"
  elseif value == -math.huge then
    return formatType == "dword" and "0xFF800000" or "h00 00 80 FF"
  elseif value == 0 then
    return formatType == "dword" and "0x00000000" or "h00 00 00 00"
  end

  local out = {}
  if asDouble then
    out = packDouble(value)
  else
    out = packFloat(value)
  end

  if formatType == "dword" then
    return string.format("0x%02X%02X%02X%02X", out[4], out[3], out[2], out[1])
  elseif formatType == "0x" then
    local r = {}
    for i = 1, #out do
      r[#r+1] = string.format("0x%02X", out[i])
    end
    return table.concat(r, " ")
  else
    local r = {}
    for i = 1, #out do
      r[#r+1] = string.format("h%02X", out[i])
    end
    return table.concat(r, " ")
  end
end

local input = gg.prompt(
  {"Numeric value to convert", "Use double? (true/false)", "Format (dword, 0x or hx)"},
  {"3.14", "false", "dword"},
  {"number", "text", "text"}
)

if input == nil then
  gg.alert("Canceled.")
  return
end

local value = tonumber(input[1])
local isDouble = input[2] == "true"
local format = input[3]

local result = ValueToHexConverter(value, isDouble, format)

if result then
  gg.alert("Result: " .. result)
else
  gg.alert("Failed to convert value.")
end