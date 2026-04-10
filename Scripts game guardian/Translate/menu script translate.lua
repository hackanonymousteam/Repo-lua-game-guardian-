
function translate() 
--T1 = "unlimited%20money" --example word with space
T1 = "money" 
T2 = "Sensitivity"
T3 = "get gold"
T4 = "no recoil"
T5 = "exit"
T6 = "activated"

enc = gg.choice({
"Portuguese",
"espanol",
"English",
"exit",
},0,"")
if enc == 1 then transl1() end
if enc == 2 then transl2() end
if enc == 3 then transl3() end
if enc == 4 then os.exit() end

BATMAN = -1
end

function transl1() 

local request = gg.makeRequest('https://api.mymemory.translated.net/get?q='..T1..'&langpair=en|pt')

if request == nil or request.content == nil then
    print('error get reply translate.')
    return
end

local response = request.content

local function extracttransFromHTML(html)
        local pattern = '"translatedText"%s*:%s*"([^"]+)"'
    local trans = html:match(pattern)
    return trans
end

local trans = extracttransFromHTML(response)

if not trans then
    print('Error')
else   end

local request2 = gg.makeRequest('https://api.mymemory.translated.net/get?q='..T2..'&langpair=en|pt')

if request2 == nil or request2.content == nil then
    print('error get reply translate.')
    return
end

local response2 = request2.content

local function extracttransFromHTML2(html)
        local pattern2 = '"translatedText"%s*:%s*"([^"]+)"'
    local trans2 = html:match(pattern2)
    return trans2
end
local trans2 = extracttransFromHTML2(response2)

if not trans2 then
    print('Error')
else  end

local request3 = gg.makeRequest('https://api.mymemory.translated.net/get?q='..T3..'&langpair=en|pt')

if request3 == nil or request3.content == nil then
    print('error get reply translate.')
    return
end

local response3 = request3.content

local function extracttransFromHTML3(html)
        local pattern3 = '"translatedText"%s*:%s*"([^"]+)"'
    local trans3 = html:match(pattern3)
    return trans3
end
local trans3 = extracttransFromHTML3(response3)

if not trans3 then
    print('Error')
else  end

local request4 = gg.makeRequest('https://api.mymemory.translated.net/get?q='..T4..'&langpair=en|pt')

if request4 == nil or request4.content == nil then
    print('error get reply translate.')
    return
end

local response4 = request4.content

local function extracttransFromHTML4(html)
        local pattern4 = '"translatedText"%s*:%s*"([^"]+)"'
    local trans4 = html:match(pattern4)
    return trans4
end
local trans4 = extracttransFromHTML4(response4)

if not trans4 then
    print('Error')
else  end

local request5 = gg.makeRequest('https://api.mymemory.translated.net/get?q='..T5..'&langpair=en|pt')

if request5 == nil or request5.content == nil then
    print('error get reply translate.')
    return
end

local response5 = request5.content

local function extracttransFromHTML5(html)
        local pattern5 = '"translatedText"%s*:%s*"([^"]+)"'
    local trans5 = html:match(pattern5)
    return trans5
end
local trans5 = extracttransFromHTML5(response5)

if not trans5 then
    print('Error')
else  end
gg.setVisible(true)

local request6 = gg.makeRequest('https://api.mymemory.translated.net/get?q='..T6..'&langpair=en|pt')

if request6 == nil or request6.content == nil then
    print('error get reply translate.')
    return
end

local response6 = request6.content

local function extracttransFromHTML6(html)
        local pattern6 = '"translatedText"%s*:%s*"([^"]+)"'
    local trans6 = html:match(pattern6)
    return trans6
end
local trans6 = extracttransFromHTML6(response6)

if not trans6 then
    print('Error')
else  end
gg.setVisible(true)

  function START1()
  
    menu = gg.choice({ 
      trans,
      trans2,
      trans3,
      trans4,
      trans5
    }, nil, (os.date"◆ ▬▬▬▬▬ ❴✪❵ ▬▬▬▬▬ ◆\n \n 📋༺ By Batman Games༻📋\n \n◆ ▬▬▬▬▬ ❴✪❵ ▬▬▬▬▬ ◆"))
 
