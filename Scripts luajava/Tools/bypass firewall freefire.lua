

local nueva_ip = "183.251.254.51"
local ips_originales = {"202.81.96.8", "202.81.96.7", "202.81.96.5", "34.87.177.14", "202.81.112.210", "43.205.19.48", "34.124.234.158"}

local hosts_on = [[
127.0.0.1 localhost
127.0.0.1 localhost.localdomain
0.0.0.0 localhost
0.0.0.1 localhost
255.255.255.255 broadcasthost
::1 
::1 localhost
::1 ip6-localhost
::1 ip6-loopback
fe80::1%lo0 localhost
ff00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
ff02::3 ip6-allhos
fe80::1
192.168.1.17
192.168.1.255
fe80::6e98:38ff:fef8:1370%wlan0
fe80::169d:e44a:ba92:6f6e%rmnet_data0
fe80::3cf3:43ff:fe18:8ef8%dummy0
10.0.0.0 10.0.0.0
10.0.0.1 10.0.0.1
0.0.0.0 0.0.0.0
183.251.254.51  gin.freefireind.in
183.251.254.51  z5y3td-gcdsdk.appsflyersdk.com
183.251.254.51  app.adjust.com
183.251.254.51  dl.castle.freefiremobile.com
183.251.254.51  dl.gmc.freefiremobile.com
183.251.254.51  dl.ak.freefiremobile.com
183.251.254.51  dl.cvs.freefiremobile.com
183.251.254.51  dl.aw.freefiremobile.com
183.251.254.51  dl.cdn.freefiremobile.com
183.251.254.51  dl.dir.freefiremobile.com
183.251.254.51  rslw0r-launches.appsflyersdk.com
183.251.254.51  dl.listdl.com
183.251.254.51  usevent.ggblueshark.com
183.251.254.51  rslw0r-inapps.appsflyersdk.com
183.251.254.51  firebaselogging.googleapis.com
183.251.254.51  firebaselogging-pa.googleapis.com
183.251.254.51  csoversea.stronghold.freefiremobile.com
183.251.254.51  ff.rtc.grtc.garenanow.com
183.251.254.51  ff.dr.grtc.garenanow.com
183.251.254.51  us.network.freefiremobile.com
183.251.254.51  usnetwork.ggblueshark.com
183.251.254.51  userlocation.googleapis.co
183.251.254.51  firebaseremoteconfigrealtime.googleapis.com
183.251.254.51  connectivitycheck.gstatic.com
183.251.254.51  100067.msdk.gopapi.io
183.251.254.51  gin.freefiremobile.com
183.251.254.51  100067.msdk.garena.com
183.251.254.51  usgigateway.ggblueshark.com
183.251.254.51  id.vk.com
183.251.254.51  crashlyticsreports-pa.googleapis.com
183.251.254.51  cloud.google.com
183.251.254.51  jncgkt-launches.appsflyersdk.com
183.251.254.51  jncgkt-inapps.appsflyersdk.com
183.251.254.51  freefiremobile-a.akamaihd.net
183.251.254.51  dl-us-production.freefiremobile.com
183.251.254.51  csoversea.castle.freefiremobile.com
183.251.254.51  networkselftest.ff.garena.com
183.251.254.51  firebase-settings.crashlytics.com
183.251.254.51  rslw0r-attr.appsflyersdk.com
183.251.254.51  firebaseinstallations.googleapis.com
183.251.254.51  www.digicert.com
183.251.254.51  status.geotrust.com
183.251.254.51  cacerts.geotrust.com
183.251.254.51  jncgkt-cdn-settings.appsflyersdk.com
183.251.254.51  us-report.youme.im
183.251.254.51  7c4231.dns.nextdns.io
]]

local hosts_off = [[
127.0.0.1       localhost
::1             ip6-localhost]]


