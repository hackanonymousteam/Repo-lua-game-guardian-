-- Fraktur
local function convertToFraktur(text)
  local normal = "abcdefghijklmnopqrstuvwxyz"
  local custom = {"𝔞","𝔟","𝔠","𝔡","𝔢","𝔣","𝔤","𝔥","𝔦","𝔧","𝔨","𝔩","𝔪","𝔫","𝔬","𝔭","𝔮","𝔯","𝔰","𝔱","𝔲","𝔳","𝔴","𝔵","𝔶","𝔷"}
  local converted = ""
  for char in text:gmatch(".") do
    local lowerChar = char:lower()
    local index = normal:find(lowerChar, 1, true)
    if index then
      converted = converted .. custom[index]
    else
      converted = converted .. char
    end
  end
  return converted
end

-- Monospace
local function convertToMonospace(text)
  local normal = "abcdefghijklmnopqrstuvwxyz"
  local custom = {"𝚊","𝚋","𝚌","𝚍","𝚎","𝚏","𝚐","𝚑","𝚒","𝚓","𝚔","𝚕","𝚖","𝚗","𝚘","𝚙","𝚚","𝚛","𝚜","𝚝","𝚞","𝚟","𝚠","𝚡","𝚢","𝚣"}
  local converted = ""
  for char in text:gmatch(".") do
    local lowerChar = char:lower()
    local index = normal:find(lowerChar, 1, true)
    if index then
      converted = converted .. custom[index]
    else
      converted = converted .. char
    end
  end
  return converted
end

-- Roman
local function convertToRoman(text)
  local normal = "abcdefghijklmnopqrstuvwxyz"
  local custom = {"Λ","B","ᄃ","D","Σ","F","G","Η","I","J","K","ᄂ","M","П","Ө","P","Q","Я","Ƨ","Ƭ","Ц","V","Щ","X","Y","Z"}
  local converted = ""
  for char in text:gmatch(".") do
    local lowerChar = char:lower()
    local index = normal:find(lowerChar, 1, true)
    if index then
      converted = converted .. custom[index]
    else
      converted = converted .. char
    end
  end
  return converted
end

-- Canadian
local function convertToCanadian(text)
  local normal = "abcdefghijklmnopqrstuvwxyz"
  local custom = {"ᗩ","ᗷ","ᑕ","ᗞ","ᕮ","ᖴ","Ｇ","ᕼ","I","ᒍ","K","ᒪ","ᗰ","ᘉ","O","ᑭ","Q","ᖇ","S","T","ᑌ","ᐯ","ᗯ","᙭","Y","Z"}
  local converted = ""
  for char in text:gmatch(".") do
    local lowerChar = char:lower()
    local index = normal:find(lowerChar, 1, true)
    if index then
      converted = converted .. custom[index]
    else
      converted = converted .. char
    end
  end
  return converted
end

-- Taile
local function convertToTaile(text)
  local normal = "abcdefghijklmnopqrstuvwxyz"
  local custom = {"ᥲ","b","ᥴ","d","ᥱ","f","g","h","ι","j","k","ᥣ","꧑","ᥒ","᥆","ρ","q","r","᥉","t","ᥙ","᥎","ᥕ","᥊","ᥡ","z"}
  local converted = ""
  for char in text:gmatch(".") do
    local lowerChar = char:lower()
    local index = normal:find(lowerChar, 1, true)
    if index then
      converted = converted .. custom[index]
    else
      converted = converted .. char
    end
  end
  return converted
end

-- Smallcaps
local function convertToSmallcaps(text)
  local normal = "abcdefghijklmnopqrstuvwxyz"
  local custom = {"ᴀ","ʙ","ᴄ","ᴅ","ᴇ","ғ","ɢ","ʜ","ɪ","ᴊ","ᴋ","ʟ","ᴍ","ɴ","ᴏ","ᴘ","ǫ","ʀ","s","ᴛ","ᴜ","ᴠ","ᴡ","x","ʏ","ᴢ"}
  local converted = ""
  for char in text:gmatch(".") do
    local lowerChar = char:lower()
    local index = normal:find(lowerChar, 1, true)
    if index then
      converted = converted .. custom[index]
    else
      converted = converted .. char
    end
  end
  return converted
end

-- Superscript
local function convertToSuperscript(text)
  local normal = "abcdefghijklmnopqrstuvwxyz"
  local custom = {"ᵃ","ᵇ","ᶜ","ᵈ","ᵉ","ᶠ","ᵍ","ʰ","ᶦ","ʲ","ᵏ","ˡ","ᵐ","ⁿ","ᵒ","ᵖ","ᵠ","ʳ","ˢ","ᵗ","ᵘ","ᵛ","ʷ","ˣ","ʸ","ᶻ"}
  local converted = ""
  for char in text:gmatch(".") do
    local lowerChar = char:lower()
    local index = normal:find(lowerChar, 1, true)
    if index then
      converted = converted .. custom[index]
    else
      converted = converted .. char
    end
  end
  return converted
