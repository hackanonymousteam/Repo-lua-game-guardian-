
h = 1
smail = {
  "🔥",
  "💥",
  "✅",
  "⚡",
  "☠️",
  "📜",
  "👻",
  "🎃",
  "🧨",
  "🔮",
  "🛡️",
  "💣",
  "📦"
}
i = math.random(#smail)
ranl = smail[i]
gg.toast("\n" .. ranl .. " ᴠɪᴘ sᴄʀɪᴘᴛ " .. ranl)
gg.sleep(1000)
smail = {
  "🔥",
  "💥",
  "✅",
  "⚡",
  "☠️",
  "📜",
  "👻",
  "🎃",
  "🧨",
  "🔮",
  "🛡️",
  "💣",
  "📦"
}
i = math.random(#smail)
ranl = smail[i]
gg.alert(smail[i] .. "Batman Games:: 𝚈𝚘𝚞𝚃𝚞𝚋𝚎" .. smail[i] .. "\n" )
gg.clearResults()
gg.clearList()
function HOME()
  h = 1
  smail = {
    "🔥",
    "💥",
    "✅",
    "⚡",
    "☠️",
    "📜",
    "👻",
    "🎃",
    "🧨",
    "🔮",
    "🛡️",
    "💣",
    "📦"
  }
  i = math.random(#smail)
  ranl = smail[i]
  hm = gg.choice({
    "⚡ ℂℍ𝔼𝔸𝕋 𝕄𝔼ℕ𝕌 ⚡",
    "🚪 𝔼𝕏𝕀𝕋 🚪"
  }, nil, ranl .. " ᴠɪᴘ sᴄʀɪᴘᴛ " .. ranl)
  if hm == nil then
    HOMEDM = false
  else
    if hm == 1 then
      MENU()
    end
    
    if hm == 2 then
      EXIT()
    end
  end
end



function MENU()
  h = 2
  smail = {
    "🔥",
    "💥",
    "✅",
    "⚡",
    "☠️",
    "📜",
    "👻",
    "🎃",
    "🧨",
    "🔮",
    "🛡️",
    "💣",
    "📦"
  }
  i = math.random(#smail)
  ranl = smail[i]
  gm = gg.multiChoice({
    "🎨 𝙲𝚘𝚕𝚘𝚛𝙼𝚎𝚗𝚞 🎨",
    "🚜 tatu hack 🚜",
    "🚪 𝔼𝕏𝕀𝕋 🚪"
  }, nil, ranl .. " ᴠɪᴘ sᴄʀɪᴘᴛ " .. ranl)
  if gm == nil then
    HOMEDM = false
  else
    if gm[1] == true then
      colorm()
    end
    
    if gm[2] == true then
      TATU()
    end
    
    if gm[3] == true then
      EXIT()
    end
  end
end

function colorm()
  gg.setRanges(gg.REGION_CODE_APP)
  if stf == true then
    gg.searchNumber(sphr, gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
    gg.refineNumber(sphr, gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
    gg.getResults(99999)
    gg.editAll("0.5", gg.TYPE_FLOAT)
    gg.clearResults()
  end
  sph = gg.prompt({
    "🎨 𝙲𝚘𝚕𝚘𝚛𝙼𝚎𝚗𝚞 🎨\n[0;7]"
  }, {0}, {"number"})
  if sph == nil then
    return
  else
    if sph[1] == "0" then
      sphr = "0.5"
    end
    if sph[1] == "1" then
      sphr = "250"
    end
    if sph[1] == "2" then
      sphr = "500"
    end
    if sph[1] == "3" then
      sphr = "750"
    end
    if sph[1] == "4" then
      sphr = "999"
    end
    if sph[1] == "5" then
      sphr = "9999"
    end
    if sph[1] == "6" then
      sphr = "99999"
    end
    if sph[1] == "7" then
      sphr = "999999"
    end
  end
  gg.setRanges(gg.REGION_CODE_APP)
  gg.searchNumber("0.5", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
  gg.getResults(999)
  gg.editAll(sphr, gg.TYPE_FLOAT)
  gg.clearResults()
  gm[1] = false
  stf = true
  i = math.random(#smail)
  ranl = smail[i]
  gg.toast(ranl .. " 𝚂𝚄𝙲𝙲𝙴𝚂𝚂 " .. ranl)
end

function TATU()

gg.setRanges(gg.REGION_ANONYMOUS)
if tat == true then
  gg.searchNumber(tatu ,gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
revert = gg.getResults(20, nil, nil, nil, nil, nil, nil, nil, nil)
local t = gg.getResults(20, nil, nil, nil, nil, nil, nil, nil, nil)
for i, v in ipairs(t) do
	if v.flags == gg.TYPE_FLOAT then
		v.editAll = '"1.34000015259"'
		v.freeze = true
	end
end
gg.addListItems(t)
t = nil
    gg.clearResults()
    gg.clearResults()
  end
  tet = gg.prompt({
    "🚜 VISÃO AEREA🚜\n[0;7]"
  }, {0}, {"number"})
  if tet == nil then
    return
  else
    if tet[1] == "0" then
      rato = "1.34000015259"
    end
    if tet[1] == "1" then
      rato = "5"
    end
    if tet[1] == "2" then
      rato = "15"
    end
    if tet[1] == "3" then
      rato = "25"
    end
    if tet[1] == "4" then
      rato = "35"
    end
    if tet[1] == "5" then
      rato = "45"
    end
    if tet[1] == "6" then
      rato = "55"
    end
    if tet[1] == "7" then
      rato = "65"
    end
  end
  gg.setRanges(gg.REGION_ANONYMOUS)
  gg.searchNumber(rato ,gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
revert = gg.getResults(20, nil, nil, nil, nil, nil, nil, nil, nil)
local t = gg.getResults(20, nil, nil, nil, nil, nil, nil, nil, nil)
for i, v in ipairs(t) do
	if v.flags == gg.TYPE_FLOAT then
	
		v.editAll(rato)
		v.freeze = true
	end
end
gg.addListItems(t)
t = nil
    gg.clearResults()
  gm[2] = false
  tat = true
  i = math.random(#smail)
  ranl = smail[i]
  gg.toast(ranl .. " 𝚂𝚄𝙲𝙲𝙴𝚂𝚂 " .. ranl)
end


function EXIT()
  gg.clearResults()
  gg.setVisible(true)
  os.exit()
end

function rmp()
  if h == 1 then
    HOME()
  end
  if h == 2 then
    MENU()
  end
  end

while true do
  if gg.isVisible(true) then
    HOMEDM = true
    gg.setVisible(false)
  end
  if HOMEDM == true then
    rmp()
  end
end