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
  g.info = { g.last, g.last:gsub("/[^/]+$", "") }
end

while true do
  g.info = gg.prompt({
    ' Select file :', 
    'Select folder  :',
    '🕒 Add date expire offline',
    '🕒 Add login online',
    '🔐 Add password offline',
    '🛡️ Add GG Version',
    '📝 Antirename',
    '🗳 Add package GameGuardian',
    '🎮 Add Package Game',
    '👩 Add Verify Human Mode',
    '🔑 Add login offline ',
    '🕗 block hours day',
    '📟 block months year',
    '📊 block days week',
    '📶 require root to start script',
    '📵 require sdk version Android',
    '📅 check expire date online',
    '📳 require arm 64 bit',
    '📱 block ip device',
    '🗂️ check file size',
    '⛔ restricted country',
    '👀 Antiview'

  }, g.info, {
    'file', 
    'path',
    'checkbox',
    'checkbox',
    'checkbox',
    'checkbox',
    'checkbox',
    'checkbox',
    'checkbox',
    'checkbox',
    'checkbox',
    'checkbox',
    'checkbox',
    'checkbox',
    'checkbox',
    'checkbox',
    'checkbox',
    'checkbox',
    'checkbox',
    'checkbox',
    'checkbox',
    'checkbox'
  }) 
  gg.saveVariable(g.info, g.config)
  g.last = g.info[1]
  if loadfile(g.last) == nil then
    gg.alert("Script not Found!")
    return
  else
    g.out = g.last:match("[^/]+$")
    g.out = g.out:gsub(".lua", "")
    g.out = g.info[2] .. "/" .. g.out .. ".lua"
     checkk= g.out:match("^.+/(.+)$")
    
     local file, err = io.open(g.out, "r")  
if  file then
    os.remove(g.out)
    file:close()  
end
end

  local file = io.open(g.last, "r")
  local DATA = file:read('*a')
  file:close()

    if g.info[3] == true then
        local day = os.date("%d")
        exp_date = gg.prompt({
        "📆 Set Expired Date : ",
        "📝 Type Expired Message : "
    }, {os.date("%Y%m" .. day), "⚠️ Script Expired ⚠️️"}, {"number", "text"})
end
if not exp_date then
    gg.setVisible(true)
elseif exp_date[1] == nil then
    gg.alert("📆 Date Can Not Be Empty !")
    gg.setVisible(true)
else
    print("📅 Added Expired Date : True✔")
    local JJ = ""
        JJ = '\n if os.date("%Y%m%d") >= "' .. exp_date[1] .. '" then print("' .. exp_date[2] .. '") return gg.alert("' .. exp_date[2] .. '") end\n'
    local file = io.open(g.out, "a")
    if file then
        file:write(JJ)
        file:close()
    else
        gg.alert("❌ Error: Could not open file for writing.")
    end
end

    if g.info[4] == true then
    gg.setVisible(true)
    function urlEncode(str)
        return (str:gsub("([^%w])", function(c)
            return string.format("%%%02X", string.byte(c))
        end):gsub(" ", "+"))
    end
    local info = gg.prompt(
    {"User", "pass", "Validity [1;7]"},
    {"", "", "1"},
    {"text", "text","number"}
)
    if not info then os.exit() end
    local user = info[1]
    local pass = info[2]
    local pos  = tonumber(info[3]) or 1
    local expire_days = "1"
    if pos == 1 then expire_days = "1"
    elseif pos == 2 then expire_days = "2"
    elseif pos == 3 then expire_days = "3"
    elseif pos == 4 then expire_days = "4"
    elseif pos == 5 then expire_days = "5"
    elseif pos == 6 then expire_days = "6"
    elseif pos == 7 then expire_days = "7"
    end

    local jsonData = '{"user":"' .. user .. '","pass":"' .. pass .. '"}'

    local headers = {["Content-Type"]="text/plain"}
    local response = gg.makeRequest("https://paste.rs", headers, jsonData)
    if type(response) ~= "table" or not response.content or response.content:find("https://paste.rs/") == nil then
        gg.alert("❌ Error creating paste:\n" .. (response.content or "No reply"))
        os.exit()
    end

    local pasteUrl = response.content
    gg.alert("✅ Data saved!\nLink:\n" .. pasteUrl .. "\nValid for " .. expire_days .. " day(s)")

    local ZZ = '\nlocal CXY = "' .. pasteUrl .. '"\n' ..
               'function online()\n' ..
               'local login = gg.prompt({"Login User","Login Pass"}, {}, {"text","text"})\n' ..
               'if not login then os.exit() end\n' ..
               'local inUser, inPass = login[1], login[2]\n' ..
               'local raw = gg.makeRequest(CXY)\n' ..
               'local ok = false\n' ..
               'if type(raw) == "table" and raw.content then\n' ..
               '  local body = raw.content\n' ..
               '  local savedUser = body:match(\'"user"%s*:%s*"(.-)"\')\n' ..
               '  local savedPass = body:match(\'"pass"%s*:%s*"(.-)"\')\n' ..
               '  if savedUser == inUser and savedPass == inPass then ok = true end\n' ..
               'end\n' ..
               'if ok then\n' ..
               '  gg.alert("✅ Login success!")\n' ..
               'else\n' ..
               '  gg.alert("❌ Wrong user or password")\n' ..
               '  os.exit()\n' ..
               'end\n'..
               'end\n'..
               'online()\n'
               

    local file = io.open(g.out, "a")
    if file then
        file:write(ZZ)
        file:close()
    else
        gg.alert("❌ Error: Could not open file for writing.")
    end
end




if g.info[5] == true then
PASS = gg.prompt({
"🔐 Set Password For Script :",
"📝 Type Message For Wrong Password : "
}, {"","⚠️ Wrong Password, Try Again!!! ⚠️"},{
"text",
"text"})
end--if
if not PASS then
gg.setVisible(true)
elseif PASS[1] == nil then
gg.alert("⚠️ Input Password !")
gg.setVisible(true)
else
print("🔐 Added Password Script : True✔")
KK = '\nlocal CXY = "'.. PASS[1]..'"\nPASSW = gg.prompt({"🔒 Input password: "},{[1]=""},{[1]="text"})\n if not PASSW the﻿n print("'..PASS[2]..'")  return end\n if PASSW[1] == "" then gg.alert("❌Password Can Not Be Empty ❌") os.exit(print("❌Password Can Not Be Empty ❌"))end\n if PASSW[1] ~= CXY then print("'..PASS[2]..'")return end\nif PASSW[1] == CXY then gg.toast("🎉Wellcome🎉")end\n' 

local file = io.open(g.out, "a")
    if file then
        file:write(KK)
        file:close()
    else
        gg.alert("❌ Error: Could not open file for writing.")
end
end

if g.info[6] == true then
VERSION = gg.prompt({
"🔐 Set Minimal GG Version : ",
"🗒️ Set Error GG Message :"
}, {gg.VERSION,"⚠️ Error GG VERSION ⚠️"}, {
"number",
"text"})
end--if
if not VERSION then
gg.setVisible(true)
elseif VERSION[1] == nil then
gg.alert("🛡️ Input Minimal Required GG Version !")
gg.setVisible(true)
else
print("🛡 Minimal Version Required : True✔")
LL = '\nlocal LynX = gg;local Xslow = LynX.VERSION;if Xslow ~= "'..VERSION[1] .. '" then print("'..VERSION[2]..'") return gg.alert("' ..VERSION[2].. '")end\n' 

