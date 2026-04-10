-- This code blocks the hours of the day. preventing the script from running on certain hours.
-- hours blocked in table: block_hour_day

local block_hour_day = {
    ["13"] = true,
    ["17"] = true,
    ["07"] = true
}

local function verify(pais)
    return block_hour_day[pais]
end

local hour = os.date('%H')

if hour then
    if verify(hour) then
        gg.alert("hour incorrect, script no work this hour")
        os.exit()
    else
        print("sucess")
    end
else
    gg.alert("Failed to get hour")
    os.exit()
end