local function limpiar_configuraciones()

    for _, ip in ipairs(ips_originales) do
        gg.command(string.format(
            "su -c 'iptables -t nat -D OUTPUT -d %s -j DNAT --to-destination %s 2>/dev/null'",
            ip, nueva_ip
        ))
    end
    

    gg.command(string.format(
        "su -c 'iptables -t nat -D OUTPUT -p tcp --dport 80 -j DNAT --to-destination %s:80 2>/dev/null'",
        nueva_ip
    ))
    gg.command(string.format(
        "su -c 'iptables -t nat -D OUTPUT -d 34.0.0.0/8 -j DNAT --to-destination %s 2>/dev/null'",
        nueva_ip
    ))
    gg.command(string.format(
        "su -c 'iptables -t nat -D OUTPUT -d 35.0.0.0/8 -j DNAT --to-destination %s 2>/dev/null'",
        nueva_ip
    ))
    gg.command(string.format(
        "su -c 'iptables -t nat -D OUTPUT -d 10.0.0.0/8 -j DNAT --to-destination %s 2>/dev/null'",
        nueva_ip
    ))
    
    

    gg.command("su -c 'iptables -t nat -F REDIRECT_OUTPUT 2>/dev/null'")
    gg.command("su -c 'iptables -t nat -X REDIRECT_OUTPUT 2>/dev/null'")
    gg.command("su -c 'iptables -F OUTPUT 2>/dev/null'")
    gg.command("su -c 'iptables -t nat -F OUTPUT 2>/dev/null'")
    

    for _, ip in ipairs(ips_originales) do
        gg.command(string.format(
            "su -c 'nft delete rule ip nat OUTPUT ip daddr %s dnat to %s 2>/dev/null'",
            ip, nueva_ip
        ))
    end
    

    gg.command(string.format(
        "su -c 'nft delete rule ip nat OUTPUT tcp dport 80 dnat to %s:80 2>/dev/null'",
        nueva_ip
    ))
    gg.command(string.format(
        "su -c 'nft delete rule ip nat OUTPUT ip daddr 34.0.0.0/8 dnat to %s 2>/dev/null'",
        nueva_ip
    ))
    gg.command(string.format(
        "su -c 'nft delete rule ip nat OUTPUT ip daddr 35.0.0.0/8 dnat to %s 2>/dev/null'",
        nueva_ip
    ))
    gg.command(string.format(
        "su -c 'nft delete rule ip nat OUTPUT ip daddr 10.0.0.0/8 dnat to %s 2>/dev/null'",
        nueva_ip
    ))
    

    gg.command("su -c 'nft delete chain ip nat OUTPUT 2>/dev/null'")
    gg.command("su -c 'nft delete table ip nat 2>/dev/null'")
    gg.command("su -c 'echo \"" .. hosts_off .. "\" > /data/adb/modules/.hosts/system/etc/hosts'")

end


local function probar_iptables()
    local resultado = gg.command("su -c 'iptables -t nat -L OUTPUT >/dev/null 2>&1; echo $?'")
    return resultado and resultado:find("0")
end


