gg.setVisible(true)
local function urlencode(str)
    if str then
        str = string.gsub(str, "\n", "\r\n")
        str = string.gsub(str, "([^%w %-%_%.%~])",
            function(c) return string.format("%%%02X", string.byte(c)) end)
        str = string.gsub(str, " ", "+")
    end
    return str
end

local function searchTelegramChannels(query)
    gg.toast("Searching channels...")
    
    local url = "https://en.tgramsearch.com/search?query=" .. urlencode(query)
    
    local headers = {
        ["User-Agent"] = "Mozilla/5.0 (Linux; Android 13; Mobile) AppleWebKit/537.36 Safari/537.36"
    }
    
    local response = gg.makeRequest(url, headers)
    
    if type(response) == "table" and response.code == 200 then
        local channels = {}

        local content = response.content or ""
        
        for name in content:gmatch('tg%-channel%-link[^>]->%s*<a[^>]->([^<]-)</a>') do
            name = name:trim()
            if name ~= "" then
                table.insert(channels, {
                    name = name,
                    members = "Unknown",
                    description = "No description",
                    link = "https://t.me/" .. name:gsub("[^%w_]", ""):lower()
                })
            end
        end
     
        for i, channel in ipairs(channels) do
            local membersPattern = 'tg%-user%-count[^>]->([^<]-)</div>'
            local members = content:match(membersPattern)
            if members then
                channel.members = members:trim()
            end
        end
  
        for i, channel in ipairs(channels) do
            local descPattern = 'tg%-channel%-description[^>]->([^<]-)</div>'
            local description = content:match(descPattern)
            if description then
                channel.description = description:trim()
            end
        end
        
        if #channels > 0 then
            return channels, true
        else
            return "No channels found", false
        end
    else
        return "HTTP Error: " .. (response.code or "unknown"), false
    end
end

local function showChannelInfo(channels)
    local channelList = {}
    for i, channel in ipairs(channels) do
        local displayText = channel.name
        if channel.members ~= "Unknown" then
            displayText = displayText .. " 👥 " .. channel.members
        end
        table.insert(channelList, displayText)
    end
    
    local choice = gg.choice(channelList, nil, "📢 Telegram Channels Found: " .. #channels)
    
    if choice then
        local selectedChannel = channels[choice]
        local info = "📢 " .. selectedChannel.name .. "\n\n"
        info = info .. "👥 Members: " .. selectedChannel.members .. "\n\n"
        info = info .. "📝 Description: " .. selectedChannel.description .. "\n\n"
        info = info .. "🔗 Link: " .. selectedChannel.link
        
        local action = gg.choice(
            {"🔗 Open Link", "📋 Copy Link", "⬅️ Back"},
            nil,
            info
        )
        
        if action == 1 then
            gg.alert("Link: " .. selectedChannel.link .. "\n\nYou can open this in your browser or Telegram app")
        elseif action == 2 then
            gg.alert("Link copied to clipboard:\n" .. selectedChannel.link)
        end
        
        return true 
    end
    
    return false 
end

while true do
    local searchInput = gg.prompt({
        'Search Telegram channels:'
    }, {
        'technology'
    }, {
        'text'
    })
    
    if not searchInput or not searchInput[1] then
        break
    end
    
    local query = searchInput[1]
    local channels, success = searchTelegramChannels(query)
    
    if success then
        gg.alert("✅ Found " .. #channels .. " channels for: " .. query)
        
        while showChannelInfo(channels) do
        end
    else
        gg.alert("❌ Search failed:\n" .. channels)
        
        local retry = gg.choice(
            {"🔄 Try Again", "❌ Exit"},
            nil,
            "Search failed for: " .. query
        )
        if retry == 2 then
            break
        end
    end
end
