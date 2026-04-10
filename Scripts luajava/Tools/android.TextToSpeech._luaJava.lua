gg.setVisible(false)

import "android.speech.tts.TextToSpeech"
import "java.util.Locale"

local mTextSpeech = nil
local ttsInitialized = false
local ttsQueue = {}  
local isSpeaking = false

function initTTS()
    mTextSpeech = TextToSpeech(activity, TextToSpeech.OnInitListener{
        onInit = function(status)
            if status == TextToSpeech.SUCCESS then
                local result = mTextSpeech.setLanguage(Locale.ENGLISH)
                if result == TextToSpeech.LANG_MISSING_DATA or result == TextToSpeech.LANG_NOT_SUPPORTED then
                    mTextSpeech.setLanguage(Locale.getDefault())
                end
                mTextSpeech.setPitch(1.0)
                mTextSpeech.setSpeechRate(0.9)
                ttsInitialized = true
                speakText("Hello everyone")
            else
                ttsInitialized = false
            end
        end
    })
end

function speakText(text)
    if not ttsInitialized or mTextSpeech == nil then
        return
    end
    table.insert(ttsQueue, text)
end

function processTTSQueue()
    if not ttsInitialized or isSpeaking or #ttsQueue == 0 then
        return
    end
    local text = table.remove(ttsQueue, 1)
    isSpeaking = true
    local success = pcall(function()
        mTextSpeech.speak(text, TextToSpeech.QUEUE_FLUSH, nil)
    end)
    if not success then
    end
    local estimatedTime = (#text / 10) * 1000
    if estimatedTime < 1000 then estimatedTime = 1000 end
    gg.sleep(estimatedTime)
    isSpeaking = false
end

function stopAllSpeech()
    if mTextSpeech and ttsInitialized then
        mTextSpeech.stop()
        ttsQueue = {}
        isSpeaking = false
    end
end

function onHackActivated()
    speakText("Speed hack activated successfully")
    speakText("Game modified")
end

function onMenuToggle(isOpen)
    if isOpen then
        speakText("Menu opened")
    else
        speakText("Menu closed")
    end
end

function onError(errorMsg)
    speakText("Error detected: " .. errorMsg)
end

function onStatusUpdate(status)
    speakText("Status: " .. status)
end

initTTS()

for i = 1, 50 do
    gg.sleep(50)
    if ttsInitialized then break end
end


local loopCount = 0
local lastGGCheck = os.time()

while true do
    loopCount = loopCount + 1
    processTTSQueue()
    local currentTime = os.time()
    if currentTime - lastGGCheck >= 2 then
        if gg.isVisible(true) then
            gg.setVisible(false)
            speakText("Game Guardian minimized")
        end
        lastGGCheck = currentTime
    end
   -- if loopCount % 200 == 0 then
      --  speakText("Voice system still active")
      --  speakText("Batman Menu working")
  --  end
    gg.sleep(50)
end

stopAllSpeech()

if mTextSpeech then
    mTextSpeech.shutdown()
end