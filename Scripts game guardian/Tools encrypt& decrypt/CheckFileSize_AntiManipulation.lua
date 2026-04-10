local sizeOriginal = "948.00 B"

local function formatSize(size)
    local units = {"B", "KB", "MB", "GB", "TB"}
    local unitIndex = 1
    while size >= 1024 and unitIndex < #units do
        size = size / 1024
        unitIndex = unitIndex + 1
    end
    return string.format("%.2f %s", size, units[unitIndex])
end

local function getFileSize(path)
    local file, err = io.open(path, "rb")
    if not file then
        return "Error opening file: " .. err
    end
    
    local content = file:read("*a")
    file:close()
    
    if not content then
        return "File empty or cannot load content."
    end

    local sizeInBytes = #content
    return formatSize(sizeInBytes)
end

local archive = gg.getFile() 

local fileSize = getFileSize(archive)
        
if sizeOriginal ~= fileSize then
    gg.alert("Error, file modified")
    print(fileSize)
    os.exit()
else
    gg.alert("File correct")
end