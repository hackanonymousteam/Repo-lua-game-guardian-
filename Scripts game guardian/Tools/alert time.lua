local hour = tonumber(os.date('%H'))

if hour >= 5 and hour < 12 then
    gg.alert("🌅 Good Morning! ☕\n\nWishing you a refreshing start to your day! ✨")
    gg.toast("🌅 Good Morning! ☀️")
elseif hour >= 12 and hour < 18 then
    gg.alert("🌞 Good Afternoon! 🍂\n\nHope you're having a productive day! 💼")
    gg.toast("🌞 Good Afternoon! 🌻")
else
    gg.alert("🌙 Good Evening! 🌌\n\nRelax and unwind, the night is yours. 🌠")
    gg.toast("🌙 Good Evening! 🛌")
end