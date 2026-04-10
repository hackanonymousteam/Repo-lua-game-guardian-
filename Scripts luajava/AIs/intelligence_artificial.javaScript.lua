gg.setVisible(false)

local WebView = luajava.bindClass("android.webkit.WebView")
local Handler = luajava.bindClass("android.os.Handler")
local Looper  = luajava.bindClass("android.os.Looper")
local handler = Handler(Looper.getMainLooper())
local webView
local ready = false

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
            window.__AI_RESULT__ = null;

            function askAI(text){
                window.__AI_RESULT__ = null;

                var form = new FormData();
                form.append("text", text);

                fetch("https://bj-tricks-ai.vercel.app/chat", {
                    method: "POST",
                    body: form
                })
                .then(r => r.json())
                .then(d => {
                    window.__AI_RESULT__ = d.result || d.error || "No response";
                })
                .catch(e => {
                    window.__AI_RESULT__ = "Network error";
                });
            }

            function getResult(){
                return window.__AI_RESULT__;
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

        ready = true
    end
})

function askAndWait(question)
    local result = nil

    handler.post({
        run = function()
            webView.evaluateJavascript(
                string.format("askAI(%q)", question),
                nil
            )
        end
    })

    for i = 1, 120 do -- 12 seconds
        handler.post({
            run = function()
                webView.evaluateJavascript("getResult()", {
                    onReceiveValue = function(v)
                        if v and v ~= "null" then
                            result = v
                        end
                    end
                })
            end
        })

        if result then break end
        gg.sleep(100)
    end

    if not result then
        return "Timeout waiting response"
    end

    result = result:gsub('^"(.*)"$', '%1')
    result = result:gsub("\\n", "\n")

    return result
end

gg.sleep(1200)

while true do
    local p = gg.prompt(
        {"Ask your question (empty = exit)"},
        nil,
        {"text"}
    )

    if not p or p[1] == "" then break end

    gg.toast("Thinking...")

    local answer = askAndWait(p[1])

    if #answer > 1800 then
        answer = answer:sub(1,1800) .. "\n\n...(truncated)"
    end

    gg.alert("🤖 AI:\n\n" .. answer)
end

handler.post({
    run = function()
        if webView then webView.destroy() end
    end
})