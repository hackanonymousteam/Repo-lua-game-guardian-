
local function load_and_run_script()

 file_path = gg.prompt({
    "Select File to Inspect",
}, {
    "/sdcard/",
}, {
    "file",
})

if file_path == nil or file_path[1] == nil then
    print("No file selected")
    return
end

local library_choice = gg.choice({
    "debug",
    "gg",
    "io",
    "os",
    "string",
    "table",
    "math",
    "bit32",
    "utf8"
}, nil, "Select Library to Inspect")

if library_choice == nil then
    print("No library selected")
    return
end

if library_choice == 1 then
    inspect_debug()
 A()
elseif library_choice == 2 then
    inspect_gg()
     A()
elseif library_choice == 3 then
    inspect_io()
A()
elseif library_choice == 4 then
    inspect_os()
    A()
elseif library_choice == 5 then
    inspect_string()
A()
elseif library_choice == 6 then
    inspect_table()
    A()
elseif library_choice == 7 then
    inspect_math()
    A()
elseif library_choice == 8 then
    inspect_bit32()
A()
elseif library_choice == 9 then
    inspect_utf8()
A()
    end
end

function A()
local f = loadfile(file_path[1])
        if f then
            pcall(f)
        else
            print("Failed to load the file.")
        end
        end

 function inspect_debug()
    local debug_options = gg.multiChoice({
        "debug.debug()",
        "debug.gethook()",
        "debug.getinfo()",
        "debug.getlocal()",
        "debug.getmetatable()",
        "debug.getregistry()",
        "debug.getupvalue()",
        "debug.sethook()",
        "debug.setlocal()",
        "debug.setmetatable()",
        "debug.setupvalue()",
        "debug.traceback()",
        "debug.upvalueid()",
        "debug.upvaluejoin()",
        "All Functions"
    }, nil, "Select Debug Functions to Inspect")
    
    if debug_options == nil then return end
    
    local orig_debug = {}
    for k,v in pairs(debug) do orig_debug[k] = v end
    
    if debug_options[1] or debug_options[15] then
        debug.debug = function() print("debug.debug() called") end
    end
    if debug_options[2] or debug_options[15] then
        debug.gethook = function() print("debug.gethook() called") end
    end
    if debug_options[3] or debug_options[15] then
        debug.getinfo = function(f, what) 
            print([[debug.getinfo(]]..tostring(f)..[[, "]]..(what or "")..[[") called]])
            return orig_debug.getinfo(f, what)
        end
    end
    if debug_options[4] or debug_options[15] then
        debug.getlocal = function(level, loc) 
            print([[debug.getlocal(]]..level..[[, ]]..loc..[[) called]])
            return orig_debug.getlocal(level, loc)
        end
    end
    if debug_options[5] or debug_options[15] then
        debug.getmetatable = function(obj) 
            print([[debug.getmetatable(]]..tostring(obj)..[[) called]])
            return orig_debug.getmetatable(obj)
        end
    end
    if debug_options[6] or debug_options[15] then
        debug.getregistry = function() 
            print("debug.getregistry() called")
            return orig_debug.getregistry()
        end
    end
    if debug_options[7] or debug_options[15] then
        debug.getupvalue = function(f, up) 
            print([[debug.getupvalue(]]..tostring(f)..[[, ]]..up..[[) called]])
            return orig_debug.getupvalue(f, up)
        end
    end
    if debug_options[8] or debug_options[15] then
        debug.sethook = function(hook, mask, count) 
            print([[debug.sethook(]]..tostring(hook)..[[, "]]..mask..[[", ]]..count..[[) called]])
            return orig_debug.sethook(hook, mask, count)
        end
    end
    if debug_options[9] or debug_options[15] then
        debug.setlocal = function(level, loc, value) 
            print([[debug.setlocal(]]..level..[[, ]]..loc..[[, ]]..tostring(value)..[[) called]])
            return orig_debug.setlocal(level, loc, value)
        end
    end
    if debug_options[10] or debug_options[15] then
        debug.setmetatable = function(obj, mt) 
            print([[debug.setmetatable(]]..tostring(obj)..[[, ]]..tostring(mt)..[[) called]])
            return orig_debug.setmetatable(obj, mt)
        end
    end
    if debug_options[11] or debug_options[15] then
        debug.setupvalue = function(f, up, value) 
            print([[debug.setupvalue(]]..tostring(f)..[[, ]]..up..[[, ]]..tostring(value)..[[) called]])
            return orig_debug.setupvalue(f, up, value)
        end
    end
    if debug_options[12] or debug_options[15] then
        debug.traceback = function(x) 
            print([[debug.traceback(]]..tostring(x)..[[) called]])
            return orig_debug.traceback(x)
        end
    end
    if debug_options[13] or debug_options[15] then
        debug.upvalueid = function(f, n) 
            print([[debug.upvalueid(]]..tostring(f)..[[, ]]..n..[[) called]])
            return orig_debug.upvalueid(f, n)
        end
    end
    if debug_options[14] or debug_options[15] then
        debug.upvaluejoin = function(f1, n1, f2, n2) 
            print([[debug.upvaluejoin(]]..tostring(f1)..[[, ]]..n1..[[, ]]..tostring(f2)..[[, ]]..n2..[[) called]])
            return orig_debug.upvaluejoin(f1, n1, f2, n2)
        end
    end
