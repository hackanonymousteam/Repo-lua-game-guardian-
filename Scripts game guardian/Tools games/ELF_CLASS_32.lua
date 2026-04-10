g = {}
g.last = "/sdcard/"
info = nil
g.config = gg.EXT_CACHE_DIR .. "/" .. gg.getFile():match("[^/]+$") .. "cfg"

if info == nil then
    info = { g.last, g.last:gsub("/[^/]+$", "") }
end

gv = gg.getValues
sv = gg.setValues
sf = string.format

local ELF_MAGIC = "\127ELF"
local ELF_CLASS_32 = 1
local ELF_CLASS_64 = 2
local ELF_DATA_LITTLE = 1
local ELF_DATA_BIG = 2
local EM_ARM = 40
local ET_DYN = 3  
local SHT_NULL = 0
local SHT_PROGBITS = 1
local SHT_SYMTAB = 2
local SHT_STRTAB = 3
local SHT_RELA = 4
local SHT_HASH = 5
local SHT_DYNAMIC = 6
local SHT_NOTE = 7
local SHT_NOBITS = 8
local SHT_REL = 9
local SHT_SHLIB = 10
local SHT_DYNSYM = 11
local SHF_WRITE = 0x1
local SHF_ALLOC = 0x2
local SHF_EXECINSTR = 0x4
local SHF_MASKPROC = 0xF0000000
local STB_LOCAL = 0
local STB_GLOBAL = 1
local STB_WEAK = 2
local STB_LOOS = 10
local STB_HIOS = 12
local STB_LOPROC = 13
local STB_HIPROC = 15
local STT_NOTYPE = 0
local STT_OBJECT = 1
local STT_FUNC = 2
local STT_SECTION = 3
local STT_FILE = 4
local STT_COMMON = 5
local STT_TLS = 6
local STT_LOOS = 10
local STT_HIOS = 12
local STT_LOPROC = 13
local STT_HIPROC = 15

local ARM_RELOCATIONS = {
    [1] = "R_ARM_ABS32",
    [2] = "R_ARM_REL32",
    [3] = "R_ARM_LDR_PC_G0",
    [4] = "R_ARM_ABS16",
    [5] = "R_ARM_ABS12",
    [6] = "R_ARM_THM_ABS5",
    [7] = "R_ARM_ABS8",
    [8] = "R_ARM_SBREL32",
    [9] = "R_ARM_THM_CALL",
    [10] = "R_ARM_THM_PC8",
    [11] = "R_ARM_THM_JUMP24",
    [12] = "R_ARM_THM_JUMP19",
    [13] = "R_ARM_THM_JUMP6",
    [16] = "R_ARM_ALU_PCREL_7_0",
    [17] = "R_ARM_ALU_PCREL_15_8",
    [18] = "R_ARM_ALU_PCREL_23_15",
    [19] = "R_ARM_LDR_SBREL_11_0_NC",
    [20] = "R_ARM_ALU_SBREL_19_12_NC",
    [21] = "R_ARM_ALU_SBREL_27_20_CK",
    [22] = "R_ARM_TARGET1",
    [23] = "R_ARM_SBREL31",
    [24] = "R_ARM_V4BX",
    [25] = "R_ARM_TARGET2",
    [26] = "R_ARM_PREL31",
    [27] = "R_ARM_MOVW_ABS_NC",
    [28] = "R_ARM_MOVT_ABS",
    [29] = "R_ARM_MOVW_PREL_NC",
    [30] = "R_ARM_MOVT_PREL",
    [31] = "R_ARM_THM_MOVW_ABS_NC",
    [32] = "R_ARM_THM_MOVT_ABS",
    [33] = "R_ARM_THM_MOVW_PREL_NC",
    [34] = "R_ARM_THM_MOVT_PREL",
    [37] = "R_ARM_ME_TOO",
    [38] = "R_ARM_THM_TLS_DESCSEQ16",
    [39] = "R_ARM_THM_TLS_DESCSEQ32",
    [40] = "R_ARM_TLS_GOTDESC",
    [41] = "R_ARM_TLS_CALL",
    [42] = "R_ARM_THM_TLS_CALL",
    [43] = "R_ARM_PLT32",
    [44] = "R_ARM_GOT_ABS",
    [45] = "R_ARM_GOT_PREL",
    [46] = "R_ARM_GOT_BREL12",
    [47] = "R_ARM_GOTOFF12",
    [48] = "R_ARM_GOTRELAX",
    [49] = "R_ARM_GNU_VTENTRY",
    [50] = "R_ARM_GNU_VTINHERIT",
    [51] = "R_ARM_THM_JUMP11",
    [52] = "R_ARM_THM_JUMP8",
    [53] = "R_ARM_TLS_GD32",
    [54] = "R_ARM_TLS_LDM32",
    [55] = "R_ARM_TLS_LDO32",
    [56] = "R_ARM_TLS_IE32",
    [57] = "R_ARM_TLS_LE32",
    [58] = "R_ARM_TLS_LDO12",
    [59] = "R_ARM_TLS_LE12",
    [60] = "R_ARM_TLS_IE12GP",
    [61] = "R_ARM_JUMP_SLOT",
    [62] = "R_ARM_GLOB_DAT",
    [63] = "R_ARM_RELATIVE",
    [64] = "R_ARM_COPY",
    [70] = "R_ARM_IRELATIVE",
    [91] = "R_ARM_THM_MOVW_BREL_NC",
    [92] = "R_ARM_THM_MOVT_BREL",
    [93] = "R_ARM_THM_MOVW_BREL",
    [94] = "R_ARM_THM_JUMP19",
    [95] = "R_ARM_THM_JUMP6",
    [96] = "R_ARM_THM_ALU_PREL_11_0",
    [97] = "R_ARM_THM_PC12",
    [98] = "R_ARM_ABS32_NOI",
    [99] = "R_ARM_REL32_NOI",
    [100] = "R_ARM_ALU_PC_G0_NC",
    [101] = "R_ARM_ALU_PC_G0",
    [102] = "R_ARM_ALU_PC_G1_NC",
    [103] = "R_ARM_ALU_PC_G1",
    [104] = "R_ARM_ALU_PC_G2",
    [105] = "R_ARM_LDR_PC_G1",
    [106] = "R_ARM_LDR_PC_G2",
    [107] = "R_ARM_LDRS_PC_G0",
    [108] = "R_ARM_LDRS_PC_G1",
    [109] = "R_ARM_LDRS_PC_G2",
    [110] = "R_ARM_LDC_PC_G0",
    [111] = "R_ARM_LDC_PC_G1",
    [112] = "R_ARM_LDC_PC_G2",
    [113] = "R_ARM_ALU_SB_G0_NC",
    [114] = "R_ARM_ALU_SB_G0",
    [115] = "R_ARM_ALU_SB_G1_NC",
    [116] = "R_ARM_ALU_SB_G1",
    [117] = "R_ARM_ALU_SB_G2",
    [118] = "R_ARM_LDR_SB_G0",
    [119] = "R_ARM_LDR_SB_G1",
    [120] = "R_ARM_LDR_SB_G2",
    [121] = "R_ARM_LDRS_SB_G0",
    [122] = "R_ARM_LDRS_SB_G1",
    [123] = "R_ARM_LDRS_SB_G2",
    [124] = "R_ARM_LDC_SB_G0",
    [125] = "R_ARM_LDC_SB_G1",
    [126] = "R_ARM_LDC_SB_G2",
    [127] = "R_ARM_MOVW_BREL_NC",
    [128] = "R_ARM_MOVT_BREL",
    [129] = "R_ARM_MOVW_BREL"
}

