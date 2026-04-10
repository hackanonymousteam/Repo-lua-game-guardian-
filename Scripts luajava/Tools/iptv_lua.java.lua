gg.setVisible(false)

import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "android.graphics.*"
import "android.graphics.drawable.*"
import "android.util.TypedValue"
import "android.content.Context"
import "android.view.WindowManager"
import "android.view.Gravity"
import "android.media.MediaPlayer"
import "android.widget.VideoView"
import "android.net.Uri"
import "java.lang.Runnable"
wm = activity.getSystemService(Context.WINDOW_SERVICE)
screenWidth = activity.getResources().getDisplayMetrics().widthPixels
screenHeight = activity.getResources().getDisplayMetrics().heightPixels

MENU_BG_COLOR = Color.parseColor("#E6000000")
CONTROL_BG_COLOR = Color.parseColor("#80000000")
PLAYER_WIDTH = screenWidth * 0.9
PLAYER_HEIGHT = screenHeight * 0.3

channels = {
    {name = "Canal 1 - Record 1", url = "http://tvconquistalrv.duckdns.org:8080/hls/tvconquistalrv.m3u8"},
    {name = "Canal 2 - record juina", url = "https://cdn.jmvstream.com/w/LVW-10841/LVW10841_mT77z9o2cP/playlist.m3u8"},
    {name = "Canal 3 - record juara", url = "https://cdn.jmvstream.com/w/LVW-10842/LVW10842_513N26MDBL/chunklist.m3u8"},
    {name = "Canal 4 - record mt", url = "https://cdn.jmvstream.com/w/LVW-10841/LVW10841_mT77z9o2cP/playlist.m3u8"},
    {name = "Canal 5  - tv camara", url = "https://stream3.camara.gov.br/tv1/manifest.m3u8"},
     {name = "Canal 6 - BS TV",url =  "https://br5093.streamingdevideo.com.br/bstv/bstv/chunklist_w1014792137.m3u8"},
     {name = "Canal 7 - uniao plus",url =  "https://live.uniaoplus.com/hls/0gmf9QNc7bQ6V0Lu.m3u8"},
     {name = "Canal 8 - animes",url =  "https://service-stitcher.clusters.pluto.tv/stitch/hls/channel/5f12136385bccc00070142ed/master.m3u8?advertisingId=&appName=web&appVersion=5.12.0-a87d76d6acd214757f3f9ce727615cd3be3397a8&app_name=web&clientDeviceType=0&clientID=eabb34b1-5995-4c43-8147-d3f8d09696f2&clientModelNumber=na&deviceDNT=false&deviceId=eabb34b1-5995-4c43-8147-d3f8d09696f2&deviceLat=-10.0000&deviceLon=-55.0000&deviceMake=Chrome&deviceModel=web&deviceType=web&deviceVersion=87.0.4280.88&marketingRegion=BR&serverSideAds=true&sessionID=30971196-4529-11eb-b866-0242ac110002&sid=30971196-4529-11eb-b866-0242ac110002&userId="},
    
}

mFloatingView = nil
videoView = nil
mediaPlayer = nil
isPlaying = false
currentChannel = nil
windowParams = nil

function dp(value)
    return TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, value, activity.getResources().getDisplayMetrics())
end

function showChannelList()
    local channelOptions = {}
    for i, channel in ipairs(channels) do
        table.insert(channelOptions, channel.name)
    end
    table.insert(channelOptions, "Cancelar")
    
    local choice = gg.choice(channelOptions, nil, "Selecione um Canal")
    
    if choice ~= nil and choice > 0 and choice <= #channels then
        currentChannel = channels[choice]
        if mFloatingView == nil then
            initFloatingPlayer()
            gg.toast("aguarde o canal carregar")
        else
            playChannel(currentChannel.url)
        end
    end
end

