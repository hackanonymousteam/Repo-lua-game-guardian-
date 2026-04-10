local bit = require("bit32")
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
local ELF_DATA_LITTLE = 1
local ELF_DATA_BIG = 2
local EM_ARM = 40

local ET = {
    NONE = 0,
    REL = 1,
    EXEC = 2,
    DYN = 3,
    CORE = 4
}

local SHN = {
    UNDEF = 0,
    ABS = 0xFFF1,
    LORESERVE = 0xFF00,
    HIOS = 0xFF1F,
    LOPROC = 0xFF00,
    HIPROC = 0xFF1F,
    LOOS = 0xFF20,
    HIOS = 0xFF3F,
    HIRESERVE = 0xFFFF
}

local SHT = {
    NULL = 0,
    PROGBITS = 1,
    SYMTAB = 2,
    STRTAB = 3,
    RELA = 4,
    HASH = 5,
    DYNAMIC = 6,
    NOTE = 7,
    NOBITS = 8,
    REL = 9,
    SHLIB = 10,
    DYNSYM = 11,
    INIT_ARRAY = 14,
    FINI_ARRAY = 15,
    PREINIT_ARRAY = 16,
    GROUP = 17,
    SYMTAB_SHNDX = 18,
    NUM = 19
}

local SHF = {
    WRITE = 0x1,
    ALLOC = 0x2,
    EXECINSTR = 0x4,
    MERGE = 0x10,
    STRINGS = 0x20,
    INFO_LINK = 0x40,
    LINK_ORDER = 0x80,
    OS_NONCONFORMING = 0x100,
    GROUP = 0x200,
    TLS = 0x400
}

local STT = {
    NOTYPE = 0,
    OBJECT = 1,
    FUNC = 2,
    SECTION = 3,
    FILE = 4,
    COMMON = 5,
    TLS = 6,
    NUM = 7,
    LOOS = 10,
    HIOS = 12,
    LOPROC = 13,
    HIPROC = 15
}

local STB = {
    LOCAL = 0,
    GLOBAL = 1,
    WEAK = 2,
    NUM = 3,
    LOOS = 10,
    HIOS = 12,
    LOPROC = 13,
    HIPROC = 15
}

local function getFileSize(fname)
    local f = io.open(fname, "rb")
    if not f then return 0 end
    f:seek("end")
    local size = f:seek()
    f:close()
    return size
end

