local function ctlsub(c)
    if c == "\n" then return "\\n"
    elseif c == "\r" then return "\\r"
    elseif c == "\t" then return "\\t"
    else return string.format("\\%03d", string.byte(c))
    end
end

local function format_value(v, maxlen)
    maxlen = maxlen or 40
    local t = type(v)
    
    if t == "string" then
        if #v > maxlen then
            return string.format('"%.' .. (maxlen-3) .. 's..."', v:gsub("%c", ctlsub))
        else
            return string.format('"%s"', v:gsub("%c", ctlsub))
        end
    elseif t == "number" then
        return string.format("%.14g", v)
    elseif t == "function" then
        local info = debug.getinfo(v, "S")
        if info then
            local name = info.name or "anonymous"
            return string.format("function:%s", name)
        end
        return "function"
    elseif t == "table" then
        local n = 0
        for _ in pairs(v) do n = n + 1 end
        return string.format("table[%d]", n)
    elseif t == "userdata" then
        return "userdata"
    elseif t == "boolean" then
        return v and "true" or "false"
    elseif t == "nil" then
        return "nil"
    else
        return tostring(v)
    end
end

local function dump_function(func)
    print("\n========== FUNCTION DUMP ==========")
    
    if type(func) ~= "function" then
        print("Error: Not a function")
        return
    end
    
    local info = debug.getinfo(func, "Slu")
    
    if info then
        print("Source:        " .. (info.source or "?"))
        print("Name:          " .. (info.name or "anonymous"))
        print("What:          " .. (info.what or "?"))
        print("Line defined:  " .. (info.linedefined or 0))
        print("Last line:     " .. (info.lastlinedefined or 0))
        print("Upvalues:      " .. (info.nups or 0))
        print("Parameters:    " .. (info.nparams or 0))
        print("Is vararg:     " .. (info.isvararg and "yes" or "no"))
        print("")
    end
    
    local dumped = string.dump(func)
    if dumped then
        print("Bytecode size: " .. #dumped .. " bytes")
        
        local hex = ""
        for i = 1, math.min(16, #dumped) do
            hex = hex .. string.format("%02X ", string.byte(dumped, i))
        end
        print("Header: " .. hex .. "...")
        print("")
    end
    

    print("")
    print("Upvalues:")
    i = 1
    while true do
        local name, value = debug.getupvalue(func, i)
        if not name then break end
        print(string.format("  [%d] %s = %s", i, name, format_value(value)))
        i = i + 1
    end
    
    print("========== END ==========")
end

local function dump_bytecode(func)
    print("\n========== BYTECODE DUMP ==========")
    
    if type(func) ~= "function" then
        print("Error: Not a function")
        return
    end
    
    local info = debug.getinfo(func, "S")
    if info then
        print("Function: " .. (info.name or "anonymous"))
        print("Source:   " .. (info.source or "?"))
        print("")
    end
    
    local dumped = string.dump(func)
    if not dumped then
        print("Error generating bytecode")
        return
    end
    
    print("Total size: " .. #dumped .. " bytes\n")
    
    print("=== Header ===")
    local signature = dumped:sub(1, 4)
    local version = string.byte(dumped, 5)
    local format = string.byte(dumped, 6)
    local endian = string.byte(dumped, 7)
    local int_size = string.byte(dumped, 8)
    local size_t = string.byte(dumped, 9)
    local instr_size = string.byte(dumped, 10)
    local lua_number = string.byte(dumped, 11)
    local integral = string.byte(dumped, 12)
    
    print(string.format("Signature:     %s", signature:gsub(".", function(c) return string.format("\\x%02X", string.byte(c)) end)))
    print(string.format("Version:       %d", version))
    print(string.format("Format:        %d", format))
    print(string.format("Endianness:    %d (%s)", endian, endian == 1 and "little" or "big"))
    print(string.format("Int size:      %d bytes", int_size))
    print(string.format("Size_t size:   %d bytes", size_t))
    print(string.format("Instr size:    %d bytes", instr_size))
    print(string.format("Number size:   %d bytes", lua_number))
    print(string.format("Integral:      %s", integral == 1 and "yes" or "no"))
    print("")
    
    print("=== Code Section (first 64 bytes) ===")
    local code_start = 13 + (version > 0x52 and 6 or 0)
    local hex = ""
    local ascii = ""
    
    for i = code_start, math.min(code_start + 63, #dumped) do
        local byte = string.byte(dumped, i)
        hex = hex .. string.format("%02X ", byte)
        ascii = ascii .. (byte >= 32 and byte <= 126 and string.char(byte) or ".")
        
        if (i - code_start + 1) % 16 == 0 then
            print(string.format("%04X: %-48s %s", i - code_start + 1 - 16, hex, ascii))
            hex = ""
            ascii = ""
        end
    end
    
    if hex ~= "" then
        local offset = math.floor((#dumped - code_start) / 16) * 16
        print(string.format("%04X: %-48s %s", offset, hex, ascii))
    end
    
    print("========== END ==========")
end

local function trace_execution(func, max_lines)
    max_lines = max_lines or 100
    local line_count = 0
    local depth = 0
    local start_time = os.clock()
    
    print("\n========== TRACE START ==========")
    
    local function hook(event, line)
        line_count = line_count + 1
        
        if line_count > max_lines then
            debug.sethook()
            print("... limit of " .. max_lines .. " lines reached")
            return
        end
        
        local info = debug.getinfo(2, "Sln")
        
        if event == "line" then
            local indent = string.rep("  ", depth)
            local src = info.source or "?"
            if #src > 30 then src = "..." .. src:sub(-27) end
            
            local output = string.format("%s[%04d] %s:%d", indent, line_count, src, line)
            if info.name then
                output = output .. " (" .. info.name .. ")"
            end
            print(output)
            
        elseif event == "call" then
            local indent = string.rep("  ", depth)
            local name = info.name or "anonymous"
            print(string.format("%s>> CALL %s", indent, name))
            depth = depth + 1
            
        elseif event == "return" then
            depth = math.max(0, depth - 1)
            local indent = string.rep("  ", depth)
            print(string.format("%s<< RETURN", indent))
        end
    end
    
    debug.sethook(hook, "crl")
    local success, result = pcall(func)
    debug.sethook()
    
    local elapsed = os.clock() - start_time
    
    print("\n========== TRACE SUMMARY ==========")
    print(string.format("Lines executed: %d", line_count))
    print(string.format("Time: %.4f seconds", elapsed))
    print(string.format("Status: %s", success and "SUCCESS" or "ERROR"))
    
    if not success then
        print(string.format("Error: %s", tostring(result)))
    end
    
    print("========== TRACE END ==========")
end

print([[
+----------------------------------------------+
|     BYTECODE ANALYZER v1.0        |
|         GameGuardian                  |
+----------------------------------------------+
]])

local function soma(a, b)
    return a + b
end

local function fatorial(n)
    if n <= 1 then return 1 end
    return n * fatorial(n - 1)
end

local function closure_teste()
    local x = 0
    return function()
        x = x + 1
        return x
    end
end

print("\n[EXAMPLE 1] Simple function")
dump_function(soma)

print("\n[EXAMPLE 2] Bytecode - Factorial function")
dump_bytecode(fatorial)

print("\n[EXAMPLE 3] Trace - factorial(5)")
trace_execution(function()
    local r = fatorial(5)
    print("Result: " .. r)
end, 30)

print("\n[EXAMPLE 4] Closure")
local cont = closure_teste()
cont() cont() cont()
dump_function(cont)

print("\n[EXAMPLE 5] Typical GameGuardian code")

local codigo_gg = [[
    local gg = _G.gg
    local function search()
        gg.clearResults()
        gg.searchNumber("100", gg.TYPE_DWORD)
        local r = gg.getResults(10)
        return #r
    end
    return search
]]

local func = loadstring(codigo_gg)
if func then
    local f = func()
    dump_function(f)
else
    print("Error loading code")
end

print("\nANALYSIS COMPLETED!")