end

-- Inverted
local function convertToInverted(text)
  local normal = "abcdefghijklmnopqrstuvwxyz"
  local custom = {"z","ʎ","x","ʍ","ʌ","n","ʇ","s","ɹ","b","d","o","u","ɯ","l","ʞ","ɾ","ı","ɥ","ɓ","ɟ","ǝ","p","ɔ","q","ɐ"}
  local converted = ""
  for char in text:gmatch(".") do
    local lowerChar = char:lower()
    local index = normal:find(lowerChar, 1, true)
    if index then
      converted = converted .. custom[index]
    else
      converted = converted .. char
    end
  end
  return converted
end

-- Serif Bold
local function convertToSerifBold(text)
  local normal = "abcdefghijklmnopqrstuvwxyz"
  local custom = {"𝐚","𝐛","𝐜","𝐝","𝐞","𝐟","𝐠","𝐡","𝐢","𝐣","𝐤","𝐥","𝐦","𝐧","𝐨","𝐩","𝐪","𝐫","𝐬","𝐭","𝐮","𝐯","𝐰","𝐱","𝐲","𝐳"}
  local converted = ""
  for char in text:gmatch(".") do
    local lowerChar = char:lower()
    local index = normal:find(lowerChar, 1, true)
    if index then
      converted = converted .. custom[index]
    else
      converted = converted .. char
    end
  end
  return converted
end

-- Sans
local function convertToSans(text)
  local normal = "abcdefghijklmnopqrstuvwxyz"
  local custom = {"𝖺","𝖻","𝖼","𝖽","𝖾","𝖿","𝗀","𝗁","𝗂","𝗃","𝗄","𝗅","𝗆","𝗇","𝗈","𝗉","𝗊","𝗋","𝗌","𝗍","𝗎","𝗏","𝗐","𝗑","𝗒","𝗓"}
  local converted = ""
  for char in text:gmatch(".") do
    local lowerChar = char:lower()
    local index = normal:find(lowerChar, 1, true)
    if index then
      converted = converted .. custom[index]
    else
      converted = converted .. char
    end
  end
  return converted
end

-- Sans Bold Italic
local function convertToSansBoldItalic(text)
  local normal = "abcdefghijklmnopqrstuvwxyz"
  local custom = {"𝙖","𝙗","𝙘","𝙙","𝙚","𝙛","𝙜","𝙝","𝙞","𝙟","𝙠","𝙡","𝙢","𝙣","𝙤","𝙥","𝙦","𝙧","𝙨","𝙩","𝙪","𝙫","𝙬","𝙭","𝙮","𝙯"}
  local converted = ""
  for char in text:gmatch(".") do
    local lowerChar = char:lower()
    local index = normal:find(lowerChar, 1, true)
    if index then
      converted = converted .. custom[index]
    else
      converted = converted .. char
    end
  end
  return converted
end

-- Underline
local function convertToUnderline(text)
  local normal = "abcdefghijklmnopqrstuvwxyz"
  local custom = {"a̲","b̲","c̲","d̲","e̲","f̲","g̲","h̲","i̲","j̲","k̲","l̲","m̲","n̲","o̲","p̲","q̲","r̲","s̲","t̲","u̲","v̲","w̲","x̲","y̲","z̲"}
  local converted = ""
  for char in text:gmatch(".") do
    local lowerChar = char:lower()
    local index = normal:find(lowerChar, 1, true)
    if index then
      converted = converted .. custom[index]
    else
      converted = converted .. char
    end
  end
  return converted
end

-- Double Underline
local function convertToDoubleUnderline(text)
  local normal = "abcdefghijklmnopqrstuvwxyz"
  local custom = {"a̳","b̳","c̳","d̳","e̳","f̳","g̳","h̳","i̳","j̳","k̳","l̳","m̳","n̳","o̳","p̳","q̳","r̳","s̳","t̳","u̳","v̳","w̳","x̳","y̳","z̳"}
  local converted = ""
  for char in text:gmatch(".") do
    local lowerChar = char:lower()
    local index = normal:find(lowerChar, 1, true)
    if index then
      converted = converted .. custom[index]
    else
      converted = converted .. char
    end
  end
  return converted
end

-- Strikethrough
local function convertToStrikethrough(text)
  local normal = "abcdefghijklmnopqrstuvwxyz"
  local custom = {"a̶","b̶","c̶","d̶","e̶","f̶","g̶","h̶","i̶","j̶","k̶","l̶","m̶","n̶","o̶","p̶","q̶","r̶","s̶","t̶","u̶","v̶","w̶","x̶","y̶","z̶"}
  local converted = ""
  for char in text:gmatch(".") do
    local lowerChar = char:lower()
    local index = normal:find(lowerChar, 1, true)
    if index then
      converted = converted .. custom[index]
    else
      converted = converted .. char
    end
  end
  return converted
end

