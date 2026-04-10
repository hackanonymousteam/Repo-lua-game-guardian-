import "android.content.Context"

local PREFS_NAME = gg.PACKAGE.."_login_prefs"
local USER_KEY = "username"
local PASS_KEY = "password"

local sharedPrefs = activity.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
local editor = sharedPrefs.edit()

function registerUser()
    local result = gg.prompt(
        {"create your user", "create your pass"},
        {"", ""},
        {"text", "text"}
    )
    
    if result == nil then
        gg.alert("cancel!")
        return false
    end
    
    local username = result[1]
    local password = result[2]
    
    if #username < 3 or #password < 3 then
        gg.alert("please enter minime 3 chars!")
        return false
    end
   
    editor.putString(USER_KEY, username)
    editor.putString(PASS_KEY, password)
    editor.commit()
    
    gg.alert("sucess register!\n\nuser: "..username)
    return true
end

function loginUser()
    local savedUser = sharedPrefs.getString(USER_KEY, nil)
    local savedPass = sharedPrefs.getString(PASS_KEY, nil)
    
    if not savedUser or not savedPass then
        gg.alert("Nenhum usuário cadastrado!")
        return registerUser()
    end
    
    local result = gg.prompt(
        {"user", "pass"},
        {"", ""},
        {"text", "text"}
    )
    
    if result == nil then
        gg.alert("Login cancel!")
        return false
    end
    
    local inputUser = result[1]
    local inputPass = result[2]
    
    if inputUser == savedUser and inputPass == savedPass then
        gg.alert("Login sucess!\n\nWelcome, "..savedUser.."!")
        return true
    else
        gg.alert("invalid!")
        return false
    end
end

function main()
    local savedUser = sharedPrefs.getString(USER_KEY, nil)
    
    if not savedUser then
        gg.alert("welcome! last go your register.")
        registerUser()
    else
        gg.alert("welcome! please enter your login.")
        loginUser()
    end
end

main()