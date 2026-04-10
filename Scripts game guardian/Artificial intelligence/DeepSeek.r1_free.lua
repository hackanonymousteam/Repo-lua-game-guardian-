local sph = gg.prompt({
    "Temperature [0;2]",
    "Top-p [0;1]",
    "Max Tokens [0;4000]"
}, {1, 1, 100}, {"number", "number", "number"})

if sph == nil then
    return
else
    local temperature = tonumber(sph[1])
    local top_p = tonumber(sph[2])
    local max_tokens = tonumber(sph[3])

    local function extractResponse(content)
        local response = content:match('"content":"(.-)","refusal"')
        if response then
            response = response:gsub('\\"', '"'):gsub("\\n", "\n")
        end
        return response
    end

    local apiKey = "YOUR_API_KEY" -- Your api key
    local url = "https://openrouter.ai/api/v1/chat/completions"
    local chatHistory = ""

    while true do
        
        local chat = gg.prompt({
            "Enter your message (or leave it blank to exit):\n" .. chatHistory,
            
        }, {}, {"text"})

        if chat == nil or chat[1] == "" then
            break
        end

        local userMessage = chat[1]
        chatHistory = chatHistory .. "You: " .. userMessage .. "\n-\n"

        local body = string.format(
            '{"model": "deepseek/deepseek-r1:free", "messages": [{"role": "user", "content": "%s"}], "temperature": %f, "top_p": %f, "max_tokens": %d}',
            userMessage, temperature, top_p, max_tokens
        )

        local headers = {
            ["Authorization"] = "Bearer " .. apiKey,
            ["Content-Type"] = "application/json",
            ["Content-Length"] = tostring(#body)
        }

        local request = gg.makeRequest(url, headers, body, nil, nil, nil, 0)
        if not request or not request.content then
            chatHistory = chatHistory .. "Bot: Erro .\n-\n"
        else
            local reply = extractResponse(request.content)
            if reply and reply ~= "" then
                chatHistory = chatHistory .. "Bot: " .. reply .. "\n-\n"
            else
                chatHistory = chatHistory .. "Bot: [Reply empty]\n-\n"
            end
        end
        
function escreverArquivo(nomeArquivo)
    local file = io.open(nomeArquivo, "w") 
    if file then
        file:write(chatHistory)
        file:close() 
        print("file '" .. nomeArquivo .. "' chat  save in storage/emulated/0/.")
    else
        print("Erro " .. nomeArquivo .. "'.")
    end
end

local nomeDoArquivo = "deepseek_chat.txt"

escreverArquivo(nomeDoArquivo)

    gg.setVisible(true)
end
end