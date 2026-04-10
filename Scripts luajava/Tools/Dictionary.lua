gg.setVisible(true)


local SERPER_API_KEY = ""
local SAPLING_API_KEY = ""

local json = nil
if not pcall(function()
    json = load(gg.makeRequest("https://raw.githubusercontent.com/rxi/json.lua/master/json.lua").content)()
end) then
    json = require("json") or gg.alert("JSON library error")
    if not json then return end
end

local searchCache = {}

function makeApiRequest(url, method, headers, body)
    local response = gg.makeRequest(url, headers, body, method)
    
    if type(response) ~= "table" then
        return nil, "Connection error"
    end
    
    if response.code ~= 200 then
        return nil, "HTTP " .. tostring(response.code)
    end
    
    local success, data = pcall(json.decode, response.content)
    if not success then
        return nil, "Invalid JSON"
    end
    
    return data
end

function correctText(text)
    if not text or text:trim() == "" then 
        return text 
    end
    
    local payload = {
        key = SAPLING_API_KEY,
        text = text,
        session_id = "gg-" .. os.time()
    }
    
    local headers = {
        ["Content-Type"] = "application/json"
    }
    
    gg.toast("Correcting...")
    
    local data, error = makeApiRequest(
        "https://api.sapling.ai/api/v1/edits",
        "POST",
        headers,
        json.encode(payload)
    )
    
    if error then
        gg.toast("Error: " .. error)
        return text
    end
    
    if not data or not data.edits or #data.edits == 0 then
        return text
    end
    
    local corrected = text
    local edits = data.edits
    
    table.sort(edits, function(a, b)
        return (a.start or 0) > (b.start or 0)
    end)
    
    for _, edit in ipairs(edits) do
        if edit.replacement and edit.start and edit["end"] then
            local startIdx = edit.start + 1
            local endIdx = edit["end"] + 1
            
            if startIdx >= 1 and endIdx <= #corrected and endIdx >= startIdx then
                corrected = corrected:sub(1, startIdx - 1) .. 
                           edit.replacement .. 
                           corrected:sub(endIdx + 1)
            end
        end
    end
    
    return corrected
end

function searchGoogle(query)
    local cacheKey = query:lower():gsub("%s+", " ")
    if searchCache[cacheKey] then
        gg.toast("Using cache...")
        return searchCache[cacheKey], nil
    end
    
    local payload = {
        q = query,
        gl = "br",
        hl = "pt-br",
        num = 8
    }
    
    local headers = {
        ["X-API-KEY"] = SERPER_API_KEY,
        ["Content-Type"] = "application/json"
    }
    
    gg.toast("Searching Google...")
    
    local data, error = makeApiRequest(
        "https://google.serper.dev/search",
        "POST",
        headers,
        json.encode(payload)
    )
    
    if error then
        return nil, error
    end
    
    local results = {}
    
    if data.answerBox then
        if data.answerBox.snippet then
            table.insert(results, data.answerBox.snippet)
        end
        if data.answerBox.title then
            table.insert(results, data.answerBox.title)
        end
    end
    
    if data.knowledgeGraph then
        if data.knowledgeGraph.description then
            table.insert(results, data.knowledgeGraph.description)
        end
        if data.knowledgeGraph.title then
            table.insert(results, data.knowledgeGraph.title)
        end
    end
    
    if data.organic and #data.organic > 0 then
        for i, item in ipairs(data.organic) do
            if i <= 5 then
                local snippet = item.snippet or item.title or ""
                if snippet:trim() ~= "" then
                    table.insert(results, snippet)
                end
            end
        end
    end
    
    if data.peopleAlsoAsk and #data.peopleAlsoAsk > 0 then
        for i, item in ipairs(data.peopleAlsoAsk) do
            if i <= 3 then
                table.insert(results, item.question)
            end
        end
    end
    
    if #results == 0 then
        return nil, "No results found"
    end
    
    local combinedText = table.concat(results, "\n\n")
    searchCache[cacheKey] = combinedText
    
    return combinedText, nil
end

