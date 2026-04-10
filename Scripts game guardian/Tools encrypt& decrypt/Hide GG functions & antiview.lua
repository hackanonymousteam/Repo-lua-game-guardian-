local original_ggsetRanges = gg.setRanges
local original_searchNumber = gg.searchNumber
local original_ggrefineNumber = gg.refineNumber
local original_ggeditAll = gg.editAll
local original_gggetResults = gg.getResults
local original_ggclearResults = gg.clearResults
local original_ggtoast = gg.toast

function Batman0(...)
    if gg.setRanges ~= original_ggsetRanges then
        gg.alert("Modification detected.")
        os.exit()
    end
    return original_ggsetRanges(...)
end

function Batman1(...)
    if gg.searchNumber ~= original_searchNumber then
        gg.alert("Modification detected.")
        os.exit()
    end
    local ret = gg.searchNumber(...)
    if gg.isVisible() then
        gg.alert("Don't look at the values")
        gg.clearResults()
        while true do os.exit() end
    end
    return ret
end

function Batman2(...)
    if gg.refineNumber ~= original_ggrefineNumber then
        gg.alert("Modification detected.")
        os.exit()
    end
    local ret = gg.refineNumber(...)
    if gg.isVisible() then
        gg.alert("Don't look at the values")
        gg.clearResults()
        while true do os.exit() end
    end
    return ret
end

function Batman3(...)
    if gg.getResults ~= original_gggetResults then
        gg.alert("Modification detected.")
        os.exit()
    end
    return original_gggetResults(...)
end

function Batman4(...)
    if gg.editAll ~= original_ggeditAll then
        gg.alert("Modification detected.")
        os.exit()
    end
    local ret = gg.editAll(...)
    if gg.isVisible() then
        gg.alert("Don't look at the values")
        gg.clearResults()
        while true do os.exit() end
    end
    return ret
end

function Batman5(...)
    if gg.clearResults ~= original_ggclearResults then
        gg.alert("Modification detected.")
        os.exit()
    end
    return original_ggclearResults(...)
end

function Batman6(...)
    if gg.toast ~= original_ggtoast then
        gg.alert("Modification detected.")
        os.exit()
    end
    return original_ggtoast(...)
end

gg.setVisible(false)

-- example usage

function fov()
    Batman0(gg.REGION_CODE_APP)
    Batman1("-0.50344371796;9.99999997e-7;-0.50291442871::9", gg.TYPE_FLOAT)
    Batman2("9.99999997e-7", gg.TYPE_FLOAT)
    Batman3(100)
    Batman4("-1", gg.TYPE_FLOAT)
    Batman5()
    Batman6("✔ ON ✔")
end

-- start function fov

fov()