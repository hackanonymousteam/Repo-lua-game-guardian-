
local apikey = "prince"

local input = gg.prompt({'Enter text to stylize'}, {}, {'text'})
if input == nil then return end
local text = input[1]

local req = gg.makeRequest("https://api.princetechn.com/api/tools/fancyv2?apikey=" .. apikey .. "&text=" .. text)
if req == nil or req.content == nil then
    print("Error: No response.")
    return
end

local response = req.content
local styles = {}
for name, result in response:gmatch('"name"%s*:%s*"([^"]+)"%s*.-"result"%s*:%s*"([^"]+)"') do
    table.insert(styles, {name = name, result = result})
end

if #styles == 0 then
    print("No fancy styles found.")
    return
end

local list = {}
for i, s in ipairs(styles) do
    list[i] = s.name .. " → " .. s.result
end

local choice = gg.choice(list, nil, "Select Fancy Style")
if choice then
    print("You chose [" .. styles[choice].name .. "]: " .. styles[choice].result)
end