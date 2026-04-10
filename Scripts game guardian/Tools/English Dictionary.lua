gg.setVisible(true)

local json = nil
if not pcall(function()
    json = load(gg.makeRequest("https://raw.githubusercontent.com/rxi/json.lua/master/json.lua").content)()
end) then
    json = require("json")
    if not json then
        gg.alert("JSON library not available")
        return
    end
end

function urlencode(str)
    if str then
        str = string.gsub(str, "\n", "\r\n")
        str = string.gsub(str, "([^%w %-%_%.%~])",
            function(c) return string.format("%%%02X", string.byte(c)) end)
        str = string.gsub(str, " ", "%%20")
    end
    return str
end

function saveFile(data, filename)
    local path = "/sdcard/" .. filename
    local file = io.open(path, "wb")
    if file then
        file:write(data)
        file:close()
        return path
    end
    return nil
end

function download(url)
    local res = gg.makeRequest(url)
    if res and res.content then
        return res.content
    end
    return nil
end

function searchDictionary()
    local input = gg.prompt({"Enter English word:"}, {}, {"text"})
    if not input or not input[1] or input[1] == "" then
        gg.alert("Empty or cancelled")
        return
    end

    local word = urlencode(input[1])
    local url = "https://api.dictionaryapi.dev/api/v2/entries/en/" .. word

    gg.toast("Searching dictionary...")

    local response = gg.makeRequest(url)
    if not response or not response.content then
        gg.alert("Connection error")
        return
    end

    local ok, data = pcall(json.decode, response.content)
    if not ok then
        gg.alert("Word not found")
        return
    end

    local result = ""
    for i, entry in ipairs(data) do
        result = result .. "Word: " .. (entry.word or "") .. "\n"
        result = result .. "Phonetic: " .. (entry.phonetic or "") .. "\n\n"

        if entry.meanings then
            for _, meaning in ipairs(entry.meanings) do
                result = result .. "[" .. meaning.partOfSpeech .. "]\n"
                for _, def in ipairs(meaning.definitions) do
                    result = result .. "- " .. def.definition .. "\n"
                    if def.example then
                        result = result .. "  Example: " .. def.example .. "\n"
                    end
                end
                result = result .. "\n"
            end
        end
        result = result .. "----------------------\n\n"
    end

    if #result > 3000 then
        if gg.alert("Result too long. Save file?", "Yes", "No") == 1 then
            local path = saveFile(result, "dictionary_" .. os.time() .. ".txt")
            if path then
                gg.alert("Saved:\n" .. path)
            end
        else
            gg.alert(string.sub(result,1,3000) .. "...")
        end
    else
        gg.alert(result)
    end
end

function main()
    local menu = gg.choice({
        "📖 English Dictionary"
        "❌ Exit"
    }, nil, "Select Option")

    if not menu or menu == 3 then return end

    if menu == 1 then
        searchDictionary()
    elseif menu == 2 then
        os.exit()
    end
end

main()