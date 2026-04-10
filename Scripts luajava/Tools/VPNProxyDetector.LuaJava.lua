function VPK()
  import "java.net.NetworkInterface"
  import "java.util.Collections"
  import "java.util.Enumeration"
  import "java.util.Iterator"
  import "java.lang.String"
  local niList = NetworkInterface.getNetworkInterfaces()
  if niList ~= nil then
    local it = Collections.list(niList).iterator()
    while it.hasNext() do
      local intf = it.next()
      if intf.isUp() and intf.getInterfaceAddresses().size() ~= 0 then
        local name = intf.getName()
        if String("tun0").equals(name) or String("ppp0").equals(name) then
          print("VPN detectada")
          os.exit()
        end
      end
    end
  end
end

function detectProxy()
  import "java.lang.System"
  import "java.lang.String"
  local httpHost = System.getProperty("http.proxyHost")
  local httpPort = System.getProperty("http.proxyPort")
  if httpHost ~= nil and httpHost ~= "" then
    print("Proxy detectado em " .. httpHost .. ":" .. (httpPort or ""))
    os.exit()
  end
end

function monitor()
  import "java.lang.Thread"
  while true do
    Thread.sleep(500)
    VPK()
    detectProxy()
  end
end

thread(monitor)