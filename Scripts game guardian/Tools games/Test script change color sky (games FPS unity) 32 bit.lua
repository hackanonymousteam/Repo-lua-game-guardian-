function colorm()
gg.alert("Please go to the match to activate this feature -_-")
     
    local sph = gg.prompt({
        "\n\nselect color sky [0;19]",
    }, {0}, {"number"})

    if sph == nil then
        return
    else
        local sphr = "2.25"
        
        local colorValues = {
            [0] = "100", [1] = "200", [2] = "300", [3] = "400", [4] = "500",
            [5] = "600", [6] = "700", [7] = "800", [8] = "900", [9] = "1000",
            [10] = "1500", [11] = "2000", [12] = "2500", [13] = "3000",
            [14] = "3500", [15] = "4000", [16] = "4500", [17] = "5000",
            [18] = "5500", [19] = "-100"
        }

        sphr = colorValues[tonumber(sph[1])] or sphr
gg.setVisible(false)
gg.setRanges(gg.REGION_C_ALLOC | gg.REGION_ANONYMOUS)
        gg.searchNumber("1.46939596e-39;2.25;-1.46945202e-39::9", gg.TYPE_FLOAT)
        local results = gg.getResults(1000)
        
        if #results == 0 then
        gg.setVisible(false)
gg.searchNumber("1.46953609e-39;2.25;-1.46945202e-39::9", gg.TYPE_FLOAT)
     results = gg.getResults(1000)
        end
        
        if #results == 0 then
        gg.setVisible(false)
         gg.searchNumber("1.46939596e-39;2.25::5", gg.TYPE_FLOAT)
        results = gg.getResults(1000)
        end
        
        if #results == 0 then
        gg.setVisible(false)
            gg.searchNumber("2.25;-1.46945202e-39::5", gg.TYPE_FLOAT)
            results = gg.getResults(1000)
            gg.editAll(sphr, gg.TYPE_FLOAT)
        end
        
        if #results == 0 then
        gg.setVisible(false)
gg.searchNumber("1.46953609e-39;2.25::9", gg.TYPE_FLOAT)
     results = gg.getResults(1000)
        end
        
        if #results == 0 then
        gg.setVisible(false)
            gg.searchNumber("2.25;-1.46945202e-39::5", gg.TYPE_FLOAT)
            results = gg.getResults(1000)
            gg.editAll(sphr, gg.TYPE_FLOAT)
        end

   if #results == 0 then
            gg.alert("THE VALUE WAS NOT FOUND OR HAS ALREADY BEEN CHANGED -_-")
            os.exit()
        else
            gg.editAll(sphr, gg.TYPE_FLOAT)
            gg.clearResults()
        end
    end
end

colorm()

--script  by @batmangamesS