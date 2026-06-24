local ULTIMATE = {}

ULTIMATE.last = "/sdcard/"
ULTIMATE.info = nil
ULTIMATE.config = gg.EXT_CACHE_DIR .. "/" .. gg.getFile():match("[^/]+$") .. "ULTIMATE.cfg"
ULTIMATE.data = loadfile(ULTIMATE.config)

if ULTIMATE.data ~= nil then
    ULTIMATE.info = ULTIMATE.data()
    ULTIMATE.data = nil
end

if ULTIMATE.info == nil then
    ULTIMATE.info = { ULTIMATE.last, ULTIMATE.last:gsub("/[^/]+$", ""), false }
end

while true do
    ULTIMATE.info = gg.prompt({
        '\240\159\147\129 SCRIPT TO PROTECT:',
        '\240\159\147\130 OUTPUT FOLDER:'
    }, ULTIMATE.info, {
        'file',
        'path'
    })

    if ULTIMATE.info == nil then 
        gg.alert('\226\157\140 CANCELLED')
        os.exit()
    end

    gg.saveVariable(ULTIMATE.info, ULTIMATE.config)
    ULTIMATE.last = ULTIMATE.info[1]

    local file_check = io.open(ULTIMATE.last, "r")
    if file_check == nil then
        gg.alert('\226\154\160 FILE NOT FOUND!\nPath: ' .. ULTIMATE.last)
        return
    end
    file_check:close()

    ULTIMATE.out_name = ULTIMATE.last:match("[^/]+$")
    ULTIMATE.out_name = ULTIMATE.out_name:gsub("%.lua$", "")
    ULTIMATE.out = ULTIMATE.info[2] .. "/" .. ULTIMATE.out_name .. ".PROTECTED.lua"

    local file = io.open(ULTIMATE.last, "r")
    if file == nil then
        gg.alert('\226\157\140 CANNOT READ FILE!')
        return
    end
    local ORIGINAL = file:read('*a')
    file:close()

    if ORIGINAL == nil or #ORIGINAL == 0 then
        gg.alert('\226\157\140 FILE IS EMPTY!')
        return
    end

    local function random_name()
        local chars = {}
        local length = math.random(25, 40)
        
        if math.random(2) == 1 then
            chars[1] = string.char(math.random(65, 90))
        else
            chars[1] = string.char(math.random(97, 122))
        end
        
        for i = 2, length do
            local r = math.random(1, 3)
            if r == 1 then
                chars[i] = string.char(math.random(97, 122))
            elseif r == 2 then
                chars[i] = string.char(math.random(65, 90))
            else
                chars[i] = string.char(math.random(48, 57))
            end
        end
        
        return table.concat(chars)
    end

    local function str_to_bytes(str)
        local bytes = {}
        for i = 1, #str do
            bytes[i] = str:byte(i)
        end
        return bytes
    end

    local function bytes_to_obfuscated_string(bytes)
        if #bytes == 0 then return "\"\"" end
        return "string.char(" .. table.concat(bytes, ",") .. ")"
    end

    local function encrypt_with_index(bytes, keys, start_index)
        local encrypted = {}
        for i = 1, #bytes do
            local gi = start_index + i - 1
            local b = bytes[i]
            
            b = b ~ ((keys[1] + (gi * 3) % 256) % 256)
            b = b ~ ((keys[2] + (gi * 7) % 256) % 256)
            b = b ~ ((keys[3] + (gi * 13) % 256) % 256)
            b = (b + ((keys[1] * gi) % 256)) % 256
            
            encrypted[i] = b
        end
        return encrypted
    end

    local function split_bytes_exact(bytes, num_chunks)
        local chunks = {}
        local total = #bytes
        local base_size = math.floor(total / num_chunks)
        local remainder = total % num_chunks
        
        local pos = 1
        for i = 1, num_chunks do
            local chunk_size = base_size
            if i <= remainder then
                chunk_size = chunk_size + 1
            end
            
            if chunk_size > 0 and pos <= total then
                local chunk = {}
                local end_pos = math.min(pos + chunk_size - 1, total)
                for j = pos, end_pos do
                    chunk[#chunk + 1] = bytes[j]
                end
                chunks[i] = chunk
                pos = end_pos + 1
            end
        end
        
        return chunks
    end

    local function generate_chunk_file(chunk_data)
        local varname = random_name()
        local data_str = table.concat(chunk_data, ",")
        return "local " .. varname .. " = {" .. data_str .. "}\nreturn " .. varname
    end

    local function generate_loader(chunks_info, keys, total_bytes, output_folder_path)
        local v = {}
        for i = 1, 25 do
            v[i] = random_name()
        end
        
        local folder_bytes = str_to_bytes(output_folder_path)
        local folder_obfuscated = bytes_to_obfuscated_string(folder_bytes)
        
        local lines = {}
        
        lines[#lines + 1] = "local " .. v[1] .. " = " .. math.random(10000, 99999)
        lines[#lines + 1] = "local " .. v[2] .. " = {}"
        lines[#lines + 1] = "local " .. v[3] .. " = {}"
        lines[#lines + 1] = "local " .. v[4] .. " = 0"
        lines[#lines + 1] = "local " .. v[5] .. " = " .. folder_obfuscated
        
        lines[#lines + 1] = "local function " .. v[6] .. "(p)"
        lines[#lines + 1] = "local h=io.open(p,\"rb\")if not h then return nil end"
        lines[#lines + 1] = "local d=h:read(\"*a\")h:close()return d"
        lines[#lines + 1] = "end"
        
        lines[#lines + 1] = "local function " .. v[7] .. "(data,start_idx)"
        lines[#lines + 1] = "local r={}local k1=" .. keys[1] .. "local k2=" .. keys[2] .. "local k3=" .. keys[3]
        lines[#lines + 1] = "for i=1,#data do"
        lines[#lines + 1] = "local gi=start_idx+i-1"
        lines[#lines + 1] = "local b=data[i]"
        lines[#lines + 1] = "b=(b-((k1*gi)%256))%256;if b<0 then b=b+256 end"
        lines[#lines + 1] = "b=b~((k3+(gi*13)%256)%256)"
        lines[#lines + 1] = "b=b~((k2+(gi*7)%256)%256)"
        lines[#lines + 1] = "b=b~((k1+(gi*3)%256)%256)"
        lines[#lines + 1] = "r[i]=b%256"
        lines[#lines + 1] = "end"
        lines[#lines + 1] = "return r"
        lines[#lines + 1] = "end"
        
        lines[#lines + 1] = "local " .. v[8] .. "=os.exit"
        lines[#lines + 1] = "os.exit=function(...)error(\"__EXIT__\"..tostring(...))end"
        
        for i, info in ipairs(chunks_info) do
            local cv = random_name()
            local filename_bytes = str_to_bytes(info.filename)
            local filename_obfuscated = bytes_to_obfuscated_string(filename_bytes)
            
            lines[#lines + 1] = "do"
            lines[#lines + 1] = "local " .. cv .. "p=" .. v[5] .. "..\"/\".." .. filename_obfuscated
            lines[#lines + 1] = "local " .. cv .. "s=" .. v[6] .. "(" .. cv .. "p)"
            lines[#lines + 1] = "if " .. cv .. "s then"
            lines[#lines + 1] = "local " .. cv .. "f,e=load(" .. cv .. "s)"
            lines[#lines + 1] = "if " .. cv .. "f then"
            lines[#lines + 1] = "local " .. cv .. "o," .. cv .. "d=pcall(" .. cv .. "f)"
            lines[#lines + 1] = "if " .. cv .. "o and type(" .. cv .. "d)==\"table\" then"
            lines[#lines + 1] = "local " .. cv .. "r=" .. v[7] .. "(" .. cv .. "d," .. info.start_index .. ")"
            lines[#lines + 1] = "" .. v[2] .. "[" .. info.chunk_id .. "]=" .. cv .. "r"
            lines[#lines + 1] = "" .. v[4] .. "=" .. v[4] .. "+1"
            lines[#lines + 1] = "end"
            lines[#lines + 1] = "end"
            lines[#lines + 1] = "end"
            lines[#lines + 1] = "end"
        end
        
        lines[#lines + 1] = "if " .. v[4] .. "<" .. #chunks_info .. " then"
        lines[#lines + 1] = "os.exit=" .. v[8] .. ";return"
        lines[#lines + 1] = "end"
        
        lines[#lines + 1] = "for i=1," .. #chunks_info .. " do"
        lines[#lines + 1] = "local c=" .. v[2] .. "[i]"
        lines[#lines + 1] = "if c then for j=1,#c do " .. v[3] .. "[#" .. v[3] .. "+1]=c[j] end end"
        lines[#lines + 1] = "end"
        
        lines[#lines + 1] = "if #" .. v[3] .. "~=" .. total_bytes .. " then"
        lines[#lines + 1] = "os.exit=" .. v[8] .. ";return"
        lines[#lines + 1] = "end"
        
        lines[#lines + 1] = "local " .. v[9] .. "={}"
        lines[#lines + 1] = "for i=1,#" .. v[3] .. " do " .. v[9] .. "[i]=string.char(" .. v[3] .. "[i]) end"
        lines[#lines + 1] = "local " .. v[10] .. "=table.concat(" .. v[9] .. ")"
        
        lines[#lines + 1] = "local " .. v[11] .. "," .. v[12] .. "=load(" .. v[10] .. ")"
        lines[#lines + 1] = "if " .. v[11] .. " then"
        lines[#lines + 1] = "local " .. v[13] .. "," .. v[14] .. "=pcall(" .. v[11] .. ")"
        lines[#lines + 1] = "if not " .. v[13] .. " then"
        lines[#lines + 1] = "local " .. v[15] .. "=tostring(" .. v[14] .. ")"
        lines[#lines + 1] = "if " .. v[15] .. ":find(\"__EXIT__\") then"
        lines[#lines + 1] = "" .. v[8] .. "()"
        lines[#lines + 1] = "else"
        lines[#lines + 1] = "gg.alert(\"Error:\\n\".." .. v[15] .. ")"
        lines[#lines + 1] = "end"
        lines[#lines + 1] = "end"
        lines[#lines + 1] = "else"
        lines[#lines + 1] = "gg.alert(\"Compile Error\")"
        lines[#lines + 1] = "end"
        
        lines[#lines + 1] = "os.exit=" .. v[8]
        
        return table.concat(lines, "\n")
    end

    local total_bytes = #ORIGINAL
    local num_chunks = 200
    local keys = {
        math.random(50, 200),
        math.random(50, 200),
        math.random(50, 200)
    }
    
    gg.toast("Generating 200 protected files...")
    
    local all_bytes = str_to_bytes(ORIGINAL)
    local encrypted_bytes = encrypt_with_index(all_bytes, keys, 1)
    local chunks = split_bytes_exact(encrypted_bytes, num_chunks)
    
    local start_indices = {}
    local current_index = 1
    for i = 1, #chunks do
        start_indices[i] = current_index
        current_index = current_index + #chunks[i]
    end
    
    local chunks_info = {}
    local output_folder = ULTIMATE.info[2]
    
    for i = 1, #chunks do
        local chunk_filename = random_name() .. ".lua"
        local chunk_path = output_folder .. "/" .. chunk_filename
        
        local chunk_code = generate_chunk_file(chunks[i])
        
        local test_load, test_err = load(chunk_code)
        if not test_load then
            gg.alert("Chunk validation failed:\n" .. test_err .. "\n\nCode:\n" .. chunk_code:sub(1, 200))
            return
        end
        
        local chunk_file = io.open(chunk_path, "w")
        if chunk_file then
            chunk_file:write(chunk_code)
            chunk_file:close()
            
            chunks_info[i] = {
                filename = chunk_filename,
                chunk_id = i,
                start_index = start_indices[i],
                size = #chunks[i]
            }
        else
            gg.alert("Cannot create: " .. chunk_path)
            return
        end
    end
    
    local shuffled_info = {}
    for i = 1, #chunks_info do
        shuffled_info[i] = chunks_info[i]
    end
    
    for i = #shuffled_info, 2, -1 do
        local j = math.random(i)
        shuffled_info[i], shuffled_info[j] = shuffled_info[j], shuffled_info[i]
    end
    
    local loader_code = generate_loader(shuffled_info, keys, total_bytes, output_folder)
    
    local loader_file = io.open(ULTIMATE.out, "w")
    if loader_file then
        loader_file:write(loader_code)
        loader_file:close()
    else
        gg.alert("Cannot create loader: " .. ULTIMATE.out)
        return
    end
    
    local msg = "PROTECTION COMPLETE!\n\n"
    msg = msg .. "Loader: " .. ULTIMATE.out_name .. ".PROTECTED.lua\n"
    msg = msg .. "Chunks: " .. #chunks .. " files\n"
    msg = msg .. "Size: " .. total_bytes .. " bytes\n"
    msg = msg .. "Folder: " .. output_folder .. "\n\n"
    msg = msg .. "All strings obfuscated\n"
    
    msg = msg .. "200 files generated"
    
    gg.alert(msg)
    print("\n" .. string.rep("=", 60))
    print(msg)
    print(string.rep("=", 60))
    
    return
end