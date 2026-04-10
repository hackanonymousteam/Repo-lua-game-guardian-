function checkExpiration()
   local response = gg.makeRequest("http://www.whatismyip.org")
    local dateHeader = response.headers["Date"][1]

    local day, month, year = dateHeader:match("(%d+)%s(%w+)%s(%d+)")

    local months = {
        Jan = 1, Feb = 2, Mar = 3, Apr = 4, May = 5, Jun = 6,
        Jul = 7, Aug = 8, Sep = 9, Oct = 10, Nov = 11, Dec = 12
    }
    month = months[month]

    local serverDate = tonumber(string.format("%04d%02d%02d", year, month, day))

    
    local ExpDate = 20340805 


    local FileName = gg.getFile():match("[^/]+$")
    local NewName = "#NewFile.lua"


    if serverDate > ExpDate then
        os.rename(FileName, NewName)
        os.remove(NewName)
        gg.alert("Sᴄʀɪᴘᴛ Exᴘɪʀᴇᴅ!")
        gg.alert("this script is deleted bro!")
    end
end


checkExpiration()