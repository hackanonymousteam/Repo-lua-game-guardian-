gg.setVisible(false)

if not activity then
    gg.toast("No activity")
    return
end

local function bind(c)
    local ok, r = pcall(luajava.bindClass, c)
    if ok then return r end
    return nil
end
local ClipboardManager = bind("android.content.ClipboardManager")
local ClipData = bind("android.content.ClipData")
local TextView = bind("android.widget.TextView")
local EditText = bind("android.widget.EditText")
local WindowManager = bind("android.view.WindowManager")
local PixelFormat = bind("android.graphics.PixelFormat")
local Gravity = bind("android.view.Gravity")
local Color = bind("android.graphics.Color")
local Build = bind("android.os.Build")
local Button = bind("android.widget.Button")
local LinearLayout = bind("android.widget.LinearLayout")
local ScrollView = bind("android.widget.ScrollView")
local HashMap = bind("java.util.HashMap")
local URL = bind("java.net.URL")
local HttpURLConnection = bind("java.net.HttpURLConnection")
local BufferedReader = bind("java.io.BufferedReader")
local InputStreamReader = bind("java.io.InputStreamReader")
local OutputStreamWriter = bind("java.io.OutputStreamWriter")
local StringBuilder = bind("java.lang.StringBuilder")
local URLEncoder = bind("java.net.URLEncoder")
local Thread = bind("java.lang.Thread")
local Handler = bind("android.os.Handler")
local Looper = bind("android.os.Looper")
local InputMethodManager = bind("android.view.inputmethod.InputMethodManager")
local Context = bind("android.content.Context")

local function getType()
    if Build.VERSION.SDK_INT >= 26 then
        return 2038
    elseif Build.VERSION.SDK_INT >= 23 then
        return 2002
    else
        return 2003
    end
end
local function copyText(text)
    local clipboard = activity.getSystemService(Context.CLIPBOARD_SERVICE)

    local clip = ClipData.newPlainText(
        "pastebin",
        tostring(text)
    )

    clipboard.setPrimaryClip(clip)
end

local windowParams = luajava.newInstance(
    "android.view.WindowManager$LayoutParams",
    -2,
    -2,
    getType(),
    0,
    PixelFormat.TRANSLUCENT
)
windowParams.gravity = Gravity.TOP + Gravity.LEFT
windowParams.x = 10
windowParams.y = 100

local RequestNetwork = {}
RequestNetwork.__index = RequestNetwork

function RequestNetwork.new(act)
    local self = setmetatable({}, RequestNetwork)
    self.params = HashMap()
    self.headers = HashMap()
    self.activity = act
    self.requestType = 0
    return self
end

function RequestNetwork:setHeaders(headers)
    self.headers = headers
end

function RequestNetwork:setParams(params, requestType)
    self.params = params
    self.requestType = requestType
end

function RequestNetwork:getParams()
    return self.params
end

function RequestNetwork:getHeaders()
    return self.headers
end

function RequestNetwork:getActivity()
    return self.activity
end

function RequestNetwork:getRequestType()
    return self.requestType
end

function RequestNetwork:startRequestNetwork(method, url, tag, responseCallback, errorCallback)
    Thread(
    luajava.createProxy(
        "java.lang.Runnable",
        {
            run = function()
                local success, result = pcall(function()
                    local urlObj = URL(url)
                    local connection = urlObj.openConnection()

                    connection.setRequestMethod(method)
                    connection.setDoInput(true)

                    if method == "POST" then
                        connection.setDoOutput(true)
                    end

                    local headerKeys = self.headers.keySet()
                    local headerIterator = headerKeys.iterator()

                    while headerIterator.hasNext() do
                        local key = headerIterator.next()
                        local value = self.headers.get(key)
                        connection.setRequestProperty(tostring(key), tostring(value))
                    end

                    connection.setConnectTimeout(15000)
                    connection.setReadTimeout(15000)

                    if method == "POST" and self.params.size() > 0 then
                        local writer = OutputStreamWriter(connection.getOutputStream())
                        local postData = StringBuilder()

                        local paramKeys = self.params.keySet()
                        local paramIterator = paramKeys.iterator()

                        local first = true

                        while paramIterator.hasNext() do
                            local key = paramIterator.next()
                            local value = self.params.get(key)

                            if not first then
                                postData.append("&")
                            end

                            postData.append(
    URLEncoder.encode(tostring(key), "UTF-8")
)

postData.append("=")

postData.append(
    URLEncoder.encode(tostring(value), "UTF-8")
)

                            first = false
                        end

                        writer.write(postData.toString())
                        writer.flush()
                        writer.close()
                    end

                    local responseCode = connection.getResponseCode()

                    local inputStream

                    if responseCode >= 200 and responseCode < 400 then
                        inputStream = connection.getInputStream()
                    else
                        inputStream = connection.getErrorStream()
                    end

                    local reader = BufferedReader(
                        InputStreamReader(inputStream)
                    )

                    local response = StringBuilder()

                    while true do
                        local line = reader.readLine()

                        if line == nil then
                            break
                        end

                        response.append(line)
                    end

                    reader.close()
                    connection.disconnect()

                    return response.toString()
                end)

                local handler = Handler(Looper.getMainLooper())

                if success then
                    handler.post(
                        luajava.createProxy(
                            "java.lang.Runnable",
                            {
                                run = function()
                                    responseCallback(tag, result)
                                end
                            }
                        )
                    )
                else
                    handler.post(
                        luajava.createProxy(
                            "java.lang.Runnable",
                            {
                                run = function()
                                    errorCallback(tag, tostring(result))
                                end
                            }
                        )
                    )
                end
            end
        }
    )
).start()
end

