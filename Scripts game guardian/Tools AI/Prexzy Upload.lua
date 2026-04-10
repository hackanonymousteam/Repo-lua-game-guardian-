gg.setVisible(true)

local function encodeBase64(data)
    local b64chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    local bytes = {}
    
    for i = 1, #data do
        bytes[i] = data:byte(i)
    end
    
    local result = ''
    for i = 1, #bytes, 3 do
        local a, b, c = bytes[i], bytes[i+1], bytes[i+2]
        
        local n = (a or 0) * 0x10000 + (b or 0) * 0x100 + (c or 0)
        
        local s1 = b64chars:sub((n >> 18) & 0x3F + 1, (n >> 18) & 0x3F + 1)
        local s2 = b64chars:sub((n >> 12) & 0x3F + 1, (n >> 12) & 0x3F + 1)
        local s3 = b64chars:sub((n >> 6) & 0x3F + 1, (n >> 6) & 0x3F + 1)
        local s4 = b64chars:sub(n & 0x3F + 1, n & 0x3F + 1)
        
        if not b then
            s3, s4 = '=', '='
        elseif not c then
            s4 = '='
        end
        
        result = result .. s1 .. s2 .. s3 .. s4
    end
    
    return result
end

local json = nil
if not pcall(function()
    json = load(gg.makeRequest("https://raw.githubusercontent.com/rxi/json.lua/master/json.lua").content)()
end) then
    json = require("json")
    if not json then 
        gg.alert("JSON library not available")
        return 
    end
end

local function uploadToPrexzy(filePath)
    local file = io.open(filePath, "rb")
    if not file then
        return nil, "Failed to open file"
    end
    
    local fileData = file:read("*a")
    file:close()
    
    local sizeMB = #fileData / (1024 * 1024)
    if sizeMB > 100 then
        return nil, "File too large (" .. string.format("%.2f", sizeMB) .. "MB), maximum 100MB"
    end
    
    local fileName = filePath:match("[^/]+$") or "file.bin"
    local base64Data = encodeBase64(fileData)
    
    local payload = {
        filename = fileName,
        data = base64Data
    }
    
    local headers = {
        ["accept"] = "*/*",
        ["content-type"] = "application/json",
        ["origin"] = "https://upload.prexzyvilla.site",
        ["referer"] = "https://upload.prexzyvilla.site/",
        ["user-agent"] = "NB Android/1.0.0"
    }
    
    gg.toast("Uploading file...")
    
    local response = gg.makeRequest("https://upload.prexzyvilla.site/api/upload", headers, json.encode(payload))
    
    if type(response) == "table" and response.code == 200 then
        local success, data = pcall(json.decode, response.content)
        if success and data then
            return data
        end
    end
    
    return nil, "Upload failed: " .. (response.code or "unknown")
end

local batman = {}
batman.last = gg.getFile()
batman.info = nil
batman.config = gg.EXT_CACHE_DIR .. "/" .. gg.getFile():match("[^/]+$") .. "cfg"
batman.DATA = loadfile(batman.config)
if batman.DATA ~= nil then batman.info = batman.DATA() batman.DATA = nil end
if batman.info == nil then batman.info = {batman.last, batman.last:gsub("/[^/]+$", "")} end

while true do
    batman.info = gg.prompt({
        '[📁] Select File to Upload:'
    --    '[📁] Select Output Directory:',
    }, batman.info, {
        "file",
        "path",
    })
    
    if batman.info == nil then break end

    gg.saveVariable(batman.info, batman.config)
    
    local filePath = batman.info[1]
    local outputDir = batman.info[2]
    
    local file = io.open(filePath, "rb")
    if not file then 
        gg.alert("Error opening file!")
        break 
    end
    file:close()
    
    gg.alert("Starting upload...\n\nFile: " .. filePath)
    
    local result, error = uploadToPrexzy(filePath)
    
    if result then
        local filename = tostring(result.filename or "N/A"):gsub(",", ".")
        local url = tostring(result.url or "N/A"):gsub(",", ".")
        local directUrl = tostring(result.directUrl or "N/A"):gsub(",", ".")
        
        local message = "✅ Prexzy Upload\n\n📂 File Name: " .. filename .. 
                       "\n🔗 URL: " .. url .. 
                       "\n⚡ Direct: " .. directUrl
        
        gg.alert(message)

        print(message)
    else
        local errorMsg = "❌ Upload failed: " .. tostring(error or "Unknown error"):gsub(",", ".")
        
        gg.alert(errorMsg)
        print(errorMsg)
    end
    
    break
end