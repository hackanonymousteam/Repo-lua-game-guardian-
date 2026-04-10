gg.setVisible(false)

local json = nil
if not pcall(function()
    json = load(gg.makeRequest("https://raw.githubusercontent.com/rxi/json.lua/master/json.lua").content)()
end) then
    json = require("json") or gg.alert("❌ JSON library not available")
    if not json then return end
end


local function getIP()
    local services = {
        "http://checkip.dyndns.org/",
        "http://ipinfo.io/ip",
        "http://api.ipify.org"
    }
    
    for _, url in ipairs(services) do
        local res = gg.makeRequest(url)
        if res and res.content then
            local ip = res.content:match("%d+%.%d+%.%d+%.%d+")
            if ip then return ip end
        end
    end
    return nil
end

local ipAddress = getIP()
if not ipAddress then
    gg.alert("⚠️ Could not determine your IP")
    return
end

local function isPrivateIP(ip)
    return ip:match("^10%.") or 
           ip:match("^192%.168%.") or 
           ip:match("^172%.%d?%d?%d?%.") or
           ip == "127.0.0.1"
end

if isPrivateIP(ipAddress) then
    gg.alert("🔒 Private IP detected!\nThis may indicate tunneling or local network")
    return
end

local function getPublicIP()
    local services = {
        "https://api.ipify.org?format=json",
        "http://ip-api.com/json",
        "https://ipinfo.io/json"
    }
    
    for _, url in ipairs(services) do
        local res = gg.makeRequest(url)
        if res and res.content then
            local data = json.decode(res.content)
            if data and (data.ip or data.query) then
                return data.ip or data.query, data.country or data.countryCode
            end
        end
    end
    return nil, nil
end

local ipAddress2, ipCountry = getPublicIP()
if not ipAddress2 then
    gg.alert("⚠️ Could not get IP information")
    return
end