-- Scratched
local function convertToScratched(text)
  local normal = "abcdefghijklmnopqrstuvwxyz"
  local custom = {"a̷","b̷","c̷","d̷","e̷","f̷","g̷","h̷","i̷","j̷","k̷","l̷","m̷","n̷","o̷","p̷","q̷","r̷","s̷","t̷","u̷","v̷","w̷","x̷","y̷","z̷"}
  local converted = ""
  for char in text:gmatch(".") do
    local lowerChar = char:lower()
    local index = normal:find(lowerChar, 1, true)
    if index then
      converted = converted .. custom[index]
    else
      converted = converted .. char
    end
  end
  return converted
end

-- Down Arrow
local function convertToDownArrow(text)
  local normal = "abcdefghijklmnopqrstuvwxyz"
  local custom = {"a͎","b͎","c͎","d͎","e͎","f͎","g͎","h͎","i͎","j͎","k͎","l͎","m͎","n͎","o͎","p͎","q͎","r͎","s͎","t͎","u͎","v͎","w͎","x͎","y͎","z͎"}
  local converted = ""
  for char in text:gmatch(".") do
    local lowerChar = char:lower()
    local index = normal:find(lowerChar, 1, true)
    if index then
      converted = converted .. custom[index]
    else
      converted = converted .. char
    end
  end
  return converted
end

-- Hot Text
local function convertToHotText(text)
  local normal = "abcdefghijklmnopqrstuvwxyz"
  local custom = {"a̾","b̾","c̾","d̾","e̾","f̾","g̾","h̾","i̾","j̾","k̾","l̾","m̾","n̾","o̾","p̾","q̾","r̾","s̾","t̾","u̾","v̾","w̾","x̾","y̾","z̾"}
  local converted = ""
  for char in text:gmatch(".") do
    local lowerChar = char:lower()
    local index = normal:find(lowerChar, 1, true)
    if index then
      converted = converted .. custom[index]
    else
      converted = converted .. char
    end
  end
  return converted
end

-- Circled
local function convertToCircled(text)
  local normal = "abcdefghijklmnopqrstuvwxyz"
  local custom = {"ⓐ","ⓑ","ⓒ","ⓓ","ⓔ","ⓕ","ⓖ","ⓗ","ⓘ","ⓙ","ⓚ","ⓛ","ⓜ","ⓝ","ⓞ","ⓟ","ⓠ","ⓡ","ⓢ","ⓣ","ⓤ","ⓥ","ⓦ","ⓧ","ⓨ","ⓩ"}
  local converted = ""
  for char in text:gmatch(".") do
    local lowerChar = char:lower()
    local index = normal:find(lowerChar, 1, true)
    if index then
      converted = converted .. custom[index]
    else
      converted = converted .. char
    end
  end
  return converted
end

-- Squared
local function convertToSquared(text)
  local normal = "abcdefghijklmnopqrstuvwxyz"
  local custom = {"🄰","🄱","🄲","🄳","🄴","🄵","🄶","🄷","🄸","🄹","🄺","🄻","🄼","🄽","🄾","🄿","🅀","🅁","🅂","🅃","🅄","🅅","🅆","🅇","🅈","🅉"}
  local converted = ""
  for char in text:gmatch(".") do
    local lowerChar = char:lower()
    local index = normal:find(lowerChar, 1, true)
    if index then
      converted = converted .. custom[index]
    else
      converted = converted .. char
    end
  end
  return converted
end

-- Squared Black
local function convertToSquaredBlack(text)
  local normal = "abcdefghijklmnopqrstuvwxyz"
  local custom = {"🅰","🅱","🅲","🅳","🅴","🅵","🅶","🅷","🅸","🅹","🅺","🅻","🅼","🅽","🅾","🅿","🆀","🆁","🆂","🆃","🆄","🆅","🆆","🆇","🆈","🆉"}
  local converted = ""
  for char in text:gmatch(".") do
    local lowerChar = char:lower()
    local index = normal:find(lowerChar, 1, true)
    if index then
      converted = converted .. custom[index]
    else
      converted = converted .. char
    end
  end
  return converted
end

-- Asian Style
local function convertToAsianStyle(text)
  local normal = "abcdefghijklmnopqrstuvwxyz"
  local custom = {"卂","乃","匚","ᗪ","乇","千","Ꮆ","卄","丨","ﾌ","Ҝ","ㄥ","爪","几","ㄖ","卩","Ɋ","尺","丂","ㄒ","ㄩ","ᐯ","山","乂","ㄚ","乙"}
  local converted = ""
  for char in text:gmatch(".") do
    local lowerChar = char:lower()
    local index = normal:find(lowerChar, 1, true)
    if index then
      converted = converted .. custom[index]
    else
      converted = converted .. char
    end
  end
  return converted
end

