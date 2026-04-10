
local your_name_script = "antiloadFile.lua" --name script 
local getInfo = tostring(gg.getFile())

local filename = getInfo:match("^.+/(.+)$")

if filename then
    if filename == your_name_script then
        gg.alert("check sucess")
    else
    gg.alert("Please do not rename or  using loadfile.")
   os.remove(filename)
 os.exit()
    end
else
    gg.alert("failed get info")
    os.exit()
end 