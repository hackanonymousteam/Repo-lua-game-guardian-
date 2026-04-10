File = luajava.bindClass("java.io.File")
Environment = luajava.bindClass("android.os.Environment")

function joinPaths(base, name)
  return base:gsub("/$", "") .. "/" .. name:gsub("^/", "")
end

function choiceFile(openPath)
  openPath = openPath:gsub("folder: ", "")
  local pathFile = File(openPath)
  local files = pathFile:listFiles()

  if files then
    local fileList = luajava.astable(files)
    local displayList = {}
    if openPath ~= "/sdcard" then
      displayList[1] = "back"
    end

    for i, f in ipairs(fileList) do
      local name = tostring(f):reverse():match("(.-)/"):reverse()
      if f:isDirectory() then
        table.insert(displayList, "folder: " .. name .. "/")
      else
        table.insert(displayList, "file: " .. name)
      end
    end

    if #displayList > 0 then
      local choice = gg.choice(displayList, nil, openPath)
      if choice then
        local selection = displayList[choice]
        if selection == "back" then
          choiceFile(oldPath)
        else

          local selectedPath = joinPaths(openPath, selection:gsub("folder: ", ""):gsub("file: ", ""))
          local selectedFile = File(selectedPath)
          if selectedFile:isDirectory() then
            oldPath = openPath
            choiceFile(selectedPath)
          else
            print("Selected file path: " .. selectedPath)

          end
        end
      end
    end
  end
end

openPath = Environment:getExternalStorageDirectory():getAbsolutePath()
choiceFile(openPath)