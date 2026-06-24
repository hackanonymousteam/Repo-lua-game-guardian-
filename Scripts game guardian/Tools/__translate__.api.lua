local text = "Hello, how are you?"
local url = "https://api.52vmy.cn/api/query/fanyi?msg="-- .. gg.makeRequest and text
local function urlencode(str)
    if str then
        str = string.gsub(str, "\n", "\r\n")
        str = string.gsub(str, "([^%w %-%_%.%~])",
            function(c) return string.format("%%%02X", string.byte(c)) end)
        str = string.gsub(str, " ", "+")
    end
    return str
end

kk = urlencode(text)
local res = gg.makeRequest(
    "https://api.52vmy.cn/api/query/fanyi?msg=" ..kk
)

print(res.content)


-- note:  this api translate only
--english for chinese
--and
--chinese to english