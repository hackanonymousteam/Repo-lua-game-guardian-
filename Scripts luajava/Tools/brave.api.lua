gg.setVisible(true)
if not string.lower then return end

local braveApiKey = "YOUR_API_KEY"  


local json = nil
if not pcall(function()
    json = load(gg.makeRequest("https://raw.githubusercontent.com/rxi/json.lua/master/json.lua").content)()
end) then
    json = require("json") or gg.alert("JSON library not available")
    if not json then return end
end

local SEARCH_FILE = "brave_search.json"

function decodeHTMLEntities(text)
    if not text then return "" end
    
    local entities = {
        ["&amp;"] = "&",
        ["&lt;"] = "<",
        ["&gt;"] = ">",
        ["&quot;"] = '"',
        ["&#039;"] = "'",
        ["&#x27;"] = "'",
        ["&#x2F;"] = "/",
        ["&#x2f;"] = "/",
        ["&#x3D;"] = "=",
        ["&#x3d;"] = "=",
        ["&#x2019;"] = "'",
        ["&#x201c;"] = '"',
        ["&#x201d;"] = '"',
        ["&#x2013;"] = "-",
        ["&#x2014;"] = "--",
        ["&#x2026;"] = "...",
        ["&#x27;"] = "'",
        ["&apos;"] = "'",
        ["&nbsp;"] = " ",
        ["&iexcl;"] = "¡",
        ["&cent;"] = "¢",
        ["&pound;"] = "£",
        ["&curren;"] = "¤",
        ["&yen;"] = "¥",
        ["&brvbar;"] = "¦",
        ["&sect;"] = "§",
        ["&uml;"] = "¨",
        ["&copy;"] = "©",
        ["&ordf;"] = "ª",
        ["&laquo;"] = "«",
        ["&not;"] = "¬",
        ["&reg;"] = "®",
        ["&macr;"] = "¯",
        ["&deg;"] = "°",
        ["&plusmn;"] = "±",
        ["&sup2;"] = "²",
        ["&sup3;"] = "³",
        ["&acute;"] = "´",
        ["&micro;"] = "µ",
        ["&para;"] = "¶",
        ["&middot;"] = "·",
        ["&cedil;"] = "¸",
        ["&sup1;"] = "¹",
        ["&ordm;"] = "º",
        ["&raquo;"] = "»",
        ["&frac14;"] = "¼",
        ["&frac12;"] = "½",
        ["&frac34;"] = "¾",
        ["&iquest;"] = "¿",
        ["&times;"] = "×",
        ["&divide;"] = "÷",
        ["&Agrave;"] = "À",
        ["&Aacute;"] = "Á",
        ["&Acirc;"] = "Â",
        ["&Atilde;"] = "Ã",
        ["&Auml;"] = "Ä",
        ["&Aring;"] = "Å",
        ["&AElig;"] = "Æ",
        ["&Ccedil;"] = "Ç",
        ["&Egrave;"] = "È",
        ["&Eacute;"] = "É",
        ["&Ecirc;"] = "Ê",
        ["&Euml;"] = "Ë",
        ["&Igrave;"] = "Ì",
        ["&Iacute;"] = "Í",
        ["&Icirc;"] = "Î",
        ["&Iuml;"] = "Ï",
        ["&ETH;"] = "Ð",
        ["&Ntilde;"] = "Ñ",
        ["&Ograve;"] = "Ò",
        ["&Oacute;"] = "Ó",
        ["&Ocirc;"] = "Ô",
        ["&Otilde;"] = "Õ",
        ["&Ouml;"] = "Ö",
        ["&Oslash;"] = "Ø",
        ["&Ugrave;"] = "Ù",
        ["&Uacute;"] = "Ú",
        ["&Ucirc;"] = "Û",
        ["&Uuml;"] = "Ü",
        ["&Yacute;"] = "Ý",
        ["&THORN;"] = "Þ",
        ["&szlig;"] = "ß",
        ["&agrave;"] = "à",
        ["&aacute;"] = "á",
        ["&acirc;"] = "â",
        ["&atilde;"] = "ã",
        ["&auml;"] = "ä",
        ["&aring;"] = "å",
        ["&aelig;"] = "æ",
        ["&ccedil;"] = "ç",
        ["&egrave;"] = "è",
        ["&eacute;"] = "é",
        ["&ecirc;"] = "ê",
        ["&euml;"] = "ë",
        ["&igrave;"] = "ì",
        ["&iacute;"] = "í",
        ["&icirc;"] = "î",
        ["&iuml;"] = "ï",
        ["&eth;"] = "ð",
        ["&ntilde;"] = "ñ",
        ["&ograve;"] = "ò",
        ["&oacute;"] = "ó",
        ["&ocirc;"] = "ô",
        ["&otilde;"] = "õ",
        ["&ouml;"] = "ö",
        ["&oslash;"] = "ø",
        ["&ugrave;"] = "ù",
        ["&uacute;"] = "ú",
        ["&ucirc;"] = "û",
        ["&uuml;"] = "ü",
        ["&yacute;"] = "ý",
        ["&thorn;"] = "þ",
        ["&yuml;"] = "ÿ",
        ["&OElig;"] = "Œ",
        ["&oelig;"] = "œ",
        ["&Scaron;"] = "Š",
        ["&scaron;"] = "š",
        ["&Yuml;"] = "Ÿ",
        ["&fnof;"] = "ƒ",
        ["&circ;"] = "ˆ",
        ["&tilde;"] = "˜",
        ["&Alpha;"] = "Α",
        ["&Beta;"] = "Β",
        ["&Gamma;"] = "Γ",
        ["&Delta;"] = "Δ",
        ["&Epsilon;"] = "Ε",
        ["&Zeta;"] = "Ζ",
        ["&Eta;"] = "Η",
        ["&Theta;"] = "Θ",
        ["&Iota;"] = "Ι",
        ["&Kappa;"] = "Κ",
        ["&Lambda;"] = "Λ",
        ["&Mu;"] = "Μ",
        ["&Nu;"] = "Ν",
        ["&Xi;"] = "Ξ",
        ["&Omicron;"] = "Ο",
        ["&Pi;"] = "Π",
        ["&Rho;"] = "Ρ",
        ["&Sigma;"] = "Σ",
        ["&Tau;"] = "Τ",
        ["&Upsilon;"] = "Υ",
        ["&Phi;"] = "Φ",
        ["&Chi;"] = "Χ",
        ["&Psi;"] = "Ψ",
        ["&Omega;"] = "Ω",
        ["&alpha;"] = "α",
        ["&beta;"] = "β",
        ["&gamma;"] = "γ",
        ["&delta;"] = "δ",
        ["&epsilon;"] = "ε",
        ["&zeta;"] = "ζ",
        ["&eta;"] = "η",
        ["&theta;"] = "θ",
        ["&iota;"] = "ι",
        ["&kappa;"] = "κ",
        ["&lambda;"] = "λ",
        ["&mu;"] = "μ",
        ["&nu;"] = "ν",
        ["&xi;"] = "ξ",
        ["&omicron;"] = "ο",
        ["&pi;"] = "π",
        ["&rho;"] = "ρ",
        ["&sigmaf;"] = "ς",
        ["&sigma;"] = "σ",
        ["&tau;"] = "τ",
        ["&upsilon;"] = "υ",
        ["&phi;"] = "φ",
        ["&chi;"] = "χ",
        ["&psi;"] = "ψ",
        ["&omega;"] = "ω",
        ["&thetasym;"] = "ϑ",
        ["&upsih;"] = "ϒ",
        ["&piv;"] = "ϖ",
        ["&bull;"] = "•",
        ["&hellip;"] = "…",
        ["&prime;"] = "′",
        ["&Prime;"] = "″",
        ["&oline;"] = "‾",
        ["&frasl;"] = "⁄",
        ["&weierp;"] = "℘",
        ["&image;"] = "ℑ",
        ["&real;"] = "ℜ",
        ["&trade;"] = "™",
        ["&alefsym;"] = "ℵ",
        ["&larr;"] = "←",
        ["&uarr;"] = "↑",
        ["&rarr;"] = "→",
        ["&darr;"] = "↓",
        ["&harr;"] = "↔",
        ["&crarr;"] = "↵",
        ["&lArr;"] = "⇐",
        ["&uArr;"] = "⇑",
        ["&rArr;"] = "⇒",
        ["&dArr;"] = "⇓",
        ["&hArr;"] = "⇔",
        ["&forall;"] = "∀",
        ["&part;"] = "∂",
        ["&exist;"] = "∃",
        ["&empty;"] = "∅",
        ["&nabla;"] = "∇",
        ["&isin;"] = "∈",
        ["&notin;"] = "∉",
        ["&ni;"] = "∋",
        ["&prod;"] = "∏",
        ["&sum;"] = "∑",
        ["&minus;"] = "−",
        ["&lowast;"] = "∗",
        ["&radic;"] = "√",
        ["&prop;"] = "∝",
        ["&infin;"] = "∞",
        ["&ang;"] = "∠",
        ["&and;"] = "∧",
        ["&or;"] = "∨",
        ["&cap;"] = "∩",
        ["&cup;"] = "∪",
        ["&int;"] = "∫",
        ["&there4;"] = "∴",
        ["&sim;"] = "∼",
        ["&cong;"] = "≅",
        ["&asymp;"] = "≈",
        ["&ne;"] = "≠",
        ["&equiv;"] = "≡",
        ["&le;"] = "≤",
        ["&ge;"] = "≥",
        ["&sub;"] = "⊂",
        ["&sup;"] = "⊃",
        ["&nsub;"] = "⊄",
        ["&sube;"] = "⊆",
        ["&supe;"] = "⊇",
        ["&oplus;"] = "⊕",
        ["&otimes;"] = "⊗",
        ["&perp;"] = "⊥",
        ["&sdot;"] = "⋅",
        ["&lceil;"] = "⌈",
        ["&rceil;"] = "⌉",
        ["&lfloor;"] = "⌊",
        ["&rfloor;"] = "⌋",
        ["&lang;"] = "⟨",
        ["&rang;"] = "⟩",
        ["&loz;"] = "◊",
        ["&spades;"] = "♠",
        ["&clubs;"] = "♣",
        ["&hearts;"] = "♥",
        ["&diams;"] = "♦",
        ["&lsquo;"] = "'",
        ["&rsquo;"] = "'",
        ["&ldquo;"] = '"',
        ["&rdquo;"] = '"',
        ["&sbquo;"] = "'",
        ["&bdquo;"] = '"',
        ["&dagger;"] = "†",
        ["&Dagger;"] = "‡",
        ["&permil;"] = "‰",
        ["&lsaquo;"] = "‹",
        ["&rsaquo;"] = "›",
        ["&euro;"] = "€"
    }
    
    text = text:gsub("&#(%d+);", function(n) return string.char(tonumber(n)) end)
    text = text:gsub("&#[xX](%x+);", function(n) return string.char(tonumber(n, 16)) end)
    
    for entity, char in pairs(entities) do
        text = text:gsub(entity, char)
    end
    
    return text
