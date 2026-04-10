-- create by Batman Games 
g = {}
g.last = "/sdcard"
g.info = nil
g.config = gg.EXT_CACHE_DIR .. "/" .. gg.getFile():match("[^/]+$") .. "cfg"
g.data = loadfile(g.config)
if g.data ~= nil then
  g.info = g.data()
  g.data = nil
end
if g.info == nil then
  g.info = {
    g.last,
    g.last:gsub("/[^/]+$", "")
  }
end
while true do
  ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

  g.info = gg.prompt({
    ' Select folder :', -- 1
    ' Add toast initial', -- 2
    ' create script', -- 4
  }, g.info, {
    'path', -- 1
    'checkbox', -- 2
    'checkbox', -- 3
      })
  ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

  gg.saveVariable(g.info, g.config)
  g.last = g.info[1]
  if g.last == nil or g.last == "" then
    return gg.alert("⚠️ Folder cannot be empty! ⚠️")
  end
  g.out = g.last .. "/new_script.lua"
  ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local TOAST = ""
 
if g.info[2] == true then
_toast_ = gg.prompt({
"✏️ Set Your toast",
}, {"my toast"},{
"text"})
end
if not _toast_ then
gg.setVisible(true)
elseif _toast_[1] == nil then
gg.alert("⚠️ Can Not be Empty!")
gg.setVisible(true)
else
print("⚠ SetToast : True√ ")
TOAST = '\ngg.toast("' .. _toast_[1] .. '")\n' .. TOAST
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local DATA = ""
if g.info[3] == true then
  start = gg.prompt({
    "✏️ Set name function 1",
    "✏️ Set name function 2",
    "✏️ Set name function 3",
    "✏️ Set name function 4",
    "✏️ Set name function 5",
    "✏️ Set name function 6",
    "✏️ script by: your name",
  }, {
    "my function 1",
    "my function 2",
    "my function 3",
    "my function 4",
    "my function 5",
    "Exit",
    "script by: your name",
  }, {
    "text",
    "text",
    "text",
    "text",
    "text",
    "text",
    "text",
  })
end

if not start then
  gg.setVisible(true)
elseif start[1] == nil or start[2] == nil or start[3] == nil or start[4] == nil or start[5] == nil or start[6] == nil then
  gg.alert("⚠️ Function names cannot be empty!")
  gg.setVisible(true)
else
  print("⚠ SetFunction GG : True√ ")
  DATA = '\nfunction START()\n  menu = gg.choice({\n' ..
    '    "' .. start[1] .. '",\n' ..
    '    "' .. start[2] .. '",\n' ..
    '    "' .. start[3] .. '",\n' ..
    '    "' .. start[4] .. '",\n' ..
    '    "' .. start[5] .. '",\n' ..
    '    "' .. start[6] .. '"\n  }, nil, "' .. start[7] .. '")\n\n' ..
    '  if menu == 1 then a() end\n' ..
    '  if menu == 2 then b() end\n' ..
    '  if menu == 3 then c() end\n' ..
    '  if menu == 4 then d() end\n' ..
    '  if menu == 5 then e() end\n' ..
    '  if menu == 6 then exit() end\n  XGCK = -1\nend\n' ..
    'function a()\n  --insert code here\n  gg.toast(\'function "' .. start[1] .. '" active\')\nend\n' ..
    'function b()\n  --insert code here\n  gg.toast(\'function "' .. start[2] .. '" active\')\nend\n' ..
    'function c()\n  --insert code here\n  gg.toast(\'function "' .. start[3] .. '" active\')\nend\n' ..
    'function d()\n  --insert code here\n  gg.toast(\'function "' .. start[4] .. '" active\')\nend\n' ..
    'function e()\n  --insert code here\n  gg.toast(\'function "' .. start[5] .. '" active\')\nend\n' ..
    'function exit()\n  --insert code here\n  gg.toast(\'function "' .. start[6] .. '" active\')\n' ..
    '  gg.toast("🇧🇷exit Script🇧🇷")\n' ..
    '  print("☆┌─┐   .─┐☆")\n' ..
    '  print("    │▒│ /▒/      ")\n' ..
    '  print("    │▒│/▒/       ")\n' ..
    '  print("    │▒/▒/─┬─┐")\n' ..
    '  print("    │▒│▒|▒│▒│ ")\n' ..
    '  print("┌┴─┴─┐-┘─┘  ")\n' ..
    '  print("│▒┌──┘▒▒▒│ ")\n' ..
    '  print("└┐▒▒▒▒▒▒┌┘")\n' ..
    '  print("    └┐▒▒▒▒┌┘")\n' ..
    '  gg.clearResults()\n' ..
    '  os.exit()\n' ..
    'end\n' ..
    'while true do\n' ..
    '  if gg.isVisible(true) then\n' ..
    '    XGCK = 1\n' ..
    '    gg.setVisible(false)\n' ..
    '  end\n' ..
    '  if XGCK == 1 then\n' ..
    '    START()\n' ..
    '  end\n' ..
    '  XGCK = -1\n' ..
    'end\n' .. DATA
end
  ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

io.open(g.out, "w"):write(TOAST .. "\n\n" .. DATA):close()
  ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

  ClU = '📂 File Saved To: ' .. g.out .. '\n'
  gg.alert(ClU, '')
  print("\n▬▬▬▬▬▬▬▬▬▬▬▬▬\n📂 File Saved To :" .. g.out .. "\n▬▬▬▬▬▬▬▬▬▬▬▬▬")
  return
end