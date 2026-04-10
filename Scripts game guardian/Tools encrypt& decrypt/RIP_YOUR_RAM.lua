local function a()
    for u = 1, 3 do
        local b = string.rep("X", 2500)
        local c = {b}
        local d = {{c, c, c, c, c}, c, c, c, c}
        local e = {{{d, d, d, d}, c, c, c, c}, c, d, c, d, c}
        local f = {{{{e, e, e, e, e, e}, d, d, d, d, d, d}, c, c, c, c, c, c}, c, d, e, c, d, e}
        local g = {{{{{f, f, f, f, f, f}, e, e, e, e, e, e}, d, d, d, d, d, d}, c, c, c, c, c, c}, c, d, e, f, f, d, e, e}
        
        for _ = 1, 100 do
            local h = {f, g, e, d, c, b}
            table.insert(f, h)
            table.insert(g, h)
        end
    end
end

local function b()
    local i = {{-1, {1-1, {-1, {-1%1, {1%1-1, {}}, {}}, {-1}, {}}, {}}, {1%1-1}, 1-1}}
    
    for j = 1, 100 do
        for k = 1, 100 do
            for l = 1, 100 do
                local m = {}
                for n = 1, 1000 do
                    m[n] = {i, i, i, i, i}
                end
                table.insert(i, m)
            end
        end
    end
end

local function c()
    local function o(p)
        if p <= 0 then return {} end
        local q = {}
        for r = 1, 10 do
            q[r] = o(p - 1)
        end
        return q
    end
    
    for s = 0, 100 do
        local t = {}
        for u = 1, 500 do
            t[u] = o(20)
        end
        
        local v = {}
        for w = 1, 1000 do
            v[w] = {t, t, t, t}
        end
        
        local x = {v, v, v}
        x[1] = o(30)
    end
end

local function d()
    local y = {}
    
    for z = 1, 1000 do
        y[z] = function(aa)
            local ab = {}
            for ac = 1, 1000 do
                ab[ac] = function(ad)
                    return {aa, ad, z, ac, {}}
                end
            end
            return ab
        end
    end
    
    return y
end

local function e()
    local ae = {}
    local af = ae
    
    for ag = 1, 1000 do
        af.next = {}
        af = af.next
    end
    
    local function ah(ai, aj)
        if aj <= 0 then return end
        for ak = 1, 100 do
            ai[ak] = {}
            for al = 1, 100 do
                ai[ak][al] = string.rep("X", 1000)
                ah(ai[ak][al], aj - 1)
            end
        end
    end
    
    ah(ae, 10)
    
    local am = 0
    while am < 10000 do
        local an = ae
        for ao = 1, 500 do
            if an.next then
                an = an.next
            end
        end
        am = am + 1
    end
end

local function f()
    local ap = ""
    local aq = ":"
    
    for ar = 1, 9999 do
        ap = ap .. aq
        for as = 1, 10 do
            ap = ap .. ap
        end
    end
    
    return ap
end

local function g()
    local at = {}
    
    for au = 1, 20 do
        local av = {}
        for aw = 1, #at + 1 do
            av[aw] = {string.rep("MEMORY", 1000)}
        end
        table.insert(at, av)
        
        for ax = 1, #at do
            table.insert(at, at[ax])
        end
    end
end

local ay = {
    a, b, c, d, e, f, g
}

while true do
    for _, az in ipairs(ay) do
        for ba = 1, 10 do
            az()
        end
    end
    
    local bb = {}
    for bc = 1, 10000 do
        bb[bc] = string.rep("OVERFLOW", 1000)
    end
    
    for bd = 1, #bb do
        bb[bd] = {bb, bb, bb}
    end
    
    local be = 0
    while be < 100000 do
        be = be + 1
        local bf = {}
        for bg = 1, 100 do
            bf[bg] = string.rep("CPU", 100)
        end
    end
end