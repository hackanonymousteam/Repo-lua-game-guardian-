local path = "/system/vendor/odm/etc/build.prop"

local file = io.open(path, "r")

if not file then
    print("No available")
    return
end

local DATA = file:read("*a")
file:close()

if not DATA then
    print("No available")
    return
end

gg.alert(DATA)