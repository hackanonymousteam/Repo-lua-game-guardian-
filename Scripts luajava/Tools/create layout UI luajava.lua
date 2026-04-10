gg.setVisible(false)

import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "android.graphics.*"
import "android.graphics.drawable.*"
import "android.util.TypedValue"
import "android.content.Context"
import "android.view.WindowManager"
import "android.view.Gravity"

wm = activity.getSystemService(Context.WINDOW_SERVICE)
screenWidth = activity.getResources().getDisplayMetrics().widthPixels
screenHeight = activity.getResources().getDisplayMetrics().heightPixels

mFloatingView = nil
currentLayout = nil
elements = {}
selectedElement = nil
elementCounter = 1
isUIVisible = true
lastYPosition = 10

UI_WIDTH = 300
UI_HEIGHT = 400

function dp(value)
    return TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, value, activity.getResources().getDisplayMetrics())
end

function colorToHex(color)
    return string.format("#%06X", 0xFFFFFF & color)
end

local json = {}

function json.encode(data)
    local result = {}
    
    local function serialize(val)
        local t = type(val)
        if t == "table" then
            local items = {}
            for k, v in pairs(val) do
                table.insert(items, string.format('"%s":%s', k, serialize(v)))
            end
            return "{"..table.concat(items, ",").."}"
        elseif t == "string" then
            return '"'..val:gsub('"', '\\"')..'"'
        elseif t == "boolean" then
            return val and "true" or "false"
        else
            return tostring(val)
        end
    end
    
    return serialize(data)
end

function json.decode(str)
    local pos = 1
    
    local function skipWhitespace()
        while pos <= #str and str:sub(pos, pos):match("%s") do
            pos = pos + 1
        end
    end
    
    local function parseValue()
        skipWhitespace()
        local char = str:sub(pos, pos)
        
        if char == "{" then
            return parseObject()
        elseif char == '"' then
            return parseString()
        elseif char:match("%d") then
            return parseNumber()
        elseif str:sub(pos, pos+3) == "true" then
            pos = pos + 4
            return true
        elseif str:sub(pos, pos+4) == "false" then
            pos = pos + 5
            return false
        end
        return nil
    end
    
    local function parseObject()
        pos = pos + 1
        local obj = {}
        
        while true do
            skipWhitespace()
            if str:sub(pos, pos) == "}" then
                pos = pos + 1
                break
            end
            
            local key = parseString()
            skipWhitespace()
            if str:sub(pos, pos) ~= ":" then break end
            pos = pos + 1
            local value = parseValue()
            
            obj[key] = value
            
            skipWhitespace()
            if str:sub(pos, pos) == "," then
                pos = pos + 1
            elseif str:sub(pos, pos) == "}" then
                pos = pos + 1
                break
            end
        end
        
        return obj
    end
    
    local function parseString()
        pos = pos + 1
        local result = ""
        
        while pos <= #str do
            local char = str:sub(pos, pos)
            
            if char == '"' then
                pos = pos + 1
                break
            elseif char == "\\" then
                pos = pos + 1
                char = str:sub(pos, pos)
            end
            
            result = result .. char
            pos = pos + 1
        end
        
        return result
    end
    
    local function parseNumber()
        local start = pos
        while pos <= #str and str:sub(pos, pos):match("[%d%.]") do
            pos = pos + 1
        end
        return tonumber(str:sub(start, pos-1))
    end
    
    return parseValue()
end

