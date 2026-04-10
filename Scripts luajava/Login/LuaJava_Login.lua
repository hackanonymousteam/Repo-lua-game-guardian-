
import "android.app.*"
import "android.ext.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "android.content.*"
import "java.util.*"
import "java.lang.*"
import "android.graphics.drawable.*"
import "android.graphics.PixelFormat"
import "android.animation.ObjectAnimator"
import "android.text.TextUtils"
import "android.text.TextWatcher"

URL = luajava.bindClass("java.net.URL")
BufferedReader = luajava.bindClass("java.io.BufferedReader")
InputStreamReader = luajava.bindClass("java.io.InputStreamReader")

function getCredentials(urlStr)
  local url = URL(urlStr)
  local reader = BufferedReader(InputStreamReader(url:openStream()))
  local line
  local content = ""
  while true do
    line = reader:readLine()
    if line == nil then break end
    content = content .. line .. "\n"
  end
  reader:close()
  return content
end

function isExpired(expireDate)
  local y, m, d = expireDate:match("(%d+)%-(%d+)%-(%d+)")
  local expireTime = os.time{year=tonumber(y), month=tonumber(m), day=tonumber(d)}
  return os.time() > expireTime
end

function login(username, password, raw_url)
  local creds = getCredentials(raw_url)
  for line in creds:gmatch("[^\r\n]+") do
    local user, pass, expire = line:match("([^:]+):([^:]+):([^:]+)")
    if username == user and password == pass then
      if isExpired(expire) then
        print("Account expired")
        return false
      else
        print("Login successful")
        return true
      end
    end
  end
  print("Invalid credentials")
  return false
end

