
if luajava == nil then gg.alert(' unavaliable please use gameguardian mod (suport luajava)') else end

if not activity then
    gg.alert("No activity available")
    return
end

import "android.ext.*"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "java.io.*"
import "java.security.*"
import "java.util.zip.CRC32"
import "java.math.BigInteger"

local Class = luajava.bindClass
local new = luajava.new
local astable = luajava.astable
local methods = luajava.methods

local Vector = Class("java.util.Vector")
local Math = Class("java.lang.Math")
local Double = Class("java.lang.Double")

gg.setVisible(false)

if not activity then
    gg.alert("No activity")
    return
end

local function bind(c)
    local ok, r = pcall(luajava.bindClass, c)
    if ok then return r end
    return nil
end

local TextView = bind("android.widget.TextView")
local WindowManager = bind("android.view.WindowManager")
local PixelFormat = bind("android.graphics.PixelFormat")
local Gravity = bind("android.view.Gravity")
local Color = bind("android.graphics.Color")
local Build = bind("android.os.Build")

local function getType()
    if Build.VERSION.SDK_INT >= 26 then
        return 2038
    elseif Build.VERSION.SDK_INT >= 23 then
        return 2002
    else
        return 2003
    end
end

local function createVector2(x, y)
    return {X = x or 0, Y = y or 0}
end

local function toVector2(v)
    return {X = v.X or 0, Y = v.Y or 0}
end

local function multiply(v, s)
    return {
        X = (v.X or 0) * s,
        Y = (v.Y or 0) * s
    }
end

local function divide(v, s)
    if s == 0 then return v end
    return multiply(v, 1 / s)
end

local function add(v1, v2)
    return {
        X = (v1.X or 0) + (v2.X or 0),
        Y = (v1.Y or 0) + (v2.Y or 0)
    }
end

local function subtract(v1, v2)
    return {
        X = (v1.X or 0) - (v2.X or 0),
        Y = (v1.Y or 0) - (v2.Y or 0)
    }
end

local function magnitude(v)
    return math.sqrt(v.X * v.X + v.Y * v.Y)
end
local function normalize(v)
    local mag = magnitude(v)
    if mag == 0 then
        return {X = 0, Y = 0}
    end
    return {
        X = v.X / mag,
        Y = v.Y / mag
    }
end

local function dot(v1, v2)
    return (v1.X or 0) * (v2.X or 0) +
           (v1.Y or 0) * (v2.Y or 0)
end

local function distance(v1, v2)
    local diff = subtract(v1, v2)
    return magnitude(diff)
end

local function lerp(v1, v2, t)
    return {
        X = v1.X + (v2.X - v1.X) * t,
        Y = v1.Y + (v2.Y - v1.Y) * t
    }
end

local function angle(v1, v2)
    local dotProduct = dot(v1, v2)
    local mag1 = magnitude(v1)
    local mag2 = magnitude(v2)
    
    if mag1 == 0 or mag2 == 0 then
        return 0
    end
    
    local cosAngle = dotProduct / (mag1 * mag2)
    if cosAngle > 1 then cosAngle = 1 end
    if cosAngle < -1 then cosAngle = -1 end
    
    local acos = 0
    local x = cosAngle
    local term = x
    for i = 1, 10 do
        acos = acos + term
        term = term * (x * x) * (2 * i - 1) / (2 * i + 1)
    end
    return 3.14159 / 2 - acos
end

local function clampMagnitude(vector, maxLength)
    local mag = magnitude(vector)
    if mag > maxLength then
        return multiply(vector, maxLength / mag)
    end
    return vector
end

local view = TextView(activity)
view.setText("O")
view.setTextColor(Color.WHITE)
view.setBackgroundColor(Color.RED)
view.setPadding(30, 30, 30, 30)
view.setTextSize(24)

local params = luajava.newInstance(
    "android.view.WindowManager$LayoutParams",
    -2,
    -2,
    getType(),
    0x00000008,
    PixelFormat.TRANSLUCENT
)

params.gravity = Gravity.TOP + Gravity.LEFT
params.x = 100
params.y = 200

local wm = nil

activity.runOnUiThread(luajava.createProxy("java.lang.Runnable", {
    run = function()
        wm = activity.getWindowManager()
        wm.addView(view, params)
        gg.toast("View created")
    end
}))

local function updateViewPosition(x, y)
    params.x = x
    params.y = y
    activity.runOnUiThread(luajava.createProxy("java.lang.Runnable", {
        run = function()
            wm.updateViewLayout(view, params)
        end
    }))
