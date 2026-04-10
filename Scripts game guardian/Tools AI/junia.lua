gg.setVisible(true)

local Base_Api = "https://www.junia.ai/api/free-tools/generate"

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

local function juniaRequest(payload)
    local headers = {
        ["Content-Type"] = "application/json",
        ["x-api-client-version"] = "4",
        ["user-agent"] = "Mozilla/5.0 (Linux; Android 10; Redmi Note 5 Pro Build/QQ3A.200805.001) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.7204.179 Mobile Safari/537.36",
        ["x-requested-with"] = "com.chromasterZ.vn",
        ["origin"] = "https://www.junia.ai",
        ["referer"] = "https://www.junia.ai/tools/ai-speech-writer",
        ["accept"] = "*/*"
    }
    
    local response = gg.makeRequest(Base_Api, headers, json.encode(payload))
    
    if type(response) == "table" and response.code == 200 then
        return response.content, true
    end
    
    return "Error: " .. (response.code or "unknown"), false
end

local function cleanResult(text)
    if not text then return text end
    return tostring(text):gsub("%s?[0-9a-f]+%-[0-9a-f]+$", ""):gsub("^%s+", ""):gsub("%s+$", "")
end

local function aiSpeechWriter(details)
    local payload = {
        details = details,
        op = "ai-speech-writer"
    }
    local result, success = juniaRequest(payload)
    if success then
        return cleanResult(result), true
    end
    return result, false
end

local function recipeGenerator(details)
    local payload = {
        details = details,
        op = "recipe-generator"
    }
    local result, success = juniaRequest(payload)
    if success then
        return cleanResult(result), true
    end
    return result, false
end

local function projectNameGenerator(details)
    local payload = {
        details = details,
        op = "project-name-generator"
    }
    local result, success = juniaRequest(payload)
    if success then
        return cleanResult(result), true
    end
    return result, false
end

local function bulletPointsGenerator(details)
    local payload = {
        details = details,
        op = "bullet-points-generator"
    }
    local result, success = juniaRequest(payload)
    if success then
        return cleanResult(result), true
    end
    return result, false
end

local function aiDebateGenerator(details)
    local payload = {
        details = details,
        op = "ai-debate-generator"
    }
    local result, success = juniaRequest(payload)
    if success then
        return cleanResult(result), true
    end
    return result, false
end

local function humanize(content)
    local payload = {
        content = content,
        op = "op-humanize"
    }
    local result, success = juniaRequest(payload)
    if success then
        return cleanResult(result), true
    end
    return result, false
end

local function promptImage(content)
    local payload = {
        content = content,
        op = "op-prompt"
    }
    local result, success = juniaRequest(payload)
    if success then
        return cleanResult(result), true
    end
    return result, false
end

local function showMainMenu()
    local choices = {
        "AI Speech Writer",
        "Recipe Generator", 
        "Project Name Generator",
        "Bullet Points Generator",
        "AI Debate Generator",
        "Text Humanizer",
        "Image Prompt Generator",
       "TEST ALL TOOLS"
       -- "EXIT"
    }
    
    local choice = gg.choice(choices, nil, "JUNIA AI TOOLS\nChoose a tool:")
    
    if not choice then return false end
    
    return choice, choices[choice]
end

local function getUserInput(title, placeholder, multiline)
    if multiline then
        gg.alert(placeholder or "Please enter the text:")
        local input = gg.prompt({"Enter text:"}, {""}, {"text"})
        if input and input[1] and input[1] ~= "" then
            return input[1]
        end
    else
        local input = gg.prompt({title or "Enter details:"}, {placeholder or ""}, {"text"})
        if input and input[1] and input[1] ~= "" then
            return input[1]
        end
    end
    return nil
end

local function showResult(title, result, success)
    if success then
        local displayText = result
        if #displayText > 2000 then
            displayText = displayText:sub(1, 2000) .. "...\n\nResult too long, showing first 2000 characters"
        end
        
        local saveChoice = gg.choice(
            {"OK", "Save Result", "Copy to Clipboard"},
            nil,
            title .. " - SUCCESS!\n\n" .. displayText
        )
        
        if saveChoice == 2 then
            local filename = gg.prompt({"Filename:"}, {"result_" .. os.date("%Y%m%d_%H%M%S") .. ".txt"}, {"text"})
            if filename and filename[1] then
                local file = io.open("/sdcard/Download/" .. filename[1], "w")
                if file then
                    file:write(result)
                    file:close()
                    gg.toast("Saved to: /sdcard/Download/" .. filename[1])
                else
                    gg.alert("Error saving file")
                end
            end
        elseif saveChoice == 3 then
            gg.toast("Copied to clipboard")
        end
    else
        gg.alert(title .. " - FAILED!\n\nError: " .. tostring(result))
    end
