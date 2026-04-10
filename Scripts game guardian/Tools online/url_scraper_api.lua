gg.setVisible(true)

local key = "YOUR_API_KEY"


local function urlencode(str)
    if str then
        str = string.gsub(str, "\n", "\r\n")
        str = string.gsub(str, "([^%w %-%_%.%~])",
            function(c) return string.format("%%%02X", string.byte(c)) end)
        str = string.gsub(str, " ", "+")
    end
    return str
end

local json = nil
if not pcall(function()
    json = load(gg.makeRequest("https://raw.githubusercontent.com/rxi/json.lua/master/json.lua").content)()
end) then
    json = require("json")
    if not json then 
        gg.alert("JSON library not available")
        return 
    end
end

local scrapeSettings = {
    js_render = true,
    premium_proxy = false,
    wait = 5000,
    wait_for = "",
    custom_headers = true
}

local function scrapeWebsite(url, options)
    options = options or {}
    
    local params = {
        apikey = key,
        url = urlencode(url)
    }
    
    if options.js_render then params.js_render = "true" end
    if options.premium_proxy then params.premium_proxy = "true" end
    if options.wait then params.wait = tostring(options.wait) end
    if options.wait_for then params.wait_for = options.wait_for end
    if options.custom_headers then params.custom_headers = "true" end
    
    local queryString = ""
    for k, v in pairs(params) do
        if queryString ~= "" then queryString = queryString .. "&" end
        queryString = queryString .. k .. "=" .. v
    end
    
    local apiUrl = "https://api.zenrows.com/v1/?" .. queryString
    
    local headers = {}
    if options.custom_headers then
        headers["Referer"] = "https://www.bing.com/"
        headers["User-Agent"] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"
    end
    
    gg.toast("Scraping website...")
    local response = gg.makeRequest(apiUrl, headers)
    
    return response
end

