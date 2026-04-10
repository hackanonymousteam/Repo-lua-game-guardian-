g = {}
g.last = "/sdcard/"
g.info = nil
g.config = gg.EXT_CACHE_DIR .. "/" .. gg.getFile():match("[^/]+$") .. "cfg"
g.data = loadfile(g.config)
if g.data ~= nil then
  g.info = g.data()
  g.data = nil
end
if g.info == nil then
  g.info = { g.last }
end
gg.alert("Select file libunity.so")
g.info = gg.prompt({ '📂 Select file libunity.so:' }, g.info, { 'file' })
if g.info == nil then return end

local myFile = g.info[1]
gg.saveVariable(g.info, g.config)
g.last = myFile

local file = io.open(g.last, "rb")
if not file then
  gg.alert("❌ Error opening file.")
  return
end

local hexPatterns = {
    {
        hex = "A4707D3F3ACD133F0AD7233CBD378635",
        searchByte = "BD",
        name = "blacksky"
    },
    {
        hex = "F08FBDE86F12833A",
        searchByte = "6F",
        name = "setalphacolor"
    },
    {
        patterns = {
            "F088BDE80000B443DB0F4940",
            "7080BDE80000B443DB0F4940",
            "0000B443DB0F4940"
        },
        searchByte = "00",
        name = "camera"
    },
    {
        hex = "F304353F5E836C3F15EFC33E",
        searchByte = "F3",
        name = "sound"
    },
    {
        hex = "32EE442A",
        searchByte = "2A",
        name = "flyHack",
        postCheck = {
            offset = 16,
            pattern = "ACC52737"
        }
    },
    {
        hex = "DDE300BF",
        searchByte = "BF",
        name = "wallhack",
        postCheck = {
            offset = 4,
            pattern = "BD378635"
        }
    }
}

local function hexToPattern(hex)
    return hex:gsub("..", function(byte)
        return string.char(tonumber(byte, 16))
    end)
end

file:seek("set", 0)
local fullContent = file:read("*a")
file:close()

local output = {
    "// ============================================",
    "// UnityEngine Internal Engine Class Dump",
    "// by Batman Games ",
    "// ============================================",
    "",
    "// Namespace: UnityEngine",
    "internal class HexPatterns",
    "{",
    "\t// Fields"
}

local alertResults = {}
local hexResults = {}

for _, patternInfo in ipairs(hexPatterns) do
    local foundOffset = nil
    
    if patternInfo.hex then
        local pattern = hexToPattern(patternInfo.hex)
        local startPos = fullContent:find(pattern, 1, true)
        if startPos then
            local searchByte = string.char(tonumber(patternInfo.searchByte, 16))
            local bytePos = fullContent:find(searchByte, startPos, true)
            if bytePos then
                if patternInfo.postCheck then
                    local postOffset = bytePos + patternInfo.postCheck.offset
                    local postPattern = hexToPattern(patternInfo.postCheck.pattern)
                    if fullContent:find(postPattern, postOffset, true) then
                        foundOffset = bytePos - 1
                    end
                else
                    foundOffset = bytePos - 1
                end
            end
        end
    elseif patternInfo.patterns then
        for _, hex in ipairs(patternInfo.patterns) do
            local pattern = hexToPattern(hex)
            local startPos = fullContent:find(pattern, 1, true)
            if startPos then
                local searchByte = string.char(tonumber(patternInfo.searchByte, 16))
                local bytePos = fullContent:find(searchByte, startPos, true)
                if bytePos then
                    foundOffset = bytePos - 1
                    break
                end
            end
        end
    end
    
    if foundOffset then
        table.insert(output, string.format("\tpublic const float %s = 0x%X;", patternInfo.name:upper(), foundOffset))
        table.insert(alertResults, string.format("%s: 0x%X", patternInfo.name, foundOffset))
        hexResults[patternInfo.name] = foundOffset
    end
end

table.insert(output, "}")

local outPath = "/sdcard/unity_hex_patterns.txt"
local outFile = io.open(outPath, "w")

for _, line in ipairs(output) do
    outFile:write(line .. "\n")
end

outFile:close()

local alertMessage = "✅ Hex patterns found:\n\n"
for name, offset in pairs(hexResults) do
    alertMessage = alertMessage .. string.format("%s: 0x%X\n", name, offset)
end
alertMessage = alertMessage .. "\nSaved to: " .. outPath

gg.alert(alertMessage)
