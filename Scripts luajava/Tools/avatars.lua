gg.setVisible(false)

if not activity then
    gg.alert("No activity")
    return
end

local function bind(c)
    local ok, r = pcall(
        luajava.bindClass,
        c
    )

    if ok then
        return r
    end

    return nil
end

local LinearLayout =
bind("android.widget.LinearLayout")

local ImageView =
bind("android.widget.ImageView")

local Button =
bind("android.widget.Button")

local WindowManager =
bind("android.view.WindowManager")

local PixelFormat =
bind("android.graphics.PixelFormat")

local Gravity =
bind("android.view.Gravity")

local Color =
bind("android.graphics.Color")

local Build =
bind("android.os.Build")

local BitmapFactory =
bind("android.graphics.BitmapFactory")

local URL =
bind("java.net.URL")

local function getType()

    if Build.VERSION.SDK_INT >= 26 then
        return 2038
    elseif Build.VERSION.SDK_INT >= 23 then
        return 2002
    else
        return 2003
    end

end

local function loadBitmap(link)

    local ok, bmp =
    pcall(function()

        local conn =
        URL(link)
        .openConnection()

        conn.connect()

        local input =
        conn.getInputStream()

        local bitmap =
        BitmapFactory.decodeStream(
            input
        )

        input.close()

        return bitmap

    end)

    if ok then
        return bmp
    end

    return nil

end

local finished = false

thread(function()

    local logoBmp =
    loadBitmap(
        "https://ui-avatars.com/api/?name=Batman+games&background=ff8ABC&color=fff"
    )

    local imageBmp =
    loadBitmap(
        "https://rxtool.top/api/generateimages.php?text=Batman&type=0&types=0"
    )

    activity.runOnUiThread(
        luajava.createProxy(
            "java.lang.Runnable",
            {
                run = function()

                    local root =
                    LinearLayout(activity)

                    root.setOrientation(1)

                    root.setPadding(
                        20,
                        20,
                        20,
                        20
                    )

                    root.setBackgroundColor(
                        0xCC000000
                    )

                    local btnClose =
                    Button(activity)

                    btnClose.setText("X")

                    btnClose.setTextColor(
                        Color.WHITE
                    )

                    local logo =
                    ImageView(activity)

                    local image =
                    ImageView(activity)

                    logo.setAdjustViewBounds(
                        true
                    )

                    image.setAdjustViewBounds(
                        true
                    )

                    if logoBmp then
                        logo.setImageBitmap(
                            logoBmp
                        )
                    end

                    if imageBmp then
                        image.setImageBitmap(
                            imageBmp
                        )
                    end

                    root.addView(
                        btnClose
                    )

                    root.addView(
                        logo
                    )

                    root.addView(
                        image
                    )

                    local params =
                    luajava.newInstance(
                        "android.view.WindowManager$LayoutParams",
                        -2,
                        -2,
                        getType(),
                        0x00000008,
                        PixelFormat.TRANSLUCENT
                    )

                    params.gravity =
                    Gravity.CENTER

                    local wm =
                    activity.getWindowManager()

                    btnClose.setOnClickListener(
                        luajava.createProxy(
                            "android.view.View$OnClickListener",
                            {
                                onClick = function(v)

                                    pcall(function()
                                        wm.removeView(
                                            root
                                        )
                                    end)

                                end
                            }
                        )
                    )

                    wm.addView(
                        root,
                        params
                    )

                    finished = true

                end
            }
        )
    )

end)

while not finished do
    gg.sleep(1000)
end