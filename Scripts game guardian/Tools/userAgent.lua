function generateUserAgent()
  local platforms = {
    "android",
    "iphone",
    "windows",
    "mac"
  }

  local browsers = {
    chrome = function(os)
      if os == "android" then
        return "Mozilla/5.0 (Linux; Android 14; SM-G991B) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.6478.114 Mobile Safari/537.36"
      elseif os == "iphone" then
        return "Mozilla/5.0 (iPhone; CPU iPhone OS 17_5_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/126.0.6478.114 Mobile/15E148 Safari/605.1.15"
      elseif os == "windows" then
        return "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.6478.114 Safari/537.36"
      elseif os == "mac" then
        return "Mozilla/5.0 (Macintosh; Intel Mac OS X 14_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.6478.114 Safari/537.36"
      end
    end,

    firefox = function(os)
      local rv = "127.0"
      if os == "android" then
        return "Mozilla/5.0 (Android 14; Mobile; rv:"..rv..") Gecko/"..rv.." Firefox/"..rv
      elseif os == "iphone" then
        return "Mozilla/5.0 (iPhone; CPU iPhone OS 17_5_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) FxiOS/"..rv.." Mobile/15E148 Safari/605.1.15"
      elseif os == "windows" then
        return "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:"..rv..") Gecko/20100101 Firefox/"..rv
      elseif os == "mac" then
        return "Mozilla/5.0 (Macintosh; Intel Mac OS X 14_5; rv:"..rv..") Gecko/20100101 Firefox/"..rv
      end
    end,

    safari = function(os)
      if os == "iphone" then
        return "Mozilla/5.0 (iPhone; CPU iPhone OS 17_5_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4.1 Mobile/15E148 Safari/605.1.15"
      elseif os == "mac" then
        return "Mozilla/5.0 (Macintosh; Intel Mac OS X 14_5) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4.1 Safari/605.1.15"
      end
    end,

    edge = function(os)
      if os == "android" then
        return "Mozilla/5.0 (Linux; Android 14; Pixel 6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.6478.114 Mobile Safari/537.36 EdgA/126.0.2592.86"
      elseif os == "iphone" then
        return "Mozilla/5.0 (iPhone; CPU iPhone OS 17_5_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) EdgiOS/126.0.2592.86 Mobile/15E148 Safari/605.1.15"
      elseif os == "windows" then
        return "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.6478.114 Safari/537.36 Edg/126.0.2592.86"
      end
    end
  }

  local function pick(tbl)
    return tbl[math.random(1, #tbl)]
  end

  local os = pick(platforms)
  local keys = {}
  for k in pairs(browsers) do table.insert(keys, k) end
  local nav = pick(keys)

  local result = browsers[nav](os)

  return result or generateUserAgent() -- fallback
end

math.randomseed(os.time())

-- Table User-Agents
local userAgents = {
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:109.0) Gecko/20100101 Firefox/127.0",
    "Mozilla/5.0 (X11; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/127.0",
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 14_5) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4.1 Safari/605.1.15",
    "Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; rv:11.0) like Gecko",
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/64.0.3282.140 Safari/537.36 Edge/18.17763",
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.6478.114 Safari/537.36",
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:109.0) Gecko/20100101 Firefox/115.0",
    "Mozilla/5.0 (Android 14; Mobile; rv:109.0) Gecko/127.0 Firefox/127.0",
    "Mozilla/5.0 (Linux; Android 14; Z832 Build/MMB29M) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.6478.114 Mobile Safari/537.36",
    "Mozilla/5.0 (Android 14; Tablet; rv:109.0) Gecko/127.0 Firefox/127.0",
    "Mozilla/5.0 (Linux; Android 14; SAMSUNG-SM-T377A Build/NMF26X) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.6478.114 Mobile Safari/537.36",
    "Mozilla/5.0 (iPhone; CPU OS 17_5_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4.1 Mobile/14E304 Safari/605.1.15",
    "Mozilla/5.0 (iPad; CPU OS 17_5_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4.1 Mobile/15E148 Safari/605.1.15",
    "Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)",
    "Twitterbot/1.0",
    "facebookexternalhit/1.1 (+http://www.facebook.com/externalhit_uatext.php)",
    "Mozilla/5.0 (PlayStation; PlayStation 5/6.50) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.4 Safari/605.1.15",
    "curl/8.8.0",
    "Wget/1.24.5 (linux-gnu)",
    "Mozilla/5.0 (Linux; Android 10; HD1913) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.6478.186 Mobile Safari/537.36 EdgA/126.0.2592.86",
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64)",
    "Mozilla/5.0 (Linux; Android 10; Mobile)",
    "Mozilla/5.0 (iPhone; CPU iPhone OS 13_5 like Mac OS X)",
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)",
    "Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; rv:11.0) like Gecko",
