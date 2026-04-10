g = {}
g.last = "/sdcard/"
info = nil
g.config = gg.EXT_CACHE_DIR .. "/" .. gg.getFile():match("[^/]+$") .. "cfg"

if info == nil then
  info = { g.last, g.last:gsub("/[^/]+$", "") }
end

function chooseElfFile()
    local info = gg.prompt({
        "📂 Select .so file:"
    }, info, {
        "file"
    })
   
    gg.saveVariable(info, g.config)
    g.last = info[1]
    
    if not info or #info == 0 then
        gg.alert("Please select ELF file")
        return nil
    end
    
    return info[1]
end

function chooseOutputFile()
    local output_file = gg.prompt({
        "📄 Select output file:"
    }, { "/sdcard/elf_info.txt" }, {
        "file"
    })
    
    if not output_file or #output_file == 0 then
        return "/sdcard/elf_info.txt"
    end
    
    return output_file[1]
end

show_symbol_table = true
show_program_headers = false
show_section_headers = true

local elf32_h_map = {
    ei_mag = {offset = 0, size = 4},   
    ei_class = {offset = 4, size = 1}, 
    ei_data = {offset = 5, size = 1},  
    ei_version = {offset = 6, size = 1},  
    ei_osabi = {offset = 7, size = 1},  
    ei_abiversion = {offset = 8, size = 1},  
    ei_padding1 = {offset = 9, size = 1},  
    ei_padding2 = {offset = 10, size = 1},  
    ei_padding3 = {offset = 11, size = 1},
    ei_padding4 = {offset = 12, size = 1},  
    ei_padding5 = {offset = 13, size = 1},
    ei_padding6 = {offset = 14, size = 1},  
    ei_padding7 = {offset = 15, size = 1},
    e_type = {offset = 16, size = 2},  
    e_machine = {offset = 18, size = 2},
    e_version = {offset = 20, size = 4},
    e_entry = {offset = 24, size = 4},
    e_phoff = {offset = 28, size = 4},  
    e_shoff = {offset = 32, size = 4},
    e_flags = {offset = 36, size = 4},  
    e_ehsize = {offset = 40, size = 2},
    e_phentsize = {offset = 42, size = 2},
    e_phnum = {offset = 44, size = 2},
    e_shentsize = {offset = 46, size = 2},
    e_shnum = {offset = 48, size = 2},
    e_shstrndx = {offset = 50, size = 2}
}

local elf64_h_map = {
    ei_mag = {offset = 0, size = 4},
    ei_class = {offset = 4, size = 1},
    ei_data = {offset = 5, size = 1},
    ei_version = {offset = 6, size = 1},
    ei_osabi = {offset = 7, size = 1},
    ei_abiversion = {offset = 8, size = 1},
    ei_padding1 = {offset = 9, size = 1},
    ei_padding2 = {offset = 10, size = 1},
    ei_padding3 = {offset = 11, size = 1},
    ei_padding4 = {offset = 12, size = 1},
    ei_padding5 = {offset = 13, size = 1},
    ei_padding6 = {offset = 14, size = 1},
    ei_padding7 = {offset = 15, size = 1},
    e_type = {offset = 16, size = 2},
    e_machine = {offset = 18, size = 2},
    e_version = {offset = 20, size = 4},
    e_entry = {offset = 24, size = 8},
    e_phoff = {offset = 32, size = 8},
    e_shoff = {offset = 40, size = 8},
    e_flags = {offset = 48, size = 4},
    e_ehsize = {offset = 52, size = 2},
    e_phentsize = {offset = 54, size = 2},
    e_phnum = {offset = 56, size = 2},
    e_shentsize = {offset = 58, size = 2},
    e_shnum = {offset = 60, size = 2},
    e_shstrndx = {offset = 62, size = 2}
}

local elf32_program_h_map = {
    p_type = {offset = 0, size = 4},
    p_offset = {offset = 4, size = 4},
    p_vaddr = {offset = 8, size = 4},
    p_paddr = {offset = 12, size = 4},
    p_filesz = {offset = 16, size = 4},
    p_memsz = {offset = 20, size = 4},
    p_flags = {offset = 24, size = 4},
    p_align = {offset = 28, size = 4}
}

