if not autocomplete then
    autocomplete = {}
end

if not autocomplete._lists then
    autocomplete._lists = {}
end

if not autocomplete._env then
    autocomplete._env = {}
end

if not autocomplete._translations then
    autocomplete._translations = {}
end

function autocomplete.RemoveList(id)
    autocomplete._env[id] = nil
    
    for i, v in ipairs(autocomplete._lists) do
        if v.id == id then
            table.remove(autocomplete._lists, i)
            return true
        end
    end
    
    return false
end

function autocomplete.AddList(id, lst)
    autocomplete.RemoveList(id)
    table.insert(autocomplete._lists, {id = id, list = lst})
end

function autocomplete.SetListTranslation(id, translation)
    autocomplete._translations[id] = translation
end

function autocomplete.GetList(id)
    for _, v in ipairs(autocomplete._lists) do
        if v.id == id then
            local lst = v.list
            if type(lst) == "function" then
                lst = lst()
            end
            return lst
        end
    end
    return {}
end

function autocomplete.GetLists()
    return autocomplete._lists
end

local function searchList(list, str, found, found_list, id)
    if type(str) ~= "string" then
        str = ""
    end
    
    if not list then
        return found
    end
    
    if type(list) == "table" then
        if str == "" then
            for i = 1, math.min(100, #list) do
                local randomIndex = math.random(1, #list)
                local value = list[randomIndex]
                
                if type(value) == "table" and value.val then
                    table.insert(found, {
                        val = value.val,
                        cat = value.cat,
                        id = id
                    })
                else
                    table.insert(found, {
                        val = value,
                        id = id
                    })
                end
            end
        else
            str = str:lower()
            for i = 1, #list do
                local item = list[i]
                local text
                
                if type(item) == "table" and item.val then
                    text = tostring(item.val)
                else
                    text = tostring(item)
                end
                
                if text:lower():find(str, 1, true) then
                    if type(item) == "table" then
                        local clone = {}
                        for k, v in pairs(item) do
                            clone[k] = v
                        end
                        clone.id = id
                        table.insert(found, clone)
                    else
                        table.insert(found, {
                            val = item,
                            id = id
                        })
                    end
                end
            end
        end
    elseif type(list) == "function" then
        local result = list(str)
        if result then
            if type(result) == "table" then
                for _, v in ipairs(result) do
                    if not v.id then
                        v.id = id
                    end
                    table.insert(found, v)
                end
            else
                table.insert(found, {
                    val = result,
                    id = id
                })
            end
        end
    end
    
    return found
end

function autocomplete.Search(str, id)
    local found = {}
    
    if type(str) ~= "string" then
        str = ""
    end
    
    if type(id) == "string" then
        return searchList(autocomplete.GetList(id), str, {}, false, id)
    elseif type(id) == "table" and type(id[1]) == "string" then
        for _, listId in ipairs(id) do
            searchList(autocomplete.GetList(listId), str, found, false, listId)
        end
        return found
    elseif type(id) == "table" then
        return searchList(id, str, {}, true)
    else
        for _, data in ipairs(autocomplete._lists) do
            searchList(data.list, str, found, false, data.id)
        end
        return found
    end
end

function autocomplete.DrawFound(id, x, y, found, max, offset)
    if not autocomplete._env[id] then
        autocomplete._env[id] = {
            found_autocomplete = {},
            scroll = 0
        }
    end
    
    offset = offset or 1
    max = max or 100
    
    local yOffset = 0
    local xOffset = 0
    
    print("=== Autocomplete Results (" .. id .. ") ===")
    
    local categories = {}
    
    for i = offset, max do
        local v = found[i]
        if not v then break end
        
        if v.cat and not categories[v.cat] then
            print("[" .. v.cat .. "]")
            yOffset = yOffset + 1
            xOffset = 2
            categories[v.cat] = true
        end
        
        local prefix = ""
        if v.id and autocomplete._translations[v.id] then
            local trans = autocomplete._translations[v.id]
            if type(trans) == "function" then
                trans = trans()
            end
            prefix = "[" .. trans .. "] "
        end
        
        print(string.rep(" ", xOffset) .. prefix .. tostring(v.val))
        yOffset = yOffset + 1
    end
    
    if yOffset == 0 then
        print("No results found")
    end
    print("==============================")
end

function autocomplete.Query(id, str, scroll, list)
    scroll = scroll or 0
    
    if not autocomplete._env[id] then
        autocomplete._env[id] = {
            found_autocomplete = {},
            scroll = 0,
            last_str = "",
            tab_str = nil,
            tab_autocomplete = nil,
            pause_autocomplete = false
        }
    end
    
    local env = autocomplete._env[id]
    
    if scroll ~= 0 then
        local targetList = env.tab_autocomplete or env.found_autocomplete
        local newScroll = env.scroll + scroll
        if newScroll < 0 then newScroll = 0 end
        if newScroll > #targetList - 1 then newScroll = #targetList - 1 end
        env.scroll = newScroll
    end
    
    if not env.pause_autocomplete then
        local searchStr = env.tab_str or str
        local searchList = env.tab_autocomplete or list or id
        
        env.found_autocomplete = autocomplete.Search(searchStr, searchList)
        
        if #env.found_autocomplete == 0 then
            env.pause_autocomplete = str
        end
    else
        if #env.pause_autocomplete >= #str then
            env.pause_autocomplete = false
        end
    end
    
    if scroll ~= 0 and #env.found_autocomplete > 0 then
        if not env.tab_str then
            env.tab_str = str
            env.tab_autocomplete = env.found_autocomplete
        end
        env.last_str = str
    end
    
    return env.found_autocomplete
end

autocomplete.AddList("numbers", {10, 20, 30, 40, 50, 100, 200, 300, 400, 500})
autocomplete.AddList("texts", {"test", "example", "autocomplete", "search", "system", "completion"})
autocomplete.AddList("categories", {
    {val = "item1", cat = "group1"},
    {val = "item2", cat = "group1"},
    {val = "item3", cat = "group2"},
    {val = "item4", cat = "group2"},
    {val = "item5", cat = "group3"}
})
autocomplete.AddList("dynamic", function(str)
    if str == "test" then
        return {
            {val = "result_test", cat = "dynamic"},
            {val = "another_result", cat = "dynamic"}
        }
    end
    return {}
end)

autocomplete.SetListTranslation("numbers", "Numeric Values")
autocomplete.SetListTranslation("texts", "Texts")
autocomplete.SetListTranslation("categories", "Categorized Items")
autocomplete.SetListTranslation("dynamic", "Dynamic Result")

local example1 = autocomplete.Search("test", "texts")
print("example1")
for i, v in ipairs(example1) do print(v.val) end

local example2 = autocomplete.Search("", "numbers")
print("example2")
for i, v in ipairs(example2) do print(v.val) end

local example3 = autocomplete.Search("item", "categories")
print("example3")
for i, v in ipairs(example3) do print(v.cat .. ": " .. v.val) end

local example4 = autocomplete.Search("test", "dynamic")
print("example4")
for i, v in ipairs(example4) do print(v.cat .. ": " .. v.val) end

local example5 = autocomplete.Search("10", nil)
print("example5")
for i, v in ipairs(example5) do print(v.val) end

autocomplete.DrawFound("test", 10, 10, example1, 5, 1)

local query1 = autocomplete.Query("chat", "te", 0)
local query2 = autocomplete.Query("chat", "te", 1)

return autocomplete