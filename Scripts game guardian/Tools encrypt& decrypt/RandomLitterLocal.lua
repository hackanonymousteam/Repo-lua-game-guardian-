function ObfGen(opt)
    opt = opt or {}

    local mode  = opt.mode or "litter"
    local num   = opt.num or math.random(1,9)
    local level = opt.level or math.random(3,7)

    -- ===============================
    -- RandomLitter
    -- ===============================
    local function RandomLitterLocal(n)
        if n == 1 then
            return string.char(
                math.random(65,90),
                math.random(97,122),
                math.random(97,122),
                math.random(65,90)
            )
        elseif n == 2 then
            return "_" .. string.char(math.random(48,57)) .. "_"
        elseif n == 3 then
            return string.char(
                math.random(65,90),
                math.random(97,122),
                math.random(48,57),
                math.random(65,90)
            )
        elseif n == 4 then
            return string.char(math.random(33,47)) ..
                   string.char(math.random(97,122)) ..
                   string.char(math.random(97,122)) ..
                   string.char(math.random(97,122))
        elseif n == 5 then
            return string.char(math.random(65,90)) ..
                   string.char(math.random(48,57)) ..
                   string.char(math.random(48,57)) ..
                   string.char(math.random(48,57))
        elseif n == 6 then
            return string.char(math.random(97,122)) ..
                   string.char(math.random(65,90)) ..
                   string.char(math.random(48,57)) ..
                   string.char(math.random(97,122))
        elseif n == 7 then
            return string.char(
                math.random(33,126),
                math.random(33,126),
                math.random(33,126),
                math.random(33,126)
            )
        elseif n == 8 then
            return "_" ..
                   string.char(math.random(97,122)) ..
                   string.char(math.random(97,122)) ..
                   string.char(math.random(97,122))
        elseif n == 9 then
            return string.char(
                math.random(48,57),
                math.random(65,90),
                math.random(97,122),
                math.random(48,57)
            )
        end
        return ""
    end

    -- ===============================
    -- FakeFlow
    -- ===============================
    local function FakeFlow(sz)
        sz = sz or math.random(5,12)

        local lbl =
            string.char(math.random(97,122)) ..
            string.char(math.random(97,122)) ..
            string.char(math.random(97,122))

        local block = ""
        local piece = " else goto " .. lbl .. " end if(nil)then "

        for i = 1, sz do
            block = block .. piece
        end

        return " if(nil)then if(true)then " ..
               block ..
               " end ::" .. lbl .. ":: end "
    end

    -- ===============================
    -- MODE litter
    -- ===============================
    if mode == "litter" then
        return RandomLitterLocal(num)
    end

    -- ===============================
    -- MODE chunk
    -- ===============================
    local out = ""
    local vars = {}

    out = out .. FakeFlow()

    for i = 1, level do
        local v = RandomLitterLocal(1) ..
                  RandomLitterLocal(2) ..
                  RandomLitterLocal(3)

        vars[#vars+1] = v
        out = out .. " local " .. v .. " = '" ..
              RandomLitterLocal(math.random(1,9)) .. "' "
    end

    for i = 1, math.random(3,7) do
        local v = vars[math.random(1,#vars)]
        out = out .. " " .. v .. " = " .. v ..
              " .. '" .. RandomLitterLocal(math.random(1,9)) .. "' "
    end

    for _,fname in ipairs({"print","load","loadstring","pcall","xpcall","require"}) do
        if _G[fname] and math.random(1,5) == 1 then
            out = out .. " if false then " .. fname .. "() end "
        end
    end
    out = out .. FakeFlow()
    return out
end

local s = ObfGen{mode="litter"}
--print(s, #s)

local c = ObfGen{mode="chunk"}
--print(type(c), #c)

local chunk = ObfGen{mode="chunk"}
local f = load(chunk)

f()



--example return
  if(nil)then if(true)then  else goto lix end if(nil)then  else goto lix end if(nil)then  else goto lix end if(nil)then  else goto lix end if(nil)then  else goto lix end if(nil)then  else goto lix end if(nil)then  else goto lix end if(nil)then  else goto lix end if(nil)then  else goto lix end if(nil)then  else goto lix end if(nil)then  else goto lix end if(nil)then  end ::lix:: end  local GmmT_3_Ie9P = '_2_'  local VhaY_9_Ut8P = '*A,p'  local PokX_2_Fg1Q = '2Il8'  local RolX_3_Zi6I = ';4_m'  local VnbX_4_Cw8A = '_fjr'  PokX_2_Fg1Q = PokX_2_Fg1Q .. 'Bi3J'  VnbX_4_Cw8A = VnbX_4_Cw8A .. '_rxx'  VhaY_9_Ut8P = VhaY_9_Ut8P .. '5Ng7'  GmmT_3_Ie9P = GmmT_3_Ie9P .. 'L033'  VnbX_4_Cw8A = VnbX_4_Cw8A .. 'mH6g'  GmmT_3_Ie9P = GmmT_3_Ie9P .. 'sY6m'  if false then xpcall() end  if false then require() end  if(nil)then if(true)then  else goto dpp end if(nil)then  else goto dpp end if(nil)then  else goto dpp end if(nil)then  else goto dpp end if(nil)then  else goto dpp end if(nil)then  end ::dpp:: end 