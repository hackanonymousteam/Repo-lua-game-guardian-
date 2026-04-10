local Link = "https://www.geoplugin.com/"
local bat = gg.makeRequest(Link).content

if bat == nil then os.exit() end

local latitude = bat:match('"geoplugin_latitude"%s*:%s*<span.-geo%-red">([%-%d%.]+)</span>')
local longitude = bat:match('"geoplugin_longitude"%s*:%s*<span.-geo%-red">([%-%d%.]+)</span>')

if not latitude or not longitude then
    print("Erro.")
    os.exit()
end

print("Latitude:", latitude)
print("Longitude:", longitude)

local osmURL = "https://nominatim.openstreetmap.org/reverse?lat="..latitude.."&lon="..longitude.."&format=json"
local geojson = gg.makeRequest(osmURL).content

if not geojson then
    print("Erro in request OSM.")
    os.exit()
end

local display_name
for match in geojson:gmatch('"display_name"%s*:%s*"([^"]+)"') do
    display_name = match
    break
end

if not display_name then
    print("Erro")
    os.exit()
end

print("Local (display_name):", display_name)

local function encodeURI(str)
    str = str:gsub("([^%w])", function(c)
        return string.format("%%%02X", string.byte(c))
    end)
    return str
end

gg.setVisible(true)

