local chat = gg.prompt({'enter app name'}, {}, {'text'})
if chat == nil then
    return
end

local duck = chat[1]
local request = gg.makeRequest('https://apkpure.com/br/search?q=' .. duck .. '&t=')
local response = request.content

local pattern1 = 'https://apkpure.com/br[^"]*download%?utm_content=1008'
local urls = {}
for url in response:gmatch(pattern1) do
    table.insert(urls, url)
end

if #urls == 0 then
    gg.alert('No URLs found.')
    return
end

local selected_url = urls[1]
gg.toast(' please wait step 1/3')

local request2 = gg.makeRequest(selected_url)
local response2 = request2.content

local pattern2 = 'https://apkpure%.com/br/[^"]+/downloading'
local download_urls = {}
for url in response2:gmatch(pattern2) do
    table.insert(download_urls, url)
end

if #download_urls == 0 then
    gg.alert('No download URLs found.')
    return
end

local selected_download_url = download_urls[1]
gg.toast(' please wait step 2/3')

local request3 = gg.makeRequest(selected_download_url)
local response3 = request3.content

local pattern3 = 'https://d%.apkpure%.com/b/[^"]+?version=latest'
local final_urls = {}
local extracted_content = {}
for url in response3:gmatch(pattern3) do
    table.insert(final_urls, url)

    local capture = url:match('https://d%.apkpure%.com/b/([^/]+)/')
    if capture then
        table.insert(extracted_content, capture)
    end
end

if #final_urls == 0 then
    gg.alert('No final download URLs found.')
    return
end

local final_url = final_urls[1]
gg.toast(' please wait step 3/3')

local apk_content = gg.makeRequest(final_url).content
if apk_content == nil then
    gg.alert('Failed to download the APK.')
    return
end

local apk_name = duck .. "." .. string.lower(extracted_content[1])  
local path = "/sdcard/Download/"

local file = io.open(path .. apk_name, "wb")
if file then
    file:write(apk_content)
    file:close()
    gg.alert('APK saved in ' .. path .. apk_name)
else
    gg.alert('Failed to save the APK.')
end