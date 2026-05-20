gg.setVisible(false)

if not activity then
    gg.alert("No activity")
    return
end

local function bind(c)
    local ok, r = pcall(luajava.bindClass, c)
    if ok then
        return r
    end
    return nil
end

local TextView = bind("android.widget.TextView")
local PixelFormat = bind("android.graphics.PixelFormat")
local Gravity = bind("android.view.Gravity")
local Color = bind("android.graphics.Color")
local Build = bind("android.os.Build")
local Button = bind("android.widget.Button")
local LinearLayout = bind("android.widget.LinearLayout")
local ScrollView = bind("android.widget.ScrollView")
local Pattern = bind("java.util.regex.Pattern")
local ForegroundColorSpan = bind("android.text.style.ForegroundColorSpan")
local SpannableStringBuilder = bind("android.text.SpannableStringBuilder")

local function getType()
    if Build.VERSION.SDK_INT >= 26 then
        return 2038
    elseif Build.VERSION.SDK_INT >= 23 then
        return 2002
    else
        return 2003
    end
end

local params = luajava.newInstance(
    "android.view.WindowManager$LayoutParams",
    -2,
    -2,
    getType(),
    0x00000008,
    PixelFormat.TRANSLUCENT
)

params.gravity = Gravity.TOP + Gravity.LEFT
params.x = 50
params.y = 200

local function createHighlight(builder, text, regex, color)
    local pattern = Pattern.compile(regex)
    local matcher = pattern.matcher(text)

    while matcher:find() do
        local s = matcher:start()
        local e = matcher["end"](matcher)

        builder.setSpan(
            ForegroundColorSpan(color),
            s,
            e,
            33
        )
    end
end

local function createLayout()
    local root = LinearLayout(activity)
    root.setOrientation(1)
    root.setPadding(25, 25, 25, 25)
    root.setBackgroundColor(Color.parseColor("#FF1E1E1E"))

    local title = TextView(activity)
    title.setText("JAVA SYNTAX")
    title.setTextColor(Color.YELLOW)
    title.setTextSize(16)

    root.addView(title)

    local scroll = ScrollView(activity)

    local code = [[public class MainActivity extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);

        // comment

        String text = "Hello World";
        int number = 12345;

        if (number > 0) {
            System.out.println(text);
        }
    }
}]]

    local builder = SpannableStringBuilder(code)

    createHighlight(
        builder,
        code,
        "\\b(public|class|extends|protected|void|int|if|String|Activity|Bundle|Override|System)\\b",
        Color.parseColor("#42a5f5")
    )

    createHighlight(
        builder,
        code,
        "\\b(onCreate|println)\\b",
        Color.parseColor("#5c6bc0")
    )

    createHighlight(
        builder,
        code,
        "\"[^\"]*\"",
        Color.parseColor("#ff1744")
    )

    createHighlight(
        builder,
        code,
        "\\b[0-9]+\\b",
        Color.parseColor("#26a69a")
    )

    createHighlight(
        builder,
        code,
        "//[^\\n]*",
        Color.parseColor("#9e9e9e")
    )

    createHighlight(
        builder,
        code,
        "@\\w+",
        Color.parseColor("#26a69a")
    )

    local codeView = TextView(activity)
    codeView.setText(builder)
    codeView.setTextSize(13)
    codeView.setTextColor(Color.WHITE)
    codeView.setPadding(30, 30, 30, 30)
    codeView.setBackgroundColor(Color.parseColor("#FF263238"))

    scroll.addView(codeView)

    root.addView(scroll)

    local close = Button(activity)
    close.setText("CLOSE")
    close.setTextColor(Color.WHITE)
    close.setBackgroundColor(Color.RED)

    root.addView(close)

    local wm = activity.getWindowManager()

    wm.addView(root, params)

    close.setOnClickListener(
        luajava.createProxy(
            "android.view.View$OnClickListener",
            {
                onClick = function(v)
                    wm.removeView(root)
                end
            }
        )
    )
end

local function startUI()
    activity.runOnUiThread(
        luajava.createProxy(
            "java.lang.Runnable",
            {
                run = function()
                    createLayout()
                end
            }
        )
    )
end

startUI()