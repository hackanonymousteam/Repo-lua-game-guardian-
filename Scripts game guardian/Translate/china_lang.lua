g = {}
caminho_arquivo = "/sdcard/"
g.info = nil
g.config = gg.EXT_CACHE_DIR .. "/" .. gg.getFile():match("[^/]+$") .. "cfg"
g.data = loadfile(g.config)
if g.data ~= nil then
    g.info = g.data()
    g.data = nil
end
if g.info == nil then
    g.info = { caminho_arquivo, caminho_arquivo:gsub("/[^/]+$", "") }
end

g.info = gg.prompt({
    'Select File txt for translate:', -- 1
}, g.info, {
    'file', -- 1
})
gg.saveVariable(g.info, g.config)
caminho_arquivo = g.info[1]
if loadfile(caminho_arquivo) == nil then

else
    os.exit()
end

local file = io.open(caminho_arquivo, "r")
local DATA = file:read('*a')
file:close()

local function urlencode(char)
    local byte = string.byte(char)
    local hex = string.format("%02X", byte)
    return "%" .. hex
end

local function url_encode(str)
    local encoded_str = ""
    for i = 1, #str do
        local char = string.sub(str, i, i)
        if char:match("[^%w%-_%.~]") then
            encoded_str = encoded_str .. urlencode(char)
        else
            encoded_str = encoded_str .. char
        end
    end
    return encoded_str:gsub(" ", "+")
end

local duck = DATA

local encoded_str = url_encode(duck)

local request = gg.makeRequest('https://api.mymemory.translated.net/get?q='..encoded_str..'&langpair=pt|zh-CN') 

if request == nil or request.content == nil then
    print('error get reply translate.')
    return
end

local response = request.content

local function decodeUnicode(str)
    return str:gsub("\\u(%x%x%x%x)", function(h)
        return utf8.char(tonumber(h, 16))
    end)
end

local function extracttransFromHTML(html)
    local pattern = '"translatedText"%s*:%s*"([^"]+)"'
    local trans = html:match(pattern)
    return trans
end

local trans = extracttransFromHTML(response)

if not trans then
    print('Error')
else
    local decoded_trans = decodeUnicode(trans)
    decoded_trans = decoded_trans:gsub("\\n", "\n")
   -- print('translate:', decoded_trans)
    print("file save in /sdcard/translate.txt")
local outputFile =    "/sdcard/translate.txt"
    local outputFile = io.open(outputFile, "a")  
        outputFile:write(decoded_trans .. "\n")  
        outputFile:close()
end