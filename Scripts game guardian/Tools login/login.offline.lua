local b64chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'

local function base64_encode(data)
    return ((data:gsub('.', function(x) 
        local r,b = '', x:byte()
        for i = 8, 1, -1 do 
            r = r .. (b % 2^i - b % 2^(i-1) > 0 and '1' or '0') 
        end
        return r
    end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
        if #x < 6 then return '' end
        local c = 0
        for i = 1, 6 do 
            c = c + (x:sub(i,i) == '1' and 2^(6-i) or 0) 
        end
        return b64chars:sub(c+1, c+1)
    end) .. ({'', '==', '='})[#data % 3 + 1])
end

local function base64_decode(data)
    data = string.gsub(data, '[^' .. b64chars .. '=]', '')
    return (data:gsub('.', function(x)
        if x == '=' then return '' end
        local r, f = '', (b64chars:find(x) - 1)
        for i = 6, 1, -1 do 
            r = r .. (f % 2^i - f % 2^(i-1) > 0 and '1' or '0') 
        end
        return r
    end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
        if #x ~= 8 then return '' end
        local c = 0
        for i = 1, 8 do 
            c = c + (x:sub(i,i) == '1' and 2^(8-i) or 0) 
        end
        return string.char(c)
    end))
end

local function bxor(a, b) return a ~ b end

local function simple_hash(str, seed)
    local h = seed or 0x9E3779B9
    for i = 1, #str do
        h = bxor(h, string.byte(str, i) * i)
        h = (h * 0x45D9F3B) & 0xFFFFFFFF
    end
    return h
end

local function derive_key(key, length)
    local kb = {}
    for i = 1, #key do kb[i] = string.byte(key, i) end
    
    local out = {}
    local state = simple_hash(key, 0xDEADBEEF)
    
    for i = 1, length do
        state = ((state * 0x41C64E6D) + 0x3039) & 0xFFFFFFFF
        local idx = (state % #kb) + 1
        out[i] = (state ~ kb[idx]) & 0xFF
    end
    return out
end

local function aes_like_encrypt(data, key_str)
    local key = key_str
    if #key < 16 then
        key = key .. string.rep('0', 16 - #key)
    elseif #key > 16 then
        key = key:sub(1, 16)
    end
    
    local keystream = derive_key(key, #data)
    local out = {}
    
    for i = 1, #data do
        local b = string.byte(data, i)
        local k = keystream[i]
        local prev = out[i-1] and string.byte(out[i-1]) or 0xAA
        out[i] = string.char(((b + k + prev) % 256) ~ (k * 0x1B) & 0xFF)
    end
    
    return table.concat(out)
end

local function aes_like_decrypt(data, key_str)
    local key = key_str
    if #key < 16 then
        key = key .. string.rep('0', 16 - #key)
    elseif #key > 16 then
        key = key:sub(1, 16)
    end
    
    local keystream = derive_key(key, #data)
    local out = {}
    
    for i = 1, #data do
        local b = string.byte(data, i)
        local k = keystream[i]
        local prev = i > 1 and string.byte(data, i-1) or 0xAA
        
        local x = (b ~ (k * 0x1B)) & 0xFF
        out[i] = string.char((x - k - prev) % 256)
    end
    
    return table.concat(out)
end

local Crypto = {
    MASTER_KEY = "K8wZ3uP1nS4XqE2V",
    IV = "zenin_xytA9F2QK"
}

function Crypto.encrypt(plaintext)
    local stage1 = base64_encode(plaintext)
    local stage2 = aes_like_encrypt(stage1, Crypto.MASTER_KEY)
    local stage3 = base64_encode(stage2)
    return stage3
end

function Crypto.decrypt(ciphertext)
    local stage1 = base64_decode(ciphertext)
    local stage2 = aes_like_decrypt(stage1, Crypto.MASTER_KEY)
    local stage3 = base64_decode(stage2)
    return stage3
end

local STORAGE_PATH = "/storage/emulated/0/Notes/.sys.dat"

local function save_credentials(username, password)
    local data = username .. ":" .. password
    local encrypted = Crypto.encrypt(data)
    local file = io.open(STORAGE_PATH, "w")
    if file then
        file:write(encrypted)
        file:close()
        return true
    end
    return false
end

local function load_credentials()
    local file = io.open(STORAGE_PATH, "r")
    if not file then return nil, nil end
    
    local encrypted = file:read("*a")
    file:close()
    
    if encrypted and #encrypted > 0 then
        local decrypted = Crypto.decrypt(encrypted)
        if decrypted then
            local user, pass = decrypted:match("^([^:]+):(.+)$")
            return user, pass
        end
    end
    return nil, nil
end

local function delete_credentials()
    os.remove(STORAGE_PATH)
    gg.toast("Logged out successfully")
end

local function validate_username(u)
    return u and u:match("^[a-zA-Z]+$") and #u >= 3
end

local function validate_password(p)
    return p and p:match("^[0-9]+$") and #p >= 4
end

local function MAIN_MENU()
    local saved_user, saved_pass = load_credentials()
    
    if saved_user and saved_pass then
        local choice = gg.choice({
            "Login with saved account",
            "Login with other account", 
            "Register new account",
            "Delete saved account",
            "Exit"
        }, nil, "Welcome back, " .. saved_user)
        
        if choice == 1 then
            LOGIN(saved_user, saved_pass)
        elseif choice == 2 then
            LOGIN_MANUAL()
        elseif choice == 3 then
            REGISTER()
        elseif choice == 4 then
            delete_credentials()
            MAIN_MENU()
        elseif choice == 5 then
            EXIT()
        end
    else
        local choice = gg.choice({
            "Login",
            "Register",
            "Exit"
        }, nil, "Welcome - Please authenticate")
        
        if choice == 1 then
            LOGIN_MANUAL()
        elseif choice == 2 then
            REGISTER()
        elseif choice == 3 then
            EXIT()
        end
    end
end

function LOGIN(saved_user, saved_pass)
    if saved_user and saved_pass then
        local input = gg.prompt({
            "Username:",
            "Password:"
        }, {saved_user, ""}, {"text", "text"})
        
        if not input then MAIN_MENU() return end
        
        if input[1] == saved_user and input[2] == saved_pass then
            SUCCESS()
        else
            gg.alert("Invalid credentials")
            MAIN_MENU()
        end
    end
end

function LOGIN_MANUAL()
    local input = gg.prompt({
        "Username:",
        "Password:"
    }, nil, {"text", "text"})
    
    if not input then MAIN_MENU() return end
    
    local saved_user, saved_pass = load_credentials()
    
    if saved_user and input[1] == saved_user and input[2] == saved_pass then
        SUCCESS()
    else
        gg.alert("Invalid credentials")
        MAIN_MENU()
    end
end

function REGISTER()
    local input = gg.prompt({
        "Username (letters only, min 3):",
        "Password (numbers only, min 4):",
        "Confirm Password:"
    }, nil, {"text", "text", "text"})
    
    if not input then MAIN_MENU() return end
    
    local user, pass, confirm = input[1], input[2], input[3]
    
    if not validate_username(user) then
        gg.alert("Invalid username format")
        return REGISTER()
    end
    
    if not validate_password(pass) then
        gg.alert("Invalid password format")
        return REGISTER()
    end
    
    if pass ~= confirm then
        gg.alert("Passwords do not match")
        return REGISTER()
    end
    
    if save_credentials(user, pass) then
        gg.alert("Registration successful!")
        MAIN_MENU()
    else
        gg.alert("Failed to save credentials")
        MAIN_MENU()
    end
end

function SUCCESS()
    gg.setVisible(false)
    gg.toast("Access granted - System unlocked")
    gg.alert("Login successful!\n\nWelcome to the protected system.")
    os.exit()
end

function EXIT()
    gg.toast("Goodbye!")
    os.exit()
end

MAIN_MENU()