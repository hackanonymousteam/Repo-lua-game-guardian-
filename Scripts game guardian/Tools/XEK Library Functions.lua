XEK = {
    ['Text2Dword'] = function(str)
        local bytes = {}
        local separator = ''
        
        for i = 1, #str do 
            bytes[#bytes+1] = string.byte(str, i, i)
            if #str % 2 ~= 0 and i == #str then 
                bytes[#bytes+1] = 0 
            end
        end

        local final = ''
        
        for i = 2, #bytes, 2 do 
            separator = (i == #bytes) and '::'..#str+4 or ';'
            final = final..(bytes[i-1] + bytes[i] * 2^16)..separator
        end

        return final:gsub('.0', '')
    end,

    ['Dword2Text'] = function(val)
        local str = ''
        for num in val:gmatch('(%d+)%p') do
            local char2, char1 = math.modf(tonumber(num)/(2^16))
            char1 = math.floor(char1 * 2^16)
            if char2 == 0 then 
                str = str..string.char(char1) 
                break 
            end
            str = str..string.char(char1)..string.char(char2)
        end
        return str
    end,

    ['hex'] = function(val, hx)
        local val1 = string.format('%08X', val):sub(1,8)
        local val2 = tostring(val1)
        if hx == true then 
            return '0x'..val2 
        elseif hx == false then
            return val2..'h'
        else 
            return val2
        end
    end,

    ['dump'] = function(tab)
        if type(tab) == 'table' then
            local s = '{ '
            for k, v in pairs(tab) do
                if type(k) ~= 'number' then k = '"'..k..'"' end
                s = s..'['..k..'] = '..XEK.dump(v)..','
            end
            return s..'} '
        else
            return tostring(tab)
        end
    end,

    ['split'] = function(s, delimiter)
        local result = {}
        for match in (s..delimiter):gmatch("(.-)"..delimiter) do
            table.insert(result, match)
        end
        return result
    end,

    ['ARMIT'] = function(value, type, aarch) 
        aarch = aarch or false
        local instructions = {}
        local mov = aarch and {'K','Z'} or {'W','T'}
        local syntaxGG = aarch and '~A8' or '~A'
        local type = type or (math.type(value) == 'integer') and 'int' or 'f'
        
        if type == 'int' then
            local maxInt = not aarch and 0xFFFFFFFF or 0xFFFFFFFFFFFFFFFF
            local hexStr = string.format("%X", value)
            if value < 0 and value >= -maxInt then 
                value = maxInt + value + 1
                hexStr = string.format("%X", value)
            else
                hexStr = string.format(aarch and "%016X" or "%08X", value)
            end
            value = hexStr
        elseif type == 'f' or type == 'd' then
            local binary = string.pack(type, value)
            local hex = ""
            for i = 1, #binary do
                hex = hex..string.format("%02X", string.byte(binary:reverse(), i))
            end
            value = hex
        elseif type == 'bool' then
            value = (not value) and '0' or '1'
        end

        local decimalValue = tonumber(value,16)
        local hexSize = (decimalValue >= -0x80 and decimalValue <= 0xFF) and 1
                or (decimalValue >= -0x8000 and decimalValue <= 0xFFFF) and 2
                or (decimalValue >= -0x80000000 and decimalValue <= 0xFFFFFFFF) and 4
                or (decimalValue >= -0x8000000000000000 and decimalValue <= 0x7FFFFFFFFFFFFFFF) and 8
                or print("Value out of range")

        local reg = (aarch and hexSize == 8) and 'X' or (aarch and hexSize == 4) and 'W' or 'R'
        
        if hexSize == 1 then
            instructions[#instructions+1] = string.format("%s MOV %s%d, #0x%s", syntaxGG, reg, 0, string.format('%X', tonumber(value,16)))
        elseif hexSize == 2 then
            instructions[#instructions+1] = string.format("%s MOV%s %s%d, #0x%s", syntaxGG, mov[1], reg, 0, string.format('%X', tonumber(value,16)))
        elseif hexSize == 4 then 
            if aarch then 
                instructions[#instructions+1] = string.format("%s MOV%s %s%d, #0x%s, LSL #16", syntaxGG, mov[1], reg, 0, string.format('%04X', tonumber('0x'..value) & 0xFFFF))
                instructions[#instructions+1] = string.format("%s MOV%s %s%d, #0x%s, LSL #32", syntaxGG, mov[1], reg, 0, string.format('%04X', tonumber('0x'..value) >> 16 & 0xFFFF))
            else
                instructions[#instructions+1] = string.format("%s MOV%s %s%d, #0x%s", syntaxGG, mov[1], reg, 0, string.format('%04X', tonumber('0x'..value) & 0xFFFF))
                instructions[#instructions+1] = string.format("%s MOV%s %s%d, #0x%s", syntaxGG, mov[2], reg, 0, string.format('%04X', tonumber('0x'..value) >> 16 & 0xFFFF))
            end
        end

        instructions[#instructions+1] = aarch and '~A8 RET' or '~A BX LR'
        return instructions
    end,

    ['readBytes'] = function(addr, size)
        local values = {}
        for i = 0, size - 1 do
            values[#values+1] = {address = addr + i, flags = gg.TYPE_BYTE}
        end
        local results = gg.getValues(values)
        local bytes = {}
        for i, res in ipairs(results) do
            if res.value <= 0 then break end
            bytes[#bytes+1] = res.value
        end
        return string.char(table.unpack(bytes))
    end,

    ['getResults'] = function(max, skip, addrMin, addrMax, valMin, valMax, type, frac, ptr)
        local results = {data = {}, original = {}}
        results.data = gg.getResults(max or gg.getResultsCount(), skip or 0, addrMin, addrMax, valMin, valMax, type, frac, ptr)
        
        results.focus = function(self)
            for i, v in ipairs(self.data) do
                self.original[i] = v.value
            end
        end
        
        results.update = function(self, value)
            for i, v in ipairs(self.data) do
                v.value = value
            end
            gg.setValues(self.data)
        end
        
        results.reset = function(self)
            for i, v in ipairs(self.data) do
                v.value = self.original[i]
            end
            gg.setValues(self.data)
        end
        
        return results
    end
}

gg.setVisible(false)

function menu()
    local option = gg.choice({
        "🔣 Text to DWORD",
        "📤 DWORD to Text",
        "📦 Generate ARM Instruction",
        "📚 Read Memory Bytes",
        "❌ Exit"
    }, nil, "XEK Library Functions")

    if option == 1 then
        textToDword()
    elseif option == 2 then
        dwordToText()
    elseif option == 3 then
        generateARM()
    elseif option == 4 then
        readBytes()
    elseif option == 5 or option == nil then
        os.exit()
    end
end

function textToDword()
    local input = gg.prompt({"Text to convert:"}, nil, {"text"})
    if input then
        local result = XEK.Text2Dword(input[1])
        gg.alert("DWORD: " .. result)
    end
end

function dwordToText()
    local input = gg.prompt({"DWORD (ex: 1234;5678::10):"}, nil, {"text"})
    if input then
        local result = XEK.Dword2Text(input[1])
        gg.alert("Text: " .. result)
    end
end

function generateARM()
    local input = gg.prompt({
        "Value (ex: 1337)",
        "Type (int/f/d/bool)",
        "Architecture (true = 64 bits)"
    }, {"1337", "int", "false"}, {"number", "text", "bool"})

    if input then
        local val = tonumber(input[1])
        local typ = input[2]
        local arch = input[3]
        local instructions = XEK.ARMIT(val, typ, arch)
        gg.alert("Instructions:\n\n" .. table.concat(instructions, "\n"))
    end
end

function readBytes()
    local input = gg.prompt({
        "Address (hexadecimal)",
        "Number of bytes"
    }, {"0x12345678", "8"}, {"text", "number"})

    if input then
        local addr = tonumber(input[1])
        local size = tonumber(input[2])
        local bytes = XEK.readBytes(addr, size)
        gg.alert("Read: " .. bytes)
    end
end

while true do
    menu()
end