local ARM_CONDITIONS = {
    [0] = "EQ", [1] = "NE", [2] = "CS", [3] = "CC",
    [4] = "MI", [5] = "PL", [6] = "VS", [7] = "VC",
    [8] = "HI", [9] = "LS", [10] = "GE", [11] = "LT",
    [12] = "GT", [13] = "LE", [14] = "AL", [15] = "NV"
}

local THUMB_CONDITIONS = {
    [0] = "EQ", [1] = "NE", [2] = "CS", [3] = "CC",
    [4] = "MI", [5] = "PL", [6] = "VS", [7] = "VC",
    [8] = "HI", [9] = "LS", [10] = "GE", [11] = "LT",
    [12] = "GT", [13] = "LE", [14] = "AL"
}

local function safe_read(data, pos, size)
    if not data then return false, "No data buffer" end
    if pos < 0 then return false, "Negative position" end
    if pos + size > #data then 
        return false, sf("Read beyond buffer: pos=%d, size=%d, buffer=%d", pos, size, #data)
    end
    return true
end

local function get_uint8(data, pos)
    local ok, err = safe_read(data, pos, 1)
    if not ok then return 0, err end
    return data:byte(pos + 1)
end

local function get_uint16(data, pos, little_endian)
    local ok, err = safe_read(data, pos, 2)
    if not ok then return 0, err end
    local b1, b2 = data:byte(pos + 1), data:byte(pos + 2)
    if little_endian then
        return b1 + b2 * 256
    else
        return b2 + b1 * 256
    end
end

local function get_uint32(data, pos, little_endian)
    local ok, err = safe_read(data, pos, 4)
    if not ok then return 0, err end
    local b1, b2, b3, b4 = data:byte(pos + 1), data:byte(pos + 2), data:byte(pos + 3), data:byte(pos + 4)
    if little_endian then
        return b1 + b2 * 256 + b3 * 65536 + b4 * 16777216
    else
        return b4 + b3 * 256 + b2 * 65536 + b1 * 16777216
    end
end

local StringBuffer = {
    new = function(self)
        return setmetatable({parts = {}, length = 0}, {__index = self})
    end,   
    append = function(self, str)
        table.insert(self.parts, str)
        self.length = self.length + #str
    end,    
    tostring = function(self)
        return table.concat(self.parts)
    end,   
    clear = function(self)
        self.parts = {}
        self.length = 0
    end
}

local function read_elf_file(fname)
    local f = io.open(fname, "rb")
    if not f then return nil, "Cannot open file: " .. fname end
    local data = f:read("*a")
    f:close()
    return data, nil
end

local function read_elf_header(data)
    if #data < 52 then return nil, "File too small for ELF header" end
    if data:sub(1, 4) ~= ELF_MAGIC then return nil, "Not an ELF file" end  
    local ei_data = get_uint8(data, 5)
    if ei_data ~= ELF_DATA_LITTLE and ei_data ~= ELF_DATA_BIG then
        return nil, "Invalid endianness"
    end
    local little_endian = (ei_data == ELF_DATA_LITTLE)    
    local hdr = {}
    hdr.ei_class = get_uint8(data, 4)
    hdr.ei_data = ei_data
    hdr.ei_version = get_uint8(data, 6)
    hdr.e_type = get_uint16(data, 16, little_endian)
    hdr.e_machine = get_uint16(data, 18, little_endian)
    hdr.e_version = get_uint32(data, 20, little_endian)
    hdr.e_entry = get_uint32(data, 24, little_endian)
    hdr.e_phoff = get_uint32(data, 28, little_endian)
    hdr.e_shoff = get_uint32(data, 32, little_endian)
    hdr.e_flags = get_uint32(data, 36, little_endian)
    hdr.e_ehsize = get_uint16(data, 40, little_endian)
    hdr.e_phentsize = get_uint16(data, 42, little_endian)
    hdr.e_phnum = get_uint16(data, 44, little_endian)
    hdr.e_shentsize = get_uint16(data, 46, little_endian)
    hdr.e_shnum = get_uint16(data, 48, little_endian)
    hdr.e_shstrndx = get_uint16(data, 50, little_endian)
    hdr.little_endian = little_endian
    hdr.is_pie = (hdr.e_type == ET_DYN)    
    return hdr, nil
end

local function read_program_headers(data, hdr)
    local phdrs = {}
    local phoff = hdr.e_phoff
    local phentsize = hdr.e_phentsize
    local phnum = hdr.e_phnum    
    if phoff == 0 or phnum == 0 then return phdrs end  
    for i = 0, phnum - 1 do
        local ph_offset = phoff + i * phentsize
        if not safe_read(data, ph_offset, phentsize) then break end        
        local ph = {}
        ph.p_type = get_uint32(data, ph_offset, hdr.little_endian)
        ph.p_offset = get_uint32(data, ph_offset + 4, hdr.little_endian)
        ph.p_vaddr = get_uint32(data, ph_offset + 8, hdr.little_endian)
        ph.p_paddr = get_uint32(data, ph_offset + 12, hdr.little_endian)
        ph.p_filesz = get_uint32(data, ph_offset + 16, hdr.little_endian)
        ph.p_memsz = get_uint32(data, ph_offset + 20, hdr.little_endian)
        ph.p_flags = get_uint32(data, ph_offset + 24, hdr.little_endian)
        ph.p_align = get_uint32(data, ph_offset + 28, hdr.little_endian)
        table.insert(phdrs, ph)
    end  
    return phdrs
end

local function get_string_from_table_fast(strtab, offset)
    if not strtab or offset < 0 or offset >= #strtab then
        return ""
    end    
    local i = offset + 1
    local start = i    
    while i <= #strtab and strtab:byte(i) ~= 0 do
        i = i + 1
    end    
    return strtab:sub(start, i - 1)
end

local function get_all_sections(data, hdr)
    local sections = {}
    local shstrndx = hdr.e_shstrndx    
    if shstrndx >= hdr.e_shnum then 
        return sections 
    end
    
    local shstrtab_offset = hdr.e_shoff + shstrndx * hdr.e_shentsize
    local ok, err = safe_read(data, shstrtab_offset, hdr.e_shentsize)
    if not ok then
        return sections
    end
    
    local shstrtab_sh_offset = get_uint32(data, shstrtab_offset + 16, hdr.little_endian)
    local shstrtab_sh_size = get_uint32(data, shstrtab_offset + 20, hdr.little_endian)    
    ok, err = safe_read(data, shstrtab_sh_offset, shstrtab_sh_size)
    if not ok then
        return sections
    end
    
    local strtab_data = data:sub(shstrtab_sh_offset + 1, shstrtab_sh_offset + shstrtab_sh_size)    
    for i = 0, hdr.e_shnum - 1 do
        local sh_offset = hdr.e_shoff + i * hdr.e_shentsize
        ok, err = safe_read(data, sh_offset, hdr.e_shentsize)
        if not ok then break end       
        local sh = {}
        sh.index = i
        sh.sh_name = get_uint32(data, sh_offset, hdr.little_endian)
        sh.sh_type = get_uint32(data, sh_offset + 4, hdr.little_endian)
        sh.sh_flags = get_uint32(data, sh_offset + 8, hdr.little_endian)
        sh.sh_addr = get_uint32(data, sh_offset + 12, hdr.little_endian)
        sh.sh_offset = get_uint32(data, sh_offset + 16, hdr.little_endian)
        sh.sh_size = get_uint32(data, sh_offset + 20, hdr.little_endian)
        sh.sh_link = get_uint32(data, sh_offset + 24, hdr.little_endian)
        sh.sh_info = get_uint32(data, sh_offset + 28, hdr.little_endian)
        sh.sh_addralign = get_uint32(data, sh_offset + 32, hdr.little_endian)
        sh.sh_entsize = get_uint32(data, sh_offset + 36, hdr.little_endian)
        sh.name = get_string_from_table_fast(strtab_data, sh.sh_name)        
        if sh.sh_type == SHT_PROGBITS then
            if (sh.sh_flags & SHF_EXECINSTR) ~= 0 then
                sh.category = "code"
            elseif (sh.sh_flags & SHF_ALLOC) ~= 0 then
                sh.category = (sh.sh_flags & SHF_WRITE) ~= 0 and "data" or "rodata"
            end
        elseif sh.sh_type == SHT_NOBITS then
            sh.category = "bss"
        elseif sh.sh_type == SHT_DYNSYM then
            sh.category = "dynsym"
        elseif sh.sh_type == SHT_STRTAB then
            sh.category = "strtab"
        else
            sh.category = "other"
        end
        table.insert(sections, sh)
    end
    return sections
end

local function get_symbols_with_pie(data, hdr, sections, load_bias)
    local symbols = {
        imports = {},
        exports = {},
        all = {},
        by_address = {},
        by_name = {},
        weak = {},
        absolute = {}
    }
    
    local dynsym_sec, dynstr_sec
    for _, sec in ipairs(sections) do
        if sec.sh_type == SHT_DYNSYM then
            dynsym_sec = sec
        elseif sec.sh_type == SHT_STRTAB and sec.name == ".dynstr" then
            dynstr_sec = sec
        end
    end    
    if not dynsym_sec or not dynstr_sec then
        return symbols
    end    
    local dynstr_data = data:sub(dynstr_sec.sh_offset + 1, dynstr_sec.sh_offset + dynstr_sec.sh_size)
    local entsize = dynsym_sec.sh_entsize
    if entsize == 0 then entsize = 16 end    
    local num_syms = math.floor(dynsym_sec.sh_size / entsize)   
    for i = 0, num_syms - 1 do
        local sym_offset = dynsym_sec.sh_offset + i * entsize
        local ok, err = safe_read(data, sym_offset, entsize)
        if not ok then break end       
        local st_name = get_uint32(data, sym_offset, hdr.little_endian)
        local st_value = get_uint32(data, sym_offset + 4, hdr.little_endian)
        local st_size = get_uint32(data, sym_offset + 8, hdr.little_endian)
        local st_info = get_uint8(data, sym_offset + 12)
        local st_other = get_uint8(data, sym_offset + 13)
        local st_shndx = get_uint16(data, sym_offset + 14, hdr.little_endian)        
        if st_name ~= 0 then
            local name = get_string_from_table_fast(dynstr_data, st_name)
            if name and #name > 0 then
                local st_type = st_info & 0xF
                local st_bind = (st_info >> 4) & 0xF           
                local adjusted_addr = st_value
                if st_shndx ~= 0 and st_shndx ~= 0xFFF1 and hdr.is_pie then
                    adjusted_addr = st_value + load_bias
                end
                
                local symbol_info = {
                    name = name,
                    address = adjusted_addr,
                    raw_address = st_value,
                    size = st_size,
                    type = st_type == STT_FUNC and "FUNC" or 
                           st_type == STT_OBJECT and "OBJECT" or 
                           st_type == STT_COMMON and "COMMON" or 
                           st_type == STT_TLS and "TLS" or "NOTYPE",
                    bind = st_bind == STB_GLOBAL and "GLOBAL" or 
                           st_bind == STB_WEAK and "WEAK" or "LOCAL",
                    section = st_shndx,
                    index = i,
                    is_import = (st_shndx == 0),
                    is_export = (st_shndx ~= 0 and st_shndx ~= 0xFFF1),
                    is_absolute = (st_shndx == 0xFFF1),
                    is_common = (st_type == STT_COMMON)
                }
                
                table.insert(symbols.all, symbol_info)
                symbols.by_address[adjusted_addr] = symbol_info
                symbols.by_name[name] = symbol_info
                
                if symbol_info.is_import then
                    table.insert(symbols.imports, symbol_info)
                elseif symbol_info.is_export then
                    table.insert(symbols.exports, symbol_info)
                end
                
                if symbol_info.bind == "WEAK" then
                    table.insert(symbols.weak, symbol_info)
                end                
                if symbol_info.is_absolute then
                    table.insert(symbols.absolute, symbol_info)
                end
            end
        end
    end
    return symbols
end

local function analyze_relocations_with_pie(data, hdr, sections, load_bias)
    local relocations = {}
    local relocations_by_symbol = {}
    local relocations_by_offset = {}
    local relative_relocs = {}    
    for _, sec in ipairs(sections) do
        if sec.sh_type == SHT_REL or sec.sh_type == SHT_RELA then
            local rel_sec = sec
            local symtab_idx = rel_sec.sh_link
            local strtab_idx = nil          
            if symtab_idx < #sections then
                local symtab_sec = sections[symtab_idx + 1]
                strtab_idx = symtab_sec.sh_link
            end
            
            if not strtab_idx or strtab_idx >= #sections then   end
            
            local symtab_sec = sections[symtab_idx + 1]
            local strtab_sec = sections[strtab_idx + 1]
            
            if not symtab_sec or not strtab_sec then  end
            
            local symtab_data = data:sub(symtab_sec.sh_offset + 1, symtab_sec.sh_offset + symtab_sec.sh_size)
            local strtab_data = data:sub(strtab_sec.sh_offset + 1, strtab_sec.sh_offset + strtab_sec.sh_size)
            local is_rela = (rel_sec.sh_type == SHT_RELA)
            local entsize = is_rela and 12 or 8
            
            local num_rels = math.floor(rel_sec.sh_size / entsize)
            
            for i = 0, num_rels - 1 do
                local rel_offset = rel_sec.sh_offset + i * entsize
                local ok, err = safe_read(data, rel_offset, entsize)
                if not ok then break end
                
                local r_offset = get_uint32(data, rel_offset, hdr.little_endian)
                local r_info = get_uint32(data, rel_offset + 4, hdr.little_endian)
                
                local sym_idx = r_info >> 8
                local r_type = r_info & 0xFF
                
                
                local adjusted_offset = r_offset
                if hdr.is_pie then
                    adjusted_offset = r_offset + load_bias
                end
                
                if sym_idx ~= 0 then
                    local sym_offset = symtab_sec.sh_offset + sym_idx * 16
                    ok, err = safe_read(data, sym_offset, 16)
                    if not ok then goto next_rel end
                    
                    local st_name = get_uint32(data, sym_offset, hdr.little_endian)
                    local name = get_string_from_table_fast(strtab_data, st_name)
                    
                    if name and #name > 0 then
                        local reloc_info = {
                            offset = adjusted_offset,
                            raw_offset = r_offset,
                            type = r_type,
                            type_name = ARM_RELOCATIONS[r_type] or sf("UNKNOWN(%d)", r_type),
                            symbol = name,
                            symbol_index = sym_idx,
                            addend = is_rela and get_uint32(data, rel_offset + 8, hdr.little_endian) or 0,
                            section = rel_sec.name,
                            is_relative = (r_type == 63) 
                        }
                        
                        table.insert(relocations, reloc_info)
                        relocations_by_offset[adjusted_offset] = reloc_info
                        
                        if not relocations_by_symbol[name] then
                            relocations_by_symbol[name] = {}
                        end
                        table.insert(relocations_by_symbol[name], reloc_info)
                        
                        if reloc_info.is_relative then
                            table.insert(relative_relocs, reloc_info)
                        end
                    end
                else
                    
                    if r_type == 63 then 
                        local reloc_info = {
                            offset = adjusted_offset,
                            raw_offset = r_offset,
                            type = r_type,
                            type_name = "R_ARM_RELATIVE",
                            symbol = "",
                            symbol_index = 0,
                            addend = is_rela and get_uint32(data, rel_offset + 8, hdr.little_endian) or 0,
                            section = rel_sec.name,
                            is_relative = true
                        }
                        table.insert(relocations, reloc_info)
                        table.insert(relative_relocs, reloc_info)
                        relocations_by_offset[adjusted_offset] = reloc_info
                    end
                end
                ::next_rel::
            end
        end
        
    end
    
    return relocations, relocations_by_symbol, relocations_by_offset, relative_relocs
end

local function decode_thumb_instruction_complete(word, addr, section_data, pos, little_endian)
    local hex = sf("%04X", word)
    
    
    local is_32bit = false
    if (word & 0xF800) == 0xF000 or (word & 0xF800) == 0xF800 then
        is_32bit = true
    end
    
    if is_32bit and pos + 2 < #section_data then
        local next_word = get_uint16(section_data, pos + 2, little_endian)
        local combined = (word << 16) | next_word
        
        
        if (word & 0xF800) == 0xF000 and (next_word & 0xD000) == 0xD000 then
            local S = (word >> 10) & 1
            local J1 = (next_word >> 13) & 1
            local J2 = (next_word >> 11) & 1
            local imm10 = word & 0x3FF
            local imm11 = next_word & 0x7FF
            
            
            local I1 = 1
            if J1 == S then I1 = 0 end
            
            local I2 = 1
            if J2 == S then I2 = 0 end
            

            local imm32 = (S << 24) | (I1 << 23) | (I2 << 22) | 
                         (imm10 << 12) | (imm11 << 1)
            

            if (imm32 & 0x01000000) ~= 0 then
                imm32 = imm32 | 0xFE000000
            end
            
            local target = (addr + 4) + imm32
            local instr = (next_word & 0x1000) == 0 and "BL" or "BLX"
            return sf("%s 0x%08X", instr, target), 4, "call"
        
        
        elseif (word & 0xFBF0) == 0xF240 then
            local i = (word >> 10) & 1
            local imm4 = (word >> 6) & 0xF
            local imm3 = (next_word >> 12) & 0x7
            local imm8 = next_word & 0xFF
            local rd = (next_word >> 8) & 0xF
            local imm16 = (i << 11) | (imm4 << 7) | (imm3 << 4) | imm8
            return sf("MOVW R%d, #0x%04X", rd, imm16), 4, "mov"
        
        elseif (word & 0xFBF0) == 0xF2C0 then
            local i = (word >> 10) & 1
            local imm4 = (word >> 6) & 0xF
            local imm3 = (next_word >> 12) & 0x7
            local imm8 = next_word & 0xFF
            local rd = (next_word >> 8) & 0xF
            local imm16 = (i << 11) | (imm4 << 7) | (imm3 << 4) | imm8
            return sf("MOVT R%d, #0x%04X", rd, imm16), 4, "mov"
        
        
        elseif (word & 0xF7F0) == 0xF850 then
            local u = (word >> 7) & 1
            local imm12 = ((word & 0x400) >> 1) | ((word & 0xF) << 8) | (next_word & 0xFF)
            local rt = (next_word >> 12) & 0xF
            local sign = u == 1 and "+" or "-"
            return sf("LDR R%d, [PC, %s#%d]", rt, sign, imm12), 4, "load"
        
        
        elseif (word & 0xFBFF) == 0xF2A0 then
            local i = (word >> 10) & 1
            local imm3 = (next_word >> 12) & 0x7
            local imm8 = next_word & 0xFF
            local rd = (next_word >> 8) & 0xF
            local imm12 = (i << 11) | (imm3 << 8) | imm8
            local target = (addr + 4) & 0xFFFFFFFC
            target = target + imm12
            return sf("ADR R%d, 0x%08X", rd, target), 4, "arith"
        end
    end
    
    
    if (word & 0xF000) == 0xD000 then
        
        local cond = (word >> 8) & 0xF
        local imm8 = word & 0xFF
        local offset = imm8 << 1
        if (offset & 0x100) ~= 0 then offset = offset | 0xFFFFFE00 end
        if cond < 14 then
            return sf("B.%s 0x%08X", THUMB_CONDITIONS[cond], addr + 4 + offset), 2, "branch"
        end
    
    elseif (word & 0xFF00) == 0xBD00 then
        
        local reg_list = word & 0xFF
        local regs = {}
        
        
        for i = 0, 7 do
            if (reg_list & (1 << i)) ~= 0 then
                table.insert(regs, sf("R%d", i))
            end
        end
        
        
        if (reg_list & 0x100) ~= 0 then
            table.insert(regs, "PC")
        end
        
        
        if (reg_list & 0x200) ~= 0 then
            table.insert(regs, "SB")
        end
        
        
        if (reg_list & 0x400) ~= 0 then
            table.insert(regs, "SL")
        end
        

        if (reg_list & 0x800) ~= 0 then
            table.insert(regs, "FP")
        end
        
        return "POP {" .. table.concat(regs, ", ") .. "}", 2, "pop"
    
    elseif (word & 0xFF00) == 0xB500 then
        
        local reg_list = word & 0xFF
        local regs = {}
        
        for i = 0, 7 do
            if (reg_list & (1 << i)) ~= 0 then
                table.insert(regs, sf("R%d", i))
            end
        end
        
        if (reg_list & 0x100) ~= 0 then table.insert(regs, "LR") end
        if (reg_list & 0x200) ~= 0 then table.insert(regs, "R9") end
        if (reg_list & 0x400) ~= 0 then table.insert(regs, "R10") end
        if (reg_list & 0x800) ~= 0 then table.insert(regs, "R11") end
        
        return "PUSH {" .. table.concat(regs, ", ") .. "}", 2, "push"
    
    elseif (word & 0xFF00) == 0x4700 then
       
        local rm = word & 0xF
        if rm == 14 then
            return "BX LR", 2, "return"
        else
            return sf("BX R%d", rm), 2, "branch"
        end
    
    elseif (word & 0xFF00) == 0x4600 then
        
        local rd = (word >> 8) & 0x7
        local rn = word & 0x7
        return sf("MOV R%d, R%d", rd, rn), 2, "mov"
    
    elseif (word & 0xF800) == 0x4800 then
        
        local rt = (word >> 8) & 0x7
        local imm8 = word & 0xFF
        local target_addr = (addr + 4) & 0xFFFFFFFC
        target_addr = target_addr + (imm8 * 4)
        return sf("LDR R%d, [PC, #%d] ; (PC=0x%08X)", rt, imm8 * 4, target_addr), 2, "load"
    
    elseif (word & 0xF800) == 0xA000 then
        
        local rd = (word >> 8) & 0x7
        local imm8 = word & 0xFF
        local target = (addr + 4) & 0xFFFFFFFC
        target = target + (imm8 * 4)
        return sf("ADR R%d, 0x%08X", rd, target), 2, "arith"
    
    elseif (word & 0xF800) == 0xE000 then
        local imm11 = word & 0x7FF
        local offset = imm11 << 1
        if (offset & 0x0800) ~= 0 then offset = offset | 0xFFFFF000 end
        return sf("B 0x%08X", addr + 4 + offset), 2, "branch"
    
    
    elseif (word & 0xFF00) == 0xBF00 then
        local firstcond = (word >> 4) & 0xF
        local mask = word & 0xF
        if mask ~= 0 then
            local cond_str = THUMB_CONDITIONS[firstcond] or "AL"
            return sf("IT%s", cond_str), 2, "it"
        end
    
    
    elseif (word & 0xF500) == 0xB100 then
        local i = (word >> 9) & 1
        local imm5 = (word >> 3) & 0x1F
        local rn = word & 0x7
        local offset = (i << 6) | (imm5 << 1)
        local op = (word & 0x800) == 0 and "CBZ" or "CBNZ"
        return sf("%s R%d, 0x%08X", op, rn, addr + 4 + offset), 2, "branch"
    
    else
        
        return sf("DCW 0x%04X", word), 2, "unknown"
    end
end

local function decode_arm_instruction_complete(word, addr, little_endian)
    local cond = (word >> 28) & 0xF
    local opcode = (word >> 21) & 0x7F
    local rn = (word >> 16) & 0xF
    local rd = (word >> 12) & 0xF
    local imm12 = word & 0xFFF
    
    local cond_str = (cond ~= 0xE) and ARM_CONDITIONS[cond] .. " " or ""
    
    
    if (word & 0x0FFFFFFF) == 0x012FFF1E then
        return "BX LR", 4, "return"
    elseif (word & 0x0FF000F0) == 0x01200010 then
        local rm = word & 0xF
        return sf("BX R%d", rm), 4, "branch"
    
    
    elseif (word & 0x0E000000) == 0x0A000000 then
        local imm24 = word & 0xFFFFFF
        local offset = imm24 << 2
        if (offset & 0x02000000) ~= 0 then offset = offset | 0xFC000000 end
        return sf("B%s 0x%08X", cond_str, addr + 8 + offset), 4, "branch"
    elseif (word & 0x0E000000) == 0x0B000000 then
        local imm24 = word & 0xFFFFFF
        local offset = imm24 << 2
        if (offset & 0x02000000) ~= 0 then offset = offset | 0xFC000000 end
        return sf("BL%s 0x%08X", cond_str, addr + 8 + offset), 4, "call"
    
    
    elseif (word & 0x0C000000) == 0x00000000 then
        local opcode = (word >> 21) & 0xF
        local s = (word >> 20) & 1
        local rm = word & 0xF
        
        local opcodes = {
            "AND", "EOR", "SUB", "RSB", "ADD", "ADC", "SBC", "RSC",
            "TST", "TEQ", "CMP", "CMN", "ORR", "MOV", "BIC", "MVN"
        }
        
        if opcode < 16 then
            local opname = opcodes[opcode + 1]
            
            if rd == 15 and opcode == 13 then
                return sf("MOV%s PC, LR", cond_str), 4, "return"
            elseif rd == 13 and rn == 13 and opcode == 4 then
                local imm = rm
                if s == 1 then imm = -imm end
                return sf("ADD%s SP, SP, #%d", cond_str, imm), 4, "arith"
            elseif opname == "MOV" or opname == "MVN" then
                return sf("%s%s R%d, R%d", opname, cond_str, rd, rm), 4, "mov"
            else
                return sf("%s%s R%d, R%d, R%d", opname, cond_str, rd, rn, rm), 4, "arith"
            end
        end
    
    
    elseif (word & 0x0E000000) == 0x04000000 then
        local p = (word >> 24) & 1
        local u = (word >> 23) & 1
        local b = (word >> 22) & 1
        local w = (word >> 21) & 1
        local l = (word >> 20) & 1
        local imm12 = word & 0xFFF
        
        local sign = u == 1 and "+" or "-"
        local addr_mode
        
        if p == 1 then
            addr_mode = sf("[R%d, %s#%d]", rn, sign, imm12)
            if w == 1 then
                addr_mode = sf("[R%d, %s#%d]!", rn, sign, imm12)
            end
        else
            addr_mode = sf("[R%d], %s#%d", rn, sign, imm12)
        end
        
        if l == 1 then
            if b == 1 then
                return sf("LDRB%s R%d, %s", cond_str, rd, addr_mode), 4, "load"
            else
                return sf("LDR%s R%d, %s", cond_str, rd, addr_mode), 4, "load"
            end
        else
            if b == 1 then
                return sf("STRB%s R%d, %s", cond_str, rd, addr_mode), 4, "store"
            else
                return sf("STR%s R%d, %s", cond_str, rd, addr_mode), 4, "store"
            end
        end
    
    
    elseif (word & 0x0F000000) == 0x03000000 then
        if (word & 0x00000010) == 0x00000010 then
            local op = (word >> 21) & 0x7
            local imm4h = (word >> 16) & 0xF
            local imm4l = word & 0xF
            local imm16 = (imm4h << 4) | imm4l
            local rd = (word >> 12) & 0xF
            
            if op == 0x4 then
                return sf("MOVW%s R%d, #0x%04X", cond_str, rd, imm16), 4, "mov"
            elseif op == 0x6 then
                return sf("MOVT%s R%d, #0x%04X", cond_str, rd, imm16), 4, "mov"
            end
        end
    
    else
        return sf("DCD 0x%08X", word), 4, "unknown"
    end
end

local FunctionDetector = {
    new = function(self)
        return setmetatable({
            functions = {},
            function_map = {},
            call_sites = {},
            thresholds = {
                max_function_size = 0x10000,
                min_function_size = 4,
                search_ahead = 0x1000,
                confidence_threshold = 0.7
            }
        }, {__index = self})
    end,
    
    detect_from_symbols = function(self, symbols)
        for _, sym in ipairs(symbols.all) do
            if sym.type == "FUNC" and sym.address > 0 then
                local func = {
                    start = sym.address,
                    size = sym.size or 0,
                    name = sym.name,
                    confidence = 1.0,  
                    source = "symbol",
                    type = (sym.address & 1) == 1 and "thumb" or "arm"
                }
                self.function_map[sym.address] = func
                table.insert(self.functions, func)
            end
        end
    end,
    
    detect_from_patterns = function(self, sections, data, little_endian)
        for _, sec in ipairs(sections) do
            if sec.category == "code" then
                local is_thumb = (sec.sh_addr & 1) == 1
                local base_addr = is_thumb and (sec.sh_addr & ~1) or sec.sh_addr
                local sec_data = data:sub(sec.sh_offset + 1, sec.sh_offset + sec.sh_size)
                
                local pos = 0
                while pos < #sec_data do
                    local addr = base_addr + pos
                    
                    
                    if not self.function_map[addr] then
                        local is_func_start = false
                        local confidence = 0.0
                        
                        if is_thumb then
                            if pos + 1 < #sec_data then
                                local word = get_uint16(sec_data, pos, little_endian)
                                
                                
                                if (word & 0xFE00) == 0xB400 then
                                    confidence = 0.8
                                    is_func_start = true
                                
                                
                                elseif (word & 0xFF80) == 0xB080 then
                                    local imm7 = word & 0x7F
                                    if imm7 >= 16 then  
                                        confidence = 0.7
                                        is_func_start = true
                                    end
                                end
                            end
                        else
                            if pos + 3 < #sec_data then
                                local word = get_uint32(sec_data, pos, little_endian)
                                
                                
                                if (word & 0xFFFF0000) == 0xE92D0000 then
                                    local reglist = word & 0xFFFF
                                    if (reglist & 0x4000) ~= 0 then  
                                        confidence = 0.9
                                        is_func_start = true
                                    end
                                
                                
                                elseif (word & 0xFFF00000) == 0xE2400000 then
                                    local imm12 = word & 0xFFF
                                    if imm12 >= 0x100 then  
                                        confidence = 0.7
                                        is_func_start = true
                                    end
                                end
                            end
                        end
                        
                        if is_func_start and confidence >= self.thresholds.confidence_threshold then
                            
                            local func_end = self:find_function_end(sec, base_addr, pos, is_thumb, data, little_endian)
                            
                            if func_end > pos then
                                local func = {
                                    start = addr,
                                    size = func_end - pos,
                                    name = sf("sub_%08X", addr),
                                    confidence = confidence,
                                    source = "pattern",
                                    type = is_thumb and "thumb" or "arm",
                                    section = sec.name
                                }
                                self.function_map[addr] = func
                                table.insert(self.functions, func)
                                
                                
                                pos = func_end
                            end
                        end
                    end
                    
                    
                    if is_thumb then
                        pos = pos + 2
                    else
                        pos = pos + 4
                    end
                end
            end
        end
    end,
    
    find_function_end = function(self, sec, base_addr, start_pos, is_thumb, data, little_endian)
        local sec_data = data:sub(sec.sh_offset + 1, sec.sh_offset + sec.sh_size)
        local max_search = math.min(start_pos + self.thresholds.search_ahead, #sec_data)
        local pos = start_pos
        
        while pos < max_search do
            local instr_addr = base_addr + pos
            
            if is_thumb then
                if pos + 1 >= #sec_data then break end
                local word = get_uint16(sec_data, pos, little_endian)
                
                
                if word == 0x4770 then  
                    return pos + 2
                elseif (word & 0xFF00) == 0xBD00 then  
                    return pos + 2
                elseif (word & 0xFF00) == 0x4700 then  
                    local rm = word & 0xF
                    if rm >= 8 then  
                        return pos + 2
                    end
                end
                pos = pos + 2
            else
                if pos + 3 >= #sec_data then break end
                local word = get_uint32(sec_data, pos, little_endian)
                
            
                if (word & 0x0FFFFFFF) == 0x012FFF1E then  
                    return pos + 4
                elseif (word & 0xFFF000F0) == 0xE8BD0000 then  
                    return pos + 4
                end
                pos = pos + 4
            end
        end
        
        
        return math.min(start_pos + self.thresholds.max_function_size, #sec_data)
    end,
    
    get_functions = function(self)
        table.sort(self.functions, function(a, b) return a.start < b.start end)
        return self.functions
    end
}

local ElfAnalyzer = {
    new = function(self)
        local obj = {
            data = nil,
            header = nil,
            phdrs = {},
            sections = {},
            symbols = {},
            relocations = {},
            relocations_by_symbol = {},
            relocations_by_offset = {},
            relative_relocs = {},
            functions = {},
            xrefs = {},
            load_bias = 0,
            filename = nil,
            analysis_time = 0
        }
        setmetatable(obj, { __index = self })
        return obj
    end,
    
    load = function(self, filename)
        local start_time = os.clock()
        
        
        local data, err = read_elf_file(filename)
        if not data then
            return false, err
        end
        
        
        local header, err = read_elf_header(data)
        if not header then
            return false, err
        end
        
        if header.e_machine ~= EM_ARM then
            return false, sf("Not an ARM32 ELF file (Machine type: %d)", header.e_machine)
        end
        
        
        local phdrs = read_program_headers(data, header)
        

        local load_bias = 0
        if header.is_pie then
            
            for _, ph in ipairs(phdrs) do
                if ph.p_type == 1 and ph.p_vaddr > 0 then  
                    load_bias = -ph.p_vaddr
                    break
                end
            end
        end
        
        
        local sections = get_all_sections(data, header)
        
        
        local symbols = get_symbols_with_pie(data, header, sections, load_bias)
        
        
        local relocations, relocations_by_symbol, relocations_by_offset, relative_relocs = 
            analyze_relocations_with_pie(data, header, sections, load_bias)
        
        
        local detector = FunctionDetector:new()
        detector:detect_from_symbols(symbols)
        detector:detect_from_patterns(sections, data, header.little_endian)
        local functions = detector:get_functions()
        
        
        local xrefs = self:build_xrefs(relocations, symbols)
        
        
        self.data = data
        self.header = header
        self.phdrs = phdrs
        self.sections = sections
        self.symbols = symbols
        self.relocations = relocations
        self.relocations_by_symbol = relocations_by_symbol
        self.relocations_by_offset = relocations_by_offset
        self.relative_relocs = relative_relocs
        self.functions = functions
        self.xrefs = xrefs
        self.load_bias = load_bias
        self.filename = filename
        self.analysis_time = os.clock() - start_time
        
        return true, nil
    end,
    
    build_xrefs = function(self, relocations, symbols)
        local xrefs = {
            calls = {},
            data_refs = {},
            by_target = {},
            by_source = {},
            count = 0
        }
        
        
        local addr_by_name = {}
        for name, sym in pairs(symbols.by_name) do
            addr_by_name[name] = sym.address
        end
        
        
        for _, rel in ipairs(relocations) do
            if rel.symbol and rel.symbol ~= "" then
                local target_addr = addr_by_name[rel.symbol]
                if target_addr then
                    local target_sym = symbols.by_name[rel.symbol]
                    local xref_type = target_sym.type == "FUNC" and "call" or "data_ref"
                    
                    local xref = {
                        from = rel.offset,
                        to = target_addr,
                        symbol = rel.symbol,
                        type = rel.type_name,
                        rel_type = xref_type,
                        section = rel.section
                    }
                    
                    if xref_type == "call" then
                        table.insert(xrefs.calls, xref)
                    else
                        table.insert(xrefs.data_refs, xref)
                    end
                    
                    if not xrefs.by_target[target_addr] then
                        xrefs.by_target[target_addr] = {}
                    end
                    table.insert(xrefs.by_target[target_addr], xref)
                    
                    if not xrefs.by_source[rel.offset] then
                        xrefs.by_source[rel.offset] = {}
                    end
                    table.insert(xrefs.by_source[rel.offset], xref)
                    
                    xrefs.count = xrefs.count + 1
                end
            end
        end
        
        return xrefs
    end,
    
    get_info = function(self)
        local info = {}
        info.filename = self.filename:match("[^/]+$")
        info.machine = "ARM32"
        info.type = self.header.e_type == ET_DYN and "PIE/DYN" or "EXEC"
        info.endianness = self.header.little_endian and "Little" or "Big"
        info.entry_point = sf("0x%08X", self.header.e_entry)
        info.load_bias = sf("0x%08X", self.load_bias)
        info.sections = #self.sections
        info.exports = #self.symbols.exports
        info.imports = #self.symbols.imports
        info.weak_symbols = #self.symbols.weak
        info.relocations = #self.relocations
        info.relative_relocs = #self.relative_relocs
        info.functions = #self.functions
        info.xrefs = self.xrefs.count
        info.analysis_time = sf("%.3f", self.analysis_time)
        
        
        local cats = {code = 0, data = 0, rodata = 0, bss = 0, other = 0}
        for _, sec in ipairs(self.sections) do
            if sec.category then
                cats[sec.category] = (cats[sec.category] or 0) + 1
            else
                cats.other = cats.other + 1
            end
        end
        
        info.code_sections = cats.code
        info.data_sections = cats.data
        info.rodata_sections = cats.rodata
        info.bss_sections = cats.bss
        
        return info
    end
}
local function chooseElfFile()
    local info = gg.prompt({
        "Select ELF file (.so, .elf):"
    }, info, {
        "file"
    })
    
    if info and #info > 0 then
        gg.saveVariable(info, g.config)
        g.last = info[1]
        return info[1]
    end
    
    return nil
end

local function show_analysis_summary(analyzer)
    local info = analyzer:get_info()
    local buf = StringBuffer:new()
    
    buf:append("ELF Analysis Summary\n")
    buf:append("=" .. string.rep("=", 50) .. "\n\n")
    
    local categories = {
        {"File", info.filename},
        {"Type", info.type},
        {"Machine", info.machine},
        {"Endianness", info.endianness},
        {"Entry Point", info.entry_point},
        {"Load Bias", info.load_bias},
        {"", ""},
        {"Sections", info.sections},
        {"  Code", info.code_sections},
        {"  Data", info.data_sections},
        {"  Read-only", info.rodata_sections},
        {"  BSS", info.bss_sections},
        {"", ""},
        {"Symbols", info.exports + info.imports},
        {"  Exports", info.exports},
        {"  Imports", info.imports},
        {"  Weak", info.weak_symbols},
        {"", ""},
        {"Relocations", info.relocations},
        {"  Relative", info.relative_relocs},
        {"", ""},
        {"Functions", info.functions},
        {"XRefs", info.xrefs},
        {"", ""},
        {"Analysis Time", info.analysis_time .. "s"}
    }
    
    for _, item in ipairs(categories) do
        if item[1] == "" then
            buf:append("\n")
        else
            buf:append(sf("%-20s: %s\n", item[1], item[2]))
        end
    end
    
    gg.alert(buf:tostring())
end

local function main()
    local analyzer = nil
    
    while true do
        local options = {
            "Load ELF File",
            "Show Analysis Summary",
            "View Sections",
            "View Symbols",
            "View Functions",
            "View Relocations",
            "Generate Assembly Dump",
            "Extract Strings",
            "Advanced Analysis",
            "Exit"
        }
        
        if not analyzer then
            for i = 2, #options - 1 do
                options[i] = nil
            end
        end
        
        local choice = gg.choice(options, nil, "ARM32 ELF Analyzer v3.0")
        if not choice then break end
        
        if choice == 1 then
            local fname = chooseElfFile()
            if fname then
                analyzer = ElfAnalyzer:new()
                local success, err = analyzer:load(fname)
                if success then
                    gg.alert("ELF file loaded successfully\nAnalysis completed in " .. 
                            sf("%.3f", analyzer.analysis_time) .. " seconds")
                else
                    gg.alert("Error loading ELF:\n" .. (err or "Unknown error"))
                    analyzer = nil
                end
            end
            
        elseif choice == 2 and analyzer then
            show_analysis_summary(analyzer)
            
        elseif choice == 3 and analyzer then
            local sections_info = {}
            for _, sec in ipairs(analyzer.sections) do
                table.insert(sections_info, sf("%-20s 0x%08X 0x%08X %s", 
                    sec.name, sec.sh_addr, sec.sh_size, sec.category or "unknown"))
            end
            
            local text = "Sections:\n\n"
            for i, info in ipairs(sections_info) do
                text = text .. info .. "\n"
                if i >= 30 then
                    text = text .. sf("\n... and %d more sections", #sections_info - 30)
                    break
                end
            end
            
            gg.alert(text)
            
        elseif choice == 4 and analyzer then
            local buf = StringBuffer:new()
            buf:append("Symbols Report\n")
            buf:append("=" .. string.rep("=", 60) .. "\n\n")
            
            buf:append(sf("Exports: %d\n", #analyzer.symbols.exports))
            for i, sym in ipairs(analyzer.symbols.exports) do
                if i <= 25 then
                    buf:append(sf("  0x%08X %-40s %-8s %s\n", 
                        sym.address, sym.name, sym.type, sym.bind))
                end
            end
            if #analyzer.symbols.exports > 25 then
                buf:append(sf("  ... and %d more exports\n\n", #analyzer.symbols.exports - 25))
            else
                buf:append("\n")
            end
            
            buf:append(sf("Imports: %d\n", #analyzer.symbols.imports))
            for i, sym in ipairs(analyzer.symbols.imports) do
                if i <= 25 then
                    buf:append(sf("  %-50s %-8s %s\n", sym.name, sym.type, sym.bind))
                end
            end
            if #analyzer.symbols.imports > 25 then
                buf:append(sf("  ... and %d more imports\n", #analyzer.symbols.imports - 25))
            end
            
            gg.alert(buf:tostring())
            
        elseif choice == 5 and analyzer then
            local buf = StringBuffer:new()
            buf:append("Detected Functions\n")
            buf:append("=" .. string.rep("=", 60) .. "\n\n")
            
            local funcs_by_type = {arm = 0, thumb = 0}
            for _, func in ipairs(analyzer.functions) do
                funcs_by_type[func.type] = (funcs_by_type[func.type] or 0) + 1
            end
            
            buf:append(sf("Total: %d functions (ARM: %d, Thumb: %d)\n\n", 
                #analyzer.functions, funcs_by_type.arm, funcs_by_type.thumb))
            
            for i, func in ipairs(analyzer.functions) do
                if i <= 30 then
                    local name = func.name or sf("sub_%08X", func.start)
                    local source = func.source or "unknown"
                    buf:append(sf("  0x%08X %-40s 0x%04X %-6s %-8s\n", 
                        func.start, name, func.size, func.type, source))
                end
            end
            if #analyzer.functions > 30 then
                buf:append(sf("\n... and %d more functions", #analyzer.functions - 30))
            end
            
            gg.alert(buf:tostring())
            
        elseif choice == 6 and analyzer then
            local buf = StringBuffer:new()
            buf:append("Relocations\n")
            buf:append("=" .. string.rep("=", 60) .. "\n\n")
            
            buf:append(sf("Total: %d relocations\n", #analyzer.relocations))
            buf:append(sf("Relative: %d\n\n", #analyzer.relative_relocs))
            
            
            local types = {}
            for _, rel in ipairs(analyzer.relocations) do
                types[rel.type_name] = (types[rel.type_name] or 0) + 1
            end
            
            buf:append("By type:\n")
            for tname, count in pairs(types) do
                buf:append(sf("  %-30s: %d\n", tname, count))
            end
            
            buf:append("\nFirst 20 relocations:\n")
            for i = 1, math.min(20, #analyzer.relocations) do
                local rel = analyzer.relocations[i]
                if rel.symbol and rel.symbol ~= "" then
                    buf:append(sf("  0x%08X -> %-40s (%s)\n", 
                        rel.offset, rel.symbol, rel.type_name))
                else
                    buf:append(sf("  0x%08X %s\n", rel.offset, rel.type_name))
                end
            end
            
            gg.alert(buf:tostring())
            
        elseif choice == 7 and analyzer then
            local output_file = "/sdcard/" .. analyzer.filename:match("[^/]+$") .. "_dump.asm"
            
            
            local out = io.open(output_file, "w")
            if out then
                out:write(sf("; ELF Analysis Dump - %s\n", analyzer.filename))
                out:write(sf("; Generated by ARM32 ELF Analyzer v3.0\n"))
                out:write(sf("; PIE: %s, Load Bias: 0x%08X\n\n", 
                    analyzer.header.is_pie and "Yes" or "No", analyzer.load_bias))
                
                
                if #analyzer.symbols.exports > 0 then
                    out:write("; === EXPORTS ===\n")
                    for _, sym in ipairs(analyzer.symbols.exports) do
                        out:write(sf("%-40s EQU 0x%08X\n", sym.name, sym.address))
                    end
                    out:write("\n")
                end
                
                out:close()
                gg.alert("Assembly dump saved to:\n" .. output_file)
            else
                gg.alert("Cannot create output file")
            end
            
        elseif choice == 8 and analyzer then
            
            local strings = {}
            for _, sec in ipairs(analyzer.sections) do
                if sec.category == "rodata" or sec.category == "data" then
                    local sec_data = analyzer.data:sub(sec.sh_offset + 1, sec.sh_offset + sec.sh_size)
                    local current = ""
                    
                    for i = 1, #sec_data do
                        local b = sec_data:byte(i)
                        if b >= 32 and b <= 126 then
                            current = current .. string.char(b)
                        else
                            if #current >= 4 then
                                table.insert(strings, {
                                    addr = sec.sh_addr + i - #current - 1,
                                    str = current,
                                    section = sec.name
                                })
                            end
                            current = ""
                        end
                    end
                end
            end
            
            if #strings > 0 then
                local output_file = "/sdcard/" .. analyzer.filename:match("[^/]+$") .. "_strings.txt"
                local out = io.open(output_file, "w")
                if out then
                    out:write("Extracted Strings\n")
                    out:write("=" .. string.rep("=", 60) .. "\n\n")
                    
                    for _, s in ipairs(strings) do
                        out:write(sf("0x%08X [%s]: %s\n", s.addr, s.section, s.str))
                    end
                    
                    out:close()
                    gg.alert(sf("Found %d strings\nSaved to: %s", #strings, output_file))
                end
            else
                gg.alert("No strings found")
            end
            
        elseif choice == 9 and analyzer then
            local advanced_options = {
                "View PIE Information",
                "View Weak Symbols",
                "View Absolute Symbols",
                "View XRef Graph",
                "Back"
            }
            
            local adv_choice = gg.choice(advanced_options, nil, "Advanced Analysis")
            
            if adv_choice == 1 then
                local buf = StringBuffer:new()
                buf:append("PIE Analysis\n")
                buf:append("=" .. string.rep("=", 60) .. "\n\n")
                
               -- buf:append(sf("Is PIE: %s\n", analyzer.header.is_pie and "Yes" : "No"))
                buf:append(sf("Load Bias: 0x%08X\n", analyzer.load_bias))
                buf:append(sf("Entry Point (raw): 0x%08X\n", analyzer.header.e_entry))
                buf:append(sf("Entry Point (adjusted): 0x%08X\n\n", 
                    analyzer.header.e_entry + analyzer.load_bias))
                
                buf:append("Relative Relocations: " .. #analyzer.relative_relocs .. "\n")
                if #analyzer.relative_relocs > 0 then
                    buf:append("First 10:\n")
                    for i = 1, math.min(10, #analyzer.relative_relocs) do
                        local rel = analyzer.relative_relocs[i]
                        buf:append(sf("  0x%08X (raw: 0x%08X) +0x%08X\n", 
                            rel.offset, rel.raw_offset, rel.addend))
                    end
                end
                
                gg.alert(buf:tostring())
                
            elseif adv_choice == 2 then
                if #analyzer.symbols.weak > 0 then
                    local buf = StringBuffer:new()
                    buf:append("Weak Symbols\n")
                    buf:append("=" .. string.rep("=", 60) .. "\n\n")
                    
                    for _, sym in ipairs(analyzer.symbols.weak) do
                        buf:append(sf("%-40s 0x%08X %s\n", sym.name, sym.address, sym.type))
                    end
                    
                    gg.alert(buf:tostring())
                else
                    gg.alert("No weak symbols found")
                end
                
            elseif adv_choice == 3 then
                if #analyzer.symbols.absolute > 0 then
                    local buf = StringBuffer:new()
                    buf:append("Absolute Symbols\n")
                    buf:append("=" .. string.rep("=", 60) .. "\n\n")
                    
                    for _, sym in ipairs(analyzer.symbols.absolute) do
                        buf:append(sf("%-40s 0x%08X %s\n", sym.name, sym.address, sym.type))
                    end
                    
                    gg.alert(buf:tostring())
                else
                    gg.alert("No absolute symbols found")
                end
                
            elseif adv_choice == 4 then
                if analyzer.xrefs.count > 0 then
                    local buf = StringBuffer:new()
                    buf:append("Cross-References\n")
                    buf:append("=" .. string.rep("=", 60) .. "\n\n")
                    
                    buf:append(sf("Total: %d xrefs\n", analyzer.xrefs.count))
                    buf:append(sf("Calls: %d\n", #analyzer.xrefs.calls))
                    buf:append(sf("Data refs: %d\n\n", #analyzer.xrefs.data_refs))
                                    local ref_counts = {}
                    for _, xref in ipairs(analyzer.xrefs.calls) do
                        ref_counts[xref.symbol] = (ref_counts[xref.symbol] or 0) + 1
                    end                
                    local sorted = {}
                    for sym, count in pairs(ref_counts) do
                        table.insert(sorted, {sym = sym, count = count})                   end
                    
                    table.sort(sorted, function(a, b) return a.count > b.count end)                   
                    buf:append("Most called functions:\n")
                    for i = 1, math.min(10, #sorted) do
                        buf:append(sf("  %-40s: %d calls\n", sorted[i].sym, sorted[i].count))
                    end
                    
                    gg.alert(buf:tostring())
                else
                    gg.alert("No cross-references found")
                end
            end           
        elseif choice == 10 then
            break
        end
    end
end

if gg.isVisible(true) then
    gg.setVisible(false)
end

main()