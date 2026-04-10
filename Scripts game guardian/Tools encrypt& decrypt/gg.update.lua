function up()
if gg.VERSION ==   "101.1" then
   else
        update()
    end
end

function update()
    local Alert = gg.alert("Update Game Guardian", "Agree e Download", "Cancel")

    if Alert == 1 then
        local Alert = gg.alert([[
            Your file is ready for download. Before downloading, you must agree to the following terms:
            - BlueStacks blocks the installation of GameGuardian. Install GG for Nox or use other emulators, not BlueStacks.
            - The Nox App Player (v6.0.8.0 - v6.2.7.1) blocks the installation of GameGuardian. Install GG for Nox, use other versions of Nox, or use other emulators, not Nox:
              Memu, LDPlayer, KoPlayer, Droid4X
            - Some antivirus software may mark GameGuardian as a virus. Most antivirus software will detect GameGuardian as a virus for financial reasons.
        ]], "Yes", "No")

        if Alert == 1 then
            local log = gg.prompt({
                "❦ GameGuardian 101.1.apk ",
                "❦ GameGuardian 101.1 for nox_bluestacks.apk ",
                "Exit"
            }, {false, false, false}, {"checkbox", "checkbox", "checkbox"})

            if log == nil then return end

            if log[1] then
                gg1()
            elseif log[2] then
                gg2()
            elseif log[3] then
                os.exit()
            end
        end
    end
end

function gg1()
    local Link = "https://gameguardian.net/forum/files/file/2-gameguardian/?do=download&r=50314&confirm=1&t=1&csrfKey=8853976879762ec670419634ae4dd157"
    local path = "/sdcard/Download/GameGuardian_101.1.apk"

    local response = gg.makeRequest(Link)
    if response.content == nil then
        print("Erro: download file.")
        return
    end

    local file = io.open(path, "wb")
    if file then
        file:write(response.content)
        file:close()
        print("Download sucess file save in /sdcard/Download/ ")
    else
        print("Erro: write file")
    end
end

function gg2()
    local Link = "https://gameguardian.net/forum/files/file/2-gameguardian/?do=download&r=50315&confirm=1&t=1&csrfKey=8853976879762ec670419634ae4dd157"
    local path = "/sdcard/Download/GameGuardian_101.1_for_nox_bluestacks.apk"

    local response = gg.makeRequest(Link)
    if response.content == nil then
        print("Erro: download file.")
        return
    end

    local file = io.open(path, "wb")
    if file then
        file:write(response.content)
        file:close()
        print("Download sucess file save in /sdcard/Download/ ")
    else
        print("Erro: write file")
    end
end

up()