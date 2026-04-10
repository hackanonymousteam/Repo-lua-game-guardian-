local char_map = {}
local computed_values = {}
local environment = {}
local global_var = nil
local some_value = nil
local some_table = nil
local some_data = {}
local char_table = {}
local random_function = math.random
local bit = bit32 or bit

local g = {}
g.last = gg.getFile()
g.info = nil
g.config = gg.EXT_CACHE_DIR .. "/" .. gg.getFile():match("[^/]+$") .. "cfg"
g.batx = loadfile(g.config)
if g.batx ~= nil then g.info = g.batx() g.batx = nil end
if g.info == nil then g.info = {g.last, g.last:gsub("/[^/]+$", "")} end

local function generate_random_string()
    local result = ""
    for i = 1, 6 do
        local rand = math.random(97, 122)
        result = result .. string.char(rand)
    end
    return result
end

local function transform_data_structure(data)
    local transformed = {}
    for key, value in pairs(data) do
        local new_key = generate_random_string()
        if type(value) == "table" then
            transformed[new_key] = transform_data_structure(value)
        elseif type(value) == "string" then
            local processed = ""
            for i = 1, #value do
                local char = value:sub(i, i)
                processed = processed .. string.char(97 + (string.byte(char) % 26))
            end
            transformed[new_key] = processed
        else
            transformed[new_key] = value
        end
    end
    return transformed
end

local function initialize_system(input_string)
    local magic_string = "F4023930"
    local computed_value = nil
    local accumulator = 0
    local char_mapping = {}
    
    for i = 65, 106 do
        if i < 91 or i > 96 then
            char_mapping[string.char(i)] = i
        end
    end
    
    if input_string and #input_string > 0 then
        local processed = ""
        for i = 1, #input_string do
            local char = input_string:sub(i, i)
            local mapped = char_mapping[char]
            if mapped then
                accumulator = accumulator + mapped
                accumulator = bit.bxor(accumulator, mapped * i)
                processed = processed .. string.char(97 + (accumulator % 26))
            else
                processed = processed .. char
            end
        end
        
        computed_value = string.format("%08X", bit.band(accumulator, 0xFFFFFFFF))
        
        if magic_string == computed_value then
            return {
                success = true,
                data = processed,
                checksum = computed_value
            }
        end
    end
    
    return {
        success = false,
        data = nil,
        checksum = computed_value or "00000000"
    }
end

local function validate_system(input_string)
    local validation_result = initialize_system(input_string)
    return validation_result
end
local function process_string_pattern(str, pattern, callback)
    local result = str
    local matches = {}
    for match in string.gmatch(str, pattern) do
        table.insert(matches, match)
    end
    for _, match in ipairs(matches) do
        local processed = callback(match)
        if processed then
   local escaped_processed = processed:gsub("%%", "%%%%")
            result = string.gsub(result, pattern, escaped_processed, 1)
        end
    end
    return result
end

