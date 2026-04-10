
local request = gg.makeRequest('https://randomuser.me/api/')

if request == nil or request.content == nil then
    print('error get reply server.')
    return
end

local response = request.content
local textContent = ""
local textContenti = ""
for text in response:gmatch('"username":"(.-)"') do
    textContent = text
    break  
end

local textContenti = ""
for texti in response:gmatch('"password":"(.-)"') do
    textContenti = texti
    break  
end

if textContent == "" then
    print('error.')
else
    print('username:  '..textContent)
    print('password:  '..textContenti)
        end
        
     --   by batman games