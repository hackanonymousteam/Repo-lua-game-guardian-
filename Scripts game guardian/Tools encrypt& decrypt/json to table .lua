local json = {
    decode = function(js)
        local js_fixed = js:gsub('(%b{})', function(obj)
            return obj:gsub('("[^"]-")%s*:', '[%1]=')
        end)
        local l = "return " .. js_fixed
        local func, err = load(l)
        if not func then
            error("Erro decode JSON: " .. err)
        end
        local success, result = pcall(func)
        if not success then
            error("Erro : " .. result)
        end
        return result
    end,

    encode = function(tbl)
        local function serialize(obj)
            if type(obj) == "table" then
                local result = {}
                for k, v in pairs(obj) do
                    local key = type(k) == "string" and '"' .. k .. '"' or k
                    local value = serialize(v)
                    table.insert(result, key .. ": " .. value)
                end
                return "{" .. table.concat(result, ", ") .. "}"
            elseif type(obj) == "string" then
                return '"' .. obj .. '"'
            else
                return tostring(obj)
            end
        end
        return serialize(tbl)
    end
}

local url = "https://jsonplaceholder.typicode.com/users/1"
local response = gg.makeRequest(url)

if response and response.content then
    local json_data = response.content
  --  print("JSON Original: ", json_data)

    -- decode json to table lua
    local tbl = json.decode(json_data)
    
    local function printTable(t, indent)
        indent = indent or 0
        local prefix = string.rep("  ", indent)
        for k, v in pairs(t) do
            if type(v) == "table" then
                print(prefix .. tostring(k) .. ": {")
                printTable(v, indent + 1)
                print(prefix .. "}")
            else
                print(prefix .. tostring(k) .. ": " .. tostring(v))
            end
        end
    end

    print("Table Lua :")
    printTable(tbl)

--example acess values in table
    if tbl and tbl.username then
      --  print("Username: ", tbl.username)
    else
    --    print(" 'username' no found.")
    end

    -- example encode json
    local encoded_json = json.encode(tbl)
  --  print("json.encode:", encoded_json)
else
    print("Erro request: ", response and response.status or "unknown")
end