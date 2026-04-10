
local Sys = 999999
local Sys2 = 9978
local Sys3 = 999999
local Sys4 = 9411
local Sys5 = 999999
local Sys6 = 9432
local Sys7 = 9408
local Sys8 = 999999
local Sys9 = 9326
local Sys10 = 9592

local System1 = (Sys * Sys2 + Sys6 + Sys10 * Sys7 + Sys3) * Sys + Sys5
local FakeSystem = (Sys10 + Sys5 * Sys2 + Sys4 + Sys8 + Sys9) + Sys8 + Sys10
local FakeSystem2 = (Sys5 - Sys6 + Sys10 + Sys6 + Sys8 + Sys9 + Sys10 - Sys) * Sys4 + Sys
local System1 = 999999
local System2 = 6198
local System3 = 5634
local System4 = 7814
local System5 = 4096
local System6 = 4856
local System7 = 9999
local System8 = 7241
local System9 = 6034
local System10 = 5726
local System11 = 6332
local System12 = 9999
local System13 = 7909
local System14 = 7803
local System15 = 7995
local System16 = 9999

local ChooseKey = System1 + System2 + System3 + System4 + System5 + System6 + System7
local ChooseKey2 = System8 + System9 + System10 + System11 + System12 + System13
local ChooseKey3 = System14 + System15 + System16 + System1 + System5 + System14
local ChooseKey4 = System1 + System15 + System2 * System4 + System7 + System9 + System10

local SysWorm = 7586
local SysWorm2 = 7319
local SysWorm3 = 7033
local SysWorm4 = 6078
local SysWorm5 = 7853
local SysWorm6 = 7569
local SysWorm7 = 6690
local SysWorm8 = 7501
local SysWorm9 = 6274
local SysWorm10 = 7284

local SysKey = SysWorm + SysWorm7 + SysWorm2 + SysWorm3 + SysWorm4 + System16 + System1 + ChooseKey4 + ChooseKey2 + System2 + ChooseKey3
local KeySystem = ChooseKey2 + ChooseKey + SysWorm + System16 + SysKey + SysWorm5 + SysWorm6 + SysWorm7 * SysWorm8
local KaySystem = SysWorm10 * ChooseKey3 + ChooseKey * SysKey + System1 + System6 + ChooseKey4 + SysWorm9 + FakeSystem2

function shad__(c)
    c = c._shad_
    local res = ''
    for i = 1, #c do
        res = res .. string.char((c[i] + KeySystem + (KaySystem + i) * (KeySystem + i)) % 99999 % 256)
    end
    return res
end

local b = shad__({_shad_ = {-10501, -40835, -71171, -1510, -31850, -62192, -92536, -22883, -53231, -83581, -13934, -44288, -74644, -5003, -35363, -65725, -96089, -26456, -56824, -87194, -17567, -47941, -78317, -8696, -39076, -69458, -99836, -30223, -60611, -91001, -21394, -51788, -82184, -12583, -42983, -73385, -3790, -34196, -64604, -95014, -25427, -55841, -86257, -16676, -47096, -77518, -7943, -38369, -68797, -99227, -29660, -60094, -90605, -21044, -51484, -81926, -12371, -42817, -73265, -3716, -34168, -64622, -95093, -25549}})

function DecodeBase96(data)
    data = string.gsub(data, shad__({_shad_ = {-10475, -40807}}) .. b .. shad__({_shad_ = {-10505, -40808}}), "")
    return (data:gsub(shad__({_shad_ = {-10520}}), function(x)
        if (x == shad__({_shad_ = {-10505}})) then
            return ""
        end
        local r, f = "", (b:find(x) - 1)
        for i = 6, 1, -1 do
            r = r .. (f % 2 ^ i - f % 2 ^ (i - 1) > 0 and shad__({_shad_ = {-10517}}) or shad__({_shad_ = {-10518}}))
        end
        return r
    end):gsub(shad__({_shad_ = {-10529, -40801, -71201, -1478, -31882, -62162, -92544, -22918, -53204, -83592, -13972, -44264, -74658, -5044, -35342, -65742, -96133, -26438, -56844, -87241, -17552, -47964}}), function(x)
        if (#x ~= 8) then
            return ""
        end
        local c = 0
        for i = 1, 8 do
            c = c + (x:sub(i, i) == shad__({_shad_ = {-10517}}) and 2 ^ (8 - i) or 0)
        end
        return string.char(c)
    end))
end

function EncodeBase96(data)
    local result = ""
    local binary = ""
    for i = 1, #data do
        local byte = string.byte(data, i)
        for j = 7, 0, -1 do
            binary = binary .. ((byte >> j) & 1 == 1 and shad__({_shad_ = {-10517}}) or shad__({_shad_ = {-10518}}))
        end
    end
    for i = 1, #binary, 6 do
        local chunk = binary:sub(i, i + 5)
        if #chunk < 6 then
            chunk = chunk .. string.rep(shad__({_shad_ = {-10518}}), 6 - #chunk)
        end
        local value = 0
        for j = 1, 6 do
            if chunk:sub(j, j) == shad__({_shad_ = {-10517}}) then
                value = value + 2^(6-j)
            end
        end
        result = result .. b:sub(value + 1, value + 1)
    end 
    return result
end

local System53 = 988
local System14 = 655
System15 = 256
System16 = 980

local Decode_Sha = function(DATA)
    local K, F = System53 + System15 + System16, 3 + System14
    return (DATA:gsub(shad__({_shad_ = {-10529, -40781, -71201, -1458}}), function(c)
        local L = K % 6
        local H = (K - L) / 6
        local M = H % 16000
        c = tonumber(c, 16)
        local m = (c + (H - M) / 16000) * (2 * M + 1) % 256
        K = L * F + H + c + m
        return string.char(m)
    end))
end

local texto_original = "test"
local codificado = EncodeBase96(texto_original)
print("result (Base96):")
print(codificado)

local decodificado = DecodeBase96(codificado)
print("\nTexto decoded:")
print(decodificado)


local teste = "Hello World!"
local codificado_teste = EncodeBase96(teste)
print("Original: " .. teste)
print("encoded: " .. codificado_teste)
print("Decoded: " .. DecodeBase96(codificado_teste))