ChineseTable = {
    ["a"] = "爱", ["b"] = "比", ["c"] = "才", ["d"] = "的", ["e"] = "额",
    ["f"] = "非", ["g"] = "给", ["h"] = "好", ["i"] = "一", ["j"] = "见",
    ["k"] = "可", ["l"] = "了", ["m"] = "么", ["n"] = "你", ["o"] = "哦",
    ["p"] = "平", ["q"] = "去", ["r"] = "人", ["s"] = "是", ["t"] = "天",
    ["u"] = "有", ["v"] = "微", ["w"] = "我", ["x"] = "心", ["y"] = "也",
    ["z"] = "在", ["1"] = "一", ["2"] = "二", ["3"] = "三", ["4"] = "四",
    ["5"] = "五", ["6"] = "六", ["7"] = "七", ["8"] = "八", ["9"] = "九",
    ["0"] = "零", ["-"] = "-", [" "] = " ",
}

reverseChineseTable = {}
for k, v in pairs(ChineseTable) do
    reverseChineseTable[v] = k
end

function encodeToEmoji(key)
    local emojiEncoded = ""
    for i = 1, #key do
        local char = key:sub(i, i)
        emojiEncoded = emojiEncoded .. (ChineseTable[char] or char)
    end
    return emojiEncoded
end

function decodeFromEmoji(emojiKey)
    local decoded = ""
    local i = 1
    while i <= #emojiKey do
        local char = emojiKey:sub(i, i)
        local matchedChar = reverseChineseTable[char]
        if matchedChar then
            decoded = decoded .. matchedChar
        else
            local found = false
            for length = 2, 4 do
                if i + length - 1 <= #emojiKey then
                    local emojiChar = emojiKey:sub(i, i + length - 1)
                    local match = reverseChineseTable[emojiChar]
                    if match then
                        decoded = decoded .. match
                        i = i + length - 1
                        found = true
                        break
                    end
                end
            end
            if not found then
                decoded = decoded .. char
            end
        end
        i = i + 1
    end
    return decoded
end

local substitutionTable = {
    ["a"] = "z", ["b"] = "y", ["c"] = "x", ["d"] = "w", ["e"] = "v",
    ["f"] = "u", ["g"] = "t", ["h"] = "s", ["i"] = "r", ["j"] = "q",
    ["k"] = "p", ["l"] = "o", ["m"] = "n", ["n"] = "m", ["o"] = "l",
    ["p"] = "k", ["q"] = "j", ["r"] = "i", ["s"] = "h", ["t"] = "g",
    ["u"] = "f", ["v"] = "e", ["w"] = "d", ["x"] = "c", ["y"] = "b",
    ["z"] = "a", [" "] = "_", ["\n"] = "|",
    ["_"] = " ", ["|"] = "\n"
}

function customEncode(data)
    local encoded = ""
    for i = 1, #data do
        local char = data:sub(i, i)
        encoded = encoded .. (substitutionTable[char] or char)
    end
    return encoded
end

function customDecode(encodedData)
    local decoded = ""
    for i = 1, #encodedData do
        local char = encodedData:sub(i, i)
        decoded = decoded .. (substitutionTable[char] or char)
    end
    return decoded
end

local shifts = {}
for i = 1, 20 do
    shifts[i] = i
end

local function wrapAround(code)
    return (code % 256)
end

function encodeLayer(input, shift)
    local result = {}
    for i = 1, #input do
        local char = input:sub(i, i)
        local code = string.byte(char)
        local newCode = wrapAround(code + shift)
        table.insert(result, string.char(newCode))
    end
    return table.concat(result)
end

function decodeLayer(input, shift)
    local result = {}
    for i = 1, #input do
        local char = input:sub(i, i)
        local code = string.byte(char)
        local newCode = wrapAround(code - shift)
        table.insert(result, string.char(newCode))
    end
    return table.concat(result)
end

function encode(input)
    local encoded = input
    for i = 1, #shifts do
        encoded = encodeLayer(encoded, shifts[i])
    end
    return encoded
end

function decode(input)
    local decoded = input
    for i = #shifts, 1, -1 do
        decoded = decodeLayer(decoded, shifts[i])
    end
    return decoded
end

local b64_chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

