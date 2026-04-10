

gg.setVisible(true)

gg.setVisible(true)

local KEYYY = "Your_api_key"  
local UUID = "gienetic_" .. tostring(math.random(100000, 999999))

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
local function urlencode(str)
    if str then
        str = string.gsub(str, "\n", "\r\n")
        str = string.gsub(str, "([^%w %-%_%.%~])",
            function(c) return string.format("%%%02X", string.byte(c)) end)
        str = string.gsub(str, " ", "+")
    end
    return str
end
local function translateToEnglish(text)
    local url = "https://translate.googleapis.com/translate_a/single?client=gtx&sl=auto&tl=en&dt=t&q=" .. urlencode(text)
    local response = gg.makeRequest(url)
    
    if type(response) == "table" and response.code == 200 then
        local success, data = pcall(json.decode, response.content)
        if success and data and data[1] and data[1][1] then
            return data[1][1][1]
        end
    end
    return text
end

local function text2img(prompt)
    gg.toast("Creating image from text...")
    
    local url = "https://noisy-firefly-a3ec.akshaynceo6876.workers.dev/chat/dalle?user_id=" .. UUID .. "&message=" .. urlencode(prompt)
    
    local headers = {
        ["user-agent"] = "Dart/3.8 (dart:io)",
        ["content-type"] = "application/json; charset=utf-8"
    }
    
    local response = gg.makeRequest(url, headers, "", "POST")
    
    if type(response) == "table" and response.code == 200 and response.content then
       
        local imageUrl = response.content:gsub('^"(.*)"$', '%1')
        return imageUrl, true
    end
    
    return "Error: " .. (response.code or "unknown"), false
end

local function text2video(prompt)
    if KEYYY == "" then
        return "Please set your ModelsLab API key", false
    end
    
    gg.toast("Creating video from text...")
    
    local translatedPrompt = translateToEnglish(prompt)
    local payload = {
        key = KEYYY,
        prompt = translatedPrompt,
        resolution = "480",
        fps = "8",  
        num_frames = "32",  
        output_type = "mp4",
        model_id = "wan2.2"
    }
    
    local headers = {
        ["user-agent"] = "Dart/3.8 (dart:io)",
        ["content-type"] = "application/json; charset=utf-8"
    }
    
    local response = gg.makeRequest("https://modelslab.com/api/v6/video/text2video_ultra", headers, json.encode(payload))
    
  
    gg.alert("Video API Response:\nCode: " .. (response.code or "N/A") .. "\nContent: " .. (response.content or "No content"))
    
    if type(response) == "table" and response.code == 200 then
        local success, data = pcall(json.decode, response.content)
        if success and data then
            if data.status == "success" and data.output then
                return data.output, true
            elseif data.id then
               
                return data.id, true, "processing"
            else
                return "No video data in response", false
            end
        else
            return "Invalid JSON response", false
        end
    end
    
    return "HTTP Error: " .. (response.code or "unknown"), false
end

local function fetchVideoResult(jobId)
    gg.toast("Checking video status...")
    
    local payload = {
        key = KEYYY
    }
    
    local headers = {
        ["user-agent"] = "Dart/3.8 (dart:io)",
        ["content-type"] = "application/json; charset=utf-8"
    }
    
    local response = gg.makeRequest("https://modelslab.com/api/v6/video/fetch/" .. jobId, headers, json.encode(payload))
    
    if type(response) == "table" and response.code == 200 then
        local success, data = pcall(json.decode, response.content)
        if success and data then
            if data.status == "success" and data.output then
                return data.output, true
            elseif data.status == "processing" then
                return jobId, false, "still_processing"
            end
        end
    end
    
    return "Fetch failed", false
end

local function saveImageFromUrl(imageUrl, fileName)
    gg.toast("Downloading image...")
    
    local response = gg.makeRequest(imageUrl)
    if type(response) == "table" and response.code == 200 and response.content then
        os.execute("mkdir -p /sdcard/Download/AI_Images")
        local path = "/sdcard/Download/AI_Images/" .. fileName
        local file = io.open(path, "wb")
        if file then
            file:write(response.content)
            file:close()
            return path, true
        end
    end
    return "Download failed: " .. (response.code or "unknown"), false
end

local function saveVideoFromUrl(videoUrl, fileName)
    gg.toast("Downloading video...")
    
    local response = gg.makeRequest(videoUrl)
    if type(response) == "table" and response.code == 200 and response.content then
        os.execute("mkdir -p /sdcard/Download/AI_Videos")
        local path = "/sdcard/Download/AI_Videos/" .. fileName
        local file = io.open(path, "wb")
        if file then
            file:write(response.content)
            file:close()
            return path, true
        end
    end
    return "Download failed: " .. (response.code or "unknown"), false
end

--main
while true do
    local choice = gg.choice(
        {"🖼️ Text to Image"
        -- "🎬 Text to Video",
      --  "❌ Exit"
        },
        nil,
        "AI Image "
    )
    
    if not choice then break end
    
    if choice == 1 then
        local promptInput = gg.prompt({
            'Enter image description:'
        }, {
            'a beautiful sunset'
        }, {
            'text'
        })
        
        if promptInput and promptInput[1] then
            local imageUrl, success = text2img(promptInput[1])
            
            if success then
                local fileName = "ai_image_" .. os.time() .. ".png"
                local filePath, saveSuccess = saveImageFromUrl(imageUrl, fileName)
                
                if saveSuccess then
                    gg.alert("✅ Image created!\n\n📁 " .. filePath)
                else
                    gg.alert("❌ Download failed:\n" .. filePath)
                end
            else
                gg.alert("❌ Creation failed:\n" .. imageUrl)
            end
        end
        
    

end
end
gg.toast("Generator finished")