local elf64_program_h_map = {
    p_type = {offset = 0, size = 4},
    p_flags = {offset = 4, size = 4},
    p_offset = {offset = 8, size = 8},
    p_vaddr = {offset = 16, size = 8},
    p_paddr = {offset = 24, size = 8},
    p_filesz = {offset = 32, size = 8},
    p_memsz = {offset = 40, size = 8},
    p_align = {offset = 48, size = 8}
}

local elf32_section_h_map = {
    sh_name = {offset = 0, size = 4},
    sh_type = {offset = 4, size = 4},
    sh_flags = {offset = 8, size = 4},
    sh_addr = {offset = 12, size = 4},
    sh_offset = {offset = 16, size = 4},
    sh_size = {offset = 20, size = 4},
    sh_link = {offset = 24, size = 4},
    sh_info = {offset = 28, size = 4},
    sh_addralign = {offset = 32, size = 4},
    sh_entsize = {offset = 36, size = 4}
}

local elf64_section_h_map = {
    sh_name = {offset = 0, size = 4},
    sh_type = {offset = 4, size = 4},
    sh_flags = {offset = 8, size = 8},
    sh_addr = {offset = 16, size = 8},
    sh_offset = {offset = 24, size = 8},
    sh_size = {offset = 32, size = 8},
    sh_link = {offset = 40, size = 4},
    sh_info = {offset = 44, size = 4},
    sh_addralign = {offset = 48, size = 8},
    sh_entsize = {offset = 56, size = 8}
}

local elf32_symbol_h_map = {
    st_name = {offset = 0, size = 4},
    st_value = {offset = 4, size = 4},
    st_size = {offset = 8, size = 4},
    st_info = {offset = 12, size = 1},
    st_other = {offset = 13, size = 1},
    st_shndx = {offset = 14, size = 2}
}

local elf64_symbol_h_map = {
    st_name = {offset = 0, size = 4},
    st_info = {offset = 4, size = 1},
    st_other = {offset = 5, size = 1},
    st_shndx = {offset = 6, size = 2},
    st_value = {offset = 8, size = 8},
    st_size = {offset = 16, size = 8}
}

local outfile = nil

function write(text)
    if outfile then
        outfile:write(text .. "\n")
    end
  --  print(text)
end

function read_bytes(fname, pos, cnt)
    local f = io.open(fname, "rb")
    if not f then
        return nil
    end
    f:seek("set", pos)
    local data = f:read(cnt)
    f:close()
    return data
end

function get_string(table_data, pos)
    local i = pos + 1
    local s = ""
    while i <= #table_data and table_data:byte(i) ~= 0 do
        s = s .. string.char(table_data:byte(i))
        i = i + 1
    end
    return s
end

function read_struct(fname, pos, struct, is64)
    local r = {}
    for key, info in pairs(struct) do
        local d = read_bytes(fname, pos + info.offset, info.size)
        if d then
            if info.size == 1 then
                r[key] = d:byte()
            elseif info.size == 2 then
                r[key] = string.unpack("<I2", d)
            elseif info.size == 4 then
                r[key] = string.unpack("<I4", d)
            elseif info.size == 8 then
                r[key] = string.unpack("<I8", d)
            end
        end
    end
    return r
end

function read_elf_header(fname)
    local magic = read_bytes(fname, 0, 4)
    if magic ~= "\x7fELF" then
        write("Error: Not ELF file")
        return nil
    end
    local cls = read_bytes(fname, 4, 1):byte()
    local is64 = (cls == 2)
    local hmap = is64 and elf64_h_map or elf32_h_map
    local hdr = {}
    hdr.is_elf64 = is64
    for key, info in pairs(hmap) do
        local d = read_bytes(fname, info.offset, info.size)
        if d then
            if info.size == 1 then
                hdr[key] = d:byte()
            elseif info.size == 2 then
                hdr[key] = string.unpack("<I2", d)
            elseif info.size == 4 then
                hdr[key] = string.unpack("<I4", d)
            elseif info.size == 8 then
                hdr[key] = string.unpack("<I8", d)
            end
        end
    end
    return hdr
end

function read_program_headers(fname, hdr)
    if hdr.e_phnum == 0 then
        return {}
    end
    local phs = {}
    local phmap = hdr.is_elf64 and elf64_program_h_map or elf32_program_h_map
    local sz = hdr.e_phentsize
    for i = 0, hdr.e_phnum - 1 do
        local pos = hdr.e_phoff + i * sz
        local ph = read_struct(fname, pos, phmap, hdr.is_elf64)
        table.insert(phs, ph)
    end
    return phs