end

 function inspect_gg()
    local gg_options = gg.multiChoice({
        "gg.alert()",
        "gg.toast()",
        "gg.sleep()",
        "gg.clearResults()",
        "gg.setVisible()",
        "gg.setRanges()",
        "gg.searchNumber()",
        "gg.getResults()",
        "gg.editAll()",
        "gg.loadList()",
        "gg.clearList()",
        "gg.addListItems()",
        "gg.choice()",
        "gg.prompt()",
        "All Functions"
    }, nil, "Select GG Functions to Inspect")
    
    if gg_options == nil then return end
    
    local orig_gg = {}
    for k,v in pairs(gg) do orig_gg[k] = v end
    
    if gg_options[1] or gg_options[15] then
        gg.alert = function(alert) print([[gg.alert("]]..alert..[[") called]]) end
    end
    if gg_options[2] or gg_options[15] then
        gg.toast = function(toast) print([[gg.toast("]]..toast..[[") called]]) end
    end
    if gg_options[3] or gg_options[15] then
        gg.sleep = function(sleep) print([[gg.sleep(]]..sleep..[[) called]]) end
    end
    if gg_options[4] or gg_options[15] then
        gg.clearResults = function() print("gg.clearResults() called") end
    end
    if gg_options[5] or gg_options[15] then
        gg.setVisible = function(visible) print([[gg.setVisible(]]..tostring(visible)..[[) called]]) end
    end
    if gg_options[6] or gg_options[15] then
        gg.setRanges = function(ranges) print([[gg.setRanges(]]..ranges..[[) called]]) end
    end
    if gg_options[7] or gg_options[15] then
        gg.searchNumber = function(searchnumber) print([[gg.searchNumber("]]..searchnumber..[[") called]]) end
    end
    if gg_options[8] or gg_options[15] then
        gg.getResults = function(count) print([[gg.getResults(]]..count..[[) called]]) end
    end
    if gg_options[9] or gg_options[15] then
        gg.editAll = function(editall) print([[gg.editAll("]]..editall..[[") called]]) end
    end
    if gg_options[10] or gg_options[15] then
        gg.loadList = function(path) 
            print([[gg.loadList("]]..path..[[") called]])
            return orig_gg.loadList(path)
        end
    end
    if gg_options[11] or gg_options[15] then
        gg.clearList = function() print("gg.clearList() called") end
    end
    if gg_options[12] or gg_options[15] then
        gg.addListItems = function(items) 
            print([[gg.addListItems(table) called]])
            return orig_gg.addListItems(items)
        end
    end
    if gg_options[13] or gg_options[15] then
        gg.choice = function(items, selected, message) 
            print([[gg.choice(table, ]]..tostring(selected)..[[, ]]..tostring(message)..[[) called]])
            return orig_gg.choice(items, selected, message)
        end
    end
    if gg_options[14] or gg_options[15] then
        gg.prompt = function(prompts, defaults, types) 
            print([[gg.prompt(table, table, table) called]])
            return orig_gg.prompt(prompts, defaults, types)
        end
    end
    
    gg.ANDROID_SDK_INT = 29
    gg.ASM_ARM = 4
    gg.ASM_ARM64 = 6
    gg.ASM_THUMB = 5
    gg.BUILD = 16142
    gg.CACHE_DIR = '/data/user/0/com.xexipw/cache'
    gg.DUMP_SKIP_SYSTEM_LIBS = 1
    gg.EXT_CACHE_DIR = '/storage/emulated/0/Android/data/com.xexipw/cache'
    gg.EXT_FILES_DIR = '/storage/emulated/0/Android/data/com.xexipw/files'
    gg.EXT_STORAGE = '/storage/emulated/0'
    gg.FILES_DIR = '/data/user/0/com.xexipw/files'
    gg.FREEZE_IN_RANGE = 3
    gg.FREEZE_MAY_DECREASE = 2
    gg.FREEZE_MAY_INCREASE = 1
    gg.FREEZE_NORMAL = 0
    gg.LOAD_APPEND = 8
    gg.LOAD_VALUES = 2
    gg.LOAD_VALUES_FREEZE = 3
    gg.PACKAGE = 'com.xexipw'
    gg.POINTER_EXECUTABLE = 2
    gg.POINTER_EXECUTABLE_WRITABLE = 1
    gg.POINTER_NO = 4
    gg.POINTER_READ_ONLY = 8
    gg.POINTER_WRITABLE = 16
    gg.PROT_EXEC = 4
    gg.PROT_NONE = 0
    gg.PROT_READ = 2
    gg.PROT_WRITE = 1
    gg.REGION_ANONYMOUS = 32
    gg.REGION_ASHMEM = 524288
    gg.REGION_BAD = 131072
    gg.REGION_CODE_APP = 16384
    gg.REGION_CODE_SYS = 32768
    gg.REGION_C_ALLOC = 4
    gg.REGION_C_BSS = 16
    gg.REGION_C_DATA = 8
    gg.REGION_C_HEAP = 1
    gg.REGION_JAVA = 65536
    gg.REGION_JAVA_HEAP = 2
    gg.REGION_OTHER = -2080896
    gg.REGION_PPSSPP = 262144
    gg.REGION_STACK = 64
    gg.REGION_VIDEO = 1048576
    gg.SAVE_AS_TEXT = 1
    gg.SIGN_EQUAL = 536870912
    gg.SIGN_FUZZY_EQUAL = 536870912
    gg.SIGN_FUZZY_GREATER = 67108864
    gg.SIGN_FUZZY_LESS = 134217728
    gg.SIGN_FUZZY_NOT_EQUAL = 268435456
    gg.SIGN_GREATER_OR_EQUAL = 67108864
    gg.SIGN_LESS_OR_EQUAL = 134217728
    gg.SIGN_NOT_EQUAL = 268435456
    gg.TAB_MEMORY_EDITOR = 3
    gg.TAB_SAVED_LIST = 2
    gg.TAB_SEARCH = 1
    gg.TAB_SETTINGS = 0
    gg.TYPE_AUTO = 127
    gg.TYPE_BYTE = 1
    gg.TYPE_DOUBLE = 64
    gg.TYPE_DWORD = 4
    gg.TYPE_FLOAT = 16
    gg.TYPE_QWORD = 32
    gg.TYPE_WORD = 2
    gg.TYPE_XOR = 8
    gg.VERSION = '101.1'
    gg.VERSION_INT = 10101
