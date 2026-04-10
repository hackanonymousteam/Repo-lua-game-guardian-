gg.clearResults()

local RANGE_LIST = {
    {"Jh", gg.REGION_JAVA_HEAP, "JAVA_HEAP"},
    {"Ch", gg.REGION_C_HEAP, "C_HEAP"},
    {"Ca", gg.REGION_C_ALLOC, "C_ALLOC"},
    {"Cd", gg.REGION_C_DATA, "C_DATA"},
    {"Cb", gg.REGION_C_BSS, "C_BSS"},
    {"A", gg.REGION_ANONYMOUS, "ANONYMOUS"},
    {"J", gg.REGION_JAVA, "JAVA"},
    {"S", gg.REGION_STACK, "STACK"},
    {"As", gg.REGION_ASHMEM, "ASHMEM"},
    {"Xa", gg.REGION_CODE_APP, "CODE_APP"},
    {"Xs", gg.REGION_CODE_SYS, "CODE_SYS"}
}

local DEX_HEADERS = {
    {version = "035", pattern = "64 65 78 0A 30 33 35 00"},
    {version = "037", pattern = "64 65 78 0A 30 33 37 00"},
    {version = "038", pattern = "64 65 78 0A 30 33 38 00"},
    {version = "039", pattern = "64 65 78 0A 30 33 39 00"},
    {version = "040", pattern = "64 65 78 0A 30 34 30 00"}
}

local CONFIG = {
    MAX_DUMP_SIZE = 50 * 1024 * 1024,
    CHUNK_SIZE = 8192,
    SAVE_PATH = "/sdcard/dumpDex/"
}

function ensureDir()
    local f = io.open(CONFIG.SAVE_PATH .. "test", "w")
    if f then
        f:close()
        os.remove(CONFIG.SAVE_PATH .. "test")
        return true
    end
    return false
end

function readBytes(addr, size)
    local t = {}
    for i = 1, size do
        t[i] = {address = addr + i - 1, flags = gg.TYPE_BYTE}
    end

    local r = gg.getValues(t)
    if not r then return nil end

    local bytes = {}
    for i = 1, #r do
        local v = r[i].value
        if v < 0 then v = v + 256 end
        bytes[i] = v
    end
    return bytes
end

function bytesToString(bytes)
    local chars = {}
    for i = 1, #bytes do
        chars[i] = string.char(bytes[i])
    end
    return table.concat(chars)
end

function validateHeader(addr, pattern)
    local b = readBytes(addr, 8)
    if not b then return false end

    local i = 1
    for hex in pattern:gmatch("%x%x") do
        if b[i] ~= tonumber(hex, 16) then
            return false
        end
        i = i + 1
    end
    return true
end

function getDexSize(addr)
    local b = readBytes(addr + 0x20, 4)
    if not b then return 0 end

    local size = b[1] + b[2]*256 + b[3]*65536 + b[4]*16777216

    if size <= 0 or size > CONFIG.MAX_DUMP_SIZE then
        return 0
    end
    return size
end

function searchDex(ranges, headers)
    local foundDex = {}
    local map = {}

    for _, h in ipairs(headers) do
        gg.setRanges(ranges)
        gg.clearResults()
        gg.searchNumber("h " .. h.pattern, gg.TYPE_BYTE_ARRAY)

        local res = gg.getResults(50000)
        if res then
            for _, r in ipairs(res) do
                local addr = r.address

                if not map[addr] and validateHeader(addr, h.pattern) then
                    local size = getDexSize(addr)
                    if size > 0 then
                        map[addr] = true
                        table.insert(foundDex, {
                            address = addr,
                            version = h.version,
                            size = size
                        })
                    end
                end
            end
        end
    end

    return foundDex
end

function dumpDex(dex, path)
    local f = io.open(path, "wb")
    if not f then return false end

    local read = 0

    while read < dex.size do
        local chunk = math.min(CONFIG.CHUNK_SIZE, dex.size - read)
        local bytes = readBytes(dex.address + read, chunk)

        if not bytes then
            f:close()
            return false
        end

        f:write(bytesToString(bytes))
        read = read + chunk

        gg.toast("Dump " .. dex.version .. " " .. math.floor(read/dex.size*100) .. "%")
    end

    f:close()
    return true
end

function main()
    if not ensureDir() then
        gg.alert("Folder error")
        return
    end

    local ranges = nil
    local headers = nil
    local dexList = {}

    while true do
        local menu = gg.choice({
            "Set ranges",
            "Set DEX versions",
            "Search",
            "Dump",
            "Exit"
        }, nil, "DEX Dumper")

        if not menu or menu == 5 then
            os.exit()
        end

        if menu == 1 then
            local names = {}
            for i, r in ipairs(RANGE_LIST) do
                names[i] = r[1] .. " - " .. r[3]
            end

            local sel = gg.multiChoice(names)
            if sel then
                local flag = 0
                for i, v in ipairs(sel) do
                    if v then flag = flag | RANGE_LIST[i][2] end
                end
                ranges = flag
            end

        elseif menu == 2 then
            local names = {}
            for i, h in ipairs(DEX_HEADERS) do
                names[i] = "DEX " .. h.version
            end

            local sel = gg.multiChoice(names)
            if sel then
                headers = {}
                for i, v in ipairs(sel) do
                    if v then table.insert(headers, DEX_HEADERS[i]) end
                end
            end

        elseif menu == 3 then
            if not ranges or not headers then
                gg.alert("Configure first")
            else
                gg.toast("Searching...")
                dexList = searchDex(ranges, headers)
                gg.alert("Found: " .. #dexList)
            end

        elseif menu == 4 then
            if #dexList == 0 then
                gg.alert("No dex")
            else
                local list = {}
                for i, d in ipairs(dexList) do
                    list[i] = string.format("%d | v%s | 0x%X | %.2fMB",
                        i, d.version, d.address, d.size/1048576)
                end

                local sel = gg.multiChoice(list)
                if sel then
                    for i, v in ipairs(sel) do
                        if v then
                            local d = dexList[i]
                            local path = CONFIG.SAVE_PATH ..
                                string.format("dex_%d_v%s.dex", i, d.version)

                            if dumpDex(d, path) then
                                gg.alert("Saved: " .. path)
                            else
                                gg.alert("Dump error")
                            end
                        end
                    end
                end
            end
        end
    end
end

gg.setVisible(false)
main()