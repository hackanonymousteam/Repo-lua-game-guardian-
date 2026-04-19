local json = load(gg.makeRequest("https://raw.githubusercontent.com/rxi/json.lua/master/json.lua").content)()

local SunDateSimple = {}

local DEGRAD = 0.017453292519943295
local INV360 = 0.002777777777777778
local RADEG = 57.29577951308232

local function cosd(d) return math.cos(d * DEGRAD) end
local function sind(d) return math.sin(d * DEGRAD) end
local function acosd(d) return math.acos(d) * RADEG end
local function atan2d(y, x) return math.atan2(y, x) * RADEG end
local function rev180(d) return d - (math.floor((INV360 * d) + 0.5) * 360.0) end
local function revolution(d) return d - (math.floor(INV360 * d) * 360.0) end

local function days_since_2000_Jan_0(y, m, d)
    return (((y * 367) - math.floor(((y + math.floor((m + 9) / 12)) * 7) / 4)) + math.floor((m * 275) / 9) + d) - 730530
end

local function GMST0(d) return revolution((d * 0.985647352) + 818.9874) end

local function sunposAtDay(d, lon, r)
    local M = revolution((0.9856002585 * d) + 356.047)
    local w = (4.70935e-5 * d) + 282.9404
    local e = 0.016709 - (d * 1.151e-9)
    local E = M + ((RADEG * e) * sind(M)) * (1.0 + (e * cosd(M)))
    local xv = cosd(E) - e
    local yv = math.sqrt(1.0 - (e * e)) * sind(E)
    r[1] = math.sqrt((xv * xv) + (yv * yv))
    local v = atan2d(yv, xv)
    lon[1] = v + w
    if lon[1] >= 360.0 then lon[1] = lon[1] - 360.0 end
end

local function sun_RA_decAtDay(d, ra, dec, r)
    local lon = {0}
    sunposAtDay(d, lon, r)
    local xs = r[1] * cosd(lon[1])
    local ys = r[1] * sind(lon[1])
    local oblecl = 23.4393 - (d * 3.563e-7)
    local xe = xs
    local ye = ys * cosd(oblecl)
    local ze = ys * sind(oblecl)
    ra[1] = atan2d(ye, xe)
    dec[1] = atan2d(ze, math.sqrt((xe * xe) + (ye * ye)))
end

local function sunRiseSetHelperForYear(year, month, day, lat, lon, altit, upper_limb, out)
    local ra = {0}
    local dec = {0}
    local r = {0}
    local d = ((days_since_2000_Jan_0(year, month, day) + 0.5) - (lon / 360.0))
    local sidtime = revolution((GMST0(d) + 180.0) + lon)
    sun_RA_decAtDay(d, ra, dec, r)
    local tsouth = 12.0 - (rev180(sidtime - ra[1]) / 15.0)
    local sradius = 0.2666 / r[1]
    local t = (sind(altit - (upper_limb ~= 0 and sradius or 0.0)) - (sind(lat) * sind(dec[1]))) / (cosd(lat) * cosd(dec[1]))
    local tdiff
    local rc
    if t >= 1.0 then
        tdiff = 0.0
        rc = -1
    elseif t <= -1.0 then
        tdiff = 0.0
        rc = 1
    else
        tdiff = acosd(t) / 15.0
        rc = 0
    end
    out[1] = tsouth - tdiff
    out[2] = tsouth + tdiff
    return rc
end

local function sunRiseSetForYear(year, month, day, lat, lon, out)
    return sunRiseSetHelperForYear(year, month, day, lat, lon, -0.5833333333333334, 1, out)
end

local function adjustMinutes(minutes)
    if minutes < 0 then return minutes + 1440 end
    if minutes >= 1440 then return minutes - 1440 end
    return minutes
end

local function formatTime(totalMinutes)
    local hour = math.floor(totalMinutes / 60)
    local min = totalMinutes % 60
    return string.format("%02d:%02d", hour, min)
end

function SunDateSimple.getSunriseSunset(latitude, longitude)
    local current_time = os.time()
    local date_table = os.date("*t", current_time)
    local sunTimes = {0, 0}

    sunRiseSetForYear(
        date_table.year,
        date_table.month,
        date_table.day,
        latitude,
        longitude,
        sunTimes
    )

    local offset = math.floor(os.difftime(os.time(), os.time(os.date("!*t"))) / 60)

    local sunrise = math.floor(sunTimes[1] * 60.0) + offset
    local sunset  = math.floor(sunTimes[2] * 60.0) + offset

    sunrise = adjustMinutes(sunrise)
    sunset  = adjustMinutes(sunset)

    return {formatTime(sunrise), formatTime(sunset)}
end

function SunDateSimple.getSunriseSunsetForDate(year, month, day, latitude, longitude)
    local sunTimes = {0, 0}

    sunRiseSetForYear(year, month, day, latitude, longitude, sunTimes)

    local offset = math.floor(os.difftime(os.time(), os.time(os.date("!*t"))) / 60)

    local sunrise = math.floor(sunTimes[1] * 60.0) + offset
    local sunset  = math.floor(sunTimes[2] * 60.0) + offset

    sunrise = adjustMinutes(sunrise)
    sunset  = adjustMinutes(sunset)

    return {formatTime(sunrise), formatTime(sunset)}
end

