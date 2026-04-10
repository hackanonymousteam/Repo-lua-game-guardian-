
local Link = "https://browserleaks.com/ip"
local bat = gg.makeRequest(Link).content

if bat == nil then
    os.exit()
end

local response = bat

local function extractDataIPFromHTML(html)
    local pattern = 'data%-ip%="([%d%.]+)"'
    local dataIP = html:match(pattern)
    return dataIP
end

local dataIP = extractDataIPFromHTML(response)

if not dataIP then
    print('Error.')
else
    print('IP USER:', dataIP)
    
end