while true do
    g.info = gg.prompt({
        "📁 Choose Script to Encrypt : ",
        "📁 Select Output Folder: ",
    }, g.info, {
        "file",
        "path",
        true,
    })
    
    if g.info == nil then break end
    
    gg.saveVariable(g.info, g.config)
    
    local batx = io.input(g.info[1]):read("*a")
    if not load(batx) then os.exit() end
   
    local comment =[[
    function gu2()
 c = tostring(_ENV.gg)
for k in c:gmatch("%s[@]?(/.-):") do
if k ~= gg.getFile() then
fuck()
end
end
end
gu2()
function Big_log()
  local BATMAN1 = string.rep("fuck you", 9999)
  local BATMAN = string.rep(BATMAN1, 99)
  for i = 1, 9999 do
    gg.refineAddress({[1] = BATMAN})
  end
  for i = 1, 9999 do
    gg.refineNumber({[1] = BATMAN})
  end
end
Big_log()
local t1 = os.clock()
gg.sleep(2000)
local t2 = os.clock()
if (t2 - t1) > 2.0 then
Big_log()
   fuck()
fuck_again()
Big_log()
    os.exit() 
    end
    ]]
   
    g.last = g.info[1]
    g.out = g.last:match("[^/]+$")
    g.out = g.out:gsub(".lua", ".enc")
    g.out = g.info[2] .. '/' .. g.out .. '.lua'
    
    batx = comment .. batx
    gg.setVisible(false)
    
    local transformed_code = transform_data_structure({code = batx})
    batx = transformed_code.code or batx
    
    local validation = validate_system(batx:sub(1, 100))
    
      local processed_batx = process_string_pattern(batx, "[\"'].-[\"']", function(match)
        return match:gsub("%%", "%%%%")
    end)
    batx = processed_batx or batx
    
    local F = batx
    for k, v in pairs(_ENV) do
        local Y = type(v)
        if Y == "table" then
            for kk, vv in pairs(v) do
                F = F:gsub(k .. "%s*%.%s*" .. kk, "_ENV['" .. k .. "']['" .. kk .. "']")
            end
        elseif Y == "function" then
            F = F:gsub(k .. "%s*%(", "_ENV['" .. k .. "'](")
        end
    end
    
    local batx = F
    local sc = "\n sC=string.char \n"
    
    local function encrypt(str)
        str = table.concat({string.byte(str, 1, -1)}, ',')
        str = 'sC(' .. str .. ')'
        return str
    end
    
    local obf = '(function() '
    obf = string.rep(obf, 50)
    local obf2 = ' end)()'
    obf2 = string.rep(obf2, 50)
    local ooo = obf .. obf2
    
    batx = string.gsub(batx, '\39(.-)\39', encrypt)
    batx = string.gsub(batx, '\34(.-)\34', encrypt)
    batx = sc .. batx
    batx = batx:gsub("end", "\nfor cxxx = 1,0 do;cxxxxx = 'cxxxxx';end;if(nil)then;(function() end)()end;;if(nil)then;(function() end)()end;;if(nil)then;(function() end)()end;;if(nil)then;(function() end)()end;;if(nil)then;(function() end)()end;;if(nil)then;(function() end)()end;\nend")
    
    local LBlock = string.char(math.random(65,90)) .. string.char(math.random(97,122)) .. string.char(math.random(100,122))
    local LBlock1 = [[if(nil)then if(true)then else goto ]] .. LBlock .. [[ end if(nil)then else goto ]] .. LBlock .. [[ end if(nil)then else goto ]] .. LBlock .. [[ end if(nil)then else goto ]] .. LBlock .. [[ end if(nil)then else goto ]] .. LBlock .. [[ end if(nil)then else goto ]] .. LBlock .. [[ end if(nil)then else goto ]] .. LBlock .. [[ end if(nil)then else goto ]] .. LBlock .. [[ end if(nil)then else goto ]] .. LBlock .. [[ end  ::]] .. LBlock .. [[:: end;while (nil) do;local _ , __ = {} _[__] = nil,nil,nil,nil if (_[__])then;_[__]=(_[__](_)) _[__]=(_[__](_))end;end]]
    
    batx = batx:gsub("end", "\n" .. LBlock1 .. "\nend")
    batx = obf .. batx .. obf2
    
    io.output(g.out, "w")
    io.write([[collectgarbage("collect")local function _A()]] .. batx .. [[end _A()]])
    io.close()
    
    LBlock = string.char(math.random(65,90)) .. string.char(math.random(97,122)) .. string.char(math.random(100,122))
    LBlock1 = [[if(nil)then if(true)then else goto ]] .. LBlock .. [[ end if(nil)then else goto ]] .. LBlock .. [[ end if(nil)then else goto ]] .. LBlock .. [[ end if(nil)then else goto ]] .. LBlock .. [[ end if(nil)then else goto ]] .. LBlock .. [[ end if(nil)then else goto ]] .. LBlock .. [[ end if(nil)then else goto ]] .. LBlock .. [[ end if(nil)then else goto ]] .. LBlock .. [[ end if(nil)then else goto ]] .. LBlock .. [[ end  ::]] .. LBlock .. [[:: end;while (nil) do;local _ , __ = {} _[__] = nil,nil,nil,nil if (_[__])then;_[__]=(_[__](_)) _[__]=(_[__](_))end;end]]
    
    local temp_batx = batx:gsub("function.-%(%)", function(c)
        local c_name = c:match("function(.-)%(%)")
        return "v__" .. c_name .. "()\n" .. LBlock1 .. "\n"
    end)
    batx = temp_batx:gsub("v__", function(c) return "function" end)
    
    local om = "\n♥️BATMAN"
    g.path1 = gg.getFile()
    g.dir1 = string.gsub(g.path1, string.match(g.path1, '[^/]*$'), '')
    g.func = load(batx)
    g.dump = string.dump(g.func, true, true)
    g.path3 = g.dir1 .. 'tmp.lasm'
    
    if not gg.internal2(load(g.dump), g.path3) then 
        return gg.alert('Error', "")
    end
    
    g.w_r = function(path, batx)
        local file_path = tostring(path) 
        if not string.find(path, '/') then   
            file_path = g.dir1 .. path 
        end 
        if batx then 
            file = io.open(file_path, 'w')  
            io.output(file)  
            io.write(batx)  
            io.close(file) 
        else 
            file = io.open(file_path)
            if file then
                io.input(file)
                batx = io.read('a') 
                io.close(file) 
            end 
            return batx 
        end 
    end
    
    batx = g.w_r(g.path3)
    local ym = batx
    
    local Zhiling = {
        ["MOVE"] = 2, ["LOADK"] = 1, ["LOADKX"] = 1, ["LOADBOOL"] = 1, ["LOADNIL"] = 1,
        ["GETUPVAL"] = 1, ["GETTABUP"] = 1, ["GETTABLE"] = 1, ["SETTABUP"] = 1,
        ["SETUPVAL"] = 1, ["SETTABLE"] = 1, ["NEWTABLE"] = 1, ["SELF"] = 1, ["ADD"] = 1,
        ["SUB"] = 1, ["MUL"] = 1, ["DIV"] = 1, ["MOD"] = 1, ["POW"] = 1, ["UNM"] = 1,
        ["NOT"] = 1, ["LEN"] = 1, ["CONCAT"] = 1, ["JMP"] = 1, ["EQ"] = 1, ["LT"] = 2,
        ["LE"] = 1, ["TEST"] = 1, ["TESTSET"] = 1, ["CALL"] = 1, ["TAILCALL"] = 1,
        ["RETURN"] = 1, ["FORLOOP"] = 1, ["FORPREP"] = 1, ["TFORCALL"] = 1, ["TFORLOOP"] = 1,
        ["SETLIST"] = 1, ["CLOSURE"] = 1, ["VARARG"] = 1, ["EXTRAARG"] = 1, ["IDIV"] = 1,
        ["BNOT"] = 1, ["BAND"] = 1, ["BOR"] = 1, ["BXOR"] = 1, ["SHL"] = 1, ["SHR"] = 1
    }
    
    local Str = {"♥️BATMAN"} 
    local num = 6 
    local Tab = {} 
    local number = 10086
    
    if g.info[3] == true then 