if menu == 1 then t1() end
if menu == 2 then t2() end
if menu == 3 then t3() end
if menu == 4 then t4() end
if menu == 5 then exit() end
Batman= -1
end

function t1()
      gg.toast(trans6)
    end
  
function t2()
      gg.toast(trans6)
    end
    
    function t3()
      gg.toast(trans6)
    end

function t4()
      gg.toast(trans6)
    end

function exit()
     
    print("  ___________________")
    print("▕╮╭┻┻╮╭┻┻╮╭▕╮╲")
    print("▕╯┃╭╮┃┃╭╮┃╰▕╯╭▏")
    print("▕╭┻┻┻┛┗┻┻┛   ▕  ╰▏")
    print("▕╰━━━┓┈┈┈╭╮▕╭╮▏")
    print("▕╭╮╰┳┳┳┳╯╰╯▕╰╯▏")
    print("▕╰╯┈┗┛┗┛┈╭╮▕╮┈▏")
    
    print("\n🦋By Batman Games🦋")
    os.exit()
  end
  
  while true do
    if gg.isVisible(true) then
      Batman = 1
      gg.setVisible(false)
      gg.clearList()
          end
    if Batman == 1 then
      START1()
    end
    Batman = -1
  end
end

--______________________________________________________________________________________________________________________________________

function transl2() 

local request = gg.makeRequest('https://api.mymemory.translated.net/get?q='..T1..'&langpair=en|es')

if request == nil or request.content == nil then
    print('error get reply translate.')
    return
end

local response = request.content

local function extracttransFromHTML(html)
        local pattern = '"translatedText"%s*:%s*"([^"]+)"'
    local trans = html:match(pattern)
    return trans
end

local trans = extracttransFromHTML(response)

if not trans then
    print('Error')
else   end

local request2 = gg.makeRequest('https://api.mymemory.translated.net/get?q='..T2..'&langpair=en|es')

if request2 == nil or request2.content == nil then
    print('error get reply translate.')
    return
end

local response2 = request2.content

local function extracttransFromHTML2(html)
        local pattern2 = '"translatedText"%s*:%s*"([^"]+)"'
    local trans2 = html:match(pattern2)
    return trans2
end
local trans2 = extracttransFromHTML2(response2)

if not trans2 then
    print('Error')
else  end

local request3 = gg.makeRequest('https://api.mymemory.translated.net/get?q='..T3..'&langpair=en|es')

if request3 == nil or request3.content == nil then
    print('error get reply translate.')
    return
end

local response3 = request3.content

local function extracttransFromHTML3(html)
        local pattern3 = '"translatedText"%s*:%s*"([^"]+)"'
    local trans3 = html:match(pattern3)
    return trans3
end
local trans3 = extracttransFromHTML3(response3)

if not trans3 then
    print('Error')
else  end

local request4 = gg.makeRequest('https://api.mymemory.translated.net/get?q='..T4..'&langpair=en|es')

if request4 == nil or request4.content == nil then
    print('error get reply translate.')
    return
end

local response4 = request4.content

local function extracttransFromHTML4(html)
        local pattern4 = '"translatedText"%s*:%s*"([^"]+)"'
    local trans4 = html:match(pattern4)
    return trans4
end
local trans4 = extracttransFromHTML4(response4)

if not trans4 then
    print('Error')
else  end
local request5 = gg.makeRequest('https://api.mymemory.translated.net/get?q='..T5..'&langpair=en|es')

if request5 == nil or request5.content == nil then
    print('error get reply translate.')
    return
end

local response5 = request5.content

local function extracttransFromHTML5(html)
        local pattern5 = '"translatedText"%s*:%s*"([^"]+)"'
    local trans5 = html:match(pattern5)
    return trans5
end
local trans5 = extracttransFromHTML5(response5)

if not trans5 then
    print('Error')
else  end

local request6 = gg.makeRequest('https://api.mymemory.translated.net/get?q='..T6..'&langpair=en|es')

