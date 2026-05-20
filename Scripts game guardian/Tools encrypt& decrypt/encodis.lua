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

local varCounter = 0
local function getVar()
    varCounter = varCounter + 1
    return "v" .. varCounter
end

local function encodeToEscapes(str)
    local result = {}
    for i = 1, #str do
        local byte = string.byte(str, i)
        result[#result + 1] = string.format("\\%03d", byte)
    end
    return table.concat(result)
end

local function generateLoader(originalCode)
    varCounter = 0
    
    local partSize = math.ceil(#originalCode / 4)
    local encodedParts = {}
    
    for i = 0, 3 do
        local start = i * partSize + 1
        local finish = math.min((i + 1) * partSize, #originalCode)
        local part = originalCode:sub(start, finish)
        encodedParts[i + 1] = encodeToEscapes(part)
    end
    
    local fullEncoded = encodedParts[1] .. encodedParts[2] .. encodedParts[3] .. encodedParts[4]
    
    local lines = {}
    
    local v1 = getVar()
    local v2 = getVar()
    local v3 = getVar()
    local v4 = getVar()
    local v5 = getVar()
    
    lines[#lines + 1] = "local " .. v1 .. " = function(" .. v2 .. ", " .. v3 .. ", " .. v4 .. ", " .. v5 .. ")"
    
    local v6 = getVar()
    local v7 = getVar()
    local v8 = getVar()
    
    lines[#lines + 1] = "  local " .. v6 .. " = " .. v2
    lines[#lines + 1] = "  local " .. v7 .. " = " .. v3
    lines[#lines + 1] = "  local " .. v8 .. " = " .. v4
    
    local v9 = getVar()
    local v10 = getVar()
    local v11 = getVar()
    local v12 = getVar()
    local v13 = getVar()
    local v14 = getVar()
    local v15 = getVar()
    local v16 = getVar()
    
    lines[#lines + 1] = "  local function " .. v9 .. "(" .. v10 .. ")"
    lines[#lines + 1] = "    local " .. v11 .. " = \"\""
    lines[#lines + 1] = "    local " .. v12 .. " = 1"
    lines[#lines + 1] = ""
    lines[#lines + 1] = "    while " .. v12 .. " <= #" .. v10 .. " do"
    lines[#lines + 1] = "      local " .. v13 .. " = " .. v6 .. ".sub(" .. v10 .. ", " .. v12 .. ", " .. v12 .. ")"
    lines[#lines + 1] = ""
    lines[#lines + 1] = "      if " .. v13 .. " == \"\\\\\" then"
    lines[#lines + 1] = "        local " .. v14 .. " = \"\""
    lines[#lines + 1] = "        local " .. v15 .. " = " .. v12 .. " + 1"
    lines[#lines + 1] = ""
    lines[#lines + 1] = "        while " .. v15 .. " <= #" .. v10 .. " do"
    lines[#lines + 1] = "          local " .. v16 .. " = " .. v6 .. ".sub(" .. v10 .. ", " .. v15 .. ", " .. v15 .. ")"
    lines[#lines + 1] = ""
    lines[#lines + 1] = "          if " .. v16 .. ":match(\"%d\") then"
    lines[#lines + 1] = "            " .. v14 .. " = " .. v14 .. " .. " .. v16
    lines[#lines + 1] = "            " .. v15 .. " = " .. v15 .. " + 1"
    lines[#lines + 1] = "          else"
    lines[#lines + 1] = "            break"
    lines[#lines + 1] = "          end"
    lines[#lines + 1] = "        end"
    lines[#lines + 1] = ""
    lines[#lines + 1] = "        if " .. v14 .. " ~= \"\" then"
    lines[#lines + 1] = "          " .. v11 .. " = " .. v11 .. " .. " .. v7 .. "(" .. v8 .. "(" .. v14 .. "))"
    lines[#lines + 1] = "        end"
    lines[#lines + 1] = ""
    lines[#lines + 1] = "        " .. v12 .. " = " .. v15
    lines[#lines + 1] = "      else"
    lines[#lines + 1] = "        " .. v11 .. " = " .. v11 .. " .. " .. v13
    lines[#lines + 1] = "        " .. v12 .. " = " .. v12 .. " + 1"
    lines[#lines + 1] = "      end"
    lines[#lines + 1] = "    end"
    lines[#lines + 1] = ""
    lines[#lines + 1] = "    return " .. v11
    lines[#lines + 1] = "  end"
    
    for i = 1, 15 do
        local j1 = getVar()
        local j2 = getVar()
        local j3 = getVar()
        local j4 = getVar()
        local j5 = getVar()
        local j6 = getVar()
        local j7 = getVar()
        local j8 = getVar()
        
        lines[#lines + 1] = "  do"
        lines[#lines + 1] = "    local " .. j1 .. " = " .. math.random(100, 999)
        lines[#lines + 1] = "    local " .. j2 .. " = \"\""
        
        if i % 3 == 0 then
            lines[#lines + 1] = "    local " .. j3 .. " = {}"
            lines[#lines + 1] = "    " .. j3 .. "[" .. math.random(1, 5) .. "] = \"" .. string.char(65 + math.random(0, 25)) .. "\""
        end
        
        lines[#lines + 1] = "    if " .. j1 .. " > 0 then"
        lines[#lines + 1] = "      local " .. j4 .. " = " .. math.random(1, 50)
        lines[#lines + 1] = "      while " .. j4 .. " > 0 do"
        lines[#lines + 1] = "        " .. j2 .. " = \"" .. string.char(65 + math.random(0, 25)) .. "\""
        lines[#lines + 1] = "        " .. j4 .. " = " .. j4 .. " - 1"
        lines[#lines + 1] = "        if " .. j4 .. " == " .. math.random(1, 10) .. " then"
        lines[#lines + 1] = "          local " .. j5 .. " = #" .. j2
        lines[#lines + 1] = "          local " .. j6 .. " = " .. j5 .. " + " .. math.random(1, 10)
        
        if i % 2 == 0 then
            lines[#lines + 1] = "          local " .. j7 .. " = " .. j6 .. " * 2"
            lines[#lines + 1] = "          local " .. j8 .. " = " .. j7 .. " / 2"
        end
        
        lines[#lines + 1] = "          break"
        lines[#lines + 1] = "        end"
        lines[#lines + 1] = "      end"
        lines[#lines + 1] = "    end"
        lines[#lines + 1] = "  end"
    end
    
    local e1 = getVar()
    local e2 = getVar()
    local e3 = getVar()
    local e4 = getVar()
    
    lines[#lines + 1] = "  local " .. e1 .. " = \"" .. fullEncoded .. "\""
    lines[#lines + 1] = "  local " .. e2 .. " = " .. v9 .. "(" .. e1 .. ")"
    lines[#lines + 1] = "  local " .. e3 .. " = load or loadstring"
    lines[#lines + 1] = "  if " .. e3 .. " then"
    lines[#lines + 1] = "    local " .. e4 .. " = " .. e3 .. "(" .. e2 .. ")"
    lines[#lines + 1] = "    if " .. e4 .. " then"
    lines[#lines + 1] = "      " .. e4 .. "()"
    lines[#lines + 1] = "    end"
    lines[#lines + 1] = "  end"
    lines[#lines + 1] = "end"
    
    lines[#lines + 1] = v1 .. "(string, string.char, tonumber, math.floor)"
    
    return table.concat(lines, "\n")
end

while true do
    g.info = gg.prompt({
        'Select file to encrypt:',
        'Select folder:'
    }, g.info, {'file', 'path'})

    if not g.info then return end

    gg.saveVariable(g.info, g.config)
    g.last = g.info[1]

    local fileName = "script_enc.lua"
    g.out = g.info[2] .. "/" .. fileName

    local file = io.open(g.last, "r")
    if not file then
        gg.alert("Error opening file: " .. g.last)
        return
    end
    
    local DATA = file:read("*a")
    file:close()
    
    if not DATA or #DATA == 0 then
        gg.alert("File is empty")
        return
    end
    
    math.randomseed(os.time())
    local finalCode = generateLoader(DATA)

    local testFunc, testErr = load(finalCode)
    if testErr then
        gg.alert("Syntax error in generated code:\n" .. testErr .. "\n\nThe file will still be saved.")
    end

    local outFile = io.open(g.out, "w")
    if not outFile then
        gg.alert("Error creating output file")
        return
    end
    
    outFile:write(finalCode)
    outFile:close()
    
    if testFunc then
        gg.alert("File saved successfully!\n" .. g.out .. "\n\nCode is valid and executable.")
        local success, execErr = pcall(testFunc)
        if not success then
            gg.alert("Code has valid syntax but runtime error:\n" .. tostring(execErr))
        end
    else
        gg.alert("File saved with warnings:\n" .. g.out)
    end
    
    return
end