function createElement(elementType, properties)
    activity.runOnUiThread(function()
        local element = nil
        local params = RelativeLayout.LayoutParams(
            properties.width and dp(properties.width) or RelativeLayout.LayoutParams.WRAP_CONTENT,
            properties.height and dp(properties.height) or RelativeLayout.LayoutParams.WRAP_CONTENT
        )
        
          local marginLeft = properties.x or 20
        local marginTop = lastYPosition
        
        if elementType == "Button" then
            element = Button(activity)
            element.setText(properties.text or "Button")
            element.setTextColor(properties.textColor or Color.WHITE)
            element.setBackgroundColor(properties.bgColor or Color.parseColor("#FF5722"))
            element.setTypeface(Typeface.DEFAULT_BOLD)
            params.height = dp(50)
        elseif elementType == "TextView" then
            element = TextView(activity)
            element.setText(properties.text or "Text")
            element.setTextColor(properties.textColor or Color.WHITE)
            element.setTextSize(properties.textSize or 14)
            element.setGravity(Gravity.CENTER)
        elseif elementType == "EditText" then
            element = EditText(activity)
            element.setHint(properties.hint or "Input text...")
            element.setTextColor(properties.textColor or Color.WHITE)
            element.setHintTextColor(Color.parseColor("#80FFFFFF"))
            element.--
            params.height = dp(50)
        elseif elementType == "ImageView" then
            element = ImageView(activity)
            element.setImageResource(android.R.drawable.ic_menu_gallery)
            element.setScaleType(ImageView.ScaleType.FIT_CENTER)
            element.--setBackgroundColor(properties.bgColor or Color.parseColor("#40000000"))
            params.height = dp(100)
        elseif elementType == "Switch" then
            element = Switch(activity)
            element.setText(properties.text or "Switch")
            element.setTextColor(properties.textColor or Color.WHITE)
            params.height = dp(50)
        elseif elementType == "CheckBox" then
            element = CheckBox(activity)
            element.setText(properties.text or "Checkbox")
            element.setTextColor(properties.textColor or Color.WHITE)
            params.height = dp(50)
        end
        
        if element then

            params.leftMargin = dp(marginLeft)
            params.topMargin = dp(marginTop)
            
            lastYPosition = marginTop + (properties.height or (elementType == "ImageView" and 100 or 50)) + 10
                    
            local elementId = "element_"..elementCounter
            element.setId(View.generateViewId())
            elementCounter = elementCounter + 1
            
            
            currentLayout.addView(element, params)
                     
            local elementInfo = {
                view = element,
                type = elementType,
                id = elementId,
                properties = {
                    x = marginLeft,
                    y = marginTop,
                    width = properties.width,
                    height = properties.height or (elementType == "ImageView" and 100 or 50),
                    text = properties.text,
                    textColor = properties.textColor,
                    bgColor = properties.bgColor,
                    textSize = properties.textSize,
                    hint = properties.hint
                }
            }
            
            table.insert(elements, elementInfo)
            
            element.setOnClickListener(function(v)
                selectElement(elementInfo)
            end)
            
            adjustLayoutHeight()
        end
    end)
end

function adjustLayoutHeight()
    local neededHeight = lastYPosition + 20
    
    local maxHeight = screenHeight - 100
    if neededHeight > maxHeight then
        neededHeight = maxHeight
    end
    
    if currentLayout and mFloatingView then
        local params = currentLayout.getLayoutParams()
        params.height = dp(neededHeight)
        currentLayout.setLayoutParams(params)
        
        local windowParams = mFloatingView.getLayoutParams()
        windowParams.height = dp(neededHeight)
        wm.updateViewLayout(mFloatingView, windowParams)
    end
end

function updateElementView(elementInfo)
    activity.runOnUiThread(function()
        local view = elementInfo.view
        local props = elementInfo.properties
        
        local params = view.getLayoutParams()
        if params and params.getClass().getName():find("RelativeLayout") then
            params.leftMargin = dp(props.x or 0)
            params.topMargin = dp(props.y or 0)
            
            if props.width then
                params.width = dp(props.width)
            else
                params.width = RelativeLayout.LayoutParams.WRAP_CONTENT
            end
            
            if props.height then
                params.height = dp(props.height)
            else
                params.height = RelativeLayout.LayoutParams.WRAP_CONTENT
            end
            
            view.setLayoutParams(params)
        end
        
        if elementInfo.type == "Button" or elementInfo.type == "TextView" or elementInfo.type == "EditText" then
            if props.text then
                view.setText(props.text)
            end
            if props.textColor then
                view.setTextColor(props.textColor)
            end
        end
        
        if props.bgColor then
            if elementInfo.type == "EditText" then
                local bg = GradientDrawable()
                bg.setColor(props.bgColor)
                bg.setCornerRadius(dp(4))
                view.setBackgroundDrawable(bg)
            else
                view.setBackgroundColor(props.bgColor)
            end
        end
        
        rearrangeElements()
    end)
end

function rearrangeElements()

    local currentY = 10
    
    for i, element in ipairs(elements) do
        local params = element.view.getLayoutParams()
        params.topMargin = dp(currentY)
        element.view.setLayoutParams(params)
        
        element.properties.y = currentY
        currentY = currentY + (element.properties.height or 50) + 10
    end
    
    lastYPosition = currentY
    adjustLayoutHeight()
end

function toggleUIVisibility()
    activity.runOnUiThread(function()
        if mFloatingView then
            isUIVisible = not isUIVisible
            mFloatingView.setVisibility(isUIVisible and View.VISIBLE or View.GONE)
        end
    end)