end

 function inspect_io()
    local io_options = gg.multiChoice({
        "io.close()",
        "io.flush()",
        "io.input()",
        "io.lines()",
        "io.open()",
        "io.output()",
        "io.popen()",
        "io.read()",
        "io.tmpfile()",
        "io.type()",
        "io.write()",
        "All Functions"
    }, nil, "Select IO Functions to Inspect")
    
    if io_options == nil then return end
    
    local orig_io = {}
    for k,v in pairs(io) do orig_io[k] = v end
    
    if io_options[1] or io_options[12] then
        io.close = function(file) print([[io.close(]]..tostring(file)..[[) called]]) end
    end
    if io_options[2] or io_options[12] then
        io.flush = function() print("io.flush() called") end
    end
    if io_options[3] or io_options[12] then
        io.input = function(file) print([[io.input(]]..tostring(file)..[[) called]]) end
    end
    if io_options[4] or io_options[12] then
        io.lines = function(filename, ...) 
            print([[io.lines("]]..(filename or "")..[[", ...) called]])
            return orig_io.lines(filename, ...)
        end
    end
    if io_options[5] or io_options[12] then
        io.open = function(filename, mode) 
            print([[io.open("]]..filename..[[", "]]..(mode or "")..[[") called]])
            return orig_io.open(filename, mode)
        end
    end
    if io_options[6] or io_options[12] then
        io.output = function(file) print([[io.output(]]..tostring(file)..[[) called]]) end
    end
    if io_options[7] or io_options[12] then
        io.popen = function(prog, mode) 
            print([[io.popen("]]..prog..[[", "]]..(mode or "")..[[") called]])
            return orig_io.popen(prog, mode)
        end
    end
    if io_options[8] or io_options[12] then
        io.read = function(...) 
            print("io.read(...) called")
            return orig_io.read(...)
        end
    end
    if io_options[9] or io_options[12] then
        io.tmpfile = function() 
            print("io.tmpfile() called")
            return orig_io.tmpfile()
        end
    end
    if io_options[10] or io_options[12] then
        io.type = function(obj) 
            print([[io.type(]]..tostring(obj)..[[) called]])
            return orig_io.type(obj)
        end
    end
    if io_options[11] or io_options[12] then
        io.write = function(...) 
            print("io.write(...) called")
            return orig_io.write(...)
        end
    end