end

local function closeView()
    activity.runOnUiThread(luajava.createProxy("java.lang.Runnable", {
        run = function()
            if wm ~= nil and view:getParent() ~= nil then
                wm.removeView(view)
                gg.toast("View closed")
            end
        end
    }))
end

local function moveTo(targetX, targetY, duration)
    local startX = params.x
    local startY = params.y
    local steps = duration / 50
    local startPos = createVector2(startX, startY)
    local targetPos = createVector2(targetX, targetY)
    
    for i = 1, steps do
        local t = i / steps
        local currentPos = lerp(startPos, targetPos, t)
        local coord = toVector2(currentPos)
        updateViewPosition(coord.X, coord.Y)
        gg.sleep(50)
    end
    
    updateViewPosition(targetX, targetY)
    gg.toast("Arrived at destination")
end

local function circularMovement(centerX, centerY, radius, rotations, duration)
    local steps = duration / 50
    local center = createVector2(centerX, centerY)
    
    for i = 1, steps do
        local progress = i / steps
        local ang = progress * 2 * 3.14159 * rotations
        
        local sinVal = ang
        local sinTerm = ang
        for n = 1, 5 do
            sinTerm = sinTerm * (-ang * ang) / ((2 * n) * (2 * n + 1))
            sinVal = sinVal + sinTerm
        end
        
        local cosVal = 1
        local cosTerm = 1
        for n = 1, 5 do
            cosTerm = cosTerm * (-ang * ang) / ((2 * n - 1) * (2 * n))
            cosVal = cosVal + cosTerm
        end
        
        local offsetX = radius * cosVal
        local offsetY = radius * sinVal
        
        local offset = createVector2(offsetX, offsetY)
        local currentPos = add(center, offset)
        local coord = toVector2(currentPos)
        
        updateViewPosition(coord.X, coord.Y)
        gg.sleep(50)
    end
end

local function spiralMovement(centerX, centerY, maxRadius, rotations, duration)
    local steps = duration / 50
    local center = createVector2(centerX, centerY)
    
    for i = 1, steps do
        local progress = i / steps
        local ang = progress * 2 * 3.14159 * rotations
        local r = progress * maxRadius
        
        local sinVal = ang
        local sinTerm = ang
        for n = 1, 5 do
            sinTerm = sinTerm * (-ang * ang) / ((2 * n) * (2 * n + 1))
            sinVal = sinVal + sinTerm
        end
        
        local cosVal = 1
        local cosTerm = 1
        for n = 1, 5 do
            cosTerm = cosTerm * (-ang * ang) / ((2 * n - 1) * (2 * n))
            cosVal = cosVal + cosTerm
        end
        
        local offsetX = r * cosVal
        local offsetY = r * sinVal
        
        local offset = createVector2(offsetX, offsetY)
        local currentPos = add(center, offset)
        local coord = toVector2(currentPos)
        
        updateViewPosition(coord.X, coord.Y)
        gg.sleep(50)
    end
end

local function zigzagMovement(startX, startY, endX, endY, amplitude, frequency, duration)
    local steps = duration / 50
    local startPos = createVector2(startX, startY)
    local endPos = createVector2(endX, endY)
    local direction = subtract(endPos, startPos)
    local dirNorm = normalize(direction)
    local dirCoord = toVector2(dirNorm)
    local perpendicular = createVector2(-dirCoord.Y, dirCoord.X)
    
    for i = 1, steps do
        local t = i / steps
        local basePos = lerp(startPos, endPos, t)
        
        local ang = t * 3.14159 * 2 * frequency
        local sinVal = ang
        local sinTerm = ang
        for n = 1, 5 do
            sinTerm = sinTerm * (-ang * ang) / ((2 * n) * (2 * n + 1))
            sinVal = sinVal + sinTerm
        end
        
        local offsetVal = amplitude * sinVal
        local offset = multiply(perpendicular, offsetVal)
        local finalPos = add(basePos, offset)
        local coord = toVector2(finalPos)
        
        updateViewPosition(coord.X, coord.Y)
        gg.sleep(50)
    end
end

