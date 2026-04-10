function clearAnsi(txt)
    txt = txt:gsub("\27%[[%d;]*[a-zA-Z]", "") -- remove ANSI
    txt = txt:gsub("[%c]", "\n")              -- replace invisible chars with \n
    return txt
end

function showCommand(title, command)
    local raw = gg.shell(command)
    if raw and raw ~= "" then
        local clean = clearAnsi(raw)
        gg.alert(title .. ":\n\n" .. clean)
    else
        gg.alert("⚠️ No output.")
    end
end

function menu()
    local options = {
        "📊 CPU Usage (top)",
        "🧠 Memory (RAM)",
        "📋 Active Processes",
        "💾 Free Space (/data)",
        "🔋 Battery Status",
        "⏳ Uptime",
        "🌡️ System Temperature",
        "🎮 GPU (OpenGL Renderer)",
        "📱 Running Apps",
        "❌ Exit"
    }

    while true do
        local choice = gg.choice(options, nil, "🔍 Advanced System Monitoring")
        if not choice or choice == #options then break end

        if choice == 1 then
            showCommand("CPU Usage", "top -n 1 -m 5")
        elseif choice == 2 then
            showCommand("RAM Memory", "cat /proc/meminfo")
        elseif choice == 3 then
            local raw = gg.shell("top -n 1 -m 5")
            local clean = clearAnsi(raw)
            local lines = {}
            for line in clean:gmatch("[^\n]+") do
                if line:find("^%s*%d+") then
                    table.insert(lines, line)
                end
            end
            gg.alert("📋 Processes:\n\n" .. table.concat(lines, "\n"))
        elseif choice == 4 then
            showCommand("Free Space in /data", "df /data")
        elseif choice == 5 then
            showCommand("Battery Status", "dumpsys battery")
        elseif choice == 6 then
            showCommand("Uptime", "uptime")
        elseif choice == 7 then
            showCommand("Temperature (thermal)", "cat /sys/class/thermal/thermal_zone0/temp")
        elseif choice == 8 then
            showCommand("GPU Info", "dumpsys SurfaceFlinger | grep GLES")
        elseif choice == 9 then
            showCommand("Running Apps", "dumpsys activity recents | grep 'Recent #0'")
        end
    end
end

menu()