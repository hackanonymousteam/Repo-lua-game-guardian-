-- This code blocks the months of the year. preventing the script from running on certain months.
-- month blocked in table: block_month_year

local months = {
"Jan",
"Feb",
"Mar",
"Apr",
"May",
"Jun",
"Jul",
"Aug",
"Sep",
"Oct",
"Nov",
"Dec"

}

local block_month_year = {
    ["Sep"] = true,
    ["Nov"] = true,
    ["Dec"] = true
}

local function verify(pais)
    return block_month_year[pais]
end

local month = os.date('%b')

if month then
    if verify(month) then
        gg.alert("month incorrect, script no work this month")
        os.exit()
    else
        print("sucess")
    end
else
    gg.alert("Failed to get month")
    os.exit()
end