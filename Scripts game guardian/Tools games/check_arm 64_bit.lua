gg.setVisible(true)

local function checkTargetInfo()
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
        gg.toast("🥰🥰🥰🥰")
    else
   
        print('no work in 32 bit')
        os.exit()
    end
end

checkTargetInfo()


--check armeabi 64bit