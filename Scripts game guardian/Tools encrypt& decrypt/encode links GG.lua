local MAP_DECODE = {
["d"]="a",["e"]="b",["f"]="c",["g"]="d",["h"]="e",["i"]="f",["j"]="g",["k"]="h",["l"]="i",["m"]="j",["n"]="k",["o"]="l",["p"]="m",["q"]="n",["r"]="o",["s"]="p",["t"]="q",["u"]="r",["v"]="s",["w"]="t",["x"]="u",["y"]="v",["z"]="w",["{"]="x",["|"]="y",["}"]="z",
["D"]="A",["E"]="B",["F"]="C",["G"]="D",["H"]="E",["I"]="F",["J"]="G",["K"]="H",["L"]="I",["M"]="J",["N"]="K",["O"]="L",["P"]="M",["Q"]="N",["R"]="O",["S"]="P",["T"]="Q",["U"]="R",["V"]="S",["W"]="T",["X"]="U",["Y"]="V",["Z"]="W",["["]="X",["]"]="Z",
["3"]="0",["4"]="1",["5"]="2",["6"]="3",["7"]="4",["8"]="5",["9"]="6",[":"]="7",[";"]="8",["<"]="9",
["="]=":",["0"]="-",["1"]=".",["2"]="/",["A"]=">",["B"]="?",["C"]="@",["a"]="^",["b"]="_",["c"]="'",
["+"]="(",["-"]="*",["@"]="=",["$"]="!",["("]="%",[")"]="&",["*"]="'",["/"]=",",[","]=")",["?"]="<",
["%"]='"',[">"]=",",["&"]="#",["√"]="*",["¦"]="£",["~"]="{",["`"]="]",["^"]="["
}

local MAP_ENCODE = {}
for k,v in pairs(MAP_DECODE) do
    MAP_ENCODE[v] = k
end

function gg_encode(s)
    local r = {}
    for i = 1, #s do
        local c = s:sub(i,i)
        r[#r+1] = MAP_ENCODE[c] or c
    end
    return table.concat(r)
end

function gg_decode(s)
    local r = {}
    for i = 1, #s do
        local c = s:sub(i,i)
        r[#r+1] = MAP_DECODE[c] or c
    end
    return table.concat(r)
end

function encode()
local chat = gg.prompt({'enter your text for encode'}, {}, {'text'})
if chat == nil then
    return
end
local duck = chat[1]
A = gg_encode(duck)
print(A)
end

function decode()
local chat = gg.prompt({'enter your text for decode'}, {}, {'text'})
if chat == nil then
    return
end
local duck = chat[1]
A = gg_decode(duck)
print(A)
end


encode()
