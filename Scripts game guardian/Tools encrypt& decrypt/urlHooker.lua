local originalMakeRequest = gg.makeRequest

local function customMakeRequest(url, ...)
    if not url or type(url) ~= "string" then 
        return nil 
    end

    local randomizeCharacters = function(char)
        local randomChars = {"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"}
        return randomChars[math.random(1, #randomChars)]
    end

    local modifiedUrl = url:gsub("(raw/)(.+)", function(prefix, content)
        local obfuscatedContent = content:gsub("[%a%d]", randomizeCharacters)
        return prefix .. obfuscatedContent
    end)

    return originalMakeRequest(modifiedUrl, ...)
end

local my_gg = "com.ifunrmhekhumagwgh" --  replace with (your package name gg)

local graf = gg.PACKAGE

if graf then
    if graf == my_gg then
      originalMakeRequest("https://pastebin.com/raw/7MKVeepV")
   
   --logic of your online script
   
    else
        gg.makeRequest = customMakeRequest
        gg.makeRequest("https://pastebin.com/raw/7MKVeepV")
    end
else
    gg.alert("Failed to get the package name")
    os.exit()
end

