g = {}
g.last = "/sdcard/"
info = nil
g.config = gg.EXT_CACHE_DIR .. "/" .. gg.getFile():match("[^/]+$") .. "cfg"

if info == nil then
  info = { g.last, g.last:gsub("/[^/]+$", "") }
end

function chooseElfFile()
    local prompt_result = gg.prompt({
        "📂 Select file ELF:"
    }, info, {
        "file"
    })
    
    if not prompt_result or #prompt_result == 0 then
        print("Please select an ELF file")
        return nil
    end
    
    gg.saveVariable(prompt_result, g.config)
    g.last = prompt_result[1]
    info = prompt_result
    
    return prompt_result[1]
end

local elf32_h_map = {
    ei_class = {offset = 4, size = 1},
    ei_data = {offset = 5, size = 1},
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
    ei_class = {offset = 4, size = 1},
    ei_data = {offset = 5, size = 1},
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

function get_file_size(filename)
    local file = io.open(filename, "rb")
    if not file then return 0 end
    local size = file:seek("end")
    file:close()
    return size
end

function read_bytes_safe(filename, offset, count, file_size)
    if offset < 0 or offset >= file_size then
        return nil
    end
    if offset + count > file_size then
        count = file_size - offset
        if count <= 0 then
            return nil
        end
    end
    
    local file = io.open(filename, "rb")
    if not file then
        return nil
    end
    file:seek("set", offset)
    local bytes = file:read(count)
    file:close()
    return bytes
end

function get_endianness_format(ei_data)
    if ei_data == 1 then
        return "<"
    elseif ei_data == 2 then
        return ">"
    else
        return "<"
    end
end

function read_elf_header(filename)
    local file_size = get_file_size(filename)
    if file_size < 64 then
        print("File too small to be a valid ELF")
        return nil
    end
    
    local elf_header = {}
    elf_header.filename = filename
    elf_header.file_size = file_size
    
    local signature = read_bytes_safe(filename, 0, 4, file_size)
    if not signature or signature ~= "\x7fELF" then
        print("Not a valid ELF file")
        return nil
    end
    
    local class_byte = read_bytes_safe(filename, 4, 1, file_size)
    local data_byte = read_bytes_safe(filename, 5, 1, file_size)
    
    if not class_byte or not data_byte then
        print("Failed to read ELF header")
        return nil
    end
    
    elf_header.ei_class = class_byte:byte()
    elf_header.ei_data = data_byte:byte()
    
    if elf_header.ei_class == 1 then
        elf_header.is_elf64 = false
    elseif elf_header.ei_class == 2 then
        elf_header.is_elf64 = true
    else
        print("Invalid ELF class: " .. elf_header.ei_class)
        return nil
    end
    
    elf_header.endianness = get_endianness_format(elf_header.ei_data)
    
    local elf_header_map = elf_header.is_elf64 and elf64_h_map or elf32_h_map
    
    for key, info in pairs(elf_header_map) do
        local bytes = read_bytes_safe(filename, info.offset, info.size, file_size)
        if bytes and #bytes == info.size then
            local format = elf_header.endianness
            if info.size == 1 then
                elf_header[key] = bytes:byte()
            elseif info.size == 2 then
                format = format .. "I2"
                elf_header[key] = string.unpack(format, bytes)
            elseif info.size == 4 then
                format = format .. "I4"
                elf_header[key] = string.unpack(format, bytes)
            elseif info.size == 8 then
                format = format .. "I8"
                elf_header[key] = string.unpack(format, bytes)
            end
        else
            elf_header[key] = 0
        end
    end
    
    if elf_header.e_phoff >= file_size or 
       elf_header.e_shoff >= file_size or
       elf_header.e_phoff < 0 or
       elf_header.e_shoff < 0 then
        print("Invalid header offsets in ELF file")
        return nil
    end
    
    if elf_header.e_phnum > 1000 then
        print("Suspicious number of program headers: " .. elf_header.e_phnum)
        elf_header.e_phnum = 0
    end
    
    if elf_header.e_shnum > 1000 then
        print("Suspicious number of section headers: " .. elf_header.e_shnum)
        elf_header.e_shnum = 0
    end
    
    if elf_header.e_phnum > 0 then
        elf_header.segments = {}
        
        for i = 0, elf_header.e_phnum - 1 do
            local seg_offset = elf_header.e_phoff + i * elf_header.e_phentsize
            
            if seg_offset >= file_size or seg_offset < 0 then
                break
            end
            
            if elf_header.is_elf64 then
                local p_type_bytes = read_bytes_safe(filename, seg_offset, 4, file_size)
                local p_flags_bytes = read_bytes_safe(filename, seg_offset + 4, 4, file_size)
                local p_offset_bytes = read_bytes_safe(filename, seg_offset + 8, 8, file_size)
                local p_vaddr_bytes = read_bytes_safe(filename, seg_offset + 16, 8, file_size)
                local p_paddr_bytes = read_bytes_safe(filename, seg_offset + 24, 8, file_size)
                local p_filesz_bytes = read_bytes_safe(filename, seg_offset + 32, 8, file_size)
                local p_memsz_bytes = read_bytes_safe(filename, seg_offset + 40, 8, file_size)
                local p_align_bytes = read_bytes_safe(filename, seg_offset + 48, 8, file_size)
                
                if p_type_bytes and p_offset_bytes then
                    local format = elf_header.endianness
                    local segment = {
                        p_type = string.unpack(format .. "I4", p_type_bytes),
                        p_flags = p_flags_bytes and string.unpack(format .. "I4", p_flags_bytes) or 0,
                        p_offset = string.unpack(format .. "I8", p_offset_bytes),
                        p_vaddr = p_vaddr_bytes and string.unpack(format .. "I8", p_vaddr_bytes) or 0,
                        p_paddr = p_paddr_bytes and string.unpack(format .. "I8", p_paddr_bytes) or 0,
                        p_filesz = p_filesz_bytes and string.unpack(format .. "I8", p_filesz_bytes) or 0,
                        p_memsz = p_memsz_bytes and string.unpack(format .. "I8", p_memsz_bytes) or 0,
                        p_align = p_align_bytes and string.unpack(format .. "I8", p_align_bytes) or 0
                    }
                    table.insert(elf_header.segments, segment)
                end
            else
                local p_type_bytes = read_bytes_safe(filename, seg_offset, 4, file_size)
                local p_offset_bytes = read_bytes_safe(filename, seg_offset + 4, 4, file_size)
                local p_vaddr_bytes = read_bytes_safe(filename, seg_offset + 8, 4, file_size)
                local p_paddr_bytes = read_bytes_safe(filename, seg_offset + 12, 4, file_size)
                local p_filesz_bytes = read_bytes_safe(filename, seg_offset + 16, 4, file_size)
                local p_memsz_bytes = read_bytes_safe(filename, seg_offset + 20, 4, file_size)
                local p_flags_bytes = read_bytes_safe(filename, seg_offset + 24, 4, file_size)
                local p_align_bytes = read_bytes_safe(filename, seg_offset + 28, 4, file_size)
                
                if p_type_bytes and p_offset_bytes then
                    local format = elf_header.endianness
                    local segment = {
                        p_type = string.unpack(format .. "I4", p_type_bytes),
                        p_offset = string.unpack(format .. "I4", p_offset_bytes),
                        p_vaddr = p_vaddr_bytes and string.unpack(format .. "I4", p_vaddr_bytes) or 0,
                        p_paddr = p_paddr_bytes and string.unpack(format .. "I4", p_paddr_bytes) or 0,
                        p_filesz = p_filesz_bytes and string.unpack(format .. "I4", p_filesz_bytes) or 0,
                        p_memsz = p_memsz_bytes and string.unpack(format .. "I4", p_memsz_bytes) or 0,
                        p_flags = p_flags_bytes and string.unpack(format .. "I4", p_flags_bytes) or 0,
                        p_align = p_align_bytes and string.unpack(format .. "I4", p_align_bytes) or 0
                    }
                    table.insert(elf_header.segments, segment)
                end
            end
        end
    end
    
    if elf_header.e_shnum > 0 then
        elf_header.sections = {}
        
        for i = 0, elf_header.e_shnum - 1 do
            local sec_offset = elf_header.e_shoff + i * elf_header.e_shentsize
            
            if sec_offset >= file_size or sec_offset < 0 then
                break
            end
            
            if elf_header.is_elf64 then
                local sh_name_bytes = read_bytes_safe(filename, sec_offset, 4, file_size)
                local sh_type_bytes = read_bytes_safe(filename, sec_offset + 4, 4, file_size)
                local sh_flags_bytes = read_bytes_safe(filename, sec_offset + 8, 8, file_size)
                local sh_addr_bytes = read_bytes_safe(filename, sec_offset + 16, 8, file_size)
                local sh_offset_bytes = read_bytes_safe(filename, sec_offset + 24, 8, file_size)
                local sh_size_bytes = read_bytes_safe(filename, sec_offset + 32, 8, file_size)
                local sh_link_bytes = read_bytes_safe(filename, sec_offset + 40, 4, file_size)
                local sh_info_bytes = read_bytes_safe(filename, sec_offset + 44, 4, file_size)
                local sh_addralign_bytes = read_bytes_safe(filename, sec_offset + 48, 8, file_size)
                local sh_entsize_bytes = read_bytes_safe(filename, sec_offset + 56, 8, file_size)
                
                if sh_name_bytes and sh_offset_bytes then
                    local format = elf_header.endianness
                    local section = {
                        sh_name = string.unpack(format .. "I4", sh_name_bytes),
                        sh_type = sh_type_bytes and string.unpack(format .. "I4", sh_type_bytes) or 0,
                        sh_flags = sh_flags_bytes and string.unpack(format .. "I8", sh_flags_bytes) or 0,
                        sh_addr = sh_addr_bytes and string.unpack(format .. "I8", sh_addr_bytes) or 0,
                        sh_offset = string.unpack(format .. "I8", sh_offset_bytes),
                        sh_size = sh_size_bytes and string.unpack(format .. "I8", sh_size_bytes) or 0,
                        sh_link = sh_link_bytes and string.unpack(format .. "I4", sh_link_bytes) or 0,
                        sh_info = sh_info_bytes and string.unpack(format .. "I4", sh_info_bytes) or 0,
                        sh_addralign = sh_addralign_bytes and string.unpack(format .. "I8", sh_addralign_bytes) or 0,
                        sh_entsize = sh_entsize_bytes and string.unpack(format .. "I8", sh_entsize_bytes) or 0
                    }
                    table.insert(elf_header.sections, section)
                end
            else
                local sh_name_bytes = read_bytes_safe(filename, sec_offset, 4, file_size)
                local sh_type_bytes = read_bytes_safe(filename, sec_offset + 4, 4, file_size)
                local sh_flags_bytes = read_bytes_safe(filename, sec_offset + 8, 4, file_size)
                local sh_addr_bytes = read_bytes_safe(filename, sec_offset + 12, 4, file_size)
                local sh_offset_bytes = read_bytes_safe(filename, sec_offset + 16, 4, file_size)
                local sh_size_bytes = read_bytes_safe(filename, sec_offset + 20, 4, file_size)
                local sh_link_bytes = read_bytes_safe(filename, sec_offset + 24, 4, file_size)
                local sh_info_bytes = read_bytes_safe(filename, sec_offset + 28, 4, file_size)
                local sh_addralign_bytes = read_bytes_safe(filename, sec_offset + 32, 4, file_size)
                local sh_entsize_bytes = read_bytes_safe(filename, sec_offset + 36, 4, file_size)
                
                if sh_name_bytes and sh_offset_bytes then
                    local format = elf_header.endianness
                    local section = {
                        sh_name = string.unpack(format .. "I4", sh_name_bytes),
                        sh_type = sh_type_bytes and string.unpack(format .. "I4", sh_type_bytes) or 0,
                        sh_flags = sh_flags_bytes and string.unpack(format .. "I4", sh_flags_bytes) or 0,
                        sh_addr = sh_addr_bytes and string.unpack(format .. "I4", sh_addr_bytes) or 0,
                        sh_offset = string.unpack(format .. "I4", sh_offset_bytes),
                        sh_size = sh_size_bytes and string.unpack(format .. "I4", sh_size_bytes) or 0,
                        sh_link = sh_link_bytes and string.unpack(format .. "I4", sh_link_bytes) or 0,
                        sh_info = sh_info_bytes and string.unpack(format .. "I4", sh_info_bytes) or 0,
                        sh_addralign = sh_addralign_bytes and string.unpack(format .. "I4", sh_addralign_bytes) or 0,
                        sh_entsize = sh_entsize_bytes and string.unpack(format .. "I4", sh_entsize_bytes) or 0
                    }
                    table.insert(elf_header.sections, section)
                end
            end
        end
    end
    
    return elf_header
end

function format_hex(value, digits)
    return string.format("0x%0" .. digits .. "X", value)
end

function get_endianness_name(ei_data)
    if ei_data == 1 then
        return "Little Endian"
    elseif ei_data == 2 then
        return "Big Endian"
    else
        return "Unknown (" .. ei_data .. ")"
    end
end

function get_segment_type_name(type)
    local types = {
        [0] = "NULL",
        [1] = "LOAD",
        [2] = "DYNAMIC",
        [3] = "INTERP",
        [4] = "NOTE",
        [5] = "SHLIB",
        [6] = "PHDR",
        [7] = "TLS",
        [0x60000000] = "LOOS",
        [0x6fffffff] = "HIOS",
        [0x70000000] = "LOPROC",
        [0x7fffffff] = "HIPROC"
    }
    return types[type] or string.format("0x%X", type)
end

function get_section_type_name(type)
    local types = {
        [0] = "NULL",
        [1] = "PROGBITS",
        [2] = "SYMTAB",
        [3] = "STRTAB",
        [4] = "RELA",
        [5] = "HASH",
        [6] = "DYNAMIC",
        [7] = "NOTE",
        [8] = "NOBITS",
        [9] = "REL",
        [10] = "SHLIB",
        [11] = "DYNSYM",
        [0x60000000] = "LOOS",
        [0x6fffffff] = "HIOS"
    }
    return types[type] or string.format("0x%X", type)
end

function display_elf_header(elf_header)
    print("╔════════════════════════════════════════════════════════════╗")
    print("║                     ELF FILE ANALYSIS                      ║")
    print("╠════════════════════════════════════════════════════════════╣")
    print("File: " .. elf_header.filename)
    print("Size: " .. string.format("%d bytes", elf_header.file_size))
    print("")
    
    print("║━━━━━━━━━━━━━━━━ ELF HEADER ━━━━━━━━━━━━━━━━━║")
    print("Architecture: " .. (elf_header.is_elf64 and "64-bit" or "32-bit"))
    print("Endianness: " .. get_endianness_name(elf_header.ei_data))
    print("Entry Point: " .. format_hex(elf_header.e_entry, elf_header.is_elf64 and 16 or 8))
    print("Type: " .. format_hex(elf_header.e_type, 4))
    print("Machine: " .. format_hex(elf_header.e_machine, 4))
    print("Version: " .. format_hex(elf_header.e_version, 8))
    print("Flags: " .. format_hex(elf_header.e_flags, 8))
    print("Program Headers Offset: " .. format_hex(elf_header.e_phoff, elf_header.is_elf64 and 16 or 8))
    print("Section Headers Offset: " .. format_hex(elf_header.e_shoff, elf_header.is_elf64 and 16 or 8))
    print("Program Header Size: " .. elf_header.e_phentsize .. " bytes")
    print("Section Header Size: " .. elf_header.e_shentsize .. " bytes")
    print("Program Headers Count: " .. elf_header.e_phnum)
    print("Section Headers Count: " .. elf_header.e_shnum)
    print("Section Name String Table Index: " .. elf_header.e_shstrndx)
    
    if elf_header.segments and #elf_header.segments > 0 then
        print("")
        print("║━━━━━━━━━━━━━━ PROGRAM SEGMENTS ━━━━━━━━━━━━━━━║")
        print("Total: " .. #elf_header.segments .. " segments")
        print("")
        
        for i, segment in ipairs(elf_header.segments) do
            print("Segment " .. i .. ":")
            print("  Type: " .. get_segment_type_name(segment.p_type))
            print("  Flags: " .. format_hex(segment.p_flags, 8))
            print("  Offset: " .. format_hex(segment.p_offset, elf_header.is_elf64 and 16 or 8))
            print("  Virtual Address: " .. format_hex(segment.p_vaddr, elf_header.is_elf64 and 16 or 8))
            print("  Physical Address: " .. format_hex(segment.p_paddr, elf_header.is_elf64 and 16 or 8))
            print("  File Size: " .. string.format("%d bytes", segment.p_filesz))
            print("  Memory Size: " .. string.format("%d bytes", segment.p_memsz))
            print("  Alignment: " .. format_hex(segment.p_align, elf_header.is_elf64 and 16 or 8))
            print("")
        end
    end
    
    if elf_header.sections and #elf_header.sections > 0 then
        print("║━━━━━━━━━━━━━━ SECTION HEADERS ━━━━━━━━━━━━━━━║")
        print("Total: " .. #elf_header.sections .. " sections")
        print("")
        
        for i, section in ipairs(elf_header.sections) do
            print("Section " .. i .. ":")
            print("  Type: " .. get_section_type_name(section.sh_type))
            print("  Flags: " .. format_hex(section.sh_flags, elf_header.is_elf64 and 16 or 8))
            print("  Address: " .. format_hex(section.sh_addr, elf_header.is_elf64 and 16 or 8))
            print("  Offset: " .. format_hex(section.sh_offset, elf_header.is_elf64 and 16 or 8))
            print("  Size: " .. string.format("%d bytes", section.sh_size))
            print("  Link: " .. section.sh_link)
            print("  Info: " .. section.sh_info)
            print("  Address Alignment: " .. format_hex(section.sh_addralign, elf_header.is_elf64 and 16 or 8))
            print("  Entry Size: " .. string.format("%d bytes", section.sh_entsize))
            print("")
        end
    end
    
    print("╚════════════════════════════════════════════════════════════╝")
end

local filename = chooseElfFile()
if filename then
    local elf_header = read_elf_header(filename)
    if elf_header then
        display_elf_header(elf_header)
    else
        print("Failed to read ELF header")
    end
end