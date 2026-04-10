function checkType(value)
    if value == math.floor(value) then
        return gg.TYPE_DWORD 
end 
end

function gg.searchNumberSmart(value)
    local flag = checkType(value)
    gg.searchNumber(value, flag)
end

function gg.editAllSmart(value)
    local results = gg.getResults(gg.getResultsCount())
    if #results == 0 then
        print("no found.")
        return
    end
    local detectedType = checkType(value)  
    for i, res in ipairs(results) do
        res.value = value  
        res.flags = detectedType  
    end
    gg.setValues(results)
    print("sucess.")
end

-- Example usage:

gg.searchNumberSmart(8)  
gg.editAllSmart(65)    