end

function cleanHtmlText(text)
    if not text then return "" end
    
    text = text:gsub("<style[^>]*>.-</style>", " ")
    text = text:gsub("<script[^>]*>.-</script>", " ")
    text = text:gsub("<[^>]+>", " ")
    text = text:gsub("%s+", " ")
    text = decodeHTMLEntities(text)
    text = text:gsub("%s+", " ")
    text = text:gsub("^%s+", "")
    text = text:gsub("%s+$", "")
    
    return text
end

function cleanUrl(url)
    if not url then return "" end
    url = url:gsub(",", ".")
    return url
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
    
    if fileExists(SEARCH_FILE) then
        local file = io.open(SEARCH_FILE, "r")
        if file then
            local content = file:read("*a")
            file:close()
            
            if content and content ~= "" then
                local success, result = pcall(json.decode, content)
                if success then
                    historyData = result
                else
                    gg.toast("Error reading search history")
                end
            end
        end
    end
    
    return historyData
end

function saveHistory(historyData)
    local file = io.open(SEARCH_FILE, "w")
    if file then
        file:write(json.encode(historyData))
        file:close()
        return true
    end
    return false
end

function getUserHistory(uid)
    local history = safeReadHistory()
    return history[tostring(uid)] or {searches = {}}
end

function saveUserHistory(uid, userHistory)
    local history = safeReadHistory()
    history[tostring(uid)] = userHistory
    return saveHistory(history)
