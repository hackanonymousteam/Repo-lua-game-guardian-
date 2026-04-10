gg.setVisible(true)

local hubConfig = {
    moonHttpUrl = "https://huggingface.co"
}

local selectedModels = {}
local modelCache = {}

local json = nil
if not pcall(function()
    json = load(gg.makeRequest("https://raw.githubusercontent.com/rxi/json.lua/master/json.lua").content)()
end) then
    json = require("json") or gg.alert("❌  JSON library no avaliable")
    if not json then return end
end
local function urlencode(str)
    if str then
        str = string.gsub(str, "\n", "\r\n")
        str = string.gsub(str, "([^%w %-%_%.%~])", function(c)
            return string.format("%%%02X", string.byte(c))
        end)
        str = string.gsub(str, " ", "+")
    end
    return str
end

function formatNumber(num)
    if num >= 1000000 then
        return string.format("%.1fM", num / 1000000)
    elseif num >= 1000 then
        return string.format("%.1fK", num / 1000)
    else
        return tostring(num)
    end
end

function makeRequest(url, method)
    method = method or "GET"
    local response = gg.makeRequest(url, {}, nil, method)
    
    if type(response) == "table" then
        if response.code == 200 then
            local success, data = pcall(json.decode, response.content)
            if success then
                return data, nil
            else
                return nil, "Erro decoder JSON"
            end
        else
            return nil, "HTTP " .. tostring(response.code)
        end
    end
    return nil, "in request"
end

function searchHuggingFaceModels(query, limit)
    local url = string.format("%s/api/models?search=%s&limit=%d&sort=downloads",
        hubConfig.moonHttpUrl,
        urlencode(query),
        limit or 20
    )
    
    gg.toast("🔍 searching models...")
    local data, err = makeRequest(url)
    
    if data then
        return data
    else
        gg.toast("❌ Error: " .. (err or "unknow"))
        return {}
    end
end

function searchAndSelectModel()
    local input = gg.prompt({"🔍 enter term for search:"}, {""}, {"text"})
    if not input or input[1] == "" then return end
    
    local query = input[1]
    local models = searchHuggingFaceModels(query, 15)
    
    if not models or #models == 0 then
        gg.alert("❌  0 results: " .. query)
        return
    end
    
    local modelList = {}
    for i, model in ipairs(models) do
        local downloads = formatNumber(model.downloads or 0)
        local likes = formatNumber(model.likes or 0)
        local pipeline = model.pipeline_tag or "general"
        
        table.insert(modelList, string.format("%s ⬇%s ❤%s 🔧%s", 
            model.modelId or model.id, 
            downloads, 
            likes,
            pipeline))
    end
    
    local choice = gg.choice(modelList, 1, "🔍 Results: " .. query)
    if choice then
        local selectedModel = models[choice]
        local modelId = selectedModel.modelId or selectedModel.id
        print(modelId)
os.exit()
    end
end

function showMainMenu()
    while true do
        local choice = gg.choice({
            "🔍 search Models",
            "❌ exit"
        }, 1, "🤗 Hugging Face Explorer")
        
        if not choice or choice == 5 then
            break
        end
        
        if choice == 1 then
            searchAndSelectModel()
        end
--casperhansen/mistral-nemo-instruct-2407-awq

--https://ai.azure.com/catalog/models/casperhansen-mistral-nemo-instruct-2407-awq

        if choice == 2 then
            os.exit()
            end
    end
end

function countTable(tbl)
    local count = 0
    for _ in pairs(tbl) do
        count = count + 1
    end
    return count
end
showMainMenu()
gg.toast("👋 bye!")