-- Asian Style 2
local function convertToAsianStyle2(text)
  local normal = "abcdefghijklmnopqrstuvwxyz"
  local custom = {"ﾑ","乃","ᄃ","り","乇","ｷ","ム","ん","ﾉ","ﾌ","ズ","ﾚ","ﾶ","刀","の","ｱ","ゐ","尺","丂","ｲ","ひ","√","W","ﾒ","ﾘ","乙"}
  local converted = ""
  for char in text:gmatch(".") do
    local lowerChar = char:lower()
    local index = normal:find(lowerChar, 1, true)
    if index then
      converted = converted .. custom[index]
    else
      converted = converted .. char
    end
  end
  return converted
end

-- Indian Way
local function convertToIndianWay(text)
  local normal = "abcdefghijklmnopqrstuvwxyz"
  local custom = {"ค","ც","८","ძ","૯","Б","૭","Һ","ɿ","ʆ","қ","Ն","ɱ","Ո","૦","ƿ","ҩ","Ր","ς","੮","υ","౮","ω","૪","ע","ઽ"}
  local converted = ""
  for char in text:gmatch(".") do
    local lowerChar = char:lower()
    local index = normal:find(lowerChar, 1, true)
    if index then
      converted = converted .. custom[index]
    else
      converted = converted .. char
    end
  end
  return converted
end

-- Russian Way
local function convertToRussianWay(text)
  local normal = "abcdefghijklmnopqrstuvwxyz"
  local custom = {"а","б","c","д","ё","f","g","н","ї","j","к","г","ѫ","п","ѳ","p","ф","я","$","т","ц","ѵ","щ","ж","ч","з"}
  local converted = ""
  for char in text:gmatch(".") do
    local lowerChar = char:lower()
    local index = normal:find(lowerChar, 1, true)
    if index then
      converted = converted .. custom[index]
    else
      converted = converted .. char
    end
  end
  return converted
end

-- Big Russian
local function convertToBigRussian(text)
  local normal = "abcdefghijklmnopqrstuvwxyz"
  local custom = {"Д","Б","C","D","Ξ","F","G","H","I","J","Ҝ","L","M","И","Ф","P","Ǫ","Я","S","Γ","Ц","V","Щ","Ж","У","Z"}
  local converted = ""
  for char in text:gmatch(".") do
    local lowerChar = char:lower()
    local index = normal:find(lowerChar, 1, true)
    if index then
      converted = converted .. custom[index]
    else
      converted = converted .. char
    end
  end
  return converted
end

-- Squiggle Symbols 1
local function convertToSquiggle1(text)
  local normal = "abcdefghijklmnopqrstuvwxyz"
  local custom = {"ꋫ","ꃃ","ꏸ","ꁕ","ꍟ","ꄘ","ꁍ","ꑛ","ꂑ","ꀭ","ꀗ","꒒","ꁒ","ꁹ","ꆂ","ꉣ","ꁸ","꒓","ꌚ","꓅","ꐇ","ꏝ","ꅐ","ꇓ","ꐟ","ꁴ"}
  local converted = ""
  for char in text:gmatch(".") do
    local lowerChar = char:lower()
    local index = normal:find(lowerChar, 1, true)
    if index then
      converted = converted .. custom[index]
    else
      converted = converted .. char
    end
  end
  return converted
end

-- Squiggle Symbols 2
local function convertToSquiggle2(text)
  local normal = "abcdefghijklmnopqrstuvwxyz"
  local custom = {"ꍏ","ꌃ","ꉓ","ꀸ","ꍟ","ꎇ","ꁅ","ꃅ","ꀤ","ꀭ","ꀘ","꒒","ꂵ","ꈤ","ꂦ","ꉣ","ꆰ","ꋪ","ꌗ","꓄","ꀎ","ꃴ","ꅏ","ꊼ","ꌩ","ꁴ"}
  local converted = ""
  for char in text:gmatch(".") do
    local lowerChar = char:lower()
    local index = normal:find(lowerChar, 1, true)
    if index then
      converted = converted .. custom[index]
    else
      converted = converted .. char
    end
  end
  return converted
end

-- Squiggle Symbols 3
local function convertToSquiggle3(text)
  local normal = "abcdefghijklmnopqrstuvwxyz"
  local custom = {"α","ß","ς","d","ε","ƒ","g","h","ï","յ","κ","ﾚ","m","η","⊕","p","Ω","r","š","†","u","∀","ω","x","ψ","z"}
  local converted = ""
  for char in text:gmatch(".") do
    local lowerChar = char:lower()
    local index = normal:find(lowerChar, 1, true)
    if index then
      converted = converted .. custom[index]
    else
      converted = converted .. char
    end
  end
  return converted
end

-- Squiggle Symbols 4
local function convertToSquiggle4(text)
  local normal = "abcdefghijklmnopqrstuvwxyz"
  local custom = {"Δ","β","Ć","Đ","€","₣","Ǥ","Ħ","Ɨ","Ĵ","Ҝ","Ł","Μ","Ň","Ø","Ƥ","Ω","Ř","Ş","Ŧ","Ữ","V","Ŵ","Ж","¥","Ž"}
  local converted = ""
  for char in text:gmatch(".") do
    local lowerChar = char:lower()
    local index = normal:find(lowerChar, 1, true)
    if index then
      converted = converted .. custom[index]
    else
      converted = converted .. char
    end
  end
  return converted