end

local function runTool(toolNumber)
    local result, success
    
    if toolNumber == 1 then
        local input = getUserInput("Speech Topic", "Ex: Importance of education, Motivational speech, etc.")
        if input then
            gg.toast("Generating speech...")
            result, success = aiSpeechWriter(input)
            showResult("SPEECH WRITER", result, success)
        end
        
    elseif toolNumber == 2 then
        local input = getUserInput("Recipe Description", "Ex: chocolate cake, vegetarian food, etc.")
        if input then
            gg.toast("Generating recipe...")
            result, success = recipeGenerator(input)
            showResult("RECIPE GENERATOR", result, success)
        end
        
    elseif toolNumber == 3 then
        local input = getUserInput("Project Description", "Ex: fitness app, tech startup, etc.")
        if input then
            gg.toast("Generating names...")
            result, success = projectNameGenerator(input)
            showResult("PROJECT NAME GENERATOR", result, success)
        end
        
    elseif toolNumber == 4 then
        local input = getUserInput("Topic for Bullet Points", "Ex: benefits of exercise, advantages of reading, etc.")
        if input then
            gg.toast("Generating bullet points...")
            result, success = bulletPointsGenerator(input)
            showResult("BULLET POINTS GENERATOR", result, success)
        end
        
    elseif toolNumber == 5 then
        local input = getUserInput("Debate Topic", "Ex: AI in education, nuclear energy, etc.")
        if input then
            gg.toast("Generating debate...")
            result, success = aiDebateGenerator(input)
            showResult("DEBATE GENERATOR", result, success)
        end
        
    elseif toolNumber == 6 then
        local input = getUserInput("Text to Humanize", "Ex: very technical formal text...", true)
        if input then
            gg.toast("Humanizing text...")
            result, success = humanize(input)
            showResult("TEXT HUMANIZER", result, success)
        end
        
    elseif toolNumber == 7 then
        local input = getUserInput("Image Description", "Ex: sunset over mountains, futuristic city, etc.")
        if input then
            gg.toast("Generating prompt...")
            result, success = promptImage(input)
            showResult("IMAGE PROMPT GENERATOR", result, success)
        end
        
    elseif toolNumber == 8 then
        gg.alert("Starting test of all tools...")
        
        local testInputs = {
            "Short speech about freedom",
            "chocolate cake recipe", 
            "mobile app for fitness tracking",
            "benefits of exercise",
            "artificial intelligence in education",
            "The utilization of technological advancements facilitates enhanced productivity",
            "a beautiful sunset over mountains"
        }
        
        local testResults = {}
        
        for i, input in ipairs(testInputs) do
            gg.toast("Testing tool " .. i .. "/7...")
            
            if i == 1 then
                result, success = aiSpeechWriter(input)
                testResults[#testResults + 1] = {tool = "Speech Writer", result = result, success = success}
            elseif i == 2 then
                result, success = recipeGenerator(input)
                testResults[#testResults + 1] = {tool = "Recipe Generator", result = result, success = success}
            elseif i == 3 then
                result, success = projectNameGenerator(input)
                testResults[#testResults + 1] = {tool = "Project Name", result = result, success = success}
            elseif i == 4 then
                result, success = bulletPointsGenerator(input)
                testResults[#testResults + 1] = {tool = "Bullet Points", result = result, success = success}
            elseif i == 5 then
                result, success = aiDebateGenerator(input)
                testResults[#testResults + 1] = {tool = "Debate", result = result, success = success}
            elseif i == 6 then
                result, success = humanize(input)
                testResults[#testResults + 1] = {tool = "Humanize", result = result, success = success}
            elseif i == 7 then
                result, success = promptImage(input)
                testResults[#testResults + 1] = {tool = "Image Prompt", result = result, success = success}
            end
        end
        
        local testReport = "TEST REPORT:\n\n"
        for _, test in ipairs(testResults) do
            local status = test.success and "SUCCESS" or "FAILED"
            testReport = testReport .. test.tool .. ": " .. status .. "\n"
            if not test.success then
                testReport = testReport .. "   Error: " .. tostring(test.result) .. "\n"
            end
            testReport = testReport .. "\n"
        end
        
        gg.alert(testReport)
    end
    
    return true
end

gg.alert("WELCOME TO JUNIA AI TOOLS\n\nFree AI tools for various uses!")

while true do
    local choice, choiceName = showMainMenu()
    
    
    
    runTool(choice)
    
    local continuee = gg.choice({"Continue", "Exit"}, nil, "Use another tool?")
    if not continuee or continuee == 2 then
        gg.alert("Thank you for using Junia AI Tools!")
        break
    end
end