end

function generateLuaCode()
    local code = "-- UI Layout generated with GG UI Designer\n\n"
    code = code .. "gg.setVisible(false)\n\n"
    code = code .. "import  \"android.widget.*\"\n"
    code = code .. "import   \"android.view.*\"\n"
    code = code .. "import  \"android.graphics.*\"\n"
    code = code .. "import  \"android.graphics.drawable.*\"\n"
    code = code .. "import  \"android.util.TypedValue\"\n"
    code = code .. "import  \"android.content.Context\"\n"
    code = code .. "import  \"android.view.WindowManager\"\n\n"
    
    code = code .. "-- Screen dimensions\n"
    code = code .. "screenWidth = activity.getResources().getDisplayMetrics().widthPixels\n"
    code = code .. "screenHeight = activity.getResources().getDisplayMetrics().heightPixels\n\n"
    
    code = code .. "-- Window manager setup\n"
    code = code .. "wm = activity.getSystemService(Context.WINDOW_SERVICE)\n\n"
    
    code = code .. "function initFloatingWindow()\n"
       code = code .. " activity.runOnUiThread(function()\n"  
    code = code .. "-- Main layout\n"
    code = code .. "local layout = RelativeLayout(activity)\n"
    code = code .. "local layoutParams = RelativeLayout.LayoutParams("..UI_WIDTH.." , "..lastYPosition..")\n"
    code = code .. "layout.setLayoutParams(layoutParams)\n\n"
    
    code = code .. "-- Background\n"
    code = code .. "local bg = GradientDrawable()\n"
    code = code .. "bg.setColor(Color.parseColor(\"#80000000\"))\n"   
    code = code .. "bg.setStroke(2, Color.WHITE)\n"
    code = code .. "layout.setBackgroundDrawable(bg)\n\n"
    code = code .. "function dp(value)\n"
    code = code .. "    return TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, value, activity.getResources().getDisplayMetrics())\n"
    code = code .. "end\n\n"
    
    for _, element in ipairs(elements) do
        local props = element.properties
        code = code .. "-- " .. element.type .. ": " .. (props.text or element.id) .. "\n"
        code = code .. "local " .. element.id .. " = " .. element.type .. "(activity)\n"
        
        local width = props.width and "dp("..props.width..")" or "RelativeLayout.LayoutParams.WRAP_CONTENT"
        local height = "dp("..props.height..")"
        
        code = code .. "local "..element.id.."_params = RelativeLayout.LayoutParams("..width..", "..height..")\n"
        code = code .. element.id.."_params.leftMargin = dp("..(props.x or 20)..")\n"
        code = code .. element.id.."_params.topMargin = dp("..(props.y or 0)..")\n"
        
        if props.text then
            code = code .. element.id..".setText(\""..props.text:gsub("\"", "\\\"").."\")\n"
        end
        
        if props.textColor then
            code = code .. element.id..".setTextColor(Color.parseColor(\""..colorToHex(props.textColor).."\"))\n"
        end
        
        if props.bgColor then
            if element.type == "EditText" then
                code = code .. "local "..element.id.."_bg = GradientDrawable()\n"
                code = code .. element.id.."_bg.setColor(Color.parseColor(\""..colorToHex(props.bgColor).."\"))\n"
                code = code .. element.id.."_bg.setCornerRadius(dp(4))\n"
                code = code .. element.id..".setBackgroundDrawable("..element.id.."_bg)\n"
            else
                code = code .. element.id..".setBackgroundColor(Color.parseColor(\""..colorToHex(props.bgColor).."\"))\n"
            end
        end
        
        if element.type == "TextView" or element.type == "Button" then
            code = code .. element.id..".setTextSize("..(props.textSize or 14)..")\n"
        end
        
        if element.type == "EditText" and props.hint then
            code = code .. element.id..".setHint(\""..props.hint:gsub("\"", "\\\"").."\")\n"
        end
        code = code .. "layout.addView("..element.id..", "..element.id.."_params)\n\n"
    end    
    code = code .. "-- Window parameters\n"
    code = code .. "local params = WindowManager.LayoutParams()\n"
    code = code .. "params.width = WindowManager.LayoutParams.WRAP_CONTENT\n"
    code = code .. "params.height = WindowManager.LayoutParams.WRAP_CONTENT\n"
    code = code .. "params.type = WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY\n"
    code = code .. "params.flags = bit32.bor(WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE, WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN)\n"
    code = code .. "params.format = PixelFormat.TRANSLUCENT\n"
    code = code .. "params.gravity = Gravity.CENTER | Gravity.CENTER\n"
    
    code = code .. "wm.addView(layout, params)\n\n"
    
    code = code .. "-- Touch listener for moving the window\n"
    code = code .. "local initialX, initialY = 0, 0\n"
    code = code .. "local initialTouchX, initialTouchY = 0, 0\n\n"
    
    code = code .. "layout.setOnTouchListener{\n"
    code = code .. "    onTouch = function(view, motionEvent)\n"
    code = code .. "        local action = motionEvent.getAction()\n\n"
    code = code .. "        if action == MotionEvent.ACTION_DOWN then\n"
    code = code .. "            initialX = params.x\n"
    code = code .. "            initialY = params.y\n"
    code = code .. "            initialTouchX = motionEvent.getRawX()\n"
    code = code .. "            initialTouchY = motionEvent.getRawY()\n"
    code = code .. "            return true\n"
    code = code .. "        elseif action == MotionEvent.ACTION_MOVE then\n"
    code = code .. "            params.x = initialX + (motionEvent.getRawX() - initialTouchX)\n"
    code = code .. "            params.y = initialY + (motionEvent.getRawY() - initialTouchY)\n"
    code = code .. "            wm.updateViewLayout(layout, params)\n"
    code = code .. "            return true\n"
    code = code .. "        end\n"
    code = code .. "        return false\n"
    code = code .. "    end\n"
    code = code .. "}\n"
    
