
if not luajava then
    print("LuaJava NOT Available!")
    return
end

if not newPaint() then
    print("Paint NOT Available!")
    return
end

if not drawCircle then
    print("canvas NOT Available!")
    return
end



local Point = luajava.bindClass("android.graphics.Point")
local Context = luajava.bindClass("android.content.Context")

local function getFbl()

    local wm =
        activity.getSystemService(
            Context.WINDOW_SERVICE
        )

    local point = Point()

    wm.getDefaultDisplay().getRealSize(point)

    return {
        width = point.x,
        height = point.y
    }
end

local screen = getFbl()

local Screen_X = screen.width
local Screen_Y = screen.height

math.randomseed(os.time())

local snake = {}

local snakeSize = 14

local ballSize = 26

local speed = 18

local directionX = speed
local directionY = speed

local posX = Screen_X / 2
local posY = Screen_Y / 2

for i = 1, snakeSize do

    table.insert(
        snake,
        {
            x = posX,
            y = posY
        }
    )

end

local bgPaint = newPaint()
bgPaint:setColor("#101010")

local snakePaint = newPaint()
snakePaint:setColor("#00FF88")

local headPaint = newPaint()
headPaint:setColor("#00E5FF")

local glowPaint = newPaint()
glowPaint:setColor("#FF1744")

local textPaint = newPaint()
textPaint:setColor("#FFFFFF")
textPaint:setTextSize(40)

local trailPaint = newPaint()
trailPaint:setColor("#444444")

if trailPaint.setStrokeWidth then
    trailPaint:setStrokeWidth(3)
end

local view = newView()

local function randomDirection()

    local dirs = {
        { speed, 0 },
        { -speed, 0 },
        { 0, speed },
        { 0, -speed },
        { speed, speed },
        { -speed, speed },
        { speed, -speed },
        { -speed, -speed }
    }

    local pick =
        dirs[math.random(1, #dirs)]

    directionX = pick[1]
    directionY = pick[2]

end

view:show(function(canvas)

    posX = posX + directionX
    posY = posY + directionY

    if posX <= ballSize then

        posX = ballSize

        directionX = math.abs(directionX)

        randomDirection()

    end

    if posX >= Screen_X - ballSize then

        posX = Screen_X - ballSize

        directionX = -math.abs(directionX)

        randomDirection()

    end

    if posY <= ballSize then

        posY = ballSize

        directionY = math.abs(directionY)

        randomDirection()

    end

    if posY >= Screen_Y - ballSize then

        posY = Screen_Y - ballSize

        directionY = -math.abs(directionY)

        randomDirection()

    end

    table.insert(
        snake,
        1,
        {
            x = posX,
            y = posY
        }
    )

    while #snake > snakeSize do
        table.remove(snake)
    end

    for i = #snake, 2, -1 do

        local p1 = snake[i]
        local p2 = snake[i - 1]

        canvas:drawLine(
            p1.x,
            p1.y,
            p2.x,
            p2.y,
            trailPaint
        )

    end

    for i, segment in ipairs(snake) do

        local size =
            ballSize - (i * 1.2)

        if size < 6 then
            size = 6
        end

        if i == 1 then

            canvas:drawCircle(
                segment.x,
                segment.y,
                size,
                headPaint
            )

            canvas:drawCircle(
                segment.x,
                segment.y,
                size + 10,
                glowPaint
            )

        else

            canvas:drawCircle(
                segment.x,
                segment.y,
                size,
                snakePaint
            )

        end
    end

    canvas:drawText(
        "DVD SNAKE",
        50,
        80,
        textPaint
    )

    canvas:drawText(
        "X: " .. math.floor(posX),
        50,
        130,
        textPaint
    )

    canvas:drawText(
        "Y: " .. math.floor(posY),
        50,
        180,
        textPaint
    )

end, 16)

while true do

    view:invalidate()

    gg.sleep(16)

end