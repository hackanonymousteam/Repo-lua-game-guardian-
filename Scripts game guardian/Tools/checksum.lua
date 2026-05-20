local bit = bit32 or bit

local function generate_random_string()
    local result = ""
    for i = 1, 6 do
        result = result .. string.char(math.random(97, 122))
    end
    return result
end

local function initialize_system(input)
    local acc = 0

    for i = 1, #input do
        local c = input:byte(i)
        acc = acc + c
        acc = bit.bxor(acc, c * i)
    end

    local checksum = string.format("%08X", bit.band(acc, 0xFFFFFFFF))

    return {
        success = true,
        checksum = checksum
    }
end

local function validate_system(input)
    local result = initialize_system(input)

    print("[System] Checksum:", result.checksum)

    return result
end

local function transform_data_structure(data)
    local out = {}

    for k, v in pairs(data) do
        local newKey = generate_random_string()

        if type(v) == "table" then
            out[newKey] = transform_data_structure(v)
        elseif type(v) == "string" then
            local s = ""
            for i = 1, #v do
                local b = v:byte(i)
                s = s .. string.char(97 + (b % 26))
            end
            out[newKey] = s
        else
            out[newKey] = v
        end
    end

    return out
end

local function process_events(map, ...)
    local results = {}
    for i = 1, select("#", ...) do
        local ev = select(i, ...)
        if map[ev] then
            results[i] = map[ev]()
        end
    end
    return results
end

local function process_string_pattern(str)
    return str:gsub("(%d+)", "[%1]")
end

local function main()
    print("=== SYSTEM START ===\n")

    print("Random:", generate_random_string())

    local r = initialize_system("HelloWorld")
    print("Checksum:", r.checksum)

    validate_system("Test123")

    local data = {
        name = "John",
        nested = { value = 123 }
    }

    local t = transform_data_structure(data)
    print("Transformed:", type(t))

    local events = {
        start = function() return "start ok" end,
        stop = function() return "stop ok" end
    }

    local res = process_events(events, "start", "stop")
    for i, v in ipairs(res) do
        print("Event:", v)
    end

    local s = process_string_pattern("abc123def456")
    print("Pattern:", s)

    print("\n=== SYSTEM OK ===")
end

main()