end

 function inspect_os()
    local os_options = gg.multiChoice({
        "os.clock()",
        "os.date()",
        "os.difftime()",
        "os.execute()",
        "os.exit()",
        "os.getenv()",
        "os.remove()",
        "os.rename()",
        "os.setlocale()",
        "os.time()",
        "os.tmpname()",
        "All Functions"
    }, nil, "Select OS Functions to Inspect")
    
    if os_options == nil then return end
    
    local orig_os = {}
    for k,v in pairs(os) do orig_os[k] = v end
    
    if os_options[1] or os_options[12] then
        os.clock = function() 
            print("os.clock() called")
            return orig_os.clock()
        end
    end
    if os_options[2] or os_options[12] then
        os.date = function(format, time) 
            print([[os.date("]]..(format or "")..[[", ]]..tostring(time)..[[) called]])
            return orig_os.date(format, time)
        end
    end
    if os_options[3] or os_options[12] then
        os.difftime = function(t2, t1) 
            print([[os.difftime(]]..t2..[[, ]]..t1..[[) called]])
            return orig_os.difftime(t2, t1)
        end
    end
    if os_options[4] or os_options[12] then
        os.execute = function(command) 
            print([[os.execute("]]..command..[[") called]])
            return orig_os.execute(command)
        end
    end
    if os_options[5] or os_options[12] then
        os.exit = function(code, close) 
            print([[os.exit(]]..tostring(code)..[[, ]]..tostring(close)..[[) called]])
            return orig_os.exit(code, close)
        end
    end
    if os_options[6] or os_options[12] then
        os.getenv = function(varname) 
            print([[os.getenv("]]..varname..[[") called]])
            return orig_os.getenv(varname)
        end
    end
    if os_options[7] or os_options[12] then
        os.remove = function(filename) 
            print([[os.remove("]]..filename..[[") called]])
            return orig_os.remove(filename)
        end
    end
    if os_options[8] or os_options[12] then
        os.rename = function(oldname, newname) 
            print([[os.rename("]]..oldname..[[", "]]..newname..[[") called]])
            return orig_os.rename(oldname, newname)
        end
    end
    if os_options[9] or os_options[12] then
        os.setlocale = function(locale, category) 
            print([[os.setlocale("]]..locale..[[", "]]..(category or "")..[[") called]])
            return orig_os.setlocale(locale, category)
        end
    end
    if os_options[10] or os_options[12] then
        os.time = function(table) 
            print([[os.time(]]..tostring(table)..[[) called]])
            return orig_os.time(table)
        end
    end
    if os_options[11] or os_options[12] then
        os.tmpname = function() 
            print("os.tmpname() called")
            return orig_os.tmpname()
        end
    end
