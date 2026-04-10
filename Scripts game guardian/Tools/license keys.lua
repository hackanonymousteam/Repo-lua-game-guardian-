function decodeBase64(str64)
    local b64chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    local temp = {}
    for i = 1, 64 do
        temp[string.sub(b64chars, i, i)] = i
    end
    temp['='] = 0
    
    local result = ""
    for i = 1, #str64, 4 do
        if i > #str64 then break end
        
        local data = 0
        local charCount = 0
        
        for j = 0, 3 do
            local char = string.sub(str64, i + j, i + j)
            if not temp[char] then return nil end
            
            if temp[char] < 1 then
                data = data * 64
            else
                data = data * 64 + temp[char] - 1
                charCount = charCount + 1
            end
        end
        
        for j = 16, 0, -8 do
            if charCount > 0 then
                result = result .. string.char(math.floor(data / math.pow(2, j)))
                data = math.fmod(data, math.pow(2, j))
                charCount = charCount - 1
            end
        end
    end
    
    local last = tonumber(string.byte(result, #result, #result))
    if last == 0 then
        result = string.sub(result, 1, #result - 1)
    end
    
    return result
end

local machineId = math.random(2685355, 99999999)

local primaryFile = '/storage/emulated/0/.78293295_1'
local backupFile = '/storage/emulated/0/Android/.78293295_int'
local licenseFile = '/storage/emulated/0/Android/.78293295_1_dll'
local verificationFile = '/storage/emulated/0/.78293295_2'

local function initializeMachineId()
    local file = io.open(primaryFile, 'r')
    
    if file == nil then
        -- First run - create files
        file = io.open(backupFile, 'w')
        file:write(machineId * 6 - 967)
        file:close()
        
        file = io.open(primaryFile, 'w')
        file:write(machineId * 6 - 967)
        file:close()
    else
        file:close()
        
        file = io.open(backupFile, 'w')
        if file == nil then
            file = io.open(primaryFile, 'r')
            local content = file:read('*a')
            file:close()
            
            file = io.open(backupFile, 'w')
            file:write(content)
            file:close()
        else
            file:close()
        end
        
        file = io.open(backupFile, 'r')
        local backupContent = file:read('*a')
        file:close()
        
        file = io.open(primaryFile, 'r')
        local primaryContent = file:read('*a')
        file:close()
        
        if backupContent ~= primaryContent then
            file = io.open(backupFile, 'w')
            file:write(primaryContent)
            file:close()
        end
    end
    
    file = io.open(backupFile, 'r')
    local storedId = file:read('*a')
    file:close()
    
    return (tonumber(storedId) + 967) / 6
end

local actualMachineId = initializeMachineId()

local function checkLicense()
    local file = io.open(licenseFile, 'r')
    
    if file == nil then
        -- Auto-generate a 30-day license
        local baseKey = 521095  -- decoded from "NTIxMDk1"
        local licenseNumber = (30 * actualMachineId + baseKey)
        
        local expirationTime = (os.time() + 30 * 24 * 60 * 60) * actualMachineId + actualMachineId
        local verificationCode = 100000000 - (expirationTime - actualMachineId)
        
    
        file = io.open(licenseFile, 'w')
        file:write(tostring(expirationTime))
        file:close()
        
        file = io.open(verificationFile, 'w')
        file:write(tostring(verificationCode))
        file:close()
        
        gg.alert('30-day trial license activated automatically. Thank you!', 'OK')
    else
        
        file:close()
        
        local verificationFile = io.open(verificationFile, 'r')
        if not verificationFile then
            cleanupFiles()
            os.exit()
        end
        
        local verificationCode = verificationFile:read('*a')
        verificationFile:close()
        
        local licenseFile = io.open(licenseFile, 'r')
        local licenseContent = licenseFile:read('*a')
        licenseFile:close()
        
        local calculatedValue = tonumber(licenseContent) - actualMachineId + tonumber(verificationCode)
        if calculatedValue ~= 100000000 then
            cleanupFiles()
            print("License files tampered with")
            os.exit()
        end
        
     
        local expirationTime = (tonumber(licenseContent) - actualMachineId) / actualMachineId
        local currentTime = os.time()
        
        if expirationTime > currentTime then
            local remaining = expirationTime - currentTime
            local days = math.floor(remaining / 86400)
            remaining = remaining % 86400
            local hours = math.floor(remaining / 3600)
            remaining = remaining % 3600
            local minutes = math.floor(remaining / 60)
            local seconds = math.floor(remaining % 60)
            
            gg.alert(string.format(
                "License active. Remaining time: %d days, %d hours, %d minutes, %d seconds",
                days, hours, minutes, seconds
            ))
        else
            gg.alert('Your trial period has ended.')
            cleanupFiles()
            os.exit()
        end
    end
end

local function cleanupFiles()
    os.remove(verificationFile)
    os.remove(licenseFile)
    os.remove(primaryFile)
    os.remove(backupFile)
end

checkLicense()