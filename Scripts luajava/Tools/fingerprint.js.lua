gg.setVisible(false)

local WebView = luajava.bindClass("android.webkit.WebView")
local Handler = luajava.bindClass("android.os.Handler")
local Looper  = luajava.bindClass("android.os.Looper")
local handler = Handler(Looper.getMainLooper())
local webView

--------------------------------------------------
-- Simple hash (DJB2)
--------------------------------------------------
function hash_djb2(str)
    local hash = 5381
    for i = 1, #str do
        hash = ((hash << 5) + hash) + str:byte(i)
        hash = hash & 0xFFFFFFFF
    end
    return string.format("%08x", hash)
end

--------------------------------------------------
-- WebView Init
--------------------------------------------------
handler.post({
    run = function()
        webView = luajava.new(WebView, activity)
        webView.setVisibility(8)

        local s = webView.getSettings()
        s.setJavaScriptEnabled(true)
        s.setDomStorageEnabled(true)
        s.setAllowFileAccess(true)

        local html = [[
        <html><head><meta charset="UTF-8">
        <script>
            window.__FP__ = null;

            function canvasFP(){
                try{
                    var c = document.createElement("canvas");
                    var ctx = c.getContext("2d");
                    ctx.font = "14px Arial";
                    ctx.fillText("BatmanGames", 2, 2);
                    return c.toDataURL();
                }catch(e){ return ""; }
            }

            function webglFP(){
                try{
                    var c = document.createElement("canvas");
                    var gl = c.getContext("webgl") || c.getContext("experimental-webgl");
                    var d = gl.getExtension("WEBGL_debug_renderer_info");
                    return d
                        ? gl.getParameter(d.UNMASKED_VENDOR_WEBGL) + "|" +
                          gl.getParameter(d.UNMASKED_RENDERER_WEBGL)
                        : "";
                }catch(e){ return ""; }
            }

            window.onload = function(){
                var fp = [
                    navigator.userAgent,
                    navigator.platform,
                    navigator.language,
                    navigator.hardwareConcurrency,
                    screen.width + "x" + screen.height,
                    new Date().getTimezoneOffset(),
                    canvasFP(),
                    webglFP()
                ].join("||");

                window.__FP__ = fp;
            };

            function getFP(){
                return window.__FP__;
            }
        </script>
        </head><body></body></html>
        ]]

        webView.loadDataWithBaseURL(
            "https://engine.local/",
            html,
            "text/html",
            "UTF-8",
            nil
        )
    end
})

--------------------------------------------------
-- Wait FP + Generate ID
--------------------------------------------------
gg.sleep(1500)

local fp_raw = nil

for i = 1, 80 do
    handler.post({
        run = function()
            webView.evaluateJavascript("getFP()", {
                onReceiveValue = function(v)
                    if v and v ~= "null" and v ~= "\"null\"" then
                        fp_raw = v
                    end
                end
            })
        end
    })

    if fp_raw then break end
    gg.sleep(100)
end

if not fp_raw then
    gg.alert("Failed to generate device ID")
else
    fp_raw = fp_raw:gsub('^"(.*)"$', '%1')
    fp_raw = fp_raw:gsub('\\"', '"')

    local device_id = hash_djb2(fp_raw)
    gg.alert("📱 DEVICE ID:\n\n" .. device_id)
end

handler.post({
    run = function()
        if webView then webView.destroy() end
    end
})

