gg.setVisible(true)

-- JSON
local json = nil
if not pcall(function()
    json = load(gg.makeRequest("https://raw.githubusercontent.com/rxi/json.lua/master/json.lua").content)()
end) then
    json = require("json") or print("JSON library unavailable")
    if not json then return end
end

-- CONFIG
local HF_TOKEN = "YOUR_HF_TOKEN"

local API_URL = "https://router.huggingface.co/v1/chat/completions"
local MODEL_URL = "https://router.huggingface.co/v1/models"

-- HISTORY
local messages = {
    {role="system", content="You are a friendly and helpful assistant."}
}

-- MODEL SELECT
function chooseModel()

    gg.toast("Loading models...")

    local headers = {
        ["Authorization"] = "Bearer "..HF_TOKEN
    }

    local r = gg.makeRequest(MODEL_URL, headers)

    if not r or r.code ~= 200 then
        print("Failed loading models")
        os.exit()
    end

    local ok,data = pcall(json.decode, r.content)

    if not ok or not data.data then
        print("Invalid model list")
        os.exit()
    end

    local list = {}
    local ids = {}

    for _,m in ipairs(data.data) do
        if m.providers then
            for _,p in ipairs(m.providers) do
                if p.status == "live" then
                    table.insert(list,m.id)
                    table.insert(ids,m.id)
                    break
                end
            end
        end
    end

    local c = gg.choice(list,nil,"Choose model")

    if not c then os.exit() end

    return ids[c]
end

local MODEL = chooseModel()

print("Using model: "..MODEL)

-- CHAT
function sendMessage(text)

    table.insert(messages,{role="user",content=text})

    local headers = {
        ["Authorization"]="Bearer "..HF_TOKEN,
        ["Content-Type"]="application/json",
        ["Accept"]="application/json"
    }

    local payload = {
        model=MODEL,
        messages=messages,
        max_tokens=512,
        temperature=0.7,
        top_p=0.95,
        stream=false
    }

    gg.toast("Thinking...")

    local r = gg.makeRequest(API_URL,headers,json.encode(payload),"POST")

    if r and r.code==200 then

        local ok,data = pcall(json.decode,r.content)

        if ok and data.choices and data.choices[1] then

            local reply = data.choices[1].message.content

            table.insert(messages,{role="assistant",content=reply})

            return reply
        end

        return "Invalid response"

    else

        local err="Request failed"

        if r then
            err=err.." ("..r.code..")"

            local ok,e = pcall(json.decode,r.content)

            if ok and e and e.error then

                if type(e.error)=="table" then
                    err=err.."\n"..(e.error.message or json.encode(e.error))
                else
                    err=err.."\n"..tostring(e.error)
                end

            else
                err=err.."\n"..tostring(r.content)
            end
        end

        return err
    end
end

-- MENU
function menu()

    local m = gg.choice({
        "Continue conversation",
        "New conversation",
        "View history",
        "Change model",
        "Exit"
    })

    if m==1 then
        return true

    elseif m==2 then

        messages={
            {role="system",content="You are a friendly and helpful assistant."}
        }

        print("New conversation started")
        return true

    elseif m==3 then

        local h="HISTORY\n\n"

        for _,msg in ipairs(messages) do

            local p = msg.role=="user" and "You" or
                      msg.role=="assistant" and "Assistant" or
                      "System"

            h=h..p..": "..msg.content.."\n\n"

            if #h>3000 then
                h=h.."..."
                break
            end
        end

        gg.alert(h)
        return true

    elseif m==4 then

        MODEL=chooseModel()
        print("Model changed to "..MODEL)
        return true

    end

    return false
end

-- MAIN LOOP
while true do

    local input = gg.prompt({"Your message:"},{""},{"text"})

    if not input then break end

    if input[1] and input[1]:match("%S") then

        local reply = sendMessage(input[1])

        while true do

            local a = gg.alert(
                reply,
                "Copy text",
                "New question",
                "Menu"
            )

            if a==1 then

                gg.copyText(reply)
                gg.toast("Copied")

            elseif a==2 then
                break

            elseif a==3 then

                if not menu() then
                    os.exit()
                end

            else
                os.exit()
            end

        end

    end

end

print("Goodbye")