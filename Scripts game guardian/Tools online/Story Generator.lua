gg.setVisible(true)

local API_URL = "https://aifreebox.com/api/ai"
local API_KEY = "AIFreeBox"
local API_TOKEN = "9n3ogbkqob"

local GENRE_OPTIONS = {
    "Comedy", "Drama", "Fantasy", "Horror", "Mystery",
    "Romance", "Sci-Fi", "Thriller", "Adventure", "Crime",
    "Dystopian", "LGBTQ+", "Children's Fiction", "Coming-of-age", "Epic"
}

local LANGUAGE_OPTIONS = {
    "English", "Spanish", "French", "German", "Indonesian",
    "Japanese", "Chinese", "Russian", "Portuguese", "Italian"
}

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

local function generateStory(prompt, genre, language, creativity)
    local payload = {
        prompt = prompt,
        language = language,
        creativity = creativity,
        user_style = genre,
        userId = "",
        direction = "ltr",
        slug = "ai-story-generator",
        token = API_TOKEN
    }

    local jsonPayload = json.encode(payload)

    local headers = {
        ["Content-Type"] = "application/json",
        ["x-api-key"] = API_KEY
    }

    gg.toast("Generating story...")
    local response = gg.makeRequest(API_URL, headers, jsonPayload)

    if type(response) == "table" and response.code == 200 then
        local story = ""
        local lines = {}
        
        for line in response.content:gmatch("[^\r\n]+") do
            table.insert(lines, line)
        end
        
        for _, line in ipairs(lines) do
            if line:sub(1, 3) == '0:"' then
                local textPart = line:sub(4, -2)
                textPart = textPart:gsub("\\n", "\n")
                story = story .. textPart
            end
        end
        
        if story ~= "" then
            return story, true
        else
            return "No story content received", false
        end
    else
        local errorMsg = "API error: "
        if type(response) == "table" then
            errorMsg = errorMsg .. "Code " .. (response.code or "N/A")
            if response.content then
                errorMsg = errorMsg .. "\n" .. response.content
            end
        else
            errorMsg = errorMsg .. tostring(response)
        end
        return errorMsg, false
    end
end

local function selectGenre()
    local choice = gg.choice(GENRE_OPTIONS, nil, "Select Story Genre")
    if choice then
        return GENRE_OPTIONS[choice]
    end
    return GENRE_OPTIONS[1]
end

local function selectLanguage()
    local choice = gg.choice(LANGUAGE_OPTIONS, nil, "Select Language")
    if choice then
        return LANGUAGE_OPTIONS[choice]
    end
    return LANGUAGE_OPTIONS[1]
end

local function storyGeneratorMenu()
    while true do
        local options = {
            "Generate Story",
            "Quick Story",
            "Exit"
        }
        
        local choice = gg.choice(options, nil, "AI Story Generator")
        
        if choice == nil or choice == 3 then
            break
            
        elseif choice == 1 then
            local storyInput = gg.prompt({
                'Enter your story idea:',
                'Creativity level (1-10):'
            }, {'A space adventure about lost astronauts', '7'}, {'text', 'number'})
            
            if storyInput and storyInput[1] and storyInput[1] ~= "" then
                local genre = selectGenre()
                local language = selectLanguage()
                local creativity = math.min(10, math.max(1, tonumber(storyInput[2]) or 5))
                
                local story, success = generateStory(storyInput[1], genre, language, creativity)
                
                if success then
                    gg.alert("📖 Generated Story\n\nGenre: " .. genre .. "\nLanguage: " .. language .. "\n\n" .. story)
                    
                    if gg.copyText then
                        if gg.alert("Copy story to clipboard?", "Yes", "No") == 1 then
                            gg.copyText(story)
                            gg.toast("Story copied!")
                        end
                    end
                else
                    gg.alert("Error: " .. story)
                end
            end
            
        elseif choice == 2 then
            local quickInput = gg.prompt({
                'Quick story idea:'
            }, {'A mysterious door appears in the forest'}, {'text'})
            
            if quickInput and quickInput[1] and quickInput[1] ~= "" then
                local story, success = generateStory(quickInput[1], "Fantasy", "English", 7)
                
                if success then
                    gg.alert("📖 Quick Story\n\n" .. story)
                else
                    gg.alert("Error: " .. story)
                end
            end
        end
    end
end

local startChoice = gg.choice({
    "Story Generator",
    "Exit"
}, nil, "AI Story Generator")

if startChoice == 1 then
    storyGeneratorMenu()
end