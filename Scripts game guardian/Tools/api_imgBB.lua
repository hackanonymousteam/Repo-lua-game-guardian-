gg.setVisible(true)

local b64 = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
local function base64_encode(t)
    local r = {}
    for i = 1, #t, 3 do
        local a, b, c = t:byte(i, i+2)
        local x = (a or 0) * 65536 + (b or 0) * 256 + (c or 0)
        r[#r+1] = b64:sub(bit32.rshift(x,18)%64+1,bit32.rshift(x,18)%64+1)
        r[#r+1] = b64:sub(bit32.rshift(x,12)%64+1,bit32.rshift(x,12)%64+1)
        r[#r+1] = b64:sub(bit32.rshift(x,6)%64+1,bit32.rshift(x,6)%64+1)
        r[#r+1] = b64:sub(x%64+1,x%64+1)
    end
    local p = (#t % 3)
    if p > 0 then for i = 1, 3 - p do r[#r-i+1] = '=' end end
    return table.concat(r)
end

local json = load(gg.makeRequest("https://raw.githubusercontent.com/rxi/json.lua/master/json.lua").content)()

local API_KEY = "YOUR_API_KEY"

local function generate_boundary()
    local boundary = "----WebKitFormBoundary"
    local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
    for i = 1, 16 do
        boundary = boundary .. chars:sub(math.random(1, #chars), math.random(1, #chars))
    end
    return boundary
end

local function build_multipart_body(filename, file_data, boundary)
    local body_parts = {}
    
    table.insert(body_parts, "--" .. boundary .. "\r\n")
    table.insert(body_parts, 'Content-Disposition: form-data; name="image"; filename="' .. filename .. '"\r\n')
    table.insert(body_parts, "Content-Type: image/png\r\n\r\n")
    table.insert(body_parts, file_data)
    table.insert(body_parts, "\r\n--" .. boundary .. "--\r\n")
    
    return table.concat(body_parts)
end

local function upload_to_imgbb(file_path)
    local fp = io.open(file_path, "rb")
    if not fp then 
        return false, "Failed to open file" 
    end
    
    local file_data = fp:read("*a")
    fp:close()
    
    local filename = file_path:match("([^/]+)$") or "image.png"
    
    local boundary = generate_boundary()
    
    local body = build_multipart_body(filename, file_data, boundary)
    
    local headers = {
        ["Content-Type"] = "multipart/form-data; boundary=" .. boundary,
        ["Content-Length"] = tostring(#body)
    }
    
    local url = "https://api.imgbb.com/1/upload?key=" .. API_KEY
    local response = gg.makeRequest(url, headers, body)
    
    if not response then
        return false, "No server response"
    end
    
    if response.code ~= 200 then
        return false, "Upload error: " .. response.code
    end
    
    local success, data = pcall(json.decode, response.content)
    if not success then
        return false, "Failed to decode response"
    end
    
    if data.success ~= true then
        return false, "Upload failed: " .. (data.error and data.error.message or "Unknown error")
    end
    
    return true, data.data
end

while true do
    local input = gg.prompt(
        {"Image file (PNG/JPG/GIF/etc)", "Filename to save URL"},
        {"/sdcard/Download/image.png", "url.txt"},
        {"file", "text"}
    )
    
    if not input then 
        break 
    end
    
    local file_check = io.open(input[1], "rb")
    if not file_check then
        gg.alert("File not found:\n" .. input[1])
        break
    end
    file_check:close()
    
    gg.toast("Uploading to ImgBB...")
    
    local success, result = upload_to_imgbb(input[1])
    
    if not success then
        gg.alert("Error: " .. result)
        break
    end
    
    local save_path = "/sdcard/Download/" .. input[2]
    local save_file = io.open(save_path, "w")
    
    local info_text = ""
    if save_file then
        save_file:write(result.url .. "\n")
        save_file:write("Delete URL: " .. (result.delete_url or "N/A") .. "\n")
        save_file:close()
        info_text = "\n\nURL saved to:\n" .. save_path
    end
    
    local message = string.format(
        "Upload complete!\n\n" ..
        "URL: %s\n" ..
        "Size: %d bytes\n" ..
        "Width: %d px\n" ..
        "Height: %d px\n" ..
        "Delete URL: %s%s",
        result.url,
        result.size or 0,
        result.width or 0,
        result.height or 0,
        result.delete_url or "N/A",
        info_text
    )
    
    gg.alert(message)
    
    local action = gg.alert("What do you want to do?", "New upload", "Copy URL", "Exit")
    
    if action == 2 and result and result.url then
        gg.copyText(result.url)
        gg.toast("URL copied!")
    elseif action == 3 then
        break
    end
end

gg.alert("end")