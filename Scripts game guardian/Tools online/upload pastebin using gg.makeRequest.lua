gg.setVisible(true)

local api_dev_key = "your_api_key"

local chat = gg.prompt({'insert you code here'}, {}, {'text'})
if chat == nil then
    return
end

local paste_content = chat[1]

local postData =
    "api_option=paste" ..
    "&api_dev_key=" .. api_dev_key ..
    "&api_paste_code=" .. paste_content ..
    "&api_paste_name=MyPaste" ..
    "&api_paste_private=1" ..
    "&api_paste_expire_date=1D"

local headers = {
    ["User-Agent"] = "LuaPasteUploader/1.0",
    ["Content-Type"] = "application/x-www-form-urlencoded"
}

local response = gg.makeRequest("https://pastebin.com/api/api_post.php", headers, postData)

if type(response) == "table" and response.content and response.content:find("https://pastebin.com/") then
    print("✅ Upload done success!")
    print("🔗 URL: " .. response.content)
    gg.alert("Upload done!\n" .. response.content)
else
    print("❌ Error in upload:")
    print(response.content or response or "No reply")

    if type(response) == "table" and response.content and response.content:find("Bad API request") then
        gg.alert("Error:\n" .. response.content .. "\nVerify your API key")
    else
        gg.alert("Upload failed:\n" .. (response.content or response or "Verify your internet"))
    end
end