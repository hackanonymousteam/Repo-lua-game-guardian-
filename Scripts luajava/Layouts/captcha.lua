gg.setVisible(false)

if not activity then
    gg.alert("No activity")
    return
end

math.randomseed(os.time())

local function bind(c)
    local ok, r = pcall(luajava.bindClass, c)
    if ok then
        return r
    end
    return nil
end

local TextView = bind("android.widget.TextView")
local LinearLayout = bind("android.widget.LinearLayout")
local ImageView = bind("android.widget.ImageView")
local Button = bind("android.widget.Button")
local PixelFormat = bind("android.graphics.PixelFormat")
local Gravity = bind("android.view.Gravity")
local Color = bind("android.graphics.Color")
local Build = bind("android.os.Build")
local Handler = bind("android.os.Handler")
local Looper = bind("android.os.Looper")
local GradientDrawable = bind("android.graphics.drawable.GradientDrawable")

local function getType()
    if Build.VERSION.SDK_INT >= 26 then
        return 2038
    elseif Build.VERSION.SDK_INT >= 23 then
        return 2002
    end
    return 2003
end

local function bg(radius, color, stroke)
    local g = GradientDrawable()
    g.setShape(GradientDrawable.RECTANGLE)
    g.setCornerRadius(radius)
    g.setColor(color)
    g.setStroke(4, stroke)
    return g
end

local function shuffle(t)
    for i = #t, 2, -1 do
        local j = math.random(i)
        t[i], t[j] = t[j], t[i]
    end
    return t
end

local questions = {

    {
        question = "Select PHONE items",
        correct = {
            android.R.drawable.ic_menu_call,
            android.R.drawable.sym_action_call
        },
        wrong = {
            android.R.drawable.ic_menu_camera,
            android.R.drawable.ic_menu_gallery,
            android.R.drawable.ic_menu_compass,
            android.R.drawable.ic_menu_crop
        }
    },

    {
        question = "Select PHOTO items",
        correct = {
            android.R.drawable.ic_menu_camera,
            android.R.drawable.ic_menu_gallery
        },
        wrong = {
            android.R.drawable.ic_menu_call,
            android.R.drawable.ic_menu_compass,
            android.R.drawable.ic_menu_manage,
            android.R.drawable.ic_menu_agenda
        }
    },

    {
        question = "Select LOCATION items",
        correct = {
            android.R.drawable.ic_menu_compass,
            android.R.drawable.ic_menu_mylocation
        },
        wrong = {
            android.R.drawable.ic_menu_camera,
            android.R.drawable.ic_menu_call,
            android.R.drawable.ic_menu_gallery,
            android.R.drawable.ic_menu_crop
        }
    },

    {
        question = "Select EDIT items",
        correct = {
            android.R.drawable.ic_menu_edit,
            android.R.drawable.ic_menu_crop
        },
        wrong = {
            android.R.drawable.ic_menu_call,
            android.R.drawable.ic_menu_camera,
            android.R.drawable.ic_menu_gallery,
            android.R.drawable.ic_menu_mylocation
        }
    },

    {
        question = "Select VIDEO items",
        correct = {
            android.R.drawable.ic_media_play,
            android.R.drawable.ic_media_pause
        },
        wrong = {
            android.R.drawable.ic_menu_call,
            android.R.drawable.ic_menu_camera,
            android.R.drawable.ic_menu_compass,
            android.R.drawable.ic_menu_agenda
        }
    },

    {
        question = "Select SHARE items",
        correct = {
            android.R.drawable.ic_menu_share,
            android.R.drawable.ic_menu_send
        },
        wrong = {
            android.R.drawable.ic_menu_camera,
            android.R.drawable.ic_menu_call,
            android.R.drawable.ic_menu_crop,
            android.R.drawable.ic_menu_compass
        }
    },

    {
        question = "Select HELP items",
        correct = {
            android.R.drawable.ic_menu_help,
            android.R.drawable.ic_menu_info_details
        },
        wrong = {
            android.R.drawable.ic_menu_camera,
            android.R.drawable.ic_menu_call,
            android.R.drawable.ic_menu_gallery,
            android.R.drawable.ic_menu_crop
        }
    },

    {
        question = "Select MUSIC items",
        correct = {
            android.R.drawable.ic_media_ff,
            android.R.drawable.ic_media_rew
        },
        wrong = {
            android.R.drawable.ic_menu_camera,
            android.R.drawable.ic_menu_call,
            android.R.drawable.ic_menu_gallery,
            android.R.drawable.ic_menu_compass
        }
    },

    {
        question = "Select CALENDAR items",
        correct = {
            android.R.drawable.ic_menu_today,
            android.R.drawable.ic_menu_my_calendar
        },
        wrong = {
            android.R.drawable.ic_menu_camera,
            android.R.drawable.ic_menu_call,
            android.R.drawable.ic_menu_gallery,
            android.R.drawable.ic_menu_crop
        }
    },

    {
        question = "Select SETTINGS items",
        correct = {
            android.R.drawable.ic_menu_manage,
            android.R.drawable.ic_menu_preferences
        },
        wrong = {
            android.R.drawable.ic_menu_camera,
            android.R.drawable.ic_menu_call,
            android.R.drawable.ic_menu_gallery,
            android.R.drawable.ic_menu_help
        }
    }

}

