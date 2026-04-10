while true do
    local currentTime = os.time()
     local formattedTime = os.date("%H:%M:%S", currentTime)
    gg.toast(formattedTime)
    gg.sleep(1000)
end