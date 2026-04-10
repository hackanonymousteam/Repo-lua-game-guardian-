function listRanges()
    local ranges = gg.getRangesList()
    if #ranges == 0 then
        gg.alert("No ranges available, please enter the game.")
        os.exit()
    else
        local totalBytes = 0
        print("\n")
        print("RANGES MEMORY AND SIZE:")
        print("\n")

        for _, range in pairs(ranges) do
            if range.state == "Xa" then
                local startAddress = range.start
                local endAddress = range["end"]
                local regionSize = endAddress - startAddress
                local regionMB = regionSize / 1024 / 1024

                print("lib:", range.internalName or range.name,
                   "- size:", string.format("%.2f", regionMB), "MB\n")

                totalBytes = totalBytes + regionSize  
            end
        end
        local totalKB = totalBytes / 1024
        local totalMB = totalKB / 1024

        print("\nSize all regions :")
        
        print("bytes:", totalBytes, "bytes")
        print("KB:", string.format("%.2f", totalKB), "KB")
        print("MB:", string.format("%.2f", totalMB), "MB")
    end
end

listRanges()