end

-- Squiggle Symbols 5
local function convertToSquiggle5(text)
  local normal = "abcdefghijklmnopqrstuvwxyz"
  local custom = {"ꋬ","ꃳ","ꉔ","꒯","ꏂ","ꊰ","ꍌ","ꁝ","꒐","꒻","ꀘ","꒒","ꂵ","ꋊ","ꄲ","ꉣ","ꆰ","ꋪ","ꇙ","꓄","꒤","꒦","ꅐ","ꉧ","ꌦ","ꁴ"}
  local converted = ""
  for char in text:gmatch(".") do
    local lowerChar = char:lower()
    local index = normal:find(lowerChar, 1, true)
    if index then
      converted = converted .. custom[index]
    else
      converted = converted .. char
    end
  end
  return converted
end

-- Bat Man
local function convertToBatMan(text)
  local normal = "abcdefghijklmnopqrstuvwxyz"
  local custom = {"a̼","b̼","c̼","d̼","e̼","f̼","g̼","h̼","i̼","j̼","k̼","l̼","m̼","n̼","o̼","p̼","q̼","r̼","s̼","t̼","u̼","v̼","w̼","x̼","y̼","z̼"}
  local converted = ""
  for char in text:gmatch(".") do
    local lowerChar = char:lower()
    local index = normal:find(lowerChar, 1, true)
    if index then
      converted = converted .. custom[index]
    else
      converted = converted .. char
    end
  end
  return converted
end

-- Top Border
local function convertToTopBorder(text)
  local normal = "abcdefghijklmnopqrstuvwxyz"
  local custom = {"a͆","b͆","c͆","d͆","e͆","f͆","g͆","h͆","i͆","j͆","k͆","l͆","m͆","n͆","o͆","p͆","q͆","r͆","s͆","t͆","u͆","v͆","w͆","x͆","y͆","z͆"}
  local converted = ""
  for char in text:gmatch(".") do
    local lowerChar = char:lower()
    local index = normal:find(lowerChar, 1, true)
    if index then
      converted = converted .. custom[index]
    else
      converted = converted .. char
    end
  end
  return converted
end

-- Bottom Border
local function convertToBottomBorder(text)
  local normal = "abcdefghijklmnopqrstuvwxyz"
  local custom = {"a̺","b̺","c̺","d̺","e̺","f̺","g̺","h̺","i̺","j̺","k̺","l̺","m̺","n̺","o̺","p̺","q̺","r̺","s̺","t̺","u̺","v̺","w̺","x̺","y̺","z̺"}
  local converted = ""
  for char in text:gmatch(".") do
    local lowerChar = char:lower()
    local index = normal:find(lowerChar, 1, true)
    if index then
      converted = converted .. custom[index]
    else
      converted = converted .. char
    end
  end
  return converted
end

-- Bottom Star
local function convertToBottomStar(text)
  local normal = "abcdefghijklmnopqrstuvwxyz"
  local custom = {"a͙","b͙","c͙","d͙","e͙","f͙","g͙","h͙","i͙","j͙","k͙","l͙","m͙","n͙","o͙","p͙","q͙","r͙","s͙","t͙","u͙","v͙","w͙","x͙","y͙","z͙"}
  local converted = ""
  for char in text:gmatch(".") do
    local lowerChar = char:lower()
    local index = normal:find(lowerChar, 1, true)
    if index then
      converted = converted .. custom[index]
    else
      converted = converted .. char
    end
  end
  return converted
end

-- Bottom Plus
local function convertToBottomPlus(text)
  local normal = "abcdefghijklmnopqrstuvwxyz"
  local custom = {"a̟","b̟","c̟","d̟","e̟","f̟","g̟","h̟","i̟","j̟","k̟","l̟","m̟","n̟","o̟","p̟","q̟","r̟","s̟","t̟","u̟","v̟","w̟","x̟","y̟","z̟"}
  local converted = ""
  for char in text:gmatch(".") do
    local lowerChar = char:lower()
    local index = normal:find(lowerChar, 1, true)
    if index then
      converted = converted .. custom[index]
    else
      converted = converted .. char
    end
  end
  return converted
end

-- Bottom Arrow
local function convertToBottomArrow(text)
  local normal = "abcdefghijklmnopqrstuvwxyz"
  local custom = {"a͎","b͎","c͎","d͎","e͎","f͎","g͎","h͎","i͎","j͎","k͎","l͎","m͎","n͎","o͎","p͎","q͎","r͎","s͎","t͎","u͎","v͎","w͎","x͎","y͎","z͎"}
  local converted = ""
  for char in text:gmatch(".") do
    local lowerChar = char:lower()
    local index = normal:find(lowerChar, 1, true)
    if index then
      converted = converted .. custom[index]
    else
      converted = converted .. char
    end
  end
  return converted
