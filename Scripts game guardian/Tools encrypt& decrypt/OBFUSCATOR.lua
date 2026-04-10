local cfg = gg.EXT_CACHE_DIR .. "/obf_safe.cfg"
local last = gg.getFile()
local sel = nil

local data = loadfile(cfg)
if data then sel = data() end
if not sel then
    sel = { last, last:gsub("[^/]+$", "") }
end

local ok = gg.alert(
    "🛡️ OBFUSCATOR LUAJ SAFE\n\n"..os.date(),
    "START",
    "EXIT"
)
if ok ~= 1 then os.exit() end

sel = gg.prompt(
    { "📁 LUA FILE:", "📂 SAVE TO:" },
    sel,
    { "file", "path" }
)
if not sel then os.exit() end
gg.saveVariable(sel, cfg)

local f = io.open(sel[1], "r")
if not f then gg.alert("ERROR OPENING FILE") os.exit() end
local DATA = f:read("*a")
f:close()

local name = sel[1]:match("([^/]+)%.lua$") or "output"
local outpath = sel[2] .. "/" .. name .. ".obf.lua"

math.randomseed(os.time())
local KEY = math.random(80,200)

local STRINGS = {}
local IDX = 0

local function encrypt(s)
    local t = {}
    for i=1,#s do
        t[i] = (s:byte(i) + KEY + i) % 256
    end
    return t
end

local function protectStrings(code)
    code = code:gsub('"(.-)"', function(s)
        IDX = IDX + 1
        STRINGS[IDX] = encrypt(s)
        return "_S("..IDX..")"
    end)
    code = code:gsub("'(.-)'", function(s)
        IDX = IDX + 1
        STRINGS[IDX] = encrypt(s)
        return "_S("..IDX..")"
    end)
    return code
end

local function generateJunkVars()
    local junk = {}
    local count = math.random(10, 30)
    for i = 1, count do
        local varName = "_j"..math.random(1000,9999)
        local value = math.random(1,999)
        table.insert(junk, "local "..varName.."="..value)
    end
    return table.concat(junk, "\n")
end

local function generateJunkFuncs()
    local funcs = {}
    local count = math.random(3, 8)
    for i = 1, count do
        local funcName = "_f"..math.random(1000,9999)
        local lines = {}
        table.insert(lines, "local function "..funcName.."()")
        local lineCount = math.random(2, 5)
        for j = 1, lineCount do
            table.insert(lines, "  local a"..j.."="..math.random(1,999))
        end
        table.insert(lines, "  return "..math.random(1,999))
        table.insert(lines, "end")
        table.insert(funcs, table.concat(lines, "\n"))
    end
    return table.concat(funcs, "\n\n")
end

local function removeComments(code)
    code = code:gsub("%-%-[^\n]*", "")
    while code:find("%-%-%[%[.-%]%]%-%-") do
        code = code:gsub("%-%-%[%[.-%]%]%-%-", "")
    end
    while code:find("%-%-%[%[.-%]%]") do
        code = code:gsub("%-%-%[%[.-%]%]", "")
    end
    return code
end

DATA = removeComments(DATA)
DATA = protectStrings(DATA)

local final = [[
local KEY=]]..KEY..[[

local _STR={
]]

for i=1,#STRINGS do
    final = final .. "{"..table.concat(STRINGS[i],",").."},\n"
end

final = final .. [[
}

local function _S(i)
    local t=_STR[i]
    local s=""
    for n=1,#t do
        s=s..string.char((t[n]-KEY-n)%256)
    end
    return s
end

]]..generateJunkVars()..[[

]]..generateJunkFuncs()..[[

]]..DATA

local out = io.open(outpath, "w")
if out then
    out:write(final)
    out:close()
    gg.alert(
        "✅ COMPLETED\n\n"..
        "📁 File: "..outpath.."\n"..
        "🔐 Strings: "..#STRINGS.."\n"..
        "🗝️ Key: "..KEY.."\n"..
        "🗑️ Junk variables added"
    )
else
    gg.alert("❌ ERROR SAVING FILE!")
end