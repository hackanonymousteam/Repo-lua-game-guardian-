gg.setVisible(true)

local api_key = "your-api-key-here"

local g = {}
g.last = gg.getFile()
g.info = nil
g.config = gg.EXT_CACHE_DIR .. "/" .. gg.getFile():match("[^/]+$") .. "cfg"
DATA = loadfile(g.config)
if DATA ~= nil then g.info = DATA() DATA = nil end
if g.info == nil then g.info = {g.last, g.last:gsub("/[^/]+$", "")} end

local function createJson(tbl)
    local parts = {}
    for k, v in pairs(tbl) do
        local key_str = string.format('"%s"', k)
        if type(v) == "boolean" then
            table.insert(parts, key_str .. ":" .. tostring(v))
        elseif type(v) == "number" then
            table.insert(parts, key_str .. ":" .. string.format("%d", v))
        elseif type(v) == "string" then
            table.insert(parts, key_str .. ':"' .. v .. '"')
        elseif type(v) == "table" and v[1] then
            local array_parts = {}
            for _, val in ipairs(v) do
                if type(val) == "number" then
                    table.insert(array_parts, string.format("%d", val))
                elseif type(val) == "boolean" then
                    table.insert(array_parts, tostring(val))
                end
            end
            table.insert(parts, key_str .. ":[" .. table.concat(array_parts, ",") .. "]")
        elseif type(v) == "table" then
            local sub_parts = {}
            for sub_k, sub_v in pairs(v) do
                if type(sub_v) == "number" then
                    table.insert(sub_parts, string.format('"%s":%d', sub_k, sub_v))
                elseif type(sub_v) == "table" and sub_v[1] then
                    local sub_array = {}
                    for _, arr_val in ipairs(sub_v) do
                        table.insert(sub_array, string.format("%d", arr_val))
                    end
                    table.insert(sub_parts, string.format('"%s":[%s]', sub_k, table.concat(sub_array, ",")))
                end
            end
            table.insert(parts, key_str .. ":{" .. table.concat(sub_parts, ",") .. "}")
        end
    end
    return "{" .. table.concat(parts, ",") .. "}"
end

