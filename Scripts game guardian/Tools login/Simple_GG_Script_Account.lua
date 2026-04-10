
local function handleLogin()
    while true do
        local inputs = gg.prompt({
            "Account: ",
            "Password:",
            "Agree to Terms of Service"
        }, {
            [1] = "Enter account",
            [2] = "Enter password",
            [3] = true
        }, {
            [1] = "text",
            [2] = "text",
            [3] = "checkbox"
        })
        
        if inputs == nil then
            print("You chose to exit login!")
            os.exit()
        end
        
        if not inputs[3] then
            gg.alert("Please agree to the Terms of Service")
            os.exit()
        end
        
        local account = inputs[1]
        local password = inputs[2]
       
        if (account == "Username" and password == "Password") or
           (account == "ZhangSan" and password == "Lee4") then
            gg.toast("Login successful")
            print("Account: " .. account)
            print("Password: " .. password)
            loginStatus = 1
            return true
        else
            gg.alert("Invalid account or password")
            gg.setVisible(true)
        end
    end
end

local loginStatus = 0.5
local function showLoginMenu()
    while true do
        local choice = gg.alert(
            "Please choose login method according to your situation",
            "Guest",
            "Login ",
            "Register"
        )
        
        if choice == 1 then
            gg.alert("Guest function is not available yet", "Back")
        elseif choice == 2 then
            handleLogin()
        elseif choice == 3 then
            gg.alert("Please contact the script author to register!", "Back")
        else
            print("Exiting script...")
            os.exit()
        end
    end
end

while true do
    if loginStatus == 0.5 then
      showLoginMenu()
    end
    
    if gg.isVisible(true) then
        loginStatus = 1
        gg.setVisible(false)
    end
    
    gg.clearResults()
    
    if loginStatus == 1 then       
    end
end