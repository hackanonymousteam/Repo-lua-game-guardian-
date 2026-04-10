
gg.setVisible(true)

local rssApiKey = "YOUR_API_KEY"
--GET YOUR API KEY IN https://api.rss2json.com
local json = nil

if not pcall(function()
    json = load(gg.makeRequest("https://raw.githubusercontent.com/rxi/json.lua/master/json.lua").content)()
end) then
    json = require("json") or gg.alert("JSON library not available")
    if not json then return end
end

local newsSites = {
    {
        name = "BBC News",
        url = "https://feeds.bbci.co.uk/news/rss.xml"
    },
    {
        name = "CNN International", 
        url = "https://rss.cnn.com/rss/edition.rss"
    },
    {
        name = "New York Times",
        url = "https://rss.nytimes.com/services/xml/rss/nyt/HomePage.xml"
    },
    {
        name = "G1 - Ultimas Noticias",
        url = "https://g1.globo.com/rss/g1/"
    },
    {
        name = "Reuters World News",
        url = "https://www.reutersagency.com/feed/?best-topics=world-news&post_type=best"
    },
    {
        name = "Science Daily", 
        url = "https://www.sciencedaily.com/rss/all.xml"
    },
    {
        name = "TechCrunch",
        url = "https://techcrunch.com/feed/"
    },
    {
        name = "IGN Games",
        url = "https://feeds.ign.com/ign/games-all"
    },
    {
        name = "ESPN Brasil",
        url = "https://www.espn.com.br/espn/rss/news"
    },
    {
        name = "Hollywood Reporter",
        url = "https://www.hollywoodreporter.com/feed/"
    }
}

local function urlencode(str)
    if str then
        str = string.gsub(str, "\n", "\r\n")
        str = string.gsub(str, "([^%w %-%_%.%~])",
            function(c) return string.format("%%%02X", string.byte(c)) end)
        str = string.gsub(str, " ", "+")
    end
    return str
end

local function stripHtml(html)
    if not html then return "" end
    return string.gsub(html, "<[^>]+>", "")
end

local siteOptions = {}
for i, site in ipairs(newsSites) do
    table.insert(siteOptions, site.name)
end
table.insert(siteOptions, "Custom URL")

local selected = gg.choice(siteOptions, nil, "Select news source:")

if not selected then
    gg.alert("Cancelled!")
    return
end

local rssUrl = ""
local siteName = ""

if selected == #siteOptions then
    local customInput = gg.prompt({
        'Enter RSS Feed URL:',
        'Number of articles (1-30):'
    }, {'https://', '10'}, {'text', 'number'})
    
    if customInput == nil then
        gg.alert("Cancelled!")
        return
    end
    
    rssUrl = customInput[1]
    siteName = "Custom URL"
else
    rssUrl = newsSites[selected].url
    siteName = newsSites[selected].name
end

local countInput = gg.prompt({
    'Number of articles to load (1-30):'
}, {'10'}, {'number'})

if countInput == nil then
    gg.alert("Cancelled!")
    return
end

local count = tonumber(countInput[1]) or 10
if count < 1 or count > 30 then
    count = 10
end

local encodedUrl = urlencode(rssUrl)
local apiUrl = string.format("https://api.rss2json.com/v1/api.json?rss_url=%s&api_key=%s&count=%d", 
                            encodedUrl, rssApiKey, count)

gg.toast("Fetching news...")
local response = gg.makeRequest(apiUrl)

if type(response) == "table" and response.code == 200 then
    local data = json.decode(response.content)
    
    if data and data.status == 'ok' then
        local feedInfo = string.format(
            "%s\n\n%s\n\n%d articles loaded from: %s",
            data.feed.title or "No title",
            data.feed.description or "No description",
            #data.items,
            siteName
        )
        
        local articlesText = "\n\n" .. string.rep("=", 50) .. "\nRECENT ARTICLES\n" .. string.rep("=", 50) .. "\n\n"
        
        for i, article in ipairs(data.items) do
            local title = article.title or "No title"
            local link = article.link or "#"
            local description = stripHtml(article.description or article.content or "")
            local pubDate = article.pubDate or "Unknown date"
            
            if pubDate ~= "Unknown date" then
                pubDate = string.sub(pubDate, 1, 16)
            end
            
            if #description > 150 then
                description = string.sub(description, 1, 150) .. "..."
            end
            
            if description == "" then
                description = "No description available"
            end
            
            articlesText = articlesText .. string.format(
                "Article %d: %s\nDate: %s\n\n%s\n\nLink: %s\n\n%s\n\n",
                i, title, pubDate, description, link, string.rep("-", 40)
            )
            
            if i >= 15 then
                articlesText = articlesText .. "\n[...] more articles available\n\n"
                break
            end
        end
        
        local fullMessage = feedInfo .. articlesText
        
        if #fullMessage > 5000 then
            local shortMessage = string.sub(fullMessage, 1, 5000) .. "\n\n[...] content truncated"
            gg.alert("News Feed:\n" .. shortMessage)
        else
            gg.alert("News Feed:\n" .. fullMessage)
        end
        
        if gg.copyText then
            if gg.alert("Copy first article link?", "Yes", "No") == 1 then
                if data.items[1] and data.items[1].link then
                    gg.copyText(data.items[1].link)
                    gg.toast("Link copied!")
                else
                    gg.alert("No link available to copy")
                end
            end
        end
        
    else
        gg.alert("Error processing RSS feed:\n" .. (data.message or "Unknown error"))
    end
else
    local errorMsg = "Request error:\n"
    
    if type(response) == "table" then
        errorMsg = errorMsg .. "Code: " .. (response.code or "N/A") .. "\n"
        if response.code == 401 then
            errorMsg = errorMsg .. "Invalid API key"
        elseif response.code == 403 then
            errorMsg = errorMsg .. "API access denied"
        elseif response.code == 404 then
            errorMsg = errorMsg .. "RSS URL not found"
        else
            errorMsg = errorMsg .. "Response: " .. (response.content or "None")
        end
    else
        errorMsg = errorMsg .. tostring(response)
    end
    
    gg.alert(errorMsg)
end