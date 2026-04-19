gg.setVisible(false)

local bit = bit32 or bit
if not bit then
  gg.alert("Error: bit32 not available")
  return
end

local band, bor, lshift, rshift = bit.band, bit.bor, bit.lshift, bit.rshift

local Color = luajava.bindClass("android.graphics.Color")
local Context = luajava.bindClass("android.content.Context")
local Typeface = luajava.bindClass("android.graphics.Typeface")
local GradientDrawable = luajava.bindClass("android.graphics.drawable.GradientDrawable")
local Build = luajava.bindClass("android.os.Build")
local Handler = luajava.bindClass("android.os.Handler")
local Looper = luajava.bindClass("android.os.Looper")
local TypedValue = luajava.bindClass("android.util.TypedValue")
local Gravity = luajava.bindClass("android.view.Gravity")
local View = luajava.bindClass("android.view.View")
local WindowManager = luajava.bindClass("android.view.WindowManager")
local LayoutParams = luajava.bindClass("android.view.WindowManager$LayoutParams")
local LinearLayout = luajava.bindClass("android.widget.LinearLayout")
local LinLayoutParams = luajava.bindClass("android.widget.LinearLayout$LayoutParams")
local TextView = luajava.bindClass("android.widget.TextView")
local EditText = luajava.bindClass("android.widget.EditText")
local Button = luajava.bindClass("android.widget.Button")
local ScrollView = luajava.bindClass("android.widget.ScrollView")
local FrameLayout = luajava.bindClass("android.widget.FrameLayout")
local Runnable = luajava.bindClass("java.lang.Runnable")
local InputMethodManager = luajava.bindClass("android.view.inputmethod.InputMethodManager")
local InputFilter = luajava.bindClass("android.text.InputFilter")
local InputFilterAllCaps = luajava.bindClass("android.text.InputFilter$AllCaps")
local ClipboardManager = luajava.bindClass("android.content.ClipboardManager")
local ClipData = luajava.bindClass("android.content.ClipData")
local ObjectAnimator = luajava.bindClass("android.animation.ObjectAnimator")
local AnimatorSet = luajava.bindClass("android.animation.AnimatorSet")
local AccelerateDecelerateInterpolator = luajava.bindClass("android.view.animation.AccelerateDecelerateInterpolator")
local ProgressDialog = luajava.bindClass("android.app.ProgressDialog")
local File = luajava.bindClass("java.io.File")
local TextWatcher = luajava.bindClass("android.text.TextWatcher")

local mainHandler = Handler(Looper.getMainLooper())

local UI = {
  BG = Color.parseColor("#0d061f"),
  CARD = Color.parseColor("#1a0f30"),
  ACCENT = Color.parseColor("#a42cff"),
  ACCENT_PINK = Color.parseColor("#ff33cc"),
  TEXT = Color.parseColor("#d1baff"),
  TEXT_DARK = Color.parseColor("#FF303030"),
  TEXT_HINT = Color.parseColor("#a42cff80"),
  DANGER = Color.parseColor("#ff4444"),
  SUCCESS = Color.parseColor("#6aff6a"),
  BTN_DARK = Color.parseColor("#2e1c50"),
  BTN_LIGHT = Color.parseColor("#3d2666"),
  WHITE = Color.parseColor("#FFFFFF"),
  BLACK = Color.parseColor("#000000"),
  RADIUS = 25
}

local state = {
  filePath = "",
  fileSize = 0,
  currentOffset = 0,
  bytesPerPage = 32,
  modified = false,
  undoStack = {},
  redoStack = {},
  maxUndo = 30,
  isUndoRedoOperation = false,
  fileData = nil,
  hexCells = {},
  pageLabel = nil,
  filePathInput = nil,
  hexContainer = nil,
  navContainer = nil,
  dumpBtn = nil,
  isUpdatingCells = false
}

local exit = false
local mainView = nil
local activeView = nil
local windowManager = nil
local mParams = nil
local WIDTH = 400
local progressDialog = nil

local function dp(v)
  return math.floor(TypedValue.applyDimension(1, v, activity.getResources().getDisplayMetrics()))
end

local function getSkin(color, radius, strokeWidth, strokeColor)
  local draw = GradientDrawable()
  draw.setColor(color)
  draw.setCornerRadius(dp(radius))
  if strokeColor then
    draw.setStroke(dp(strokeWidth or 1), strokeColor)
  end
  return draw
