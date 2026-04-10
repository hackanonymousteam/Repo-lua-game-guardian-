
function translate(text, target_lang)
if type(text) ~= 'string' or #text < 1 then return text end
local function url_encode(str)
return str:gsub("([^%w])", function(c)
return string.format("%%%02X", string.byte(c)) end) end
local userAgent = {['User-Agent'] = 'GoogleTranslate/6.3.0.RC06.277163268 Linux; U; Android 14; A201SO Build/64.2.E.2.140'}
local getTrans = gg.makeRequest('https://translate.googleapis.com/translate_a/single?client=gtx&sl=auto&tl=' .. target_lang .. '&dt=t&q=' .. url_encode(text), userAgent)
if type(getTrans) ~= 'table' then return text end
local result = getTrans.content:match('["](.-)["]') return result or text
end

T1 = translate("headshot", gg.getLocale())
T2 = translate("Sensitivity", gg.getLocale())
T3 = translate("get gold", gg.getLocale())
T4 = translate("no recoil", gg.getLocale())
T5 = translate("exit", gg.getLocale())
T6 = translate("activated", gg.getLocale())

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