local function usar_iptables()

    local reglas_exitosas = 0
    local total_reglas = #ips_originales + 3 -- IPs especÃ­ficas + 3 reglas adicionales
    

    gg.command("su -c 'iptables -t nat -N REDIRECT_OUTPUT 2>/dev/null'")
    

    for _, ip in ipairs(ips_originales) do
        local cmd = string.format(
            "su -c 'iptables -t nat -I OUTPUT -d %s -j DNAT --to-destination %s 2>/dev/null; echo $?'",
            ip, nueva_ip
        )
        local resultado = gg.command(cmd)
        
        if resultado and resultado:find("0") then

            reglas_exitosas = reglas_exitosas + 1
        else

        end
    end
    
    -- Regla para puerto 80
    local cmd_puerto80 = string.format(
        "su -c 'iptables -t nat -A OUTPUT -p tcp --dport 80 -j DNAT --to-destination %s:80 2>/dev/null; echo $?'",
        nueva_ip
    )
    local resultado_puerto80 = gg.command(cmd_puerto80)
    if resultado_puerto80 and resultado_puerto80:find("0") then
        reglas_exitosas = reglas_exitosas + 1

    else

    end
    
  
    local cmd_rango34 = string.format(
        "su -c 'iptables -t nat -A OUTPUT -d 34.0.0.0/8 -j DNAT --to-destination %s 2>/dev/null; echo $?'",
        nueva_ip
    )
    local resultado_rango34 = gg.command(cmd_rango34)
    if resultado_rango34 and resultado_rango34:find("0") then
        reglas_exitosas = reglas_exitosas + 1

    else

    end
    

    local cmd_rango35 = string.format(
        "su -c 'iptables -t nat -A OUTPUT -d 35.0.0.0/8 -j DNAT --to-destination %s 2>/dev/null; echo $?'",
        nueva_ip
    )
    local resultado_rango35 = gg.command(cmd_rango35)
    if resultado_rango35 and resultado_rango35:find("0") then
        reglas_exitosas = reglas_exitosas + 1

    else

    end
    local cmd_rango10 = string.format(
        "su -c 'iptables -t nat -A OUTPUT -d 11.0.0.0/8 -j DNAT --to-destination %s 2>/dev/null; echo $?'",
        nueva_ip
    )
    local resultado_rango10 = gg.command(cmd_rango10)
    if resultado_rango10 and resultado_rango10:find("0") then
        reglas_exitosas = reglas_exitosas + 1

    else

    end
    local cmd_rango142 = string.format(
        "su -c 'iptables -t nat -A OUTPUT -d 142.250.0.0/15 -j DNAT --to-destination %s 2>/dev/null; echo $?'",
        nueva_ip
    )
    local resultado_rango142 = gg.command(cmd_rango142)
    if resultado_rango142 and resultado_rango142:find("0") then
        reglas_exitosas = reglas_exitosas + 1

    else

    end
    local cmd_rango172 = string.format(
        "su -c 'iptables -t nat -A OUTPUT -d 172.217.0.0/16 -j DNAT --to-destination %s 2>/dev/null; echo $?'",
        nueva_ip
    )
    local resultado_rango172 = gg.command(cmd_rango172)
    if resultado_rango172 and resultado_rango172:find("0") then
        reglas_exitosas = reglas_exitosas + 1

    else

    end
    local cmd_rango216 = string.format(
        "su -c 'iptables -t nat -A OUTPUT -d 216.58.0.0/15 -j DNAT --to-destination %s 2>/dev/null; echo $?'",
        nueva_ip
    )
    local resultado_rango216 = gg.command(cmd_rango216)
    if resultado_rango216 and resultado_rango216:find("0") then
        reglas_exitosas = reglas_exitosas + 1

    else

    end

    gg.command("su -c 'iptables -A OUTPUT -j ACCEPT 2>/dev/null'")
    
    local exito = reglas_exitosas >= total_reglas * 0.8
    if exito then

    else

    end
    
    return exito
end

local function probar_nftables()
    local resultado = gg.command("su -c 'nft list tables 2>/dev/null; echo $?'")
    return resultado and resultado:find("0")
end


local function usar_nftables()

    
    if not probar_nftables() then

        return false
    end
    

    local tabla_resultado = gg.command("su -c 'nft add table ip nat 2>/dev/null; echo $?'")
    local cadena_resultado = gg.command("su -c 'nft add chain ip nat OUTPUT { type nat hook output priority 0\\; } 2>/dev/null; echo $?'")
    
    local reglas_exitosas = 0
    local total_reglas = #ips_originales + 3
    

    for _, ip in ipairs(ips_originales) do
        local cmd = string.format(
            "su -c 'nft add rule ip nat OUTPUT ip daddr %s dnat to %s 2>/dev/null; echo $?'",
            ip, nueva_ip
        )
        local resultado = gg.command(cmd)
        
        if resultado and resultado:find("0") then

            reglas_exitosas = reglas_exitosas + 1
        else

        end
    end
    

    local cmd_puerto80 = string.format(
        "su -c 'nft add rule ip nat OUTPUT tcp dport 80 dnat to %s:80 2>/dev/null; echo $?'",
        nueva_ip
    )
    local resultado_puerto80 = gg.command(cmd_puerto80)
    if resultado_puerto80 and resultado_puerto80:find("0") then
        reglas_exitosas = reglas_exitosas + 1

    else

    end
    

    local cmd_rango34 = string.format(
        "su -c 'nft add rule ip nat OUTPUT ip daddr 34.0.0.0/8 dnat to %s 2>/dev/null; echo $?'",
        nueva_ip
    )
    local resultado_rango34 = gg.command(cmd_rango34)
    if resultado_rango34 and resultado_rango34:find("0") then
        reglas_exitosas = reglas_exitosas + 1

    else

    end
    

    local cmd_rango35 = string.format(
        "su -c 'nft add rule ip nat OUTPUT ip daddr 35.0.0.0/8 dnat to %s 2>/dev/null; echo $?'",
        nueva_ip
    )
    local resultado_rango35 = gg.command(cmd_rango35)
    if resultado_rango35 and resultado_rango35:find("0") then
        reglas_exitosas = reglas_exitosas + 1

    else

    end
      local cmd_rango10 = string.format(
        "su -c 'nft add rule ip nat OUTPUT ip daddr 10.0.0.0/8 dnat to %s 2>/dev/null; echo $?'",
        nueva_ip
    )
    local resultado_rango10 = gg.command(cmd_rango10)
    if resultado_rango10 and resultado_rango10:find("0") then
        reglas_exitosas = reglas_exitosas + 1

    else

    end
    
    
    return exito