end

function read_section_headers(fname, hdr)
    if hdr.e_shnum == 0 then
        return {}
    end
    local shs = {}
    local shmap = hdr.is_elf64 and elf64_section_h_map or elf32_section_h_map
    local sz = hdr.e_shentsize
    for i = 0, hdr.e_shnum - 1 do
        local pos = hdr.e_shoff + i * sz
        local sh = read_struct(fname, pos, shmap, hdr.is_elf64)
        table.insert(shs, sh)
    end
    return shs
end

function read_string_table(fname, sec)
    return read_bytes(fname, sec.sh_offset, sec.sh_size)
end

function print_elf_header(hdr)
    write("ELF Header Info:")
    write("----------------------")
    local cls = hdr.is_elf64 and "ELF64" or "ELF32"
    write("Class: " .. cls)
    write("OS/ABI: 0x" .. string.format("%x", hdr.ei_osabi))
    write("Machine: 0x" .. string.format("%x", hdr.e_machine))
    write("Type: 0x" .. string.format("%x", hdr.e_type))
    write("Entry: 0x" .. string.format("%x", hdr.e_entry))
    write("Program headers: " .. hdr.e_phnum)
    write("Section headers: " .. hdr.e_shnum)
    write("String table index: " .. hdr.e_shstrndx)
    write("----------------------")
end

function print_program_headers(phs, hdr)
    for i, ph in ipairs(phs) do
        write("Program header " .. (i-1) .. ":")
        write("  type: 0x" .. string.format("%x", ph.p_type))
        if hdr.is_elf64 then
            write("  flags: 0x" .. string.format("%x", ph.p_flags))
        else
            write("  flags: 0x" .. string.format("%x", ph.p_flags or 0))
        end
        write("  offset: 0x" .. string.format("%x", ph.p_offset))
        write("  vaddr: 0x" .. string.format("%x", ph.p_vaddr))
        write("  paddr: 0x" .. string.format("%x", ph.p_paddr))
        write("  size: 0x" .. string.format("%x", ph.p_filesz))
        write("  memsize: 0x" .. string.format("%x", ph.p_memsz))
        write("  align: 0x" .. string.format("%x", ph.p_align))
        write("  ----------------------")
    end
end

function print_symbol_table(fname, sec, shs, hdr)
    if not show_symbol_table then
        return
    end
    local strtab = read_string_table(fname, shs[sec.sh_link + 1])
    local symmap = hdr.is_elf64 and elf64_symbol_h_map or elf32_symbol_h_map
    local sz = sec.sh_entsize
    local pos = sec.sh_offset
    local endpos = pos + sec.sh_size
    while pos < endpos do
        local sym = read_struct(fname, pos, symmap, hdr.is_elf64)
        pos = pos + sz
        if sym.st_name ~= 0 then
            local name = get_string(strtab, sym.st_name)
            local info = sym.st_info
            local typ = info & 0xf
            local bind = info >> 4
            local line = name
            if typ == 0 then
                line = line .. " STT_NOTYPE"
            elseif typ == 1 then
                line = line .. " STT_OBJECT"
            elseif typ == 2 then
                line = line .. " STT_FUNC"
            elseif typ == 3 then
                line = line .. " STT_SECTION"
            elseif typ == 4 then
                line = line .. " STT_FILE"
            end
            if bind == 0 then
                line = line .. " STB_LOCAL"
            elseif bind == 1 then
                line = line .. " STB_GLOBAL"
            elseif bind == 2 then
                line = line .. " STB_WEAK"
            end
            line = line .. " value: 0x" .. string.format("%x", sym.st_value)
            line = line .. " size: 0x" .. string.format("%x", sym.st_size)
            write("  " .. line)
        end
    end
end