function base64_encode(data)
    local result = {}
    local padding = (3 - (#data % 3)) % 3
    local padded_data = data .. string.rep("\0", padding)
    for i = 1, #padded_data, 3 do
        local b1 = padded_data:byte(i) or 0
        local b2 = padded_data:byte(i + 1) or 0
        local b3 = padded_data:byte(i + 2) or 0
        local v = (b1 << 16) + (b2 << 8) + b3
        result[#result + 1] = b64_chars:sub(((v >> 18) & 0x3F) + 1, ((v >> 18) & 0x3F) + 1)
        result[#result + 1] = b64_chars:sub(((v >> 12) & 0x3F) + 1, ((v >> 12) & 0x3F) + 1)
        result[#result + 1] = b64_chars:sub(((v >> 6) & 0x3F) + 1, ((v >> 6) & 0x3F) + 1)
        result[#result + 1] = b64_chars:sub((v & 0x3F) + 1, (v & 0x3F) + 1)
    end
    if padding > 0 then
        result[#result] = "="
        if padding == 2 then
            result[#result - 1] = "="
        end
    end
    return table.concat(result)
end

local b64_table = {}
for i = 1, #b64_chars do
    b64_table[b64_chars:sub(i, i)] = i - 1
end

function base64_decode(data)
    local result = {}
    local padding = 0
    if data:sub(-1) == "=" then
        padding = 1
        data = data:sub(1, -2)
        if data:sub(-1) == "=" then
            padding = 2
            data = data:sub(1, -2)
        end
    end
    for i = 1, #data, 4 do
        local a = b64_table[data:sub(i, i)] or 0
        local b = b64_table[data:sub(i + 1, i + 1)] or 0
        local c = b64_table[data:sub(i + 2, i + 2)] or 0
        local d = b64_table[data:sub(i + 3, i + 3)] or 0
        local v = (a << 18) + (b << 12) + (c << 6) + d
        result[#result + 1] = string.char((v >> 16) & 0xFF)
        if i + 2 <= #data then
            result[#result + 1] = string.char((v >> 8) & 0xFF)
        end
        if i + 3 <= #data then
            result[#result + 1] = string.char(v & 0xFF)
        end
    end
    return table.concat(result):sub(1, -padding)
end

function menuu()
    local setdate = gg.choice({"1Day", "2Days", "3Days", "4Days", "5Days", "7Days", "14Days", "30Days", "1Year", "2Years"}, nil, "Mgubs")
    
    if setdate == nil then
        menuu()
    else
        _G.currentMonth = tonumber(os.date("%m"))
        _G.currentDay = tonumber(os.date("%d"))
        _G.currentYear = tonumber(os.date("%y"))
        
        local dayss = 0
        local months = 0
        local years = 0
        
        if setdate == 1 then
            dayss = 1
        elseif setdate == 2 then
            dayss = 2
        elseif setdate == 3 then
            dayss = 3
        elseif setdate == 4 then
            dayss = 4
        elseif setdate == 5 then
            dayss = 5
        elseif setdate == 6 then
            dayss = 7
        elseif setdate == 7 then
            dayss = 14
        elseif setdate == 8 then
            dayss = 30
        elseif setdate == 9 then
            years = 1
        elseif setdate == 10 then
            years = 2
        end
        
        local ulok3 = _G.currentDay + dayss
        local ulok4 = _G.currentMonth + months
        local ulok5 = _G.currentYear + years
        
        local expiration = "y" .. ulok5 .. "/" .. ulok4 .. "/" .. ulok3
        local passwordb = expiration
        
        local customEncodedPassword = customEncode(password)
        local shiftEncodedPassword = encode(customEncodedPassword)
        local base64EncodedPassword = base64_encode(shiftEncodedPassword)
        local two = encodeToEmoji(base64EncodedPassword)
        
        local aaa = customEncode(passwordb)
        local bbb = encode(aaa)
        local ccc = base64_encode(bbb)
        local ddd = encodeToEmoji(ccc)
        
        gg.copyText(two .. "&" .. ddd)
    end
end

function generateRandomPassword()
    local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    local length = 9
    local password = ""
    
    math.randomseed(os.time())
    
    for i = 1, length do
        local index = math.random(1, #chars)
        password = password .. chars:sub(index, index)
    end
    
    return password .. "onee"
end

running=true
TEMPLATE=1

function home()
    local test = gg.prompt(
        {
            "Enter Code", 
        }, 
        nil, 
        {"text"}
    )
    
    if test == nil then
    else
        password = test[1]
        menuu()
    end
end

home()