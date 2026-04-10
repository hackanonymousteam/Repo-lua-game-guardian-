gg.setVisible(true)

local api_dev_key = "your_api_key"

local api_user_key = nil

function urlencode(str)
if str then
str = string.gsub(str, "\n", "\r\n")
str = string.gsub(str, "([^%w %-%_%.%~])",
function(c) return string.format("%%%02X", string.byte(c)) end)
str = string.gsub(str, " ", "%%20")
end
return str
end

local function createPaste(code, name, format, private, expire)
    name = name or "MyPaste"
    format = format or "text"
    private = private or 1  -- 0=public, 1=unlisted, 2=private
    expire = expire or "1D"  -- N=Never, 10M, 1H, 1D, 1W, 2W, 1M, 6M, 1Y
    
    local postData = "api_option=paste" ..
        "&api_dev_key=" .. api_dev_key ..
        "&api_paste_code=" .. urlencode(code) ..
        "&api_paste_name=" .. urlencode(name) ..
        "&api_paste_format=" .. format ..
        "&api_paste_private=" .. private ..
        "&api_paste_expire_date=" .. expire
    
    if api_user_key then
        postData = postData .. "&api_user_key=" .. api_user_key
    end
    
    local headers = {
        ["User-Agent"] = "LuaPasteUploader/2.0",
        ["Content-Type"] = "application/x-www-form-urlencoded"
    }
    
    local response = gg.makeRequest("https://pastebin.com/api/api_post.php", headers, postData)
    return response
end

local function listUserPastes(limit)
    if not api_user_key then
        return nil, "Error: User authentication required"
    end
    
    limit = limit or 50
    
    local postData = "api_option=list" ..
        "&api_dev_key=" .. api_dev_key ..
        "&api_user_key=" .. api_user_key ..
        "&api_results_limit=" .. limit
    
    local headers = {
        ["User-Agent"] = "LuaPasteUploader/2.0",
        ["Content-Type"] = "application/x-www-form-urlencoded"
    }
    
    local response = gg.makeRequest("https://pastebin.com/api/api_post.php", headers, postData)
    return response
end

local function deletePaste(paste_key)
    if not api_user_key then
        return nil, "Error: User authentication required"
    end
    
    local postData = "api_option=delete" ..
        "&api_dev_key=" .. api_dev_key ..
        "&api_user_key=" .. api_user_key ..
        "&api_paste_key=" .. paste_key
    
    local headers = {
        ["User-Agent"] = "LuaPasteUploader/2.0",
        ["Content-Type"] = "application/x-www-form-urlencoded"
    }
    
    local response = gg.makeRequest("https://pastebin.com/api/api_post.php", headers, postData)
    return response
end

local function getUserInfo()
    if not api_user_key then
        return nil, "Error: User authentication required"
    end
    
    local postData = "api_option=userdetails" ..
        "&api_dev_key=" .. api_dev_key ..
        "&api_user_key=" .. api_user_key
    
    local headers = {
        ["User-Agent"] = "LuaPasteUploader/2.0",
        ["Content-Type"] = "application/x-www-form-urlencoded"
    }
    
    local response = gg.makeRequest("https://pastebin.com/api/api_post.php", headers, postData)
    return response
end

local function showMenu()
    local options = {
        "Create new paste",
        "Exit"
    }
    
    local choice = gg.choice(options, nil, "Pastebin Automation - Select an option:")
    
    if choice == 1 then
        local input = gg.prompt({
            "Code/Content:", 
            "Paste name (optional):", 
            "Format (text/python/lua/etc):",
            "Privacy (0=public,1=unlisted,2=private):",
            "Expiration (N/10M/1H/1D/1W/2W/1M/6M/1Y):"
        }, {
            "print('Hello World!')", 
            "My Script", 
            "lua", 
            "1", 
            "1D"
        }, {'text', 'text', 'text', 'text', 'text'})
        
        if input then
            local code = input[1]
            local name = input[2] ~= "" and input[2] or "MyPaste"
            local format = input[3] ~= "" and input[3] or "text"
            local private = tonumber(input[4]) or 1
            local expire = input[5] ~= "" and input[5] or "1D"
            
            print("Uploading paste...")
            local response = createPaste(code, name, format, private, expire)
            
            if type(response) == "table" and response.content then
                if response.content:find("https://pastebin.com/") then
                    print("Upload completed successfully!")
                    print("URL: " .. response.content)
                    gg.alert("Upload completed!\n\nURL: " .. response.content)
                else
                    print("Upload error:")
                    print(response.content)
                    gg.alert("Upload error!\n\n" .. response.content)
                end
            else
                print("Request error")
                gg.alert("Request error!\nCheck your internet connection.")
            end
        end
        
    elseif choice == 2 then

        
        
        return
    end
end

if api_dev_key == "your_api_key" then
    print("WARNING: Configure your API Developer Key in the script!")
    gg.alert("WARNING!\n\nConfigure your API Developer Key in the script before using.\n\nFind the 'api_dev_key' variable at the beginning of the code.")
    return
end

while true do
    showMenu()
    local continuee = gg.alert("Do you want to perform another operation?", "Yes", "No")
    if continuee ~= 1 then
        break
    end
end

