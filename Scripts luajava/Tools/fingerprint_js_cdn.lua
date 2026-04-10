gg.setVisible(false)

local options = {

    "FingerprintJS (0.5.3)",
    "ClientJS (0.2.1)"
}

local choice = gg.choice(options, nil, "Select JS CDN")
if not choice then
    gg.alert("Canceled")
    os.exit()
end

local cdnScript = ""
local jsFunction = ""

if choice == 1 then
    
    cdnScript = "https://cdnjs.cloudflare.com/ajax/libs/fingerprintjs/0.5.3/fingerprint.min.js"
    jsFunction = [[
        function process(){
            var fp = new Fingerprint().get();
            return fp.toString();
        }
    ]]
elseif choice == 2 then
    cdnScript = "https://cdnjs.cloudflare.com/ajax/libs/ClientJS/0.2.1/client.min.js"
    jsFunction = [[
        function process(){
            var client = new ClientJS();
            return JSON.stringify({
                browser: client.getBrowser(),
                os: client.getOS(),
                device: client.getDevice(),
                cpu: client.getCPU(),
                language: client.getLanguage()
            });
        }
    ]]
end

local WebView = luajava.bindClass("android.webkit.WebView")
local Handler = luajava.bindClass("android.os.Handler")
local Looper  = luajava.bindClass("android.os.Looper")
local handler = Handler(Looper.getMainLooper())

local webView = nil
local ready = false

handler.post({
    run = function()
        webView = luajava.new(WebView, activity)
        webView.setVisibility(8)

        local settings = webView.getSettings()
        settings.setJavaScriptEnabled(true)
        settings.setDomStorageEnabled(true)
        settings.setAllowFileAccess(true)

        local html = [[
        <html>
        <head>
            <meta charset="UTF-8">
            <script src="]] .. cdnScript .. [["></script>
            <script>
                ]] .. jsFunction .. [[
            </script>
        </head>
        <body></body>
        </html>
        ]]

        webView.loadDataWithBaseURL(
            "https://engine.local/",
            html,
            "text/html",
            "UTF-8",
            nil
        )

        ready = true
    end
})

function jsProcess(callback)
    if not ready or not webView then
        gg.alert("WebView not ready")
        return
    end

    handler.post({
        run = function()
            webView.evaluateJavascript("process()", {
                onReceiveValue = function(result)
                    if callback then
                        callback(result)
                    end
                end
            })
        end
    })
end

gg.sleep(2000)

jsProcess(function(result)
    print("JS RESULT:")
    print(result)
end)

gg.sleep(3000)

handler.post({
    run = function()
        if webView then
            webView.destroy()
            webView = nil
        end
    end
})