end

function deleteUserHistory(uid)
    local history = safeReadHistory()
    history[tostring(uid)] = nil
    return saveHistory(history)
end

function searchBrave(query, country, searchLang, count)
    local headers = {
        ["Accept"] = "application/json",
        ["X-Subscription-Token"] = braveApiKey
    }
    
    local baseUrl = "https://api.search.brave.com/res/v1/web/search"
    local params = "q=" .. query
    
    if count then
        params = params .. "&count=" .. tostring(count)
    end
    
    if country and country ~= "" then
        params = params .. "&country=" .. country
    end
    
    if searchLang and searchLang ~= "" then
        params = params .. "&search_lang=" .. searchLang
    end
    
    local url = baseUrl .. "?" .. params
    
    gg.toast("Searching Brave...")
    local response = gg.makeRequest(url, headers)
    
    if type(response) ~= "table" then
        return nil, "Error: invalid API response"
    end
    
    if response.code ~= 200 then
        local errorMsg = "Search error (Code " .. tostring(response.code) .. ")\n"
        if response.content then
            local success, errorData = pcall(json.decode, response.content)
            if success and errorData then
                if errorData.error then
                    errorMsg = errorMsg .. "Details: " .. tostring(errorData.error)
                elseif errorData.message then
                    errorMsg = errorMsg .. "Message: " .. tostring(errorData.message)
                else
                    errorMsg = errorMsg .. "Response: " .. response.content:sub(1, 200)
                end
            else
                errorMsg = errorMsg .. "Response: " .. response.content:sub(1, 200)
            end
        end
        return nil, errorMsg
    end
    
    if not response.content or response.content == "" then
        return nil, "Error: empty API response"
    end
    
    local success, result = pcall(json.decode, response.content)
    if not success then
        return nil, "Error processing API response"
    end
    
    return result, nil
