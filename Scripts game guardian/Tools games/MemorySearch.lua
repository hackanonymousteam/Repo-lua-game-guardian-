menu = gg.choice({'⚡ HACK'}, nil, 'MAKE BY Batman')
if menu == 1 then
    
    local function MemorySearch(value, valueType)
        gg.setVisible(false)
        gg.clearResults()
        gg.searchNumber(value, valueType)
        if gg.getResultCount() == 0 then
            gg.alert("Value not found!")
            return nil
        end
        gg.refineNumber(value, valueType)
        return {
            results = gg.getResults(999999),
            count = math.min(gg.getResultCount(), 999999)
        }
    end

    local function MemoryModify(searchResults, targetValue, offset, valueType, newValue)
        if not searchResults or searchResults.count == 0 then return end
        
        local modifiedAddresses = {}
        for i = 1, searchResults.count do
            local targetAddress = searchResults.results[i].address + offset
            table.insert(modifiedAddresses, {
                address = targetAddress,
                flags = valueType,
                value = newValue
            })
            

            if i % 10000 == 0 or i == searchResults.count then
                gg.setValues(modifiedAddresses)
                modifiedAddresses = {}
            end
        end
        gg.toast("Modification complete!")
    end

    -- Main execution
    gg.toast("Starting hack...")
    
 
    local searchResult = MemorySearch("1", gg.TYPE_FLOAT)
    if searchResult then

        MemoryModify(searchResult, "12", -0x4, gg.TYPE_FLOAT, "90")
        MemoryModify(searchResult, "10~7", -0x8, gg.TYPE_FLOAT, "90")
    end
    
    gg.clearResults()
    gg.toast(" hack applied successfully!")
end