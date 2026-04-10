--https://quickchart.io/chart?c= {type:'bar',data:{labels:[2012,2013,2014,2015, 2016],datasets:[{label:'Users',data:[120,60,50,180,120]}]}}

local chat = gg.prompt({
	'name graphic',
    'label 1',
    'value 1', 
    'label 2',
    'value 2', 
    'label 3',
    'value 3', 
    'label 4',
    'value 4', 
    'label 5',
    'value 5', 
    
}, {}, {'text','text', 'number','text', 'number','text','number','text', 'number','text', 'number'})

if chat == nil then
    return
end
local name = chat[1]
local a = chat[2]
local b = chat[4]
local c = chat[6]
local d = chat[8]
local e = chat[10]

local f = chat[3]
local g = chat[5]
local h = chat[7]
local i = chat[9]
local j = chat[11]

local url = 'https://quickchart.io/chart?c={type:"bar",data:{labels:["' .. a .. '","' .. b .. '","' .. c .. '","' .. d .. '","' .. e .. '"],datasets:[{label:"' .. name .. '",data:[' .. f .. ',' .. g .. ',' .. h .. ',' .. i .. ',' .. j .. ']}]}}'

local request = gg.makeRequest(url)
if request == nil or request.content == nil then
    gg.alert('error.')
    return
end

local graf = request.content
local namer = 'graphic.png'

local path = "/sdcard/"

local file = io.open(path .. namer, "wb")
if file then
    file:write(graf)
    file:close()
    gg.alert('image graphic  save in ' .. path .. namer)
else
    gg.alert('failed to save graphic.')
end