local function vectorOperations()
    local opVec = {
        "Add vectors",
        "Subtract vectors",
        "Multiply by scalar",
        "Divide by scalar",
        "Magnitude",
        "Normalize",
        "Dot product",
        "Distance",
        "Angle",
        "Lerp",
        "Clamp magnitude",
        "Back"
    }
    
    local escVec = gg.choice(opVec)
    
    if escVec == 1 then
        local v1 = gg.prompt({"V1 X:", "V1 Y:"}, {0, 0}, {"number", "number"})
        local v2 = gg.prompt({"V2 X:", "V2 Y:"}, {0, 0}, {"number", "number"})
        if v1 and v2 then
            local vec1 = createVector2(tonumber(v1[1]), tonumber(v1[2]))
            local vec2 = createVector2(tonumber(v2[1]), tonumber(v2[2]))
            local result = add(vec1, vec2)
            local pos = toVector2(result)
            gg.alert("Result: (" .. pos.X .. ", " .. pos.Y .. ")")
        end
        
    elseif escVec == 2 then
        local v1 = gg.prompt({"V1 X:", "V1 Y:"}, {0, 0}, {"number", "number"})
        local v2 = gg.prompt({"V2 X:", "V2 Y:"}, {0, 0}, {"number", "number"})
        if v1 and v2 then
            local vec1 = createVector2(tonumber(v1[1]), tonumber(v1[2]))
            local vec2 = createVector2(tonumber(v2[1]), tonumber(v2[2]))
            local result = subtract(vec1, vec2)
            local pos = toVector2(result)
            gg.alert("Result: (" .. pos.X .. ", " .. pos.Y .. ")")
        end
        
    elseif escVec == 3 then
        local v = gg.prompt({"X:", "Y:"}, {0, 0}, {"number", "number"})
        local s = gg.prompt({"Scalar:"}, {1}, {"number"})
        if v and s then
            local vec = createVector2(tonumber(v[1]), tonumber(v[2]))
            local result = multiply(vec, tonumber(s[1]))
            local pos = toVector2(result)
            gg.alert("Result: (" .. pos.X .. ", " .. pos.Y .. ")")
        end
        
    elseif escVec == 4 then
        local v = gg.prompt({"X:", "Y:"}, {0, 0}, {"number", "number"})
        local s = gg.prompt({"Scalar:"}, {1}, {"number"})
        if v and s then
            local vec = createVector2(tonumber(v[1]), tonumber(v[2]))
            local result = divide(vec, tonumber(s[1]))
            local pos = toVector2(result)
            gg.alert("Result: (" .. pos.X .. ", " .. pos.Y .. ")")
        end
        
    elseif escVec == 5 then
        local v = gg.prompt({"X:", "Y:"}, {0, 0}, {"number", "number"})
        if v then
            local vec = createVector2(tonumber(v[1]), tonumber(v[2]))
            local mag = magnitude(vec)
            gg.alert("Magnitude: " .. mag)
        end
        
    elseif escVec == 6 then
        local v = gg.prompt({"X:", "Y:"}, {0, 0}, {"number", "number"})
        if v then
            local vec = createVector2(tonumber(v[1]), tonumber(v[2]))
            local norm = normalize(vec)
            local pos = toVector2(norm)
            gg.alert("Normalized: (" .. pos.X .. ", " .. pos.Y .. ")")
        end
        
    elseif escVec == 7 then
        local v1 = gg.prompt({"V1 X:", "V1 Y:"}, {0, 0}, {"number", "number"})
        local v2 = gg.prompt({"V2 X:", "V2 Y:"}, {0, 0}, {"number", "number"})
        if v1 and v2 then
            local vec1 = createVector2(tonumber(v1[1]), tonumber(v1[2]))
            local vec2 = createVector2(tonumber(v2[1]), tonumber(v2[2]))
            local d = dot(vec1, vec2)
            gg.alert("Dot product: " .. d)
        end
        
    elseif escVec == 8 then
        local v1 = gg.prompt({"V1 X:", "V1 Y:"}, {0, 0}, {"number", "number"})
        local v2 = gg.prompt({"V2 X:", "V2 Y:"}, {0, 0}, {"number", "number"})
        if v1 and v2 then
            local vec1 = createVector2(tonumber(v1[1]), tonumber(v1[2]))
            local vec2 = createVector2(tonumber(v2[1]), tonumber(v2[2]))
            local dist = distance(vec1, vec2)
            gg.alert("Distance: " .. dist)
        end
        
    elseif escVec == 9 then
        local v1 = gg.prompt({"V1 X:", "V1 Y:"}, {0, 0}, {"number", "number"})
        local v2 = gg.prompt({"V2 X:", "V2 Y:"}, {0, 0}, {"number", "number"})
        if v1 and v2 then
            local vec1 = createVector2(tonumber(v1[1]), tonumber(v1[2]))
            local vec2 = createVector2(tonumber(v2[1]), tonumber(v2[2]))
            local ang = angle(vec1, vec2)
            gg.alert("Angle (radians): " .. ang)
        end
        
    elseif escVec == 10 then
        local v1 = gg.prompt({"V1 X:", "V1 Y:"}, {0, 0}, {"number", "number"})
        local v2 = gg.prompt({"V2 X:", "V2 Y:"}, {100, 100}, {"number", "number"})
        local t = gg.prompt({"t (0-1):"}, {0.5}, {"number"})
        if v1 and v2 and t then
            local vec1 = createVector2(tonumber(v1[1]), tonumber(v1[2]))
            local vec2 = createVector2(tonumber(v2[1]), tonumber(v2[2]))
            local l = lerp(vec1, vec2, tonumber(t[1]))
            local pos = toVector2(l)
            gg.alert("Lerp: (" .. pos.X .. ", " .. pos.Y .. ")")
        end
        
    elseif escVec == 11 then
        local v = gg.prompt({"X:", "Y:"}, {0, 0}, {"number", "number"})
        local maxLen = gg.prompt({"Max length:"}, {1}, {"number"})
        if v and maxLen then
            local vec = createVector2(tonumber(v[1]), tonumber(v[2]))
            local clamped = clampMagnitude(vec, tonumber(maxLen[1]))
            local pos = toVector2(clamped)
            gg.alert("Clamped: (" .. pos.X .. ", " .. pos.Y .. ")")
        end
    end