local function createCaptcha()
    local q = questions[math.random(#questions)]

    local icons = {}

    for _, v in ipairs(q.correct) do
        icons[#icons + 1] = {
            icon = v,
            correct = true
        }
    end

    for _, v in ipairs(q.wrong) do
        icons[#icons + 1] = {
            icon = v,
            correct = false
        }
    end

    shuffle(icons)

    local root = LinearLayout(activity)
    root.setOrientation(LinearLayout.VERTICAL)
    root.setPadding(35, 35, 35, 35)

    root.setBackground(
        bg(
            30,
            Color.BLACK,
            Color.argb(255, 80, 80, 80)
        )
    )

    local title = TextView(activity)
    title.setText("VERIFICATION")
    title.setTextSize(20)
    title.setTextColor(Color.WHITE)
    title.setGravity(Gravity.CENTER)
    title.setPadding(0, 0, 0, 20)

    root.addView(title)

    local question = TextView(activity)
    question.setText(q.question)
    question.setTextSize(17)
    question.setTextColor(Color.WHITE)
    question.setGravity(Gravity.CENTER)
    question.setPadding(0, 0, 0, 20)

    root.addView(question)

    local status = TextView(activity)
    status.setText("Select 2 images")
    status.setTextSize(14)
    status.setGravity(Gravity.CENTER)
    status.setTextColor(
        Color.argb(255, 180, 180, 180)
    )
    status.setPadding(0, 0, 0, 20)

    root.addView(status)

    local selected = {}

    local index = 1

    for row = 1, 2 do
        local line = LinearLayout(activity)
        line.setGravity(Gravity.CENTER)

        for col = 1, 3 do
            local currentIndex = index
            local item = icons[currentIndex]

            local holder = LinearLayout(activity)

            holder.setPadding(12, 12, 12, 12)

            local lp = LinearLayout.LayoutParams(
                -2,
                -2
            )

            lp.leftMargin = 12
            lp.rightMargin = 12
            lp.bottomMargin = 12

            holder.setLayoutParams(lp)

            holder.setBackground(
                bg(
                    25,
                    Color.argb(255, 0, 180, 70),
                    Color.argb(255, 0, 255, 120)
                )
            )

            local img = ImageView(activity)

            img.setImageResource(item.icon)

            local imgLp = LinearLayout.LayoutParams(
                140,
                140
            )

            img.setLayoutParams(imgLp)

            local isSelected = false

            holder.setOnClickListener(
                luajava.createProxy(
                    "android.view.View$OnClickListener",
                    {
                        onClick = function(v)
                            isSelected = not isSelected

                            if isSelected then
                                holder.setBackground(
                                    bg(
                                        25,
                                        Color.argb(255, 20, 20, 20),
                                        Color.argb(255, 70, 70, 70)
                                    )
                                )

                                selected[currentIndex] = true
                            else
                                holder.setBackground(
                                    bg(
                                        25,
                                        Color.argb(255, 0, 180, 70),
                                        Color.argb(255, 0, 255, 120)
                                    )
                                )

                                selected[currentIndex] = nil
                            end

                            local count = 0

                            for _ in pairs(selected) do
                                count = count + 1
                            end

                            status.setText(
                                "Selected: " ..
                                count ..
                                "/2"
                            )
                        end
                    }
                )
            )
            holder.addView(img)
            line.addView(holder)

            index = index + 1
        end

        root.addView(line)
    end

    local confirm = Button(activity)

    confirm.setText("CONFIRM")
    confirm.setTextColor(Color.WHITE)
    confirm.setTextSize(16)

    confirm.setBackground(
        bg(
            25,
            Color.argb(255, 20, 140, 60),
            Color.argb(255, 0, 255, 120)
        )
    )

    local confirmWrap = LinearLayout(activity)
    confirmWrap.setGravity(Gravity.CENTER)
    confirmWrap.setPadding(0, 20, 0, 0)

    confirmWrap.addView(confirm)

    root.addView(confirmWrap)

    return {
        root = root,
        confirm = confirm,
        status = status,
        selected = selected,
        icons = icons
    }
end

local params = luajava.newInstance(
    "android.view.WindowManager$LayoutParams",
    -2,
    -2,
    getType(),
    0x00000008,
    PixelFormat.TRANSLUCENT
)

params.gravity = Gravity.CENTER

local function startCaptcha()
    local data = createCaptcha()

    local wm = activity.getWindowManager()

    activity.runOnUiThread(
        luajava.createProxy(
            "java.lang.Runnable",
            {
                run = function()
                    wm.addView(data.root, params)
                end
            }
        )
    )

    local handler = Handler(
        Looper.getMainLooper()
    )

    data.confirm.setOnClickListener(
        luajava.createProxy(
            "android.view.View$OnClickListener",
            {
                onClick = function(v)
                    local total = 0
                    local correct = 0

                    for i, _ in pairs(data.selected) do
                        total = total + 1

                        if data.icons[i].correct then
                            correct = correct + 1
                        end
                    end

                    if total == 2 and correct == 2 then
                        data.status.setText("CORRECT")
                        data.status.setTextColor(
                            Color.argb(255, 0, 255, 120)
                        )

                        handler.postDelayed(
                            luajava.createProxy(
                                "java.lang.Runnable",
                                {
                                    run = function()
                                        wm.removeView(data.root)
                                        gg.toast("Verified")
                                    end
                                }
                            ),
                            1000
                        )
                    else
                        data.status.setText("WRONG")
                        data.status.setTextColor(
                            Color.argb(255, 255, 80, 80)
                        )

                        handler.postDelayed(
                            luajava.createProxy(
                                "java.lang.Runnable",
                                {
                                    run = function()
                                        wm.removeView(data.root)
                                        startCaptcha()
                                    end
                                }
                            ),
                            1000
                        )
                    end
                end
            }
        )
    )
end

startCaptcha()