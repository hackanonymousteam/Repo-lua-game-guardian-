gg.setVisible(false)

import "android.widget.*"
import "android.graphics.*"
import "android.view.*"
import "java.io.*"
import "android.os.*"
import "android.content.Context"


local CACHE_DIR = activity.getExternalFilesDir(nil).toString() .. "/toast_cache/"
local TIMEOUT = 10000 


local cacheDir = File(CACHE_DIR)
if not cacheDir.exists() then
    cacheDir.mkdirs()
end

function showImageToast(text, imageUrl)
    local cachedImage = getCachedImage(imageUrl)
    
    if cachedImage then

        showToastWithImage(text, cachedImage)
    else

        downloadAndShowToast(text, imageUrl)
    end
end

function showToastWithImage(text, bitmap)
    activity.runOnUiThread(function()
        local toast = Toast.makeText(activity, "", Toast.LENGTH_LONG)
        
        local layout = LinearLayout(activity)
        layout.setOrientation(LinearLayout.VERTICAL)
        layout.setGravity(Gravity.CENTER)
        layout.setPadding(40, 40, 40, 40)
        layout.setBackgroundResource(android.R.drawable.toast_frame)
        

        local imageView = ImageView(activity)
        imageView.setScaleType(ImageView.ScaleType.CENTER_CROP)
        imageView.setLayoutParams(LinearLayout.LayoutParams(
            dpToPx(200), dpToPx(150)
        ))
        imageView.setImageBitmap(bitmap)
        
       
        local textView = TextView(activity)
        textView.setText(text)
        textView.setTextColor(Color.BLACK)
        textView.setTextSize(16)
        textView.setGravity(Gravity.CENTER)
        
        layout.addView(imageView)
        layout.addView(textView)
        toast.setView(layout)
        toast.show()
    end)
end

function downloadAndShowToast(text, imageUrl)
    thread(function()
        local success, bitmap = pcall(function()
            return downloadImage(imageUrl)
        end)
        
        if success and bitmap then
            cacheImage(imageUrl, bitmap)
            showToastWithImage(text, bitmap)
        else
            showToastWithImage(text, 
                BitmapFactory.decodeResource(activity.getResources(), 
                android.R.drawable.ic_menu_report_image))
        end
    end)
end


function downloadImage(url)
    local connection = luajava.bindClass("java.net.URL")(url).openConnection()
    connection.setConnectTimeout(TIMEOUT)
    connection.setReadTimeout(TIMEOUT)
    
    local inputStream = connection.getInputStream()
    local bitmap = BitmapFactory.decodeStream(inputStream)
    inputStream.close()
    
    return bitmap
end


function getCachedImage(url)
    local fileName = string.gsub(url, "[^%w]", "_") .. ".cache"
    local file = File(CACHE_DIR .. fileName)
    
    if file.exists() then
        return BitmapFactory.decodeFile(file.getAbsolutePath())
    end
    return nil
end

function cacheImage(url, bitmap)
    local fileName = string.gsub(url, "[^%w]", "_") .. ".cache"
    local file = File(CACHE_DIR .. fileName)
    
    local outputStream = FileOutputStream(file)
    bitmap.compress(Bitmap.CompressFormat.PNG, 90, outputStream)
    outputStream.close()
end

function dpToPx(dp)
    local metrics = activity.getResources().getDisplayMetrics()
    return dp * (metrics.densityDpi / 160)
end

-- Example usage
showImageToast("Toast Batman", "https://icons.iconarchive.com/icons/blackvariant/button-ui-system-folders-alt/96/Music-icon.png")