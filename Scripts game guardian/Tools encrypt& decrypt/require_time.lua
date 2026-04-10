Protection = {}

function Protection.addTimeLimit(maxMinutes, errorMessage)
    if not maxMinutes then
        gg.alert("❌ invalid parameters")
        return false
    end
    Protection._startTime = os.time()
    Protection._maxTime = maxMinutes * 60
    Protection._msg = errorMessage or "❌ minutes exceeded!"
    function Protection.checkTime()
        local elapsed = os.time() - Protection._startTime
        if elapsed > Protection._maxTime then
            gg.alert(Protection._msg)
            os.exit()
        end
    end
    return true
end

function START3()
    local menu = gg.choice({ 
        "  function one",
        "  function two",
        "  function three",
        "◖ EXIT ◗"
    }, nil, "Choose an option")
    if menu == nil then return end
    if menu == 1 then fov() end
    if menu == 2 then run() end 
    if menu == 3 then re() end
    if menu == 4 then exit3() end
end

function fov()
    gg.alert("Function One executed")
end

function run()
    gg.alert("Function Two executed")
end

function re()
    gg.alert("Function Three executed")
end

function exit3()
    print("⭐ creator : BATMAN GAMES ")
    os.exit()
end

Protection.addTimeLimit(1, "Time expired!")
--time for expire script 1 minute
while true do
    if gg.isVisible(true) then
        gg.setVisible(false)
        gg.clearResults()
        Protection.checkTime()  
        START3()
    end
end