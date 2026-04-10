
local inicio = gg.choice({
    "🗃️ Download tutorial video 🗃️",
    "❇️ Start script ❇️",
    "❌ Exit ❌"
})


function START1()

-- Your link video tutorial here 
    local Link = "https://cdn.pixabay.com/video/2015/09/27/847-140823881_large.mp4"
  
  
  

  local path = "/sdcard/"
    local extension = ".mp4"
    local Name = "tutorial_video"

    local response = gg.makeRequest(Link)
    if response.content == nil then
        print("Error: Failed to download file.")
        return
    end

    local filePath = path .. Name .. extension
    local file = io.open(filePath, "wb")
    if file then
        file:write(response.content)
        file:close()
        print("File downloaded successfully.")
    else
        print("Error: Unable to open file for writing.")
    end
end


function START2()

    -- Start your script here
    
    print("Script started.")
end

if inicio == 1 then
    START1()
elseif inicio == 2 then
    START2()
elseif inicio == 3 then
    os.exit()
else
    print("Invalid choice.")
end

