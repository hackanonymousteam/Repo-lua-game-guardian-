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
  g.info = gg.prompt({
    'Select folder:', -- 1
    'Create file site HTML', -- 4
  }, g.info, {
    'path', -- 1
    'checkbox', -- 3
  })

  gg.saveVariable(g.info, g.config)
  g.last = g.info[1]

  if g.last == nil or g.last == "" then
    gg.alert("⚠️ Folder cannot be empty! ⚠️")
    return
  end

  g.out = g.last .. "/mySite.html"

  local DATA = ""

  if g.info[2] == true then
    start = gg.prompt({
      "✏️ title site",
      "✏️ text 1",
      "✏️ text 2",
      "✏️ text 3",
      "✏️ link",
      "✏️ site by",
    }, {
      "my site",
      "text 1",
      "text 2",
      "text 3",
      "your link",
      "your name",
    }, {
      "text",
      "text",
      "text",
      "text",
      "text",
      "text",
    })

    if start[1] == nil or start[2] == nil or start[3] == nil or start[4] == nil or start[5] == nil or start[6] == nil then
      gg.alert("⚠️ Function names cannot be empty!")
    else
      print("⚠️ Site created: True√ ")

      DATA = '\n<!DOCTYPE html>\n' ..
             '<html lang="pt-br">\n' ..
             '<head>\n' ..
             '  <meta charset="UTF-8">\n' ..
             '  <meta http-equiv="X-UA-Compatible" content="IE=edge">\n' ..
             '  <meta name="viewport" content="width=device-width, initial-scale=1.0">\n' ..
             '  <link rel="shortcut icon" href="img/favicon-16x16.png" type="image/x-icon">\n' ..
             '  <title>' .. start[1] .. '</title>\n' ..
             '</head>\n' ..
             '<body>\n' ..

             '  <h1 class="title"><font style="vertical-align: inherit;">' ..
             '    <font style="vertical-align: inherit;">' .. start[1] .. '</font></font>' ..
             '  </h1>\n' ..
             '  <p><font style="vertical-align: inherit;"><font style="vertical-align: inherit;">' .. start[2] .. '' ..
             '    <font style="vertical-align: inherit;"></font></font></p>\n' ..

             '  <p><font style="vertical-align: inherit;"><font style="vertical-align: inherit;">' .. start[3] .. '' ..
             ' </font><font style="vertical-align: inherit;"></font></p>\n' ..

             '  <p><font style="vertical-align: inherit;"><font style="vertical-align: inherit;">' .. start[4] .. '' ..
             '  </font><font style="vertical-align: inherit;"></font></p>\n' ..

             '  <div class="widget"><h3><span>suport</span></h3>\n' ..
             '    <li><a href="' .. start[5] .. '"><font style="vertical-align: inherit;"><font style="vertical-align: inherit;">click</font></font></a></li>\n' ..
             '  </div>\n' ..

             '  <div class="copyright-footer">\n' ..
             '    <p><font style="vertical-align: inherit;"><font style="vertical-align: inherit;">' .. start[6] .. '</font></font></p>\n' ..
             '  </div>\n' ..

             '</body>\n' ..
             '</html>'
    end

    io.open(g.out, "w"):write(DATA):close()

    ClU = '📂 File Saved To: ' .. g.out .. '\n'
    gg.alert(ClU, '')
    print("\n▬▬▬▬▬▬▬▬▬▬▬▬▬\n📂 File HTML Saved To :" .. g.out .. "\n▬▬▬▬▬▬▬▬▬▬▬▬▬")
    return
  end
end