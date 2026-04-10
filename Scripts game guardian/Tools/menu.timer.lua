
local running = false
local paused = false

local hours = 0
local minutes = 0
local seconds = 0

 function startTimer()
    running = true
    paused = false
    while running do
        if not paused then
            
            seconds = seconds + 1

                if seconds == 60 then
                seconds = 0
                minutes = minutes + 1
            end

                 if minutes == 60 then
                minutes = 0
                hours = hours + 1
            end

            local formattedTime = string.format("%02d:%02d:%02d", hours, minutes, seconds)

            gg.toast(formattedTime)

            gg.sleep(1000)
        else
            
            gg.sleep(100)
        end
        
        if gg.isVisible(true) then
            gg.setVisible(false)
            showMenu()
        end
    end
end

 function pauseTimer()
    paused = true
    gg.toast("paused in: " .. string.format("%02d:%02d:%02d", hours, minutes, seconds))
end

 function exitScript()
    running = false
    gg.toast("finish")
    os.exit()
end

 function showMenu()
    while true do
        local menuOptions = {'Start', 'pause', 'continue', 'exit'}
        if running and not paused then
            menuOptions[1] = 'restart'
        end
        local menu = gg.choice(menuOptions, nil, 'Menu timer')

        if menu == 1 then
            if not running then
                startTimer()
            else
                hours, minutes, seconds = 0, 0, 0
                paused = false
            end
        elseif menu == 2 then
            if running then
                pauseTimer()
            else
                gg.toast("no running")
            end
        elseif menu == 3 then
            if paused then
                paused = false
            else
                
            end
        elseif menu == 4 then
            exitScript()
        end
        
        break
    end
end

while true do
    if gg.isVisible(true) then
        gg.setVisible(false)
        showMenu()
    end
    gg.sleep(100)
end