end

function formatSearchResults(searchData, query)
    if not searchData or not searchData.web or not searchData.web.results then
        return "No results found for: " .. query
    end
    
    local results = searchData.web.results
    if #results == 0 then
        return "No results found for: " .. query
    end
    
    local formatted = "Search results: " .. query .. "\n" .. string.rep("-", 40) .. "\n\n"
    
    for i, result in ipairs(results) do
        if i > 5 then break end
        
        local title = cleanHtmlText(result.title or "No title")
        local url = cleanUrl(result.url or "No URL")
        local description = cleanHtmlText(result.description or "No description")
        
        if #description > 300 then
            local breakPoint = description:find("%. ", 200)
            if breakPoint then
                description = description:sub(1, breakPoint)
            else
                description = description:sub(1, 297) .. "..."
            end
        end
        
        formatted = formatted .. i .. ". " .. title .. "\n"
        formatted = formatted .. "   Link: " .. url .. "\n"
        formatted = formatted .. "   Description: " .. description .. "\n\n"
    end
    
    return formatted
end

function formatWebResults(searchData)
    if not searchData or not searchData.web or not searchData.web.results then
        return {}
    end
    
    local results = {}
    for i, result in ipairs(searchData.web.results) do
        if i > 5 then break end
        table.insert(results, {
            title = cleanHtmlText(result.title or "No title"),
            url = cleanUrl(result.url or "No URL"),
            description = cleanHtmlText(result.description or "No description")
        })
    end
    
    return results
end

function saveSearchToHistory(uid, query, searchData)
    local userHistory = getUserHistory(uid)
    local results = formatWebResults(searchData)
    
    table.insert(userHistory.searches, {
        query = query,
        timestamp = os.time(),
        results_count = #results,
        results = results
    })
    
    while #userHistory.searches > 50 do
        table.remove(userHistory.searches, 1)
    end
    
    saveUserHistory(uid, userHistory)
end

