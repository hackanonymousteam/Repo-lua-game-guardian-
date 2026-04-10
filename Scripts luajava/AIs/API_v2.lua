gg.setVisible(true)

-- API Keys
local MOONSHOT_API_KEY ="YOUR_API_KEY_HERE"
local NVIDIA_API_KEY = "YOUR_API_KEY_HERE"
local REPLICATE_API_TOKEN = "YOUR_API_KEY_HERE"


local json = nil
if not pcall(function()
json = load(gg.makeRequest("https://raw.githubusercontent.com/rxi/json.lua/master/json.lua").content)()
end) then
json = require("json") or gg.alert("JSON library not available")
if not json then return end
end

function urlencode(str)
if str then
str = string.gsub(str, "\n", "\r\n")
str = string.gsub(str, "([^%w %-%_%.%~])",
function(c) return string.format("%%%02X", string.byte(c)) end)
str = string.gsub(str, " ", "%%20")
end
return str
end

function saveFileToStorage(data, filename)
local filepath = "/sdcard/"..filename
local file = io.open(filepath, "wb")
if file then
file:write(data)
file:close()
return filepath
end
return nil
end

function downloadFile(url)
local response = gg.makeRequest(url)
if response and response.content then
return response.content
end
return nil
end

function selectAPI()
local apis = {
"🌙 Kimi K2 (Moonshot AI)",
"⭐ Kimi K2.5 (NVIDIA) slow",
"🎨 Generate Image (Replicate)",
"❌ Cancel"
}
local choice = gg.choice(apis, nil, "🎯 Select an AI Service")
if not choice or choice == 4 then return nil end
return choice
end

function formatMoonshotResponse(response)
if not response or not response.content then return "Error: No response from API" end
local success, data = pcall(json.decode, response.content)
if success and data.choices and data.choices[1] and data.choices[1].message then
local text = data.choices[1].message.content
text = text:gsub("([%.,!?;:])", "%1 ")
text = text:gsub("%s+", " ")
return text
end
return response.content
end

function processMoonshotKimi(query, model)
gg.toast("Processing with " .. (model == "kimi-k2-0905-preview" and "Kimi K2" or "Kimi K2.5") .. "...")
local base_url = "https://api.moonshot.ai/v1"
local request_data = {
model = model,
messages = {
{role = "system", content = "You are a helpful assistant."},
{role = "user", content = query}
},
temperature = 0.7
}
local json_data = json.encode(request_data)
local url = base_url .. "/chat/completions"
local headers = {
["Content-Type"] = "application/json",
["Authorization"] = "Bearer " .. MOONSHOT_API_KEY
}
local response = gg.makeRequest(url, headers, json_data, "POST")
return response
end

function processNVIDIAKimi(query)
gg.toast("Processing with Kimi K2.5 (NVIDIA)...")
local base_url = "https://integrate.api.nvidia.com/v1"
local request_data = {
model = "moonshotai/kimi-k2.5",
messages = {
{role = "user", content = query}
},
temperature = 0.7
}
local json_data = json.encode(request_data)
local url = base_url .. "/chat/completions"
local headers = {
["Content-Type"] = "application/json",
["Authorization"] = "Bearer " .. NVIDIA_API_KEY
}
gg.toast("Please wait, NVIDIA may take a few seconds...")
local response = gg.makeRequest(url, headers, json_data, "POST")
return response
end

function processReplicateImage()
gg.toast("Replicate - Describe your image")
local input = gg.prompt({"Describe the image you want to generate:"}, {}, {"text"})
if not input or not input[1] or input[1]:trim() == "" then
gg.alert("Empty input or cancelled")
return
end
local query = input[1]
gg.toast("Generating image... (this may take a moment)")
local create_data = {
version = "stability-ai/sdxl:39ed52f2a78e934b3ba6e2a89f5b1c712de7dfea535525255b1aa35c5565e08b",
input = {
prompt = query,
width = 1024,
height = 1024,
num_outputs = 1
}
}
local url = "https://api.replicate.com/v1/predictions"
local headers = {
["Content-Type"] = "application/json",
["Authorization"] = "Token " .. REPLICATE_API_TOKEN
}
local json_data = json.encode(create_data)
local create_response = gg.makeRequest(url, headers, json_data, "POST")
if not create_response or not create_response.content then
gg.alert("Failed to create image generation request")
return
end
local success, prediction = pcall(json.decode, create_response.content)
if not success or not prediction.id then
gg.alert("Error creating prediction")
return
end
gg.toast("Image generating... please wait")
local max_attempts = 30
local attempt = 0
while attempt < max_attempts do
gg.sleep(2000)
local status_url = "https://api.replicate.com/v1/predictions/" .. prediction.id
local status_headers = {
["Authorization"] = "Token " .. REPLICATE_API_TOKEN
}
local status_response = gg.makeRequest(status_url, status_headers)
if status_response and status_response.content then
local success, status = pcall(json.decode, status_response.content)
if success then
if status.status == "succeeded" and status.output then
local image_url = status.output[1] or status.output
if type(image_url) == "table" then
image_url = image_url[1]
end
gg.alert("✅ Image generated!\n\nURL: " .. image_url)
if gg.alert("Download image?", "Yes", "No") == 1 then
local img_data = gg.makeRequest(image_url)
if img_data and img_data.content then
local filename = "ai_image_" .. os.time() .. ".png"
local filepath = saveFileToStorage(img_data.content, filename)
if filepath then
gg.alert("✅ Image saved to:\n" .. filepath)
else
gg.alert("❌ Failed to save image")
end
end
end
return
elseif status.status == "failed" then
gg.alert("❌ Image generation failed")
return
end
end
end
attempt = attempt + 1
end
gg.alert("Timeout. Check your Replicate dashboard.")
end

function main()
local apiChoice = selectAPI()
if not apiChoice then
gg.alert("Operation cancelled")
return
end
if apiChoice == 3 then
processReplicateImage()
return
end
local promptTitle = "Enter your question"
if apiChoice == 2 then
promptTitle = "Enter your question for Kimi K2.5 (NVIDIA)"
end
local chat = gg.prompt({promptTitle}, {}, {"text"})
if not chat or not chat[1] or chat[1]:trim() == "" then
gg.alert("Empty input or cancelled")
return
end
local query = chat[1]
local response
if apiChoice == 1 then
response = processMoonshotKimi(query, "kimi-k2-0905-preview")
elseif apiChoice == 2 then
response = processNVIDIAKimi(query)
end
if not response or not response.content then
gg.alert("Error connecting to API")
return
end
local result = formatMoonshotResponse(response)
if string.len(result) > 3000 then
if gg.alert("Result too long. Save to file?", "Yes", "No") == 1 then
local filename = "ai_response_" .. os.time() .. ".txt"
local filepath = saveFileToStorage(result, filename)
if filepath then
gg.alert("✅ Saved to:\n" .. filepath)
end
else
gg.alert(string.sub(result, 1, 3000) .. "...")
end
else
gg.alert(result)
end
if gg.copyText then
if gg.alert("Copy response?", "Yes", "No") == 1 then
gg.copyText(result)
gg.toast("Copied!")
end
end
end

main()