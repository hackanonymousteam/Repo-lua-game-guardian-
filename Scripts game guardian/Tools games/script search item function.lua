
local chat = gg.prompt({
    'Enter name function'
}, {}, {'text'})

if chat == nil then
    return
end

function High_View()
    gg.clearResults()
    gg.setRanges(gg.REGION_ANONYMOUS)
    gg.clearResults()
    gg.searchNumber("220;178;15 ",gg.TYPE_FLOAT,false,gg.SIGN_EQUAL,0,-1)
    gg.searchNumber("220",gg.TYPE_FLOAT,false,gg.SIGN_EQUAL,0,-1)
    gg.getResults(300)
    gg.editAll("438",gg.TYPE_FLOAT)
    gg.clearResults()
    gg.toast("High View on")
    
  end
  function Black_Sky()
    gg.clearResults()
    gg.setRanges(gg.REGION_BAD)
    gg.searchNumber("100F;1F;1,008,981,770D:99",gg.TYPE_FLOAT,false)
    gg.searchNumber("100",gg.TYPE_FLOAT,false)
    gg.getResults(100)
    gg.editAll("-8200",gg.TYPE_FLOAT)
    gg.clearResults()
    gg.toast("Black Sky On")
  end
  
  function Antena()
    gg.setRanges(gg.REGION_ANONYMOUS)
    gg.searchNumber("60,000.0;5.6051939e-45;1.0::77",gg.TYPE_FLOAT,false,gg.SIGN_EQUAL,0,-1)
    gg.searchNumber("1",gg.TYPE_FLOAT,false,gg.SIGN_EQUAL,0,-1)
    gg.getResults(10)
    gg.editAll("0",gg.TYPE_FLOAT)
    gg.clearResults()
    gg.clearResults()
    gg.setRanges(gg.REGION_ANONYMOUS)
    gg.searchNumber("18.38613319397;0.53447723389;3.42665576935",gg.TYPE_FLOAT,false,gg.SIGN_EQUAL,0,-1)
    gg.getResults(3)
    gg.editAll("99999",gg.TYPE_FLOAT)
    gg.clearResults()
    gg.searchNumber("0.53446006775F;-1.68741035461F:501",gg.TYPE_FLOAT,false,gg.SIGN_EQUAL,0,-1)
    gg.searchNumber("-1.68741035461",gg.TYPE_FLOAT,false,gg.SIGN_EQUAL,0,-1)
    gg.getResults(1995)
    gg.editAll("19995",gg.TYPE_FLOAT)
    gg.clearResults()
    gg.toast("Antena On")
  end
  
  function magic_bullet()
    gg.clearResults()
    gg.setRanges(gg.REGION_ANONYMOUS)
    gg.searchNumber("9.20161819458;23;25;30.5",gg.TYPE_FLOAT,false,gg.SIGN_EQUAL,0,-1)
    gg.getResultCount()
    gg.searchNumber("25;30.5",gg.TYPE_FLOAT,false,gg.SIGN_EQUAL,0,-1)
    gg.getResults(10)
    gg.editAll("250",gg.TYPE_FLOAT)
    gg.clearResults()
    gg.toast("MB + HS 99 on")
  end
  
  function headshot()
    gg.clearResults()
    gg.setRanges(gg.REGION_ANONYMOUS)
    gg.searchNumber("9.20161819458;23;25;30.5",gg.TYPE_FLOAT,false,gg.SIGN_EQUAL,0,-1)
    gg.getResultCount()
    gg.searchNumber("25;30.5",gg.TYPE_FLOAT,false,gg.SIGN_EQUAL,0,-1)
    gg.getResults(10)
    gg.editAll("40",gg.TYPE_FLOAT)
    gg.clearResults()
    gg.toast("Headshot 30 On")
  end
  
  function recoil()
    gg.clearResults()
    gg.setRanges(gg.REGION_ANONYMOUS)
    gg.searchNumber("1.5584387e28",gg.TYPE_FLOAT,false,gg.SIGN_EQUAL,0,-1)
    gg.searchNumber("1.5584387e28",gg.TYPE_FLOAT,false,gg.SIGN_EQUAL,0,-1)
    gg.getResults(100)
    gg.editAll("0",gg.TYPE_FLOAT)
    gg.clearResults()
    gg.setRanges(gg.REGION_ANONYMOUS)
    gg.searchNumber("1D;0.05000000075F;0.10000000149F;0.55000001192F;9.5F;15.0F",gg.TYPE_FLOAT,false,gg.SIGN_EQUAL,0,-1)
    gg.searchNumber("1",gg.TYPE_DWORD,false,gg.SIGN_EQUAL,0,-1)
    gg.getResults(100)
    gg.editAll("0",gg.TYPE_DWORD)
    gg.clearResults()
    gg.searchNumber("1,084,227,584D;1D;0.64999997616F;1.2520827e-32F",gg.TYPE_FLOAT,false,gg.SIGN_EQUAL,0,-1)
    gg.searchNumber("1.2520827e-32",gg.TYPE_FLOAT,false,gg.SIGN_EQUAL,0,-1)
    gg.getResults(100)
    gg.editAll("1.4012985e-43",gg.TYPE_FLOAT)
    gg.clearResults()
    gg.toast("Less Recoil On.")
  end
  
  function wallhack()
    gg.setRanges(131072)
    gg.searchNumber("95D;2;9.2194229e-41",16,false,536870912,0,-1)
    gg.searchNumber("2",16,false,536870912,0,-1)
    gg.getResults(15)
    gg.editAll("130",16)
    gg.clearResults()
    gg.setRanges(131072)
    gg.searchNumber("206D;3.7615819e-37;2;-1;1",16,false,536870912,0,-1)
    gg.searchNumber("2",16,false,536870912,0,-1)
    gg.getResults(10)
    gg.editAll("130",16)
    gg.toast("WH 845 On")
    gg.clearResults()
  end
  
  function red_body()
    gg.clearResults()
    gg.searchNumber("8,196D;8,192D;8,200D::",4,false,536870912,0,-1)
    gg.searchNumber("8200",4,false,536870912,0,-1)
    gg.getResults(10)
    gg.editAll("7",4)
    gg.toast("Red On")
  end
  
  function white_body()
    gg.clearResults()
    gg.setRanges(gg.REGION_BAD)
    gg.searchNumber("256;8200;26",gg.TYPE_DWORD,false,gg.SIGN_EQUAL,0,-1)
    gg.searchNumber("8200",gg.TYPE_DWORD,false,gg.SIGN_EQUAL,0,-1)
    gg.getResults(5)
    gg.editAll("5",gg.TYPE_DWORD)
    gg.toast("white On")
  end
  
  function yellow_body()
    gg.clearResults()
    gg.searchNumber("8,196D;8,192D;8,200D::",4,false,536870912,0,-1)
    gg.searchNumber("8200",4,false,536870912,0,-1)
    gg.getResults(10)
    gg.editAll("6",4)
    gg.toast("Yellow ON")
  end

local searchTerm = string.lower(chat[1])

local funcNames = {"High_View", "Black_Sky","Antena", "magic_bullet","headshot", "recoil","wallhack","red_body", "white_body","yellow_body"}
local functions = {High_View, Black_Sky,Antena, magic_bullet,headshot, recoil,wallhack,red_body, white_body,yellow_body}
local answers = {}

for i, name in ipairs(funcNames) do
    if string.find(name, searchTerm) then
        table.insert(answers, name)  
    end
end

if #answers == 0 then
    gg.alert("no found")
    return
end

local choice
repeat
    choice = gg.choice(answers, nil, 'select function')
    if choice == nil then
        return  
    end
until choice ~= nil

if choice then
    functions[choice]()  
end