code = code .. "end)\n"
code = code .. "end\n"

code = code .. "initFloatingWindow()\n"
   
    return code
end

function saveLayoutToFile(fileName)
    local layoutData = {
        elements = {},
        screenWidth = screenWidth,
        screenHeight = screenHeight,
        uiWidth = UI_WIDTH,
        lastYPosition = lastYPosition
    }
    
    for _, element in ipairs(elements) do
        table.insert(layoutData.elements, {
            type = element.type,
            properties = element.properties
        })
    end
    
    local file = io.open(fileName, "w")
    if file then
        file:write(json.encode(layoutData))
        file:close()
        return true
    end
    return false
end

function showAddElementMenu()
    local elementTypes = {"Button", "TextView", "EditText",  "Switch", "CheckBox"}
    local typeChoice = gg.choice(elementTypes, nil, "Add New Element")
    
    if typeChoice then
        local defaultProps = {
            x = 20,
            width = UI_WIDTH - 40,
            text = elementTypes[typeChoice],
            textColor = Color.WHITE,
            bgColor = Color.parseColor("#FF5722"),
            textSize = 14
        }
        
        if elementTypes[typeChoice] == "EditText" then
            defaultProps.text = nil
            defaultProps.hint = "Input text..."
        elseif elementTypes[typeChoice] == "ImageView" then
            defaultProps.text = nil
            defaultProps.height = 100
        elseif elementTypes[typeChoice] == "Switch" or elementTypes[typeChoice] == "CheckBox" then
            defaultProps.width = nil -- WRAP_CONTENT
        end
        
        createElement(elementTypes[typeChoice], defaultProps)
        gg.toast(elementTypes[typeChoice].." added!")
    end
end

function showEditElementMenu()
    if #elements == 0 then
        gg.alert("No elements to edit!")
        return
    end
    
    local elementList = {}
    for i, elem in ipairs(elements) do
        table.insert(elementList, elem.type..": "..(elem.properties.text or elem.id))
    end
    
    local elemChoice = gg.choice(elementList, nil, "Select Element to Edit")
    if elemChoice then
        local element = elements[elemChoice]
        
        local propMenu = {
            {"Text", element.properties.text or ""},
            {"X Position", element.properties.x or 20},
            {"Width", element.properties.width or "WRAP_CONTENT"},
            {"Height", element.properties.height or (element.type == "ImageView" and 100 or 50)},

            {"Delete Element", "DELETE"}
        }
        
        if element.type == "EditText" then
            table.insert(propMenu, 2, {"Hint", element.properties.hint or ""})
        end
        
        local options = {}
        for i, v in ipairs(propMenu) do
            table.insert(options, v[1]..": "..v[2])
        end
        
        local choice = gg.choice(options, nil, "Edit "..element.type)
        if choice then
            if propMenu[choice][1] == "Delete Element" then
                activity.runOnUiThread(function()
                    currentLayout.removeView(element.view)
                    table.remove(elements, elemChoice)
                    rearrangeElements()
                end)
                gg.toast("Element deleted!")
            else
                local newValue = gg.prompt({"Enter new "..propMenu[choice][1]}, {propMenu[choice][2]})
                if newValue and newValue[1] ~= propMenu[choice][2] then
                    local propName = propMenu[choice][1]:lower():gsub(" ", "_")
                    
                    if propName == "x_position" or propName == "width" or propName == "height" or propName == "text_size" then
                        element.properties[propName] = tonumber(newValue[1])
                    elseif propName == "text_color" or propName == "background_color" then
                        element.properties[propName] = Color.parseColor(newValue[1])
                    else
                        element.properties[propName] = newValue[1]
                    end
                    
                    updateElementView(element)
                    gg.toast(propMenu[choice][1].." updated!")
                end
            end
        end
    end
