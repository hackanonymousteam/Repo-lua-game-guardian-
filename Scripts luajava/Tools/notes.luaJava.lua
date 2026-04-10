import 'android.app.*'
import 'android.os.*'
import 'android.widget.*'
import 'android.view.*'
import 'android.content.*'
import 'java.util.*'
import 'java.lang.*'
import 'android.*'
import 'android.graphics.drawable.*'
import 'android.graphics.PixelFormat'
import 'android.view.animation.Animation'
import 'android.view.animation.AnimationUtils'
import 'android.view.animation.RotateAnimation'
import 'android.animation.ObjectAnimator'
import 'android.view.animation.DecelerateInterpolator'
import 'android.ext.*'
import 'android.view.inputmethod.InputMethodManager'
import 'android.widget.ListView'
import 'android.widget.ArrayAdapter'
import 'android.widget.AdapterView'
import 'android.widget.LinearLayout'
import 'android.widget.EditText'
import 'android.widget.TextView'
import 'android.text.InputType'
import 'android.view.inputmethod.EditorInfo'

context = activity
window = context.getSystemService(Context.WINDOW_SERVICE)

function getLayoutParams()
    local LayoutParams = WindowManager.LayoutParams
    local layoutParams = luajava.new(LayoutParams)
    
    layoutParams.type = (Build.VERSION.SDK_INT >= 26) and LayoutParams.TYPE_APPLICATION_OVERLAY or LayoutParams.TYPE_PHONE
    layoutParams.format = PixelFormat.RGBA_8888
    layoutParams.flags = bit32.bor(LayoutParams.FLAG_NOT_TOUCH_MODAL, LayoutParams.FLAG_LAYOUT_IN_SCREEN)
    layoutParams.gravity = Gravity.CENTER
    layoutParams.width = LayoutParams.WRAP_CONTENT
    layoutParams.height = LayoutParams.WRAP_CONTENT
    
    return layoutParams
end

notesApp = {
    LinearLayout,
    orientation = "vertical",
    layout_width = "fill",
    layout_height = "wrap_content",
    padding = "16dp",
    background = "#f4f4f4",
    
    {
        TextView,
        text = "Notes App",
        textSize = "24sp",
        textColor = "#333333",
        gravity = "center",
        layout_marginBottom = "20dp",
    },
    
    {
        LinearLayout,
        orientation = "horizontal",
        layout_width = "fill",
        layout_height = "wrap_content",
        layout_marginBottom = "20dp",
        
        {
            EditText,
            id = "searchInput",
            layout_width = "0dp",
            layout_height = "wrap_content",
            layout_weight = "1",
            hint = "Search notes",
            padding = "10dp",
            textSize = "16sp",
        },
        
        {
            Button,
            id = "searchButton",
            text = "Search",
            layout_width = "wrap_content",
            layout_height = "wrap_content",
            padding = "10dp",
            textSize = "16sp",
        },
    },
    
    {
        LinearLayout,
        orientation = "vertical",
        layout_width = "fill",
        layout_height = "wrap_content",
        layout_marginBottom = "20dp",
        
        {
            TextView,
            text = "Enter your note:",
            textSize = "16sp",
            layout_marginBottom = "5dp",
        },
        
        {
            EditText,
            id = "noteInput",
            layout_width = "fill",
            layout_height = "wrap_content",
            padding = "10dp",
            textSize = "16sp",
            textColor = "#000000",
            layout_marginBottom = "15dp",
        },
        
        {
            Button,
            id = "saveButton",
            text = "Save Note",
            layout_width = "fill",
            layout_height = "wrap_content",
            padding = "10dp",
            textSize = "16sp",
            background = "#4CAF50",
            textColor = "#FFFFFF",
        },
        
        {
            Button,
            id = "exitButton",
            text = "Exit",
            layout_width = "fill",
            layout_height = "wrap_content",
            padding = "10dp",
            textSize = "16sp",
            background = "#f44336",
            textColor = "#FFFFFF",
            layout_marginTop = "10dp",
        },
    },
    
    {
        ScrollView,
        layout_width = "fill",
        layout_height = "wrap_content",
        
        {
            LinearLayout,
            id = "notesContainer",
            orientation = "vertical",
            layout_width = "fill",
            layout_height = "wrap_content",
        },
    },
}

mainLayoutParams = getLayoutParams()
notesApp = loadlayout(notesApp)

local sharedPref = activity.getSharedPreferences("NotesApp", Context.MODE_PRIVATE)
local savedNotes = {}

local function loadNotes()
    local notesJson = sharedPref.getString("notes", "[]")
    savedNotes = luajava.newInstance("org.json.JSONArray", notesJson)
end

local function saveNotes()
    local editor = sharedPref.edit()
    editor.putString("notes", savedNotes.toString())
    editor.apply()
end

local function displayNotes(searchTerm)
    notesContainer.removeAllViews()
    
    for i=0,savedNotes.length()-1 do
        local note = savedNotes.getJSONObject(i)
        local noteText = note.getString("text")
        local noteDate = note.getString("date")
        
        if searchTerm == nil or string.find(string.lower(noteText), string.lower(searchTerm)) then
            local noteLayout = {
                LinearLayout,
                orientation = "vertical",
                layout_width = "fill",
                layout_height = "wrap_content",
                padding = "15dp",
                background = "#FFFFFF",
                layout_marginBottom = "10dp",
                elevation = "2dp",
                
                {
                    TextView,
                    text = noteText,
                    textSize = "14sp",
                    textColor = "#000000",
                    layout_marginBottom = "5dp",
                },
                
                {
                    TextView,
                    text = "Date: "..noteDate,
                    textSize = "12sp",
                    textColor = "#666666",
                    layout_marginBottom = "10dp",
                },
                
                {
                    Button,
                    text = "Delete",
                    layout_width = "wrap_content",
                    layout_height = "wrap_content",
                    padding = "8dp",
                    textSize = "14sp",
                    background = "#ff4d4d",
                    textColor = "#FFFFFF",
                    onClick = function()
                        savedNotes.remove(i)
                        saveNotes()
                        displayNotes(searchInput.Text)
                    end,
                },
            }
            
            local noteView = loadlayout(noteLayout)
            notesContainer.addView(noteView)
        end
    end
end

local function addNote()
    local noteText = noteInput.Text
    if noteText ~= "" then
        local newNote = luajava.newInstance("org.json.JSONObject")
        newNote.put("text", noteText)
        newNote.put("date", os.date("%d/%m/%Y %H:%M:%S"))
        
        savedNotes.put(newNote)
        saveNotes()
        noteInput.Text = ""
        displayNotes()
    end
end

loadNotes()
displayNotes()

saveButton.onClick = function()
    addNote()
end

searchButton.onClick = function()
    displayNotes(searchInput.Text)
end

exitButton.onClick = function()
    window.removeView(notesApp)
    os.exit()
end

function setUi()
    function invoke()
        window.addView(notesApp, mainLayoutParams)
    end
    activity.postFunc(invoke)
end

setUi()