end

local function animateViewIn(view)
  if not view then return end
  pcall(function()
    local scaleX = ObjectAnimator.ofFloat(view, "scaleX", {0.7, 1.05, 1.0})
    local scaleY = ObjectAnimator.ofFloat(view, "scaleY", {0.7, 1.05, 1.0})
    local alpha = ObjectAnimator.ofFloat(view, "alpha", {0.0, 1.0})
    scaleX.setDuration(300)
    scaleY.setDuration(300)
    alpha.setDuration(300)
    local set = AnimatorSet()
    set.playTogether({scaleX, scaleY, alpha})
    set.setInterpolator(AccelerateDecelerateInterpolator())
    set.start()
  end)
end

local function showToast(text)
  mainHandler.post(Runnable({
    run = function()
      gg.toast(text)
    end
  }))
end

local function showProgress(title, message)
  mainHandler.post(Runnable({
    run = function()
      progressDialog = ProgressDialog(activity)
      progressDialog.setTitle(title)
      progressDialog.setMessage(message)
      progressDialog.setCancelable(false)
      progressDialog.show()
    end
  }))
end

local function hideProgress()
  mainHandler.post(Runnable({
    run = function()
      if progressDialog then
        progressDialog.dismiss()
        progressDialog = nil
      end
    end
  }))
end

local function hideKeyboard()
  pcall(function()
    local imm = activity.getSystemService(Context.INPUT_METHOD_SERVICE)
    local currentFocus = activity.getCurrentFocus()
    if currentFocus then
      imm.hideSoftInputFromWindow(currentFocus.getWindowToken(), 0)
    end
  end)
end

local function forceShowKeyboard(inputField)
  if inputField then
    inputField.requestFocus()
    inputField.post(Runnable({
      run = function()
        local imm = activity.getSystemService(Context.INPUT_METHOD_SERVICE)
        imm.showSoftInput(inputField, InputMethodManager.SHOW_FORCED)
      end
    }))
  end
end