function getHistorySummary(uid)
    local userHistory = getUserHistory(uid)
    
    if #userHistory.searches == 0 then
        return "No previous searches found."
    end
    
    local summary = "Search History (last 10):\n" .. string.rep("-", 40) .. "\n\n"
    local start = math.max(1, #userHistory.searches - 9)
    
    for i = start, #userHistory.searches do
        local search = userHistory.searches[i]
        local date = os.date("%m/%d/%Y %H:%M", search.timestamp)
        summary = summary .. (i - start + 1) .. ". [" .. date .. "] " .. search.query .. "\n"
        summary = summary .. "   Results: " .. search.results_count .. "\n\n"
    end
    
    return summary
end

function clearHistory(uid)
    deleteUserHistory(uid)
    return "Search history cleared successfully!"
end

function testApiKey()
    gg.toast("Testing API key...")
    local testData, error = searchBrave("test", nil, nil, 1)
    
    if error then
        return false, error
    end
    
    if testData and testData.web then
        return true, "Valid API key! Ready to search."
    else
        return false, "Invalid API key or no permission"
    end
end

local function main()
    local menu = gg.choice({
        "New web search",
        "View search history",
        "Clear history",
        "Test API key",
        "Settings",
        "Exit"
    }, nil, "Brave Search - Web Search")
    
    if not menu then
        return
    end
    
    if menu == 1 then
        local input = gg.prompt({
            "Enter your search:",
            "User ID (optional):",
            "Country (ex: BR, US - Enter for default):",
            "Language (ex: pt, en - Enter for default):",
            "Results (1-10):"
        }, {"", "user123", "", "", "5"}, 
        {"text", "text", "text", "text", "number"})
        
        if not input or not input[1] or input[1] == "" then
            gg.alert("Search cancelled or empty!")
            main()
            return
        end
        
        local query = input[1]
        local uid = input[2] ~= "" and input[2] or "user123"
        local country = input[3] ~= "" and input[3] or nil
        local searchLang = input[4] ~= "" and input[4] or nil
        local count = tonumber(input[5]) or 5
        count = math.max(1, math.min(10, count))
        
        if query:lower() == "history" then
            gg.alert(getHistorySummary(uid))
            main()
            return
        end
        
        if query:lower() == "clear" then
            gg.alert(clearHistory(uid))
            main()
            return
        end
        
        gg.toast("Searching...")
        local startTime = os.time()
        
        local searchData, errorMsg = searchBrave(query, country, searchLang, count)
        
        local endTime = os.time()
        local elapsed = string.format("%.2f", os.difftime(endTime, startTime))
        
        if errorMsg then
            gg.alert(errorMsg)
            main()
            return
        end
        
        saveSearchToHistory(uid, query, searchData)
        
        local formattedResults = formatSearchResults(searchData, query)
        formattedResults = formattedResults .. "Time: " .. elapsed .. " seconds"
        
        local choice = gg.alert(formattedResults, "Copy", "New search", "History", "Close")
        
        if choice == 1 then
            gg.copyText(formattedResults)
            gg.toast("Results copied!")
        elseif choice == 2 then
            main()
        elseif choice == 3 then
            gg.alert(getHistorySummary(uid))
            main()
        end
        
    elseif menu == 2 then
        local input = gg.prompt({
            "User ID:"
        }, {"user123"}, {"text"})
        
        if input and input[1] then
            local uid = input[1] ~= "" and input[1] or "user123"
            gg.alert(getHistorySummary(uid))
        end
        main()
        
    elseif menu == 3 then
        local input = gg.prompt({
            "User ID:"
        }, {"user123"}, {"text"})
        
        if input and input[1] then
            local uid = input[1] ~= "" and input[1] or "user123"
            local confirm = gg.alert(
                "Are you sure you want to clear the history for " .. uid .. "?",
                "Yes", "No"
            )
            
            if confirm == 1 then
                gg.alert(clearHistory(uid))
            end
        end
        main()
        
    elseif menu == 4 then
        local success, message = testApiKey()
        gg.alert(message)
        main()
        
    elseif menu == 5 then
        local input = gg.prompt({
            "Brave API Key:",
            "Default country (Enter for BR):",
            "Default language (Enter for pt):",
            "Default results (1-10):"
        }, {braveApiKey, "BR", "pt", "5"}, 
        {"text", "text", "text", "number"})
        
        if input then
            if input[1] ~= "" then
                braveApiKey = input[1]
                gg.toast("API key updated!")
            end
            
            local config = {
                default_country = input[2] ~= "" and input[2] or "BR",
                default_lang = input[3] ~= "" and input[3] or "pt",
                default_count = tonumber(input[4]) or 5
            }
            
            local file = io.open("brave_config.json", "w")
            if file then
                file:write(json.encode(config))
                file:close()
                gg.toast("Settings saved!")
            end
        end
        main()
    end
end

gg.toast("Brave Search started!")
main()