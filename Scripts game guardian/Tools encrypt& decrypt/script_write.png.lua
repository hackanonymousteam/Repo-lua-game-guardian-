Link = "https://firebasestorage.googleapis.com/v0/b/antiban-by-st.appspot.com/o/icon_bookmark_open.png?alt=media&token=a1ab14f9-49d2-4cbc-b265-b7345dbf5d75"
path = "/sdcard/"
Name = "Photo_For_Test.png"
Satan = gg.makeRequest(Link).content
if Satan == nil then
os.exit() end
io.open(path .. "/" .. Name, "w"):write(Satan)