end

 function inspect_string()
    local string_options = gg.multiChoice({
        "string.byte()",
        "string.char()",
        "string.dump()",
        "string.find()",
        "string.format()",
        "string.gmatch()",
        "string.gsub()",
        "string.len()",
        "string.lower()",
        "string.match()",
        "string.pack()",
        "string.packsize()",
        "string.rep()",
        "string.reverse()",
        "string.sub()",
        "string.unpack()",
        "string.upper()",
        "All Functions"
    }, nil, "Select String Functions to Inspect")
    
    if string_options == nil then return end
    
    local orig_string = {}
    for k,v in pairs(string) do orig_string[k] = v end

    if string_options[1] or string_options[18] then
        string.byte = function(s, i, j) 
            print([[string.byte("]]..s..[[", ]]..(i or 1)..[[, ]]..(j or i or 1)..[[) called]])
            return orig_string.byte(s, i, j)
        end
    end
    if string_options[2] or string_options[18] then
        string.char = function(...) 
            print("string.char(...) called")
            return orig_string.char(...)
        end
    end
    if string_options[3] or string_options[18] then
        string.dump = function(func, strip) 
            print([[string.dump(]]..tostring(func)..[[, ]]..tostring(strip)..[[) called]])
            return orig_string.dump(func, strip)
        end
    end
    if string_options[4] or string_options[18] then
        string.find = function(s, pattern, init, plain) 
            print([[string.find("]]..s..[[", "]]..pattern..[[", ]]..(init or 1)..[[, ]]..tostring(plain)..[[) called]])
            return orig_string.find(s, pattern, init, plain)
        end
    end
    if string_options[5] or string_options[18] then
        string.format = function(formatstring, ...) 
            print([[string.format("]]..formatstring..[[", ...) called]])
            return orig_string.format(formatstring, ...)
        end
    end
    if string_options[6] or string_options[18] then
        string.gmatch = function(s, pattern) 
            print([[string.gmatch("]]..s..[[", "]]..pattern..[[") called]])
            return orig_string.gmatch(s, pattern)
        end
    end
    if string_options[7] or string_options[18] then
        string.gsub = function(s, pattern, repl, n) 
            print([[string.gsub("]]..s..[[", "]]..pattern..[[", ]]..tostring(repl)..[[, ]]..(n or -1)..[[) called]])
            return orig_string.gsub(s, pattern, repl, n)
        end
    end
    if string_options[8] or string_options[18] then
        string.len = function(s) 
            print([[string.len("]]..s..[[") called]])
            return orig_string.len(s)
        end
    end
    if string_options[9] or string_options[18] then
        string.lower = function(s) 
            print([[string.lower("]]..s..[[") called]])
            return orig_string.lower(s)
        end
    end
    if string_options[10] or string_options[18] then
        string.match = function(s, pattern, init) 
            print([[string.match("]]..s..[[", "]]..pattern..[[", ]]..(init or 1)..[[) called]])
            return orig_string.match(s, pattern, init)
        end
    end
    if string_options[11] or string_options[18] then
        string.pack = function(fmt, ...) 
            print([[string.pack("]]..fmt..[[", ...) called]])
            return orig_string.pack(fmt, ...)
        end
    end
    if string_options[12] or string_options[18] then
        string.packsize = function(fmt) 
            print([[string.packsize("]]..fmt..[[") called]])
            return orig_string.packsize(fmt)
        end
    end
    if string_options[13] or string_options[18] then
        string.rep = function(s, n, sep) 
            print([[string.rep("]]..s..[[", ]]..n..[[, "]]..(sep or "")..[[") called]])
            return orig_string.rep(s, n, sep)
        end
    end
    if string_options[14] or string_options[18] then
        string.reverse = function(s) 
            print([[string.reverse("]]..s..[[") called]])
            return orig_string.reverse(s)
        end
    end
    if string_options[15] or string_options[18] then
        string.sub = function(s, i, j) 
            print([[string.sub("]]..s..[[", ]]..i..[[, ]]..(j or -1)..[[) called]])
            return orig_string.sub(s, i, j)
        end
    end
    if string_options[16] or string_options[18] then
        string.unpack = function(fmt, s, pos) 
            print([[string.unpack("]]..fmt..[[", "]]..s..[[", ]]..(pos or 1)..[[) called]])
            return orig_string.unpack(fmt, s, pos)
        end
    end
    if string_options[17] or string_options[18] then
        string.upper = function(s) 
            print([[string.upper("]]..s..[[") called]])
            return orig_string.upper(s)
        end
    end
