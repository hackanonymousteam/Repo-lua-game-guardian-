gg.setVisible(true)

local apiKey = "YOUR_API_KEY"
local apiURL = "https://www.virustotal.com/vtapi/v2/file/report"

local json = nil
if not pcall(function()
    json = load(gg.makeRequest("https://raw.githubusercontent.com/rxi/json.lua/master/json.lua").content)()
end) then
    json = require("json")
    if not json then 
        gg.alert("JSON library not available")
        return 
    end
end

local LAST_CHECK = nil

local function checkHashVirusTotal(fileHash)
    gg.toast("Checking VirusTotal...")
    
    local params = "apikey=" .. apiKey .. "&resource=" .. fileHash
    local fullURL = apiURL .. "?" .. params
    
    local response = gg.makeRequest(
        fullURL,
        {"Content-Type: application/x-www-form-urlencoded"},
        ""
    )
    
    return response
end

local function analyzeVirusTotalResult(data)
    if not data then
        return "No data received from API"
    end
    
    local result = "VirusTotal Analysis Result\n\n"
    
    if data.response_code == 0 then
        return result .. "Hash not found in VirusTotal database\n\nHash: " .. (data.resource or "N/A")
    
    elseif data.response_code == 1 then
        result = result .. "Hash found in database\n\n"
        result = result .. "Hash: " .. (data.resource or "N/A") .. "\n"
        result = result .. "Scan Date: " .. (data.scan_date or "N/A") .. "\n"
        result = result .. "Positives: " .. (data.positives or 0) .. "/" .. (data.total or 0) .. "\n\n"
        
        local positives = data.positives or 0
        if positives == 0 then
            result = result .. "STATUS: CLEAN\n"
            result = result .. "No antivirus detected threats\n"
        elseif positives < 5 then
            result = result .. "STATUS: SUSPICIOUS\n"
            result = result .. "Few antivirus detected threats\n"
        else
            result = result .. "STATUS: MALICIOUS\n"
            result = result .. "Multiple antivirus detected threats\n"
        end
        
        if data.scans then
            result = result .. "\nDETECTIONS:\n"
            local detectionCount = 0
            for avName, scanResult in pairs(data.scans) do
                if scanResult.detected == true then
                    detectionCount = detectionCount + 1
                    if detectionCount <= 10 then
                        result = result .. "" .. avName .. ": " .. (scanResult.result or "Malware") .. "\n"
                    end
                end
            end
            if detectionCount > 10 then
                result = result .. "... and " .. (detectionCount - 10) .. " more detections\n"
            end
        end
        
        if data.sha1 then
            result = result .. "\nOTHER HASHES:\n"
            result = result .. "SHA1: " .. (data.sha1 or "N/A") .. "\n"
            if data.md5 then
                result = result .. "MD5: " .. (data.md5 or "N/A") .. "\n"
            end
        end
        
        return result
        
    else
        return result .. "API response error: Code " .. (data.response_code or "N/A")
    end
end

local function virusTotalMenu()
    while true do
        local options = {
            "Check SHA256 Hash",
            "Last Check Result",
            "About VirusTotal",
            "Exit"
        }
        
        local choice = gg.choice(options, nil, "VirusTotal Hash Checker")
        
        if choice == nil or choice == 4 then
            break
            
        elseif choice == 1 then
            local hashInput = gg.prompt({
                'Enter SHA256 hash:'
            }, {''}, {'text'})
            
            if hashInput and hashInput[1] and hashInput[1] ~= "" then
                local fileHash = hashInput[1]:gsub("%s+", ""):upper()
                
                if #fileHash ~= 64 or not string.match(fileHash, "^[A-F0-9]+$") then
                    gg.alert("Invalid SHA256 hash!\n\nMust be 64 characters\nOnly A-F and 0-9\n\nHash: " .. fileHash)
                else
                    local response = checkHashVirusTotal(fileHash)
                    
                    if type(response) == "table" and response.code == 200 then
                        local data = json.decode(response.content)
                        local analysis = analyzeVirusTotalResult(data)
                        gg.alert(analysis)
                        
                        LAST_CHECK = {
                            hash = fileHash,
                            data = data,
                            timestamp = os.date("%Y-%m-%d %H:%M:%S")
                        }
                        
                    else
                        local errorMsg = "Query error:\n"
                        if type(response) == "table" then
                            errorMsg = errorMsg .. "Code: " .. (response.code or "N/A") .. "\n"
                            if response.content then
                                errorMsg = errorMsg .. "Response: " .. response.content
                            end
                        else
                            errorMsg = errorMsg .. tostring(response)
                        end
                        gg.alert(errorMsg)
                    end
                end
            end
            
        elseif choice == 2 then
            if LAST_CHECK then
                local analysis = analyzeVirusTotalResult(LAST_CHECK.data)
                local lastCheckMsg = "Last Check\n" ..
                                   "Time: " .. LAST_CHECK.timestamp .. "\n" ..
                                   "Hash: " .. LAST_CHECK.hash .. "\n\n" ..
                                   analysis
                gg.alert(lastCheckMsg)
            else
                gg.alert("No checks performed yet.\nUse 'Check SHA256 Hash' first.")
            end
            
        elseif choice == 3 then
            gg.alert("VirusTotal Hash Checker\n\nVirusTotal analyzes suspicious files and URLs for malware detection.\n\nFeatures:\nCheck SHA256 file hashes\nQuery multiple antivirus engines\nAnalyze file reputation\nDetect known malware")
        end
    end
end

local function quickHashCheck()
    local hashInput = gg.prompt({
        'Paste SHA256 hash for quick check:'
    }, {''}, {'text'})
    
    if hashInput and hashInput[1] and hashInput[1] ~= "" then
        local fileHash = hashInput[1]:gsub("%s+", ""):upper()
        
        if #fileHash == 64 and string.match(fileHash, "^[A-F0-9]+$") then
            gg.toast("Querying VirusTotal...")
            local response = checkHashVirusTotal(fileHash)
            
            if type(response) == "table" and response.code == 200 then
                local data = json.decode(response.content)
                local analysis = analyzeVirusTotalResult(data)
                gg.alert(analysis)
            else
                gg.alert("Error querying VirusTotal")
            end
        else
            gg.alert("Invalid SHA256 hash!")
        end
    end
end

local startChoice = gg.choice({
    "VirusTotal Menu",
    "Quick Check",
    "Exit"
}, nil, "VirusTotal Hash Checker")

if startChoice == 1 then
    virusTotalMenu()
elseif startChoice == 2 then
    quickHashCheck()
end