
--code by Batman Games
-- telegram: @batmangamesS

-- Table version Android 
local versoes_permitidas = {
    ["Android 8"] = true,
    ["Android 9"] = true,
    ["Android 11"] = true
}

local function verificarVersaoPermitida(versao)
    return versoes_permitidas[versao]
end

local response = gg.makeRequest("https://weather.mp.qq.com/?_nav_alpha=0&_nav_txtclr=ffffff&_nav_titleclr=ffffff&_nav_anim=true&asyncMode=1&adtag=h5page.ark_expose&city=%E4%B8%AD%E5%B1%B1-%E4%B8%AD%E5%B1%B1&adcode=101281701").content 

if response then 
    local xh, bb = response:match("%(Linux; U; (.-); (.-)%)") 

    if xh and bb then 
        
        print("System version: " .. xh) 

        
        if not verificarVersaoPermitida(xh) then
            gg.alert("The system version is not supported. ")
            return 
        end

    else 
        gg.toast("Unable to obtain device information.") 
    end 
else 
    gg.toast("Failed to make request for device information.") 
end