end

-- Cross Top & Bottom
local function convertToCrossTopBottom(text)
  local normal = "abcdefghijklmnopqrstuvwxyz"
  local custom = {"a͓̽","b͓̽","c͓̽","d͓̽","e͓̽","f͓̽","g͓̽","h͓̽","i͓̽","j͓̽","k͓̽","l͓̽","m͓̽","n͓̽","o͓̽","p͓̽","q͓̽","r͓̽","s͓̽","t͓̽","u͓̽","v͓̽","w͓̽","x͓̽","y͓̽","z͓̽"}
  local converted = ""
  for char in text:gmatch(".") do
    local lowerChar = char:lower()
    local index = normal:find(lowerChar, 1, true)
    if index then
      converted = converted .. custom[index]
    else
      converted = converted .. char
    end
  end
  return converted
end

-- Stinky
local function convertToStinky(text)
  local normal = "abcdefghijklmnopqrstuvwxyz"
  local custom = {"a̾","b̾","c̾","d̾","e̾","f̾","g̾","h̾","i̾","j̾","k̾","l̾","m̾","n̾","o̾","p̾","q̾","r̾","s̾","t̾","u̾","v̾","w̾","x̾","y̾","z̾"}
  local converted = ""
  for char in text:gmatch(".") do
    local lowerChar = char:lower()
    local index = normal:find(lowerChar, 1, true)
    if index then
      converted = converted .. custom[index]
    else
      converted = converted .. char
    end
  end
  return converted
end

-- Cross Above Below
local function convertToCrossAboveBelow(text)
  local normal = "abcdefghijklmnopqrstuvwxyz"
  local custom = {"a͓̽","b͓̽","c͓̽","d͓̽","e͓̽","f͓̽","g͓̽","h͓̽","i͓̽","j͓̽","k͓̽","l͓̽","m͓̽","n͓̽","o͓̽","p͓̽","q͓̽","r͓̽","s͓̽","t͓̽","u͓̽","v͓̽","w͓̽","x͓̽","y͓̽","z͓̽"}
  local converted = ""
  for char in text:gmatch(".") do
    local lowerChar = char:lower()
    local index = normal:find(lowerChar, 1, true)
    if index then
      converted = converted .. custom[index]
    else
      converted = converted .. char
    end
  end
  return converted
end

-- Arrow Below
local function convertToArrowBelow(text)
  local normal = "abcdefghijklmnopqrstuvwxyz"
  local custom = {"a͎","b͎","c͎","d͎","e͎","f͎","g͎","h͎","i͎","j͎","k͎","l͎","m͎","n͎","o͎","p͎","q͎","r͎","s͎","t͎","u͎","v͎","w͎","x͎","y͎","z͎"}
  local converted = ""
  for char in text:gmatch(".") do
    local lowerChar = char:lower()
    local index = normal:find(lowerChar, 1, true)
    if index then
      converted = converted .. custom[index]
    else
      converted = converted .. char
    end
  end
  return converted
end

-- Thick Box
local function convertToThickBox(text)
  local normal = "abcdefghijklmnopqrstuvwxyz"
  local custom = {"⟦a⟧","⟦b⟧","⟦c⟧","⟦d⟧","⟦e⟧","⟦f⟧","⟦g⟧","⟦h⟧","⟦i⟧","⟦j⟧","⟦k⟧","⟦l⟧","⟦m⟧","⟦n⟧","⟦o⟧","⟦p⟧","⟦q⟧","⟦r⟧","⟦s⟧","⟦t⟧","⟦u⟧","⟦v⟧","⟦w⟧","⟦x⟧","⟦y⟧","⟦z⟧"}
  local converted = ""
  for char in text:gmatch(".") do
    local lowerChar = char:lower()
    local index = normal:find(lowerChar, 1, true)
    if index then
      converted = converted .. custom[index]
    else
      converted = converted .. char
    end
  end
  return converted
end

-- Dot Box
local function convertToDotBox(text)
  local normal = "abcdefghijklmnopqrstuvwxyz"
  local custom = {"꜍a꜉","꜍b꜉","꜍c꜉","꜍d꜉","꜍e꜉","꜍f꜉","꜍g꜉","꜍h꜉","꜍i꜉","꜍j꜉","꜍k꜉","꜍l꜉","꜍m꜉","꜍n꜉","꜍o꜉","꜍p꜉","꜍q꜉","꜍r꜉","꜍s꜉","꜍t꜉","꜍u꜉","꜍v꜉","꜍w꜉","꜍x꜉","꜍y꜉","꜍z꜉"}
  local converted = ""
  for char in text:gmatch(".") do
    local lowerChar = char:lower()
    local index = normal:find(lowerChar, 1, true)
    if index then
      converted = converted .. custom[index]
    else
      converted = converted .. char
    end
  end
  return converted
