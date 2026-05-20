local g = {}
g.last = gg.getFile()
g.sel = nil

local function simple_encode(str, key)
    local result = {}
    for i = 1, #str do
        local c = string.byte(str, i)
        local k = string.byte(key, ((i - 1) % #key) + 1)
        result[i] = string.format("%02X", c ~ k)
    end
    return table.concat(result)
end

while true do
    g.sel = gg.prompt({
        "Input Path",
        "Function Name",
        "Choice Variable",
        "Title",
        "Number of Functions"
    }, {
        "/sdcard/",
        "Home",
        "BAT",
        "Welcome To My Script",
        "4"
    }, {
        "path",
        "text",
        "text",
        "text",
        "number"
    })
    
    if g.sel == nil then 
        return 
    end
    
    g.out = g.sel[1]
    local num_functions = tonumber(g.sel[5]) or 4
    local key = tostring(os.time()):sub(-8) .. "MYKEY123"
    
    local function_names = {}
    local function_codes = {}
    local encoded_choices = {}
    
    for i = 1, num_functions do
        local choice_prompt = gg.prompt({
            "Choice " .. i .. " Name",
            "Code for Function " .. i
        }, {
            "Choice " .. i,
            "gg.setVisible(false)\nprint('Function " .. i .. " executed')"
        }, {
            "text",
            "text"
        })
        
        if choice_prompt == nil then
            function_names[i] = "Choice " .. i
            function_codes[i] = "gg.setVisible(false)\nprint('Function " .. i .. " executed')"
        else
            function_names[i] = choice_prompt[1]
            function_codes[i] = choice_prompt[2]
        end
        
        encoded_choices[i] = simple_encode(function_names[i], key)
        function_codes[i] = simple_encode(function_codes[i], key)
    end
    
    local encoded_exit = simple_encode("Exit", key)
    
    local script_code = [[
local function simple_decode(hex_str, key)
    local result = {}
    for i = 1, #hex_str, 2 do
        local hex_byte = hex_str:sub(i, i + 1)
        local byte = tonumber(hex_byte, 16)
        local k = string.byte(key, (((i - 1) / 2) % #key) + 1)
        result[#result + 1] = string.char(byte ~ k)
    end
    return table.concat(result)
end

local key = "]] .. key .. [["
local num = ]] .. num_functions .. [[

local choice_texts = {}
local function_codes = {}
]]
    
    for i = 1, num_functions do
        script_code = script_code .. "choice_texts[" .. i .. "] = simple_decode(\"" .. encoded_choices[i] .. "\", key)\n"
        script_code = script_code .. "function_codes[" .. i .. "] = simple_decode(\"" .. function_codes[i] .. "\", key)\n"
    end
    
    script_code = script_code .. [[
local exit_text = simple_decode("]] .. encoded_exit .. [[", key)

local choices = {}
for i = 1, num do
    choices[i] = choice_texts[i]
end
choices[num + 1] = exit_text

function ]] .. g.sel[2] .. [[()
    local ]] .. g.sel[3] .. [[ = gg.choice(choices, 0, "]] .. g.sel[4] .. [[")
    if ]] .. g.sel[3] .. [[ == nil then
        gg.setVisible(false)
        return
    end
    
    for i = 1, num do
        if ]] .. g.sel[3] .. [[ == i then
            local fn = load(function_codes[i])
            if fn then 
                fn()
            end
            gg.setVisible(false)
        end
    end
    
    if ]] .. g.sel[3] .. [[ == num + 1 then
        print("]] .. g.sel[4] .. [[")
        gg.skipRestoreState()
        gg.setVisible(true)
        os.exit()
    end
end

while true do
    if gg.isVisible(true) then
        gg.setVisible(false)
        ]] .. g.sel[2] .. [[()
    end
end]]
    
    io.open(g.out, "w"):write(script_code):close()    
    gg.alert("Script created successfully!\n" .. g.out)
    print("Script created: " .. g.out) 
    break
end