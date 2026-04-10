
local CONFIG = {
   TOKEN = "<Telegram bot token>",
    CHAT_ID = "<Chat or user ID>",
    MAX_LOGIN_ATTEMPTS = 3
}

local json = nil
if not pcall(function()
    json = load(gg.makeRequest("https://raw.githubusercontent.com/rxi/json.lua/master/json.lua").content)()
end) then
    json = require("json") or gg.alert("❌ JSON library not available")
    if not json then return end
end

local current_user = nil
local login_attempts = 0
local is_logged_in = false
local session_start = nil

function get_all_messages()
    gg.toast("🔄 Retrieving messages...")
    
    local url = "https://api.telegram.org/bot" .. CONFIG.TOKEN .. "/getUpdates?limit=100"
    local response = gg.makeRequest(url)
    
    if not response or not response.content then
        gg.alert("❌ Failed to connect to Telegram")
        return nil
    end
    
    local success, data = pcall(json.decode, response.content)
    if not success or not data.ok then
        gg.alert("❌ Error decoding messages")
        return nil
    end
    
    if not data.result or #data.result == 0 then
        gg.alert("❌ No messages found")
        return nil
    end
    
    return data.result
end

function extract_credentials_from_messages(messages)
    if not messages or #messages == 0 then
        gg.toast("❌ No messages available")
        return nil
    end
    
    for i = #messages, 1, -1 do
        local message = messages[i]
        local text = message.message and message.message.text
        
        if text then
            local success, credentials = pcall(json.decode, text)
            if success and type(credentials) == "table" then
                if credentials[1] and credentials[1].user then
                    gg.toast("✅ Credentials found!")
                    return credentials
                elseif credentials.user and credentials.pass then
                    return {credentials}
                end
            end
            
            local json_patterns = {"%b[]", "%b{}"}
            
            for _, pattern in ipairs(json_patterns) do
                local json_str = text:match(pattern)
                if json_str then
                    local success, credentials = pcall(json.decode, json_str)
                    if success and type(credentials) == "table" then
                        if credentials[1] and credentials[1].user or credentials.user then
                            return credentials[1] and credentials or {credentials}
                        end
                    end
                end
            end
        end
    end
    
    gg.alert("❌ No valid credentials JSON found!")
    return nil
end

function check_expiration(date_str)
    if not date_str then 
        return true
    end
    
    local year, month, day = date_str:match("(%d+)-(%d+)-(%d+)")
    if not year then 
        return true
    end
    
    local expire_time = os.time({
        year = tonumber(year), 
        month = tonumber(month), 
        day = tonumber(day),
        hour = 23, min = 59, sec = 59
    })
    local current_time = os.time()
    
    return current_time <= expire_time
end

function check_login(username, password)
    if login_attempts >= CONFIG.MAX_LOGIN_ATTEMPTS then
        gg.alert("🚫 Too many login attempts!")
        return false
    end
    
    gg.toast("🔍 Checking credentials...")
    
    local messages = get_all_messages()
    if not messages then
        login_attempts = login_attempts + 1
        gg.toast(string.format("❌ Error getting messages %d/%d", login_attempts, CONFIG.MAX_LOGIN_ATTEMPTS))
        return false
    end
    
    local credentials_list = extract_credentials_from_messages(messages)
    if not credentials_list then
        login_attempts = login_attempts + 1
        gg.toast(string.format("❌ Credentials not found %d/%d", login_attempts, CONFIG.MAX_LOGIN_ATTEMPTS))
        return false
    end
    
    local user_found = false
    local user_data = nil
    
    for _, cred in ipairs(credentials_list) do
        if cred.user and cred.user:lower() == username:lower() then
            user_found = true
            user_data = cred
            break
        end
    end
    
    if not user_found then
        login_attempts = login_attempts + 1
        gg.toast(string.format("❌ User not found! %d/%d", login_attempts, CONFIG.MAX_LOGIN_ATTEMPTS))
        return false
    end
    
    if user_data.pass ~= password then
        login_attempts = login_attempts + 1
        gg.toast(string.format("❌ Wrong password! %d/%d", login_attempts, CONFIG.MAX_LOGIN_ATTEMPTS))
        return false
    end
    
    if not check_expiration(user_data.data_de_expiracao) then
        gg.alert("❌ Account expired!")
        login_attempts = login_attempts + 1
        return false
    end
    
    login_attempts = 0
    current_user = username
    is_logged_in = true
    session_start = os.time()
    
    gg.toast("✅ Login successful!")
    return true
