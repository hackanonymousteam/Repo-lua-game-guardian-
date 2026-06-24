gg.setVisible(false)

import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "android.graphics.*"
import "android.graphics.drawable.*"
import "android.content.*"
import "android.net.*"
import "android.media.*"
import "android.util.TypedValue"
import "android.view.WindowManager"
import "android.widget.VideoView"
import "java.io.File"
import "java.lang.Thread"

wm = activity.getSystemService(Context.WINDOW_SERVICE)

API = "https://1.xingmianapi1.ccwu.cc/API/alazylazy.php"

CACHE_DIR = "/storage/emulated/0/Download/tiktok_cache"

File(CACHE_DIR).mkdirs()

MENU_BG = Color.parseColor("#CC000000")
LOADING_BG = Color.parseColor("#AA000000")

videoView = nil
floatingView = nil
loadingOverlay = nil
loadingText = nil

mediaPlayer = nil

currentVideo = nil
nextVideo = nil
preloadVideo2 = nil

isLoading = false
isVideoReady = false
isDragging = false
isClosing = false
isChangingVideo = false

touchStartX = 0
touchStartY = 0

mainHandler = Handler(Looper.getMainLooper())

function dp(v)

  return TypedValue.applyDimension(
    TypedValue.COMPLEX_UNIT_DIP,
    v,
    activity.getResources().getDisplayMetrics()
  )
end
function uiDelay(ms, func)

  local runnable =
  luajava.createProxy(
    "java.lang.Runnable",
    {
      run = function()

        if not isClosing then

          pcall(function()
            activity.runOnUiThread(func)
          end)
        end
      end
    }
  )

  mainHandler.postDelayed(
    runnable,
    ms
  )
end

function randomName()

  return tostring(os.time()) ..
  "_" ..
  tostring(math.random(1000,9999)) ..
  ".mp4"
end

function deleteFile(path)

  if path == nil then
    return
  end

  pcall(function()
    os.remove(path)
  end)
end

function clearCache()

  local files =
  File(CACHE_DIR).listFiles()

  if files == nil then
    return
  end

  for i = 0, files.length - 1 do

    local f = files[i]

    if f ~= nil then

      local p =
      tostring(
        f.getAbsolutePath()
      )

      if p ~= currentVideo
      and p ~= nextVideo
      and p ~= preloadVideo2 then

        pcall(function()
          f.delete()
        end)
      end
    end
  end
end

function downloadVideo(path)

  local ok, res =
  pcall(function()
    return gg.makeRequest(API)
  end)

  if not ok then
    return nil
  end

  if res == nil then
    return nil
  end

  if res.content == nil then
    return nil
  end

  local file =
  io.open(path, "wb")

  if file == nil then
    return nil
  end

  file:write(res.content)

  file:close()

  local f = File(path)

  if not f.exists() then

    deleteFile(path)

    return nil
  end

  if f.length() < 1000 then

    deleteFile(path)

    return nil
  end

  return path
end

function showLoading(text)

  if loadingOverlay == nil then
    return
  end

  activity.runOnUiThread(function()

    loadingOverlay.setVisibility(
      View.VISIBLE
    )

    if text ~= nil then
      loadingText.setText(text)
    end
  end)
end

function hideLoading()

  if loadingOverlay == nil then
    return
  end

  activity.runOnUiThread(function()

    loadingOverlay.setVisibility(
      View.GONE
    )
  end)
end

function preloadNext()

  if isLoading then
    return
  end

  isLoading = true

  local runnable =
  luajava.createProxy(
    "java.lang.Runnable",
    {
      run = function()

        local path =
        CACHE_DIR ..
        "/" ..
        randomName()

        local video =
        downloadVideo(path)

        if video ~= nil then

          if nextVideo == nil then

            nextVideo = video

          elseif preloadVideo2 == nil then

            preloadVideo2 = video

          else

            deleteFile(video)
          end
        end

        isLoading = false
      end
    }
  )

  Thread(runnable).start()
end

function ensureBuffer()

  if nextVideo == nil then
    preloadNext()
  end

  uiDelay(300, function()

    if preloadVideo2 == nil then
      preloadNext()
    end
  end)
end