end

function initFloatingWindow()
    activity.runOnUiThread(function()
        currentLayout = RelativeLayout(activity)
        currentLayout.setLayoutParams(RelativeLayout.LayoutParams(dp(UI_WIDTH), dp(UI_HEIGHT)))
        
        local background = GradientDrawable()
        background.setColor(Color.parseColor("#80000000"))
        background.setCornerRadius(dp(10))
        background.setStroke(2, Color.WHITE)
        currentLayout.setBackgroundDrawable(background)
        
        local welcomeText = TextView(activity)
        local welcomeParams = RelativeLayout.LayoutParams(RelativeLayout.LayoutParams.WRAP_CONTENT, RelativeLayout.LayoutParams.WRAP_CONTENT)

        currentLayout.addView(welcomeText)
        
        mFloatingView = currentLayout
        
        local params = WindowManager.LayoutParams()
        params.width = WindowManager.LayoutParams.WRAP_CONTENT
        params.height = WindowManager.LayoutParams.WRAP_CONTENT
        params.type = WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
        params.flags = bit32.bor(WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE, 
                               WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN)
        params.format = PixelFormat.TRANSLUCENT
        params.gravity = Gravity.CENTER | Gravity.CENTER
        
        wm.addView(mFloatingView, params)

        local initialX, initialY = 0, 0
        local initialTouchX, initialTouchY = 0, 0
        
        mFloatingView.setOnTouchListener{
            onTouch = function(view, motionEvent)
                local action = motionEvent.getAction()
                
                if action == MotionEvent.ACTION_DOWN then
                    initialX = params.x
                    initialY = params.y
                    initialTouchX = motionEvent.getRawX()
                    initialTouchY = motionEvent.getRawY()
                    return true
                elseif action == MotionEvent.ACTION_MOVE then
                    params.x = initialX + (motionEvent.getRawX() - initialTouchX)
                    params.y = initialY + (motionEvent.getRawY() - initialTouchY)
                    wm.updateViewLayout(mFloatingView, params)
                    return true
                end
                return false
            end
        }
    end)
end

function showMainMenu()
    while true do
        local mainMenu = {
            "Add Element",
            "Edit Elements",
            "Generate Lua Code",
            "remove UI",
            "Exit Designer"
        }
        
        local choice = gg.choice(mainMenu, nil, "GG UI Designer")
        
        if not choice then gg.sleep(3000)  end
        
        if choice == 1 then
            showAddElementMenu()
        elseif choice == 2 then
            showEditElementMenu()
        elseif choice == 3 then
            if #elements > 0 then
                local code = generateLuaCode()
                local saveChoice = gg.choice({"Copy to Clipboard", "Save to File", "View Code", "Back"}, nil, "Generated Code")
                
                if saveChoice == 1 then
                    gg.copyText(code)
                    gg.toast("Code copied to clipboard!")
                elseif saveChoice == 2 then
                    local fileName = gg.prompt({"Enter file name:"}, {"ui_layout.lua"})[1]
                    if fileName then
                        io.open(fileName, "w"):write(code):close()
                        gg.toast("Code saved to "..fileName)
                    end
                elseif saveChoice == 3 then
                    gg.alert(code:sub(1, 200000)..(code:len() > 10000 and "\n\n... (truncated)" or ""), "Generated UI Code")
                end
            else
                gg.alert("No elements to generate code!")
            end
elseif choice == 4 then
toggleUIVisibility()

        elseif choice == 5 then
            break
        end
    end
    
    activity.runOnUiThread(function()
        if mFloatingView then
            wm.removeView(mFloatingView)
            mFloatingView = nil
        end
    end)
end

initFloatingWindow()
showMainMenu()


