import "java.util.Date"

local Date = luajava.bindClass("java.util.Date")
local new = luajava.new

local currentDate = new(Date)
local specificDate = new(Date, 125, 10, 5)
local timestampDate = new(Date, 1741332776000)

print("Current Date:", currentDate:toString())
print("Specific Date:", specificDate:toString())
print("Timestamp Date:", timestampDate:toString())

local timestamp = currentDate:getTime()
print("Timestamp:", timestamp)

currentDate:setTime(1741332776000)
print("After setTime:", currentDate:toString())

local dayOfMonth = currentDate:getDate()
print("Day of Month:", dayOfMonth)

currentDate:setDate(15)
print("After setDate:", currentDate:toString())

local month = currentDate:getMonth()
print("Month:", month)

currentDate:setMonth(5)
print("After setMonth:", currentDate:toString())

local year = currentDate:getYear()
print("Year:", year)

currentDate:setYear(125)
print("After setYear:", currentDate:toString())

local dayOfWeek = currentDate:getDay()
print("Day of Week:", dayOfWeek)

local hours = currentDate:getHours()
print("Hours:", hours)

currentDate:setHours(14)
print("After setHours:", currentDate:toString())

local minutes = currentDate:getMinutes()
print("Minutes:", minutes)

currentDate:setMinutes(30)
print("After setMinutes:", currentDate:toString())

local seconds = currentDate:getSeconds()
print("Seconds:", seconds)

currentDate:setSeconds(45)
print("After setSeconds:", currentDate:toString())

local offset = currentDate:getTimezoneOffset()
print("Timezone Offset:", offset)

local parsedTimestamp = Date.parse("Nov 5, 2025")
print("Parsed Timestamp:", parsedTimestamp)

local gmtString = currentDate:toGMTString()
print("GMT String:", gmtString)

local instant = currentDate:toInstant()
print("Instant:", instant:toString())

local localeString = currentDate:toLocaleString()
print("Locale String:", localeString)

local stringData = currentDate:toString()
print("String:", stringData)

local hashCode = currentDate:hashCode()
print("Hash Code:", hashCode)

local date1 = new(Date)
local date2 = new(Date, date1:getTime() + 1000)

print("Date1:", date1:toString())
print("Date2:", date2:toString())
print("Equals:", date1:equals(date2))
print("Before:", date1:before(date2))
print("After:", date1:after(date2))
print("CompareTo:", date1:compareTo(date2))

print("Class:", currentDate:getClass():getName())

local baseDate = new(Date)
print("Base Date:", baseDate:toString())

baseDate:setDate(baseDate:getDate() + 5)
print("+5 days:", baseDate:toString())

baseDate:setMonth(baseDate:getMonth() + 2)
print("+2 months:", baseDate:toString())

baseDate:setYear(baseDate:getYear() + 1)
print("+1 year:", baseDate:toString())

local finalDate = new(Date)
print("Final Date:", finalDate:toString())

local summaryDate = new(Date)
print(string.format("Date: %02d/%02d/%d", 
    summaryDate:getDate(), 
    summaryDate:getMonth() + 1, 
    summaryDate:getYear() + 1900))

print(string.format("Time: %02d:%02d:%02d", 
    summaryDate:getHours(), 
    summaryDate:getMinutes(), 
    summaryDate:getSeconds()))

print("Timestamp:", summaryDate:getTime())
print("GMT:", summaryDate:toGMTString())