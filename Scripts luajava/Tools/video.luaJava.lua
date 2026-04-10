gg.setVisible(false)

import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "android.graphics.*"
import "android.graphics.drawable.*"
import "android.util.TypedValue"
import "android.text.Html"
import "android.content.Context"
import "android.view.WindowManager"
import "android.view.Gravity"
import "android.media.MediaPlayer"
import "android.widget.VideoView"
import "android.net.Uri"
import "android.widget.ImageView"
import "android.provider.MediaStore"
import "java.io.File"
import "android.graphics.BitmapFactory"


wm = activity.getSystemService(Context.WINDOW_SERVICE)
screenWidth = activity.getResources().getDisplayMetrics().widthPixels
screenHeight = activity.getResources().getDisplayMetrics().heightPixels


MENU_BG_COLOR = Color.parseColor("#80000000")
CONTROL_BG_COLOR = Color.parseColor("#40000000")
CONTROL_HEIGHT = 80
PLAYER_WIDTH = 300
PLAYER_HEIGHT = 350

Link = "https://archive.org/download/kotosemma-video-6968222692998696198/kotosemma-video-6968222692998696198.mp4"
path = "/storage/emulated/0/Download"
Name = "sample.mp4"
fullPath = path .. "/" .. Name

if os.rename(fullPath, fullPath) then

end

bat = gg.makeRequest(Link).content
if bat == nil then
  print("Erro ")
  os.exit()
end


local file = io.open(fullPath, "w")
file:write(bat)
file:close()

mFloatingView = nil
videoView = nil
imageView = nil
mediaPlayer = nil
isPlaying = false
currentVideoPath = "/storage/emulated/0/Download/sample.mp4"

function dp(value)
  return TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, value, activity.getResources().getDisplayMetrics())
end