local function safe_read(data, pos, size)
    if not data then return false, "No data buffer" end
    if pos < 0 then return false, "Negative position" end
    if pos + size > #data then
        return false, sf("Read beyond buffer: pos=%d, size=%d, buffer=%d", pos, size, #data)
    end
    return true, nil
end

local function get_uint8(data, pos)
    local ok, err = safe_read(data, pos, 1)
    if not ok then return 0, err end
    return data:byte(pos + 1), nil
end

local function get_uint16(data, pos, little_endian)
    local ok, err = safe_read(data, pos, 2)
    if not ok then return 0, err end
    local b1, b2 = data:byte(pos + 1), data:byte(pos + 2)
    if little_endian then
        return b1 + b2 * 256, nil
    else
        return b2 + b1 * 256, nil
    end
end

local function get_uint32(data, pos, little_endian)
    local ok, err = safe_read(data, pos, 4)
    if not ok then return 0, err end
    local b1, b2, b3, b4 = data:byte(pos + 1), data:byte(pos + 2), data:byte(pos + 3), data:byte(pos + 4)
    if little_endian then
        return b1 + b2 * 256 + b3 * 65536 + b4 * 16777216, nil
    else
        return b4 + b3 * 256 + b2 * 65536 + b1 * 16777216, nil
    end
end

local function read_elf_file(fname)
    local f = io.open(fname, "rb")
    if not f then return nil, "Cannot open file: " .. fname end
    local data = f:read("*a")
    f:close()
    return data, nil
end

local ElfAnalyzer = {}
ElfAnalyzer.__index = ElfAnalyzer

function ElfAnalyzer.new(fname)
    local self = setmetatable({}, ElfAnalyzer)
    self.fname = fname
    self.file_size = getFileSize(fname)
    self.data = nil
    self.sections = {}
    self.segments = {}
    self.symbols = {}
    self.functions = {}
    self.load_bias = 0
    self.text_base = 0
    return self
end

function ElfAnalyzer:parse()
    self.data, err = read_elf_file(self.fname)
    if not self.data then
        return false, err
    end

    if #self.data < 52 then  
        return false, "File too small for ELF header"  
    end  
    
    if self.data:sub(1, 4) ~= ELF_MAGIC then  
        return false, "Not an ELF file"  
    end  
    
    self.ei_magic = self.data:sub(1, 4)  
    self.ei_class = self.data:byte(5)  
    self.ei_data = self.data:byte(6)  
    self.ei_version = self.data:byte(7)  
    self.ei_osabi = self.data:byte(8)  
    self.ei_abiversion = self.data:byte(9)  
    
    if self.ei_class ~= ELF_CLASS_32 then  
        return false, "Only ELF32 is supported"  
    end  
    
    if self.ei_data ~= ELF_DATA_LITTLE and self.ei_data ~= ELF_DATA_BIG then  
        return false, "Invalid data encoding"  
    end  
    
    self.little_endian = (self.ei_data == ELF_DATA_LITTLE)  
    
    self.e_type, err = get_uint16(self.data, 16, self.little_endian)  
    if err then return false, "Failed to read e_type: " .. err end  
    
    self.e_machine, err = get_uint16(self.data, 18, self.little_endian)  
    if err then return false, "Failed to read e_machine: " .. err end  
    
    self.e_version, err = get_uint32(self.data, 20, self.little_endian)  
    if err then return false, "Failed to read e_version: " .. err end  
    
    self.e_entry, err = get_uint32(self.data, 24, self.little_endian)  
    if err then return false, "Failed to read e_entry: " .. err end  
    
    self.e_phoff, err = get_uint32(self.data, 28, self.little_endian)  
    if err then return false, "Failed to read e_phoff: " .. err end  
    
    self.e_shoff, err = get_uint32(self.data, 32, self.little_endian)  
    if err then return false, "Failed to read e_shoff: " .. err end  
    
    self.e_flags, err = get_uint32(self.data, 36, self.little_endian)  
    if err then return false, "Failed to read e_flags: " .. err end  
    
    self.e_ehsize, err = get_uint16(self.data, 40, self.little_endian)  
    if err then return false, "Failed to read e_ehsize: " .. err end  
    
    self.e_phentsize, err = get_uint16(self.data, 42, self.little_endian)  
    if err then return false, "Failed to read e_phentsize: " .. err end  
    
    self.e_phnum, err = get_uint16(self.data, 44, self.little_endian)  
    if err then return false, "Failed to read e_phnum: " .. err end  
    
    self.e_shentsize, err = get_uint16(self.data, 46, self.little_endian)  
    if err then return false, "Failed to read e_shentsize: " .. err end  
    
    self.e_shnum, err = get_uint16(self.data, 48, self.little_endian)  
    if err then return false, "Failed to read e_shnum: " .. err end  
    
    self.e_shstrndx, err = get_uint16(self.data, 50, self.little_endian)  
    if err then return false, "Failed to read e_shstrndx: " .. err end  
    
    if self.e_machine ~= EM_ARM then  
        return false, sf("Not an ARM32 ELF file (Machine type: %d)", self.e_machine)  
    end  
    
    self.is_pie = (self.e_type == ET.DYN)  
    
    local ok, err2 = self:loadSegments()  
    if not ok then return false, err2 end  
    
    if self.is_pie then  
        self:calculateLoadBias()  
    end  
    
    local ok, err2 = self:loadSections()  
    if not ok then return false, err2 end  
    
    local ok, err2 = self:loadSymbols()  
    if not ok then return false, err2 end  
    
    self:detectFunctions()  
    
    return true, nil
end

function ElfAnalyzer:loadSegments()
    if self.e_phnum == 0 then return true, nil end

    for i = 0, self.e_phnum - 1 do  
        local ph_offset = self.e_phoff + i * self.e_phentsize  
        local ok, err = safe_read(self.data, ph_offset, self.e_phentsize)  
        if not ok then break end  
          
        local p_type, err = get_uint32(self.data, ph_offset, self.little_endian)  
        if err then return false, "Failed to read p_type: " .. err end  
          
        local p_offset, err = get_uint32(self.data, ph_offset + 4, self.little_endian)  
        if err then return false, "Failed to read p_offset: " .. err end  
          
        local p_vaddr, err = get_uint32(self.data, ph_offset + 8, self.little_endian)  
        if err then return false, "Failed to read p_vaddr: " .. err end  
          
        local p_paddr, err = get_uint32(self.data, ph_offset + 12, self.little_endian)  
        if err then return false, "Failed to read p_paddr: " .. err end  
          
        local p_filesz, err = get_uint32(self.data, ph_offset + 16, self.little_endian)  
        if err then return false, "Failed to read p_filesz: " .. err end  
          
        local p_memsz, err = get_uint32(self.data, ph_offset + 20, self.little_endian)  
        if err then return false, "Failed to read p_memsz: " .. err end  
          
        local p_flags, err = get_uint32(self.data, ph_offset + 24, self.little_endian)  
        if err then return false, "Failed to read p_flags: " .. err end  
          
        local p_align, err = get_uint32(self.data, ph_offset + 28, self.little_endian)  
        if err then return false, "Failed to read p_align: " .. err end  
          
        local segment = {  
            p_type = p_type,  
            p_offset = p_offset,  
            p_vaddr = p_vaddr,  
            p_paddr = p_paddr,  
            p_filesz = p_filesz,  
            p_memsz = p_memsz,  
            p_flags = p_flags,  
            p_align = p_align  
        }  
          
        table.insert(self.segments, segment)  
    end  
    
    return true, nil
end

function ElfAnalyzer:calculateLoadBias()
    if not self.is_pie then
        self.load_bias = 0
        return
    end

    for _, segment in ipairs(self.segments) do  
        if segment.p_type == 1 and segment.p_vaddr > 0 then  
            self.load_bias = segment.p_vaddr  
            for _, sec in ipairs(self.sections) do  
                if sec.name == ".text" then  
                    self.text_base = sec.sh_addr  
                    break  
                end  
            end  
            return  
        end  
    end  
    
    self.load_bias = 0
end

function ElfAnalyzer:loadSections()
    if self.e_shnum == 0 then return true, nil end

    local shstrtab_header = nil  
    if self.e_shstrndx < self.e_shnum then  
        local shstrtab_offset = self.e_shoff + self.e_shstrndx * self.e_shentsize  
        local ok, err = safe_read(self.data, shstrtab_offset, self.e_shentsize)  
        if ok then  
            local sh_offset, err = get_uint32(self.data, shstrtab_offset + 16, self.little_endian)  
            if err then return false, "Failed to read shstrtab offset: " .. err end  
              
            local sh_size, err = get_uint32(self.data, shstrtab_offset + 20, self.little_endian)  
            if err then return false, "Failed to read shstrtab size: " .. err end  
              
            shstrtab_header = {  
                sh_offset = sh_offset,  
                sh_size = sh_size  
            }  
        end  
    end  
    
    for i = 0, self.e_shnum - 1 do  
        local sh_offset = self.e_shoff + i * self.e_shentsize  
        local ok, err = safe_read(self.data, sh_offset, self.e_shentsize)  
        if not ok then break end  
          
        local sh_name, err = get_uint32(self.data, sh_offset, self.little_endian)  
        if err then return false, "Failed to read sh_name: " .. err end  
          
        local sh_type, err = get_uint32(self.data, sh_offset + 4, self.little_endian)  
        if err then return false, "Failed to read sh_type: " .. err end  
          
        local sh_flags, err = get_uint32(self.data, sh_offset + 8, self.little_endian)  
        if err then return false, "Failed to read sh_flags: " .. err end  
          
        local sh_addr, err = get_uint32(self.data, sh_offset + 12, self.little_endian)  
        if err then return false, "Failed to read sh_addr: " .. err end  
          
        local sh_offset_val, err = get_uint32(self.data, sh_offset + 16, self.little_endian)  
        if err then return false, "Failed to read sh_offset: " .. err end  
          
        local sh_size, err = get_uint32(self.data, sh_offset + 20, self.little_endian)  
        if err then return false, "Failed to read sh_size: " .. err end  
          
        local sh_link, err = get_uint32(self.data, sh_offset + 24, self.little_endian)  
        if err then return false, "Failed to read sh_link: " .. err end  
          
        local sh_info, err = get_uint32(self.data, sh_offset + 28, self.little_endian)  
        if err then return false, "Failed to read sh_info: " .. err end  
          
        local sh_addralign, err = get_uint32(self.data, sh_offset + 32, self.little_endian)  
        if err then return false, "Failed to read sh_addralign: " .. err end  
          
        local sh_entsize, err = get_uint32(self.data, sh_offset + 36, self.little_endian)  
        if err then return false, "Failed to read sh_entsize: " .. err end  
          
        local section = {  
            index = i,  
            sh_name = sh_name,  
            sh_type = sh_type,  
            sh_flags = sh_flags,  
            sh_addr = sh_addr,  
            sh_offset = sh_offset_val,  
            sh_size = sh_size,  
            sh_link = sh_link,  
            sh_info = sh_info,  
            sh_addralign = sh_addralign,  
            sh_entsize = sh_entsize,  
            name = ""  
        }  
          
        if shstrtab_header and sh_name < shstrtab_header.sh_size then  
            local name_offset = shstrtab_header.sh_offset + sh_name  
            local name = ""  
            local pos = 0  
            while pos < shstrtab_header.sh_size - sh_name do  
                local byte_pos = name_offset + pos  
                if byte_pos >= #self.data then break end  
                  
                local byte = self.data:byte(byte_pos + 1)  
                if byte == 0 then break end  
                name = name .. string.char(byte)  
                pos = pos + 1  
            end  
            section.name = name  
        end  
          
        table.insert(self.sections, section)  
    end  
    
    return true, nil
end

function ElfAnalyzer:loadSymbols()
    self.symbols = {
        imports = {},
        exports = {},
        all = {},
        global_exports = {},
        weak_exports = {},
        local_symbols = {}
    }

    local dynsym_sec, dynstr_sec  
    for _, sec in ipairs(self.sections) do  
        if sec.sh_type == SHT.DYNSYM then  
            dynsym_sec = sec  
        elseif sec.sh_type == SHT.STRTAB and (sec.name == ".dynstr" or sec.name == ".strtab") then  
            dynstr_sec = sec  
        end  
    end  
    
    if not dynsym_sec or not dynstr_sec then   
        return true, nil   
    end  
    
    local dynstr_start = dynstr_sec.sh_offset  
    local dynstr_end = dynstr_start + dynstr_sec.sh_size  
    if dynstr_end > #self.data then  
        dynstr_end = #self.data  
    end  
    
    local entsize = dynsym_sec.sh_entsize  
    if entsize == 0 then  
        entsize = 16  
        if dynsym_sec.sh_offset + 24 <= #self.data then  
            local test_byte = self.data:byte(dynsym_sec.sh_offset + 24)  
            if test_byte then  
                entsize = 16  
            end  
        end  
    end  
    
    local num_syms = math.floor(dynsym_sec.sh_size / entsize)  
    
    for i = 0, num_syms - 1 do  
        local sym_offset = dynsym_sec.sh_offset + i * entsize  
        local ok, err = safe_read(self.data, sym_offset, entsize)  
        if not ok then break end  
          
        local st_name, err = get_uint32(self.data, sym_offset, self.little_endian)  
        if err then break end  
          
        local st_value, err = get_uint32(self.data, sym_offset + 4, self.little_endian)  
        if err then break end  
          
        local st_size, err = get_uint32(self.data, sym_offset + 8, self.little_endian)  
        if err then break end  
          
        local st_info, err = get_uint8(self.data, sym_offset + 12)  
        if err then break end  
          
        local st_other, err = get_uint8(self.data, sym_offset + 13)  
        if err then break end  
          
        local st_shndx, err = get_uint16(self.data, sym_offset + 14, self.little_endian)  
        if err then break end  
          
        if st_name ~= 0 then  
            local name = ""  
            if st_name < dynstr_sec.sh_size then  
                local name_start = dynstr_start + st_name  
                if name_start < dynstr_end then  
                    local pos = 0  
                    while true do  
                        local byte_pos = name_start + pos  
                        if byte_pos >= dynstr_end then break end  
                          
                        local byte = self.data:byte(byte_pos + 1)  
                        if byte == 0 or byte == nil then break end  
                          
                        name = name .. string.char(byte)  
                        pos = pos + 1  
                    end  
                end  
            end  
              
            if #name > 0 then  
                local st_type = bit.band(st_info, 0xF)  
                local st_bind = bit.rshift(bit.band(st_info, 0xF0), 4)  
                  
                local type_str  
                if st_type == STT.NOTYPE then  
                    type_str = "NOTYPE"  
                elseif st_type == STT.OBJECT then  
                    type_str = "OBJECT"  
                elseif st_type == STT.FUNC then  
                    type_str = "FUNC"  
                elseif st_type == STT.SECTION then  
                    type_str = "SECTION"  
                elseif st_type == STT.FILE then  
                    type_str = "FILE"  
                elseif st_type == STT.COMMON then  
                    type_str = "COMMON"  
                elseif st_type == STT.TLS then  
                    type_str = "TLS"  
                else  
                    type_str = sf("UNKNOWN_%d", st_type)  
                end  
                  
                local bind_str  
                if st_bind == STB.LOCAL then  
                    bind_str = "LOCAL"  
                elseif st_bind == STB.GLOBAL then  
                    bind_str = "GLOBAL"  
                elseif st_bind == STB.WEAK then  
                    bind_str = "WEAK"  
                else  
                    bind_str = sf("UNKNOWN_%d", st_bind)  
                end  
                  
                local symbol_info = {  
                    name = name,  
                    raw_address = st_value,  
                    size = st_size,  
                    type = type_str,  
                    bind = bind_str,  
                    section = st_shndx,  
                    index = i,  
                    is_import = (st_shndx == SHN.UNDEF),  
                    is_export = (st_shndx ~= SHN.UNDEF and st_shndx ~= SHN.ABS),  
                    is_absolute = (st_shndx == SHN.ABS)  
                }  
                  
                table.insert(self.symbols.all, symbol_info)  
                  
                if symbol_info.is_import then  
                    table.insert(self.symbols.imports, symbol_info)  
                elseif symbol_info.is_export then  
                    table.insert(self.symbols.exports, symbol_info)  
                      
                    if symbol_info.bind == "GLOBAL" then  
                        table.insert(self.symbols.global_exports, symbol_info)  
                    elseif symbol_info.bind == "WEAK" then  
                        table.insert(self.symbols.weak_exports, symbol_info)  
                    else  
                        table.insert(self.symbols.local_symbols, symbol_info)  
                    end  
                end  
            end  
        end  
    end  
    
    table.sort(self.symbols.exports, function(a, b)   
        return a.raw_address < b.raw_address   
    end)  
    
    table.sort(self.symbols.imports, function(a, b)   
        return a.name < b.name   
    end)  
    
    table.sort(self.symbols.global_exports, function(a, b)   
        return a.raw_address < b.raw_address   
    end)  
    
    table.sort(self.symbols.weak_exports, function(a, b)   
        return a.raw_address < b.raw_address   
    end)  
    
    return true, nil
end

function ElfAnalyzer:detectFunctions()
    self.functions = {}

    for _, sym in ipairs(self.symbols.exports) do  
        if (sym.type == "FUNC" or sym.type == "NOTYPE") and sym.raw_address > 0 then  
            local is_executable = false  
            for _, sec in ipairs(self.sections) do  
                if sec.sh_addr <= sym.raw_address and sym.raw_address < sec.sh_addr + sec.sh_size then  
                    if (bit.band(sec.sh_flags, SHF.EXECINSTR)) ~= 0 then  
                        is_executable = true  
                    elseif sec.name == ".text" or sec.name == ".plt" or sec.name:match("^%.text") then  
                        is_executable = true  
                    end  
                    break  
                end  
            end  
              
            if is_executable or sym.type == "FUNC" then  
                table.insert(self.functions, {  
                    name = sym.name,  
                    address = sym.raw_address,  
                    size = sym.size or 0,  
                    bind = sym.bind,  
                    section = sym.section  
                })  
            end  
        end  
    end  
    
    table.sort(self.functions, function(a, b)   
        return a.address < b.address   
    end)
end

function ElfAnalyzer:getInfo()
    local info = {}
    info.filename = self.fname:match("[^/]+$")
    info.machine = "ARM32"
    info.type = self.is_pie and "PIE/DYN" or "EXEC"
    info.endianness = self.little_endian and "Little" or "Big"
    info.entry_point = sf("0x%08X", self.e_entry)
    info.load_bias = sf("0x%08X", self.load_bias)
    info.sections = #self.sections
    info.exports = #self.symbols.exports
    info.imports = #self.symbols.imports
    info.global_exports = #self.symbols.global_exports
    info.weak_exports = #self.symbols.weak_exports
    info.local_symbols = #self.symbols.local_symbols
    info.functions = #self.functions

    local cats = {code = 0, data = 0, rodata = 0, bss = 0, other = 0}  
    for _, sec in ipairs(self.sections) do  
        local sec_name = sec.name:lower()  
          
        if sec.sh_type == SHT.PROGBITS then  
            if (bit.band(sec.sh_flags, SHF.EXECINSTR)) ~= 0 then  
                cats.code = cats.code + 1  
            elseif (bit.band(sec.sh_flags, SHF.ALLOC)) ~= 0 then  
                if (bit.band(sec.sh_flags, SHF.WRITE)) ~= 0 then  
                    cats.data = cats.data + 1  
                else  
                    cats.rodata = cats.rodata + 1  
                end  
            else  
                cats.other = cats.other + 1  
            end  
        elseif sec.sh_type == SHT.NOBITS then  
            cats.bss = cats.bss + 1  
        else  
            if sec_name == ".text" or sec_name:match("^%.text%.") or   
               sec_name == ".init" or sec_name == ".fini" or  
               sec_name == ".plt" or sec_name == ".init_array" or  
               sec_name == ".fini_array" then  
                cats.code = cats.code + 1  
            elseif sec_name == ".data" or sec_name:match("^%.data%.") or  
                   sec_name == ".got" or sec_name == ".got.plt" then  
                cats.data = cats.data + 1  
            elseif sec_name == ".rodata" or sec_name:match("^%.rodata%.") or  
                   sec_name == ".eh_frame" or sec_name == ".eh_frame_hdr" then  
                cats.rodata = cats.rodata + 1  
            elseif sec_name == ".bss" or sec_name:match("^%.bss%.") then  
                cats.bss = cats.bss + 1  
            else  
                cats.other = cats.other + 1  
            end  
        end  
    end  
    
    info.code_sections = cats.code  
    info.data_sections = cats.data  
    info.rodata_sections = cats.rodata  
    info.bss_sections = cats.bss  
    
    return info
end

local function chooseElfFile()
    local selected_file = gg.prompt({
        "Select ELF file (.so, .elf):"
    }, info, {
        "file"
    })

    if selected_file and #selected_file > 0 then  
        gg.saveVariable(selected_file, g.config)  
        g.last = selected_file[1]  
        return selected_file[1]  
    end  
    
    return nil
end

local function generateOutputFileName(fname)
    local base_name = fname:match("([^/]+)$")
    if not base_name then base_name = "elf_analysis" end
    local name_no_ext = base_name:gsub("%..+$", "")
    return "/sdcard/" .. name_no_ext .. "_exports.txt"
end

local function formatAddress(address)
    local hex_str = sf("%X", address)
    if hex_str == "" then hex_str = "0" end
    return "0x" .. hex_str
end

local function combineAndSortAllExports(analyzer)
    local all_exports = {}

    for _, sym in ipairs(analyzer.symbols.global_exports) do  
        table.insert(all_exports, {  
            raw_address = sym.raw_address,  
            size = sym.size or 0,  
            type = sym.type,  
            bind = sym.bind,  
            name = sym.name,  
            visibility = "public"  
        })  
    end  
    
    for _, sym in ipairs(analyzer.symbols.weak_exports) do  
        table.insert(all_exports, {  
            raw_address = sym.raw_address,  
            size = sym.size or 0,  
            type = sym.type,  
            bind = sym.bind,  
            name = sym.name,  
            visibility = "weak"  
        })  
    end  
    
    for _, sym in ipairs(analyzer.symbols.local_symbols) do  
        table.insert(all_exports, {  
            raw_address = sym.raw_address,  
            size = sym.size or 0,  
            type = sym.type,  
            bind = sym.bind,  
            name = sym.name,  
            visibility = "private"  
        })  
    end  
    
    table.sort(all_exports, function(a, b)   
        return a.raw_address < b.raw_address   
    end)  
    
    return all_exports
end

local function writeExportsOnly(analyzer, output_file)
    local outfile = io.open(output_file, "w")
    if not outfile then
        return false, "Cannot open output file: " .. output_file
    end
    
    local function write(text)
        outfile:write(text .. "\n")
    end
    
    local time = os.date("%Y-%m-%d %H:%M:%S")
    local info = analyzer:getInfo()
    
    local all_exports = combineAndSortAllExports(analyzer)
    
    local function calculateOffset(address)
        for _, seg in ipairs(analyzer.segments) do
            if seg.p_type == 1 then
                if seg.p_vaddr <= address and address < seg.p_vaddr + seg.p_memsz then
                    local offset_in_segment = address - seg.p_vaddr
                    if offset_in_segment < seg.p_filesz then
                        return seg.p_offset + offset_in_segment
                    end
                end
            end
        end
        return address
    end
    
    local function isValidOffsetEnding(address)
        local hex_str = sf("%X", address)
        if hex_str == "" then return false end
        local last_char = hex_str:sub(-1):upper()
        return last_char == "0" or last_char == "4" or 
               last_char == "8" or last_char == "C"
    end
    
    local function isObjectType(type_str)
        return type_str == "OBJECT"
    end
    
    local function isNotWeak(bind_str)
        return bind_str ~= "WEAK"
    end
    
    local filtered_exports = {}
    local seen_offsets = {}
    local original_count = #all_exports
    
    for _, sym in ipairs(all_exports) do
        local offset_val = calculateOffset(sym.raw_address)
        
        if isValidOffsetEnding(offset_val) and isObjectType(sym.type) and isNotWeak(sym.bind) then
            if not seen_offsets[offset_val] then
                seen_offsets[offset_val] = true
                table.insert(filtered_exports, {
                    raw_address = sym.raw_address,
                    size = sym.size or 0,
                    type = sym.type,
                    bind = sym.bind,
                    name = sym.name,
                    visibility = sym.visibility,
                    offset = offset_val
                })
            end
        end
    end
    
    table.sort(filtered_exports, function(a, b) 
        return a.offset < b.offset 
    end)
    
    write("=" .. string.rep("=", 100))
    write("ELF EXPORTS REPORT - FILTERED (OBJECT + 0/4/8/C)")
    write("=" .. string.rep("=", 100))
    write("Time: " .. time)
    write("File: " .. info.filename)
    write("Size: " .. analyzer.file_size .. " bytes")
    write("Type: " .. info.type)
    if analyzer.is_pie then
        write("Load Bias: " .. formatAddress(analyzer.load_bias))
    end
    
    write("[1] FILTERED EXPORTS - OBJECT ONLY (Ordered by Offset)")
    write(string.rep("-", 100))
    write("RVA         Offset      VA          Visibility   Type       Name")
    write(string.rep("-", 100))
    
    for _, sym in ipairs(filtered_exports) do
        local offset_val = sym.offset
        local rva_str = formatAddress(offset_val)
        local offset_str = formatAddress(offset_val)
        local va_str = formatAddress(offset_val)
        local visibility = sym.visibility
        local type_str = sym.type
        
        write(sf("RVA: %-10s Offset: %-10s VA: %-10s %-11s %-10s %s",
            rva_str, offset_str, va_str, visibility, type_str, sym.name))
        
        write("")
    end
    
    outfile:close()
    return true, nil
end

local function main()
    local analyzer = nil

    while true do  
        local options = {  
            "Load ELF File",  
            "Show Summary",  
            "Generate Exports Report",  
            "Exit"  
        }  
          
        if not analyzer then  
            for i = 2, #options do  
                options[i] = nil  
            end  
        end  
          
        local valid_options = {}  
        for _, opt in ipairs(options) do  
            if opt then  
                table.insert(valid_options, opt)  
            end  
        end  
          
        local choice = gg.choice(valid_options, nil, "ELF Analyzer - Exports Only")  
        if not choice then break end  
          
        if choice == 1 then  
            local fname = chooseElfFile()  
            if fname then  
                gg.toast("Loading ELF file...")  
                local start_time = os.clock()  
                  
                analyzer = ElfAnalyzer.new(fname)  
                local ok, err = analyzer:parse()  
                  
                if ok then  
                    local load_time = os.clock() - start_time  
                    local info = analyzer:getInfo()  
                    gg.alert(sf("ELF loaded successfully!\nFile: %s\nType: %s\nExports: %d\nTime: %.3f seconds",   
                        info.filename, info.type, info.exports, load_time))  
                else  
                    gg.alert("Error parsing ELF:\n" .. tostring(err))  
                    analyzer = nil  
                end  
            end  
              
        elseif choice == 2 and analyzer then  
            local info = analyzer:getInfo()  
            local text = "ELF ANALYSIS SUMMARY\n"  
            text = text .. "=" .. string.rep("=", 40) .. "\n\n"  
              
            text = text .. sf("File: %s\n", info.filename)  
            text = text .. sf("Size: %d bytes\n", analyzer.file_size)  
            text = text .. sf("Type: %s\n", info.type)  
            text = text .. sf("Arch: %s\n", info.machine)  
            text = text .. sf("Entry: %s\n", info.entry_point)  
            if analyzer.is_pie then  
                text = text .. sf("Load Bias: %s\n", info.load_bias)  
            end  
            text = text .. "\n"  
            text = text .. sf("Sections: %d\n", info.sections)  
            text = text .. sf("  Code: %d\n", info.code_sections)  
            text = text .. sf("  Data: %d\n", info.data_sections)  
            text = text .. sf("  Read-only: %d\n", info.rodata_sections)  
            text = text .. sf("  BSS: %d\n", info.bss_sections)  
            text = text .. "\n"  
            text = text .. sf("Symbols: %d\n", #analyzer.symbols.all)  
            text = text .. sf("  Imports: %d\n", info.imports)  
            text = text .. sf("  Exports: %d\n", info.exports)  
            text = text .. sf("    Global: %d\n", info.global_exports)  
            text = text .. sf("    Weak: %d\n", info.weak_exports)  
            text = text .. sf("    Local: %d\n", info.local_symbols)  
            text = text .. sf("  Functions: %d\n", info.functions)  
              
            gg.alert(text)  
              
        elseif choice == 3 and analyzer then  
            local output_file = generateOutputFileName(analyzer.fname)  
            gg.toast("Generating exports report...")  
            local success, err = writeExportsOnly(analyzer, output_file)  
            if success then  
                gg.alert(sf("Exports report saved successfully!\nLocation: %s", output_file))  
            else  
                gg.alert("Error saving report:\n" .. (err or "Unknown error"))  
            end  
              
        elseif choice == 4 then  
            break  
        end  
    end
end

if gg.isVisible(true) then
    gg.setVisible(false)
end

main()