function initFloatingPlayer()
    activity.runOnUiThread(Runnable{
        run = function()
            local mainLayout = FrameLayout(activity)
            mainLayout.setLayoutParams(FrameLayout.LayoutParams(-2, -2))
            
            local background = GradientDrawable()
            background.setColor(MENU_BG_COLOR)
            background.setCornerRadius(dp(12))
            background.setStroke(2, Color.parseColor("#40FFFFFF"))
            mainLayout.setBackgroundDrawable(background)
            
            videoView = VideoView(activity)
            local videoParams = FrameLayout.LayoutParams(dp(PLAYER_WIDTH - 40), dp(PLAYER_HEIGHT - 100))
            videoParams.gravity = Gravity.CENTER_HORIZONTAL
            videoParams.topMargin = dp(50)
            videoView.setLayoutParams(videoParams)
            
            local controlsLayout = LinearLayout(activity)
            controlsLayout.setOrientation(LinearLayout.VERTICAL)
            local controlsParams = FrameLayout.LayoutParams(-1, -2)
            controlsParams.gravity = Gravity.BOTTOM
            controlsLayout.setLayoutParams(controlsParams)
            controlsLayout.setPadding(dp(10), dp(5), dp(10), dp(5))
            
            local controlsBg = GradientDrawable()
            controlsBg.setColor(CONTROL_BG_COLOR)
            controlsBg.setCornerRadius(dp(8))
            controlsLayout.setBackgroundDrawable(controlsBg)
            
            local buttonsLayout = LinearLayout(activity)
            buttonsLayout.setOrientation(LinearLayout.HORIZONTAL)
            buttonsLayout.setGravity(Gravity.CENTER)
            buttonsLayout.setLayoutParams(LinearLayout.LayoutParams(-1, -2))
            
            local playPauseBtn = Button(activity)
            local playPauseParams = LinearLayout.LayoutParams(dp(100), dp(40))
            playPauseParams.weight = 1
            playPauseParams.rightMargin = dp(10)
            playPauseBtn.setLayoutParams(playPauseParams)
            playPauseBtn.setText("Play")
            playPauseBtn.setTextColor(Color.WHITE)
            playPauseBtn.setTypeface(Typeface.DEFAULT_BOLD)
            
            local playPauseBg = GradientDrawable()
            playPauseBg.setColor(Color.parseColor("#4CAF50"))
            playPauseBg.setCornerRadius(dp(8))
            playPauseBtn.setBackgroundDrawable(playPauseBg)
            
            local closeBtn = Button(activity)
            local closeParams = LinearLayout.LayoutParams(dp(100), dp(40))
            closeParams.weight = 1
            closeBtn.setLayoutParams(closeParams)
            closeBtn.setText("Sair")
            closeBtn.setTextColor(Color.WHITE)
            closeBtn.setTypeface(Typeface.DEFAULT_BOLD)
            
            local closeBg = GradientDrawable()
            closeBg.setColor(Color.parseColor("#F44336"))
            closeBg.setCornerRadius(dp(8))
            closeBtn.setBackgroundDrawable(closeBg)
            
            local channelBtn = Button(activity)
            local channelParams = LinearLayout.LayoutParams(dp(100), dp(40))
            channelParams.weight = 1
            channelParams.leftMargin = dp(10)
            channelBtn.setLayoutParams(channelParams)
            channelBtn.setText("Canais")
            channelBtn.setTextColor(Color.WHITE)
            channelBtn.setTypeface(Typeface.DEFAULT_BOLD)
            
            local channelBg = GradientDrawable()
            channelBg.setColor(Color.parseColor("#2196F3"))
            channelBg.setCornerRadius(dp(8))
            channelBtn.setBackgroundDrawable(channelBg)
            
            buttonsLayout.addView(playPauseBtn)
            buttonsLayout.addView(closeBtn)
           -- buttonsLayout.addView(channelBtn)
            controlsLayout.addView(buttonsLayout)
            
            mainLayout.addView(videoView)
            mainLayout.addView(controlsLayout)
            
            mFloatingView = mainLayout
            
            windowParams = WindowManager.LayoutParams()
            windowParams.width = WindowManager.LayoutParams.WRAP_CONTENT
            windowParams.height = WindowManager.LayoutParams.WRAP_CONTENT
            windowParams.type = WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
            windowParams.flags = bit32.bor(WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE, 
                                          WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN)
            windowParams.format = PixelFormat.TRANSLUCENT
            windowParams.gravity = Gravity.CENTER
            windowParams.x = (screenWidth - PLAYER_WIDTH) / 2
            windowParams.y = (screenHeight - PLAYER_HEIGHT) / 2
            
            wm.addView(mFloatingView, windowParams)
            
            playPauseBtn.setOnClickListener{
                onClick = function(v)
                    togglePlayPause(playPauseBtn)
                end
            }
            
            closeBtn.setOnClickListener{
                onClick = function(v)
                    closePlayer()
                end
            }
            
            channelBtn.setOnClickListener{
                onClick = function(v)
                    showChannelList()
                end
            }
            
            local initialX, initialY = 0, 0
            local initialTouchX, initialTouchY = 0, 0
            
            mFloatingView.setOnTouchListener{
                onTouch = function(view, motionEvent)
                    local action = motionEvent.getAction()
                    
                    if action == MotionEvent.ACTION_DOWN then
                        initialX = windowParams.x
                        initialY = windowParams.y
                        initialTouchX = motionEvent.getRawX()
                        initialTouchY = motionEvent.getRawY()
                        return true
                    elseif action == MotionEvent.ACTION_MOVE then
                        windowParams.x = initialX + (motionEvent.getRawX() - initialTouchX)
                        windowParams.y = initialY + (motionEvent.getRawY() - initialTouchY)
                        wm.updateViewLayout(mFloatingView, windowParams)
                        return true
                    end
                    return false
                end
            }
            
            if currentChannel then
                playChannel(currentChannel.url)
            end
        end
    })
end

function playChannel(url)
    activity.runOnUiThread(Runnable{
        run = function()
            if mediaPlayer ~= nil then
                mediaPlayer.stop()
                mediaPlayer.release()
                mediaPlayer = nil
            end
            
            videoView.setVideoURI(Uri.parse(url))
            
            videoView.setOnPreparedListener{
                onPrepared = function(mp)
                    mediaPlayer = mp
                    mp.start()
                    isPlaying = true
                end
            }
            
            videoView.setOnErrorListener{
                onError = function(mp, what, extra)
                    gg.toast("Erro ao carregar o canal")
                    return true
                end
            }
            
            videoView.setOnCompletionListener{
                onCompletion = function(mp)
                    isPlaying = false
                end
            }
        end
    })
end

function togglePlayPause(btn)
    activity.runOnUiThread(Runnable{
        run = function()
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
    })
end

function closePlayer()
    activity.runOnUiThread(Runnable{
        run = function()
            if mediaPlayer ~= nil then
                mediaPlayer.stop()
                mediaPlayer.release()
                mediaPlayer = nil
            end
            
            if mFloatingView ~= nil then
                wm.removeView(mFloatingView)
                mFloatingView = nil
            end
        end
    })
end

showChannelList()