function initFloatingPlayer()

  local mainLayout = RelativeLayout(activity)
  mainLayout.setLayoutParams(RelativeLayout.LayoutParams(dp(PLAYER_WIDTH), dp(PLAYER_HEIGHT)))
  
  local background = GradientDrawable()
  background.setColor(MENU_BG_COLOR)
  background.setCornerRadius(dp(10))
  background.setStroke(2, Color.WHITE)
  mainLayout.setBackgroundDrawable(background)
  
  imageView = ImageView(activity)
  local imageParams = RelativeLayout.LayoutParams(dp(PLAYER_WIDTH-00), dp(920))
  imageParams.topMargin = dp(10)

  imageView.setLayoutParams(imageParams)
  imageView.setScaleType(ImageView.ScaleType.FIT_XY)
  
  local options = BitmapFactory.Options()
  options.inSampleSize = 2 
  local bitmap = BitmapFactory.decodeFile(currentImagePath, options)
  if bitmap ~= nil then
    imageView.setImageBitmap(bitmap)
  else
   -- print("erro: "..currentImagePath)
  end
  

  videoView = VideoView(activity)
  local videoParams = RelativeLayout.LayoutParams(dp(PLAYER_WIDTH-0), dp(520))
  videoParams.topMargin = dp(180)

  videoView.setLayoutParams(videoParams)
  
  -- Controls  vídeo
  local controlsLayout = LinearLayout(activity)
  controlsLayout.setOrientation(LinearLayout.VERTICAL)
  local controlsParams = RelativeLayout.LayoutParams(-1, dp(CONTROL_HEIGHT))
  controlsParams.topMargin = dp(270)
  controlsLayout.setLayoutParams(controlsParams)
  controlsLayout.setPadding(dp(10), dp(5), dp(10), dp(5))
  
  -- SeekBar 
  local seekBar = SeekBar(activity)
  seekBar.setLayoutParams(LinearLayout.LayoutParams(-1, dp(40)))
  

  local buttonsLayout = LinearLayout(activity)
  buttonsLayout.setOrientation(LinearLayout.HORIZONTAL)
  buttonsLayout.setGravity(Gravity.CENTER)
  buttonsLayout.setLayoutParams(LinearLayout.LayoutParams(-1, dp(40)))
  
  
  local playPauseBtn = Button(activity)
  playPauseBtn.setLayoutParams(LinearLayout.LayoutParams(dp(80), dp(50)))
  playPauseBtn.setText("Play")
  playPauseBtn.setTextColor(Color.WHITE)
  playPauseBtn.setTypeface(Typeface.DEFAULT_BOLD)
  playPauseBtn.setBackgroundColor(Color.parseColor("#FF0000"))
  

  local closeBtn = Button(activity)
  closeBtn.setLayoutParams(LinearLayout.LayoutParams(dp(80), dp(50)))
  closeBtn.setText("Close")
  closeBtn.setTextColor(Color.WHITE)
  closeBtn.setTypeface(Typeface.DEFAULT_BOLD)
  closeBtn.setBackgroundColor(Color.parseColor("#FF0000"))
  
  -- Adicionando botões ao layout
  buttonsLayout.addView(playPauseBtn)
  buttonsLayout.addView(closeBtn)
  
  controlsLayout.addView(buttonsLayout)
  

 -- mainLayout.addView(imageView)
  mainLayout.addView(videoView)
  mainLayout.addView(controlsLayout)
  
  mFloatingView = mainLayout
  

  local params = WindowManager.LayoutParams()
  params.width = WindowManager.LayoutParams.WRAP_CONTENT
  params.height = WindowManager.LayoutParams.WRAP_CONTENT
  params.type = WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
  params.flags = bit32.bor(WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE, 
                          WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN)
  params.format = PixelFormat.TRANSLUCENT
  params.gravity = Gravity.TOP | Gravity.LEFT
  params.x = 100
  params.y = 100
  

  activity.runOnUiThread(function()
    wm.addView(mFloatingView, params)
  end)
  

  setupMediaPlayer(currentVideoPath, seekBar, playPauseBtn)
  

  playPauseBtn.setOnClickListener{
    onClick = function(v)
      togglePlayPause(playPauseBtn)
    end
  }
  
  closeBtn.setOnClickListener{
    onClick = function(v)
      releaseMediaPlayer()
      wm.removeView(mFloatingView)
      mFloatingView = nil
    end
  }
  
  seekBar.setOnSeekBarChangeListener{
    onProgressChanged = function(sb, progress, fromUser)
      if fromUser and mediaPlayer ~= nil then
        mediaPlayer.seekTo(progress)
      end
    end,
    onStartTrackingTouch = function(sb) end,
    onStopTrackingTouch = function(sb) end
  }
  
  local initialX, initialY = 0, 0
  local initialTouchX, initialTouchY = 0, 0
  
  mFloatingView.setOnTouchListener{
    onTouch = function(view, motionEvent)
      local action = motionEvent.getAction()
      
      if action == MotionEvent.ACTION_DOWN then
        initialX = params.x
        initialY = params.y
        initialTouchX = motionEvent.getRawX()
        initialTouchY = motionEvent.getRawY()
        return true
      elseif action == MotionEvent.ACTION_MOVE then
        params.x = initialX + (motionEvent.getRawX() - initialTouchX)
        params.y = initialY + (motionEvent.getRawY() - initialTouchY)
        activity.runOnUiThread(function()
          wm.updateViewLayout(mFloatingView, params)
        end)
        return true
      end
      return false
    end
  }
end

function setupMediaPlayer(videoPath, seekBar, playBtn)

  local file = File(videoPath)
  if not file.exists() then
    print("vídeo no found: "..videoPath)
    playBtn.setEnabled(false)
    return
  end
  
  videoView.setVideoURI(Uri.fromFile(file))
  
  videoView.setOnPreparedListener{
    onPrepared = function(mp)
      mediaPlayer = mp
      seekBar.setMax(mp.getDuration())
      mp.start()
      isPlaying = true
      playBtn.setText("Pause")
      updateSeekBar(seekBar)
    end
  }
  
  videoView.setOnCompletionListener{
    onCompletion = function(mp)
      isPlaying = false
      playBtn.setText("Play")
      seekBar.setProgress(0)
    end
  }
  
  videoView.setOnErrorListener{
    onError = function(mp, what, extra)
      print("Erro: "..what..", "..extra)
      isPlaying = false
      playBtn.setText("Play")
      return true
    end
  }
end

function togglePlayPause(btn)
  if mediaPlayer ~= nil then
    if isPlaying then
      mediaPlayer.pause()
      btn.setText("Play")
    else
      mediaPlayer.start()
      btn.setText("Pause")
    end
    isPlaying = not isPlaying
  end
end

function updateSeekBar(sb)
  if mediaPlayer ~= nil and isPlaying then
    sb.setProgress(mediaPlayer.getCurrentPosition())
    
    activity.runOnUiThread(Runnable{
      run = function()
        updateSeekBar(sb)
      end
    }, 1000)
  end
end

function releaseMediaPlayer()
  if mediaPlayer ~= nil then
    mediaPlayer.stop()
    mediaPlayer.release()
    mediaPlayer = nil
  end
end

initFloatingPlayer()