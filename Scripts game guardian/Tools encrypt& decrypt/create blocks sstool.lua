function START3()
    menu = gg.choice({ 
        " CREATE BLOCK SSTOLL",
        " CREATE BLOCK ANTILOG ",
        " CREATE BLOCK ANTILOG II ",
        "◖ EXIT ◗"
    })
    if menu == 1 then block() end 
    if menu == 2 then log() end
    if menu == 3 then log2() end
    if menu == 4 then exit3() end
    XGCK3 = -1
end

function block()
    local alert = gg.prompt({
        "🔐 Set name I for block:",
        "🔐 Set name II for block:"
    }, {
        "",
        ""
    }, {
        "text",
        "text"
    })
    
    if not alert then
        gg.setVisible(true)
    elseif alert[1] == "" or alert[2] == "" then
        gg.alert("⚠️ Input name!")
        gg.setVisible(true)
    else
        local name1 = alert[1]
        local name2 = alert[2]
        
        local block_template = [[
for x = 0, 1, 0 do
    local _ss = {}
    if _ss.ss ~= nil then
        _ss.bidun = _ss.ss()
        _ss.ss = nil -nil+nil-nil*nil*nil*nil*nil*nil*nil*nil*nil*nil*nil*nil*nil*nil*nil*nil*nil*nil*nil*nil*nil*nil*nil*nil*nil*nil*nil*nil*nil*nil*nil*nil*nil*nil*nil*nil*nil*nil*nil*nil*nil*nil*nil*nil*nil*nil*nil*nil*nil*nil*nil*nil*nil*nil*nil*nil*nil*nil*nil*nil*nil*nil*nil*nil*nil*nil*nil*nil*nil*nil*nil*nil*nil/nil%nil~nil~~~nil%#nil
    end
    _ss = nil -nil+nil-nil*nil/nil%nil~nil~~~nil%#nil
end
]]
        local block = string.gsub(block_template, "ss", name1)
        block = string.gsub(block, "bidun", name2)
        
        gg.alert("🔐 Added block  : True✔")
        gg.alert(block)
        print(block)  
 gg.setVisible(true)
 os.exit()
  end
end

function log()
    local alert = gg.prompt({
        "🔐 Set name I for antilog:",
        "🔐 Set name II for antilog:"
    }, {
        "",
        ""
    }, {
        "text",
        "text"
    })
    
    if not alert then
        gg.setVisible(true)
    elseif alert[1] == "" or alert[2] == "" then
        gg.alert("⚠️ Input name!")
        gg.setVisible(true)
    else
        local name1 = alert[1]
        local name2 = alert[2]
        
        local antilog = [[
MYOH1=string.rep("MakeYourOwnHacks",99999)
MYOH=string.rep(MYOH1,99)
for i=1,9999 do
    gg.refineAddress({[1]=MYOH})
end
for i=1,9999 do
    gg.refineNumber({[1]=MYOH})
end
]]
        local block = string.gsub(antilog, "MYOH", name1)
        block = string.gsub(block, "MakeYourOwnHacks", name2)
        
        gg.alert("🔐 Added antilog  : True✔")
        gg.alert(block)
        print(block)  
  gg.setVisible(true)
 os.exit()
  end
end

function log2()
    local alert = gg.prompt({
        "🔐 Set name I for antilog:",
        "🔐 Set name II for alert antilog:"
    }, {
        "",
        ""
    }, {
        "text",
        "text"
    })
    
    if not alert then
        gg.setVisible(true)
    elseif alert[1] == "" or alert[2] == "" then
        gg.alert("⚠️ Input name!")
        gg.setVisible(true)
    else
        local name1 = alert[1]
        local name2 = alert[2]
        
        local antilog2 = [[
local Text = "batman"
local Rep = 9999 --Time to repeat
for k,v in pairs(gg) do
    if type(v) == "function" and k ~= "isPackageInstalled" then
        def = function(...)
            gg.isPackageInstalled(Text:rep(Rep))
            return v(table.unpack({...}))
        end
        _G["gg"][k] = def
    end
end
gg.alert("lol")
]]
        local block = string.gsub(antilog2, "batman", name1)
        block = string.gsub(block, "lol", name2)
        
        gg.alert("🔐 Added antilog  : True✔")
        gg.alert(block)
        print(block)  
   gg.setVisible(true)
 os.exit()
  end
end

function exit3()
    print("--⭐ creator : BATMAN GAMES ")
    os.exit()
end

while true do
    if gg.isVisible(true) then
        XGCK1 = 1
        gg.setVisible(false)
        gg.clearResults()
    end
    if XGCK1 == 1 then
        START3()
    end
    XGCK1 = -1
end