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

local duck = DATA

B="EN2ZH_CN"--有道云中文转英文
Y='http://m.youdao.com/translate'--第一个参数的网址
F="inputtext=0"..DATA.."&type="..B--需要翻译的内容

local request = gg.makeRequest('http://m.youdao.com/translate',nil,F) 


if request == nil or request == nil then
    print('error get reply translate.')
    return
end

local response = request.content

 function extractContentFromHTML(html)
   local pattern = '<ul id="translateResult">%s*<li>(.-)</li>'

    local content = html:match(pattern)
    return content
end

local content = extractContentFromHTML(response)
print("file save in /sdcard/translate.txt")
    local outputFile = "/sdcard/translate.txt"
    local file_out = io.open(outputFile, "w")
  file_out:write(content .. "\n")
    file_out:close()