local function searchPredefinedSites()
    local predefinedSites = {
        {
            name = "Wikipedia Search",
            url_template = "https://en.wikipedia.org/wiki/Special:Search?search=%s",
            description = "Search on Wikipedia"
        },
        {
            name = "GitHub Search",
            url_template = "https://github.com/search?q=%s",
            description = "Search repositories on GitHub"
        },
        {
            name = "Stack Overflow Search",
            url_template = "https://stackoverflow.com/search?q=%s",
            description = "Search questions on Stack Overflow"
        },
        {
            name = "Reddit Search",
            url_template = "https://www.reddit.com/search/?q=%s",
            description = "Search posts on Reddit"
        },
        {
            name = "DuckDuckGo Search",
            url_template = "https://duckduckgo.com/?q=%s",
            description = "Search on DuckDuckGo"
        },
        {
            name = "Bing Search",
            url_template = "https://www.bing.com/search?q=%s",
            description = "Search on Bing"
        },
        {
            name = "Medium Search",
            url_template = "https://medium.com/search?q=%s",
            description = "Search articles on Medium"
        }
    }
    
    local siteNames = {}
    for i, site in ipairs(predefinedSites) do
        table.insert(siteNames, site.name .. " - " .. site.description)
    end
    
    local choice = gg.choice(siteNames, nil, "Select search site:")
    
    if choice then
        local selectedSite = predefinedSites[choice]
        
        local searchInput = gg.prompt({
            'Enter search term:'
        }, {
            'test search'
        }, {
            'text'
        })
        
        if searchInput and searchInput[1] then
            local searchTerm = urlencode(searchInput[1])
            local finalUrl = string.format(selectedSite.url_template, searchTerm)
            
            gg.alert("Searching: " .. selectedSite.name .. "\nQuery: " .. searchInput[1] .. "\nURL: " .. finalUrl)
            
            local response = scrapeWebsite(finalUrl, scrapeSettings)
            
            if type(response) == "table" then
                if response.code == 200 then
                    local contentPreview = response.content
                    if #contentPreview > 1000 then
                        contentPreview = contentPreview:sub(1, 1000) .. "..."
                    end
                    
                    local resultMessage = "✅ " .. selectedSite.name .. " - Search Successful!\n\n"
                    resultMessage = resultMessage .. "Search Term: " .. searchInput[1] .. "\n"
                    resultMessage = resultMessage .. "Status Code: " .. (response.code or "N/A") .. "\n"
                    resultMessage = resultMessage .. "Content Length: " .. (#response.content or 0) .. " bytes\n\n"
                    resultMessage = resultMessage .. "Preview:\n" .. contentPreview
                    
                    gg.alert(resultMessage)
                    
                    local fileName = "/sdcard/Download/search_" .. selectedSite.name:gsub(" ", "_") .. "_" .. os.time() .. ".html"
                    local file = io.open(fileName, "w")
                    if file then
                        file:write(response.content)
                        file:close()
                        gg.toast("Full content saved to: " .. fileName)
                    end
                    
                else
                    local errorMessage = "❌ " .. selectedSite.name .. " - Search Failed!\n\n"
                    errorMessage = errorMessage .. "Status Code: " .. (response.code or "N/A") .. "\n"
                    
                    if response.content then
                        errorMessage = errorMessage .. "Response: " .. response.content
                    end
                    
                    gg.alert(errorMessage)
                end
            else
                gg.alert("❌ Invalid response from API for " .. selectedSite.name)
            end
        end
    end
end

local function customUrlScraping()
    local urlInput = gg.prompt({
        'Enter URL:'
    }, {
        'https://example.com'
    }, {
        'text'
    })

    if urlInput and urlInput[1] then
        local url = urlInput[1]
        
        local response = scrapeWebsite(url, scrapeSettings)
        
        if type(response) == "table" then
            if response.code == 200 then
                local contentPreview = response.content
                if #contentPreview > 1000 then
                    contentPreview = contentPreview:sub(1, 1000) .. "..."
                end
                
                local resultMessage = "✅ Scraping Successful!\n\n"
                resultMessage = resultMessage .. "Status Code: " .. (response.code or "N/A") .. "\n"
                resultMessage = resultMessage .. "Content Length: " .. (#response.content or 0) .. " bytes\n\n"
                resultMessage = resultMessage .. "Preview:\n" .. contentPreview
                
                gg.alert(resultMessage)
                
                local fileName = "/sdcard/Download/scrape_custom_" .. os.time() .. ".html"
                local file = io.open(fileName, "w")
                if file then
                    file:write(response.content)
                    file:close()
                    gg.toast("Full content saved to: " .. fileName)
                end
                
            else
                local errorMessage = "❌ Scraping Failed!\n\n"
                errorMessage = errorMessage .. "Status Code: " .. (response.code or "N/A") .. "\n"
                
                if response.content then
                    errorMessage = errorMessage .. "Response: " .. response.content
                end
                
                gg.alert(errorMessage)
            end
        else
            gg.alert("❌ Invalid response from API")
        end
    end
end

local function settingsMenu()
    while true do
        local settingsChoice = gg.choice({
            "JavaScript Render: " .. tostring(scrapeSettings.js_render),
            "Premium Proxy: " .. tostring(scrapeSettings.premium_proxy),
            "Wait Time: " .. scrapeSettings.wait .. "ms",
            "Wait For Selector: " .. (scrapeSettings.wait_for ~= "" and scrapeSettings.wait_for or "Not set"),
            "Custom Headers: " .. tostring(scrapeSettings.custom_headers),
            "Back to Main Menu"
        }, nil, "Scraping Settings:")
        
        if not settingsChoice then break end
        
        if settingsChoice == 1 then
            local toggle = gg.choice({"true", "false"}, nil, "JavaScript Render:")
            if toggle then
                scrapeSettings.js_render = toggle == 1
            end
        elseif settingsChoice == 2 then
            local toggle = gg.choice({"true", "false"}, nil, "Premium Proxy:")
            if toggle then
                scrapeSettings.premium_proxy = toggle == 1
            end
        elseif settingsChoice == 3 then
            local waitInput = gg.prompt({
                'Wait Time (ms):'
            }, {
                tostring(scrapeSettings.wait)
            }, {
                'number'
            })
            if waitInput then
                scrapeSettings.wait = tonumber(waitInput[1]) or 5000
            end
        elseif settingsChoice == 4 then
            local selectorInput = gg.prompt({
                'CSS Selector (leave empty to disable):'
            }, {
                scrapeSettings.wait_for
            }, {
                'text'
            })
            if selectorInput then
                scrapeSettings.wait_for = selectorInput[1]
            end
        elseif settingsChoice == 5 then
            local toggle = gg.choice({"true", "false"}, nil, "Custom Headers:")
            if toggle then
                scrapeSettings.custom_headers = toggle == 1
            end
        elseif settingsChoice == 6 then
            break
        end
    end
end

local function showMainMenu()
    while true do
        local choice = gg.choice({
            "Custom URL Scraping",
            "Search on Sites", 
            "Settings",
            "Exit"
        }, nil, "ZenRows Web Scraper - Select Option:")
        
        if not choice then break end
        
        if choice == 1 then
            customUrlScraping()
        elseif choice == 2 then
            searchPredefinedSites()
        elseif choice == 3 then
            settingsMenu()
        elseif choice == 4 then
            break
        end
    end
end

showMainMenu()