local function extractCodeFromResponse(response_text)
    if not response_text then return nil end
    
    --print("Full response length:", #response_text)
    --print("First 500 chars:", string.sub(response_text, 1, 500))
    
    local code_start = response_text:find('"code":"')
    if not code_start then
        return nil
    end
    
    code_start = code_start + 8
    
    local code = ""
    local i = code_start
    local in_escape = false
    
    while i <= #response_text do
        local char = response_text:sub(i, i)
        
        if in_escape then
            code = code .. char
            in_escape = false
        elseif char == "\\" then
            code = code .. char
            in_escape = true
        elseif char == '"' then
            break
        else
            code = code .. char
        end
        
        i = i + 1
    end
    
    --print("Extracted code length:", #code)
    
    code = code:gsub("\\\\", "\\")
    code = code:gsub("\\n", "\n")
    code = code:gsub("\\r", "\r")
    code = code:gsub("\\t", "\t")
    code = code:gsub('\\"', '"')
    
    return code
end

local function obfuscateFile()
    while true do
        g.info = gg.prompt({
            '[🔒] file to protect:',
            '[📂] folder to save:'
        }, g.info, {
            "file",
            "path"
        })
        
        if g.info == nil then return end
        
        gg.saveVariable(g.info, g.config)
        g.last = g.info[1]
        
        local file = io.open(g.last, "r")
        if not file then
            gg.alert("❌ Cannot open file: " .. g.last)
            return
        end
        
        local lua_code = file:read("*a")
        file:close()
        
        if #lua_code == 0 then
            gg.alert("❌ File is empty")
            return
        end
        
        if #lua_code > 100000 then
            local confirm = gg.alert(
                "⚠️ Warning: Large file (" .. #lua_code .. " chars)\n" ..
                "API may truncate response. Continue?",
                "Yes",
                "No"
            )
            if confirm ~= 1 then return end
        end
        
        g.out = g.info[2].."/"..g.last:match("([^/]+)$"):gsub("%.lua$","_protected.lua")
        
        local config = {
            MinifiyAll = true,
            Minifier = true,
            Virtualize = true,
            EncryptStrings = 100,
            SwizzleLookups = 100,
            JunkifyAllIfStatements = 70,
            MutateAllLiterals = 50,
            Seed = math.random(1000000, 9999999),
            CustomPlugins = {
                DummyFunctionArgs = {2, 5},
                ControlFlowFlattenV1AllBlocks = 60
            }
        }
        
        gg.toast("Creating session...", true)
        
        local resp1 = gg.makeRequest(
            "https://api.luaobfuscator.com/v1/obfuscator/newscript",
            {
                ["apikey"] = api_key,
                ["Content-Type"] = "text/plain"
            },
            lua_code
        )
        
        if not resp1 or not resp1.content then
            gg.alert("❌ No response from server")
            return
        end
        
        local sessionId = resp1.content:match('"sessionId":"([^"]+)"')
        if not sessionId then
            gg.alert("❌ Failed to get session ID\n" .. resp1.content)
            return
        end
        
        gg.toast("Obfuscating...", true)
        
        local config_json = createJson(config)
        local resp2 = gg.makeRequest(
            "https://api.luaobfuscator.com/v1/obfuscator/obfuscate",
            {
                ["apikey"] = api_key,
                ["sessionId"] = sessionId,
                ["Content-Type"] = "application/json"
            },
            config_json
        )
        
        if not resp2 or not resp2.content then
            gg.alert("❌ No obfuscation response")
            return
        end
        
        if #resp2.content < 100 then
            --print("Very short response:", resp2.content)
        end
        
        local obfuscated_code = extractCodeFromResponse(resp2.content)
        
        if obfuscated_code and #obfuscated_code > 10 then
            local out_file = io.open(g.out, "w")
            if out_file then
                out_file:write(obfuscated_code)
                out_file:close()
                
                local check_file = io.open(g.out, "r")
                local saved = check_file:read("*a")
                check_file:close()
                
                gg.alert(
                    "✅ Obfuscation complete!\n" ..
                    "Saved to: " .. g.out .. "\n" ..
                    "Original: " .. #lua_code .. " chars\n" ..
                    "Obfuscated: " .. #obfuscated_code .. " chars\n" ..
                    "Saved: " .. #saved .. " chars"
                )
                
                
local syntax_check = gg.alert("Check syntax?", "Yes", "No")
                if syntax_check == 1 then
                  --  local success, err = pcall(load("return " .. saved))
                    if success then
                     --   gg.toast("✅ Syntax OK")
                    else
                        --gg.alert("⚠️ Syntax issue:\n" .. tostring(err))
                    end
                end
            else
             --   gg.alert("❌ Cannot save to: " .. g.out)
            end
        else
            local msg = resp2.content:match('"message":"([^"]+)"') or "Unknown error"
            gg.alert("❌ Failed to extract code\n" .. msg .. "\n\nResponse length: " .. #resp2.content)
            
            if #resp2.content < 1000 then
                gg.alert("Full response:\n" .. resp2.content)
            end
        end
        
        local again = gg.alert("Process another file?", "Yes", "No")
        if again ~= 1 then break end
    end
end

local function testWithSmallCode()
    local test_code = [[
function test()
    --print("Hello World")
    for i=1,10 do
        --print("Number: " .. i)
    end
    return true
end
test()
]]
    
    gg.toast("Testing with small code...", true)
    
    local config = {
        MinifiyAll = false,
        Minifier = true,
        EncryptStrings = 100,
        Seed = 12345
    }
    
    local resp1 = gg.makeRequest(
        "https://api.luaobfuscator.com/v1/obfuscator/newscript",
        {
            ["apikey"] = api_key,
            ["Content-Type"] = "text/plain"
        },
        test_code
    )
    
    if not resp1 or not resp1.content then
        gg.alert("❌ Test failed: No response")
        return
    end
    
    local sessionId = resp1.content:match('"sessionId":"([^"]+)"')
    if not sessionId then
        gg.alert("❌ Test failed: " .. resp1.content)
        return
    end
    
    local config_json = createJson(config)
    local resp2 = gg.makeRequest(
        "https://api.luaobfuscator.com/v1/obfuscator/obfuscate",
        {
            ["apikey"] = api_key,
            ["sessionId"] = sessionId,
            ["Content-Type"] = "application/json"
        },
        config_json
    )
    
    if resp2 and resp2.content then
        local code = extractCodeFromResponse(resp2.content)
        if code then
            local file = io.open("/sdcard/test_obfuscated.lua", "w")
            file:write(code)
            file:close()
            
            gg.alert(
                "✅ Test passed!\n" ..
                "Code saved to: /sdcard/test_obfuscated.lua\n" ..
                "Length: " .. #code .. " chars\n\n" ..
                "First 300 chars:\n" .. string.sub(code, 1, 300)
            )
        else
            gg.alert("❌ Test failed: Could not extract code\n" .. string.sub(resp2.content, 1, 500))
        end
    else
        gg.alert("❌ Test failed: No obfuscation response")
    end
end

local function setApiKey()
    local new_key = gg.prompt(
        {"API Key:"},
        {api_key},
        {"text"}
    )
    if new_key and new_key[1] then
        api_key = new_key[1]
        gg.toast("API Key updated")
    end
end

while true do
    local choice = gg.choice({
        "🔒 Obfuscate File",
     --   "🧪 Test with Small Code",
      --  "⚙️  Set API Key",
        "❌ Exit"
    }, nil, "Lua Obfuscator")
    
    if choice == 1 then
        obfuscateFile()
  --  elseif choice == 2 then
        --testWithSmallCode()
  --  elseif choice == 3 then
     --   setApiKey()
    else
        break
    end
end