local json = nil
if not pcall(function()
    json = load(gg.makeRequest("https://raw.githubusercontent.com/rxi/json.lua/master/json.lua").content)()
end) then
    json = require("json") or gg.alert("❌ JSON library not available")
    if not json then return end
end

local function urlencode(str)
    if str then
        str = string.gsub(str, "\n", "\r\n")
        str = string.gsub(str, "([^%w %-%_%.%~])", function(c)
            return string.format("%%%02X", string.byte(c))
        end)
        str = string.gsub(str, " ", "+")
    end
    return str
end

local function make_api_request(url)
    local request = gg.makeRequest(url)
    if request == nil then
        return nil, "Error: no internet connection"
    end
    if request.code ~= 200 then
        return nil, "HTTP Error: " .. (request.code or "unknown") .. " - " .. (request.message or "no message")
    end
    if request.content == nil then
        return nil, "Empty API reply"
    end
    return request.content, nil
end

local function save_file(content, filename)
    local path = "/sdcard" .. "/" .. filename
    local file = io.open(path, "wb")
    if file then
        file:write(content)
        file:close()
        gg.alert("✅ File saved successfully!\nLocation: " .. path)
        return true
    else
        gg.alert("❌ Failed to save file!\nLocation: " .. path)
        return false
    end
end

local function generate_image()
    local prompt = gg.prompt({"Enter image prompt:"}, {}, {'text'})
    if prompt == nil or prompt[1] == "" then
        gg.alert("Empty prompt!")
        return
    end
    
    local ratios = {"1:1", "16:9", "9:16", "4:3", "3:4"}
    local ratio_choice = gg.choice(ratios, nil, "Select image ratio:")
    if ratio_choice == nil then
        gg.alert("No ratio selected!")
        return
    end
    
    local encoded_prompt = urlencode(prompt[1])
    local ratio = ratios[ratio_choice]
    local url = "https://api.cuki.biz.id/api/ai/image/flux?apikey=cuki-x&prompt=" .. encoded_prompt .. "&ratio=" .. ratio
    
    gg.alert("🔄 Generating image, please wait...")
    
    local response_content, error_msg = make_api_request(url)
    if error_msg then
        gg.alert("❌ Error:\n" .. error_msg)
        return
    end
    
    local filename = "flux_image_" .. os.time() .. ".png"
    save_file(response_content, filename)
end

local function download_website()
    local url_input = gg.prompt({"Enter website URL to download (including http:// or https://):"}, {}, {'text'})
    if url_input == nil or url_input[1] == "" then
        gg.alert("Empty URL!")
        return
    end
    
    local encoded_url = urlencode(url_input[1])
    local api_url = "https://api.cuki.biz.id/api/tools/copyweb?apikey=cuki-x&url=" .. encoded_url
    
    gg.alert("🔄 Downloading website, please wait...")
    
    local response_content, error_msg = make_api_request(api_url)
    if error_msg then
        gg.alert("❌ Error:\n" .. error_msg)
        return
    end
    
    local filename = "website_" .. os.time() .. ".zip"
    save_file(response_content, filename)
end

while true do
    local main_choice = gg.choice({
        "🎨 Generate Image (Flux AI)",
        "🌐 Download Website (ZIP)",
        "❌ Exit"
    }, nil, "Cuki API - Flux Image & Website Downloader\nBase URL: api.cuki.biz.id")
    
    if main_choice == nil or main_choice == 3 then
        break
    end
    
    if main_choice == 1 then
        generate_image()
    elseif main_choice == 2 then
        download_website()
    end
end

gg.alert("Thank you for using Cuki API Tools!")