function print_dyn_table(fname, sec, shs, hdr)
    local strtab = read_string_table(fname, shs[sec.sh_link + 1])
    local dynmap = hdr.is_elf64 and 
        {d_tag = {offset = 0, size = 8}, d_val = {offset = 8, size = 8}} or
        {d_tag = {offset = 0, size = 4}, d_val = {offset = 4, size = 4}}
    local sz = hdr.is_elf64 and 16 or 8
    local pos = sec.sh_offset
    local endpos = pos + sec.sh_size
    while pos < endpos do
        local dyn = read_struct(fname, pos, dynmap, hdr.is_elf64)
        pos = pos + sz
        if dyn.d_tag == 1 then
            local lib = get_string(strtab, dyn.d_val)
            write("  Needed library: " .. lib)
        elseif dyn.d_tag == 14 then
            local soname = get_string(strtab, dyn.d_val)
            write("  Soname: " .. soname)
        end
    end
end

function print_section_headers(fname, hdr, shs)
    local strsec = shs[hdr.e_shstrndx + 1]
    local strdata = read_string_table(fname, strsec)
    for i, sec in ipairs(shs) do
        local name = get_string(strdata, sec.sh_name)
        write("Section header " .. (i-1) .. ":")
        write("  name: " .. name)
        write("  offset: 0x" .. string.format("%x", sec.sh_offset))
        write("  size: 0x" .. string.format("%x", sec.sh_size))
        write("  addr: 0x" .. string.format("%x", sec.sh_addr))
        local typ = sec.sh_type
        if typ == 0 then
            write("  type: SHT_NULL")
        elseif typ == 1 then
            write("  type: SHT_PROGBITS")
            if name == ".interp" or name == ".comment" then
                local d = read_bytes(fname, sec.sh_offset, math.min(sec.sh_size, 100))
                if d then
                    write("  data: " .. d:gsub("%c", "."))
                end
            end
        elseif typ == 2 then
            write("  type: SHT_SYMTAB")
            print_symbol_table(fname, sec, shs, hdr)
        elseif typ == 3 then
            write("  type: SHT_STRTAB")
        elseif typ == 4 then
            write("  type: SHT_RELA")
        elseif typ == 5 then
            write("  type: SHT_HASH")
        elseif typ == 6 then
            write("  type: SHT_DYNAMIC")
            print_dyn_table(fname, sec, shs, hdr)
        elseif typ == 7 then
            write("  type: SHT_NOTE")
        elseif typ == 8 then
            write("  type: SHT_NOBITS")
        elseif typ == 9 then
            write("  type: SHT_REL")
        elseif typ == 11 then
            write("  type: SHT_DYNSYM")
            print_symbol_table(fname, sec, shs, hdr)
        elseif typ == 14 then
            write("  type: SHT_INIT_ARRAY")
        elseif typ == 15 then
            write("  type: SHT_FINI_ARRAY")
        elseif typ == 16 then
            write("  type: SHT_PREINIT_ARRAY")
        elseif typ == 17 then
            write("  type: SHT_GROUP")
        else
            write("  type: 0x" .. string.format("%x", typ))
        end
        write("  ----------------------")
    end
end

function main()
    local fname = chooseElfFile()
    if not fname then
        return
    end
    local outname = chooseOutputFile()
    outfile = io.open(outname, "w")
    if not outfile then
        gg.alert("Cannot open output file")
        return
    end
    local time = os.date("%Y-%m-%d %H:%M:%S")
    write("ELF File Analysis")
    write("Time: " .. time)
    write("Input: " .. fname)
    write("Output: " .. outname)
    write("=" .. string.rep("=", 60) .. "\n")
    local hdr = read_elf_header(fname)
    if not hdr then
        write("Failed to read ELF header")
        outfile:close()
        return
    end
    print_elf_header(hdr)
    if show_section_headers then
        write("\nSECTION HEADERS:")
        write("======================")
        local shs = read_section_headers(fname, hdr)
        if #shs > 0 then
            print_section_headers(fname, hdr, shs)
        else
            write("No sections found")
        end
    end
    if show_program_headers then
        write("\nPROGRAM HEADERS:")
        write("======================")
        local phs = read_program_headers(fname, hdr)
        if #phs > 0 then
            print_program_headers(phs, hdr)
        else
            write("No program headers found")
        end
    end
    write("\n" .. string.rep("=", 70))
    write("ANALYSIS DONE")
    write("Sections: " .. (hdr.e_shnum or 0))
    write("Program headers: " .. (hdr.e_phnum or 0))
    outfile:close()
    gg.alert("Done!\nSaved to:\n" .. outname)
    
end

main()