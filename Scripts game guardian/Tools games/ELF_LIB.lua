function Batman(lib, offset, data)
    local info = gg.getTargetInfo()
    local pack = info.nativeLibraryDir
    local ranges = gg.getRangesList(pack .. "/lib" .. lib .. ".so")

    for _, range in ipairs(ranges) do
        if gg.getValues({{address = range.start, flags = gg.TYPE_DWORD}})[1].value == 0x464C457F then
            local address = range.start + offset
            local values = {}
            for i = 1, #data, 2 do
                local byte = tonumber(data:sub(i, i+1), 16)
                table.insert(values, {address = address + i//2, flags = gg.TYPE_BYTE, value = byte})
            end
            gg.setValues(values)
            return true
        end
    end
    return false
end

function START()
    menu = gg.choice({ 
        "➣ 👥 FUNCTION  I👥",
        " ❎SAIR ❎ "
    })
    
    if menu == 1 then antenas() end
    if menu == 2 then  exit() end
    XGCK= -1
end

function antenas()
    Batman("il2cpp", 0x4 , 5.0) 
    gg.toast("🤷  on✔️🤷")
end 

function exit()
    gg.toast("🇧🇷Saindo da Script🇧🇷")
    print(" \n🧙🏻‍♂️CRIADOR: BATMAN GAMES🧙🏻‍♂️")
    os.exit()
end

while true do
    if gg.isVisible(true) then
        XGCK = 1
        gg.setVisible(false)
        gg.clearResults()
    end
    if XGCK == 1 then
        START()
    end
    XGCK = -1
end