if request6 == nil or request6.content == nil then
    print('error get reply translate.')
    return
end

local response6 = request6.content

local function extracttransFromHTML6(html)
        local pattern6 = '"translatedText"%s*:%s*"([^"]+)"'
    local trans6 = html:match(pattern6)
    return trans6
end
local trans6 = extracttransFromHTML6(response6)

if not trans6 then
    print('Error')
else  end

gg.setVisible(true)

  function START1()
  
    menu = gg.choice({ 
      trans,
      trans2,
      trans3,
      trans4,
      trans5
    }, nil, (os.date"◆ ▬▬▬▬▬ ❴✪❵ ▬▬▬▬▬ ◆\n \n 📋༺ By Batman Games༻📋\n \n◆ ▬▬▬▬▬ ❴✪❵ ▬▬▬▬▬ ◆"))
 
if menu == 1 then t1() end
if menu == 2 then t2() end
if menu == 3 then t3() end
if menu == 4 then t4() end
if menu == 5 then exit() end
Batman= -1
end

function t1()
      gg.toast(trans6)
    end
  
function t2()
      gg.toast(trans6)
    end
    
    function t3()
      gg.toast(trans6)
    end


function t4()
      gg.toast(trans6)
    end

function exit()
     
    print("  ___________________")
    print("▕╮╭┻┻╮╭┻┻╮╭▕╮╲")
    print("▕╯┃╭╮┃┃╭╮┃╰▕╯╭▏")
    print("▕╭┻┻┻┛┗┻┻┛   ▕  ╰▏")
    print("▕╰━━━┓┈┈┈╭╮▕╭╮▏")
    print("▕╭╮╰┳┳┳┳╯╰╯▕╰╯▏")
    print("▕╰╯┈┗┛┗┛┈╭╮▕╮┈▏")
    
    print("\n🦋By Batman Games🦋")
    os.exit()
  end
  
  while true do
    if gg.isVisible(true) then
      Batman = 1
      gg.setVisible(false)
      gg.clearList()
          end
    if Batman == 1 then
      START1()
    end
    Batman = -1
  end
end
--______________________________________________________________________________________________________________________________________

function transl3() 
gg.setVisible(true)

  function START1()
  
    menu = gg.choice({ 
      T1,
      T2,
      T3,
      T4,
      T5
    }, nil, (os.date"◆ ▬▬▬▬▬ ❴✪❵ ▬▬▬▬▬ ◆\n \n 📋༺ By Batman Games༻📋\n \n◆ ▬▬▬▬▬ ❴✪❵ ▬▬▬▬▬ ◆"))
 
if menu == 1 then t1() end
if menu == 2 then t2() end
if menu == 3 then t3() end
if menu == 4 then t4() end
if menu == 5 then exit() end
Batman= -1
end

function t1()
      gg.toast(T6)
    end
  
function t2()
      gg.toast(T6)
    end
    
    function t3()
      gg.toast(T6)
    end

function t4()
      gg.toast(T6)
    end

function exit()
     
    print("  ___________________")
    print("▕╮╭┻┻╮╭┻┻╮╭▕╮╲")
    print("▕╯┃╭╮┃┃╭╮┃╰▕╯╭▏")
    print("▕╭┻┻┻┛┗┻┻┛   ▕  ╰▏")
    print("▕╰━━━┓┈┈┈╭╮▕╭╮▏")
    print("▕╭╮╰┳┳┳┳╯╰╯▕╰╯▏")
    print("▕╰╯┈┗┛┗┛┈╭╮▕╮┈▏")
    
    print("\n🦋By Batman Games🦋")
    os.exit()
  end
  
  while true do
    if gg.isVisible(true) then
      Batman = 1
      gg.setVisible(false)
      gg.clearList()
          end
    if Batman == 1 then
      START1()
    end
    Batman = -1
  end
end
--______________________________________________________________________________________________________________________________________

while(true)do if gg.isVisible(true)then BATMAN = 1 gg.setVisible(false)end
if BATMAN == 1 then translate()end
end