function playVideo(path)

  if path == nil then
    return
  end

  local file = File(path)

  if not file.exists() then

    switchToNextVideo()

    return
  end

  isVideoReady = false

  showLoading(
    "loading vídeo..."
  )

  activity.runOnUiThread(function()

    pcall(function()
      videoView.stopPlayback()
    end)

    videoView.setVideoURI(
      Uri.fromFile(file)
    )

    videoView.setOnPreparedListener{
      onPrepared = function(mp)

        mediaPlayer = mp

        mp.setLooping(false)

        isVideoReady = true

        hideLoading()

        videoView.start()

        ensureBuffer()
      end
    }

    videoView.setOnCompletionListener{
      onCompletion = function(mp)

        switchToNextVideo()
      end
    }

    videoView.setOnErrorListener{
      onError = function(mp, what, extra)

        switchToNextVideo()

        return true
      end
    }
  end)
end

function switchToNextVideo()

  if isChangingVideo then
    return
  end

  isChangingVideo = true

  local old =
  currentVideo

  currentVideo =
  nextVideo

  nextVideo =
  preloadVideo2

  preloadVideo2 = nil

  if currentVideo == nil then

    local path =
    CACHE_DIR ..
    "/" ..
    randomName()

    currentVideo =
    downloadVideo(path)
  end

  deleteFile(old)

  clearCache()

  if currentVideo ~= nil then

    playVideo(currentVideo)

  else

    showLoading(
      "Error loading videos please start script again"
    )
  end

  ensureBuffer()

  uiDelay(700, function()

    isChangingVideo = false
  end)
end

function closePlayer()

  if isClosing then
    return
  end

  isClosing = true

  pcall(function()

    activity.runOnUiThread(function()

      pcall(function()
        videoView.stopPlayback()
      end)

      pcall(function()

        if floatingView ~= nil then

          wm.removeView(
            floatingView
          )
        end
      end)

      floatingView = nil
    end)
  end)

  deleteFile(currentVideo)
  deleteFile(nextVideo)
  deleteFile(preloadVideo2)

  clearCache()

  uiDelay(300, function()
    os.exit()
  end)
end

function createPlayer()

  local root =
  FrameLayout(activity)

  local bg =
  GradientDrawable()

  bg.setColor(MENU_BG)

  bg.setCornerRadius(
    dp(14)
  )

  root.setBackgroundDrawable(bg)

  videoView =
  VideoView(activity)

  local videoParams =
  FrameLayout.LayoutParams(
    dp(330),
    dp(600)
  )

  videoParams.gravity =
  Gravity.CENTER

  videoView.setLayoutParams(
    videoParams
  )

  root.addView(videoView)

  loadingOverlay =
  FrameLayout(activity)

  loadingOverlay.setBackgroundColor(
    LOADING_BG
  )

  local loadingParams =
  FrameLayout.LayoutParams(
    dp(330),
    dp(600)
  )

  loadingParams.gravity =
  Gravity.CENTER

  loadingOverlay.setLayoutParams(
    loadingParams
  )

  local loadingContainer =
  LinearLayout(activity)

  loadingContainer.setOrientation(
    LinearLayout.VERTICAL
  )

  loadingContainer.setGravity(
    Gravity.CENTER
  )

  local progress =
  ProgressBar(activity)

  progress.setIndeterminate(
    true
  )

  loadingContainer.addView(
    progress
  )

  loadingText =
  TextView(activity)

  loadingText.setText(
    "loading..."
  )

  loadingText.setTextColor(
    Color.WHITE
  )

  loadingText.setTextSize(16)

  loadingText.setPadding(
    0,
    dp(12),
    0,
    0
  )

  loadingContainer.addView(
    loadingText
  )

  loadingOverlay.addView(
    loadingContainer
  )

  root.addView(
    loadingOverlay
  )

  local title =
  TextView(activity)

  title.setText(
    "                 Scroll to change video"
  )

  title.setTextColor(
    Color.WHITE
  )

  title.setTextSize(16)

  title.setTypeface(
    Typeface.DEFAULT_BOLD
  )

  title.setShadowLayer(
    5,
    1,
    1,
    Color.BLACK
  )

  local titleParams =
  FrameLayout.LayoutParams(
    -2,
    -2
  )

  titleParams.gravity =
Gravity.TOP |
Gravity.RIGHT

titleParams.rightMargin =
dp(40)