end

-- Arrow Box
local function convertToArrowBox(text)
  local normal = "abcdefghijklmnopqrstuvwxyz"
  local custom = {"⦏â⦎","⦏b̂⦎","⦏ĉ⦎","⦏d̂⦎","⦏ê⦎","⦏f̂⦎","⦏ĝ⦎","⦏ĥ⦎","⦏î⦎","⦏ĵ⦎","⦏k̂⦎","⦏l̂⦎","⦏m̂⦎","⦏n̂⦎","⦏ô⦎","⦏p̂⦎","⦏q̂⦎","⦏r̂⦎","⦏ŝ⦎","⦏t̂⦎","⦏û⦎","⦏v̂⦎","⦏ŵ⦎","⦏x̂⦎","⦏ŷ⦎","⦏ẑ⦎"}
  local converted = ""
  for char in text:gmatch(".") do
    local lowerChar = char:lower()
    local index = normal:find(lowerChar, 1, true)
    if index then
      converted = converted .. custom[index]
    else
      converted = converted .. char
    end
  end
  return converted
end

-- Diametric Box
local function convertToDiametricBox(text)
  local normal = "abcdefghijklmnopqrstuvwxyz"
  local custom = {"⦑a⦒","⦑b⦒","⦑c⦒","⦑d⦒","⦑e⦒","⦑f⦒","⦑g⦒","⦑h⦒","⦑i⦒","⦑j⦒","⦑k⦒","⦑l⦒","⦑m⦒","⦑n⦒","⦑o⦒","⦑p⦒","⦑q⦒","⦑r⦒","⦑s⦒","⦑t⦒","⦑u⦒","⦑v⦒","⦑w⦒","⦑x⦒","⦑y⦒","⦑z⦒"}
  local converted = ""
  for char in text:gmatch(".") do
    local lowerChar = char:lower()
    local index = normal:find(lowerChar, 1, true)
    if index then
      converted = converted .. custom[index]
    else
      converted = converted .. char
    end
  end
  return converted
end

-- Thick Block Framed
local function convertToThickBlockFramed(text)
  local normal = "abcdefghijklmnopqrstuvwxyz"
  local custom = {"【a】","【b】","【c】","【d】","【e】","【f】","【g】","【h】","【i】","【j】","【k】","【l】","【m】","【n】","【o】","【p】","【q】","【r】","【s】","【t】","【u】","【v】","【w】","【x】","【y】","【z】"}
  local converted = ""
  for char in text:gmatch(".") do
    local lowerChar = char:lower()
    local index = normal:find(lowerChar, 1, true)
    if index then
      converted = converted .. custom[index]
    else
      converted = converted .. char
    end
  end
  return converted
end

-- Diametric Angle Frame
local function convertToDiametricAngleFrame(text)
  local normal = "abcdefghijklmnopqrstuvwxyz"
  local custom = {"『a』","『b』","『c』","『d』","『e』","『f』","『g』","『h』","『i』","『j』","『k』","『l』","『m』","『n』","『o』","『p』","『q』","『r』","『s』","『t』","『u』","『v』","『w』","『x』","『y』","『z』"}
  local converted = ""
  for char in text:gmatch(".") do
    local lowerChar = char:lower()
    local index = normal:find(lowerChar, 1, true)
    if index then
      converted = converted .. custom[index]
    else
      converted = converted .. char
    end
  end
  return converted
end

-- Brackethangtext Angle Frame
local function convertToBrackethangtextAngleFrame(text)
  local normal = "abcdefghijklmnopqrstuvwxyz"
  local custom = {"╟a╢","╟b╢","╟c╢","╟d╢","╟e╢","╟f╢","╟g╢","╟h╢","╟i╢","╟j╢","╟k╢","╟l╢","╟m╢","╟n╢","╟o╢","╟p╢","╟q╢","╟r╢","╟s╢","╟t╢","╟u╢","╟v╢","╟w╢","╟x╢","╟y╢","╟z╢"}
  local converted = ""
  for char in text:gmatch(".") do
    local lowerChar = char:lower()
    local index = normal:find(lowerChar, 1, true)
    if index then
      converted = converted .. custom[index]
    else
      converted = converted .. char
    end
  end
  return converted
end

-- Focustext Angle Frame
local function convertToFocustextAngleFrame(text)
  local normal = "abcdefghijklmnopqrstuvwxyz"
  local custom = {"⎡a⎦","⎡b⎦","⎡c⎦","⎡d⎦","⎡e⎦","⎡f⎦","⎡g⎦","⎡h⎦","⎡i⎦","⎡j⎦","⎡k⎦","⎡l⎦","⎡m⎦","⎡n⎦","⎡o⎦","⎡p⎦","⎡q⎦","⎡r⎦","⎡s⎦","⎡t⎦","⎡u⎦","⎡v⎦","⎡w⎦","⎡x⎦","⎡y⎦","⎡z⎦"}
  local converted = ""
  for char in text:gmatch(".") do
    local lowerChar = char:lower()
    local index = normal:find(lowerChar, 1, true)
    if index then
      converted = converted .. custom[index]
    else
      converted = converted .. char
    end
  end
  return converted
