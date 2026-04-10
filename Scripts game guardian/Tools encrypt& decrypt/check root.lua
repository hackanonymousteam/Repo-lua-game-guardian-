file, err = io.open("/system/bin/su", "r")

if file then
    gg.alert("Rooted device! Starting the script...")
    file:close()
else
    gg.alert("Non-rooted device. This script requires a rooted device.")
    os.exit()
end


--check root