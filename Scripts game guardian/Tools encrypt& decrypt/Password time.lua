password = "123"
maxTime = 5

function enterPassword()
  startTime = os.time()
  userPassword = gg.prompt({"🅰🅳🅼🅸🅽 🅿🅰🆂🆂🆆🅾🆁🅳"}, nil, {"number"})[1]
  endTime = os.time()
  elapsedTime = os.difftime(endTime, startTime)
  return userPassword, elapsedTime
end

userPassword, elapsedTime = enterPassword()

if elapsedTime > maxTime then
  gg.alert("Yᴏᴜ ᴀʀᴇ ɴᴏᴛ ᴀɴ ᴀᴅᴍɪɴɪsᴛʀᴀᴛᴏʀ")
  os.exit()
else
  if userPassword == password then
    gg.alert("❖ʜᴇʟʟᴏ ғʀɪᴇɴᴅ, ɢʟᴀᴅ ᴛᴏ sᴇᴇ ʏᴏᴜ!")
  else
    gg.alert("❖Iɴᴠᴀʟɪᴅ ᴘᴀssᴡᴏʀᴅ!")
    os.exit()
  end
end