end

-- Newsquare bracket Angle Frame
local function convertToNewsquareBracketAngleFrame(text)
  local normal = "abcdefghijklmnopqrstuvwxyz"
  local custom = {"⁅a⁆","⁅b⁆","⁅c⁆","⁅d⁆","⁅e⁆","⁅f⁆","⁅g⁆","⁅h⁆","⁅i⁆","⁅j⁆","⁅k⁆","⁅l⁆","⁅m⁆","⁅n⁆","⁅o⁆","⁅p⁆","⁅q⁆","⁅r⁆","⁅s⁆","⁅t⁆","⁅u⁆","⁅v⁆","⁅w⁆","⁅x⁆","⁅y⁆","⁅z⁆"}
  local converted = ""
  for char in text:gmatch(".") do
    local lowerChar = char:lower()
    local index = normal:find(lowerChar, 1, true)
    if index then
      converted = converted .. custom[index]
    else
      converted = converted .. char
    end
  end
  return converted
end

-- Test all fonts
local testText = "by Batman"
gg.alert("Fraktur: " .. convertToFraktur(testText))
gg.alert("Monospace: " .. convertToMonospace(testText))
gg.alert("Roman: " .. convertToRoman(testText))
gg.alert("Canadian: " .. convertToCanadian(testText))
gg.alert("Taile: " .. convertToTaile(testText))
gg.alert("Smallcaps: " .. convertToSmallcaps(testText))
gg.alert("Superscript: " .. convertToSuperscript(testText))
gg.alert("Inverted: " .. convertToInverted(testText))
gg.alert("Serif Bold: " .. convertToSerifBold(testText))
gg.alert("Sans: " .. convertToSans(testText))
gg.alert("Sans Bold Italic: " .. convertToSansBoldItalic(testText))
gg.alert("Underline: " .. convertToUnderline(testText))
gg.alert("Double Underline: " .. convertToDoubleUnderline(testText))
gg.alert("Strikethrough: " .. convertToStrikethrough(testText))
gg.alert("Scratched: " .. convertToScratched(testText))
gg.alert("Down Arrow: " .. convertToDownArrow(testText))
gg.alert("Hot Text: " .. convertToHotText(testText))
gg.alert("Circled: " .. convertToCircled(testText))
gg.alert("Squared: " .. convertToSquared(testText))
gg.alert("Squared Black: " .. convertToSquaredBlack(testText))
gg.alert("Asian Style: " .. convertToAsianStyle(testText))
gg.alert("Asian Style 2: " .. convertToAsianStyle2(testText))
gg.alert("Indian Way: " .. convertToIndianWay(testText))
gg.alert("Russian Way: " .. convertToRussianWay(testText))
gg.alert("Big Russian: " .. convertToBigRussian(testText))
gg.alert("Squiggle 1: " .. convertToSquiggle1(testText))
gg.alert("Squiggle 2: " .. convertToSquiggle2(testText))
gg.alert("Squiggle 3: " .. convertToSquiggle3(testText))
gg.alert("Squiggle 4: " .. convertToSquiggle4(testText))
gg.alert("Squiggle 5: " .. convertToSquiggle5(testText))
gg.alert("Bat Man: " .. convertToBatMan(testText))
gg.alert("Top Border: " .. convertToTopBorder(testText))
gg.alert("Bottom Border: " .. convertToBottomBorder(testText))
gg.alert("Bottom Star: " .. convertToBottomStar(testText))
gg.alert("Bottom Plus: " .. convertToBottomPlus(testText))
gg.alert("Bottom Arrow: " .. convertToBottomArrow(testText))
gg.alert("Cross Top & Bottom: " .. convertToCrossTopBottom(testText))
gg.alert("Stinky: " .. convertToStinky(testText))
gg.alert("Cross Above Below: " .. convertToCrossAboveBelow(testText))
gg.alert("Arrow Below: " .. convertToArrowBelow(testText))
gg.alert("Thick Box: " .. convertToThickBox(testText))
gg.alert("Dot Box: " .. convertToDotBox(testText))
gg.alert("Arrow Box: " .. convertToArrowBox(testText))
gg.alert("Diametric Box: " .. convertToDiametricBox(testText))
gg.alert("Thick Block Framed: " .. convertToThickBlockFramed(testText))
gg.alert("Diametric Angle Frame: " .. convertToDiametricAngleFrame(testText))
gg.alert("Brackethangtext Angle Frame: " .. convertToBrackethangtextAngleFrame(testText))
gg.alert("Focustext Angle Frame: " .. convertToFocustextAngleFrame(testText))
gg.alert("Newsquare Bracket Angle Frame: " .. convertToNewsquareBracketAngleFrame(testText))