
local chat = gg.prompt({'insert link'}, {}, {'text'})
if chat == nil then
    return
end

local duck = chat[1]
local request = gg.makeRequest('https://api.qrserver.com/v1/create-qr-code/?data='..duck)

local response = request.content
    
print("file save in /sdcard/Qr_code.png")
    local outputFile = "/sdcard/Qr_code.png"
    local file_out = io.open(outputFile, "w")
  file_out:write(response)
    file_out:close()
    os.exit() 