local function pasteFromClipboard(inputField)
  pcall(function()
    local clipboard = activity.getSystemService(Context.CLIPBOARD_SERVICE)
    local clip = clipboard.getPrimaryClip()
    if clip and clip.getItemCount() > 0 then
      local pastedText = clip.getItemAt(0).getText()
      if pastedText and inputField then
        inputField.setText(pastedText)
        inputField.setSelection(#pastedText)
        showToast("Path pasted!")
      end
    else
      showToast("Empty clipboard")
    end
  end)
end

local function readUInt8(data, offset)
  return data:byte(offset + 1) or 0
end

local function readUInt16(data, offset)
  local b1, b2 = data:byte(offset + 1, offset + 2)
  return bor(b1 or 0, lshift(b2 or 0, 8))
end

local function readUInt32(data, offset)
  local b1, b2, b3, b4 = data:byte(offset + 1, offset + 4)
  return bor(b1 or 0, lshift(b2 or 0, 8), lshift(b3 or 0, 16), lshift(b4 or 0, 24))
end

local function readUInt64(data, offset)
  local low = readUInt32(data, offset)
  local high = readUInt32(data, offset + 4)
  return low + high * 4294967296
end

local function writeUInt8(val)
  return string.char(band(val, 0xFF))
end

local function formatSize(size)
  if size < 1024 then
    return size .. " B"
  elseif size < 1048576 then
    return string.format("%.2f KB", size / 1024)
  elseif size < 1073741824 then
    return string.format("%.2f MB", size / 1048576)
  else
    return string.format("%.2f GB", size / 1073741824)
  end
end

local function loadFileInBackground(filePath, callback)
  local thread = luajava.createProxy("java.lang.Runnable", {
    run = function()
      local f = io.open(filePath, "rb")
      if not f then
        mainHandler.post(Runnable({
          run = function()
            hideProgress()
            callback(false, "Error opening file")
          end
        }))
        return
      end
      
      local size = f:seek("end")
      
      if size > 100 * 1024 * 1024 then
        f:close()
        mainHandler.post(Runnable({
          run = function()
            hideProgress()
            callback(false, "File too large (>100MB)")
          end
        }))
        return
      end
      
      f:seek("set", 0)
      local data = f:read("*all")
      f:close()
      
      if not data then
        mainHandler.post(Runnable({
          run = function()
            hideProgress()
            callback(false, "Error reading file")
          end
        }))
        return
      end
      
      mainHandler.post(Runnable({
        run = function()
          state.filePath = filePath
          state.fileSize = #data
          state.currentOffset = 0
          state.fileData = data
          state.modified = false
          state.undoStack = {}
          state.redoStack = {}
          
          state.hexContainer.setVisibility(View.VISIBLE)
          state.navContainer.setVisibility(View.VISIBLE)
          state.dumpBtn.setVisibility(View.VISIBLE)
          
          hideProgress()
          updateHexDisplay()
          callback(true, nil)
        end
      }))
    end
  })
  
  luajava.newInstance("java.lang.Thread", thread):start()
end

function saveFileInBackground(callback)
  if not state.fileData or state.filePath == "" then
    callback(false, "No data to save")
    return
  end
  
  local thread = luajava.createProxy("java.lang.Runnable", {
    run = function()
      local newPath = state.filePath .. ".mod"
      local f = io.open(newPath, "wb")
      if not f then
        mainHandler.post(Runnable({
          run = function()
            hideProgress()
            callback(false, "Error opening for write")
          end
        }))
        return
      end
      
      local ok = f:write(state.fileData)
      f:close()
      
      if not ok then
        mainHandler.post(Runnable({
          run = function()
            hideProgress()
            callback(false, "Error writing file")
          end
        }))
        return
      end
      
      mainHandler.post(Runnable({
        run = function()
          loadFileInBackground(newPath, function(success, err)
            if success then
              state.modified = false
              callback(true, nil)
            else
              callback(false, err)
            end
          end)
        end
      }))
    end
  })
  
  luajava.newInstance("java.lang.Thread", thread):start()
end

local function parseELFInBackground(filePath, callback)
  local thread = luajava.createProxy("java.lang.Runnable", {
    run = function()
      local f = io.open(filePath, "rb")
      if not f then
        mainHandler.post(Runnable({
          run = function()
            hideProgress()
            callback(false, "Error opening file", nil)
          end
        }))
        return
      end
      
      local header = f:read(64)
      f:close()
      
      if not header or header:sub(1, 4) ~= "\x7FELF" then
        mainHandler.post(Runnable({
          run = function()
            hideProgress()
            callback(false, "File is not a valid ELF", nil)
          end
        }))
        return
      end
      
      local ei_class = header:byte(5)
      local is64bit = (ei_class == 2)
      
      f = io.open(filePath, "rb")
      local elf = f:read("*all")
      f:close()
      
      local result = { is64bit = is64bit, dynamicSymbols = {} }
      
      local e_shoff, e_shentsize, e_shnum, e_shstrndx
      
      if is64bit then
        e_shoff = readUInt64(elf, 0x28)
        e_shentsize = readUInt16(elf, 0x3A)
        e_shnum = readUInt16(elf, 0x3C)
        e_shstrndx = readUInt16(elf, 0x3E)
      else
        e_shoff = readUInt32(elf, 0x20)
        e_shentsize = readUInt16(elf, 0x2E)
        e_shnum = readUInt16(elf, 0x30)
        e_shstrndx = readUInt16(elf, 0x32)
      end
      
      if e_shoff + e_shnum * e_shentsize <= #elf then
        local function readSection(idx)
          if idx < 0 or idx >= e_shnum then return nil end
          local off = e_shoff + idx * e_shentsize
          
          if is64bit then
            return {
              name = readUInt32(elf, off),
              offset = readUInt64(elf, off + 0x18),
              size = readUInt64(elf, off + 0x20),
              entsize = readUInt64(elf, off + 0x38)
            }
          else
            return {
              name = readUInt32(elf, off),
              offset = readUInt32(elf, off + 0x10),
              size = readUInt32(elf, off + 0x14),
              entsize = readUInt32(elf, off + 0x24)
            }
          end
        end
        
        local shstr = readSection(e_shstrndx)
        if shstr then
          local shstrData = elf:sub(shstr.offset + 1, shstr.offset + shstr.size)
          
          local function getSectionName(offset)
            return shstrData:match("([^%z]+)%z", offset + 1) or "UNKNOWN"
          end
          
          local dynsym, dynstr = nil, nil
          
          for i = 0, e_shnum - 1 do
            local sec = readSection(i)
            if sec then
              local name = getSectionName(sec.name)
              if name == ".dynsym" then
                dynsym = sec
              elseif name == ".dynstr" then
                dynstr = sec
              end
            end
          end
          
          if dynsym and dynstr then
            local dynstrData = elf:sub(dynstr.offset + 1, dynstr.offset + dynstr.size)
            local count = math.floor(dynsym.size / dynsym.entsize)
            
            for j = 0, count - 1 do
              local symOff = dynsym.offset + j * dynsym.entsize
              local nameOffset = readUInt32(elf, symOff)
              local name = dynstrData:match("([^%z]+)%z", nameOffset + 1)
              if name and name ~= "" then
                table.insert(result.dynamicSymbols, name)
              end
            end
          end
        end
      end
      
      mainHandler.post(Runnable({
        run = function()
          hideProgress()
          callback(true, nil, result)
        end
      }))
    end
  })
  
  luajava.newInstance("java.lang.Thread", thread):start()
end

local function writeByte(offset, value)
  if offset < 0 or offset >= state.fileSize then
    return false
  end
  
  if not state.isUndoRedoOperation then
    local oldByte = state.fileData:sub(offset + 1, offset + 1)
    table.insert(state.undoStack, {offset = offset, oldData = oldByte, newData = writeUInt8(value)})
    if #state.undoStack > state.maxUndo then
      table.remove(state.undoStack, 1)
    end
    state.redoStack = {}
  end
  
  local before = state.fileData:sub(1, offset)
  local after = state.fileData:sub(offset + 2)
  state.fileData = before .. writeUInt8(value) .. after
  state.modified = true
  
  return true
end

local function undo()
  if #state.undoStack == 0 then return false end
  
  state.isUndoRedoOperation = true
  local action = table.remove(state.undoStack)
  local currentByte = state.fileData:sub(action.offset + 1, action.offset + 1)
  
  local before = state.fileData:sub(1, action.offset)
  local after = state.fileData:sub(action.offset + 2)
  state.fileData = before .. action.oldData .. after
  
  table.insert(state.redoStack, {offset = action.offset, oldData = currentByte, newData = action.oldData})
  state.isUndoRedoOperation = false
  return true
end

local function redo()
  if #state.redoStack == 0 then return false end
  
  state.isUndoRedoOperation = true
  local action = table.remove(state.redoStack)
  local currentByte = state.fileData:sub(action.offset + 1, action.offset + 1)
  
  local before = state.fileData:sub(1, action.offset)
  local after = state.fileData:sub(action.offset + 2)
  state.fileData = before .. action.newData .. after
  
  table.insert(state.undoStack, {offset = action.offset, oldData = currentByte, newData = action.newData})
  state.isUndoRedoOperation = false
  return true
end

local hexFilter = luajava.createProxy("android.text.InputFilter", {
  filter = function(source, start, endd, dest, dstart, dend)
    local result = source:toString():gsub("[^0-9A-Fa-f]", "")
    return result
  end
})

local function createHexCell()
  local cell = EditText(activity)
  cell.setGravity(Gravity.CENTER)
  cell.setText("00")
  cell.setTextColor(UI.TEXT)
  cell.setTextSize(1, 12)
  cell.setTypeface(Typeface.MONOSPACE)
  cell.setBackground(getSkin(UI.CARD, 8, 1, UI.ACCENT))
  cell.setPadding(dp(2), dp(4), dp(2), dp(4))
  cell.setSingleLine(true)
  cell.setInputType(1)
  cell.setFilters({
    InputFilter.LengthFilter(2),
    InputFilterAllCaps(true),
    hexFilter
  })
  
  local watcher = luajava.createProxy("android.text.TextWatcher", {
    beforeTextChanged = function(s, start, count, after) end,
    onTextChanged = function(s, start, before, count) end,
    afterTextChanged = function(s)
      if state.isUpdatingCells then return end
      
      local text = s:toString()
      local offset = cell.getTag()
      
      if offset < 0 then return end
      
      if text == "" then return end
      
      local cleaned = text:gsub("[^0-9A-Fa-f]", ""):upper()
      
      if #cleaned > 2 then
        cleaned = cleaned:sub(1, 2)
      end
      
      if cleaned ~= text then
        state.isUpdatingCells = true
        cell.setText(cleaned)
        cell.setSelection(#cleaned)
        state.isUpdatingCells = false
      end
      
      local val = tonumber(cleaned, 16)
      if val then
        local current = state.fileData:byte(offset + 1)
        
        if val ~= current then
          writeByte(offset, val)
          state.modified = true
        end
      end
    end
  })
  
  cell.addTextChangedListener(watcher)
  
  cell.setOnFocusChangeListener(View.OnFocusChangeListener({
    onFocusChange = function(v, hasFocus)
      if hasFocus then
        local cellView = v
        cellView.selectAll()
      else
        hideKeyboard()
      end
    end
  }))
  
  cell.setOnClickListener(View.OnClickListener({
    onClick = function(v)
      if not state.fileData then
        showToast("No file loaded")
        return
      end
      forceShowKeyboard(v)
    end
  }))
  
  return cell
end

function updateHexDisplay()
  if not state.fileData then return end
  
  state.isUpdatingCells = true
  
  local startOffset = state.currentOffset
  
  for i = 0, state.bytesPerPage - 1 do
    local offset = startOffset + i
    local cell = state.hexCells[i + 1]
    
    if cell and offset < state.fileSize then
      local byte = state.fileData:byte(offset + 1)
      cell.setText(string.format("%02X", byte))
      cell.setTag(offset)
      cell.setEnabled(true)
    elseif cell then
      cell.setText("")
      cell.setTag(-1)
      cell.setEnabled(false)
    end
  end
  
  state.isUpdatingCells = false
  
  if state.pageLabel then
    state.pageLabel.setText(string.format("Offset: 0x%X - 0x%X | %s%s",
      startOffset,
      math.min(startOffset + state.bytesPerPage - 1, state.fileSize - 1),
      formatSize(state.fileSize),
      state.modified and " *" or ""))
  end
end

local function loadFileFromPath()
  local path = state.filePathInput.getText().toString()
  if path == "" then
    showToast("Enter path")
    return
  end
  
  local f = File(path)
  if not f.exists() then
    showToast("File not found")
    return
  end
  
  hideKeyboard()
  showProgress("Loading", path:match("[^/]+$") or path)
  
  loadFileInBackground(path, function(success, err)
    if success then
      showToast("Loaded: " .. formatSize(state.fileSize))
    else
      showToast(err)
    end
  end)
end

local function dumpSymbolsAction()
  if state.filePath == "" then
    showToast("No file")
    return
  end
  
  hideKeyboard()
  showProgress("Analyzing", "ELF...")
  
  parseELFInBackground(state.filePath, function(success, err, elf)
    if not success then
      showToast(err)
      return
    end
    
    local output = {}
    table.insert(output, "═══════════════════════════════════════")
    table.insert(output, "  ELF Symbol Dumper")
    table.insert(output, "═══════════════════════════════════════")
    table.insert(output, "File: " .. state.filePath:match("[^/]+$"))
    table.insert(output, "Architecture: " .. (elf.is64bit and "64-bit" or "32-bit"))
    table.insert(output, "Total symbols: " .. #elf.dynamicSymbols)
    table.insert(output, "")
    
    if #elf.dynamicSymbols > 0 then
      table.insert(output, "━━━ Symbols ━━━")
      for i, name in ipairs(elf.dynamicSymbols) do
        table.insert(output, name)
      end
    else
      table.insert(output, "No symbols found")
    end
    
    local report = table.concat(output, "\n")
    local savePath = "/sdcard/ELF_Dump_" .. state.filePath:match("[^/]+$") .. ".txt"
    
    local f = io.open(savePath, "w")
    if f then
      f:write(report)
      f:close()
      showToast(#elf.dynamicSymbols .. " symbols saved!")
    else
      showToast("Error saving")
    end
  end)
end

function createMainView()
  local root = FrameLayout(activity)
  root.setLayoutParams(FrameLayout.LayoutParams(dp(WIDTH), -2))
  root.setFocusable(true)
  root.setFocusableInTouchMode(true)
  
  local scroll = ScrollView(activity)
  scroll.setLayoutParams(FrameLayout.LayoutParams(-1, dp(560)))
  
  local main = LinearLayout(activity)
  main.setOrientation(1)
  main.setBackground(getSkin(UI.BG, UI.RADIUS, 2, UI.ACCENT))
  main.setPadding(dp(16), dp(14), dp(16), dp(14))
  
  local header = LinearLayout(activity)
  header.setOrientation(0)
  header.setGravity(Gravity.CENTER_VERTICAL)
  header.setPadding(0, 0, 0, dp(10))
  
  local title = TextView(activity)
  title.setText("HEX EDITOR + ELF")
  title.setTextColor(UI.ACCENT)
  title.setTextSize(1, 16)
  title.setTypeface(Typeface.create("sans-serif-black", Typeface.BOLD))
  title.setLayoutParams(LinLayoutParams(0, -2, 1.0))
  header.addView(title)
  
  local closeBtn = TextView(activity)
  closeBtn.setText("✕")
  closeBtn.setTextSize(1, 16)
  closeBtn.setTextColor(UI.TEXT)
  closeBtn.setBackground(getSkin(UI.BTN_DARK, 10))
  closeBtn.setPadding(dp(10), dp(2), dp(10), dp(2))
  closeBtn.setFocusable(true)
  closeBtn.setClickable(true)
  closeBtn.setOnClickListener(View.OnClickListener({ onClick = function() forceClose() end }))
  header.addView(closeBtn)
  main.addView(header)
  
  local sx, sy, lx, ly
  header.setOnTouchListener(View.OnTouchListener({
    onTouch = function(v, ev)
      if ev.getAction() == 0 then
        sx, sy = ev.getRawX(), ev.getRawY()
        lx, ly = mParams.x, mParams.y
        return true
      elseif ev.getAction() == 2 then
        mParams.x = lx + (ev.getRawX() - sx)
        mParams.y = ly + (ev.getRawY() - sy)
        pcall(function() windowManager.updateViewLayout(mainView, mParams) end)
        return true
      end
      return false
    end
  }))
  
  local fileRow = LinearLayout(activity)
  fileRow.setOrientation(0)
  fileRow.setLayoutParams(LinLayoutParams(-1, dp(40)))
  
  state.filePathInput = EditText(activity)
  state.filePathInput.setLayoutParams(LinLayoutParams(0, -1, 1.0))
  state.filePathInput.setHint("/sdcard/libUE4.so")
  state.filePathInput.setHintTextColor(UI.TEXT_HINT)
  state.filePathInput.setTextColor(UI.TEXT_DARK)
  state.filePathInput.setTextSize(1, 11)
  state.filePathInput.setSingleLine(true)
  state.filePathInput.setBackground(getSkin(Color.WHITE, 10))
  state.filePathInput.setPadding(dp(10), 0, dp(10), 0)
  fileRow.addView(state.filePathInput)
  
  local pasteBtn = Button(activity)
  pasteBtn.setLayoutParams(LinLayoutParams(dp(45), -1))
  pasteBtn.setText("📋")
  pasteBtn.setTextSize(1, 14)
  pasteBtn.setTextColor(UI.WHITE)
  pasteBtn.setBackground(getSkin(UI.BTN_LIGHT, 10))
  pasteBtn.setOnClickListener(View.OnClickListener({ 
    onClick = function() pasteFromClipboard(state.filePathInput) end 
  }))
  fileRow.addView(pasteBtn)
  
  local loadBtn = Button(activity)
  loadBtn.setLayoutParams(LinLayoutParams(dp(65), -1))
  loadBtn.setText("LOAD")
  loadBtn.setTextSize(1, 9)
  loadBtn.setTextColor(UI.WHITE)
  loadBtn.setBackground(getSkin(UI.ACCENT, 10))
  loadBtn.setOnClickListener(View.OnClickListener({ onClick = function() loadFileFromPath() end }))
  fileRow.addView(loadBtn)
  main.addView(fileRow)
  
  local actionRow = LinearLayout(activity)
  actionRow.setOrientation(0)
  actionRow.setGravity(Gravity.CENTER)
  local actionParams = LinLayoutParams(-1, dp(35))
  actionParams.topMargin = dp(8)
  actionRow.setLayoutParams(actionParams)
  
  local undoBtn = Button(activity)
  undoBtn.setText("↩️ UNDO")
  undoBtn.setTextSize(1, 10)
  undoBtn.setTextColor(UI.WHITE)
  undoBtn.setBackground(getSkin(UI.BTN_LIGHT, 8))
  undoBtn.setPadding(dp(8), dp(4), dp(8), dp(4))
  undoBtn.setOnClickListener(View.OnClickListener({
    onClick = function()
      if undo() then 
        updateHexDisplay()
        showToast("Undo")
      else 
        showToast("Nothing to undo")
      end
    end
  }))
  actionRow.addView(undoBtn)
  
  local redoBtn = Button(activity)
  redoBtn.setText("↪️ REDO")
  redoBtn.setTextSize(1, 10)
  redoBtn.setTextColor(UI.WHITE)
  redoBtn.setBackground(getSkin(UI.BTN_LIGHT, 8))
  redoBtn.setPadding(dp(8), dp(4), dp(8), dp(4))
  redoBtn.setOnClickListener(View.OnClickListener({
    onClick = function()
      if redo() then 
        updateHexDisplay()
        showToast("Redo")
      else 
        showToast("Nothing to redo")
      end
    end
  }))
  actionRow.addView(redoBtn)
  
  function syncHexToBuffer()
    if not state.fileData then return end
    
    for i = 1, #state.hexCells do
      local cell = state.hexCells[i]
      local offset = cell.getTag()
      
      if offset >= 0 then
        local text = cell.getText().toString()
        
        if text and #text > 0 then
          local val = tonumber(text, 16)
          
          if val then
            local current = state.fileData:byte(offset + 1)
            
            if val ~= current then
              writeByte(offset, val)
            end
          end
        end
      end
    end
  end
  
  local saveBtn = Button(activity)
  saveBtn.setText("💾 SAVE")
  saveBtn.setTextSize(1, 10)
  saveBtn.setTextColor(UI.WHITE)
  saveBtn.setBackground(getSkin(UI.SUCCESS, 8))
  saveBtn.setPadding(dp(8), dp(4), dp(8), dp(4))
  saveBtn.setOnClickListener(View.OnClickListener({
    onClick = function()
      if not state.fileData then 
        showToast("No file")
        return 
      end
      
      syncHexToBuffer()
      
      hideKeyboard()
      showProgress("Saving", "...")
      saveFileInBackground(function(success, err)
        if success then
          state.pageLabel.setText(string.format("Offset: 0x%X - 0x%X | %s",
            state.currentOffset,
            math.min(state.currentOffset + state.bytesPerPage - 1, state.fileSize - 1),
            formatSize(state.fileSize)))
          showToast("File saved in current folder name is .mod.so!")
        else
          showToast(err)
        end
      end)
    end
  }))
  actionRow.addView(saveBtn)
  main.addView(actionRow)
  
  local sep = View(activity)
  sep.setBackgroundColor(UI.ACCENT)
  sep.setAlpha(0.5)
  local sepParams = LinLayoutParams(-1, dp(1))
  sepParams.topMargin = dp(8)
  sepParams.bottomMargin = dp(8)
  sep.setLayoutParams(sepParams)
  main.addView(sep)
  
  state.pageLabel = TextView(activity)
  state.pageLabel.setText("Waiting for file...")
  state.pageLabel.setTextColor(UI.TEXT)
  state.pageLabel.setTextSize(1, 10)
  state.pageLabel.setGravity(Gravity.CENTER)
  main.addView(state.pageLabel)
  
  state.hexContainer = LinearLayout(activity)
  state.hexContainer.setOrientation(1)
  state.hexContainer.setGravity(Gravity.CENTER)
  state.hexContainer.setLayoutParams(LinLayoutParams(-1, -2))
  state.hexContainer.setVisibility(View.GONE)
  
  state.hexCells = {}
  
  for row = 1, 4 do
    local rowLayout = LinearLayout(activity)
    rowLayout.setOrientation(0)
    rowLayout.setGravity(Gravity.CENTER)
    
    for col = 1, 8 do
      local cell = createHexCell()
      table.insert(state.hexCells, cell)
      
      local cellParams = LinLayoutParams(dp(40), dp(40))
      cellParams.setMargins(dp(2), dp(2), dp(2), dp(2))
      cell.setLayoutParams(cellParams)
      
      rowLayout.addView(cell)
    end
    
    state.hexContainer.addView(rowLayout)
  end
  
  main.addView(state.hexContainer)
  
  state.navContainer = LinearLayout(activity)
  state.navContainer.setOrientation(0)
  state.navContainer.setGravity(Gravity.CENTER)
  local navParams = LinLayoutParams(-1, -2)
  navParams.topMargin = dp(10)
  state.navContainer.setLayoutParams(navParams)
  state.navContainer.setVisibility(View.GONE)
  
  local prevBtn = Button(activity)
  prevBtn.setText("◀ PREV")
  prevBtn.setTextSize(1, 11)
  prevBtn.setTextColor(UI.WHITE)
  prevBtn.setBackground(getSkin(UI.BTN_LIGHT, 8))
  prevBtn.setPadding(dp(12), dp(6), dp(12), dp(6))
  prevBtn.setOnClickListener(View.OnClickListener({
    onClick = function()
      if not state.fileData then return end
      state.currentOffset = math.max(0, state.currentOffset - state.bytesPerPage)
      updateHexDisplay()
    end
  }))
  state.navContainer.addView(prevBtn)
  
  local spacer = View(activity)
  spacer.setLayoutParams(LinLayoutParams(dp(15), -1))
  state.navContainer.addView(spacer)
  
  local nextBtn = Button(activity)
  nextBtn.setText("NEXT ▶")
  nextBtn.setTextSize(1, 11)
  nextBtn.setTextColor(UI.WHITE)
  nextBtn.setBackground(getSkin(UI.BTN_LIGHT, 8))
  nextBtn.setPadding(dp(12), dp(6), dp(12), dp(6))
  nextBtn.setOnClickListener(View.OnClickListener({
    onClick = function()
      if not state.fileData then return end
      if state.currentOffset + state.bytesPerPage < state.fileSize then
        state.currentOffset = state.currentOffset + state.bytesPerPage
        updateHexDisplay()
      else
        showToast("End of file")
      end
    end
  }))
  state.navContainer.addView(nextBtn)
  
  main.addView(state.navContainer)
  
  state.dumpBtn = Button(activity)
  state.dumpBtn.setText("🔍 DUMP SYMBOLS (ELF)")
  state.dumpBtn.setTextColor(UI.WHITE)
  state.dumpBtn.setTextSize(1, 12)
  state.dumpBtn.setTypeface(Typeface.DEFAULT_BOLD)
  state.dumpBtn.setBackground(getSkin(UI.ACCENT_PINK, 10))
  local dumpParams = LinLayoutParams(-1, dp(38))
  dumpParams.topMargin = dp(10)
  state.dumpBtn.setLayoutParams(dumpParams)
  state.dumpBtn.setVisibility(View.GONE)
  state.dumpBtn.setOnClickListener(View.OnClickListener({ onClick = function() dumpSymbolsAction() end }))
  main.addView(state.dumpBtn)
  
  local closeAllBtn = Button(activity)
  closeAllBtn.setText("❌ CLOSE ALL")
  closeAllBtn.setTextColor(UI.WHITE)
  closeAllBtn.setTextSize(1, 12)
  closeAllBtn.setTypeface(Typeface.DEFAULT_BOLD)
  closeAllBtn.setBackground(getSkin(UI.DANGER, 10))
  local closeParams = LinLayoutParams(-1, dp(38))
  closeParams.topMargin = dp(6)
  closeAllBtn.setLayoutParams(closeParams)
  closeAllBtn.setOnClickListener(View.OnClickListener({ onClick = function() forceClose() end }))
  main.addView(closeAllBtn)
  
  scroll.addView(main)
  root.addView(scroll)
  
  return root
end

function forceClose()
  mainHandler.post(function()
    pcall(function()
      if activeView then
        windowManager.removeView(activeView)
      end
    end)
    exit = true
  end)
end

function initUI()
  windowManager = activity.getSystemService(Context.WINDOW_SERVICE)
  
  local layoutType
  if Build.VERSION.SDK_INT >= 26 then
    layoutType = LayoutParams.TYPE_APPLICATION_OVERLAY
  else
    layoutType = LayoutParams.TYPE_PHONE
  end
  
  mParams = LayoutParams(dp(WIDTH), -2, layoutType, 0, -3)
  mParams.gravity = Gravity.TOP | Gravity.LEFT
  mParams.x, mParams.y = 50, 150
  
  mainView = createMainView()
  
  mainHandler.post(function()
    pcall(function()
      windowManager.addView(mainView, mParams)
      animateViewIn(mainView)
    end)
    activeView = mainView
  end)
end

mainHandler.post(function()
  initUI()
end)