
A = gg.FILES_DIR

packageGGForKillDaemon = "com.i.xmdv.zs.rrt.ve"

packageyourGG  = "catch_.me_.if_.you_.can_"

rest = "/"

local match = A:match("([/a-zA-Z0-9_.-]+/0)")  

local trap= match.gsub(match, packageyourGG, packageGGForKillDaemon) 

tools.chmod(match..rest..packageGGForKillDaemon,000)

gg.alert(" gameguardian  "..packageGGForKillDaemon.." daemon killed sucess")


