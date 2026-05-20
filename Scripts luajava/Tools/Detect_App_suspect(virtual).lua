if luajava == nil then gg.alert(' unavaliable please use gameguardian mod (suport luajava)') else end

if type(gg.shell) ~= "function" then
    gg.alert("shell not available use game guardian mod luajava")
    os.exit()
end

local info = gg.getTargetInfo()
local pid = info and info.pid

if not pid then
    gg.alert("no process available")
    os.exit()
end

local fd = gg.shell("ls -l /proc/" .. pid .. "/fd")
if not fd then
    gg.alert("failed to read fd")
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

local blacklist = {}
for i = 1, #tab do
    blacklist[tab[i]] = true
end

local apks = {}

for line in fd:gmatch("[^\n]+") do
    local path = line:match("(/data/app/.-/base%.apk)")
    if path then
        apks[path] = true
    end
end

for path in pairs(apks) do
 local pkg = path:match("/data/app/(.-)-")    
    if pkg then
       if blacklist[pkg] then
            print("🚨 App suspect detected:", pkg)
            os.exit()
        end
    end
end