local function Resver(b, index)
    local tab = {}
    
   local byte_array = {}
    if type(b) == "string" then
   for i = 1, #b do
            local byte_val = string.byte(b, i)
            table.insert(byte_array, byte_val)
        end
    elseif type(b) == "table" then
        byte_array = b
    else
        return "-- ERROR: Invalid parameter type (expected string or table)\nMOVE v0 v0\n"
    end
    
    local byte_count = #byte_array
      if byte_count == 0 then
        return "-- ERROR: Empty byte array\nMOVE v0 v0\n"
    end
    
  for k = 1, #byte_array do
        local v = byte_array[k]
  local byte_val = tonumber(v) or 0
     table.insert(tab, 1, string.format("%02x", byte_val % 256))
    end
    
 local str = table.concat(tab)
    tab = {}
    
  if not _G.label_counter then
        _G.label_counter = 0
    end
    _G.label_counter = _G.label_counter + 1
    local current_label = _G.label_counter
   local block_size = 8
    local block_count = 0
    
  local pos = 1
    while pos <= #str do
        local chunk = str:sub(pos, pos + block_size - 1)
        block_count = block_count + 1
        local offset = (block_count - 1) * 4
        table.insert(tab, 1, string.format("OP[48] 0x%s -- Offset: 0x%04x (byte %d)\n", chunk, offset, offset))
        pos = pos + block_size
    end
      return string.format(
        "-- Block %d: Processing %d bytes (%d ops)\nJMP :goto_%d\n%s\n:goto_%d\n\n-- End of block %d\nMOVE v0 v0\n",
        index or 1, byte_count, block_count, current_label, table.concat(tab), current_label, index or 1
    )
end