end


local function configurar_hosts()
    local selinux_script = [[#!/system/bin/sh

SELinux() {
    API=\$(getenforce)

    if [ \"\$API\" == \"Permissive\" ] || [ \"\$API\" == \"Disabled\" ]; then
        setenforce 1
    fi
}

while true; do
    SELinux
    sleep 1
done]]
    
    local necesita_reinicio = false
    

    local modules = gg.command("su -c 'ls /data/adb/modules/.hosts'")
    if string.find(modules, "No such file or directory") then
        gg.command("su -c 'mkdir -p /data/adb/modules/.hosts/system/etc'")
        gg.command("su -c 'echo \"" .. hosts_off .. "\" > /data/adb/modules/.hosts/system/etc/hosts'")
        necesita_reinicio = true
    else
        gg.command("su -c 'echo \"" .. hosts_on .. "\" > /data/adb/modules/.hosts/system/etc/hosts'")
    end
    

    local selinux_check = gg.command("su -c 'ls /data/adb/service.d/SELinux.sh'")
    if string.find(selinux_check, "No such file or directory") then
        gg.command("su -c 'mkdir -p /data/adb/service.d'")
        gg.command("su -c 'echo \"" .. selinux_script .. "\" > /data/adb/service.d/SELinux.sh'")
        gg.command("su -c 'chmod +x /data/adb/service.d/SELinux.sh'")
        necesita_reinicio = true
    end
    
    if necesita_reinicio then
        gg.alert("Se requiere reinicio del sistema. Reiniciando...")
        gg.command("su -c reboot")
        return false 
    end
    
    return true 
end


local function verificar_hosts()
    local contenido_hosts = gg.command("su -c 'cat /data/adb/modules/.hosts/system/etc/hosts 2>/dev/null'")
    if contenido_hosts then
        
        local ips_encontradas = 0
        if string.find(contenido_hosts, "gin%.freefiremobile%.com") then ips_encontradas = ips_encontradas + 1 end
        if string.find(contenido_hosts, "gin%.freefireind%.in") then ips_encontradas = ips_encontradas + 1 end
        if string.find(contenido_hosts, "dl%.castle%.freefiremobile%.com") then ips_encontradas = ips_encontradas + 1 end
        if string.find(contenido_hosts, nueva_ip) then ips_encontradas = ips_encontradas + 1 end
        
        return ips_encontradas >= 3 
    end
    return false
end



local hosts_configurado = configurar_hosts()
if not hosts_configurado then
    return
end


gg.command("su -c 'sysctl -w net.ipv4.ip_forward=1'")


local configuracion_exitosa = false

if probar_iptables() then

    configuracion_exitosa = usar_iptables()
end

if not configuracion_exitosa then

    configuracion_exitosa = usar_nftables()
end

local hosts_verificado = verificar_hosts()

if configuracion_exitosa and hosts_verificado then
    
   

    gg.toast("BYPASS ACTIVATE")
else

    gg.toast("BYPASS FAIL")
    os.exit()
end
