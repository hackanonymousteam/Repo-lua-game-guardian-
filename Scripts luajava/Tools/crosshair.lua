gg.setVisible(true)
gg.alert("use orientation landscape")

function START3()
  menu = gg.choice({
    "  crooshair On",
    "  crosshair Off",
    "◖ EXIT ◗"
  })
  if menu == 1 then cross() end
  if menu == 2 then run() end
  if menu == 3 then exit3() end
  XGCK3 = -1
end

function cross()
  local sph = gg.prompt({
    "select radius [0;4]",
  }, {0}, {"number"})

  if sph == nil then return end

  local sphr = "20"

  if sph[1] == "0" then sphr = "20"
  elseif sph[1] == "1" then sphr = "50"
  elseif sph[1] == "2" then sphr = "100"
  elseif sph[1] == "3" then sphr = "200"
  elseif sph[1] == "4" then sphr = "300"
  
  
  end
run()
  fovv(sphr)
  os.exit()
end

function fovv(radius)
  local cx = 732.5
  local cy = 360
  drawCircle(cx, cy, radius)
  drawLine(cx - radius, cy, cx + radius, cy)
  drawLine(cx, cy - radius, cx, cy + radius)
  setColor("#FFFF1000")
end

function run()
  removeAll()
end

function exit3()
  print("⭐ creator : BATMAN GAMES")
  removeAll()
  os.exit()
end

while true do
  if gg.isVisible(true) then
    XGCK1 = 1
    gg.setVisible(false)
    gg.clearResults()
  end
  if XGCK1 == 1 then
    START3()
  end
  XGCK1 = -1
end