local Link = "https://www.uuidgenerator.net/api/version4"
local A = "uuid.txt"
local path = gg.FILES_DIR .. "/" .. A

function checkPath(dir)
return os.rename(dir,dir) or false
end

if checkPath(path) then
    local file = io.open(path, "r")
    if file then
        local DATA = file:read("*a")
        file:close()
        gg.alert("Your UID: " .. DATA)
        os.exit()
    end
    
end

function create()
    local response = gg.makeRequest(Link)
    if not response or not response.content then
        gg.alert("Error: Unable to fetch UUID.")
        return
    end

    local file = io.open(path, "wb")
    if file then
        file:write(response.content)
        file:close()
        gg.alert("Your UID has been generated: " .. response.content)
    else
        gg.alert("Error: Unable to create file.")
    end
end

create()