end

 function inspect_table()
    local table_options = gg.multiChoice({
        "table.concat()",
        "table.insert()",
        "table.move()",
        "table.pack()",
        "table.remove()",
        "table.sort()",
        "table.unpack()",
        "All Functions"
    }, nil, "Select Table Functions to Inspect")
    
    if table_options == nil then return end
    
    local orig_table = {}
    for k,v in pairs(table) do orig_table[k] = v end
    
    if table_options[1] or table_options[8] then
        table.concat = function(list, sep, i, j) 
            print([[table.concat(]]..tostring(list)..[[, "]]..(sep or "")..[[", ]]..(i or 1)..[[, ]]..(j or #list)..[[) called]])
            return orig_table.concat(list, sep, i, j)
        end
    end
    if table_options[2] or table_options[8] then
        table.insert = function(list, pos, value) 
            print([[table.insert(]]..tostring(list)..[[, ]]..(type(pos) == "number" and pos or "nil")..[[, ]]..(type(pos) == "number" and tostring(value) or tostring(pos))..[[) called]])
            return orig_table.insert(list, pos, value)
        end
    end
    if table_options[3] or table_options[8] then
        table.move = function(a1, f, e, t, a2) 
            print([[table.move(]]..tostring(a1)..[[, ]]..f..[[, ]]..e..[[, ]]..t..[[, ]]..tostring(a2)..[[) called]])
            return orig_table.move(a1, f, e, t, a2)
        end
    end
    if table_options[4] or table_options[8] then
        table.pack = function(...) 
            print("table.pack(...) called")
            return orig_table.pack(...)
        end
    end
    if table_options[5] or table_options[8] then
        table.remove = function(list, pos) 
            print([[table.remove(]]..tostring(list)..[[, ]]..(pos or #list)..[[) called]])
            return orig_table.remove(list, pos)
        end
    end
    if table_options[6] or table_options[8] then
        table.sort = function(list, comp) 
            print([[table.sort(]]..tostring(list)..[[, ]]..tostring(comp)..[[) called]])
            return orig_table.sort(list, comp)
        end
    end
    if table_options[7] or table_options[8] then
        table.unpack = function(list, i, j) 
            print([[table.unpack(]]..tostring(list)..[[, ]]..(i or 1)..[[, ]]..(j or #list)..[[) called]])
            return orig_table.unpack(list, i, j)
        end
    end
end

 function inspect_math()
    local math_options = gg.multiChoice({
        "math.abs()",
        "math.acos()",
        "math.asin()",
        "math.atan()",
        "math.atan2()",
        "math.ceil()",
        "math.cos()",
        "math.cosh()",
        "math.deg()",
        "math.exp()",
        "math.floor()",
        "math.fmod()",
        "math.frexp()",
        "math.ldexp()",
        "math.log()",
        "math.max()",
        "math.min()",
        "math.modf()",
        "math.pow()",
        "math.rad()",
        "math.random()",
        "math.randomseed()",
        "math.sin()",
        "math.sinh()",
        "math.sqrt()",
        "math.tan()",
        "math.tanh()",
        "math.tointeger()",
        "math.type()",
        "math.ult()",
        "All Functions"
    }, nil, "Select Math Functions to Inspect")
    
    if math_options == nil then return end
    
    local orig_math = {}
    for k,v in pairs(math) do orig_math[k] = v end
    
    if math_options[1] or math_options[31] then
        math.abs = function(x) 
            print([[math.abs(]]..x..[[) called]])
            return orig_math.abs(x)
        end
    end
    if math_options[2] or math_options[31] then
        math.acos = function(x) 
            print([[math.acos(]]..x..[[) called]])
            return orig_math.acos(x)
        end
    end
    if math_options[3] or math_options[31] then
        math.asin = function(x) 
            print([[math.asin(]]..x..[[) called]])
            return orig_math.asin(x)
        end
    end
    if math_options[4] or math_options[31] then
        math.atan = function(y, x) 
            print([[math.atan(]]..y..(x and ", "..x or "")..[[) called]])
            return orig_math.atan(y, x)
        end
    end
    if math_options[5] or math_options[31] then
        math.atan2 = function(y, x) 
            print([[math.atan2(]]..y..[[, ]]..x..[[) called]])
            return orig_math.atan2(y, x)
        end
    end
    if math_options[6] or math_options[31] then
        math.ceil = function(x) 
            print([[math.ceil(]]..x..[[) called]])
            return orig_math.ceil(x)
        end
    end
    if math_options[7] or math_options[31] then
        math.cos = function(x) 
            print([[math.cos(]]..x..[[) called]])
            return orig_math.cos(x)
        end
    end
    if math_options[8] or math_options[31] then
        math.cosh = function(x) 
            print([[math.cosh(]]..x..[[) called]])
            return orig_math.cosh(x)
        end
    end
    if math_options[9] or math_options[31] then
        math.deg = function(x) 
            print([[math.deg(]]..x..[[) called]])
            return orig_math.deg(x)
        end
    end
    if math_options[10] or math_options[31] then
        math.exp = function(x) 
            print([[math.exp(]]..x..[[) called]])
            return orig_math.exp(x)
        end
    end
    if math_options[11] or math_options[31] then
        math.floor = function(x) 
            print([[math.floor(]]..x..[[) called]])
            return orig_math.floor(x)
        end
    end
    if math_options[12] or math_options[31] then
        math.fmod = function(x, y) 
            print([[math.fmod(]]..x..[[, ]]..y..[[) called]])
            return orig_math.fmod(x, y)
        end
    end
    if math_options[13] or math_options[31] then
        math.frexp = function(x) 
            print([[math.frexp(]]..x..[[) called]])
            return orig_math.frexp(x)
        end
    end
    if math_options[14] or math_options[31] then
        math.ldexp = function(m, e) 
            print([[math.ldexp(]]..m..[[, ]]..e..[[) called]])
            return orig_math.ldexp(m, e)
        end
    end
    if math_options[15] or math_options[31] then
        math.log = function(x, base) 
            print([[math.log(]]..x..(base and ", "..base or "")..[[) called]])
            return orig_math.log(x, base)
        end
    end
    if math_options[16] or math_options[31] then
        math.max = function(...) 
            print("math.max(...) called")
            return orig_math.max(...)
        end
    end
    if math_options[17] or math_options[31] then
        math.min = function(...) 
            print("math.min(...) called")
            return orig_math.min(...)
        end
    end
    if math_options[18] or math_options[31] then
        math.modf = function(x) 
            print([[math.modf(]]..x..[[) called]])
            return orig_math.modf(x)
        end
    end
    if math_options[19] or math_options[31] then
        math.pow = function(x, y) 
            print([[math.pow(]]..x..[[, ]]..y..[[) called]])
            return orig_math.pow(x, y)
        end
    end
    if math_options[20] or math_options[31] then
        math.rad = function(x) 
            print([[math.rad(]]..x..[[) called]])
            return orig_math.rad(x)
        end
    end
    if math_options[21] or math_options[31] then
        math.random = function(m, n) 
            print([[math.random(]]..(m and (n and m..", "..n or m) or "")..[[) called]])
            return orig_math.random(m, n)
        end
    end
    if math_options[22] or math_options[31] then
        math.randomseed = function(x) 
            print([[math.randomseed(]]..x..[[) called]])
            return orig_math.randomseed(x)
        end
    end
        if math_options[23] or math_options[31] then
        math.sin = function(x) 
            print([[math.sin(]]..x..[[) called]])
            return orig_math.sin(x)
        end
    end
    if math_options[24] or math_options[31] then
        math.sinh = function(x) 
            print([[math.sinh(]]..x..[[) called]])
            return orig_math.sinh(x)
        end
    end
    if math_options[25] or math_options[31] then
        math.sqrt = function(x) 
            print([[math.sqrt(]]..x..[[) called]])
            return orig_math.sqrt(x)
        end
    end
    if math_options[26] or math_options[31] then
        math.tan = function(x) 
            print([[math.tan(]]..x..[[) called]])
            return orig_math.tan(x)
        end
    end
    if math_options[27] or math_options[31] then
        math.tanh = function(x) 
            print([[math.tanh(]]..x..[[) called]])
            return orig_math.tanh(x)
        end
    end
    if math_options[28] or math_options[31] then
        math.tointeger = function(x) 
            print([[math.tointeger(]]..x..[[) called]])
            return orig_math.tointeger(x)
        end
    end
    if math_options[29] or math_options[31] then
        math.type = function(x) 
            print([[math.type(]]..x..[[) called]])
            return orig_math.type(x)
        end
    end
    if math_options[30] or math_options[31] then
        math.ult = function(m, n) 
            print([[math.ult(]]..m..[[, ]]..n..[[) called]])
            return orig_math.ult(m, n)
        end
    end
end

 function inspect_bit32()
    local bit32_options = gg.multiChoice({
        "bit32.arshift()",
        "bit32.band()",
        "bit32.bnot()",
        "bit32.bor()",
        "bit32.btest()",
        "bit32.bxor()",
        "bit32.extract()",
        "bit32.lrotate()",
        "bit32.lshift()",
        "bit32.replace()",
        "bit32.rrotate()",
        "bit32.rshift()",
        "All Functions"
    }, nil, "Select Bit32 Functions to Inspect")
    
    if bit32_options == nil then return end
    
    local orig_bit32 = {}
    for k,v in pairs(bit32) do orig_bit32[k] = v end
    
    if bit32_options[1] or bit32_options[13] then
        bit32.arshift = function(x, disp) 
            print([[bit32.arshift(]]..x..[[, ]]..disp..[[) called]])
            return orig_bit32.arshift(x, disp)
        end
    end
    if bit32_options[2] or bit32_options[13] then
        bit32.band = function(...) 
            print("bit32.band(...) called")
            return orig_bit32.band(...)
        end
    end
    if bit32_options[3] or bit32_options[13] then
        bit32.bnot = function(x) 
            print([[bit32.bnot(]]..x..[[) called]])
            return orig_bit32.bnot(x)
        end
    end
    if bit32_options[4] or bit32_options[13] then
        bit32.bor = function(...) 
            print("bit32.bor(...) called")
            return orig_bit32.bor(...)
        end
    end
    if bit32_options[5] or bit32_options[13] then
        bit32.btest = function(...) 
            print("bit32.btest(...) called")
            return orig_bit32.btest(...)
        end
    end
    if bit32_options[6] or bit32_options[13] then
        bit32.bxor = function(...) 
            print("bit32.bxor(...) called")
            return orig_bit32.bxor(...)
        end
    end
    if bit32_options[7] or bit32_options[13] then
        bit32.extract = function(n, field, width) 
            print([[bit32.extract(]]..n..[[, ]]..field..[[, ]]..(width or 1)..[[) called]])
            return orig_bit32.extract(n, field, width)
        end
    end
    if bit32_options[8] or bit32_options[13] then
        bit32.lrotate = function(x, disp) 
            print([[bit32.lrotate(]]..x..[[, ]]..disp..[[) called]])
            return orig_bit32.lrotate(x, disp)
        end
    end
    if bit32_options[9] or bit32_options[13] then
        bit32.lshift = function(x, disp) 
            print([[bit32.lshift(]]..x..[[, ]]..disp..[[) called]])
            return orig_bit32.lshift(x, disp)
        end
    end
    if bit32_options[10] or bit32_options[13] then
        bit32.replace = function(n, v, field, width) 
            print([[bit32.replace(]]..n..[[, ]]..v..[[, ]]..field..[[, ]]..(width or 1)..[[) called]])
            return orig_bit32.replace(n, v, field, width)
        end
    end
    if bit32_options[11] or bit32_options[13] then
        bit32.rrotate = function(x, disp) 
            print([[bit32.rrotate(]]..x..[[, ]]..disp..[[) called]])
            return orig_bit32.rrotate(x, disp)
        end
    end
    if bit32_options[12] or bit32_options[13] then
        bit32.rshift = function(x, disp) 
            print([[bit32.rshift(]]..x..[[, ]]..disp..[[) called]])
            return orig_bit32.rshift(x, disp)
        end
    end
end

 function inspect_utf8()
    local utf8_options = gg.multiChoice({
        "utf8.char()",
        "utf8.charpattern",
        "utf8.codes()",
        "utf8.codepoint()",
        "utf8.len()",
        "utf8.offset()",
        "All Functions"
    }, nil, "Select UTF8 Functions to Inspect")
    
    if utf8_options == nil then return end
    
    local orig_utf8 = {}
    for k,v in pairs(utf8) do orig_utf8[k] = v end
    

    if utf8_options[1] or utf8_options[7] then
        utf8.char = function(...) 
            print("utf8.char(...) called")
            return orig_utf8.char(...)
        end
    end
    if utf8_options[2] or utf8_options[7] then
        local orig_charpattern = utf8.charpattern
        utf8.charpattern = function() 
            print("utf8.charpattern accessed")
            return orig_charpattern
        end
    end
    if utf8_options[3] or utf8_options[7] then
        utf8.codes = function(s) 
            print([[utf8.codes("]]..s..[[") called]])
            return orig_utf8.codes(s)
        end
    end
    if utf8_options[4] or utf8_options[7] then
        utf8.codepoint = function(s, i, j) 
            print([[utf8.codepoint("]]..s..[[", ]]..(i or 1)..[[, ]]..(j or i or #s)..[[) called]])
            return orig_utf8.codepoint(s, i, j)
        end
    end
    if utf8_options[5] or utf8_options[7] then
        utf8.len = function(s, i, j) 
            print([[utf8.len("]]..s..[[", ]]..(i or 1)..[[, ]]..(j or #s)..[[) called]])
            return orig_utf8.len(s, i, j)
        end
    end
    if utf8_options[6] or utf8_options[7] then
        utf8.offset = function(s, n, i) 
            print([[utf8.offset("]]..s..[[", ]]..n..[[, ]]..(i or 1)..[[) called]])
            return orig_utf8.offset(s, n, i)
        end
    end
end

load_and_run_script()