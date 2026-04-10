
local function getFileSize(path)
    local function formatSize(size)
        local units = {"B", "KB", "MB", "GB", "TB"}
        local unitIndex = 1
        while size >= 1024 and unitIndex < #units do
            size = size / 1024
            unitIndex = unitIndex + 1
        end
        return string.format("%.2f %s", size, units[unitIndex])
    end

    local file, err = io.open(path, "rb")
    if not file then
        return "Erro open file: " .. err
    end
    
    local content = file:read("*a")
    file:close()
    
    if not content then
        return "file empty or no load content."
    end

    local sizeInBytes = #content
    return formatSize(sizeInBytes)
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
  g.info = { g.last, g.last:gsub("/[^/]+$", "") }
end

while true do
    g.info = gg.prompt({
        'Select file lua :' 
    }, g.info, {
        'file'
    })

    if not g.info or not g.info[1] then
        gg.alert("No file lua selected! ")
        return
    end
     
    gg.saveVariable(g.info, g.config)
    
    g.last = g.info[1]
    
    if not loadfile(g.last) then
        gg.alert("please select file lua ")
        return
    else
        g.out = g.last:match("[^/]+$")
        
        local fileSize = getFileSize(g.last)
        gg.alert("📂 File: " .. g.out .. "\n\n📂 Size: " .. fileSize)
        os.exit()
    end
end