local file = io.open(g.out, "a")
    if file then
        file:write(LL)
        file:close()
    else
        gg.alert("❌ Error: Could not open file for writing.")
end
end

if g.info[7] == true then
NAME = gg.prompt({
"🗒️ Set Name For Script :",
"📝 Type Message For Name Changed :",
}, {g.out:match("[^/]+$"),
"⚠️ RENAME DETECTED ⚠️"}, {
"text",
"text"})
end
if not NAME then
gg.setVisible(true)
elseif NAME[1] == nil then
gg.alert("📝 Set Name Can Not Be Empty !")
gg.setVisible(true)
else
print("📝 Added Rename Blocker : True✔")
MM = '\nlocal HckUtdProtect = gg.getFile():match("[^/]+$")local tptd =  "'..NAME[1]..'"\nif HckUtdProtect ~= tptd then gg.copyText("'..NAME[1]..'")gg.setVisible(true) print("'..NAME[2]..'") return gg.alert("'..NAME[2].. '")end\n'
local file = io.open(g.out, "a")
    if file then
        file:write(MM)
        file:close()
    else
        gg.alert("❌ Error: Could not open file for writing.")
end
end

if g.info[8] == true then
_Hacks_Unlimited_ = gg.prompt({
"✏️ Set Your Package GameGuardian",
"📝 Type Message If Package Is Wrong :"
}, {"com.GameGuardian.id","⚠ Use MY GG For Run This Script ⚠"},{
"text",
"text"})
end--if
if not _Hacks_Unlimited_ then
gg.setVisible(true)
elseif _Hacks_Unlimited_[1] == nil then
gg.alert("⚠️ Set Package GameGuardian Can Not Bd Empty!")
gg.setVisible(true)
else
print("⚠ SetPeckage GG : True√ ")
NN = '\nif gg.PACKAGE == "' .. _Hacks_Unlimited_[1] .. '" then\nelse\ngg.alert("' .. _Hacks_Unlimited_[2] .. '")\nprint("' .. _Hacks_Unlimited_[2] .. '")\nos.exit()\nend\n' 
local file = io.open(g.out, "a")
    if file then
        file:write(NN)
        file:close()
    else
        gg.alert("❌ Error: Could not open file for writing.")
end
end

if g.info[9] == true then
    _Hacks_Unlimited_g = gg.prompt(
        {
            "✏️ Set Package Game",
            "📝 Type Message If Package Is Wrong :"
        },
        {
            "com.dts.freefireth",
            "⚠ Use Script In Game ⚠"
        },
        {
            "text",
            "text"
        }
    )
end

if not _Hacks_Unlimited_g then
    gg.setVisible(true)
elseif _Hacks_Unlimited_g[1] == nil then
    gg.alert("⚠️ Set Package GameGuardian Can Not Be Empty!")
    gg.setVisible(true)
else
    print("🎮 SetPackage Game : True √")

    local OO = '\nlocal info = gg.getTargetInfo()\n'
        .. 'if info == nil or info.processName ~= "' .. _Hacks_Unlimited_g[1] .. '" then\n'
        .. '    gg.alert("' .. _Hacks_Unlimited_g[2] .. '")\n'
        .. '    os.exit()\n'
        .. 'end\n'

    local file = io.open(g.out, "a")
    if file then
        file:write(OO)
        file:close()
    else
        gg.alert("❌ Error: Could not open file for writing.")
    end
end

if g.info[10] == true then
print("💀 Added Verify Human Mode")
print("")
PP = "local code = math.random(10000, 99999)\nlocal hmn = gg.prompt({'🔒 Input This Code to Verify: '..code..' !'},{[1]=''},{[1]='number'}) if not hmn then os.exit() end if hmn[1]..'1' == code..'1' then gg.toast('☑ Code correct!') else gg.alert('✖ Wrong Code!') os.exit() end\n" 
local file = io.open(g.out, "a")
    if file then
        file:write(PP)
        file:close()
    else
        gg.alert("❌ Error: Could not open file for writing.")
end
end

if g.info[11] == true then
 LOGIN = gg.prompt({ "🕵 Sᴇᴛ Usᴇʀɴᴀᴍᴇ Fᴏʀ Sᴄʀɪᴘᴛ :",
 "🔐 Sᴇᴛ Pᴀssᴡᴏʀᴅ Fᴏʀ Sᴄʀɪᴘᴛ :", 
"📝 Tʏᴘᴇ Mᴇssᴀɢᴇ Fᴏʀ Sᴜᴄᴄᴇs Lᴏɢɪɴ :", }, 
{"Batman", "games","🎉 Sᴜᴄᴄᴇss Lᴏɢɪɴ! 🎉"}, 
{ "text", "text", "text"}) end if not LOGIN then 
gg.setVisible(true) else if LOGIN[1] == '' then gg.alert("⚠️ Usᴇʀɴᴀᴍᴇ Cᴀɴɴᴏᴛ Bᴇ Eᴍᴘᴛʏ! ⚠️") 
gg.setVisible(true) elseif LOGIN[2] == '' then gg.alert("⚠️ Pᴀssᴡᴏʀᴅ Cᴀɴɴᴏᴛ Bᴇ Eᴍᴘᴛʏ! ⚠️") 
gg.setVisible(true) else print("💀 Aᴅᴅᴇᴅ Lᴏɢɪɴ Oғғʟɪɴᴇ! 💀") 
QQ = "\n\nlocal Username = '"..LOGIN[1].."';local Password = '"..LOGIN[2].."'\nlocal LoginScript = gg.prompt({'🕵 Usᴇʀɴᴀᴍᴇ : ','🔐 Pᴀssᴡᴏʀᴅ 🔐 :'},nil,{'text','text'})\nif LoginScript == nil then print('❌ Lᴏɢɪɴ Cᴀɴᴄᴇʟᴇᴅ ❌')return end\nif LoginScript[1] == '' then gg.alert('⚠️ Usᴇʀɴᴀᴍᴇ  Cᴀɴɴᴏᴛ Bᴇ Eᴍᴘᴛʏ! ⚠️') print('⚠️ Usᴇʀɴᴀᴍᴇ  Cᴀɴɴᴏᴛ Bᴇ Eᴍᴘᴛʏ !⚠️')  os.exit() end\nif LoginScript[2] == '' then gg.alert('⚠️ Pᴀssᴡᴏʀᴅ Cᴀɴɴᴏᴛ Bᴇ Eᴍᴘᴛʏ! ⚠️') print('⚠️ Pᴀssᴡᴏʀᴅ Cᴀɴɴᴏᴛ Bᴇ Eᴍᴘᴛʏ! ⚠️') os.exit() end\nif LoginScript[1] ~= Username then gg.alert('❌ Wʀᴏɴɢ Usᴇʀɴᴀᴍᴇ! ❌')return else end\nif LoginScript[2] ~= Password then gg.alert('❌ Wʀᴏɴɢ Pᴀssᴡᴏʀᴅ! ❌')return else end\ngg.sleep(500)gg.toast('"..LOGIN[3].."')\ngg.sleep(500) gg.toast('"..LOGIN[3].."')\n\n"
local file = io.open(g.out, "a")
    if file then
        file:write(QQ)
        file:close()
    else
        gg.alert("❌ Error: Could not open file for writing.")
end
end
end

if g.info[12] == true then
    HOUR = gg.prompt({
        "⏰ Sᴇᴛ Hᴏᴜʀ 1:",
        "⏰ Sᴇᴛ Hᴏᴜʀ 2:",
        "⏰ Sᴇᴛ Hᴏᴜʀ 3:",
    }, {"13", "14", "15"}, {"text", "text", "text"})
