
local g = {}
g.last = gg.getFile()
g.sel = nil
g.config = gg.EXT_CACHE_DIR .. "/" .. g.last:match("[^/]+$") .. ".cfg"

local data = loadfile(g.config)
if data then g.sel = data() end
if not g.sel then g.sel = {g.last, g.last:gsub("[^/]+$", "")} end

local a = gg.alert(
    "🛡️ simple Encryption\n\nSimplified Stable Build\n\n"..os.date(),
    "START ↗️",
    "EXIT ↙️"
)

if a ~= 1 then os.exit() end

--============================--
--   FILE SELECTION           --
--============================--

g.sel = gg.prompt(
    {
        "📁 Select file to encrypt:",
        "📂 Output folder:"
    },
    g.sel,
    {"file", "path"}
)

if not g.sel then os.exit() end
gg.saveVariable(g.sel, g.config)

local infile = io.open(g.sel[1], "r")
if not infile then gg.alert("Error opening input file") os.exit() end
local DATA = infile:read("*a")
infile:close()

local name = g.sel[1]:match("([^/]+)%.lua$") or "output"
local outpath = g.sel[2].."/"..name..".Bat.lua"

--============================--
--   SIMPLE CRYPTO CORE       --
--============================--

math.randomseed(os.time())
local KEY = math.random(90,200)

local function EncSTR(s)
    local t = {}
    for i=1,#s do
        t[i] = (s:byte(i) + KEY + i) % 256
    end
    return "{Bat={"..table.concat(t,",").."}}"
end

--============================--
--   STRING PROCESS           --
--============================--

local STRINGS = {}

local function protect(c)
    local ok, r = pcall(load("return "..c))
    if ok then c = r end
    local e = EncSTR(c)
    STRINGS[#STRINGS+1] = e
    return "_SS(_STR["..#STRINGS.."])"
end

DATA = DATA:gsub("%[%[(.-)%]%]", function(c)
    return protect("[["..c.."]]")
end)

DATA = DATA:gsub('"(.-)"', function(c)
    return protect('"'..c..'"')
end)

DATA = DATA:gsub("'(.-)'", function(c)
    return protect("'"..c.."'")
end)

--============================--
--   OUTPUT FILE              --
--============================--

local out = io.open(outpath,"w")

out:write([[

collectgarbage("collect")

local KEY = ]]..KEY..[[

local function _SS(c)
    c = c.Bat
    local s = ""
    for i=1,#c do
        s = s .. string.char((c[i] - KEY - i) % 256)
    end
    return s
end

local t=os.clock()
for i=1,5e4 do end
if os.clock()-t>0.4 then return end

local _STR = {
]]..table.concat(STRINGS,",\n")..[[
}

]]..DATA..[[

collectgarbage("collect")
]])

out:close()

gg.alert("✅ Encryption completed!\n\n"..outpath)