context = activity
window = context.getSystemService('window')
resourceDirectory = gg.EXT_CACHE_DIR 
bcUI = {
   settings = {
    promptWidth = '320dp',
    promptHeight = nil,

    promptHeaderTextColor = '0xFFFFFFFF',
    promptHeaderTextStyle = 'bold',
    promptHeaderTextSize = '18sp',

    promptFooterTextColor = '0xFFBBBBBB',
    promptFooterTextStyle = 'italic',
    promptFooterTextSize = '14sp',

    promptBackgroundColor = '#FF121212', -- fundo geral (quase preto)
    promptCardBackgroundColor = '#FF1E1E1E', -- cards levemente mais claros

    promptSwitchTextColor = '0xFFFFFFFF',
    promptSwitchTextStyle = 'normal',
    promptSwitchTextSize = '16sp',

    promptSeekBarTextColor = '0xFFFFFFFF',
    promptSeekBarTextStyle = 'normal',
    promptSeekBarTextSize = '16sp',

    promptCheckboxTextColor = '0xFFFFFFFF',
    promptCheckboxTextStyle = 'normal',
    promptCheckboxTextSize = '16sp',

    promptButtonTextColor = '0xFFFFFFFF',
    promptButtonTextStyle = 'bold',
    promptButtonTextSize = '16sp',
    promptButtonColor = '#FF03DAC6', -- verde água moderno (Material You)

    promptEditTextTextColor = '0xFFFFFFFF',
    promptEditTextTextStyle = 'normal',
    promptEditTextTextSize = '16sp',
    promptEditTextColor = '#FF2C2C2C', -- campo mais claro que o fundo

    promptEditTextButtonTextColor = '0xFFFFFFFF',
    promptEditTextButtonTextStyle = 'bold',
    promptEditTextButtonTextSize = '16sp',
    promptEditTextButtonColor = '#FFBB86FC', -- roxo Material Design

    promptFont = resourceDirectory .. '/UbuntuAwesome.ttf',
},
    getResources = function() --Resources required by the UI are downloaded in this function
        local fontDestinationPath = resourceDirectory .. "/UbuntuAwesome.ttf" 
        if not file.exists(fontDestinationPath) then
            file.download("http://badcase.org/files/UbuntuAwesome.ttf",fontDestinationPath) --Downloads my UbuntuAwesome font, you can use another but won't be able to use the font awesome icons
        end
    end,

    loadlayout = function(layoutTable, dialogNames, dialogType)
        for layoutIndex,dialogRequest in pairs(bcUI.dialogRequests) do
            local namesMatch = true
            for nameIndex,dialogName in pairs(dialogNames) do
                if dialogRequest.dialogNames[nameIndex] ~= dialogName then
                    namesMatch = false
                end
            end
            if namesMatch and dialogRequest.dialogType == dialogType then
                return bcUI.loadedLayouts[layoutIndex]
            end
        end
        if layoutTable then
            bcUI.dialogRequests[#bcUI.dialogRequests + 1] = {
                dialogNames = dialogNames,
                dialogType = dialogType
            }
            bcUI.loadedLayouts[#bcUI.loadedLayouts + 1] = loadlayout(layoutTable)

            return bcUI.loadedLayouts[#bcUI.loadedLayouts]
        else
            return nil
        end
    end,
    dialogRequests = {},
    loadedLayouts = {},
    listAllElements = function(viewGroup)
        local elements = {}
        local function traverseViewGroup(group)
            for i = 0, group.getChildCount() - 1 do
                local childView = group.getChildAt(i)
                table.insert(elements, childView)
                if childView.getClass().getName() == 'android.widget.LinearLayout' or
                    childView.getClass().getName() == 'android.widget.RelativeLayout' or
                    childView.getClass().getName() == 'android.widget.FrameLayout' or
                    childView.getClass().getName() == 'android.widget.ScrollView' then
                    traverseViewGroup(childView)
                end
            end
        end
        traverseViewGroup(viewGroup)
        return elements
    end,
    toast={
        hint = function(textString)
            toast.cancel()
            runInBackground(toast.diyShow,'hint',textString,false,Gravity.BOTTOM)
        end,
        success = function(textString)
            toast.cancel()
            runInBackground(toast.diyShow,'success',textString,false,Gravity.BOTTOM)
        end,
        error = function(textString)
            toast.cancel()
            runInBackground(toast.diyShow,'error',textString,false,Gravity.BOTTOM)
        end,
    },
	
    prompt = function(menuItems,itemValues,itemTypes,headerText,footerText,dialogWidth,dialogHeight)
		promptTable = nil
		isChoiceMade = false
		bcUI.buildPrompt(
			menuItems,
            itemValues,
            itemTypes,
            headerText,
            footerText,
            dialogWidth,
            dialogHeight,
			function(selectedChoices)
				promptTable = selectedChoices
				isChoiceMade = true
			end
		)
		while not isChoiceMade do
			os.execute("sleep 0.1")
		end
		return promptTable
	end,
    buildPrompt = function(menuItems, itemValues, itemTypes, headerText, footerText, dialogWidth, dialogHeight, callback) -- Adding callback as a parameter
        local promptLayout = bcUI.loadlayout(nil, menuItems, 'prompt')
        local choices = {}
        local editTextElements = {}
        local buttonClick = function(v, buttonIndex, viewType)
            if viewType == 'switch' or viewType == 'checkbox' then
                choices[buttonIndex] = v.isChecked()
                if choices[buttonIndex] then
                    bcUI.toast.success(menuItems[buttonIndex] .. ": Enabled")
                else
                    bcUI.toast.error(menuItems[buttonIndex] .. ": Disabled")
	            end
            elseif viewType == 'seek' then
                local progress = v.getProgress()
                choices[buttonIndex] = progress
                local seekBarLabel = _G['seekbar_' .. buttonIndex .. '_label']
                local tag = seekBarLabel.getTag()
                seekBarLabel.setText(tag .. ' (' .. tostring(progress) .. ')')
                bcUI.toast.success(menuItems[buttonIndex] .. ": " .. progress)
            elseif viewType == 'text' or viewType == 'number' then
                choices[buttonIndex] = v.getText().toString()
                bcUI.toast.success(menuItems[buttonIndex] .. ": " .. choices[buttonIndex])
            end
            if buttonIndex == #menuItems + 1 then
				mainLayoutParams = bcUI.getLayoutParams()

                local lastIndex = 0
                for index, element in pairs(editTextElements) do
                    for i, menuItem in pairs(menuItems) do
                        if i > lastIndex and (itemTypes[i] == 'text' or itemTypes[i] == 'number' or itemTypes[i] == 'file' or itemTypes[i] == 'path') then
                            choices[i] = element.getText().toString()
                            lastIndex = i
                            break
                        end
                    end
                end
                if callback then
                    promptTable = choices
                    isChoiceMade = true
                end
                window.removeView(promptLayout)
                activity.stopFunc()
            end
        end
        if not promptLayout then
            local DialogWidth = dialogWidth or bcUI.settings.promptWidth
	        local DialogHeight = dialogHeight or bcUI.settings.promptHeight or nil

            if type(DialogWidth) == "string" then
                DialogWidth = DialogWidth:gsub("dp","")
            else
                DialogWidth = bcUI.percentageToDp(DialogWidth, true)
            end
            if DialogHeight and  type(DialogHeight) == "string" then
                DialogHeight = DialogHeight:gsub("dp","")
            elseif DialogHeight then
                DialogHeight = bcUI.percentageToDp(DialogHeight)
            end

            promptLayout =
                bcUI.getLayout(
                DialogWidth,
                DialogHeight,
                bcUI.settings.promptBackgroundColor,
                bcUI.settings.promptCardBackgroundColor,
                headerText,
                bcUI.settings.promptHeaderTextColor,
                bcUI.settings.promptHeaderTextSize,
                bcUI.settings.promptHeaderTextStyle,
                footerText,
                bcUI.settings.promptFooterTextColor,
                bcUI.settings.promptFooterTextSize,
                bcUI.settings.promptFooterTextStyle,
				nil,
				nil,
				bcUI.settings.promptFont
            )

            local checkBoxElements = {}
            local seekBarElements = {}
            local switchElements = {}

            for i, v in pairs(menuItems) do
                if itemValues[i] then
                    if itemTypes[i] == 'text' or itemTypes[i] == 'number' or itemTypes[i] == 'file' or
                            itemTypes[i] == 'path'
                     then
                        choices[i] = itemValues[i]
                    end
                    if itemTypes[i] == 'switch' or itemTypes[i] == 'checkbox' then
                        choices[i] = itemValues[i]
                    end
                    if itemTypes[i] == 'seek' then
                        choices[i] = itemValues[i][3]
                    end
                end
            end

            local createButtons = function(namesTable)
                for index, itemText in pairs(namesTable) do
                    local function createEditText(inputType, hintText, buttonTypeface)
                        local linearLayout = {
                            LinearLayout,
                            layout_width = 'match_parent',
                            layout_height = 'wrap_content',
                            orientation = 'vertical',
                            gravity = 'center'
                        }

                        local editText = {
                            EditText,
                            layout_height = 'wrap_content',
                            layout_width = 'match_parent',
                            gravity = 'left',
                            textSize = bcUI.settings.promptEditTextTextSize,
                            textColor = bcUI.settings.promptEditTextTextColor,
                            textStyle = bcUI.settings.promptEditTextTextStyle,
                            inputType = inputType,
                            hint = hintText,
                            background = [[<?xml version="1.0" encoding="utf-8"?>
    <!-- rounded_corners.xml -->
    <shape xmlns:android="http://schemas.android.com/apk/res/android">
    <solid android:color="]] .. bcUI.settings.promptEditTextColor .. [["/>
    <corners android:radius="16dp"/>
    </shape>
    ]],
                            typeface = bcUI.settings.promptFont,
                            id = 'button_' .. index,
                            layout_marginTop = '10dp',
                            padding = '10dp'
                        }
                        linearLayout[2] = editText

                        return linearLayout
                    end

                    local function createFilePicker(inputType, hintText, filePath)
                        local linearLayout = {
                            LinearLayout,
                            layout_width = 'match_parent',
                            layout_height = 'wrap_content',
                            orientation = 'horizontal',
                            gravity = 'center',
                            layout_marginTop = '10dp',
                            {
                                EditText,
                                layout_height = 'wrap_content',
                                layout_width = 'wrap_content',
                                gravity = 'left|center_vertical',
                                textSize = bcUI.settings.promptEditTextTextSize,
                                textColor = bcUI.settings.promptEditTextTextColor,
                                textStyle = bcUI.settings.promptEditTextTextStyle,
                                inputType = inputType,
                                layout_weight = 1,
                                hint = hintText,
                                text = filePath,
                                background = [[<?xml version="1.0" encoding="utf-8"?>
                            <!-- rounded_corners.xml -->
                            <shape xmlns:android="http://schemas.android.com/apk/res/android">
                                <solid android:color="]] .. bcUI.settings.promptEditTextColor .. [["/>
                                <corners android:radius="16dp"/>
                            </shape>
                            ]],
                            	typeface = bcUI.settings.promptFont,
                                id = 'file_picker_' .. index,
                                paddingLeft = '10dp',
                                layout_marginRight = '10dp'
                            },
                            {
                                Button,
                                layout_height = 'wrap_content',
                                layout_width = 'wrap_content',
                                gravity = 'center',
                                id = 'file_picker_' .. index .. '_button',
                                textSize = bcUI.settings.promptEditTextButtonTextSize,
                                textColor = bcUI.settings.promptEditTextButtonTextColor,
                                textStyle = bcUI.settings.promptEditTextButtonTextStyle,
                                background = [[<?xml version="1.0" encoding="utf-8"?>
                            <!-- rounded_corners.xml -->
                            <shape xmlns:android="http://schemas.android.com/apk/res/android">
                                <solid android:color="]] ..
                                    bcUI.settings.promptEditTextButtonColor ..
                                        [["/>
                                <corners android:radius="16dp"/>
                            </shape>
                            ]],
                                text = 'OK',
								typeface = bcUI.settings.promptFont,
                                onClick = function()
                                    local file_picker = _G['file_picker_' .. index]
                                    local filePath = file_picker:getText():toString()

                                    runInBackground(
                                        bcUI.filePicker,
                                        filePath,
                                        headerText,
                                        footerText,
                                        dialogWidth,
                                        dialogHeight,
                                        promptLayout,
                                        index
                                    )
                                end
                            }
                        }

                        return linearLayout
                    end

                    local function createDirectoryPicker(inputType, hintText, filePath)
                        local linearLayout = {
                            LinearLayout,
                            layout_width = 'match_parent',
                            layout_height = 'wrap_content',
                            orientation = 'horizontal',
                            gravity = 'center',
                            layout_marginTop = '10dp',
                            {
                                EditText,
                                layout_height = 'wrap_content',
                                layout_width = 'wrap_content',
                                gravity = 'left|center_vertical',
                                textSize = bcUI.settings.promptEditTextTextSize,
                                textColor = bcUI.settings.promptEditTextTextColor,
                                textStyle = bcUI.settings.promptEditTextTextStyle,
                                inputType = inputType,
                                layout_weight = 1,
                                hint = hintText,
                                text = filePath,
                                background = [[<?xml version="1.0" encoding="utf-8"?>
                        <!-- rounded_corners.xml -->
                        <shape xmlns:android="http://schemas.android.com/apk/res/android">
                            <solid android:color="]] .. bcUI.settings.promptEditTextColor .. [["/>
                            <corners android:radius="16dp"/>
                        </shape>
                        ]],
						typeface = bcUI.settings.promptFont,
						id = 'path_picker_' .. index,
                                paddingLeft = '10dp',
                                layout_marginRight = '10dp'
                            },
                            {
                                Button,
                                layout_height = 'wrap_content',
                                layout_width = 'wrap_content',
                                gravity = 'center',
                                id = 'path_picker_' .. index .. '_button',
                                textSize = bcUI.settings.promptEditTextButtonTextSize,
                                textColor = bcUI.settings.promptEditTextButtonTextColor,
                                textStyle = bcUI.settings.promptEditTextButtonTextStyle,
                                background = [[<?xml version="1.0" encoding="utf-8"?>
                        <!-- rounded_corners.xml -->
                        <shape xmlns:android="http://schemas.android.com/apk/res/android">
                            <solid android:color="]] .. bcUI.settings.promptEditTextButtonColor .. [["/>
                            <corners android:radius="16dp"/>
                        </shape>
                        ]],
                                text = 'OK',
								typeface = bcUI.settings.promptFont,
                                onClick = function()
                                    local path_picker = _G['path_picker_' .. index]
                                    local filePath = path_picker:getText():toString()
                                    runInBackground(
                                        bcUI.directoryPicker,
                                        filePath,
                                        headerText,
                                        footerText,
                                        dialogWidth,
                                        dialogHeight,
                                        promptLayout,
                                        index
                                    )
                                end
                            }
                        }

                        return linearLayout
                    end

                    local function createCheckBox(inputType, checkText, buttonTypeface)
                        local checkBox = {
                            CheckBox,
                            layout_height = 'wrap_content',
                            layout_width = 'match_parent',
                            layout_marginTop = '5dp',
                            gravity = 'right|center_vertical',
                            textSize = bcUI.settings.promptCheckboxTextSize,
                            textColor = bcUI.settings.promptCheckboxTextColor,
                            textStyle = bcUI.settings.promptCheckboxTextStyle,
                            text = checkText,
                            typeface = bcUI.settings.promptFont,
                            id = 'button_' .. index,
                            paddingRight = '4dp'
                        }

                        return checkBox
                    end

                    local function createSeekBar(inputType, hintText)
                        local linearLayout = {
                            LinearLayout,
                            layout_width = 'match_parent',
                            layout_height = 'wrap_content',
                            orientation = 'vertical',
                            gravity = 'center'
                        }

                        local textView = {
                            TextView,
                            layout_width = 'wrap_content',
                            layout_height = 'wrap_content',
                            layout_marginTop = '10dp',
                            textColor = bcUI.settings.promptSeekBarTextColor,
                            textStyle = bcUI.settings.promptSeekBarTextStyle,
                            textSize = bcUI.settings.promptSeekBarTextSize,
                            text = itemText,
                            tag = itemText,
                            id = 'seekbar_' .. index .. '_label',
							typeface = bcUI.settings.promptFont
                        }

                        local SeekBar = {
                            SeekBar,
                            layout_width = 'match_parent',
                            layout_height = 'wrap_content',
                            id = 'seekbar_' .. index,
                            min = itemValues[1],
                            max = itemValues[2]
                        }

                        linearLayout[2] = textView
                        linearLayout[3] = SeekBar

                        return linearLayout
                    end

                    local function createSwitch(inputType, hintText)
                        local Switch = {
                            Switch,
                            layout_width = 'match_parent',
                            layout_height = 'wrap_content',
                            layout_marginTop = '5dp',
                            textColor = bcUI.settings.promptSwitchTextColor,
                            textStyle = bcUI.settings.promptSwitchTextStyle,
                            textSize = bcUI.settings.promptSwitchTextSize,
                            id = 'button_' .. index,
                            text = itemText,
                            layout_weight = '1',
							typeface = bcUI.settings.promptFont
                        }
                        return Switch
                    end

                    local promptItem
                    if itemTypes[index] == 'file' then
                        promptItem = createFilePicker('text', itemText, itemValues[index])
                    end
                    if itemTypes[index] == 'path' then
                        promptItem = createDirectoryPicker('text', itemText, itemValues[index])
                    end
                    if itemTypes[index] == 'text' then
                        promptItem = createEditText('text', itemText)
                    end
                    if itemTypes[index] == 'number' then
                        promptItem = createEditText('number', itemText)
                    end
                    if itemTypes[index] == 'seek' then
                        promptItem = createSeekBar('seek', itemText)
                    end
                    if itemTypes[index] == 'switch' then
                        promptItem = createSwitch('switch', itemText)
                    end
                    if itemTypes[index] == 'checkbox' then
                        promptItem = createCheckBox('checkbox', itemText)
                    end

                    promptLayout[2][3][2][2][index + 1] = promptItem

                    if index == #menuItems then
                        local button = {
                            Button,
                            layout_height = 'wrap_content',
                            layout_width = 'match_parent',
                            layout_marginTop = '10dp',
                            layout_marginBottom = '10dp',
                            gravity = 'center',
                            textSize = bcUI.settings.promptButtonTextSize,
                            textColor = bcUI.settings.promptButtonTextColor,
                            textStyle = bcUI.settings.promptButtonTextStyle,
                            background = [[<?xml version="1.0" encoding="utf-8"?>
    <!-- rounded_corners.xml -->
    <shape xmlns:android="http://schemas.android.com/apk/res/android">
    <solid android:color="]] ..
                                bcUI.settings.promptButtonColor .. [["/>
    <corners android:radius="16dp"/>
    </shape>
    ]],
                            text = 'OK',
                            typeface = bcUI.settings.promptFont,
                            id = 'button_' .. index + 1
                        }
                        promptLayout[2][3][2][2][index + 2] = button

                        button.onClick = function(view)
                            bcUI.toast.success(headerText)
                            

                            buttonClick(view, index + 1, 'button')
                        end
                    end
                end
            end

            createButtons(menuItems)

            promptLayout = bcUI.loadlayout(promptLayout, menuItems, 'prompt')

            local getCardView = function(elements)
                for _, element in ipairs(elements) do
                    local widgetType = element.getClass().getSimpleName()
                    if widgetType:find('CardView') then
                        return element
                    end
                end
            end
            local getWidgetInfo = function(elements)
                local elementCount = 0
                for _, element in ipairs(elements) do
                    local widgetType = element.getClass().getSimpleName()
                    local widgetId = element.getId()
                    if widgetType:find('CheckBox') then
                        elementCount = elementCount + 1
                        checkBoxElements[elementCount] = element
                    elseif widgetType:find('EditText') then
                        elementCount = elementCount + 1
                        editTextElements[elementCount] = element
                    elseif widgetType:find('SeekBar') then
                        elementCount = elementCount + 1
                        seekBarElements[elementCount] = element
                    elseif widgetType:find('Switch') then
                        elementCount = elementCount + 1
                        switchElements[elementCount] = element
                    end
                end
            end

            local allElements = bcUI.listAllElements(promptLayout)
            allElements = bcUI.listAllElements(getCardView(allElements))
            getWidgetInfo(allElements)

            activity.runOnUiThread(
                function()
                    for index, state in ipairs(menuItems) do
                        if itemTypes[index] == 'file' then
                            local file_picker = _G['file_picker_' .. index]
                            local file_picker_button = _G['file_picker_' .. index .. '_button']
                            local NewSize = file_picker_button.getTextSize()
                            local textPixels = math.tointeger(math.floor(NewSize))

                            local layoutParams = file_picker.getLayoutParams()
                            local density = activity.getResources().getDisplayMetrics().density
                            density = math.ceil(density)
                            if density < 3 then
                                density = density + 0.5
                            end
                            local estimatedHeight = math.ceil(textPixels * density)
                            layoutParams.height = estimatedHeight
                            file_picker.setLayoutParams(layoutParams)
                            file_picker.requestLayout()
                        end
                        if itemTypes[index] == 'path' then
                            local file_picker = _G['path_picker_' .. index]
                            local file_picker_button = _G['path_picker_' .. index .. '_button']
                            local NewSize = file_picker_button.getTextSize()
                            local textPixels = math.tointeger(math.floor(NewSize))

                            local layoutParams = file_picker.getLayoutParams()
                            local density = activity.getResources().getDisplayMetrics().density
                            density = math.ceil(density)
                            if density < 3 then
                                density = density + 0.5
                            end
                            local estimatedHeight = math.ceil(textPixels * density)
                            layoutParams.height = estimatedHeight
                            file_picker.setLayoutParams(layoutParams)
                            file_picker.requestLayout()
                        end
                        if itemValues[index] and itemTypes[index] == 'seek' then
                            local SeekBar = seekBarElements[index]
                            if SeekBar then
                                SeekBar.setMax(itemValues[index][2])
                                SeekBar.setProgress(itemValues[index][3])
                                local seekBarLabel = _G['seekbar_' .. index .. '_label']
                                local tag = seekBarLabel.getTag()
                                seekBarLabel.setText(tag .. ' (' .. tostring(itemValues[index][3]) .. ')')
                                SeekBar.setOnSeekBarChangeListener(
                                    luajava.createProxy(
                                        'android.widget.SeekBar$OnSeekBarChangeListener',
                                        {
                                            onStopTrackingTouch = function(seekBar)
                                                local progress = SeekBar.getProgress()
                                                if progress < itemValues[index][1] then
                                                    SeekBar.setProgress(itemValues[index][1])
                                                end
                                                buttonClick(SeekBar, index, itemTypes[index])
                                            end
                                        }
                                    )
                                )
                            end
                        end

                        if itemTypes[index] == 'checkbox' then
                            local checkbox = checkBoxElements[index]
                            if checkbox then
                                checkbox.setOnClickListener(
                                    luajava.createProxy(
                                        'android.view.View$OnClickListener',
                                        {
                                            onClick = function(view)
                                                buttonClick(view, index, itemTypes[index])
                                            end
                                        }
                                    )
                                )
                                checkbox.setChecked(itemValues[index])
                            end
                        end

                        if itemTypes[index] == 'switch' then
                            local Switch = switchElements[index]
                            if Switch then
                                Switch.setOnClickListener(
                                    luajava.createProxy(
                                        'android.view.View$OnClickListener',
                                        {
                                            onClick = function(view)
                                                buttonClick(view, index, itemTypes[index])
                                            end
                                        }
                                    )
                                )
                                Switch.setChecked(itemValues[index])
                            end
                        end
                    end
                end
            )
        end
		mainLayoutParams = bcUI.getLayoutParams()

		function touch.onTouch(v, event)
			local Action = event.getAction()

			if Action == MotionEvent.ACTION_DOWN then
				RawX = event.getRawX()
				RawY = event.getRawY()
				x = mainLayoutParams.x
				y = mainLayoutParams.y
                oooPressStartTime = os.time()
            elseif Action == MotionEvent.ACTION_UP then
                local endX, endY = event.getRawX(), event.getRawY()
                local deltaX = endX - RawX
                local deltaY = endY - RawY
                if (deltaX > -50 and deltaX < 50) and (deltaY > -50 and deltaY < 50) then
                    local pressDuration = os.time() - oooPressStartTime
                    if pressDuration >= 2 then -- Only execute if press lasted at least 2 seconds
                        window.removeView(promptLayout)
                        activity.stopFunc()
                        if callback then
                            promptTable = nil
                            isChoiceMade = true
                        end
                    end
                end
			elseif Action == MotionEvent.ACTION_MOVE then
                mainLayoutParams.x = tonumber(x) + (event.getRawX() - RawX)
				mainLayoutParams.y = tonumber(y) + (event.getRawY() - RawY)
				window.updateViewLayout(promptLayout, mainLayoutParams)
			end
		end
        local setUi = function()
            activity.runOnUiThread(
                function()
                    window.addView(promptLayout, bcUI.getLayoutParams())
                end
            )
        end
        setUi()
    end,
    filePicker = function(sdPath, headerText, footerText, dialogWidth, dialogHeight, callingView, callingIndex)
        local selectedFile
        local nextDir

        function countOccurrences(str, char)
            local count = 0
            for i = 1, #str do
                if str:sub(i, i) == char then
                    count = count + 1
                end
            end
            return count
        end

        ::loadnextdir::

        if nextDir then
            sdPath = nextDir:gsub('/$', '')
        elseif not sdPath then
            sdPath = gg.EXT_STORAGE
        end

        local slashCount = countOccurrences(sdPath, '/') + 2
        local sdPathFiles = file.list(sdPath, file.TYPE_CHILD, 1)
        local menuItems = {}

        for index, filePath in pairs(sdPathFiles) do
            local cleanedPath = filePath
            if index == 1 and filePath ~= gg.EXT_STORAGE .. '/' and filePath ~= '/sdcard/' then
                cleanedPath = file.sub(filePath, 1, slashCount - 2)
            end
            table.insert(menuItems, cleanedPath)
        end

        local DialogWidth = dialogWidth or bcUI.settings.filePickerWidth
	        local DialogHeight = dialogHeight or bcUI.settings.filePickerHeight or nil

            if type(DialogWidth) == "string" then
                DialogWidth = DialogWidth:gsub("dp","")
            else
                DialogWidth = bcUI.percentageToDp(DialogWidth, true)
            end
            if DialogHeight and  type(DialogHeight) == "string" then
                DialogHeight = DialogHeight:gsub("dp","")
            elseif DialogHeight then
                DialogHeight = bcUI.percentageToDp(DialogHeight)
            end

        local mainLayout =
            bcUI.getLayout(
            DialogWidth,
            DialogHeight,
            bcUI.settings.filePickerBackgroundColor,
            bcUI.settings.filePickerCardBackgroundColor,
            headerText,
            bcUI.settings.filePickerHeaderTextColor,
            bcUI.settings.filePickerHeaderTextSize,
            bcUI.settings.filePickerHeaderTextStyle,
            footerText,
            bcUI.settings.filePickerFooterTextColor,
            bcUI.settings.filePickerFooterTextSize,
            bcUI.settings.filePickerFooterTextStyle,
			nil,
			nil,
			bcUI.settings.filePickerFont
        )

        local mainLayoutParams = bcUI.getLayoutParams()

        local buttonClick = function(v, buttonIndex)
            nextDir = nil
            local buttonText = tostring(v.getTag())
            selectedFile = buttonText
            DebugPrint(debug.getinfo(2).currentline, "File Picker Dialog Button Clicked:", {Index = buttonIndex, Text = buttonText})
            bcUI.toast.success('You Selected: ' .. buttonText)
            if callingView then
                local file_picker = _G['file_picker_' .. callingIndex]
                file_picker.setText(buttonText)
                file_picker.setSingleLine(true) 
                file_picker.setMaxWidth(file_picker.getWidth())
                local getPath = file_picker:getText():toString()
                if not getPath:find('%.') then
                    changeDir = true

                    window.removeView(mainLayout)

                    runInBackground(
                        bcUI.filePicker,
                        getPath,
                        headerText,
                        footerText,
                        dialogWidth,
                        dialogHeight,
                        callingView,
                        callingIndex
                    )
                else
                    bcUI.switchViews(mainLayout, callingView, mainLayoutParams)
                end
            else
                window.removeView(mainLayout)
                activity.stopFunc()
            end
        end

        local createButtons = function(namesTable)
            for index, itemText in ipairs(namesTable) do
                local buttonString

                if itemText:find('/$') then
					if bcUI.settings.filePickerFont and bcUI.settings.filePickerFont:find('UbuntuAwesome.ttf$') then
                        buttonString = fA('fa-folder') .. ' ' .. itemText
                    else
                        buttonString = '📁 ' .. itemText
                    end
                    
                else
                    if bcUI.settings.filePickerFont and bcUI.settings.filePickerFont:find('UbuntuAwesome.ttf$') then
                        buttonString = fA('fa-file') .. ' ' .. itemText
                    else
                        buttonString = '📄 ' .. itemText
                    end
                end
                local topMargin
                local bottomMargin
                if index == 1 then
                    topMargin = '10dp'
                    bottomMargin = '5dp'
                elseif index ~= #namesTable then
                    topMargin = '5dp'
                    bottomMargin = '5dp'
                else
                    topMargin = '5dp'
                    bottomMargin = '10dp'
                end
                local button = {
                    Button,
                    layout_height = 'wrap_content',
                    layout_width = 'match_parent',
                    layout_marginTop = topMargin,
                    layout_marginBottom = bottomMargin,
                    gravity = 'left',
                    textSize = bcUI.settings.filePickerButtonTextSize,
                    textColor = bcUI.settings.filePickerButtonTextColor,
                    textStyle = bcUI.settings.filePickerButtonTextStyle,
                    background = [[<?xml version="1.0" encoding="utf-8"?>
    <!-- rounded_corners.xml -->
    <shape xmlns:android="http://schemas.android.com/apk/res/android">
    <solid android:color="]] .. bcUI.settings.filePickerButtonColor .. [["/>
    <corners android:radius="16dp"/>
    </shape>
    ]],
                    tag = itemText,
                    text = buttonString,
                    typeface = bcUI.settings.filePickerFont,
                    id = 'button_' .. index
                }

                mainLayout[2][3][2][2][index + 1] = button

                button.onClick = function(view)
                    buttonClick(view, index)
                end
            end
        end

        createButtons(menuItems)

        mainLayout = loadlayout(mainLayout)

        local setUi = function(arr)
            function invoke()
                if callingView and not changeDir then
                    bcUI.switchViews(callingView, mainLayout, mainLayoutParams)
                else
                    window.addView(mainLayout, mainLayoutParams)
                end
            end
            activity.runOnUiThread(invoke)
        end
        setUi()
        if nextDir then
            goto loadnextdir
        end
        return selectedFile
    end,
    directoryPicker = function(sdPath, headerText, footerText, dialogWidth, dialogHeight, callingView, callingIndex)
        local selectedFile
        local nextDir

        function countOccurrences(str, char)
            local count = 0
            for i = 1, #str do
                if str:sub(i, i) == char then
                    count = count + 1
                end
            end
            return count
        end

        ::loadnextdir::

        if nextDir then
            sdPath = nextDir:gsub('/$', '')
        elseif not sdPath then
            sdPath = gg.EXT_STORAGE
        end

        local slashCount = countOccurrences(sdPath, '/') + 2
        local sdPathFiles = file.list(sdPath, file.TYPE_CHILD, 1)
        local menuItems = {}

        table.insert(sdPathFiles, 1, sdPathFiles[1])

        for index, filePath in pairs(sdPathFiles) do
            local cleanedPath = filePath
            if index == 1 and filePath ~= gg.EXT_STORAGE .. '/' and filePath ~= '/sdcard/' then
                cleanedPath = file.sub(filePath, 1, slashCount - 2)
            end
            if not cleanedPath:find('%.') then
                table.insert(menuItems, cleanedPath)
            end
        end

        local DialogWidth = dialogWidth or bcUI.settings.directoryPickerWidth
	        local DialogHeight = dialogHeight or bcUI.settings.directoryPickerHeight or nil

            if type(DialogWidth) == "string" then
                DialogWidth = DialogWidth:gsub("dp","")
            else
                DialogWidth = bcUI.percentageToDp(DialogWidth, true)
            end
            if DialogHeight and  type(DialogHeight) == "string" then
                DialogHeight = DialogHeight:gsub("dp","")
            elseif DialogHeight then
                DialogHeight = bcUI.percentageToDp(DialogHeight)
            end
        

        local mainLayout =
            bcUI.getLayout(
            DialogWidth,
            DialogHeight,
            bcUI.settings.directoryPickerBackgroundColor,
            bcUI.settings.directoryPickerCardBackgroundColor,
            headerText,
            bcUI.settings.directoryPickerHeaderTextColor,
            bcUI.settings.directoryPickerHeaderTextSize,
            bcUI.settings.directoryPickerHeaderTextStyle,
            footerText,
            bcUI.settings.directoryPickerFooterTextColor,
            bcUI.settings.directoryPickerFooterTextSize,
            bcUI.settings.directoryPickerFooterTextStyle,
			nil,
			nil,
			bcUI.settings.directoryPickerFont
        )

        local mainLayoutParams = bcUI.getLayoutParams()

        local buttonClick = function(v, buttonIndex)
            local buttonText = tostring(v.getTag())

            selectedFile = buttonText
            DebugPrint(debug.getinfo(2).currentline, "Directory Picker Dialog Button Clicked:", {Index = buttonIndex, Text = buttonText})
            bcUI.toast.success('You Selected: ' .. buttonText)
            if callingView then
                local path_picker_ = _G['path_picker_' .. callingIndex]
                path_picker_.setText(buttonText)
                path_picker_.setSingleLine(true)
                path_picker_.setMaxWidth(path_picker_.getWidth())
                local getPath = path_picker_:getText():toString()
                if sdPathFiles[2] == buttonText then
                    bcUI.switchViews(mainLayout, callingView, mainLayoutParams)
                else
                    changeDir = true
                    window.removeView(mainLayout)
                    runInBackground(
                        bcUI.directoryPicker,
                        getPath,
                        headerText,
                        footerText,
                        dialogWidth,
                        dialogHeight,
                        callingView,
                        callingIndex
                    )
                end
            else
                window.removeView(mainLayout)
                activity.stopFunc()
            end
        end

        local createButtons = function(namesTable)
            for index, itemText in ipairs(namesTable) do
                local buttonString

                if itemText:find('/$') then
					if bcUI.settings.filePickerFont and bcUI.settings.filePickerFont:find('UbuntuAwesome.ttf$') then
                        buttonString = fA('fa-folder') .. ' ' .. itemText
                    else
                        buttonString = '📁 ' .. itemText
                    end
                else
                    if bcUI.settings.filePickerFont and bcUI.settings.filePickerFont:find('UbuntuAwesome.ttf$') then
                        buttonString = fA('fa-file') .. ' ' .. itemText
                    else
                        buttonString = '📄 ' .. itemText
                    end
                end
                local topMargin
                local bottomMargin
                if index == 1 then
                    topMargin = '10dp'
                    bottomMargin = '5dp'
                elseif index ~= #namesTable then
                    topMargin = '5dp'
                    bottomMargin = '5dp'
                else
                    topMargin = '5dp'
                    bottomMargin = '10dp'
                end
                local button = {
                    Button,
                    layout_height = 'wrap_content',
                    layout_width = 'match_parent',
                    layout_marginTop = topMargin,
                    layout_marginBottom = bottomMargin,
                    gravity = 'left',
                    textSize = bcUI.settings.filePickerButtonTextSize,
                    textColor = bcUI.settings.filePickerButtonTextColor,
                    textStyle = bcUI.settings.filePickerButtonTextStyle,
                    background = [[<?xml version="1.0" encoding="utf-8"?>
        <!-- rounded_corners.xml -->
        <shape xmlns:android="http://schemas.android.com/apk/res/android">
        <solid android:color="]] .. bcUI.settings.filePickerButtonColor .. [["/>
        <corners android:radius="16dp"/>
        </shape>
        ]],
                    tag = itemText,
                    text = buttonString,
                    typeface = bcUI.settings.directoryPickerFont,
                    id = 'button_' .. index
                }

                mainLayout[2][3][2][2][index + 1] = button

                button.onClick = function(view)
                    buttonClick(view, index)
                end
            end
        end

        createButtons(menuItems)

        mainLayout = loadlayout(mainLayout)

        local setUi = function(arr)
            function invoke()
                if callingView and not changeDir then
                    bcUI.switchViews(callingView, mainLayout, mainLayoutParams)
                else
                    window.addView(mainLayout, mainLayoutParams)
                end
            end
            activity.runOnUiThread(invoke)
        end
        setUi()
        if nextDir then
            goto loadnextdir
        end
        return selectedFile
    end,
	choiceImages = function(menuItems, headerText, footerText,buttonHeight, dialogWidth, dialogHeight)
		choiceImagesMenu = nil
		isChoiceMade = false
		bcUI.buildChoiceImages(
			menuItems,
			headerText,
			footerText,
			buttonHeight,
			dialogWidth,
			dialogHeight,
			function(selectedIndex)
				choiceImagesMenu = selectedIndex
				isChoiceMade = true
			end
		)
		while not isChoiceMade do
			os.execute("sleep 0.1")
		end
        bcUI.toast.success('Button ' .. choiceImagesMenu .. ' Selected')
		return choiceImagesMenu
	end,
    buildChoiceImages = function(menuItems, headerText, footerText, buttonHeight, dialogWidth, dialogHeight, callback) -- Added callback parameter
        local choiceImagesLayout = bcUI.loadlayout(nil, menuItems, 'choiceImages')
        local buttonClick = function(v, buttonIndex)
			mainLayoutParams = bcUI.getLayoutParams()
            DebugPrint(debug.getinfo(2).currentline, "Choice Image Dialog Button Clicked:", {Index = buttonIndex})
            window.removeView(choiceImagesLayout)
            activity.stopFunc()
            if callback then
                choiceImagesMenu = buttonIndex
                isChoiceMade = true
            end
        end
        if not choiceImagesLayout then
            local DialogWidth = dialogWidth or bcUI.settings.choiceImageWidth
	        local DialogHeight = dialogHeight or bcUI.settings.choiceImageHeight or nil

            if type(DialogWidth) == "string" then
                DialogWidth = DialogWidth:gsub("dp","")
            else
                DialogWidth = bcUI.percentageToDp(DialogWidth, true)
            end
            if DialogHeight and  type(DialogHeight) == "string" then
                DialogHeight = DialogHeight:gsub("dp","")
            elseif DialogHeight then
                DialogHeight = bcUI.percentageToDp(DialogHeight)
            end

            choiceImagesLayout =
                bcUI.getLayout(
                DialogWidth,
                DialogHeight,
                bcUI.settings.choiceImageBackgroundColor,
                bcUI.settings.choiceImageCardBackgroundColor,
                headerText,
                bcUI.settings.choiceImageHeaderTextColor,
                bcUI.settings.choiceImageHeaderTextSize,
                bcUI.settings.choiceImageHeaderTextStyle,
                footerText,
                bcUI.settings.choiceImageFooterTextColor,
                bcUI.settings.choiceImageFooterTextSize,
                bcUI.settings.choiceImageFooterTextStyle,
				nil,
				nil,
				bcUI.settings.choiceImageFont
            )

            local createButtons = function(namesTable)
                for index, imagePath in pairs(namesTable) do
                    local topMargin = (index == 1 and '10dp' or '5dp')
                    local bottomMargin = (index == #namesTable and '10dp' or '5dp')
                    local ButtonHeight = buttonHeight  or bcUI.settings.choiceImageButtonHeight
                    if type(ButtonHeight) == "string" then
                        ButtonHeight = ButtonHeight:gsub("dp","")
                    else
                        ButtonHeight = bcUI.percentageToDp(ButtonHeight)
                    end
                    local button = {
                        ImageButton,
                        layout_width = 'wrap_content',
                        layout_height = ButtonHeight .. 'dp',
                        layout_marginTop = topMargin,
                        layout_marginBottom = bottomMargin,
                        padding = '0dp',
                        background = '#00000000',
                        src = imagePath,
                        scaleType = 'fitCenter',
                        id = 'button_' .. index
                    }

                    choiceImagesLayout[2][3][2][2][index + 1] = button

                    button.onClick = function(view)
                        buttonClick(view, index)
                    end
                end
            end

            createButtons(menuItems)

            choiceImagesLayout = bcUI.loadlayout(choiceImagesLayout, menuItems, 'choiceImages')
        end
		mainLayoutParams = bcUI.getLayoutParams()

		function touch.onTouch(v, event)
			local Action = event.getAction()

			if Action == MotionEvent.ACTION_DOWN then
				RawX = event.getRawX()
				RawY = event.getRawY()
				x = mainLayoutParams.x
				y = mainLayoutParams.y
                oooPressStartTime = os.time()
            elseif Action == MotionEvent.ACTION_UP then
                local endX, endY = event.getRawX(), event.getRawY()
                local deltaX = endX - RawX
                local deltaY = endY - RawY
                if (deltaX > -50 and deltaX < 50) and (deltaY > -50 and deltaY < 50) then
                    local pressDuration = os.time() - oooPressStartTime
                    if pressDuration >= 2 then -- Only execute if press lasted at least 2 seconds
                        window.removeView(choiceImagesLayout)
                        activity.stopFunc()
                        if callback then
                            choiceImagesMenu = nil
                            isChoiceMade = true
                        end
                    end
                end
			elseif Action == MotionEvent.ACTION_MOVE then
                mainLayoutParams.x = tonumber(x) + (event.getRawX() - RawX)
				mainLayoutParams.y = tonumber(y) + (event.getRawY() - RawY)
				window.updateViewLayout(choiceImagesLayout, mainLayoutParams)
			end
		end
        local setUi = function()
            function invoke()
                window.addView(choiceImagesLayout, bcUI.getLayoutParams())
            end
            activity.runOnUiThread(invoke)
        end
        setUi()
    end,
	
    getLayout = function(layoutWidth, layoutHeight, mainBackgroundColor, cardBackgroundColor, headerText, headerTextColor, headerTextSize, headerTextStyle, footerText, footerTextColor,footerTextSize,footerTextStyle,alertButtons,buttonColor,typeface)
        if not layoutHeight then
            layoutHeight = 'match_parent'
        end

        local mainLayout = {
            CardView,
            radius = '8dp',
            cardElevation = '8dp',
            id = 'touch',
            layout_height = 'match_parent',
            layout_width = layoutWidth .. 'dp',
            cardBackgroundColor = mainBackgroundColor,
            {
                LinearLayout,
                id = 'ooo',
                layout_height = 'match_parent',
                orientation = 'vertical',
                layout_width = layoutWidth .. 'dp',

                {
                    LinearLayout,
                    layout_height = 'wrap_content',
                    layout_width = 'match_parent',
                    {
                        LinearLayout,
                        layout_height = 'match_parent',
                        layout_width = 'match_parent',
                        {
                            TextView,
                            id = 'control',
                            layout_height = 'match_parent',
                            layout_width = 'match_parent',
                            text = headerText,
                            textSize = headerTextSize,
                            textStyle = headerTextStyle,
                            textColor = headerTextColor,
                            layout_marginTop = '10dp',
                            layout_marginBottom = '10dp',
                            gravity = 'center',
							typeface = typeface
                        }
                    }
                },
                {
                    CardView,
                    radius = '8dp',
                    cardElevation = '4dp',
                    id = 'touch',
                    layout_height = 'match_parent',
                    layout_width = 'match_parent',
                    cardBackgroundColor = cardBackgroundColor,
                    layout_marginLeft = '10dp',
                    layout_marginRight = '10dp',
                {
                    ScrollView,
                    layout_height = layoutHeight,
                    layout_width = 'match_parent',
                    
                    {
                        LinearLayout,
                        layout_height = 'match_parent',
                        layout_width = 'match_parent',
                        orientation = 'vertical',
                        background = '#55CFCFCF',
                        paddingLeft = '10dp',
                        paddingRight = '10dp'
                    }
                },
                },
            }
        }

        if not alertButtons then
            mainLayout[2][4] = {
                LinearLayout,
                layout_height = 'wrap_content',
                layout_width = 'match_parent',
                {
                    LinearLayout,
                    layout_height = 'match_parent',
                    layout_width = 'match_parent',
                    {
                        TextView,
                        id = 'control',
                        layout_height = 'match_parent',
                        layout_width = 'match_parent',
                        text = footerText,
                        textSize = footerTextSize,
                        textColor = footerTextColor,
                        textStyle = footerTextStyle,
                        layout_marginTop = '10dp',
                        layout_marginBottom = '10dp',
                        gravity = 'center',
						typeface = typeface
                    }
                }
            }
        else

            mainLayout[2][4] = {
                LinearLayout,
                layout_width = "match_parent",
                layout_height = "wrap_content",
                orientation = "horizontal",
                gravity = "end",
                padding = "10dp",
            }

            local layoutCount = 2

            if #alertButtons == 3 then
                mainLayout[2][4][layoutCount] = {
                    Button,
                    layout_width = "wrap_content",
                    layout_height = "wrap_content",
                    text = alertButtons[3],
                    id = "neutralButton",
                    background = [[<?xml version="1.0" encoding="utf-8"?>
<!-- rounded_corners.xml -->
<shape xmlns:android="http://schemas.android.com/apk/res/android">
    <solid android:color="]] .. bcUI.settings.alertNeutralButtonColor .. [["/>
    <corners android:radius="16dp"/>
</shape>
]],
                    textSize =  bcUI.settings.alertNeutralButtonTextSize,
                    textStyle = bcUI.settings.alertNeutralButtonTextStyle,
                    textColor = bcUI.settings.alertNeutralButtonTextColor,
					typeface = typeface
                }
                layoutCount = layoutCount + 1
            end
    
            mainLayout[2][4][layoutCount] = {
                Space,
                layout_width = "0dp",
                layout_height = "match_parent",
                layout_weight = 1
            }

            layoutCount = layoutCount + 1

            mainLayout[2][4][layoutCount] = {
                LinearLayout,
                layout_width = "wrap_content",
                layout_height = "match_parent",
                orientation = "horizontal",
                {
                    Button,
                    layout_width = "wrap_content",
                    layout_height = "match_parent",
                    text = alertButtons[1],
                    id = "positiveButton",
                    background = [[<?xml version="1.0" encoding="utf-8"?>
<!-- rounded_corners.xml -->
<shape xmlns:android="http://schemas.android.com/apk/res/android">
    <solid android:color="]] .. bcUI.settings.alertPositiveButtonColor .. [["/>
    <corners android:radius="16dp"/>
</shape>
]],
                    textSize = bcUI.settings.alertPositiveButtonTextSize,
                    textStyle = bcUI.settings.alertPositiveButtonTextStyle,
                    textColor = bcUI.settings.alertPositiveButtonTextColor,
					typeface = typeface
                }
            }

            if #alertButtons >= 2 then
                mainLayout[2][4][layoutCount][3] = {
                    Button,
                    layout_width = "wrap_content",
                    layout_height = "match_parent",
                    layout_marginLeft = "10dp",
                    text = alertButtons[2],
                    id = "negativeButton",
                    background = [[<?xml version="1.0" encoding="utf-8"?>
<!-- rounded_corners.xml -->
<shape xmlns:android="http://schemas.android.com/apk/res/android">
    <solid android:color="]] .. bcUI.settings.alertNegativeButtonColor .. [["/>
    <corners android:radius="16dp"/>
</shape>
]],
                    textSize =  bcUI.settings.alertNegativeButtonTextSize,
                    textStyle = bcUI.settings.alertNegativeButtonTextStyle,
                    textColor = bcUI.settings.alertNegativeButtonTextColor,
					typeface = typeface
                }
            end
        end
        return mainLayout
    end,
    getLayoutParams = function()
        local LayoutParams = WindowManager.LayoutParams
        local layoutParams = luajava.new(LayoutParams)
        if Build.VERSION.SDK_INT >= 26 then
            layoutParams.type = LayoutParams.TYPE_APPLICATION_OVERLAY
        else
            layoutParams.type = LayoutParams.TYPE_PHONE
        end
        layoutParams.format = PixelFormat.RGBA_8888
        layoutParams.flags = bit32.bor(LayoutParams.FLAG_NOT_TOUCH_MODAL, LayoutParams.FLAG_LAYOUT_IN_SCREEN)
        layoutParams.softInputMode = WindowManager.LayoutParams.SOFT_INPUT_STATE_VISIBLE
        layoutParams.gravity = Gravity.CENTER
        layoutParams.width = LayoutParams.WRAP_CONTENT
        layoutParams.height = LayoutParams.WRAP_CONTENT
        return layoutParams
    end,
    percentageToDp = function(percentage, setWidth)
        local metrics = activity.getResources().getDisplayMetrics()
        local screenHeight = tonumber(metrics.heightPixels)
        local screenWidth = tonumber(metrics.widthPixels)
        if setWidth then
            local px = (percentage * screenWidth) / 100
            return px / metrics.density
        else
            local px = (percentage * screenHeight) / 100
            return px / metrics.density
        end
    end,
	exit = function()
		for _, layout in ipairs(bcUI.loadedLayouts) do
			local parent = layout:getParent()
			if parent then
				parent:removeView(layout)
			end
		end
		activity.stopFunc()
		activity:finish()
		os.exit()
	end
}

bcUI.getResources()
bcUI.settings.alertFont = bcUI.settings.alertFont and Typeface.createFromFile(bcUI.settings.alertFont) or nil
bcUI.settings.choiceFont = bcUI.settings.choiceFont and Typeface.createFromFile(bcUI.settings.choiceFont) or nil
bcUI.settings.choiceImageFont = bcUI.settings.choiceImageFont and Typeface.createFromFile(bcUI.settings.choiceImageFont) or nil
bcUI.settings.multiChoiceFont = bcUI.settings.multiChoiceFont and Typeface.createFromFile(bcUI.settings.multiChoiceFont) or nil
bcUI.settings.multiChoiceTogglesFont = bcUI.settings.multiChoiceTogglesFont and Typeface.createFromFile(bcUI.settings.multiChoiceTogglesFont) or nil
bcUI.settings.promptFont = bcUI.settings.promptFont and Typeface.createFromFile(bcUI.settings.promptFont) or nil
bcUI.settings.filePickerFont = bcUI.settings.filePickerFont and Typeface.createFromFile(bcUI.settings.filePickerFont) or nil
bcUI.settings.directoryPickerFont = bcUI.settings.directoryPickerFont and Typeface.createFromFile(bcUI.settings.directoryPickerFont) or nil

local arClass = luajava.bindClass("android.ext.ar")

local arInstance = arClass.d
if arInstance then
    local handler = arInstance:getHandler()
    if handler then
        handler:removeCallbacksAndMessages(nil)
    end
end

function fA(faName)
    local glyph
    if faTable[faName] then
        glyph = utf8.char(faTable[faName] )
        return glyph
    else
        return "?"
    end
end

function runInBackground(taskFunction,parameter1,parameter2,parameter3,parameter4,parameter5,parameter6,parameter7)
    local Runnable = luajava.bindClass("java.lang.Runnable")
    local Thread = luajava.bindClass("java.lang.Thread")
    local runnableProxy = luajava.createProxy("java.lang.Runnable", {
        run = function()
            taskFunction(parameter1,parameter2,parameter3,parameter4,parameter5,parameter6,parameter7)
        end
    })
    local threadInstance = luajava.newInstance("java.lang.Thread", runnableProxy)
    threadInstance.start()
end

DebugPrint = function(currentLine, message,data)
    if bcUI.settings.debugging then
        print('Line: ' .. currentLine .. " : " .. message)
        if data then
            if type(data) == "table" then
            for key, value in pairs(data) do
            print('[Debug]: Key: ' .. key .. " Value: " .. tostring(value))
            end
            else
                print('[Debug]: ' .. tostring(data))
            end
        end
    end
end

gg.setVisible(false)

function home()
    local result =
            bcUI.prompt(
    {'Username', 'Password'},
    {'admin', ''},
    {'text', 'text'},
    'Login System',
    'Enter your credentials',
    '300dp'
)

login(result[1], result[2], "https://pastebin.com/raw/GGeb92uZ")

bcUI.exit()
end

while true do
    if gg.isVisible() then
        gg.setVisible(false)
        home()
    end
    gg.sleep(100)
end
