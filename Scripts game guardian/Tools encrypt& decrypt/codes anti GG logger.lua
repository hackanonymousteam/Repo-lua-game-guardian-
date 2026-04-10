
PACKAGE = "com.game.guardian" -- your package gg

local EXPECTED = "/data/user/0/"..PACKAGE.."/cache"
local EXPECTED1 = "/data/user/0/"..PACKAGE.."/files"

if gg.CACHE_DIR ~= EXPECTED then
    print("please use my gg")
    os.exit()
end

if gg.FILES_DIR ~= EXPECTED1 then
    print("please use my gg")
    os.exit()
end

local tab = {
"com.prabalgaming.logger",
"any_.body_.can_.fuck_.tencent_",
"com.rjvsbmhdspmnfbame",
"com.redwolfgaming.ripgg",
"com.vrexqfftfsxekm.kl",
"com.nochqxpucsbldqqx",
"com.ghueczxrttlhgd",
"com.yy.qptvrjwerw.ghoex",
"com.Egypt.yuosseef",
"com.tssfjipkmrco",
"com.vip.paidhacksonly.mr.toxin",
"com.ioyysvgfsrig",
"com.mrteamz.id",
"com.jtbodgpqxox",
"com.ByGGXEZ",
"com.eidymumcghpfeeeavps",
"com.mod.iraq",
"com.dzelttwyuyyes",
"com.sxqa",
"com.xyyxgxfn",
"com.zgb",
"com.vnpqk",
"com.mwjvnwesbghkxbjznbwo",
"com.blackduty.gc",
"com.s.fyojrme",
"com.roxmemek",
"com.fhshwhpvqvruvjtu",
"com.fireongaming.fog",
"com.paranoiaworks.unicus.android.sse",
"com.raincitygaming.ggmod",
"com.pvt4u",
"com.nydpvsb.z.r.pkgh",
"com.gmsm",
"com.sudsjcqvvcmgutdjeg",
"com.coolfoolggfuckscript.tm",
"com.foxcyber.gg",
"com.hckeam.mjgql",
"com.i.ii",
"com.k.kk",
"com.aero.ss",
"com.decrypt.tool.by.joker.gg",
"com.rgkttz.rausqwl",
"catch.Art.Tool.seatch",
"com.laallkxhtrnqncw",
"com.khoiscript.logger",
"com.kaoygxapp"
}

for i, pkg in ipairs(tab) do
    local expected_cache = "/data/user/0/" .. pkg .. "/cache"
    local expected_files = "/data/user/0/" .. pkg .. "/files"

    if gg.CACHE_DIR == expected_cache or gg.FILES_DIR == expected_files then
        print("please no use gg decrypt")
        os.exit()
    end
end

if gg.VERSION_INT < 10100 then
    gg.alert("Update GameGuardian")
    os.exit()
    return
end

if type(gg.isVPN) == "function" then
    if gg.isVPN() == true then
        gg.alert("Disable VPN")
        os.exit()
        return
    end
end

gg.alert("done")