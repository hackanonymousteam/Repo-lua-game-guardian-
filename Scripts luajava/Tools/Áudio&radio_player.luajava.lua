gg.setVisible(false)

local WebView = luajava.bindClass("android.webkit.WebView")
local Handler = luajava.bindClass("android.os.Handler")
local Looper  = luajava.bindClass("android.os.Looper")

local handler = Handler(Looper.getMainLooper())

if _G.GG_AUDIO_WEBVIEW == nil then
    _G.GG_AUDIO_WEBVIEW = {}
end

local webView = _G.GG_AUDIO_WEBVIEW.instance

local music_list = {
    {"Canon in D - Pachelbel", "http://www.archive.org/download/CanonInD_261/CanoninD.mp3"},
 --   {"Jailhouse Rock - Elvis Presley", "https://archive.org/download/78_jailhouse-rock_elvis-presley-jerry-leiber-mike-stoller_gbia0080595b/Jailhouse%20Rock%20-%20Elvis%20Presley%20-%20Jerry%20Leiber-restored.mp3"},
 --   {"Smooth Criminal - Michael Jackson", "https://archive.org/download/J._Period_and_Michael_Jackson_-_Man_Or_The_Music-2010/17%20Smooth%20Criminal.mp3"},
  --  {"Y.M.C.A - Village People", "https://archive.org/download/OldPop_256/VillagePeople-Y.m.c.a.mp3"},
    {"Take Me Home, Country Roads - John Denver", "https://archive.org/download/TakeMeHomeCountryRoad/JohnDenver-TakeMeHomeCountryRoad.mp3"}
}

local radio_list = {
    {"Radio Paradise 320 mp3", "http://stream.radioparadise.com/mp3-320"},
    {"Radio Paradise AAC 320", "http://stream.radioparadise.com/aac-320"},
    {"Chillhop Lofi 128", "https://streams.fluxfm.de/Chillhop/mp3-128/streams.fluxfm.de/"},
    {"Afrika Radyo", "http://afrikaradyo.com:8000/listen.mp3"},
    {"SomaFM Live AAC 128", "http://ice6.somafm.com/live-128-aac"},
    {"KEXP Rock/Indie 128", "https://kexp-mp3-128.streamguys1.com/kexp128.mp3"}
}

if webView == nil then
    handler.post({
        run = function()
            webView = luajava.new(WebView, activity)
            webView.setVisibility(8)

            local s = webView.getSettings()
            s.setJavaScriptEnabled(true)
            s.setMediaPlaybackRequiresUserGesture(false)

            local html = [[
            <html><body>
            <audio id="player" autoplay></audio>
            <script>
                var audio = document.getElementById("player");
                window.control = {
                    play: function(url){
                        audio.src = url;
                        audio.load();
                        audio.play();
                    },
                    stop: function(){
                        audio.pause();
                    },
                    volume: function(v){
                        audio.volume = v;
                    }
                };
            </script>
            </body></html>
            ]]

            webView.loadDataWithBaseURL(nil, html, "text/html", "UTF-8", nil)

            _G.GG_AUDIO_WEBVIEW.instance = webView
        end
    })

    gg.sleep(1000)

    handler.post({
        run = function()
            webView.evaluateJavascript('control.play("'..radio_list[1][2]..'");', nil)
        end
    })
end

while true do
    local menu = gg.choice({
        "Select Track",
        "Radio Player",
        "Volume",
        "Stop",
        "Exit"
    }, nil, "Audio Player")

    if menu == 1 then
        local names = {}
        for i,v in ipairs(music_list) do names[i] = v[1] end
        local pick = gg.choice(names, nil, "Choose Track")
        if pick then
            handler.post({run=function()
                webView.evaluateJavascript('control.play("'..music_list[pick][2]..'");', nil)
            end})
        end

    elseif menu == 2 then
        local radios = {}
        for i,v in ipairs(radio_list) do radios[i] = v[1] end
        local rpick = gg.choice(radios, nil, "Choose Radio")
        if rpick then
            handler.post({run=function()
                webView.evaluateJavascript('control.play("'..radio_list[rpick][2]..'");', nil)
            end})
        end

    elseif menu == 3 then
        local vol = gg.prompt({
            "\nSelect volume [0;100]"
        }, {"100"}, {"number"})

        if vol then
            local v = tonumber(vol[1])
            if v then
                if v < 0 then v = 0 end
                if v > 100 then v = 100 end
                v = math.floor(v / 10) * 10
                local formatted = string.format("%.1f", v)
                local jsVolume = tonumber(formatted) / 100
                handler.post({run=function()
                    webView.evaluateJavascript("control.volume(" .. jsVolume .. ");", nil)
                end})
            end
        end

    elseif menu == 4 then
        handler.post({run=function()
            webView.evaluateJavascript("control.stop();", nil)
        end})

    else
        break
    end
end