end

function show_user_info()
    if not current_user then return end
    
    gg.toast("📊 Getting information...")
    
    local messages = get_all_messages()
    local credentials_list = extract_credentials_from_messages(messages)
    
    if not credentials_list then
        gg.alert("❌ Could not load information")
        return
    end
    
    local user_info = nil
    for _, cred in ipairs(credentials_list) do
        if cred.user and cred.user:lower() == current_user:lower() then
            user_info = cred
            break
        end
    end
    
    if not user_info then
        gg.alert("❌ Information not found")
        return
    end
    
    local session_duration = os.time() - session_start
    local hours = math.floor(session_duration / 3600)
    local minutes = math.floor((session_duration % 3600) / 60)
    local seconds = session_duration % 60
    
    local status = "✅ Active"
    if user_info.data_de_expiracao then
        if not check_expiration(user_info.data_de_expiracao) then
            status = "❌ Expired"
        end
    end
    
    local info_text = string.format(
        "👤 User: %s\n📅 Expires: %s\n📊 Status: %s\n⏰ Session: %02d:%02d:%02d",
        current_user,
        user_info.data_de_expiracao or "Not defined",
        status,
        hours, minutes, seconds
    )
    
    gg.alert(info_text, "📋 Account Information")
end

function show_login_prompt()
    gg.alert("🔐 TELEGRAM LOGIN SYSTEM\n\nSend credentials via JSON to the bot", "Remote Access")
    
    while not is_logged_in and login_attempts < CONFIG.MAX_LOGIN_ATTEMPTS do
        local input = gg.prompt({
            "👤 Username", 
            "🔒 Password"
        }, nil, {"text", "password"})
        
        if input == nil then
            if gg.alert("Cancel login?", "Yes", "No") == 1 then
                return false
            end
        else
            local username = input[1] or ""
            local password = input[2] or ""
            
            if username ~= "" and password ~= "" then
                check_login(username, password)
            else
                gg.toast("⚠️ Fill all fields!")
            end
        end
    end
    
    return is_logged_in
end

function show_main_menu()
    local options = {
        "📋 View Information",
        "🚪 Exit"
    }
    
    while is_logged_in do
        local choice = gg.choice(options, nil, "🎮 MENU - " .. current_user)
        
        if not choice then
            if gg.alert("Exit?", "Yes", "No") == 1 then
                break
            end
        else
            if options[choice] == "📋 View Information" then
                show_user_info()
            elseif options[choice] == "🚪 Exit" then
                if gg.alert("Logout?", "Yes", "No") == 1 then
                    break
                end
            end
        end
    end
end

function logout()
    if current_user then
        gg.toast("👋 Goodbye, " .. current_user .. "!")
    end
    is_logged_in = false
    current_user = nil
end

function main()
    if not CONFIG.TOKEN or CONFIG.TOKEN == "<Telegram bot token>" then
        local token_input = gg.prompt({"🔑 Bot Token:"}, nil, {"text"})
        if token_input and token_input[1] then
            CONFIG.TOKEN = token_input[1]
        else
            gg.alert("❌ Token required!")
            return
        end
    end
    
    if show_login_prompt() then
        gg.alert("✅ Welcome, " .. current_user .. "!")
        show_main_menu()
        logout()
    end
    
    gg.alert("👋 Program ended!")
end

pcall(main)