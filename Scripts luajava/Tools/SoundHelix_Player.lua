gg.setVisible(true)

local MediaPlayer = luajava.bindClass("android.media.MediaPlayer")
local AudioManager = luajava.bindClass("android.media.AudioManager")

local player = nil
local musicas = {
    "SoundHelix Song 1",
    "SoundHelix Song 2",
    "SoundHelix Song 3",
    "SoundHelix Song 4",
    "SoundHelix Song 5",
    "SoundHelix Song 6",
    "SoundHelix Song 7",
    "SoundHelix Song 8",
    "SoundHelix Song 9",
    "SoundHelix Song 10"
}

local function gerarURL(index)
    return "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-" .. index .. ".mp3"
end

local function parar()
    if player ~= nil then
        pcall(function()
            player.stop()
            player.release()
        end)
        player = nil
        gg.toast("⏹ stoped")
    end
end

local function pausar()
    if player ~= nil then
        pcall(function()
            if player.isPlaying() then
                player.pause()
                gg.toast("⏸ ended")
            end
        end)
    end
end

local function tocar(index)
    parar()

    player = MediaPlayer()
    player.setAudioStreamType(AudioManager.STREAM_MUSIC)

    local url = gerarURL(index)

    local ok, err = pcall(function()
        player.setDataSource(url)
        player.prepareAsync()

        player.setOnPreparedListener({
            onPrepared = function(mp)
                mp.start()
                gg.toast("▶ playng: " .. musicas[index])
            end
        })
    end)

    if not ok then
        gg.toast("Erro: " .. tostring(err))
        player = nil
    end
end

local function menuPrincipal()
    local op = gg.choice({
        "🎵 choose music",
        "⏸ pause",
        "⏹ stop",
        "❌ exit"
    }, nil, "SoundHelix Player")

    if op == 1 then
        local escolha = gg.choice(musicas, nil, "choose music")
        if escolha then
            tocar(escolha)
        end

    elseif op == 2 then
        pausar()

    elseif op == 3 then
        parar()

    elseif op == 4 then
        parar()
        os.exit()
    end
end
gg.toast("SoundHelix Player started")

while true do
    if gg.isVisible(true) then
        gg.setVisible(false)
        menuPrincipal()
    end
    gg.sleep(100)
end