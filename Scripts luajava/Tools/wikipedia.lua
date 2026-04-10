gg.setVisible(true)

local json = nil
if not pcall(function()
    json = load(gg.makeRequest("https://raw.githubusercontent.com/rxi/json.lua/master/json.lua").content)()
end) then
    json = require("json") or gg.alert("❌ JSON library not available")
    if not json then return end
end

local SEARCH_HISTORY_FILE = "wikipedia_history.json"

local function urlEncode(str)
    if str == nil then return "" end
    return (str:gsub("([^%w])", function(c)
        return string.format("%%%02X", string.byte(c))
    end):gsub(" ", "+"))
end

function fileExists(filename)
    local file = io.open(filename, "r")
    if file then
        file:close()
        return true
    end
    return false
end

function safeReadHistory()
    local historyData = {}
    if fileExists(SEARCH_HISTORY_FILE) then
        local file = io.open(SEARCH_HISTORY_FILE, "r")
        if file then
            local content = file:read("*a")
            file:close()
            if content and content:trim() ~= "" then
                local success, result = pcall(json.decode, content)
                if success then
                    historyData = result
                end
            end
        end
    end
    return historyData
end

function saveHistory(historyData)
    local file = io.open(SEARCH_HISTORY_FILE, "w")
    if file then
        file:write(json.encode(historyData))
        file:close()
        return true
    end
    return false
end

function addToHistory(query, resultTitle)
    local history = safeReadHistory()
    local timestamp = os.time()
    
    if not history.searches then history.searches = {} end
    
    table.insert(history.searches, 1, {
        query = query,
        title = resultTitle,
        timestamp = timestamp,
        date = os.date("%Y-%m-%d %H:%M:%S", timestamp)
    })
    
    if #history.searches > 50 then
        history.searches = {table.unpack(history.searches, 1, 50)}
    end
    
    saveHistory(history)
end

function searchWikipedia(query)
    local searchUrl = "https://id.wikipedia.org/w/api.php?action=query&list=search&srsearch=" .. urlEncode(query) .. "&format=json"
    
    gg.toast("🔍 Searching: " .. query)
    local searchResponse = gg.makeRequest(searchUrl, {}, nil, "GET")
    
    if type(searchResponse) ~= "table" or searchResponse.code ~= 200 then
        return nil, "Search error: " .. (searchResponse.code or "no connection")
    end
    
    local searchData = json.decode(searchResponse.content)
    
    if not searchData.query or not searchData.query.search or #searchData.query.search == 0 then
        return nil, "No results found for: " .. query
    end
    
    local pageTitle = searchData.query.search[1].title
    
    local pageUrl = "https://id.wikipedia.org/w/api.php?action=query&titles=" .. urlEncode(pageTitle) .. "&prop=extracts|pageimages&exintro=true&explaintext=true&pithumbsize=500&format=json&redirects=1"
    
    local pageResponse = gg.makeRequest(pageUrl, {}, nil, "GET")
    
    if type(pageResponse) ~= "table" or pageResponse.code ~= 200 then
        return nil, "Error loading page"
    end
    
    local pageData = json.decode(pageResponse.content)
    
    local pages = pageData.query.pages
    local pageId = nil
    for id, _ in pairs(pages) do
        pageId = id
        break
    end
    
    if not pageId or pageId == "-1" then
        return nil, "Page not found"
    end
    
    local pageInfo = pages[pageId]
    
    if not pageInfo or not pageInfo.extract then
        return nil, "Content not available"
    end
    
    local result = {
        title = pageInfo.title or pageTitle,
        summary = pageInfo.extract,
        imageUrl = pageInfo.thumbnail and pageInfo.thumbnail.source or nil,
        url = "https://id.wikipedia.org/wiki/" .. urlEncode(pageInfo.title:gsub(" ", "_"))
    }
    
    addToHistory(query, result.title)
    
    return result, nil
end

function formatResult(result)
    local formatted = "📚 *" .. result.title .. "*\n\n"
    
    local summary = result.summary
    if #summary > 1500 then
        summary = summary:sub(1, 1500) .. "..."
    end
    
    formatted = formatted .. summary .. "\n\n"
    formatted = formatted .. "🔗 *Link:* " .. result.url .. "\n"
    
    if result.imageUrl then
        formatted = formatted .. "🖼 *Image:* Available"
    end
    
    return formatted
end

function showHistory()
    local history = safeReadHistory()
    
    if not history.searches or #history.searches == 0 then
        return "📭 No searches in history"
    end
    
    local historyText = "📖 SEARCH HISTORY:\n\n"
    
    for i, search in ipairs(history.searches) do
        if i <= 10 then
            historyText = historyText .. i .. ". " .. search.query .. "\n"
            historyText = historyText .. "   📄 " .. search.title .. "\n"
            historyText = historyText .. "   📅 " .. search.date .. "\n\n"
        end
    end
    
    return historyText
end

function clearHistory()
    saveHistory({searches = {}})
    return "✅ History cleared!"
end

function showSearchMenu()
    local options = {
        "🔍 New Wikipedia search",
        "📖 View search history",
        "🗑️ Clear history",
        "📋 View API information",
        "🚪 Exit"
    }
    
    local choice = gg.choice(options, nil, "🌐 WIKIPEDIA SEARCH")
    
    if choice == 1 then
        local input = gg.prompt({"Enter your search query:"}, {""}, {"text"})
        
        if input and input[1] and input[1]:trim() ~= "" then
            local query = input[1]:trim()
            local result, error = searchWikipedia(query)
            
            if error then
                gg.alert("❌ ERROR\n\n" .. error)
            else
                local formatted = formatResult(result)
                gg.alert(formatted)
                
                if gg.copyText and gg.alert("📋 Copy result?", "Yes", "No") == 1 then
                    gg.copyText(formatted)
                    gg.toast("✅ Copied!")
                end
            end
        end
        
    elseif choice == 2 then
        local history = showHistory()
        gg.alert(history)
        
    elseif choice == 3 then
        local confirm = gg.alert("🗑️ Are you sure you want to clear all history?", "Yes", "No")
        if confirm == 1 then
            local message = clearHistory()
            gg.alert(message)
        end
        
    elseif choice == 4 then
        local apiInfo = [[
🌐 INDONESIAN WIKIPEDIA API

📊 Endpoint: id.wikipedia.org
🔍 Features:
   • Article search
   • Content extraction
   • Thumbnail images
   • Links to full articles

📚 Source: Wikipedia Bahasa Indonesia
⚡ Status: Online

📱 This script uses Wikipedia's public API to search for information about any topic.
]]
        gg.alert(apiInfo)
        
    elseif choice == 5 then
        return false
    end
    
    return true
end

function main()
    gg.alert("🌐 WELCOME TO WIKIPEDIA SEARCHER\n\nSearch information about any topic directly from Indonesian Wikipedia.")
    
    local continuee = true
    while continuee do
        continuee = showSearchMenu()
    end
    
    gg.toast("👋 Goodbye!")
end

main()