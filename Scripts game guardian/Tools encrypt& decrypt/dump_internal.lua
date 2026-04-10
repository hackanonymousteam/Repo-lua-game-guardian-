g = {}
caminho_arquivo = "/sdcard/"
g.info = nil
g.config = gg.EXT_CACHE_DIR .. "/" .. gg.getFile():match("[^/]+$") .. "cfg"
g.data = loadfile(g.config)
if g.data ~= nil then
  g.info = g.data()
  g.data = nil
end
if g.info == nil then
  g.info = { caminho_arquivo, caminho_arquivo:gsub("/[^/]+$", "") }
end

while true do
  g.info = gg.prompt({
    'Select script lua for dump Lasm :', -- 1
    'Select folder to save dump :' -- 2
  }, g.info, {
    'file', -- 1
    'path' -- 2
  })

  gg.saveVariable(g.info, g.config)
  caminho_arquivo = g.info[1]
  if loadfile(caminho_arquivo) == nil then
    gg.alert(" Script not Found! ")
  else
    g.out = caminho_arquivo:match("[^/]+$")
    g.out = g.out:gsub(".lua", ".dump")
    g.out = g.info[2] .. "/" .. g.out .. ".lua"
  end

  local file = io.open(caminho_arquivo, "r")
  local DATA = file:read('*a')
  file:close()
    
  gg.internal2(load(DATA), g.out)
 
   gg.alert(" Script dumped Lasm ")
  return
  end