titleParams.topMargin =
dp(40)
  title.setLayoutParams(
    titleParams
  )

 root.addView(title)

  local closeBtn =
  TextView(activity)

  closeBtn.setText("✕")

  closeBtn.setGravity(
    Gravity.CENTER
  )

  closeBtn.setTextSize(18)

  closeBtn.setTextColor(
    Color.WHITE
  )

  closeBtn.setTypeface(
    Typeface.DEFAULT_BOLD
  )

  local closeBg =
  GradientDrawable()

  closeBg.setShape(
    GradientDrawable.OVAL
  )

  closeBg.setColor(
    Color.parseColor(
      "#CCFF0000"
    )
  )

  closeBtn.setBackgroundDrawable(
    closeBg
  )

  local closeParams =
  FrameLayout.LayoutParams(
    dp(42),
    dp(42)
  )

  closeParams.gravity =
  Gravity.TOP |
  Gravity.RIGHT

  closeParams.topMargin =
  dp(10)

  closeParams.rightMargin =
  dp(10)

  closeBtn.setLayoutParams(
    closeParams
  )

  root.addView(closeBtn)

  local scrollText =
  TextView(activity)

  scrollText.setText(
    ""
  )

  scrollText.setTextColor(
    Color.WHITE
  )

  scrollText.setTextSize(13)

  scrollText.setShadowLayer(
    4,
    1,
    1,
    Color.BLACK
  )

  local scrollParams =
  FrameLayout.LayoutParams(
    -2,
    -2
  )

  scrollParams.gravity =
  Gravity.BOTTOM |
  Gravity.CENTER_HORIZONTAL

  scrollParams.bottomMargin =
  dp(16)

  scrollText.setLayoutParams(
    scrollParams
  )

  root.addView(scrollText)

  floatingView = root

  local params =
  WindowManager.LayoutParams()

  params.width =
  WindowManager.LayoutParams.WRAP_CONTENT

  params.height =
  WindowManager.LayoutParams.WRAP_CONTENT

  params.type =
  WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY

  params.flags =
  bit32.bor(
    WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN
  )

  params.format =
  PixelFormat.TRANSLUCENT

  params.gravity =
  Gravity.TOP |
  Gravity.LEFT

  params.x = 70
  params.y = 40

  activity.runOnUiThread(function()

    wm.addView(
      floatingView,
      params
    )
  end)

  closeBtn.setOnClickListener{
    onClick = function(v)

      closePlayer()
    end
  }

  local startX = 0
  local startY = 0

  local winX = 0
  local winY = 0

  root.setOnTouchListener{
    onTouch = function(view, event)

      local action =
      event.getAction()

      if action ==
      MotionEvent.ACTION_DOWN then

        startX =
        event.getRawX()

        startY =
        event.getRawY()

        winX = params.x
        winY = params.y

        isDragging = false

        return true

      elseif action ==
      MotionEvent.ACTION_MOVE then

        local dx =
        event.getRawX() -
        startX

        local dy =
        event.getRawY() -
        startY

        if math.abs(dx) > 25 then

          isDragging = true

          params.x =
          winX + dx

          params.y =
          winY + dy

          activity.runOnUiThread(function()

            pcall(function()

              wm.updateViewLayout(
                floatingView,
                params
              )
            end)
          end)
        end

        return true

      elseif action ==
      MotionEvent.ACTION_UP then

        local dy =
        event.getRawY() -
        startY

        local dx =
        event.getRawX() -
        startX

        if not isDragging then

          if math.abs(dy) > 120
          and math.abs(dy) > math.abs(dx) then

            if dy < 0 then

              switchToNextVideo()
            end
          end
        end

        return true
      end

      return false
    end
  }
end

math.randomseed(os.time())

clearCache()

showLoading()

local firstPath =
CACHE_DIR ..
"/" ..
randomName()

currentVideo =
downloadVideo(firstPath)

if currentVideo == nil then

  gg.toast(
    "Error"
  )

  os.exit()
end

local secondPath =
CACHE_DIR ..
"/" ..
randomName()

nextVideo =
downloadVideo(secondPath)

local thirdPath =
CACHE_DIR ..
"/" ..
randomName()

preloadVideo2 =
downloadVideo(thirdPath)


createPlayer()

playVideo(currentVideo)

while floatingView ~= nil do

  if not isClosing then

    ensureBuffer()
  end

  gg.sleep(2000)
end