end

if not HOUR then 
    gg.setVisible(true) 
else 
    if HOUR[1] == '' then 
        gg.alert("⚠️ Hᴏᴜʀ 1 Cᴀɴɴᴏᴛ Bᴇ Eᴍᴘᴛʏ! ⚠️") 
        gg.setVisible(true) 
    elseif HOUR[2] == '' then 
        gg.alert("⚠️ Hᴏᴜʀ 2 Cᴀɴɴᴏᴛ Bᴇ Eᴍᴘᴛʏ! ⚠️") 
        gg.setVisible(true) 
    elseif HOUR[3] == '' then 
        gg.alert("⚠️ Hᴏᴜʀ 3 Cᴀɴɴᴏᴛ Bᴇ Eᴍᴘᴛʏ! ⚠️") 
        gg.setVisible(true) 
    else 
        
        local hora1 = HOUR[1]
        local hora2 = HOUR[2]
        local hora3 = HOUR[3]

        local RR = [[
local block_hour_day = {
    ["]] .. hora1 .. [["] = true,
    ["]] .. hora2 .. [["] = true,
    ["]] .. hora3 .. [["] = true,
}

local function verify(pais)
    return block_hour_day[pais]
end

local hour = os.date('%H')
if hour then
    if verify(hour) then
        gg.alert(" sᴄʀɪᴘᴛ ɴᴏᴡ ᴡᴏʀᴋ ᴛʜɪs ʜᴏᴜʀ")
        os.exit()
    else
        
    end
else
    gg.alert("❌ Fᴀɪʟᴇd ᴛᴏ ɢᴇᴛ hᴏᴜʀ")
    os.exit()
end
]]
        local file = io.open(g.out, "a")
        if file then
            file:write(RR)
            file:close()
            
        else
            gg.alert("❌ Error: Could not open file for writing.")
        end
    end
    end

if g.info[13] == true then
    monther = gg.prompt({
        "⏰ Mᴏɴᴛʜ 1 (Jan):",
        "⏰ Mᴏɴᴛʜ 2 (Feb):",
        "⏰ Mᴏɴᴛʜ 3 (Mar):",
        "⏰ Mᴏɴᴛʜ 4 (Apr):",
        "⏰ Mᴏɴᴛʜ 5 (May):",
        "⏰ Mᴏɴᴛʜ 6 (Jun):",
        "⏰ Mᴏɴᴛʜ 7 (Jul):",
        "⏰ Mᴏɴᴛʜ 8 (Aug):",
        "⏰ Mᴏɴᴛʜ 9 (Sep):",
        "⏰ Mᴏɴᴛʜ 10 (Oct):",
        "⏰ Mᴏɴᴛʜ 11 (Nov):",
        "⏰ Mᴏɴᴛʜ 12 (Dec):"
    }, {false, false, false, false, false, false, false, false, false, false, false, false}, {"checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox"})
end

if not monther then 
    gg.setVisible(true) 