local function createLayout()
    local defaultApiKey = "your_api_key_here"
    
    local scrollView = ScrollView(activity)
    scrollView.setFillViewport(true)
    
    local layout = LinearLayout(activity)
    layout.setOrientation(LinearLayout.VERTICAL)
    layout.setBackgroundColor(Color.parseColor("#FF1A1A1A"))
    layout.setPadding(20, 20, 20, 20)

    local titleView = TextView(activity)
    titleView.setText("PASTEBIN UPLOAD")
    titleView.setTextColor(Color.parseColor("#FF00E5FF"))
    titleView.setTextSize(18)
    titleView.setPadding(10, 10, 10, 20)
    titleView.setGravity(Gravity.CENTER)
    layout.addView(titleView)

    local apiLabel = TextView(activity)
    apiLabel.setText("API Key:")
    apiLabel.setTextColor(Color.parseColor("#FFB0BEC5"))
    apiLabel.setTextSize(14)
    layout.addView(apiLabel)
    
    local apiInput = EditText(activity)
    apiInput.setHint("Paste your Pastebin API Key")
    apiInput.setHintTextColor(Color.parseColor("#FF607D8B"))
    apiInput.setTextColor(Color.parseColor("#FFFFEB3B"))
    apiInput.setBackgroundColor(Color.parseColor("#FF37474F"))
    apiInput.setPadding(15, 10, 15, 10)
    apiInput.setTextSize(14)
    apiInput.setSingleLine(true)
    apiInput.setText(defaultApiKey)
    apiInput.setFocusable(true)
    apiInput.setFocusableInTouchMode(true)
    layout.addView(apiInput)

    local spacer1 = TextView(activity)
    spacer1.setHeight(10)
    layout.addView(spacer1)

    local nameLabel = TextView(activity)
    nameLabel.setText("Paste Name:")
    nameLabel.setTextColor(Color.parseColor("#FFB0BEC5"))
    nameLabel.setTextSize(14)
    layout.addView(nameLabel)
    
    local nameInput = EditText(activity)
    nameInput.setHint("MyPaste")
    nameInput.setHintTextColor(Color.parseColor("#FF607D8B"))
    nameInput.setTextColor(Color.WHITE)
    nameInput.setBackgroundColor(Color.parseColor("#FF37474F"))
    nameInput.setPadding(15, 10, 15, 10)
    nameInput.setTextSize(14)
    nameInput.setSingleLine(true)
    nameInput.setText("MyPaste")
    nameInput.setFocusable(true)
    nameInput.setFocusableInTouchMode(true)
    layout.addView(nameInput)

    local spacer2 = TextView(activity)
    spacer2.setHeight(10)
    layout.addView(spacer2)

    local codeLabel = TextView(activity)
    codeLabel.setText("Code:")
    codeLabel.setTextColor(Color.parseColor("#FFB0BEC5"))
    codeLabel.setTextSize(14)
    layout.addView(codeLabel)
    
    local codeInput = EditText(activity)
    codeInput.setHint("Paste your code here...")
    codeInput.setHintTextColor(Color.parseColor("#FF607D8B"))
    codeInput.setTextColor(Color.WHITE)
    codeInput.setBackgroundColor(Color.parseColor("#FF37474F"))
    codeInput.setPadding(15, 15, 15, 15)
    codeInput.setTextSize(13)
    codeInput.setMinHeight(200)
    codeInput.setGravity(Gravity.TOP)
    codeInput.setFocusable(true)
    codeInput.setFocusableInTouchMode(true)
    codeInput.setHorizontallyScrolling(false)
    layout.addView(codeInput)

    local spacer3 = TextView(activity)
    spacer3.setHeight(10)
    layout.addView(spacer3)

    local settingsLayout = LinearLayout(activity)
    settingsLayout.setOrientation(LinearLayout.HORIZONTAL)
    settingsLayout.setGravity(Gravity.CENTER)
    
    local privateLabel = TextView(activity)
    privateLabel.setText("Private:")
    privateLabel.setTextColor(Color.parseColor("#FFB0BEC5"))
    privateLabel.setTextSize(13)
    settingsLayout.addView(privateLabel)
    
    local privateInput = EditText(activity)
    privateInput.setText("1")
    privateInput.setTextColor(Color.WHITE)
    privateInput.setBackgroundColor(Color.parseColor("#FF37474F"))
    privateInput.setPadding(10, 5, 10, 5)
    privateInput.setTextSize(13)
    privateInput.setWidth(60)
    privateInput.setSingleLine(true)
    privateInput.setFocusable(true)
    privateInput.setFocusableInTouchMode(true)
    settingsLayout.addView(privateInput)
    
    local spacer4 = TextView(activity)
    spacer4.setWidth(15)
    settingsLayout.addView(spacer4)
    
    local expireLabel = TextView(activity)
    expireLabel.setText("Expire:")
    expireLabel.setTextColor(Color.parseColor("#FFB0BEC5"))
    expireLabel.setTextSize(13)
    settingsLayout.addView(expireLabel)
    
    local expireInput = EditText(activity)
    expireInput.setText("1D")
    expireInput.setTextColor(Color.WHITE)
    expireInput.setBackgroundColor(Color.parseColor("#FF37474F"))
    expireInput.setPadding(10, 5, 10, 5)
    expireInput.setTextSize(13)
    expireInput.setWidth(80)
    expireInput.setSingleLine(true)
    expireInput.setFocusable(true)
    expireInput.setFocusableInTouchMode(true)
    settingsLayout.addView(expireInput)
    
    layout.addView(settingsLayout)

    local expireInfo = TextView(activity)
    expireInfo.setText("N=Never | 10M=10Min | 1H=1Hour | 1D=1Day | 1W=1Week | 2W=2Weeks | 1M=1Month | 6M=6Months | 1Y=1Year")
    expireInfo.setTextColor(Color.parseColor("#FF607D8B"))
    expireInfo.setTextSize(10)
    expireInfo.setPadding(0, 5, 0, 10)
    layout.addView(expireInfo)

    local spacer5 = TextView(activity)
    spacer5.setHeight(15)
    layout.addView(spacer5)

    local uploadButton = Button(activity)
    uploadButton.setText("UPLOAD TO PASTEBIN")
    uploadButton.setTextColor(Color.WHITE)
    uploadButton.setBackgroundColor(Color.parseColor("#FF4CAF50"))
    uploadButton.setPadding(20, 15, 20, 15)
    uploadButton.setTextSize(14)
    uploadButton.setAllCaps(false)
    layout.addView(uploadButton)

    local spacer6 = TextView(activity)
    spacer6.setHeight(15)
    layout.addView(spacer6)

    local responseLabel = TextView(activity)
    responseLabel.setText("RESPONSE:")
    responseLabel.setTextColor(Color.parseColor("#FFFFEB3B"))
    responseLabel.setTextSize(14)
    layout.addView(responseLabel)
    
    local responseArea = TextView(activity)
    responseArea.setText("Waiting for upload...")
    responseArea.setTextColor(Color.parseColor("#FFB0BEC5"))
    responseArea.setBackgroundColor(Color.parseColor("#FF263238"))
    responseArea.setPadding(15, 15, 15, 15)
    responseArea.setTextSize(12)
    responseArea.setMinHeight(100)
    layout.addView(responseArea)

    local spacer7 = TextView(activity)
    spacer7.setHeight(15)
    layout.addView(spacer7)

    local actionLayout = LinearLayout(activity)
    actionLayout.setOrientation(LinearLayout.HORIZONTAL)
    actionLayout.setGravity(Gravity.CENTER)
    
    local clearButton = Button(activity)
    clearButton.setText("CLEAR")
    clearButton.setTextColor(Color.WHITE)
    clearButton.setBackgroundColor(Color.parseColor("#FFFF6600"))
    clearButton.setPadding(15, 10, 15, 10)
    clearButton.setTextSize(13)
    clearButton.setAllCaps(false)
    actionLayout.addView(clearButton)
    
    local spacerBtn = TextView(activity)
    spacerBtn.setWidth(10)
    actionLayout.addView(spacerBtn)
    
    local closeButton = Button(activity)
    closeButton.setText("CLOSE")
    closeButton.setTextColor(Color.WHITE)
    closeButton.setBackgroundColor(Color.parseColor("#FFFF1744"))
    closeButton.setPadding(15, 10, 15, 10)
    closeButton.setTextSize(13)
    closeButton.setAllCaps(false)
    actionLayout.addView(closeButton)
    
    layout.addView(actionLayout)
    
    scrollView.addView(layout)
    
    local wm = activity.getWindowManager()
    wm.addView(scrollView, windowParams)
    
    local function showKeyboard(view)
        local imm = activity.getSystemService(Context.INPUT_METHOD_SERVICE)
        imm.showSoftInput(view, InputMethodManager.SHOW_IMPLICIT)
    end

    local function hideKeyboard(view)
        local imm = activity.getSystemService(Context.INPUT_METHOD_SERVICE)
        imm.hideSoftInputFromWindow(view.getWindowToken(), 0)
    end
    
    local function doUpload()
        local apiKey = apiInput.getText().toString()
        local pasteName = nameInput.getText().toString()
        local pasteContent = codeInput.getText().toString()
        local privateValue = privateInput.getText().toString()
        local expireValue = expireInput.getText().toString()
        
        if apiKey == "" or apiKey == "your_api_key_here" then
            gg.toast("Please enter your Pastebin API Key!\n\nGet it at: https://pastebin.com/doc_api")
            return
        end
        
        if pasteContent == "" then
            gg.toast("Enter the code to upload!")
            return
        end
        
        if pasteName == "" then
            pasteName = "MyPaste"
        end
        
        if privateValue == "" then
            privateValue = "1"
        end
        
        if expireValue == "" then
            expireValue = "1D"
        end
        
        hideKeyboard(codeInput)
        
        responseArea.setText("Uploading to Pastebin...")
        responseArea.setTextColor(Color.parseColor("#FFFFEB3B"))
        
        local requestNet = RequestNetwork.new(activity)
        
        local headers = HashMap()
        headers.put("User-Agent", "LuaPasteUploader/1.0")
        headers.put("Content-Type", "application/x-www-form-urlencoded")
        requestNet:setHeaders(headers)
        
        local paramsMap = HashMap()
        paramsMap.put("api_option", "paste")
        paramsMap.put("api_dev_key", apiKey)
        paramsMap.put("api_paste_code", pasteContent)
        paramsMap.put("api_paste_name", pasteName)
        paramsMap.put("api_paste_private", privateValue)
        paramsMap.put("api_paste_expire_date", expireValue)
        requestNet:setParams(paramsMap, 1)
        
        requestNet:startRequestNetwork(
            "POST",
            "https://pastebin.com/api/api_post.php",
            "pastebin_upload",
            function(tag, response)
                if response:find("https://pastebin.com/") then
                    responseArea.setText("Upload completed!\n\nURL: " .. response)
                    responseArea.setTextColor(Color.parseColor("#FF4CAF50"))
                    gg.toast("Upload successful!\n\n" .. response)
                    gg.toast("Upload completed!")
copyText(response)
gg.toast("Text copied!")

                else
                    responseArea.setText("Unexpected response:\n" .. response)
                    responseArea.setTextColor(Color.parseColor("#FFFFEB3B"))
                    gg.toast("Response:\n\n" .. response)
                end
            end,
            function(tag, error)
                local errorMsg = tostring(error)
                responseArea.setText("Upload failed:\n" .. errorMsg)
                responseArea.setTextColor(Color.parseColor("#FFFF1744"))
                
                if errorMsg:find("Bad API request") then
                    gg.toast("Error: Invalid API Key!\n\n" .. errorMsg .. "\n\nCheck your API Key!")
                else
                    gg.toast("Upload failed:\n\n" .. errorMsg)
                end
            end
        )
    end

    apiInput.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
        onClick = function(v)
            showKeyboard(v)
        end
    }))
    
    nameInput.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
        onClick = function(v)
            showKeyboard(v)
        end
    }))
    
    codeInput.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
        onClick = function(v)
            showKeyboard(v)
        end
    }))
    
    privateInput.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
        onClick = function(v)
            showKeyboard(v)
        end
    }))
    
    expireInput.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
        onClick = function(v)
            showKeyboard(v)
        end
    }))

    uploadButton.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
        onClick = function(v)
            hideKeyboard(codeInput)
            doUpload()
        end
    }))

    clearButton.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
        onClick = function(v)
            responseArea.setText("Waiting for upload...")
            responseArea.setTextColor(Color.parseColor("#FFB0BEC5"))
            gg.toast("Cleared!")
        end
    }))

    closeButton.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
        onClick = function(v)
            hideKeyboard(codeInput)
            wm.removeView(scrollView)
            gg.toast("Closed!")
        end
    }))

    gg.toast("Pastebin Upload ready!")
end

local function startUI()
    activity.runOnUiThread(
        luajava.createProxy(
            "java.lang.Runnable",
            {
                run = function()
                    createLayout()
                end
            }
        )
    )
end

startUI()