"Android/5.1; Bermi/1.40.1; Manufacturer/OPPO; Model/A1603; Gaoiscoolman",
"Android Phone / Chrome 62 [Mobile]: Mozilla/5.0 (Linux; Android 7.0; SM-G935P Build/NRD90M) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202 Mobile Safari/537.36",
"Android Phone / Chrome 60 [Mobile]: Mozilla/5.0 (Linux; Android 7.0; SM-G935P Build/NRD90M) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/60.0.3112.78 Mobile Safari/537.36",
"Android Phone / Chrome 67 [Mobile]: Mozilla/5.0 (Linux; Android 9; Pixel 2 XL Build/PPP3.180510.008; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/67.0.3396.87 Mobile",
"Android Phone / Chrome 65 [Mobile]: Mozilla/5.0 (Linux; Android 7.0; SM-G935P Build/NRD90M) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Mobile Safari/537.36",
"Android Phone / Chrome 59 [Mobile]: Mozilla/5.0 (Linux; Android 7.0; SM-G935P Build/NRD90M) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/59.0.3071.92 Mobile Safari/537.36",
"Android Phone / Chrome 51 [Mobile]: Mozilla/5.0 (Linux; Android 6.0.1; SM-G935P Build/MMB29M; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/51.0.2704.81 Mobile Safari/537.36",
"Android Phone / Chrome 55 [Mobile]: Mozilla/5.0 (Linux; Android 6.0.1; SM-G935P Build/MMB29M; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/55.0.2883.91 Mobile Safari/537.36",
"Android Phone / Chrome 58 [Mobile]: Mozilla/5.0 (Linux; Android 6.0.1; SM-G935P Build/MMB29M) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.83 Mobile Safari/537.36",
"Android Phone / Chrome 67 [Mobile]: Mozilla/5.0 (Linux; Android 9; Pixel 2 XL Build/PPP3.180510.008; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/67.0.3396.87 Mobile",
"Android Phone / Chrome 67 [Mobile]: Mozilla/5.0 (Linux; Android 9; Pixel 2 XL Build/PPP3.180510.008; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/67.0.3396.87 Mobile",
"Android Phone / Chrome 58 [Mobile]: Mozilla/5.0 (Linux; Android 7.0; SM-G935P Build/NRD90M; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/58.0.3029.83 Mobile Safari/537.36 [FB_IAB/FB4A;FBAV/134.0.0.25.91;]",
"Android Phone / Chrome 58 [Mobile]: Mozilla/5.0 (Linux; Android 6.0.1; SM-G935P Build/MMB29M; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/50.0.2661.86 Mobile Safari/537.36",
"Android Phone / Chrome 56 [Mobile]: Mozilla/5.0 (Linux; Android 7.0; SM-G935P Build/NRD90M; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/56.0.2924.87 Mobile Safari/537.36 [FB_IAB/MESSENGER;FBAV/121.0.0.15.70;]",
"Android Phone / Chrome 62 [Mobile]: Mozilla/5.0 (Linux; Android 7.0; SM-G935P Build/NRD90M) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.73 Mobile Safari/537.36",
"Android Phone / Chrome 58 [Mobile]: Mozilla/5.0 (Linux; Android 8.0; Nexus 6P Build/OPP3.170518.006) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.121 Mobile Safari/537.36",
"Android Phone / Android Browser [Mobile]: Mozilla/5.0 (Linux; U; Android 8.1.0; zh-cn; Redmi Note 5 Build/OPM1.171019.011) AppleWebKit/533.1 (KHTML, like Gecko) Mobile Safari/533.1",
"Android Phone / Android Browser [Mobile]: Mozilla/5.0 (Linux; U; Android 8.1.0; zh-cn; CLT-AL01 Build/HUAWEICLT-AL01) AppleWebKit/533.1 (KHTML, like Gecko) Mobile Safari/533.1",
"Android Phone / Chrome 58 [Mobile]: Mozilla/5.0 (Linux; Android 8.0.0; Pixel XL Build/OPP3.170518.006) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/59.0.3071.125 Mobile Safari/537.36",
"Android Phone / Android Browser [Mobile]: Mozilla/5.0 (Linux; U; Android 8.1.0; zh-cn; ONEPLUS A5010 Build/OPM1.171019.011) AppleWebKit/533.1 (KHTML, like Gecko) Mobile Safari/533.1",
"Android Phone / Chrome 64 [Mobile]: Mozilla/5.0 (Linux; Android 8.0.0; SM-G960F Build/R16NW) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/64.0.3282.137 Mobile Safari/537.36",
"Android Phone / Chrome 60 [Mobile]: Mozilla/5.0 (Linux; Android 8.0.0; Pixel Build/OPP3.170518.006) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/60.0.3112.66 Mobile Safari/537.36",
"Android Phone / Android Browser [Mobile]: Mozilla/5.0 (Linux; U; Android 8.1.0; zh-cn; vivo X21A Build/OPM1.171019.011) AppleWebKit/533.1 (KHTML, like Gecko) Mobile Safari/533.1",
"Android Phone / Chrome 67 [Mobile]: Mozilla/5.0 (Linux; Android 9; Pixel 2 XL Build/PPP3.180510.008; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/67.0.3396.87 Mobile Safari/537.36",
"Android Phone / Chrome 62 [Mobile]: Mozilla/5.0 (Linux; Android 8.0.0; Nexus 6P Build/OPR5.170623.011) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.84 Mobile Safari/537.36",
"Android Phone / Chrome 67 [Mobile]: Mozilla/5.0 (Linux; Android 9; Pixel 2 XL Build/PPP3.180510.008; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/67.0.3396.87 Mobile",
"Android Phone / Chrome 63 [Mobile]: Mozilla/5.0 (Linux; Android 9.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3237.0 Mobile Safari/537.36",
"Android Phone / Chrome 63 [Mobile]: Mozilla/5.0 (Linux; Android 8.0.0; Nexus 6P Build/OPR5.170623.007) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/61.0.3163.98 Mobile Safari/537.36",
"Android Phone / Chrome 62 [Mobile]: Mozilla/5.0 (Linux; Android 9.0.0; Pixel XL Build/OPP3.170518.006) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.0 Mobile Safari/537.36",
"Android Phone / Chrome 62 [Mobile]: Mozilla/5.0 (Linux; Android 8.0.0; SM-G965F Build/R16NW) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.109 Mobile Safari/537.36",
"Android Phone / Chrome 62 [Mobile]: Mozilla/5.0 (Linux; Android 8.1.99; Build/PPP2.180412.013) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/67.0.3396.87 Mobile Safari/537.36",
"Android Phone / Android Browser [Mobile]: Mozilla/5.0 (Linux; Android 8.0.0; SM-A520F Build/R16NW) AppleWebKit/537.36 (KHTML, like Geck",
"Android Phone / Chrome 61 [Mobile]: Mozilla/5.0 (Linux; Android 7.0; SM-G935P Build/NRD90M) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/61.0.3163.81 Mobile Safari/537.36",
"Android Phone / Chrome 61 [Mobile]: Mozilla/5.0 (Linux; Android 7.0; SM-G935P Build/NRD90M; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/65.0.3325.109 Mobile Safari/537.36",
"Android Phone / Chrome 44 [Mobile]: Mozilla/5.0 (Linux; Android 7.0; SM-G935P Build/NRD90M; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/44.0.2403.119 Mobile Safari/537.36 ACHEETAHI/1",
"Android Phone / Chrome 55 [Mobile]: Mozilla/5.0 (Linux; Android 7.0; SM-G935P Build/NRD90M; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/55.0.2883.91 Mobile Safari/537.36 Liebao",
"Android Phone / Orca [Mobile]: Mozilla/5.0 (Linux; Android 7.0; SM-G935P Build/NRD90M; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/62.0.3202.84 Mobile Safari/537.36 [FB_IAB/Orca-Android;FBAV/144.0.0.22.136;]",
"Android Phone / Chrome 48 [Mobile]: Mozilla/5.0 (Linux; Android 6.0.1; SM-G935P Build/MMB29M; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/48.0.2564.106 Mobile Safari/537.36",
"Android Phone / Chrome 61 [Mobile]: Mozilla/5.0 (Linux; Android 7.0; SM-G935P Build/NRD90M; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/61.0.3163.98 Mobile Safari/537.36 [FB_IAB/MESSENGER;FBAV/140.0.0.43.91;]",
"Android Phone / Chrome 61 [Mobile]: Mozilla/5.0 (Linux; Android 6.0.1; SM-G935P Build/MMB29M; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/54.0.2840.85 Mobile Safari/537.36 Mobile/1 EtsyInc/4.56.0 Android/1",
"Android Phone / Chrome 61 [Mobile]: Mozilla/5.0 (Linux; Android 7.0; SM-G935P Build/NRD90M; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/57.0.2987.132 Mobile Safari/537.36",
"Android Phone / Chrome 64 [Mobile]: Mozilla/5.0 (Linux; Android 7.0; SM-G935P Build/NRD90M) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/64.0.3282.186 Mobile Safari/537.36",
"Android Phone / Chrome 62 [Mobile]: Mozilla/5.0 (Linux; Android 7.0; SM-G935P Build/NRD90M; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/62.0.3202.84 Mobile Safari/537.36",
"Android Phone / Chrome 66 [Mobile]: Mozilla/5.0 (Linux; Android 8.1; SM-G935P Build/NRD90M) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.158 Mobile Safari/537.36",
"Android Phone / Chrome 63 [Mobile]: Mozilla/5.0 (Linux; Android 7.0; SM-G935P Build/NRD90M; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/63.0.3239.111 Mobile Safari/537.36~Real Appeal-8.0.0",
"Android Phone / Chrome 66 [Mobile]: Mozilla/5.0 (Linux; Android 8.1; SM-G935P Build/NRD90M) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.106 Mobile Safari/537.36",
"Android Phone / Opera 37.8 [Mobile]: Mozilla/5.0 (Linux; Android 6.0.1; SM-G935P Build/MMB29M) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.94 Mobile Safari/537.36 OPR/37.8.2192.106015",
"Android Phone / Chrome 64 [Mobile]: Mozilla/5.0 (Linux; Android 7.0; SM-G935P Build/NRD90M) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/64 Mobile Safari/537.36",
"Android Phone / Chrome 61 [Mobile]: Mozilla/5.0 (Linux; Android 7.0; SM-G935P Build/NRD90M; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/61.0.3163.98 Mobile Safari/537.36",
"Android Phone / Chrome 64 [Mobile]: Mozilla/5.0 (Linux; Android 8.0; SM-G935P Build/NRD90M) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/64 Mobile Safari/537.36",
"Android Phone / Firefox 58 [Mobile]: Mozilla/5.0 (Linux; Android 8.0; SM-G935P Build/NRD90M) Gecko/20100101 Firefox/58.0.1",
"Android Phone / Chrome 64 [Mobile]: Mozilla/5.0 (Linux; Android 7.0; SM-G935P Build/NRD90M) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/59.0.3071.92 Mobile Safari/537.36",
"Android Phone / Samsung Browser 5.4 [Mobile]: Mozilla/5.0 (Linux; Android 7.0; SAMSUNG SM-G935P Build/NRD90M) AppleWebKit/537.36 (KHTML, like Gecko) SamsungBrowser/5.4 Chrome/51.0.2704.106 Mobile Safari/537.36",
"Android Phone / Samsung Browser 6.2 [Mobile]: Mozilla/5.0 (Linux; Android 7.0; SAMSUNG SM-G935P Build/NRD90M) AppleWebKit/537.36 (KHTML, like Gecko) SamsungBrowser/6.2 Chrome/56.0.2924.87 Mobile Safari/537.36",
"Android Phone / Samsung Browser 5 [Mobile]: Mozilla/5.0 (Linux; Android 7.0; SAMSUNG SM-G935P Build/NRD90M) AppleWebKit/537.36 (KHTML, like Gecko) SamsungBrowser/5.0 Chrome/51.0.2704.106 Mobile Safari/537.36",
"Android Phone / Samsung Browser 6.4 [Mobile]: Mozilla/5.0 (Linux; Android 7.0; SAMSUNG SM-G935P Build/NRD90M) AppleWebKit/537.36 (KHTML, like Gecko) SamsungBrowser/6.4 Chrome/56.0.2924.87 Mobile Safari/537.36",
"Android Phone / Chrome 61 [Mobile]: Mozilla/5.0 (Linux; Android 7.0; SM-G935P Build/NRD90M) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/61.0.3163.98 Mobile Safari/537.36",
"Android Phone / Chrome 61 [Mobile]: Mozilla/5.0 (Linux; Android 7.0; SM-G935P Build/NRD90M) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.158 Mobile Safari/537.36",
"Android Phone / Chrome 62 [Mobile]: Mozilla/5.0 (Linux; Android 7.0; SM-G935P Build/NRD90M) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.84 Mobile Safari/537.36",
"Android Phone / Chrome 64 [Mobile]: Mozilla/5.0 (Linux; Android 7.0; SM-G935P Build/NRD90M) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/64.0.3282.137 Mobile Safari/537.36",
"Android Phone / Chrome 59 [Mobile]: Mozilla/5.0 (Linux; Android 8.1; SM-G935P Build/NRD90M) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/59.0.3071.92 Mobile Safari/537.36",
"Android Phone / Chrome 67 [Mobile]: Mozilla/5.0 (Linux; Android 8.1.99; Qualcore 1030 4G Build/LMY47D) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/67.0.3396.81 Safari/537.36",
"Android Phone / Chrome 66 [Mobile]: Mozilla/5.0 (Linux; Android 8.1.99; BQS_4504_Nice Build/LMY47I) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.126 Mobile Safari/537.36",
"Android Phone / Chrome 64 [[Mobile]: Mozilla/5.0 (Linux; Android 8.1.99; Huawei Y301A1 Build/HuaweiY301A1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/64.0.3282.137 Mobile Safari/537.36",
"Android Phone / Chrome 68 [Mobile]: Mozilla/5.0 (Linux; Android 8.1.99; Build/PPP2.180412.013) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/68.0.3434.0 Mobile Safari/537.36",
"Android Phone / Internet Explorer [Mobile]: Mozilla/5.0 (Mobile; Windows Phone 8.1; Android 4.0; ARM; Trident/7.0; Touch; rv:11.0; IEMobile/11.0; NOKIA; Lumia 625) like iPhone OS 7_0_3 Mac OS X AppleWebKit/537 (KHTML, like Gecko) Mobile Safari/",
"Android Phone / Chrome 66 [Mobile]: Mozilla/5. (Android 8.) AppleWebKit/538 Chrome/66",
"Android Phone / UC Browser 10.9 [Mobile]: Mozilla/5.0 (Linux; U; Android 8.0.2; en-US; REMI GAPLE V6 Build/GETUK_OS) AppleWebKit/534.30 (KHTML, like Gecko) Version/4.0 UCBrowser/10.9.0.731 U3/0.8.0 Mobile Safari/534.30",
"Android Phone / UC Browser 10.9 [Mobile]: Mozilla/5.0 (Linux; U; Android 8.0.2; en-US; Lenovo A536 Build/KOT49H) AppleWebKit/534.30 (KHTML, like Gecko) Version/4.0 UCBrowser/10.9.0.731 U3/0.8.0 Mobile Safari/534.30",
"Android Phone / Firefox 62 [Mobile]: Mozilla/5.0 (Android 8.1.1; Mobile; rv:62.0) Gecko/62.0 Firefox/62.0",
"Android Phone / Chrome 68 [Mobile]: Mozilla/5.0 (Linux; Android 8.1.1; SM-J700M Build/NRD90M) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/68.0.3440.8 Mobile Safari/537.36",
"Android Phone / Chrome 66 [Mobile]: Mozilla/5.0 (Linux; Android 8.1.1; Nexus 5 Build/M4B30Z) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.158 Mobile Safari/537.36",
"Android Phone / Firefox 62 [Mobile]: Mozilla/5.0 (Android 8.1.1; Mobile; rv:60.0.1) Gecko/60.0 Firefox/60.0.1",
"Android Phone / Chrome 67 [Mobile]: Mozilla/5.0 (Linux; Android 9; Pixel 2 XL Build/PPP4.180612.004; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/67.0.3396.87 Mobile Safari/537.36",
"Android Phone / Chrome 67 [Mobile]: Mozilla/5.0 (Linux; Android 9) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Focus/5.2 Chrome/67.0.3396.87 Mobile Safari/537.36",
"Android Phone / Chrome 61 [Mobile]: Mozilla/5.0 (Linux; Android 12.5; Marvel Xcore7 Build/LMY47I; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/61.0.3163.98 Mobile Safari/537.36",
"Android Phone / Chrome 61 [Mobile]: com.zhihu.android/Futureve/5.19.1 Mozilla/5.0 (Linux; Android 8.0.0; MHA-AL00 Build/HUAWEIMHA-AL00; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/61.0.3163.98 Mobile Safari/537.36",
"Apple iPhone / Safari 11 [Mobile]: Mozilla/5.0 (iPhone; CPU iPhone OS 11_2_5 like Mac OS X) AppleWebKit/604.5.6 (KHTML, like Gecko) Version/11.0 Mobile/15D60 Safari/604.1Android Phone / Chrome 62 [Android 7.0]: Mozilla/5.0 (Linux; Android 7.0; SM-G935P Build/NRD90M) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202 Mobile Safari/537.36",
"Android Phone / Chrome 60 [Mobile]: Mozilla/5.0 (Linux; Android 7.0; SM-G935P Build/NRD90M) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/60.0.3112.78 Mobile Safari/537.36",
"Android Phone / Chrome 67 [Mobile]: Mozilla/5.0 (Linux; Android 9; Pixel 2 XL Build/PPP3.180510.008; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/67.0.3396.87 Mobile",
"Android Phone / Chrome 65 [Mobile]: Mozilla/5.0 (Linux; Android 7.0; SM-G935P Build/NRD90M) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Mobile Safari/537.36",
"Android Phone / Chrome 59 [Mobile]: Mozilla/5.0 (Linux; Android 7.0; SM-G935P Build/NRD90M) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/59.0.3071.92 Mobile Safari/537.36",
"Android Phone / Chrome 51 [Mobile]: Mozilla/5.0 (Linux; Android 6.0.1; SM-G935P Build/MMB29M; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/51.0.2704.81 Mobile Safari/537.36",
"Android Phone / Chrome 55 [Mobile]: Mozilla/5.0 (Linux; Android 6.0.1; SM-G935P Build/MMB29M; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/55.0.2883.91 Mobile Safari/537.36",
"Android Phone / Chrome 58 [Mobile]: Mozilla/5.0 (Linux; Android 6.0.1; SM-G935P Build/MMB29M) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.83 Mobile Safari/537.36",
"Android Phone / Chrome 67 [Mobile]: Mozilla/5.0 (Linux; Android 9; Pixel 2 XL Build/PPP3.180510.008; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/67.0.3396.87 Mobile",
"Android Phone / Chrome 67 [Mobile]: Mozilla/5.0 (Linux; Android 9; Pixel 2 XL Build/PPP3.180510.008; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/67.0.3396.87 Mobile",
"Android Phone / Chrome 58 [Mobile]: Mozilla/5.0 (Linux; Android 7.0; SM-G935P Build/NRD90M; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/58.0.3029.83 Mobile Safari/537.36 [FB_IAB/FB4A;FBAV/134.0.0.25.91;]",
"Android Phone / Chrome 58 [Mobile]: Mozilla/5.0 (Linux; Android 6.0.1; SM-G935P Build/MMB29M; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/50.0.2661.86 Mobile Safari/537.36",
"Android Phone / Chrome 56 [Mobile]: Mozilla/5.0 (Linux; Android 7.0; SM-G935P Build/NRD90M; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/56.0.2924.87 Mobile Safari/537.36 [FB_IAB/MESSENGER;FBAV/121.0.0.15.70;]",
"Android Phone / Chrome 62 [Mobile]: Mozilla/5.0 (Linux; Android 7.0; SM-G935P Build/NRD90M) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.73 Mobile Safari/537.36",
"Android Phone / Chrome 58 [Mobile]: Mozilla/5.0 (Linux; Android 8.0; Nexus 6P Build/OPP3.170518.006) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.121 Mobile Safari/537.36",
"Android Phone / Android Browser [Mobile]: Mozilla/5.0 (Linux; U; Android 8.1.0; zh-cn; Redmi Note 5 Build/OPM1.171019.011) AppleWebKit/533.1 (KHTML, like Gecko) Mobile Safari/533.1",
"Android Phone / Android Browser [Mobile]: Mozilla/5.0 (Linux; U; Android 8.1.0; zh-cn; CLT-AL01 Build/HUAWEICLT-AL01) AppleWebKit/533.1 (KHTML, like Gecko) Mobile Safari/533.1",
"Android Phone / Chrome 58 [Mobile]: Mozilla/5.0 (Linux; Android 8.0.0; Pixel XL Build/OPP3.170518.006) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/59.0.3071.125 Mobile Safari/537.36",
"Android Phone / Android Browser [Mobile]: Mozilla/5.0 (Linux; U; Android 8.1.0; zh-cn; ONEPLUS A5010 Build/OPM1.171019.011) AppleWebKit/533.1 (KHTML, like Gecko) Mobile Safari/533.1",
"Android Phone / Chrome 64 [Mobile]: Mozilla/5.0 (Linux; Android 8.0.0; SM-G960F Build/R16NW) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/64.0.3282.137 Mobile Safari/537.36",
"Android Phone / Chrome 60 [Mobile]: Mozilla/5.0 (Linux; Android 8.0.0; Pixel Build/OPP3.170518.006) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/60.0.3112.66 Mobile Safari/537.36",
"Android Phone / Android Browser [Mobile]: Mozilla/5.0 (Linux; U; Android 8.1.0; zh-cn; vivo X21A Build/OPM1.171019.011) AppleWebKit/533.1 (KHTML, like Gecko) Mobile Safari/533.1",
"Android Phone / Chrome 67 [Mobile]: Mozilla/5.0 (Linux; Android 9; Pixel 2 XL Build/PPP3.180510.008; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/67.0.3396.87 Mobile Safari/537.36",
"Android Phone / Chrome 62 [Mobile]: Mozilla/5.0 (Linux; Android 8.0.0; Nexus 6P Build/OPR5.170623.011) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.84 Mobile Safari/537.36"
}

local function getRandomUserAgent()
    local index = math.random(1, #userAgents)
    return userAgents[index]
end

local url = "https://httpbin.org/user-agent"

local headers = {
--    ["User-Agent"] = getRandomUserAgent()
--    or
    ["User-Agent"] = generateUserAgent()
    
}

local response = gg.makeRequest(url, headers)

if type(response) ~= "table" or response.content == nil then
    print("Error please check internet connection.")
    return
end

gg.setVisible(true)

print(response.content)