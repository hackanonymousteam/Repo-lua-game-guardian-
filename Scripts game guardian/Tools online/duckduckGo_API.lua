local chat = gg.prompt({'ask a question'}, {}, {'text'})
if chat == nil then
    return
end

local duck = chat[1]
local request = gg.makeRequest('https://api.duckduckgo.com/?q='..duck..'&format=json')

if request == nil or request.content == nil then
    print('error get reply DuckDuckGo.')
    return
end

local response = request.content
local textContent = ""
for text in response:gmatch('"Text":"(.-)"') do
    textContent = text
    break  
end

if textContent == "" then
    print('error.')
else
    print('your question : ' .. duck .. '\n\n\nreply:\n' .. textContent)
        end