function encrypt(val)
    return val * 1800
end

function decrypt(val)
    return val / 1800
end

gg.clearResults()
local address = ptm
local currentValue = gg.getValues({{address = address, flags = gg.TYPE_DWORD}})[1].value
local decryptedValue = decrypt(currentValue)
local currentHours = math.floor(decryptedValue / 60)
local formattedHours = tostring(currentHours):gsub("%.0$", "")
local currentMinutes = decryptedValue % 60

local userInput = gg.prompt(
    {"Enter hours:", "Enter minutes:", "Add (Enter 0 to keep unchanged)"},
    {formattedHours, currentMinutes, false},
    {"number", "number", 'checkbox'}
)

if userInput == nil or tonumber(userInput[1]) == nil or tonumber(userInput[2]) == nil then
    gg.alert("Invalid input. The script will exit.")
    result = "denied"
    return
end

local totalMinutes = tonumber(userInput[1]) * 60 + tonumber(userInput[2])
local action = userInput[3] and 1 or 2

if action == 1 then
    local newEncryptedValue = encrypt(decryptedValue + totalMinutes)
    gg.setValues({{address = address, value = newEncryptedValue, flags = gg.TYPE_DWORD}})
    gg.toast("Value successfully updated.")
else
    local newEncryptedValue = encrypt(totalMinutes)
    gg.setValues({{address = address, value = newEncryptedValue, flags = gg.TYPE_DWORD}})
    gg.toast("Value successfully updated.")
end