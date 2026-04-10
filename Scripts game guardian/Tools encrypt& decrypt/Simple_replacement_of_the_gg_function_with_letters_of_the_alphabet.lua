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
    '📂 Select file :', -- 1
    '📂 Select folder :' -- 2
  }, g.info, {
    'file', -- 1
    'path' -- 2
  })
  gg.saveVariable(g.info, g.config)
  g.last = g.info[1]

  if loadfile(g.last) == nil then
    gg.alert("⚠️ Script not Found! ⚠️")
    return
  else
    g.out = g.last:match("[^/]+$") 
    g.out = g.out:gsub("%.lua$", ".Batman") 
    g.out = g.info[2] .. "/" .. g.out .. ".lua" 
  end

  local file = io.open(g.last, "r")
  local DATA = file:read('*a')
  file:close()

  local symbol_map = {}
  local used_symbols = {}

  local tabel = {
    "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T"
  }

  local function get_unique_symbol()
    local symbol
    repeat
      local ind = math.random(1, #tabel)
      symbol = tabel[ind]
    until not used_symbols[symbol]
    used_symbols[symbol] = true
    return symbol
  end

  DATA = DATA:gsub("gg%.(%a+)", function(x)
   
    if x == "REGION" or x == "TYPE" then
      return "gg." .. x
    end
    
    local get_nnm = x
    
    if not symbol_map[get_nnm] then
      
      local symbol = get_unique_symbol()
      symbol_map[get_nnm] = symbol
    end
    
    return symbol_map[get_nnm]
  end)

  local outputFile = io.open(g.out, "w")  

  for func, symbol in pairs(symbol_map) do
    outputFile:write(symbol .. " = gg." .. func .. "\n")  
  end

  outputFile:write(DATA)
  outputFile:close()
  
  local ClU = '📂 File Saved To: ' .. g.out .. '\n'
  gg.alert(ClU)
  print("\n▬▬▬▬▬▬▬▬▬▬▬▬▬\n📂 File Saved To :" .. g.out .. "\n▬▬▬▬▬▬▬▬▬▬▬▬▬")
  
  return
end