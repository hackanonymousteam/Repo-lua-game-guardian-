
local crc32_table = {}

local function create_crc32_table()
    local polynomial = 0xEDB88320
    for i = 0, 255 do
        local crc = i
        for j = 8, 1, -1 do
            if (crc % 2) == 1 then
                crc = (crc // 2) ~ polynomial
            else
                crc = crc // 2
            end
        end
        crc32_table[i] = crc
    end
end

create_crc32_table()

local function crc32(data)
    local crc = 0xFFFFFFFF
    for i = 1, #data do
        local byte = string.byte(data, i)
        local index = bit32.bxor(byte, bit32.band(crc, 0xFF))
        crc = bit32.bxor(bit32.rshift(crc, 8), crc32_table[index])
    end
    return bit32.bnot(crc)
end

local function calculate_crc32(file_path)
    local file = io.open(file_path, "rb")
    if not file then
        error("error open file: " .. file_path)
    end

    local data = file:read("*all")
    file:close()

    return crc32(data)
end

local file_path = gg.getFile()

g = {}
g.last = "/sdcard/"
g.info = nil
g.config = gg.EXT_CACHE_DIR .. "/" .. gg.getFile():match("[^/]+$") .. "cfg"
g.data = loadfile(g.config)
if g.data ~= nil then
  g.info = g.data()
  g.data = nil
end
if g.info == nil then
  g.info = { g.last, g.last:gsub("/[^/]+$", "") }
end

while true do
  g.info = gg.prompt({
    'Select file to get CRC32:'
  
  }, g.info, {
    'file' -- 1
  })

  if g.info == nil then
    return
  end

  local myFile = g.info[1]
  gg.saveVariable(g.info, g.config)
  g.last = myFile
  
  local crc32_value = calculate_crc32(myFile)
gg.alert(string.format("CRC32: %08X", crc32_value))
os.exit()
end
