function manage() 
var = gg.choice({
"Edit #var file (list results)",
"Extract info #var file (list results)",
"exit",
},0,"")
if var == 1 then varv1() end
if var == 2 then varv2() end
if var == 3 then  os.exit() end

BATMAN = -1
end

function varv1() 
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
      'Select var file for edit:', -- 1
    }, g.info, {
      'file', -- 1
    })

    if not g.info or not g.info[1] then
      gg.alert("Invalid input. Please try again.")
      return
    end

    gg.saveVariable(g.info, g.config)
    caminho_arquivo = g.info[1]
    local file = io.open(caminho_arquivo, "r")
    if not file then
      gg.alert("Var list not found!")
      return
    end

    g.out = caminho_arquivo:match("[^/]+$")
    g.out = g.out:gsub(".txt", ".#var")

    function readFile(caminho_arquivo)
      local file = io.open(caminho_arquivo, "r")
      if not file then
        print("ERROR OPEN FILE: " .. caminho_arquivo)
      end
      local content = file:read("*all")
      file:close()
      return content
    end

    function writeFile(caminho_arquivo, content)
      local file = io.open(caminho_arquivo, "w")
      if not file then
        print("ERROR OPEN FILE: " .. caminho_arquivo)
      end
      file:write(content)
      file:close()
    end

    function replaceValueInFile(caminho_arquivo)
      local function processLine(line)
        newValue2 = "10"
        local lineWithSecondValueReplaced = line:gsub(
          "^(.-|.-|)([^|]*)",
          function(prefix, _)
            return prefix .. newValue2
          end
        )
        return lineWithSecondValueReplaced
      end

      local content = {}
      local file = io.open(caminho_arquivo, "r")
      if not file then
        print("error : " .. caminho_arquivo)
      end

      for line in file:lines() do
        local processedLine = processLine(line)
        table.insert(content, processedLine)
      end
      file:close()

      file = io.open(caminho_arquivo, "w")
      if not file then
        print("error  " .. caminho_arquivo)
      end

      for _, line in ipairs(content) do
        file:write(line .. "\n")
      end
      file:close()
    end

    local function replaceValueInFile2(caminho_arquivo, newValue)
      local function processLine(line)
        local lineWithThirdValueReplaced = line:gsub(
          "^(.-|.-|.-|)([^|]*)",
          function(prefix, _)
            return prefix .. newValue
          end
        )
        return lineWithThirdValueReplaced
      end

      local content = {}
      local file = io.open(caminho_arquivo, "r")
      if not file then
        print("error : " .. caminho_arquivo)
      end

      for line in file:lines() do
        local processedLine = processLine(line)
        table.insert(content, processedLine)
      end
      file:close()

      file = io.open(caminho_arquivo, "w")
      if not file then
        print("error  " .. caminho_arquivo)
      end

      for _, line in ipairs(content) do
        file:write(line .. "\n")
      end
      file:close()
    end

    function floatToHexReversed(number)
      local packed = string.pack("f", number)
      local hex = ""
      for i = #packed, 1, -1 do
        hex = hex .. string.format("%02x", packed:byte(i))
      end
      return hex
    end

    function value1()
      local input = gg.prompt({"insert number float"}, {""}, {"number"})

      if input and input[1] then
        local floatNumber = tonumber(input[1])
        if floatNumber then
          local hexReversed = floatToHexReversed(floatNumber)
          replaceValueInFile(caminho_arquivo)
          replaceValueInFile2(caminho_arquivo, hexReversed)

          gg.alert("success")
          gg.alert("new var file save"..caminho_arquivo)
          gg.setVisible(true)
          os.exit()
        else
          gg.alert("please insert a valid float number")
        end
      else
        gg.alert("please insert number float")
      end
    end

    value1()
    return
  end
end



function varv2()

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
    'Select var file for inspect :', -- 1
  }, g.info, {
    'file', -- 1
  })

  if not g.info or not g.info[1] then
    gg.alert("Invalid input. Please try again.")
    return
  end

  gg.saveVariable(g.info, g.config)
  caminho_arquivo = g.info[1]
  local file = io.open(caminho_arquivo, "r")
  if not file then
    gg.alert("Var list not found!")
    return
  end

  g.out = caminho_arquivo:match("[^/]+$")
  g.out = g.out:gsub(".txt", ".#var")

  function readFile(caminho_arquivo)
    local file = io.open(caminho_arquivo, "r")
    if not file then
      print("error open file: " .. caminho_arquivo)
    end
    local content = file:read("*all")
    file:close()
    return content
  end

  function writeFile(caminho_arquivo, content)
    local file = io.open(caminho_arquivo, "w")
    if not file then
      print("error open file: " .. caminho_arquivo)
    end
    file:write(content)
    file:close()
  end

  function processLines(content)
    for line in content:gmatch("[^\r\n]+") do
      local startText = line:match("arm/(.-)|")
      local endText = line:match(".*|(.-)$")
      if startText then
     
        print(startText.." Offset 0x" .. endText)

      end
      if endText then

      end
    end
  end

  local content = readFile(caminho_arquivo)
  processLines(content)
  gg.setVisible(true)
        os.exit()
  return
end
end


while(true)do if gg.isVisible(true)then BATMAN = 1 gg.setVisible(false)end
if BATMAN == 1 then manage()end
end