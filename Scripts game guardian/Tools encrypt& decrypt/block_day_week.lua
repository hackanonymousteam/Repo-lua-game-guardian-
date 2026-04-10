-- This code blocks the days of the week. preventing the script from running on certain days.
-- days blocked in table: block_day_week

local days = {
    "Mon",
    "Tue",
    "Wed",
    "Thu",
    "Fri",
    "Sat",
    "Sun"
}

local block_day_week = {
    ["Mon"] = true,
    ["Tue"] = true,
    ["Sat"] = true
}

local function verify(pais)
    return block_day_week[pais]
end

local day = os.date('%a')

if day then
    if verify(day) then
        gg.alert("day week incorrect, script no work this day")
        os.exit()
    else
        print("sucess")
    end
else
    gg.alert("Failed to get date")
    os.exit()
end