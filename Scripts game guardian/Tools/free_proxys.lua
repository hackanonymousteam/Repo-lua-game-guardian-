local apikey = "prince"
local req = gg.makeRequest("https://api.princetechn.com/api/tools/proxy?apikey=" .. apikey)
if req == nil or req.content == nil then
    print("Error: No response.")
    return
end
local response = req.content
local proxies = {}
for ip, port, code, country, anonymity, google, https, last in response:gmatch('"ip"%s*:%s*"([^"]+)".-"port"%s*:%s*"([^"]+)".-"code"%s*:%s*"([^"]+)".-"country"%s*:%s*"([^"]+)".-"anonymity"%s*:%s*"([^"]+)".-"google"%s*:%s*"([^"]*)".-"https"%s*:%s*"([^"]+)".-"last"%s*:%s*"([^"]+)"') do
    table.insert(proxies, {
        ip = ip,
        port = port,
        code = code,
        country = country,
        anonymity = anonymity,
        google = google,
        https = https,
        last = last
    })
end
if #proxies == 0 then
    print("No proxies found.")
    return
end
local list = {}
for i, p in ipairs(proxies) do
    list[i] = p.ip .. ":" .. p.port .. " → " .. p.country .. " (" .. p.anonymity .. ")"
end
local choice = gg.choice(list, nil, "Select Proxy")
if choice then
    local selected = proxies[choice]
    print("IP: " .. selected.ip)
    print("Port: " .. selected.port)
    print("Country: " .. selected.country)
    print("Code: " .. selected.code)
    print("Anonymity: " .. selected.anonymity)
    print("Google: " .. (selected.google ~= "" and selected.google or "N/A"))
    print("HTTPS: " .. selected.https)
    print("Last Checked: " .. selected.last)
end