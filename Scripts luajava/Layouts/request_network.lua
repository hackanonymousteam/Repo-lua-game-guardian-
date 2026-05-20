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
local Thread = bind("java.lang.Thread")
local Handler = bind("android.os.Handler")
local Looper = bind("android.os.Looper")

local function getType()
    if Build.VERSION.SDK_INT >= 26 then
        return 2038
    elseif Build.VERSION.SDK_INT >= 23 then
        return 2002
    else
        return 2003
    end
end

local params = luajava.newInstance(
    "android.view.WindowManager$LayoutParams",
    -2,
    -2,
    getType(),
    0x00000008,
    PixelFormat.TRANSLUCENT
)

params.gravity = Gravity.TOP + Gravity.LEFT
params.x = 10
params.y = 100

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
    Thread(function()
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
            
            if method == "POST" then
                connection.setRequestProperty("Content-Type", "application/x-www-form-urlencoded")
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
                    postData.append(tostring(key))
                    postData.append("=")
                    postData.append(tostring(value))
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
            
            local reader = BufferedReader(InputStreamReader(inputStream))
            local response = StringBuilder()
            local line = ""
            
            while true do
                line = reader.readLine()
                if line == nil then break end
                response.append(line)
            end
            
            reader.close()
            connection.disconnect()
            
            return response.toString()
        end)
        
        local handler = Handler(Looper.getMainLooper())
        if success then
            handler.post(function()
                responseCallback(tag, result)
            end)
        else
            handler.post(function()
                errorCallback(tag, tostring(result))
            end)
        end
    end).start()
end

local function createLayout()
    local requestNetwork = RequestNetwork.new(activity)
    
    local layout = LinearLayout(activity)
    layout.setOrientation(LinearLayout.VERTICAL)
    layout.setBackgroundColor(Color.parseColor("#FF1A1A1A"))
    layout.setPadding(20, 20, 20, 20)

    local titleView = TextView(activity)
    titleView.setText("HTTP REQUEST")
    titleView.setTextColor(Color.parseColor("#FF00E5FF"))
    titleView.setTextSize(18)
    titleView.setPadding(10, 10, 10, 20)
    titleView.setGravity(Gravity.CENTER)
    layout.addView(titleView)

    local urlLabel = TextView(activity)
    urlLabel.setText("URL:")
    urlLabel.setTextColor(Color.parseColor("#FFB0BEC5"))
    urlLabel.setTextSize(14)
    layout.addView(urlLabel)
    
    local urlInput = EditText(activity)
    urlInput.setHint("https://api.example.com/data")
    urlInput.setHintTextColor(Color.parseColor("#FF607D8B"))
    urlInput.setTextColor(Color.WHITE)
    urlInput.setBackgroundColor(Color.parseColor("#FF37474F"))
    urlInput.setPadding(15, 10, 15, 10)
    urlInput.setTextSize(14)
    urlInput.setSingleLine(true)
    urlInput.setText("https://httpbin.org/get")
    layout.addView(urlInput)

    local spacer1 = TextView(activity)
    spacer1.setHeight(10)
    layout.addView(spacer1)

    local methodLayout = LinearLayout(activity)
    methodLayout.setOrientation(LinearLayout.HORIZONTAL)
    methodLayout.setGravity(Gravity.CENTER)
    
    local getButton = Button(activity)
    getButton.setText("GET")
    getButton.setTextColor(Color.WHITE)
    getButton.setBackgroundColor(Color.parseColor("#FF4CAF50"))
    getButton.setPadding(20, 10, 20, 10)
    getButton.setTextSize(14)
    methodLayout.addView(getButton)
    
    local spacerBtn1 = TextView(activity)
    spacerBtn1.setWidth(10)
    methodLayout.addView(spacerBtn1)
    
    local postButton = Button(activity)
    postButton.setText("POST")
    postButton.setTextColor(Color.WHITE)
    postButton.setBackgroundColor(Color.parseColor("#FF2196F3"))
    postButton.setPadding(20, 10, 20, 10)
    postButton.setTextSize(14)
    methodLayout.addView(postButton)
    
    layout.addView(methodLayout)

    local spacer2 = TextView(activity)
    spacer2.setHeight(15)
    layout.addView(spacer2)

    local responseLabel = TextView(activity)
    responseLabel.setText("RESPONSE:")
    responseLabel.setTextColor(Color.parseColor("#FFFFEB3B"))
    responseLabel.setTextSize(14)
    layout.addView(responseLabel)
    
    local responseArea = TextView(activity)
    responseArea.setText("Waiting for request...")
    responseArea.setTextColor(Color.parseColor("#FFB0BEC5"))
    responseArea.setBackgroundColor(Color.parseColor("#FF263238"))
    responseArea.setPadding(15, 15, 15, 15)
    responseArea.setTextSize(12)
    responseArea.setMinHeight(200)
    layout.addView(responseArea)

    local spacer3 = TextView(activity)
    spacer3.setHeight(15)
    layout.addView(spacer3)

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
    
    local spacerBtn2 = TextView(activity)
    spacerBtn2.setWidth(10)
    actionLayout.addView(spacerBtn2)
    
    local closeButton = Button(activity)
    closeButton.setText("CLOSE")
    closeButton.setTextColor(Color.WHITE)
    closeButton.setBackgroundColor(Color.parseColor("#FFFF1744"))
    closeButton.setPadding(15, 10, 15, 10)
    closeButton.setTextSize(13)
    closeButton.setAllCaps(false)
    actionLayout.addView(closeButton)
    
    layout.addView(actionLayout)
    
    local function makeRequest(method)
        local url = urlInput.getText().toString()
        
        if url == "" then
            gg.toast("Enter a URL!")
            return
        end
        
        responseArea.setText("Loading...")
        responseArea.setTextColor(Color.parseColor("#FFFFEB3B"))
        
        local requestNet = RequestNetwork.new(activity)
        
        local headers = HashMap()
        headers.put("User-Agent", "GameGuardian/1.0")
        headers.put("Accept", "application/json")
        requestNet:setHeaders(headers)
        
        if method == "POST" then
            local paramsMap = HashMap()
            paramsMap.put("name", "GameGuardian")
            paramsMap.put("version", "1.0")
            paramsMap.put("type", "test")
            requestNet:setParams(paramsMap, 1)
        end
        
        requestNet:startRequestNetwork(
            method,
            url,
            "request_tag",
            function(tag, response)
                responseArea.setText(response)
                responseArea.setTextColor(Color.parseColor("#FF4CAF50"))
                gg.toast("Request completed!")
            end,
            function(tag, message)
                responseArea.setText("Error: " .. message)
                responseArea.setTextColor(Color.parseColor("#FFFF1744"))
                gg.toast("Request failed")
            end
        )
    end
    
    local wm = activity.getWindowManager()
    wm.addView(layout, params)

    getButton.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
        onClick = function(v)
            urlInput.setText("https://httpbin.org/get")
            makeRequest("GET")
        end
    }))

    postButton.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
        onClick = function(v)
            urlInput.setText("https://httpbin.org/post")
            makeRequest("POST")
        end
    }))

    clearButton.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
        onClick = function(v)
            responseArea.setText("Waiting for request...")
            responseArea.setTextColor(Color.parseColor("#FFB0BEC5"))
            gg.toast("Cleared!")
        end
    }))

    closeButton.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
        onClick = function(v)
            wm.removeView(layout)
            gg.toast("Closed!")
        end
    }))

    gg.toast("HTTP Request ready!")
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