function summarizeText(text)
    if not text or text:trim() == "" then
        return "No content"
    end
    
    if #text > 1000 then
        text = text:sub(1, 1000) .. "..."
    end
    
    gg.toast("Summarizing...")
    
    local improvedText = correctText(text)
    
    local sentences = {}
    for sentence in improvedText:gmatch("[^.!?\n]+[.!?\n]?") do
        local trimmed = sentence:trim()
        if trimmed ~= "" and #trimmed > 10 then
            table.insert(sentences, trimmed)
        end
    end
    
    local summarySentences = {}
    local maxSentences = math.min(4, #sentences)
    
    for i = 1, maxSentences do
        table.insert(summarySentences, sentences[i])
    end
    
    if #summarySentences == 0 then
        return improvedText
    end
    
    local summary = table.concat(summarySentences, " ")
    
    if summary:sub(-1) ~= "." then
        summary = summary .. "."
    end
    
    return summary
end

function intelligentSearch(query)
    local correctedQuery = correctText(query)
    local originalQuery = query
    
    if correctedQuery ~= query then
        gg.toast("Corrected")
    end
    
    local searchResults, searchError = searchGoogle(correctedQuery)
    
    if searchError then
        return nil, searchError
    end
    
    local summary = summarizeText(searchResults)
    
    return {
        original = originalQuery,
        corrected = correctedQuery,
        results = searchResults,
        summary = summary,
        timestamp = os.time()
    }
end

local function mainInterface()
    gg.alert("INTELLIGENT SEARCH\n\n1. Auto-correction\n2. Google search\n3. Smart summary")
    
    while true do
        local choice = gg.choice({
            "New Search",
            "Last Search",
            "API Settings",
            "About",
            "Exit"
        }, nil, "MAIN MENU")
        
        if choice == 1 then
            local input = gg.prompt({
                "Search query:",
                "Additional details:"
            }, {"", ""}, {"text", "text"})
            
            if input and input[1] and input[1]:trim() ~= "" then
                local query = input[1]:trim()
                if input[2] and input[2]:trim() ~= "" then
                    query = query .. " " .. input[2]:trim()
                end
                
                gg.toast("Processing...")
                local startTime = os.time()
                
                local result, error = intelligentSearch(query)
                
                local endTime = os.time()
                local timeTaken = endTime - startTime
                
                if error then
                    gg.alert("ERROR\n\n" .. error)
                else
                    local display = string.format("Time: %.1fs\n\nOriginal: %s\n\nCorrected: %s\n\nSummary: %s\n\nFull results (%d chars):\n%s",
                        timeTaken, result.original, result.corrected, 
                        result.summary, #result.results, 
                        result.results:sub(1, 500) .. (#result.results > 500 and "..." or ""))
                    
                    local action = gg.alert(display, "View Summary", "View All", "Copy Summary", "Back")
                    
                    if action == 1 then
                        gg.alert("SUMMARY:\n\n" .. result.summary)
                    elseif action == 2 then
                        gg.alert("FULL RESULTS:\n\n" .. result.results)
                    elseif action == 3 and gg.copyText then
                        gg.copyText(result.summary)
                        gg.toast("Copied!")
                    end
                end
            end
            
        elseif choice == 2 then
            local lastQuery = nil
            local lastResults = nil
            
            for query, results in pairs(searchCache) do
                lastQuery = query
                lastResults = results
                break
            end
            
            if lastQuery then
                gg.alert("LAST SEARCH:\n\nQuery: " .. lastQuery .. "\n\nResults:\n" .. lastResults:sub(1, 300) .. "...")
            else
                gg.alert("No search history")
            end
            
        elseif choice == 3 then
            local config = gg.prompt({
                "Serper API Key:",
                "Sapling API Key:"
            }, {SERPER_API_KEY, SAPLING_API_KEY}, {"text", "text"})
            
            if config then
                SERPER_API_KEY = config[1]
                SAPLING_API_KEY = config[2]
                searchCache = {}
                gg.toast("API keys updated, cache cleared")
            end
            
        elseif choice == 4 then
            gg.alert("INTELLIGENT SEARCH v2.0\n\nAPIs:\n• Serper (Google Search)\n• Sapling (Grammar)\n\nGet free keys:\n• serper.dev\n• sapling.ai")
            
        elseif choice == 5 then
            gg.toast("Goodbye!")
            break
        end
    end
end

function checkApiKeys()
    if SERPER_API_KEY == "" or SAPLING_API_KEY == "" then
        gg.alert("API KEYS REQUIRED\n\n1. Serper: https://serper.dev\n2. Sapling: https://sapling.ai\n\nConfigure now:")
        
        local config = gg.prompt({
            "Serper API Key:",
            "Sapling API Key:"
        }, {"", ""}, {"text", "text"})
        
        if config and config[1] and config[1]:trim() ~= "" and
           config[2] and config[2]:trim() ~= "" then
            SERPER_API_KEY = config[1]:trim()
            SAPLING_API_KEY = config[2]:trim()
            gg.toast("API keys configured!")
            return true
        else
            gg.alert("API keys required to use the app")
            return false
        end
    end
    return true
end

gg.toast("Loading...")

if checkApiKeys() then
    mainInterface()
else
    gg.alert("Please configure API keys and restart")
end