else 
    local selected_months = {}
    for i = 1, 12 do
        if monther[i] then
            table.insert(selected_months, i)  
        end
    end

    if #selected_months == 0 then
        gg.alert("⚠️ empty! ⚠️")
        gg.setVisible(true)
        return
    end

    print("✅ : ", table.concat(selected_months, ", "))
   
    local months = {
        "Jan", "Feb", "Mar", "Apr", "May", "Jun", 
        "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    }   
    local SS = "local block_month_year = {\n"
    for _, month_index in ipairs(selected_months) do
        SS = SS .. string.format('    ["%s"] = true,\n', months[month_index])
    end
    SS = SS .. "}\n\n"   
    SS = SS .. [[
local function verify(month)
    return block_month_year[month]
end

local month = os.date('%b')
if month then
    if verify(month) then
        gg.alert("Mᴏɴᴛʜ ɪɴᴄᴏʀʀᴇᴛ, sᴄʀɪᴘᴛ ɴᴏᴡ ᴡᴏʀᴋ ᴛʜɪs ᴍᴏɴᴛʜ")
        os.exit()
    else
        print("✅ Sᴜᴄᴄᴇss")
    end
else
    gg.alert("❌ Fᴀɪʟᴇd ᴛᴏ ɢᴇᴛ mᴏɴᴛʜ")
    os.exit()
end
]]
    local file = io.open(g.out, "a") 
    if file then
        file:write(SS)
        file:close()
    else
        gg.alert("❌ Erro: Não foi possível abrir o arquivo para escrita.")
    end
end


if g.info[14] == true then
    DAYY = gg.prompt({
        "⏰ Day 1 (Mon):",
        "⏰ Day 2 (Tue):",
        "⏰ Day 3 (Wed):",
        "⏰ Day 4 (Thu):",
        "⏰ Day 5 (Fri):",
        "⏰ Day 6 (Sat):",
        "⏰ Day 7 (Sun):"
    }, {false, false, false, false, false, false, false}, {"checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox"})
end

if not DAYY then 
    gg.setVisible(true) 
else 
    local selected_days = {}
    for i = 1, 7 do
        if DAYY[i] then
            table.insert(selected_days, i)  
        end
    end

    if #selected_days == 0 then
        gg.alert("⚠️ erro! ⚠️")
        gg.setVisible(true)
        return
    end

    local days = {
    "Mon",
    "Tue",
    "Wed",
    "Thu",
    "Fri",
    "Sat",
    "Sun"
}
    local TT = "local block_day_week = {\n"
    for _, day_index in ipairs(selected_days) do
        TT = TT .. string.format('    ["%s"] = true,\n', days[day_index])
    end
    TT = TT .. "}\n\n"
    TT = TT .. [[
local function verify(day)
    return block_day_week[day]
end

local day = os.date('%a')
if day then
    if verify(day) then
 gg.alert("day week incorrect, script no work this day")
        os.exit()
    else
        print("✅ Sucesso")
    end
else
    gg.alert("❌ error")
    os.exit()
end
]]   
    local file = io.open(g.out, "a") 
    if file then
        file:write(TT)
        file:close()
    else
        gg.alert("❌ error")
    end
end

if g.info[15] == true then
 UU = [[ file, err = io.open("/system/bin/su", "r")

if file then
    gg.alert("Rooted device! Starting the script...")
    file:close()
else
    gg.alert("Non-rooted device. This script requires a rooted device.")
    os.exit()
end

]]
local file = io.open(g.out, "a")
    if file then
        file:write(UU)
        file:close()
    else
        gg.alert("❌ Error: Could not open file for writing.")
end
end

if g.info[16] == true then
    local sph = gg.prompt({
        "Android 5.0 (Lollipop)",
        "Android 5.1 (Lollipop)",
        "Android 6.0 (Marshmallow)",
        "Android 7.0 (Nougat)",
        "Android 7.1 (Nougat)",
        "Android 8.0 (Oreo)",
        "Android 8.1 (Oreo)",
        "Android 9.0 (Pie)",
        "Android 10",
        "Android 11",
        "Android 12",
        "Android 12L",
        "Android 13",
        "Android 14"
    }, {false, false, false, false, false, false, false, false, false, false, false, false, false, false}, 
    {"checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox"})

    if sph == nil then
        return
    else
        local sphr = "30" 

        if sph[1] == true then
            sphr = "21"
        elseif sph[2] == true then
            sphr = "22"
        elseif sph[3] == true then
            sphr = "23"
        elseif sph[4] == true then
            sphr = "24"
        elseif sph[5] == true then
            sphr = "25"
        elseif sph[6] == true then
            sphr = "26"
        elseif sph[7] == true then
            sphr = "27"
        elseif sph[8] == true then
            sphr = "28"
        elseif sph[9] == true then
            sphr = "29"
        elseif sph[10] == true then
            sphr = "30"
        elseif sph[11] == true then
            sphr = "31"
        elseif sph[12] == true then
            sphr = "32"
        elseif sph[13] == true then
            sphr = "33"
        elseif sph[14] == true then
            sphr = "34"
        end

        local VB = [[
            local required_sdk = ]] .. sphr .. [[

            local original_sdk = gg.ANDROID_SDK_INT

            if original_sdk then
                if original_sdk == required_sdk then
                    print("correct SDK")
                else
                    local sdk_versions = {
                        ["21"] = "Android 5.0",
                        ["22"] = "Android 5.1",
                        ["23"] = "Android 6.0",
                        ["24"] = "Android 7.0",
                        ["25"] = "Android 7.1",
                        ["26"] = "Android 8.0",
                        ["27"] = "Android 8.1",
                        ["28"] = "Android 9.0",
                        ["29"] = "Android 10",
                        ["30"] = "Android 11",
                        ["31"] = "Android 12",
                        ["32"] = "Android 12L",
                        ["33"] = "Android 13",
                        ["34"] = "Android 14"
                    }
                    local required_version = sdk_versions[tostring(required_sdk)]
                    gg.alert("Please use " .. required_version .. " (API Level " .. required_sdk .. ") to execute this script.")
                    os.exit()
                end
            else
                gg.alert("Failed to get SDK.")
                os.exit()
            end
        ]]
        local file = io.open(g.out, "a")
        if file then
            file:write(VB)
            file:close()            
        else
            gg.alert("❌ Error: Could not open file for writing.")
        end
    end
end

    if g.info[17] == true then
        local dayy = os.date("%d")
        exp_dater = gg.prompt({
        "📆 Set Expired Date : ",
        "📝 Type Expired Message : "
    }, {os.date("%Y%m" .. dayy), "⚠️ Script Expired ⚠️️"}, {"number", "text"})
end 
if not exp_dater then
    gg.setVisible(true)
elseif exp_dater[1] == nil then
    gg.alert("📆 Date Can Not Be Empty !")
    gg.setVisible(true)
else
    print("📅 Added Expired Date online : True✔")
    
    local XX = [[
    function dayyy()
        local response = gg.makeRequest('http://www.whatismyip.org')
    local dateHeader = response.headers['Date'][1]

    local day, month, year = dateHeader:match('(%d+)%s(%w+)%s(%d+)')

    local months = {
        Jan = 1, Feb = 2, Mar = 3, Apr = 4, May = 5, Jun = 6,
        Jul = 7, Aug = 8, Sep = 9, Oct = 10, Nov = 11, Dec = 12
    }
    month = months[month]

    local serverDate = tonumber(string.format('%04d%02d%02d', year, month, day))

    local ExpDate = ]]..exp_dater[1] ..[[

    local FileName = gg.getFile():match('[^/]+$')
    local NewName = '#NewFile.lua'

    if serverDate > ExpDate then
        os.rename(FileName, NewName)
        os.remove(NewName)
        gg.alert('Sᴄʀɪᴘᴛ Exᴘɪʀᴇᴅ!')
        gg.alert('this script is deleted bro!')
        os.exit()
    end
    end
dayyy()
    ]]

 local file = io.open(g.out, "a")
    if file then
        file:write(XX)
        file:close()
    else
        gg.alert("❌ Error: Could not open file for writing.")
    end
end
  
if g.info[18] == true then
 UU = [[     local function checkTargetInfo()
    local targetInfo = gg.getTargetInfo()
    if not targetInfo then
        print('failed request info.')
        os.exit()
        return
    end
    for k, v in pairs(targetInfo) do
        --print(k .. ": " .. tostring(v))
    end
    if targetInfo.x64 then        
    else
           print('no work in 32 bit')
        os.exit()
    end
end

checkTargetInfo()
]]
local file = io.open(g.out, "a")
    if file then
        file:write(UU)
        file:close()
    else
        gg.alert("❌ Error: Could not open file for writing.")
end
end
 
if g.info[19] == true then
    IPP = gg.prompt({
        "⏰ enter ip to block:",
        
    }, {"00.000.000"}, {"text"})
end

if not IPP then 
    gg.setVisible(true) 
else 
    if IPP[1] == '' then 
        gg.alert("⚠️ Cᴀɴɴᴏᴛ Bᴇ Eᴍᴘᴛʏ! ⚠️") 
        gg.setVisible(true) 
    else       
        local ip1 = IPP[1]
       
        local RR = [[

       local ip = "]]..ip1..[[" 

local Link = "https://browserleaks.com/ip"
local bat = gg.makeRequest(Link).content

if not bat then
    gg.alert("Failed to retrieve the page.")
    os.exit()
end

local function extractDataIPFromHTML(html)
    local pattern = 'data%-ip%="([%d%.]+)"'
    local dataIP = html:match(pattern)
    return dataIP
end

local dataIP = extractDataIPFromHTML(bat)

if not dataIP then
    gg.alert("Error: Failed to extract IP.")
    os.exit()
else
end

if dataIP == ip then
    gg.alert("IP blocked.")
    os.exit()
else
end
]]
    local file = io.open(g.out, "a")
    if file then
        file:write(RR)
        file:close()
    else
        gg.alert("❌ Error: Could not open file for writing.")
end
end
end
 
if g.info[20] == true then
    FILE = gg.prompt({
        "✍️ enter file size example 33.00 KB ",
        
    }, {"948.00 B"}, {"text"})
end

if not FILE then 
    gg.setVisible(true) 
else 
    if FILE[1] == '' then 
        gg.alert("⚠️ Cᴀɴɴᴏᴛ Bᴇ Eᴍᴘᴛʏ! ⚠️") 
        gg.setVisible(true) 
    else 
      
        local ip1 = FILE[1]
       
        local RR = [[

local sizeOriginal = "]]..ip1..[[" 

local function formatSize(size)
    local units = {"B", "KB", "MB", "GB", "TB"}
    local unitIndex = 1
    while size >= 1024 and unitIndex < #units do
        size = size / 1024
        unitIndex = unitIndex + 1
    end
    return string.format("%.2f %s", size, units[unitIndex])
end

local function getFileSize(path)
    local file, err = io.open(path, "rb")
    if not file then
        return "Error opening file: " .. err
    end
    local content = file:read("*a")
    file:close()

    if not content then
        return "File empty or cannot load content."
    end
    local sizeInBytes = #content
    return formatSize(sizeInBytes)
end
local archive = gg.getFile()
local fileSize = getFileSize(archive)
if sizeOriginal ~= fileSize then
    gg.alert("Error, file modified")
    print(fileSize)
    os.exit()
else
end
]]
local file = io.open(g.out, "a")
    if file then
        file:write(RR)
        file:close()
    else
        gg.alert("❌ Error: Could not open file for writing.")
end
end
end

if g.info[21] == true then
local country_language_map = {
    AF = "AFGHANISTAN",
    AL = "ALBANIA",
    DZ = "ALGERIA",
    AS = "AMERICAN SAMOA",
    AD = "ANDORRA",
    AO = "ANGOLA",
    AI = "ANGUILLA",
    AG = "ANTIGUA AND BARBUDA",
    AR = "ARGENTINA",
    AM = "ARMENIA",
    AW = "ARUBA",
    AU = "AUSTRALIA",
    AT = "AUSTRIA",
    AZ = "AZERBAIJAN",
    BS = "BAHAMAS",
    BH = "BAHRAIN",
    BD = "BANGLADESH",
    BB = "BARBADOS",
    BY = "BELARUS",
    BE = "BELGIUM",
    BZ = "BELIZE",
    BJ = "BENIN",
    BM = "BERMUDA",
    BT = "BHUTAN",
    BO = "BOLIVIA",
    BA = "BOSNIA AND HERZEGOVINA",
    BW = "BOTSWANA",
    BV = "BOUVET ISLAND",
    BR = "BRAZIL",
    IO = "BRITISH INDIAN OCEAN TERRITORY",
    BN = "BRUNEI DARUSSALAM",
    BG = "BULGARIA",
    BF = "BURKINA FASO",
    BI = "BURUNDI",
    KH = "CAMBODIA",
    CM = "CAMEROON",
    CA = "CANADA",
    CV = "CAPE VERDE",
    KY = "CAYMAN ISLANDS",
    CF = "CENTRAL AFRICAN REPUBLIC",
    TD = "CHAD",
    CL = "CHILE",
    CN = "CHINA",
    CX = "CHRISTMAS ISLAND",
    CC = "COCOS (KEELING) ISLANDS",
    CO = "COLOMBIA",
    KM = "COMOROS",
    CG = "CONGO",
    CD = "CONGO, DEMOCRATIC REPUBLIC OF THE",
    CK = "COOK ISLANDS",
    CR = "COSTA RICA",
    CI = "COTE D'IVOIRE",
    HR = "CROATIA",
    CU = "CUBA",
    CW = "CURACAO",
    CY = "CYPRUS",
    CZ = "CZECH REPUBLIC",
    DK = "DENMARK",
    DJ = "DJIBOUTI",
    DM = "DOMINICA",
    DO = "DOMINICAN REPUBLIC",
    EC = "ECUADOR",
    EG = "EGYPT",
    SV = "EL SALVADOR",
    GQ = "EQUATORIAL GUINEA",
    ER = "ERITREA",
    EE = "ESTONIA",
    ET = "ETHIOPIA",
    FK = "FALKLAND ISLANDS",
    FO = "FAROE ISLANDS",
    FJ = "FIJI",
    FI = "FINLAND",
    FR = "FRANCE",
    GF = "FRENCH GUIANA",
    PF = "FRENCH POLYNESIA",
    TF = "FRENCH SOUTHERN TERRITORIES",
    GA = "GABON",
    GM = "GAMBIA",
    GE = "GEORGIA",
    DE = "GERMANY",
    GH = "GHANA",
    GI = "GIBRALTAR",
    GR = "GREECE",
    GL = "GREENLAND",
    GD = "GRENADA",
    GP = "GUADELOUPE",
    GU = "GUAM",
    GT = "GUATEMALA",
    GG = "GUERNSEY",
    GN = "GUINEA",
    GW = "GUINEA-BISSAU",
    GY = "GUYANA",
    HT = "HAITI",
    HM = "HEARD ISLAND AND MCDONALD ISLANDS",
    VA = "HOLY SEE",
    HN = "HONDURAS",
    HK = "HONG KONG",
    HU = "HUNGARY",
    IS = "ICELAND",
    IN = "INDIA",
    ID = "INDONESIA",
    IR = "IRAN",
    IQ = "IRAQ",
    IE = "IRELAND",
    IM = "ISLE OF MAN",
    IL = "ISRAEL",
    IT = "ITALY",
    JM = "JAMAICA",
    JP = "JAPAN",
    JE = "JERSEY",
    JO = "JORDAN",
    KZ = "KAZAKHSTAN",
    KE = "KENYA",
    KI = "KIRIBATI",
    KP = "KOREA, DEMOCRATIC PEOPLE'S REPUBLIC OF",
    KR = "KOREA, REPUBLIC OF",
    KW = "KUWAIT",
    KG = "KYRGYZSTAN",
    LA = "LAO PEOPLE'S DEMOCRATIC REPUBLIC",
    LV = "LATVIA",
    LB = "LEBANON",
    LS = "LESOTHO",
    LR = "LIBERIA",
    LY = "LIBYA",
    LI = "LIECHTENSTEIN",
    LT = "LITHUANIA",
    LU = "LUXEMBOURG",
    MO = "MACAO",
    MK = "MACEDONIA",
    MG = "MADAGASCAR",
    MW = "MALAWI",
    MY = "MALAYSIA",
    MV = "MALDIVES",
    ML = "MALI",
    MT = "MALTA",
    MH = "MARSHALL ISLANDS",
    MR = "MAURITANIA",
    MU = "MAURITIUS",
    YT = "MAYOTTE",
    MX = "MEXICO",
    FM = "MICRONESIA",
    MD = "MOLDOVA",
    MC = "MONACO",
    MN = "MONGOLIA",
    ME = "MONTENEGRO",
    MS = "MONTSERRAT",
    MA = "MOROCCO",
    MZ = "MOZAMBIQUE",
    MM = "MYANMAR",
    NA = "NAMIBIA",
    NR = "NAURU",
    NP = "NEPAL",
    NL = "NETHERLANDS",
    NC = "NEW CALEDONIA",
    NZ = "NEW ZEALAND",
    NI = "NICARAGUA",
    NE = "NIGER",
    NG = "NIGERIA",
    NU = "NIUE",
    NF = "NORFOLK ISLAND",
    MP = "NORTHERN MARIANA ISLANDS",
    NO = "NORWAY",
    OM = "OMAN",
    PK = "PAKISTAN",
    PW = "PALAU",
    PS = "PALESTINE",
    PA = "PANAMA",
    PG = "PAPUA NEW GUINEA",
    PY = "PARAGUAY",
    PE = "PERU",
    PH = "PHILIPPINES",
    PN = "PITCAIRN",
    PL = "POLAND",
    PT = "PORTUGAL",
    PR = "PUERTO RICO",
    QA = "QATAR",
    RE = "REUNION",
    RO = "ROMANIA",
    RU = "RUSSIA",
    RW = "RWANDA",
    BL = "SAINT BARTHÉLEMY",
    SH = "SAINT HELENA",
    KN = "SAINT KITTS AND NEVIS",
    LC = "SAINT LUCIA",
    MF = "SAINT MARTIN",
    PM = "SAINT PIERRE AND MIQUELON",
    VC = "SAINT VINCENT AND THE GRENADINES",
    WS = "SAMOA",
    SM = "SAN MARINO",
    ST = "SAO TOME AND PRINCIPE",
    SA = "SAUDI ARABIA",
    SN = "SENEGAL",
    RS = "SERBIA",
    SC = "SEYCHELLES",
    SL = "SIERRA LEONE",
    SG = "SINGAPORE",
    SX = "SINT MAARTEN",
    SK = "SLOVAKIA",
    SI = "SLOVENIA",
    SB = "SOLOMON ISLANDS",
    SO = "SOMALIA",
    ZA = "SOUTH AFRICA",
    GS = "SOUTH GEORGIA AND THE SOUTH SANDWICH ISLANDS",
    SS = "SOUTH SUDAN",
    ES = "SPAIN",
    LK = "SRI LANKA",
    SD = "SUDAN",
    SR = "SURINAME",
    SZ = "SWAZILAND",
    SE = "SWEDEN",
    CH = "SWITZERLAND",
    SY = "SYRIAN ARAB REPUBLIC",
    TW = "TAIWAN",
    TJ = "TAJIKISTAN",
    TZ = "TANZANIA",
    TH = "THAILAND",
    TL = "TIMOR-LESTE",
    TG = "TOGO",
    TK = "TOKELAU",
    TO = "TONGA",
    TT = "TRINIDAD AND TOBAGO",
    TN = "TUNISIA",
    TR = "TURKEY",
    TM = "TURKMENISTAN",
    TC = "TURKS AND CAICOS ISLANDS",
    TV = "TUVALU",
    UG = "UGANDA",
    UA = "UKRAINE",
    AE = "UNITED ARAB EMIRATES",
    GB = "UNITED KINGDOM",
    US = "UNITED STATES",
    UY = "URUGUAY",
    UZ = "UZBEKISTAN",
    VU = "VANUATU",
    VE = "VENEZUELA",
    VN = "VIETNAM",
    VG = "VIRGIN ISLANDS, BRITISH",
    VI = "VIRGIN ISLANDS, U.S.",
    WF = "WALLIS AND FUTUNA",
    EH = "WESTERN SAHARA",
    YE = "YEMEN",
    ZM = "ZAMBIA",
    ZW = "ZIMBABWE"
}
    local sph = gg.prompt({
 "AFGHANISTAN",
"ALBANIA",
"ALGERIA",
"AMERICAN SAMOA",
"ANDORRA",
"ANGOLA",
"ANGUILLA",
"ANTIGUA AND BARBUDA",
"ARGENTINA",
"ARMENIA",
"ARUBA",
"AUSTRALIA",
"AUSTRIA",
"AZERBAIJAN",
"BAHAMAS",
"BAHRAIN",
"BANGLADESH",
"BARBADOS",
"BELARUS",
"BELGIUM",
"BELIZE",
"BENIN",
"BERMUDA",
"BHUTAN",
"BOLIVIA",
"BOSNIA AND HERZEGOVINA",
"BOTSWANA",
"BOUVET ISLAND",
"BRAZIL",
"BRITISH INDIAN OCEAN TERRITORY",
"BRUNEI DARUSSALAM",
"BULGARIA",
"BURKINA FASO",
"BURUNDI",
"CAMBODIA",
"CAMEROON",
"CANADA",
"CAPE VERDE",
"CAYMAN ISLANDS",
"CENTRAL AFRICAN REPUBLIC",
"CHAD",
"CHILE",
"CHINA",
"CHRISTMAS ISLAND",
"COCOS (KEELING) ISLANDS",
"COLOMBIA",
"COMOROS",
"CONGO",
"CONGO, DEMOCRATIC REPUBLIC OF THE",
"COOK ISLANDS",
"COSTA RICA",
"COTE D'IVOIRE",
"CROATIA",
"CUBA",
"CURACAO",
"CYPRUS",
"CZECH REPUBLIC",
"DENMARK",
"DJIBOUTI",
"DOMINICA",
"DOMINICAN REPUBLIC",
"ECUADOR",
"EGYPT",
"EL SALVADOR",
"EQUATORIAL GUINEA",
"ERITREA",
"ESTONIA",
"ETHIOPIA",
"FALKLAND ISLANDS",
"FAROE ISLANDS",
"FIJI",
"FINLAND",
"FRANCE",
"FRENCH GUIANA",
"FRENCH POLYNESIA",
"FRENCH SOUTHERN TERRITORIES",
"GABON",
"GAMBIA",
"GEORGIA",
"GERMANY",
"GHANA",
"GIBRALTAR",
"GREECE",
"GREENLAND",
"GRENADA",
"GUADELOUPE",
"GUAM",
"GUATEMALA",
"GUERNSEY",
"GUINEA",
"GUINEA-BISSAU",
"GUYANA",
"HAITI",
"HEARD ISLAND AND MCDONALD ISLANDS",
"HOLY SEE",
"HONDURAS",
"HONG KONG",
"HUNGARY",
"ICELAND",
"INDIA",
"INDONESIA",
"IRAN",
"IRAQ",
"IRELAND",
"ISLE OF MAN",
"ISRAEL",
"ITALY",
"JAMAICA",
"JAPAN",
"JERSEY",
"JORDAN",
"KAZAKHSTAN",
"KENYA",
"KIRIBATI",
"KOREA, DEMOCRATIC PEOPLE'S REPUBLIC OF",
"KOREA, REPUBLIC OF",
"KUWAIT",
"KYRGYZSTAN",
"LAO PEOPLE'S DEMOCRATIC REPUBLIC",
"LATVIA",
"LEBANON",
"LESOTHO",
"LIBERIA",
"LIBYA",
"LIECHTENSTEIN",
"LITHUANIA",
"LUXEMBOURG",
"MACAO",
"MACEDONIA",
"MADAGASCAR",
"MALAWI",
"MALAYSIA",
"MALDIVES",
"MALI",
"MALTA",
"MARSHALL ISLANDS",
"MAURITANIA",
"MAURITIUS",
"MAYOTTE",
"MEXICO",
"MICRONESIA",
"MOLDOVA",
"MONACO",
"MONGOLIA",
"MONTENEGRO",
"MONTSERRAT",
"MOROCCO",
"MOZAMBIQUE",
"MYANMAR",
"NAMIBIA",
"NAURU",
"NEPAL",
"NETHERLANDS",
"NEW CALEDONIA",
"NEW ZEALAND",
"NICARAGUA",
"NIGER",
"NIGERIA",
"NIUE",
"NORFOLK ISLAND",
"NORTHERN MARIANA ISLANDS",
"NORWAY",
"OMAN",
"PAKISTAN",
"PALAU",
"PALESTINE",
"PANAMA",
"PAPUA NEW GUINEA",
"PARAGUAY",
"PERU",
"PHILIPPINES",
"PITCAIRN",
"POLAND",
"PORTUGAL",
"PUERTO RICO",
"QATAR",
"REUNION",
"ROMANIA",
"RUSSIA",
"RWANDA",
"SAINT BARTHÉLEMY",
"SAINT HELENA",
"SAINT KITTS AND NEVIS",
"SAINT LUCIA",
"SAINT MARTIN",
"SAINT PIERRE AND MIQUELON",
"SAINT VINCENT AND THE GRENADINES",
"SAMOA",
"SAN MARINO",
"SAO TOME AND PRINCIPE",
"SAUDI ARABIA",
"SENEGAL",
"SERBIA",
"SEYCHELLES",
"SIERRA LEONE",
"SINGAPORE",
"SINT MAARTEN",
"SLOVAKIA",
"SLOVENIA",
"SOLOMON ISLANDS",
"SOMALIA",
"SOUTH AFRICA",
"SOUTH GEORGIA AND THE SOUTH SANDWICH ISLANDS",
"SOUTH SUDAN",
"SPAIN",
"SRI LANKA",
"SUDAN",
"SURINAME",
"SWAZILAND",
"SWEDEN",
"SWITZERLAND",
"SYRIAN ARAB REPUBLIC",
"TAIWAN",
"TAJIKISTAN",
"TANZANIA",
"THAILAND",
"TIMOR-LESTE",
"TOGO",
"TOKELAU",
"TONGA",
"TRINIDAD AND TOBAGO",
"TUNISIA",
"TURKEY",
"TURKMENISTAN",
"TURKS AND CAICOS ISLANDS",
"TUVALU",
"UGANDA",
"UKRAINE",
"UNITED ARAB EMIRATES",
"UNITED KINGDOM",
"UNITED STATES",
"URUGUAY",
"UZBEKISTAN",
"VANUATU",
"VENEZUELA",
"VIETNAM",
"VIRGIN ISLANDS, BRITISH",
"VIRGIN ISLANDS, U.S.",
"WALLIS AND FUTUNA",
"WESTERN SAHARA",
 "YEMEN",
 "ZAMBIA",
 "ZIMBABWE"
    }, {false}  , {"checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox","checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox","checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox","checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox","checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox","checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", 
     "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox","checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox","checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox","checkbox", "checkbox"})

    if sph == nil then
        return
    else
        local block_country_codes = {}

            local country_codes = {
            "AF", "AL", "DZ", "AS", "AD", "AO", "AI", "AG", "AR", "AM", "AW", "AU",
"AT", "AZ", "BS", "BH", "BD", "BB", "BY", "BE", "BZ", "BJ", "BM", "BT",
"BO", "BA", "BW", "BV", "BR", "IO", "BN", "BG", "BF", "BI", "KH", "CM",
"CA", "CV", "KY", "CF", "TD", "CL", "CN", "CX", "CC", "CO", "KM", "CG",
"CD", "CK", "CR", "CI", "HR", "CU", "CW", "CY", "CZ", "DK", "DJ", "DM",
"DO", "EC", "EG", "SV", "GQ", "ER", "EE", "ET", "FK", "FO", "FJ", "FI",
"FR", "GF", "PF", "TF", "GA", "GM", "GE", "DE", "GH", "GI", "GR", "GL",
"GD", "GP", "GU", "GT", "GG", "GN", "GW", "GY", "HT", "HM", "VA", "HN",
"HK", "HU", "IS", "IN", "ID", "IR", "IQ", "IE", "IM", "IL", "IT", "JM",
"JP", "JE", "JO", "KZ", "KE", "KI", "KP", "KR", "KW", "KG", "LA", "LV",
"LB", "LS", "LR", "LY", "LI", "LT", "LU", "MO", "MK", "MG", "MW", "MY",
"MV", "ML", "MT", "MH", "MR", "MU", "YT", "MX", "FM", "MD", "MC", "MN",
"ME", "MS", "MA", "MZ", "MM", "NA", "NR", "NP", "NL", "NC", "NZ", "NI",
"NE", "NG", "NU", "NF", "MP", "NO", "OM", "PK", "PW", "PS", "PA", "PG",
"PY", "PE", "PH", "PN", "PL", "PT", "PR", "QA", "RE", "RO", "RU", "RW",
"BL", "SH", "KN", "LC", "MF", "PM", "VC", "WS", "SM", "ST", "SA", "SN",
"RS", "SC", "SL", "SG", "SX", "SK", "SI", "SB", "SO", "ZA", "GS", "SS",
"ES", "LK", "SD", "SR", "SZ", "SE", "CH", "SY", "TW", "TJ", "TZ", "TH",
"TL", "TG", "TK", "TO", "TT", "TN", "TR", "TM", "TC", "TV", "UG", "UA",
"AE", "GB", "US", "UY", "UZ", "VU", "VE", "VN", "VG", "VI", "WF", "EH",
"YE", "ZM", "ZW"
        }

        for i, selected in ipairs(sph) do
            if selected then
                table.insert(block_country_codes, country_codes[i])
            end
        end

        local VB = [[
                
        local country_language_map = {
    AF = "AFGHANISTAN",
    AL = "ALBANIA",
    DZ = "ALGERIA",
    AS = "AMERICAN SAMOA",
    AD = "ANDORRA",
    AO = "ANGOLA",
    AI = "ANGUILLA",
    AG = "ANTIGUA AND BARBUDA",
    AR = "ARGENTINA",
    AM = "ARMENIA",
    AW = "ARUBA",
    AU = "AUSTRALIA",
    AT = "AUSTRIA",
    AZ = "AZERBAIJAN",
    BS = "BAHAMAS",
    BH = "BAHRAIN",
    BD = "BANGLADESH",
    BB = "BARBADOS",
    BY = "BELARUS",
    BE = "BELGIUM",
    BZ = "BELIZE",
    BJ = "BENIN",
    BM = "BERMUDA",
    BT = "BHUTAN",
    BO = "BOLIVIA",
    BA = "BOSNIA AND HERZEGOVINA",
    BW = "BOTSWANA",
    BV = "BOUVET ISLAND",
    BR = "BRAZIL",
    IO = "BRITISH INDIAN OCEAN TERRITORY",
    BN = "BRUNEI DARUSSALAM",
    BG = "BULGARIA",
    BF = "BURKINA FASO",
    BI = "BURUNDI",
    KH = "CAMBODIA",
    CM = "CAMEROON",
    CA = "CANADA",
    CV = "CAPE VERDE",
    KY = "CAYMAN ISLANDS",
    CF = "CENTRAL AFRICAN REPUBLIC",
    TD = "CHAD",
    CL = "CHILE",
    CN = "CHINA",
    CX = "CHRISTMAS ISLAND",
    CC = "COCOS (KEELING) ISLANDS",
    CO = "COLOMBIA",
    KM = "COMOROS",
    CG = "CONGO",
    CD = "CONGO, DEMOCRATIC REPUBLIC OF THE",
    CK = "COOK ISLANDS",
    CR = "COSTA RICA",
    CI = "COTE D'IVOIRE",
    HR = "CROATIA",
    CU = "CUBA",
    CW = "CURACAO",
    CY = "CYPRUS",
    CZ = "CZECH REPUBLIC",
    DK = "DENMARK",
    DJ = "DJIBOUTI",
    DM = "DOMINICA",
    DO = "DOMINICAN REPUBLIC",
    EC = "ECUADOR",
    EG = "EGYPT",
    SV = "EL SALVADOR",
    GQ = "EQUATORIAL GUINEA",
    ER = "ERITREA",
    EE = "ESTONIA",
    ET = "ETHIOPIA",
    FK = "FALKLAND ISLANDS",
    FO = "FAROE ISLANDS",
    FJ = "FIJI",
    FI = "FINLAND",
    FR = "FRANCE",
    GF = "FRENCH GUIANA",
    PF = "FRENCH POLYNESIA",
    TF = "FRENCH SOUTHERN TERRITORIES",
    GA = "GABON",
    GM = "GAMBIA",
    GE = "GEORGIA",
    DE = "GERMANY",
    GH = "GHANA",
    GI = "GIBRALTAR",
    GR = "GREECE",
    GL = "GREENLAND",
    GD = "GRENADA",
    GP = "GUADELOUPE",
    GU = "GUAM",
    GT = "GUATEMALA",
    GG = "GUERNSEY",
    GN = "GUINEA",
    GW = "GUINEA-BISSAU",
    GY = "GUYANA",
    HT = "HAITI",
    HM = "HEARD ISLAND AND MCDONALD ISLANDS",
    VA = "HOLY SEE",
    HN = "HONDURAS",
    HK = "HONG KONG",
    HU = "HUNGARY",
    IS = "ICELAND",
    IN = "INDIA",
    ID = "INDONESIA",
    IR = "IRAN",
    IQ = "IRAQ",
    IE = "IRELAND",
    IM = "ISLE OF MAN",
    IL = "ISRAEL",
    IT = "ITALY",
    JM = "JAMAICA",
    JP = "JAPAN",
    JE = "JERSEY",
    JO = "JORDAN",
    KZ = "KAZAKHSTAN",
    KE = "KENYA",
    KI = "KIRIBATI",
    KP = "KOREA, DEMOCRATIC PEOPLE'S REPUBLIC OF",
    KR = "KOREA, REPUBLIC OF",
    KW = "KUWAIT",
    KG = "KYRGYZSTAN",
    LA = "LAO PEOPLE'S DEMOCRATIC REPUBLIC",
    LV = "LATVIA",
    LB = "LEBANON",
    LS = "LESOTHO",
    LR = "LIBERIA",
    LY = "LIBYA",
    LI = "LIECHTENSTEIN",
    LT = "LITHUANIA",
    LU = "LUXEMBOURG",
    MO = "MACAO",
    MK = "MACEDONIA",
    MG = "MADAGASCAR",
    MW = "MALAWI",
    MY = "MALAYSIA",
    MV = "MALDIVES",
    ML = "MALI",
    MT = "MALTA",
    MH = "MARSHALL ISLANDS",
    MR = "MAURITANIA",
    MU = "MAURITIUS",
    YT = "MAYOTTE",
    MX = "MEXICO",
    FM = "MICRONESIA",
    MD = "MOLDOVA",
    MC = "MONACO",
    MN = "MONGOLIA",
    ME = "MONTENEGRO",
    MS = "MONTSERRAT",
    MA = "MOROCCO",
    MZ = "MOZAMBIQUE",
    MM = "MYANMAR",
    NA = "NAMIBIA",
    NR = "NAURU",
    NP = "NEPAL",
    NL = "NETHERLANDS",
    NC = "NEW CALEDONIA",
    NZ = "NEW ZEALAND",
    NI = "NICARAGUA",
    NE = "NIGER",
    NG = "NIGERIA",
    NU = "NIUE",
    NF = "NORFOLK ISLAND",
    MP = "NORTHERN MARIANA ISLANDS",
    NO = "NORWAY",
    OM = "OMAN",
    PK = "PAKISTAN",
    PW = "PALAU",
    PS = "PALESTINE",
    PA = "PANAMA",
    PG = "PAPUA NEW GUINEA",
    PY = "PARAGUAY",
    PE = "PERU",
    PH = "PHILIPPINES",
    PN = "PITCAIRN",
    PL = "POLAND",
    PT = "PORTUGAL",
    PR = "PUERTO RICO",
    QA = "QATAR",
    RE = "REUNION",
    RO = "ROMANIA",
    RU = "RUSSIA",
    RW = "RWANDA",
    BL = "SAINT BARTHÉLEMY",
    SH = "SAINT HELENA",
    KN = "SAINT KITTS AND NEVIS",
    LC = "SAINT LUCIA",
    MF = "SAINT MARTIN",
    PM = "SAINT PIERRE AND MIQUELON",
    VC = "SAINT VINCENT AND THE GRENADINES",
    WS = "SAMOA",
    SM = "SAN MARINO",
    ST = "SAO TOME AND PRINCIPE",
    SA = "SAUDI ARABIA",
    SN = "SENEGAL",
    RS = "SERBIA",
    SC = "SEYCHELLES",
    SL = "SIERRA LEONE",
    SG = "SINGAPORE",
    SX = "SINT MAARTEN",
    SK = "SLOVAKIA",
    SI = "SLOVENIA",
    SB = "SOLOMON ISLANDS",
    SO = "SOMALIA",
    ZA = "SOUTH AFRICA",
    GS = "SOUTH GEORGIA AND THE SOUTH SANDWICH ISLANDS",
    SS = "SOUTH SUDAN",
    ES = "SPAIN",
    LK = "SRI LANKA",
    SD = "SUDAN",
    SR = "SURINAME",
    SZ = "SWAZILAND",
    SE = "SWEDEN",
    CH = "SWITZERLAND",
    SY = "SYRIAN ARAB REPUBLIC",
    TW = "TAIWAN",
    TJ = "TAJIKISTAN",
    TZ = "TANZANIA",
    TH = "THAILAND",
    TL = "TIMOR-LESTE",
    TG = "TOGO",
    TK = "TOKELAU",
    TO = "TONGA",
    TT = "TRINIDAD AND TOBAGO",
    TN = "TUNISIA",
    TR = "TURKEY",
    TM = "TURKMENISTAN",
    TC = "TURKS AND CAICOS ISLANDS",
    TV = "TUVALU",
    UG = "UGANDA",
    UA = "UKRAINE",
    AE = "UNITED ARAB EMIRATES",
    GB = "UNITED KINGDOM",
    US = "UNITED STATES",
    UY = "URUGUAY",
    UZ = "UZBEKISTAN",
    VU = "VANUATU",
    VE = "VENEZUELA",
    VN = "VIETNAM",
    VG = "VIRGIN ISLANDS, BRITISH",
    VI = "VIRGIN ISLANDS, U.S.",
    WF = "WALLIS AND FUTUNA",
    EH = "WESTERN SAHARA",
    YE = "YEMEN",
    ZM = "ZAMBIA",
    ZW = "ZIMBABWE"
}

local block_country = {
]]

        for _, code in ipairs(block_country_codes) do
            VB = VB .. string.format('    ["%s"] = true,\n', country_language_map[code])
        end

        VB = VB .. [[
}

local function verificarVersaoBloqueada(pais)
    return block_country[pais]
end

local function makeRequest(url)
    local request = gg.makeRequest(url)
    if not request or not request.content then
        print('Error in request.')
        os.exit()
    end
    return request.content
end
local Link = "https://ipwhois.app/json/"
local response = makeRequest(Link)

local function extractCountryCodeFromHTML(html)
    local pattern = '"country_code":"(.-)"'
    return html:match(pattern)
end

local function getCountryNameFromCode(code)
    return country_language_map[code] or "UNKNOWN"
end

local country_code = extractCountryCodeFromHTML(response)

if not country_code then
    print('Error in getting country code.')
    os.exit()
end

local country_name = getCountryNameFromCode(country_code)

if verificarVersaoBloqueada(country_name) then
    gg.alert("this country is blocked.")
    os.exit()
    return 
end
]]
        local file = io.open(g.out, "a")
        if file then
            file:write(VB)
            file:close()
        else
            gg.alert("❌ Error: Could not open file for writing.")
        end
    end
    
end
 
 if g.info[22] == true then
VIEW = [[
if true then
    local org = gg.searchNumber
    local hook = function(...)
        gg.setVisible(false)
        local ret = org(...)
        if gg.isVisible() then
        gg.alert("ANTI VIEW CODE😂")
        gg.clearResults()
            while true do os.exit() end
        end
        return ret
    end
    gg.searchNumber = hook
end
]]
print('🛡ANTIVIEW  by Batman games : Sucess √ ')
local file = io.open(g.out, "a")
    if file then
        file:write(VIEW)
        file:close()
    else
        gg.alert("❌ Error: Could not open file for writing.")
end
end

local file = io.open(g.out, "a")
    if file then
        file:write(DATA)
        file:close()
    else
        gg.alert("❌ Error: Could not open file for writing.")
end

alertBatman = '📂 File Saved To: '..g.out..'\n'
gg.alert(alertBatman, '')
print("\n▬▬▬▬▬▬▬▬▬▬▬▬▬\n📂 File Saved To :" .. g.out .. "\n▬▬▬▬▬▬▬▬▬▬▬▬▬")
return 
end 