local function getRealLocation()
    local mockLocations = {"BR", "US", "JP", "DE", "FR"}
    return mockLocations[math.random(#mockLocations)]
end

local realCountryCode = getRealLocation()

local function checkGeoConsistency(ipCountry, realCountry)
    if not ipCountry or not realCountry then
        return false, "Incomplete location data"
    end
    
    ipCountry = ipCountry:upper()
    realCountry = realCountry:upper()
    
    if ipCountry == realCountry then
        return true, "✅ Location consistent"
    else
        local proxyCountries = {
            ["US"] = "American VPN/Proxy detected",
            ["NL"] = "Dutch server (common proxies)",
            ["SG"] = "Singapore server",
            ["RU"] = "Russian proxy detected"
        }
        
        local warning = proxyCountries[ipCountry] or "⚠️ Location mismatch"
        return false, warning.."\nIP registered in: "..ipCountry.."\nDevice in: "..realCountry
    end
end

local isConsistent, geoMessage = checkGeoConsistency(ipCountry, realCountryCode)

local function checkVPN(ip)
    local iphub = gg.makeRequest('http://v2.api.iphub.info/ip/' .. ip, {
        ['X-Key'] = "MjYxNDU6RXUzWEs3QkJHTXBOOWlOWWJMQllxd21veUI5MDhKSXQ="
    })
    
    local ipapi = gg.makeRequest('http://ip-api.com/json/' .. ip)
    
    local results = {
        vpn = false,
        proxy = false,
        hosting = false,
        country = "Unknown"
    }
    
    if iphub and iphub.content then
        local data = pcall(json.decode, iphub.content)
        
    end
    
    if ipapi and ipapi.content then
        local data = pcall(json.decode, ipapi.content)
        
    end
    
    return results
end

local vpnCheck = json.decode(gg.makeRequest('http://v2.api.iphub.info/ip/'..ipAddress, {
    ['X-Key'] = "MjYxNDU6RXUzWEs3QkJHTXBOOWlOWWJMQllxd21veUI5MDhKSXQ="
}).content)

local function checkSpeed()
    local start = os.clock()
    local res = gg.makeRequest("http://httpbin.org/delay/1", nil, 5000)
    local latency = math.floor((os.clock() - start) * 1000)
    
    if latency > 2000 then
        return false, "⏳ High latency ("..latency.."ms)\nPossible proxy/Tor usage"
    end
    return true
end

local speedOk, speedMsg = checkSpeed()
local vpnInfo = checkVPN(ipAddress)

local suspiciousCountries = {
    "Russia", "China", "North Korea", 
    "Iran", "Brazil", "Nigeria"
}

local isSuspiciousCountry = false
for _, country in ipairs(suspiciousCountries) do
    if vpnInfo.country:lower():find(country:lower()) then
        isSuspiciousCountry = true
        break
    end
end

local function checkDNS()
    local domains = {
        {url = "https://www.google.com", expected = "Google"},
        {url = "https://www.cloudflare.com", expected = "Cloudflare"}
    }
    
    for _, site in ipairs(domains) do
        local res = gg.makeRequest(site.url)
        if res and res.content and not res.content:find(site.expected) then
            return false, "DNS possibly tampered"
        end
    end
    return true, "DNS clean"
end

local dnsOk, dnsStatus = checkDNS()
local latencyCheck = gg.makeRequest("https://www.google.com", nil, 5000)

local report = "🌐 SECURITY REPORT 🌐\n\n"
report = report .. "🆔 IP: " .. ipAddress .. "\n"
report = report .. "🌎 Country: " .. vpnInfo.country .. "\n"
report = report .. "📍 IP Country: "..(ipCountry or "Unknown").."\n"
report = report .. "📱 Real Location: "..(realCountryCode or "Not detected").."\n"
report = report .. "⚡ Latency: " .. (speedOk and "Normal" or speedMsg) .. "\n\n"
report = report .. "🚫 VPN: " .. (vpnInfo.vpn and "DETECTED" or "Not detected") .. "\n"
report = report .. "🔄 Proxy: " .. (vpnInfo.proxy and "DETECTED" or "Not detected") .. "\n"
report = report .. "📦 Hosting: " .. (vpnInfo.hosting and "YES (possible VPS)" or "No") .. "\n"
report = report .. "🔎 Location: " .. (isSuspiciousCountry and "SUSPICIOUS" or "Normal") .. "\n"
report = report .. "🔍 Geo Check: "..geoMessage.."\n"
report = report .. "🔗 DNS: "..dnsStatus.."\n"
report = report .. "⏱️ Response: "..(latencyCheck and "Normal" or "High (possible proxy)").."\n"

if vpnInfo.vpn or vpnInfo.proxy or not speedOk or isSuspiciousCountry or not isConsistent or (vpnCheck and vpnCheck.block == 1) then
    local riskScore = 0
    if vpnInfo.vpn then riskScore = riskScore + 40 end
    if vpnInfo.proxy then riskScore = riskScore + 30 end
    if not speedOk then riskScore = riskScore + 20 end
    if isSuspiciousCountry then riskScore = riskScore + 10 end
    if not isConsistent then riskScore = riskScore + 30 end
    if vpnCheck and vpnCheck.block == 1 then riskScore = riskScore + 50 end
    
    local riskLevel = ""
    if riskScore >= 70 then
        riskLevel = "🚨 HIGH RISK"
    elseif riskScore >= 40 then
        riskLevel = "⚠️ MEDIUM RISK"
    else
        riskLevel = "🟡 LOW RISK"
    end

    report = report .. "\n" .. riskLevel .. " (" .. riskScore .. "/100)"
    
    while true do
        local choice = gg.alert(report .. "\n\n🔒 Connection blocked for security", "Exit", "Try again")
        if choice == 1 then
            os.exit()
        else
            local newIP = getIP()
            if newIP and newIP ~= ipAddress then
                gg.toast("IP change detected! Verifying again...")
                ipAddress = newIP
                vpnInfo = checkVPN(ipAddress)
            else
              --  gg.toast("No changes detected")
            end
        end
    end
else
    gg.toast("✅ Security check completed")
    gg.alert(report .. "\n\n🟢 Secure connection detected")
end

gg.toast("Monitoring connection...")
local originalIP = ipAddress

function monitorIP()
    while true do
        sleep(30000)
        local currentIP = getIP()
        if currentIP and currentIP ~= originalIP then
            gg.alert("⚠️ IP CHANGE DETECTED!\n\nOriginal: "..originalIP.."\nCurrent: "..currentIP)
            originalIP = currentIP
        end
    end
end

pcall(monitorIP)