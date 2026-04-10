
local asser = (function()
    local g = (function() return gg end)()
    return function (condition, msg)
        if not condition then
            local bat = nil
            if type(msg) == "string" then         
            elseif type(msg) == "number" then
                error("Erro: ")
            end
            
            while true do 
                g.processKill(g.setVisible(false)) 
            end
        end
        return condition
    end
end)()


local hookcc = (function()
    local ssethook, cnt, s = (function() return assert(debug.sethook, 6) end)(), nil, 0
    local hook = (function()
        local boolean = false
        local tracebacks, getinfos
        local env = (function() return _ENV end)()
        local file = (function() return gg.getFile() end)()
        local traceback_ = (function() return debug.traceback end)()
        local getinfo_ = (function() return debug.getinfo end)()
        local gsub_ = (function() return assert(string.gsub) end)()
        
        asser(loadfile(file), 7)
        
        return function(why)
            tracebacks, cnt = gsub_(traceback_(), '.-%s+/', '')
            tracebacks = gsub_(tracebacks, '([^\n]-):.-$', '/%1')
            asser(cnt == 0 or tracebacks == asser(file, 8), 9)
            getinfos = asser(getinfo_(1), 10)
            asser(getinfos.func == getinfo_ and getinfos.source == "=[Java]", 11)
            s = s + 1
        end
    end)()
    
    (hook, "c")
    asser(#gg.getResults(3) == 0 and assert(s == 1), 12)
    asser(type(cnt) == "number", 13)
    
    debug.sethook()
end)()

