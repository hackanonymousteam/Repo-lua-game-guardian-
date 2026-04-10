
local chat = gg.prompt({'insert link'}, {}, {'text'})
if chat == nil then
    return
end

local duck = chat[1]
local request = gg.makeRequest('http://tinyurl.com/api-create.php?url='..duck)
local response = request.content
    
print(response)
    
    os.exit() 