gg.setVisible(false)

function hash_djb2(str)
    local hash = 5381
    for i = 1, #str do
        hash = ((hash << 5) + hash) + str:byte(i)
        hash = hash & 0xFFFFFFFF
    end
    return string.format("%08x", hash)
end

Build = luajava.bindClass("android.os.Build")

local AAB = table.concat({
  Build.VERSION.RELEASE,
  Build.VERSION.SDK,
  Build.MODEL,
  Build.MANUFACTURER,
  Build.BOOTLOADER,
  Build.CPU_ABI,
  Build.HARDWARE,
  Build.UNKNOWN,
  Build.ID,
  Build.TYPE,
  Build.BRAND,
  Build.HOST,
  Build.FINGERPRINT
}, "|")

local device_id = hash_djb2(AAB)

gg.alert("📱 DEVICE ID:\n\n" .. device_id)