local function fetchLocation()
    local apis = {
        {url = "https://ipwho.is/", lat = "latitude", lon = "longitude", city = "city", country = "country"},
        {url = "https://ipapi.co/json/", lat = "latitude", lon = "longitude", city = "city", country = "country_name"},
        {url = "https://ipinfo.io/json", lat = nil, lon = nil, city = "city", country = "country", loc = "loc"},
        {url = "http://ip-api.com/json", lat = "lat", lon = "lon", city = "city", country = "country"}
    }
    
    for _, api in ipairs(apis) do
        local req = gg.makeRequest(api.url)
        if req and req.content then
            local success, data = pcall(json.decode, req.content)
            if success and data then
                local lat, lon
                if api.loc then
                    local loc = data[api.loc]
                    if loc then
                        local parts = {}
                        for part in loc:gmatch("[^,]+") do table.insert(parts, part) end
                        if #parts >= 2 then
                            lat = tonumber(parts[1])
                            lon = tonumber(parts[2])
                        end
                    end
                else
                    if data[api.lat] and data[api.lon] then
                        lat = tonumber(data[api.lat])
                        lon = tonumber(data[api.lon])
                    end
                end
                
                if lat and lon then
                    if lat >= -90 and lat <= 90 and lon >= -180 and lon <= 180 then
                        return {
                            latitude = lat,
                            longitude = lon,
                            city = data[api.city] or "Unknown",
                            country = data[api.country] or "Unknown"
                        }
                    end
                end
            end
        end
    end
    
    return nil
end

local function showSunTimes()
    gg.toast("Fetching location...")
    local loc = fetchLocation()
    
    if not loc then
        gg.alert("Failed to get location. Please check internet connection.")
        return
    end
    
    local times = SunDateSimple.getSunriseSunset(loc.latitude, loc.longitude)
    
    local message = string.format([[
Location: %s, %s
Coordinates: %.4f, %.4f
Date: %s

Sunrise: %s
Sunset: %s
    ]], 
        loc.city, loc.country,
        loc.latitude, loc.longitude,
        os.date("%Y-%m-%d"),
        times[1], times[2]
    )
    
    gg.alert(message)
end

local function showSunTimesForDate()
    local inputs = gg.prompt({
        "Day (1-31):",
        "Month (1-12):",
        "Year (e.g., 2026):"
    }, {nil, nil, nil}, {"number", "number", "number"})
    
    if not inputs then return end
    
    local day = tonumber(inputs[1])
    local month = tonumber(inputs[2])
    local year = tonumber(inputs[3])
    
    if not day or not month or not year then
        gg.alert("Invalid date!")
        return
    end
    
    if day < 1 or day > 31 or month < 1 or month > 12 then
        gg.alert("Invalid date range!")
        return
    end
    
    gg.toast("Fetching location...")
    local loc = fetchLocation()
    
    if not loc then
        gg.alert("Failed to get location.")
        return
    end
    
    local times = SunDateSimple.getSunriseSunsetForDate(year, month, day, loc.latitude, loc.longitude)
    
    local message = string.format([[
Location: %s, %s
Coordinates: %.4f, %.4f
Date: %04d-%02d-%02d

Sunrise: %s
Sunset: %s
    ]], 
        loc.city, loc.country,
        loc.latitude, loc.longitude,
        year, month, day,
        times[1], times[2]
    )
    
    gg.alert(message)
end

local function showDayLength()
    gg.toast("Fetching location...")
    local loc = fetchLocation()
    
    if not loc then
        gg.alert("Failed to get location.")
        return
    end
    
    local times = SunDateSimple.getSunriseSunset(loc.latitude, loc.longitude)
    
    local function timeToMinutes(t)
        local h, m = t:match("(%d+):(%d+)")
        return tonumber(h) * 60 + tonumber(m)
    end
    
    local sunrise_mins = timeToMinutes(times[1])
    local sunset_mins = timeToMinutes(times[2])
    
    local day_length_mins = (sunset_mins - sunrise_mins + 1440) % 1440
    
    local hours = math.floor(day_length_mins / 60)
    local minutes = day_length_mins % 60
    
    local message = string.format([[
Location: %s, %s
Coordinates: %.4f, %.4f
Date: %s

Sunrise: %s
Sunset: %s

Day Length: %02d:%02d hours
    ]], 
        loc.city, loc.country,
        loc.latitude, loc.longitude,
        os.date("%Y-%m-%d"),
        times[1], times[2],
        hours, minutes
    )
    
    gg.alert(message)
end

local function showCustomLocation()
    local inputs = gg.prompt({
        "Latitude (e.g., -23.5505):",
        "Longitude (e.g., -46.6333):"
    }, {nil, nil}, {"number", "number"})
    
    if not inputs then return end
    
    local latitude = tonumber(inputs[1])
    local longitude = tonumber(inputs[2])
    
    if not latitude or not longitude then
        gg.alert("Invalid coordinates!")
        return
    end
    
    if latitude < -90 or latitude > 90 or longitude < -180 or longitude > 180 then
        gg.alert("Coordinates out of range!")
        return
    end
    
    local times = SunDateSimple.getSunriseSunset(latitude, longitude)
    
    local message = string.format([[
Coordinates: %.4f, %.4f
Date: %s

Sunrise: %s
Sunset: %s
    ]], 
        latitude, longitude,
        os.date("%Y-%m-%d"),
        times[1], times[2]
    )
    
    gg.alert(message)
end

function main()
    while true do
        local options = {
            "Current Location (Auto-detect)",
            "Specific Date",
            "Day Length",
            "Custom Coordinates",
            "Exit"
        }
        
        local choice = gg.choice(options, nil, "Sun Calculator")
        if not choice then break end
        
        if choice == 1 then
            showSunTimes()
        elseif choice == 2 then
            showSunTimesForDate()
        elseif choice == 3 then
            showDayLength()
        elseif choice == 4 then
            showCustomLocation()
        elseif choice == 5 then
            break
        end
    end
end

if gg.isVisible(true) then
    gg.setVisible(false)
end

main()