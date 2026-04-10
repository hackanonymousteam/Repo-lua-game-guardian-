
function encodeFunction(func)
    local data = {}

    local ggPattern = "gg%.([%a_]+)%((.-)%)"

    for command, value in string.gmatch(func, ggPattern) do
        
        local entry = { 
            func = "test", 
            gg = "gg", 
            variable = command, 
            value = value  
        }
        table.insert(data, entry)
    end

    local jsonStr = "local data = {\n"
    for i, entry in ipairs(data) do
        
        jsonStr = jsonStr .. "\t{func = \"" .. entry.func .. "\", gg = \"" .. entry.gg .. "\", variable = \"" .. entry.variable .. "\", value = \"" .. entry.value .. "\"},\n"
    end
    
    jsonStr = jsonStr:sub(1, -3) .. "\n}"

    return jsonStr
end


local func = [[
function a()
gg.searchNumber("1;1058236411D::5", 16)
gg.toast("Active")
end
]]


local jsonStr = encodeFunction(func)
print("JSON encoded:")
print(jsonStr)

