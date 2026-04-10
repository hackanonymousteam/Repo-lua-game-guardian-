local function getFileSizeBytes(path)
    local file, err = io.open(path, "rb")
    if not file then
        return nil, "Error opening file: " .. err
    end
    
    local content = file:read("*a")
    file:close()
    
    if not content then
        return nil, "File empty or unable to load content."
    end    
    return #content, nil
end

local function formatFileSize(bytes)
    local units = {"B", "KB", "MB", "GB", "TB"}
    local unitIndex = 1
    local size = bytes
    
    while size >= 1024 and unitIndex < #units do
        size = size / 1024
        unitIndex = unitIndex + 1
    end
    return string.format("%.2f %s", size, units[unitIndex])
end

local function script_to_bytes(content)
    local bytes = {}
    for i = 1, #content do
        bytes[i] = string.byte(content, i)
    end
    return bytes
end

local function encode_content(content)
    local bytes = script_to_bytes(content)
    return string.format("pcall(load(string.char(table.unpack({%s}))))", table.concat(bytes, ","))
end

local function encode_with_iterations(content, iterations)
    local final_code = content
    
    if iterations > 0 then
        gg.toast("Starting encoding... 0%")
        for i = 1, iterations do
            local percent = math.floor((i / iterations) * 100)
            gg.toast(percent .. "%")
            final_code = encode_content(final_code)
        end
        gg.toast("Encoding completed! 100%")
    end
    
    return final_code
end

local function determine_iterations(file_size_bytes)
    local MAX_LIMIT = 10354
    local LIMIT_4KB = 4.03 * 1024
    
    if file_size_bytes > MAX_LIMIT then
        return nil
    elseif file_size_bytes > LIMIT_4KB then
        return 6
    else
        return 7
    end
end

g = {}
g.last = "/sdcard/"
g.info = nil
g.config = gg.EXT_CACHE_DIR .. "/" .. gg.getFile():match("[^/]+$") .. "cfg"
g.data = loadfile(g.config)

if g.data ~= nil then
    g.info = g.data()
    g.data = nil
end

if g.info == nil then
    g.info = { g.last }
end

while true do
    g.info = gg.prompt({
        'Select .lua file:'
    }, g.info, {
        'file'
    })
    
    if not g.info or not g.info[1] then
        gg.alert("No file selected!")
        return
    end
    
    gg.saveVariable(g.info, g.config)
    g.last = g.info[1]
    
    if loadfile(g.last) == nil then
        gg.alert("Please select a valid .lua file!")
        return
    end
    
    local file_size_bytes, err = getFileSizeBytes(g.last)
    if not file_size_bytes then
        gg.alert("Error reading file:\n" .. err)
        return
    end
    
    local file_size_formatted = formatFileSize(file_size_bytes)
    local file_name = g.last:match("[^/]+$")
    
    if file_size_bytes > 10354 then
        gg.alert("❌ FILE TOO LARGE!\n\n" ..
                 "📂 File: " .. file_name .. "\n" ..
                 "📏 Size: " .. file_size_formatted .. "\n" ..
                 "⚠️  Maximum limit: 10 KB\n\n" ..
                 "❌ Encoding cancelled!")
        return
    end
    
    local num_iterations = determine_iterations(file_size_bytes)
    
    if not num_iterations then
       -- gg.alert("❌ ERROR: Unable to determine number of iterations!")
        return
    end
        
    local f = io.open(g.last, "r")
    if not f then
        gg.alert("Error opening file for reading!")
        return
    end
    
    local data = f:read('*a')
    f:close()
    
    if not data or data == "" then
        gg.alert("File is empty!")
        return
    end
    
    g.out = g.last:match("[^/]+$")
    g.out = g.out:gsub("%.lua$", "")
    g.out = g.info[2] and (g.info[2] .. "/" .. g.out .. ".encoded.lua") or ("/sdcard/" .. g.out .. ".encoded.lua")    

    local final_code = encode_with_iterations(data, num_iterations)
    
    local out_file = io.open(g.out, "w")
    if not out_file then
        gg.alert("Error creating output file!")
        return
    end
    
    out_file:write(final_code)
    out_file:close()
    
    local encoded_size_bytes = #final_code
    local encoded_size_formatted = formatFileSize(encoded_size_bytes)
    
    gg.alert("✅ ENCODING COMPLETED!\n\n" ..
             "📂 Original file:\n" ..
             "   Name: " .. file_name .. "\n" ..
             "by batman games")    
    break
end