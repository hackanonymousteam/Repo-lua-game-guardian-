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

context = activity
window = context.getSystemService('window')
resourceDirectory = gg.EXT_CACHE_DIR 

local mistralApiKey = "YOUR_API_KEY"  
local mistralModel = "mistral-small-latest"

local json = nil
if not pcall(function()
    json = load(gg.makeRequest("https://raw.githubusercontent.com/rxi/json.lua/master/json.lua").content)()
end) then
    json = require("json") or gg.alert("❌ JSON library not available")
    if not json then return end
end

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
        promptBackgroundColor = '#FF121212',
        promptCardBackgroundColor = '#FF1E1E1E',
        promptButtonTextColor = '0xFFFFFFFF',
        promptButtonTextStyle = 'bold',
        promptButtonTextSize = '16sp',
        promptButtonColor = '#FF03DAC6',
        promptEditTextTextColor = '0xFFFFFFFF',
        promptEditTextTextStyle = 'normal',
        promptEditTextTextSize = '16sp',
        promptEditTextColor = '#FF2C2C2C',
        promptFont = resourceDirectory .. '/UbuntuAwesome.ttf',
    },
    

    sendToMistral = function(question)
        local resultText = ""
        
        local success, errorMsg = pcall(function()
            
            local payload = {
                model = mistralModel,
                messages = {
                    {
                        role = "system",
                        content = "You are a helpful AI assistant. Respond in the user's language."
                    },
                    {
                        role = "user",
                        content = question
                    }
                },
                max_tokens = 500,
                temperature = 0.7
            }
            
           
            local jsonPayload = json.encode(payload)
            
           
            local headers = {
                ["Content-Type"] = "application/json",
                ["Authorization"] = "Bearer " .. mistralApiKey,
                ["Accept"] = "application/json"
            }
            
            
            local response = gg.makeRequest(
                "https://api.mistral.ai/v1/chat/completions",
                headers,
                jsonPayload,
                "POST"
            )
            
            if type(response) == "table" then
                if response.code == 200 then
                    
                    if response.content and response.content:trim() ~= "" then
                        local responseData = json.decode(response.content)
                        
                        if responseData and responseData.choices and #responseData.choices > 0 then
                            local botResponse = responseData.choices[1].message.content
                            resultText = botResponse
                        else
                            resultText = "Resposta inválida da API Mistral"
                            if responseData and responseData.error then
                                resultText = resultText .. "\nErro: " .. tostring(responseData.error.message)
                            end
                        end
                    else
                        resultText = "Resposta vazia da API"
                    end
                else
                    resultText = "Erro HTTP: " .. tostring(response.code)
                    if response.content then
                        local errorData = json.decode(response.content)
                        if errorData and errorData.error then
                            resultText = resultText .. "\n" .. tostring(errorData.error.message)
                        else
                            resultText = resultText .. "\n" .. tostring(response.content)
                        end
                    end
                end
            else
                resultText = "reply invalid"
            end
        end)
        
        if not success then
            resultText = "Erro: " .. tostring(errorMsg)
        end
        
        return resultText
    end,
    
    
    showResponse = function(responseText)
        activity.runOnUiThread(function()
            bcUI.buildPromptResponse(
                responseText,
                "Mistral AI Response",
                "Model: " .. mistralModel
            )
        end)
    end,
    
   buildPromptResponse = function(responseText, headerText, footerText)
        local DialogWidth = 340
        
        
        local responseLayout = {
            CardView,
            radius = '8dp',
            cardElevation = '8dp',
            layout_width = DialogWidth .. 'dp',
            layout_height = 'wrap_content',
            cardBackgroundColor = bcUI.settings.promptBackgroundColor,
            {
                LinearLayout,
                layout_width = 'match_parent',
                layout_height = 'wrap_content',
                orientation = 'vertical',
                padding = '20dp',
                {
                    TextView,
                    layout_width = 'match_parent',
                    layout_height = 'wrap_content',
                    text = headerText,
                    textSize = bcUI.settings.promptHeaderTextSize,
                    textStyle = bcUI.settings.promptHeaderTextStyle,
                    textColor = bcUI.settings.promptHeaderTextColor,
                    gravity = 'center',
                    layout_marginBottom = '15dp'
                },
                {
                    ScrollView,
                    layout_width = 'match_parent',
                    layout_height = '300dp',
                    layout_marginBottom = '15dp',
                    {
                        TextView,
                        layout_width = 'match_parent',
                        layout_height = 'wrap_content',
                        id = 'response_text',
                        text = responseText,
                        textSize = '14sp',
                        textColor = '0xFFFFFFFF',
                        padding = '10dp',
                        background = [[<?xml version="1.0" encoding="utf-8"?>
                            <shape xmlns:android="http://schemas.android.com/apk/res/android">
                            <solid android:color="#FF333333"/>
                            <corners android:radius="8dp"/>
                            </shape>]]
                    }
                },
                {
                    LinearLayout,
                    layout_width = 'match_parent',
                    layout_height = 'wrap_content',
                    orientation = 'horizontal',
                    gravity = 'center',
                    {
                        Button,
                        layout_width = '150dp',
                        layout_height = 'wrap_content',
                        id = 'btn_new_question',
                        text = 'New ask',
                        textSize = bcUI.settings.promptButtonTextSize,
                        textColor = bcUI.settings.promptButtonTextColor,
                        background = [[<?xml version="1.0" encoding="utf-8"?>
                            <shape xmlns:android="http://schemas.android.com/apk/res/android">
                            <solid android:color="]] .. bcUI.settings.promptButtonColor .. [["/>
                            <corners android:radius="8dp"/>
                            </shape>]],
                        layout_marginRight = '10dp'
                    },
                    {
                        Button,
                        layout_width = '150dp',
                        layout_height = 'wrap_content',
                        id = 'btn_close',
                        text = 'Close',
                        textSize = bcUI.settings.promptButtonTextSize,
                        textColor = bcUI.settings.promptButtonTextColor,
                        background = [[<?xml version="1.0" encoding="utf-8"?>
                            <shape xmlns:android="http://schemas.android.com/apk/res/android">
                            <solid android:color="#FF666666"/>
                            <corners android:radius="8dp"/>
                            </shape>]]
                    }
                },
                {
                    TextView,
                    layout_width = 'match_parent',
                    layout_height = 'wrap_content',
                    text = footerText,
                    textSize = bcUI.settings.promptFooterTextSize,
                    textStyle = bcUI.settings.promptFooterTextStyle,
                    textColor = bcUI.settings.promptFooterTextColor,
                    gravity = 'center',
                    layout_marginTop = '15dp'
                }
            }
        }
        
       
        responseLayout = loadlayout(responseLayout)
        
      
        _G.btn_new_question.onClick = function()
            window.removeView(responseLayout)
            home()
        end
        
        _G.btn_close.onClick = function()
            window.removeView(responseLayout)
            bcUI.exit()
        end
        
        
        local LayoutParams = WindowManager.LayoutParams
        local layoutParams = luajava.new(LayoutParams)
        if Build.VERSION.SDK_INT >= 26 then
            layoutParams.type = LayoutParams.TYPE_APPLICATION_OVERLAY
        else
            layoutParams.type = LayoutParams.TYPE_PHONE
        end
        layoutParams.format = PixelFormat.RGBA_8888
        layoutParams.flags = bit32.bor(LayoutParams.FLAG_NOT_TOUCH_MODAL, LayoutParams.FLAG_LAYOUT_IN_SCREEN)
        layoutParams.gravity = Gravity.CENTER
        layoutParams.width = LayoutParams.WRAP_CONTENT
        layoutParams.height = LayoutParams.WRAP_CONTENT
        
        
        window.addView(responseLayout, layoutParams)
    end,
    
   
    buildPrompt = function(menuItems, itemValues, itemTypes, headerText, footerText, dialogWidth, dialogHeight, callback)
       
        activity.runOnUiThread(function()
            local DialogWidth = dialogWidth or bcUI.settings.promptWidth
            if type(DialogWidth) == "string" then
                DialogWidth = DialogWidth:gsub("dp","")
            else
                DialogWidth = 340
            end
            
           
            local promptLayout = {
                CardView,
                radius = '8dp',
                cardElevation = '8dp',
                layout_width = DialogWidth .. 'dp',
                layout_height = 'wrap_content',
                cardBackgroundColor = bcUI.settings.promptBackgroundColor,
                {
                    LinearLayout,
                    layout_width = 'match_parent',
                    layout_height = 'wrap_content',
                    orientation = 'vertical',
                    padding = '20dp',
                    {
                        TextView,
                        layout_width = 'match_parent',
                        layout_height = 'wrap_content',
                        text = headerText,
                        textSize = bcUI.settings.promptHeaderTextSize,
                        textStyle = bcUI.settings.promptHeaderTextStyle,
                        textColor = bcUI.settings.promptHeaderTextColor,
                        gravity = 'center',
                        layout_marginBottom = '15dp'
                    },
                    {
                        TextView,
                        layout_width = 'match_parent',
                        layout_height = 'wrap_content',
                        text = 'API: Mistral AI',
                        textSize = '12sp',
                        textColor = '0xFF03DAC6',
                        gravity = 'center',
                        layout_marginBottom = '10dp'
                    },
                    {
                        EditText,
                        layout_width = 'match_parent',
                        layout_height = 'wrap_content',
                        id = 'question_input',
                        hint = 'Ask your question...',
                        textSize = bcUI.settings.promptEditTextTextSize,
                        textColor = bcUI.settings.promptEditTextTextColor,
                        background = [[<?xml version="1.0" encoding="utf-8"?>
                            <shape xmlns:android="http://schemas.android.com/apk/res/android">
                            <solid android:color="]] .. bcUI.settings.promptEditTextColor .. [["/>
                            <corners android:radius="8dp"/>
                            </shape>]],
                        padding = '10dp',
                        layout_marginBottom = '10dp'
                    },
                    {
                        LinearLayout,
                        layout_width = 'match_parent',
                        layout_height = 'wrap_content',
                        orientation = 'horizontal',
                        gravity = 'center',
                        {
                            Button,
                            layout_width = '150dp',
                            layout_height = 'wrap_content',
                            id = 'btn_ok',
                            text = 'Send',
                            textSize = bcUI.settings.promptButtonTextSize,
                            textColor = bcUI.settings.promptButtonTextColor,
                            background = [[<?xml version="1.0" encoding="utf-8"?>
                                <shape xmlns:android="http://schemas.android.com/apk/res/android">
                                <solid android:color="]] .. bcUI.settings.promptButtonColor .. [["/>
                                <corners android:radius="8dp"/>
                                </shape>]],
                            layout_marginRight = '10dp'
                        },
                        {
                            Button,
                            layout_width = '150dp',
                            layout_height = 'wrap_content',
                            id = 'btn_cancel',
                            text = 'Cancel',
                            textSize = bcUI.settings.promptButtonTextSize,
                            textColor = bcUI.settings.promptButtonTextColor,
                            background = [[<?xml version="1.0" encoding="utf-8"?>
                                <shape xmlns:android="http://schemas.android.com/apk/res/android">
                                <solid android:color="#FF666666"/>
                                <corners android:radius="8dp"/>
                                </shape>]]
                        }
                    },
                    {
                        TextView,
                        layout_width = 'match_parent',
                        layout_height = 'wrap_content',
                        text = footerText,
                        textSize = bcUI.settings.promptFooterTextSize,
                        textStyle = bcUI.settings.promptFooterTextStyle,
                        textColor = bcUI.settings.promptFooterTextColor,
                        gravity = 'center',
                        layout_marginTop = '15dp'
                    }
                }
            }
            

            promptLayout = loadlayout(promptLayout)
            
  local isProcessing = false
            
           
            _G.btn_ok.onClick = function(view)
                if isProcessing then
                    return
                end
                
                isProcessing = true
                _G.btn_ok.setEnabled(false)
                _G.btn_ok.setText("wait...")
                
                local question = _G.question_input.getText().toString()
                if question and question:trim() ~= "" then

                    thread(function()
                        local response = bcUI.sendToMistral(question)
                        

                        activity.runOnUiThread(function()
                           
                            _G.btn_ok.setEnabled(true)
                            _G.btn_ok.setText("send")
                            isProcessing = false
                            

                            window.removeView(promptLayout)
                            
                          
                            bcUI.showResponse(response)
                            
                            --print(response)
                        end)
                    end)
                else
                    
                    _G.btn_ok.setEnabled(true)
                    _G.btn_ok.setText("send")
                    isProcessing = false
                    
                end
            end
            
            _G.btn_cancel.onClick = function()
                window.removeView(promptLayout)
                bcUI.exit()
            end
            

            local LayoutParams = WindowManager.LayoutParams
            local layoutParams = luajava.new(LayoutParams)
            if Build.VERSION.SDK_INT >= 26 then
                layoutParams.type = LayoutParams.TYPE_APPLICATION_OVERLAY
            else
                layoutParams.type = LayoutParams.TYPE_PHONE
            end
            layoutParams.format = PixelFormat.RGBA_8888
            layoutParams.flags = bit32.bor(LayoutParams.FLAG_NOT_TOUCH_MODAL, LayoutParams.FLAG_LAYOUT_IN_SCREEN)
            layoutParams.gravity = Gravity.CENTER
            layoutParams.width = LayoutParams.WRAP_CONTENT
            layoutParams.height = LayoutParams.WRAP_CONTENT
            
           
            window.addView(promptLayout, layoutParams)
        end)
    end,

    
    testConnection = function()
        local payload = {
            model = mistralModel,
            messages = {
                {
                    role = "user",
                    content = "Hello"
                }
            },
            max_tokens = 10
        }
        
        local headers = {
            ["Content-Type"] = "application/json",
            ["Authorization"] = "Bearer " .. mistralApiKey,
            ["Accept"] = "application/json"
        }
        
        local success, result = pcall(function()
            local response = gg.makeRequest(
                "https://api.mistral.ai/v1/chat/completions",
                headers,
                json.encode(payload),
                "POST"
            )
            
            if type(response) == "table" then
                if response.code == 200 then
                    return true
                else
                    return false, "code HTTP: " .. response.code
                end
            end
            return false, "Reply invalid"
        end)
        
        return success and result == true
    end,
    
    exit = function()
        activity.stopFunc()
        activity:finish()
        os.exit()
    end
}

function home()
    bcUI.buildPrompt(
        {"Ask"},
        {""},
        {"text"},
        "Mistral AI Assistant",
        "API: mistral.ai | Model: " .. mistralModel,
        "340dp",
        nil,
        function(choices)
           
        end
    )
end
        home()
    