end

local function showMenu()
    local options = {
       "[ANIMATION] Linear move",
        "[ANIMATION] Circular movement",
       "[ANIMATION] Spiral movement",
       "[ANIMATION] Zigzag movement",
       "[VECTOR] Vector operations",
        "[VIEW] Move manually",
        "[VIEW] Current position",
        "[VIEW] Close"
    }
    
    local choice = gg.choice(options)
    
    if not choice then
        closeView()
        return
    end
    
   if choice == 1 then
        local target = gg.prompt({"Target X:", "Target Y:", "Duration (ms):"}, {300, 500, 2000}, {"number", "number", "number"})
        if target then
            moveTo(tonumber(target[1]), tonumber(target[2]), tonumber(target[3]))
        end
        showMenu()
        
    elseif choice == 2 then
        local config = gg.prompt({
            "Center X:", 
            "Center Y:", 
            "Radius:", 
            "Rotations:", 
            "Duration (ms):"
        }, {300, 500, 150, 3, 3000}, {"number", "number", "number", "number", "number"})
        if config then
            circularMovement(
                tonumber(config[1]), 
                tonumber(config[2]), 
                tonumber(config[3]), 
                tonumber(config[4]), 
                tonumber(config[5])
            )
        end
        showMenu()
        
    elseif choice == 3 then
        local config = gg.prompt({
            "Center X:", 
            "Center Y:", 
            "Max radius:", 
            "Rotations:", 
            "Duration (ms):"
        }, {300, 500, 200, 3, 3000}, {"number", "number", "number", "number", "number"})
        if config then
            spiralMovement(
                tonumber(config[1]), 
                tonumber(config[2]), 
                tonumber(config[3]), 
                tonumber(config[4]), 
                tonumber(config[5])
            )
        end
        showMenu()
        
    elseif choice == 4 then
        local config = gg.prompt({
            "Start X:", 
            "Start Y:", 
            "End X:", 
            "End Y:",
            "Amplitude:",
            "Frequency:",
            "Duration (ms):"
        }, {100, 200, 500, 200, 50, 3, 2000}, {"number", "number", "number", "number", "number", "number", "number"})
        if config then
            zigzagMovement(
                tonumber(config[1]), 
                tonumber(config[2]), 
                tonumber(config[3]), 
                tonumber(config[4]),
                tonumber(config[5]),
                tonumber(config[6]),
                tonumber(config[7])
            )
        end
        showMenu()
        
    elseif choice == 5 then
        vectorOperations()
        showMenu()
        
    elseif choice == 6 then
        local pos = gg.prompt({"New X:", "New Y:"}, {params.x, params.y}, {"number", "number"})
        if pos then
            updateViewPosition(tonumber(pos[1]), tonumber(pos[2]))
            gg.toast("View moved")
        end
        showMenu()
        
    elseif choice == 7 then
        gg.alert("Current position:\nX = " .. params.x .. "\nY = " .. params.y)
        showMenu()
        
    elseif choice == 8 then
        closeView()
    end
end

showMenu()