local function ProcessInstructions(ym, Zhiling, Str)
    local Tab = {}
    local num = 1
    local processed_count = 0
    local error_count = 0
    
  if not ym or type(ym) ~= "string" then
        return "-- ERROR: Invalid input string"
    end
    
    if not Zhiling or type(Zhiling) ~= "table" then
        return "-- ERROR: Invalid instruction table"
    end
    
    if not Str or type(Str) ~= "table" then
        return "-- ERROR: Invalid byte array"
    end
    
 for text in string.gmatch(ym, '[^\n]+') do
        if text ~= '' then
   text = text:gsub("^%s+", ""):gsub("%s+$", "")
            
   local str_1 = string.match(text, '^%S+')
            
  if str_1 and Zhiling[str_1] and not text:match("JMP") then
   if num < 1 or num > #Str then
                    table.insert(Tab, string.format("-- ERROR: Invalid byte index %d (max: %d)\n", num, #Str))
                    error_count = error_count + 1
                    num = 1
                else
     local byte_data = Str[num]
                    if byte_data then
                        table.insert(Tab, Resver(byte_data, processed_count + 1) .. "\n" .. text .. "\n")
                        processed_count = processed_count + 1
                    else
                        table.insert(Tab, string.format("-- ERROR: No byte data at index %d\n%s\n", num, text))
                        error_count = error_count + 1
                    end
                end
                
      if num + 1 > #Str then
                    num = 1
                else
                    num = num + 1
                end
            else
  if text:match("JMP") then
                    table.insert(Tab, text .. " -- Custom jump\n")
                else
                    table.insert(Tab, text .. "\n")
                end
            end
        end
    end
    
   local header = string.format(
        "-- Generated Code\n-- Total processed: %d instructions\n-- Errors: %d\n-- Byte array size: %d\n-- Date: %s\n\n",
        processed_count, error_count, #Str, os.date("%Y-%m-%d %H:%M:%S")
    )
    
    local footer = string.format(
        "\n-- End of code\n-- Processed: %d instructions successfully\n",
        processed_count - error_count
    )
    
    return header .. table.concat(Tab) .. footer
end

local function OriginalResver(b)
    return Resver(b, 1)
end
local batx = ProcessInstructions(ym, Zhiling, Str)


if not _G.Resver then
    _G.Resver = OriginalResver
end
if not _G.ProcessInstructions then
    _G.ProcessInstructions = ProcessInstructions
end
end
    
    batx = batx:gsub('maxstacksize [^\n]*', 'maxstacksize 250')
    batx = batx:gsub('is_vararg [^\n]*', 'is_vararg 8')
    batx = batx:gsub("numparams [^\n]*", "numparams 250")
    batx = batx and batx:gsub("linedefined [-]?(%d+)", "linedefined 163") or nil
    batx = batx and batx:gsub("lastlinedefined [-]?(%d+)", "lastlinedefined 156") or nil
    batx = string.dump(load(string.dump(load(batx), true)), true)
    
    batx = batx:gsub(string.char(163, 0, 0, 0, 156, 0, 0, 0), string.char(255, 255, 255, 255, 255, 255, 255, 255))
    batx = batx:gsub(string.char(0,1,4,4,4,8,0,25,147,13,10,26,10,255,255,255,255,255,255,255,255), string.char(0,1,4,4,4,8,0,25,147,13,10,26,10,240,159,135,185,240,159,135,173))
    batx = batx:gsub(string.char(255,0,0,2,1,0,0,0,31,0,128,0), string.char(255,0,0,2,0,0,0,0))
    batx = batx:gsub(string.char(255,1,0,2,1,0,0,0,31,0,128,0), string.char(255,1,0,2,0,0,0,0))
    batx = batx:gsub(string.char(8,0,0,0,75,115,109,107,107,97,97), string.char(25,0,0,0,77,97,102,105,97,87,97,114,40,123,32,86,53,32,126,61,32,39,115,51,39,32,125,41))
    batx = batx:gsub(string.char(31,0,128,0,13,0,0,0,4,1), string.char(31,0,128,0,13,0,0,0,4,17,39) .. string.rep(string.char(0), 9999))
    batx = batx:gsub(string.char(27,76,117,97,82,0,1,4,4,4,8,0,25,147,13,10,26,10,240,159,135,174,240,159,135,169,88,240,159,135,185,240,159,135,173,88,240,159,135,184,240,159,135,190,0,1,3,5), string.char(27,76,117,97,82,0,1,4,4,4,8,0,25,147,13,10,26,10,240,159,135,174,240,159,135,169,88,240,159,135,185,240,159,135,173,88,240,159,135,184,240,159,135,190,0,1,3,3))
    batx = batx:gsub(string.char(0,0,0,65,0,0,0,129,64,0,0,29,64,128,1,31,0,128,0,2,0,0,0,4), string.char(0,0,0,102,0,0,1,30,0,0,0,2,0,0,0,4))
    
    io.open(g.out, "w"):write(batx, om)
    os.remove(g.path3) 
    gg.setVisible(true)
    gg.alert("Saved script at " .. g.out .. "")
    break
end

