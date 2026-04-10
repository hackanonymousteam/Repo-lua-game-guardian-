gg.setVisible(true)

local json = nil
if not pcall(function()
json = load(gg.makeRequest("https://raw.githubusercontent.com/rxi/json.lua/master/json.lua").content)()
end) then
json = require("json") or gg.alert("JSON library not available")
if not json then return end
end

local USERS_FILE = "cf_chat.json"
local API_URL = "https://aifreeforever.com/api/generate-ai-answer"
local REFERER = "https://aifreeforever.com/tools/free-chatgpt-no-login"

function fileExists(filename)
local file = io.open(filename, "r")
if file then
file:close()
return true
end
return false
end

function safeReadUsers()
local usersData = {}

if fileExists(USERS_FILE) then
local file = io.open(USERS_FILE, "r")
if file then
local content = file:read("*a")
file:close()

if content and content:trim() ~= "" then
local success, result = pcall(json.decode, content)
if success then
usersData = result
else
gg.toast("Error reading conversation file")
end
end
end
end

return usersData
end

function saveUsers(usersData)
local file = io.open(USERS_FILE, "w")
if file then
file:write(json.encode(usersData))
file:close()
return true
end
return false
end

function getConversationHistory(uid)
local users = safeReadUsers()
return users[tostring(uid)] or {}
end

function saveConversationHistory(uid, history)
local users = safeReadUsers()

if #history > 10 then
local newHistory = {}
for i = #history - 9, #history do
table.insert(newHistory, history[i])
end
history = newHistory
end

users[tostring(uid)] = history
return saveUsers(users)
end

function clearConversation(uid)
local users = safeReadUsers()
users[tostring(uid)] = nil
return saveUsers(users)
end

function buildFullPrompt(history, newQuestion)
local fullPrompt = ""

if #history > 0 then
fullPrompt = "Conversation history:\n"
for i, msg in ipairs(history) do
fullPrompt = fullPrompt .. msg.role .. ": " .. msg.content .. "\n"
end
fullPrompt = fullPrompt .. "\n"
end

fullPrompt = fullPrompt .. "Current question: " .. newQuestion

return fullPrompt
end

function chatWithAPI(prompt, uid, imageUrl)
local history = getConversationHistory(uid)

if prompt:trim():lower() == "clear" or prompt:trim():lower() == "limpar" then
clearConversation(uid)
return "Conversation cleared successfully!"
end

local fullPrompt = buildFullPrompt(history, prompt:trim())

local payload = {
question = fullPrompt,
tone = "friendly",
format = "paragraph"
}

if imageUrl and imageUrl:trim() ~= "" then
payload.file = {
data = "",
type = "image/jpeg",
name = "image.jpg"
}
end

local headers = {
["accept"] = "*/*",
["content-type"] = "application/json",
["referer"] = REFERER,
["user-agent"] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"
}

gg.toast("Processing your question...")

local response = gg.makeRequest(
API_URL,
headers,
json.encode(payload),
"POST"
)

if type(response) ~= "table" then
return "Request error: No response from server"
end

if response.code ~= 200 then
local errorMsg = "Error " .. response.code .. ": "
if response.content then
errorMsg = errorMsg .. response.content
else
errorMsg = errorMsg .. "Failed to communicate with server"
end
return errorMsg
end

local success, data = pcall(json.decode, response.content)
if success and data then
local answer = data.result or data.answer or "Answer not found in expected format"

table.insert(history, {role = "user", content = prompt:trim()})
table.insert(history, {role = "assistant", content = answer})
saveConversationHistory(uid, history)

return answer
else
return "Error processing server response: " .. response.content
end
end

local function main()
local inputs = gg.prompt({
'Your question:',
'User ID (optional):',
'Image URL (optional):'
}, {
'',
'user_' .. os.time(),
''
}, {
'text',
'text',
'text'
})

if not inputs or not inputs[1] or inputs[1]:trim() == "" then
gg.alert("Operation canceled or empty question!")
return
end

local question = inputs[1]
local userId = inputs[2]:trim() ~= "" and inputs[2] or "user_" .. os.time()
local imageUrl = inputs[3]:trim() ~= "" and inputs[3] or nil

if question:lower() == "clear" or question:lower() == "limpar" then
clearConversation(userId)
gg.alert("Conversation cleared successfully!")
return
end

gg.toast("Please wait, processing...")
local startTime = os.time()

local responseText = chatWithAPI(question, userId, imageUrl)

local endTime = os.time()
local completionTime = endTime - startTime

local finalMessage = string.format("Response (%ds):\n\n%s", completionTime, responseText)
gg.alert(finalMessage)

if gg.copyText then
local choice = gg.alert(
finalMessage .. "\n\nWould you like to copy the response?",
"Yes, copy",
"No",
"New question"
)

if choice == 1 then
gg.copyText(responseText)
gg.toast("Response copied!")
elseif choice == 3 then
main()
end
else
local choice = gg.alert(
finalMessage .. "\n\nWould you like to ask another question?",
"Yes",
"No"
)

if choice == 1 then
main()
end
end
end

gg.alert([[Free AI Chat

Available commands:
• Your question - Send to AI
• "clear" - Clear conversation history
• Image URL - Optional for image analysis

Click OK to start!]])

main()