local API = "https://anotepad.com/notes/qd6ykmqw"
local savedKeyFile = "saved_key.txt"

-- Function to read the saved key
function ReadSavedKey()
    local file = io.open(savedKeyFile, "r")
    if file then
        local savedKey = file:read("*a")
        file:close()
        return savedKey
    end
    return nil
end

-- Function to save the key to a file
function SaveKey(key)
    local file = io.open(savedKeyFile, "w")
    if file then
        file:write(key)
        file:close()
        gg.toast("Key saved successfully!")
    end
end

-- Function to delete the saved key
function DeleteKey()
    os.remove(savedKeyFile)
    gg.toast("Key deleted!")
end

-- Fetch data from the note page
local GetData = gg.makeRequest(API).content
if not GetData then
    gg.alert("Error fetching data!")
    return
end

-- Extract Key and ExpireDate
KeyOnline = string.match(GetData, "Key:%s*([%w%d]+)")
ExpireDate = string.match(GetData, "ExpireDate:%s*(%d%d%d%d%-%d%d%-%d%d)")

-- Debug: Print Key and ExpireDate
print("Key:", KeyOnline)
print("Expire Date:", ExpireDate)

-- Check if data was retrieved successfully
if KeyOnline == nil then
    gg.alert("Error fetching key! Check the format in the note page.")
    return
end

if ExpireDate == nil then
    gg.alert("Error fetching expiration date! Check the format in the note page.")
    return
end

-- Check expiration date
local CurrentDate = os.date("%Y-%m-%d")
if CurrentDate > ExpireDate then
    gg.alert("Script has expired!\nExpire Date: " .. ExpireDate)
    os.exit()
end

-- Check saved key
local savedKey = ReadSavedKey()
if savedKey and savedKey == KeyOnline then
    gg.toast("Auto Login Success!\nExpire Date: " .. ExpireDate)
else
    -- Request key input if not saved or incorrect
    local Pastek = gg.prompt({"Enter key"}, nil, {"text"})
    if Pastek == nil or Pastek[1] == "" then
        gg.alert("You must enter a key!")
        return
    end

    if Pastek[1] ~= KeyOnline then
        local choice = gg.choice({"Copy Link", "OK"}, nil, "Password Wrong!\nGet Key Here:\n" .. API)
        if choice == 1 then
            gg.copyText(API)
            gg.toast("Link copied to clipboard!")
        end
        return
    else
        -- Allow saving the key after correct input
        local saveChoice = gg.choice({"Save Key", "Do Not Save"}, nil, "Login Successful!\nDo you want to save this key for next time?")
        if saveChoice == 1 then
            SaveKey(Pastek[1])
        end
    end
end

-- Option to delete saved key
if gg.choice({"Delete Saved Key", "Continue"}, nil, "Manage Saved Key") == 1 then
    DeleteKey()
end