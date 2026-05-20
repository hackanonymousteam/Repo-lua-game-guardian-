g = {}
g.last = "/sdcard/"
info = nil
g.config = gg.EXT_CACHE_DIR .. "/" .. gg.getFile():match("[^/]+$") .. "cfg"
if info == nil then info = { g.last, g.last:gsub("/[^/]+$", "") } end
gv = gg.getValues
sv = gg.setValues
sf = string.format


local ELF_MAGIC = "\127ELF"
local ELFCLASS32 = 1
local ELFCLASS64 = 2
local ELFDATA2LSB = 1
local ELFDATA2MSB = 2
local ET_NONE = 0 local ET_REL = 1 local ET_EXEC = 2 local ET_DYN = 3 local ET_CORE = 4
local EM_ARM = 40 local EM_AARCH64 = 183
local SHT_NULL = 0 local SHT_PROGBITS = 1 local SHT_SYMTAB = 2 local SHT_STRTAB = 3
local SHT_RELA = 4 local SHT_HASH = 5 local SHT_DYNAMIC = 6 local SHT_NOTE = 7
local SHT_NOBITS = 8 local SHT_REL = 9 local SHT_SHLIB = 10 local SHT_DYNSYM = 11
local SHT_INIT_ARRAY = 14 local SHT_FINI_ARRAY = 15 local SHT_PREINIT_ARRAY = 16
local SHT_GNU_HASH = 0x6ffffff6 local SHT_GNU_verdef = 0x6ffffffd
local SHT_GNU_verneed = 0x6ffffffe local SHT_GNU_versym = 0x6fffffff
local SHT_ARM_EXIDX = 0x70000001 local SHT_ARM_ATTRIBUTES = 0x70000003
local SHF_WRITE = 0x1 local SHF_ALLOC = 0x2 local SHF_EXECINSTR = 0x4
local SHF_MERGE = 0x10 local SHF_STRINGS = 0x20 local SHF_TLS = 0x400 local SHF_COMPRESSED = 0x800
local STB_LOCAL = 0 local STB_GLOBAL = 1 local STB_WEAK = 2
local STT_NOTYPE = 0 local STT_OBJECT = 1 local STT_FUNC = 2 local STT_SECTION = 3
local STT_FILE = 4 local STT_COMMON = 5 local STT_TLS = 6
local PT_NULL = 0 local PT_LOAD = 1 local PT_DYNAMIC = 2 local PT_INTERP = 3
local PT_NOTE = 4 local PT_SHLIB = 5 local PT_PHDR = 6 local PT_TLS = 7
local PT_GNU_EH_FRAME = 0x6474E550 local PT_GNU_STACK = 0x6474E551 local PT_GNU_RELRO = 0x6474E552
local DT_NULL = 0 local DT_NEEDED = 1 local DT_PLTRELSZ = 2 local DT_PLTGOT = 3
local DT_HASH = 4 local DT_STRTAB = 5 local DT_SYMTAB = 6 local DT_RELA = 7
local DT_RELASZ = 8 local DT_RELAENT = 9 local DT_STRSZ = 10 local DT_SYMENT = 11
local DT_INIT = 12 local DT_FINI = 13 local DT_SONAME = 14 local DT_RPATH = 15
local DT_SYMBOLIC = 16 local DT_REL = 17 local DT_RELSZ = 18 local DT_RELENT = 19
local DT_PLTREL = 20 local DT_DEBUG = 21 local DT_TEXTREL = 22 local DT_JMPREL = 23
local DT_BIND_NOW = 24 local DT_INIT_ARRAY = 25 local DT_FINI_ARRAY = 26
local DT_INIT_ARRAYSZ = 27 local DT_FINI_ARRAYSZ = 28 local DT_RUNPATH = 29
local DT_FLAGS = 30 local DT_ENCODING = 32 local DT_PREINIT_ARRAY = 32
local DT_PREINIT_ARRAYSZ = 33


local class_tbl = { [ELFCLASS32] = "ELF32", [ELFCLASS64] = "ELF64" }
local osabi_tbl = { [0] = "UNIX System V", [3] = "Linux", [97] = "ARM", [255] = "Standalone" }
local type_tbl = {
    [ET_NONE] = "NONE", [ET_REL] = "REL", [ET_EXEC] = "EXEC",
    [ET_DYN] = "DYN", [ET_CORE] = "CORE"
}
local mach_tbl = { [EM_ARM] = "ARM", [EM_AARCH64] = "AARCH64" }
local sht_tbl = {
    [SHT_NULL] = "NULL", [SHT_PROGBITS] = "PROGBITS", [SHT_SYMTAB] = "SYMTAB",
    [SHT_STRTAB] = "STRTAB", [SHT_RELA] = "RELA", [SHT_HASH] = "HASH",
    [SHT_DYNAMIC] = "DYNAMIC", [SHT_NOTE] = "NOTE", [SHT_NOBITS] = "NOBITS",
    [SHT_REL] = "REL", [SHT_SHLIB] = "SHLIB", [SHT_DYNSYM] = "DYNSYM",
    [SHT_INIT_ARRAY] = "INIT_ARRAY", [SHT_FINI_ARRAY] = "FINI_ARRAY",
    [SHT_PREINIT_ARRAY] = "PREINIT_ARRAY", [SHT_GNU_HASH] = "GNU_HASH",
    [SHT_GNU_verdef] = "VERDEF", [SHT_GNU_verneed] = "VERNEED",
    [SHT_GNU_versym] = "VERSYM", [SHT_ARM_EXIDX] = "ARM_EXIDX",
    [SHT_ARM_ATTRIBUTES] = "ARM_ATTR"
}
local pt_tbl = {
    [PT_NULL] = "NULL", [PT_LOAD] = "LOAD", [PT_DYNAMIC] = "DYNAMIC",
    [PT_INTERP] = "INTERP", [PT_NOTE] = "NOTE", [PT_SHLIB] = "SHLIB",
    [PT_PHDR] = "PHDR", [PT_TLS] = "TLS", [PT_GNU_EH_FRAME] = "EH_FRAME",
    [PT_GNU_STACK] = "STACK", [PT_GNU_RELRO] = "RELRO"
}
local bind_tbl = { [STB_LOCAL] = "LOCAL", [STB_GLOBAL] = "GLOBAL", [STB_WEAK] = "WEAK" }
local type_sym_tbl = {
    [STT_NOTYPE] = "NOTYPE", [STT_OBJECT] = "OBJECT", [STT_FUNC] = "FUNC",
    [STT_SECTION] = "SECTION", [STT_FILE] = "FILE", [STT_COMMON] = "COMMON", [STT_TLS] = "TLS"
}
local dt_tbl = {
    [DT_NULL] = "NULL", [DT_NEEDED] = "NEEDED", [DT_PLTRELSZ] = "PLTRELSZ",
    [DT_PLTGOT] = "PLTGOT", [DT_HASH] = "HASH", [DT_STRTAB] = "STRTAB",
    [DT_SYMTAB] = "SYMTAB", [DT_RELA] = "RELA", [DT_RELASZ] = "RELASZ",
    [DT_RELAENT] = "RELAENT", [DT_STRSZ] = "STRSZ", [DT_SYMENT] = "SYMENT",
    [DT_INIT] = "INIT", [DT_FINI] = "FINI", [DT_SONAME] = "SONAME",
    [DT_RPATH] = "RPATH", [DT_SYMBOLIC] = "SYMBOLIC", [DT_REL] = "REL",
    [DT_RELSZ] = "RELSZ", [DT_RELENT] = "RELENT", [DT_PLTREL] = "PLTREL",
    [DT_DEBUG] = "DEBUG", [DT_TEXTREL] = "TEXTREL", [DT_JMPREL] = "JMPREL",
    [DT_BIND_NOW] = "BIND_NOW", [DT_INIT_ARRAY] = "INIT_ARRAY",
    [DT_FINI_ARRAY] = "FINI_ARRAY", [DT_INIT_ARRAYSZ] = "INIT_ARRAYSZ",
    [DT_FINI_ARRAYSZ] = "FINI_ARRAYSZ", [DT_RUNPATH] = "RUNPATH",
    [DT_FLAGS] = "FLAGS", [DT_ENCODING] = "ENCODING",
    [DT_PREINIT_ARRAY] = "PREINIT_ARRAY", [DT_PREINIT_ARRAYSZ] = "PREINIT_ARRAYSZ"
}


local function r8(d, p)
    if p + 1 > #d then return 0 end
    return d:byte(p + 1)
end

local function r16(d, p, le)
    if p + 2 > #d then return 0 end
    local a, b = d:byte(p + 1), d:byte(p + 2)
    return le and (a | (b << 8)) or (b | (a << 8))
end

local function r32(d, p, le)
    if p + 4 > #d then return 0 end
    local a, b, c, d2 = d:byte(p + 1), d:byte(p + 2), d:byte(p + 3), d:byte(p + 4)
    if le then
        return a | (b << 8) | (c << 16) | (d2 << 24)
    else
        return d2 | (c << 8) | (b << 16) | (a << 24)
    end
end

local function r64(d, p, le)
    if p + 8 > #d then return 0 end
    local lo = r32(d, p, le)
    local hi = r32(d, p + 4, le)
    if le then
        return lo + hi * 0x100000000
    else
        return hi + lo * 0x100000000
    end
end

local function get_str(d, off, maxlen)
    if off < 0 or off >= #d then return "" end
    local maxlen = maxlen or (#d - off)
    local i = off + 1
    local limit = math.min(off + maxlen, #d)
    while i <= limit and d:byte(i) ~= 0 do
        i = i + 1
    end
    return d:sub(off + 1, i - 1)
end

local function hx(v, w)
    if type(v) == "number" then
        return sf("0x%0" .. (w or 8) .. "X", v)
    end
    return sf("0x%0" .. (w or 16) .. "X", v)
end

local function nm(t, k)
    return t[k] or sf("0x%X", k)
end

local function flg(f)
    local r = ""
    if (f & SHF_WRITE) ~= 0 then r = r .. "W" end
    if (f & SHF_ALLOC) ~= 0 then r = r .. "A" end
    if (f & SHF_EXECINSTR) ~= 0 then r = r .. "X" end
    if (f & SHF_MERGE) ~= 0 then r = r .. "M" end
    if (f & SHF_STRINGS) ~= 0 then r = r .. "S" end
    if (f & SHF_TLS) ~= 0 then r = r .. "T" end
    if (f & SHF_COMPRESSED) ~= 0 then r = r .. "C" end
    return r
end

local function pflg(f)
    local r = ""
    if (f & 4) ~= 0 then r = r .. "R" end
    if (f & 2) ~= 0 then r = r .. "W" end
    if (f & 1) ~= 0 then r = r .. "E" end
    return r
end


local function dump_header(d, le, elf_class)
    local t = "=== ELF Header ===\n"
    t = t .. sf("Class:      %s\n", nm(class_tbl, elf_class))
    t = t .. sf("Encoding:   %s\n", le and "Little endian" or "Big endian")
    t = t .. sf("OS/ABI:     %s\n", nm(osabi_tbl, r8(d, 7)))
    t = t .. sf("ABI Ver:    %d\n", r8(d, 8))
    t = t .. sf("Type:       %s\n", nm(type_tbl, r16(d, 16, le)))
    t = t .. sf("Machine:    %s\n", nm(mach_tbl, r16(d, 18, le)))
    if elf_class == ELFCLASS32 then
        t = t .. sf("Entry:      %s\n", hx(r32(d, 24, le)))
        t = t .. sf("PH offset:  %d\n", r32(d, 28, le))
        t = t .. sf("SH offset:  %d\n", r32(d, 32, le))
        t = t .. sf("Flags:      0x%X\n", r32(d, 36, le))
        t = t .. sf("EH size:    %d\n", r16(d, 40, le))
        t = t .. sf("PH ent size:%d\n", r16(d, 42, le))
        t = t .. sf("PH num:     %d\n", r16(d, 44, le))
        t = t .. sf("SH ent size:%d\n", r16(d, 46, le))
        t = t .. sf("SH num:     %d\n", r16(d, 48, le))
        t = t .. sf("SH strndx:  %d\n", r16(d, 50, le))
    else 
        t = t .. sf("Entry:      %s\n", hx(r64(d, 24, le), 16))
        t = t .. sf("PH offset:  %d\n", r64(d, 32, le))
        t = t .. sf("SH offset:  %d\n", r64(d, 40, le))
        t = t .. sf("Flags:      0x%X\n", r32(d, 48, le))
        t = t .. sf("EH size:    %d\n", r16(d, 52, le))
        t = t .. sf("PH ent size:%d\n", r16(d, 54, le))
        t = t .. sf("PH num:     %d\n", r16(d, 56, le))
        t = t .. sf("SH ent size:%d\n", r16(d, 58, le))
        t = t .. sf("SH num:     %d\n", r16(d, 60, le))
        t = t .. sf("SH strndx:  %d\n", r16(d, 62, le))
    end
    return t
end

local function dump_sections(d, le, sho, shn, she, shstr, elf_class)
    if shn == 0 then return "=== Sections ===\nNenhuma secao\n" end
    
    
    if sho + shstr * she + (elf_class == ELFCLASS32 and 40 or 64) > #d then
        return "=== Sections ===\nErro: string table fora dos limites\n"
    end
    
    
    local sso = sho + shstr * she
    local so, ssz
    if elf_class == ELFCLASS32 then
        so = r32(d, sso + 16, le)
        ssz = r32(d, sso + 20, le)
    else
        so = r64(d, sso + 24, le)
        ssz = r64(d, sso + 32, le)
    end
    
    if so + ssz > #d then
        return "=== Sections ===\nErro: string table fora dos limites\n"
    end
    
    local st = d:sub(so + 1, so + ssz)
    
    local t = "=== Sections ===\n"
    t = t .. "[Nr] Nome                Tipo       Addr     Off    Size   ES Flg Lk Inf Al\n"
    
    for i = 0, shn - 1 do
        local p = sho + i * she
        if p + (elf_class == ELFCLASS32 and 40 or 64) > #d then break end
        
        local nm_off, tp, fl, ad, off, sz, lk, inf, al, es
        
        if elf_class == ELFCLASS32 then
            nm_off = r32(d, p, le)
            tp = r32(d, p + 4, le)
            fl = r32(d, p + 8, le)
            ad = r32(d, p + 12, le)
            off = r32(d, p + 16, le)
            sz = r32(d, p + 20, le)
            lk = r32(d, p + 24, le)
            inf = r32(d, p + 28, le)
            al = r32(d, p + 32, le)
            es = r32(d, p + 36, le)
        else
            nm_off = r32(d, p, le)
            tp = r32(d, p + 4, le)
            fl = r64(d, p + 8, le)
            ad = r64(d, p + 16, le)
            off = r64(d, p + 24, le)
            sz = r64(d, p + 32, le)
            lk = r32(d, p + 40, le)
            inf = r32(d, p + 44, le)
            al = r64(d, p + 48, le)
            es = r64(d, p + 56, le)
        end
        
        local sname = get_str(st, nm_off)
        t = t .. sf("[%2d] %-20s %-9s %s %s %s %2d %-3s %2d %3d %2d\n",
            i, sname, nm(sht_tbl, tp), hx(ad), hx(off), hx(sz, 6), es, flg(fl), lk, inf, al)
    end
    return t
end

local function dump_segments(d, le, pho, phn, phe, elf_class)
    if phn == 0 then return "=== Segments ===\nNenhum segmento\n" end
    
    local t = "=== Segments ===\n"
    t = t .. "[Nr] Tipo     Offset   VAddr    PAddr    FileSz  MemSz   Flg Align\n"
    
    for i = 0, phn - 1 do
        local p = pho + i * phe
        if p + (elf_class == ELFCLASS32 and 32 or 56) > #d then break end
        
        local tp, off, va, pa, fs, ms, fl, al
        
        if elf_class == ELFCLASS32 then
            tp = r32(d, p, le)
            off = r32(d, p + 4, le)
            va = r32(d, p + 8, le)
            pa = r32(d, p + 12, le)
            fs = r32(d, p + 16, le)
            ms = r32(d, p + 20, le)
            fl = r32(d, p + 24, le)
            al = r32(d, p + 28, le)
        else
            tp = r32(d, p, le)
            fl = r32(d, p + 4, le)
            off = r64(d, p + 8, le)
            va = r64(d, p + 16, le)
            pa = r64(d, p + 24, le)
            fs = r64(d, p + 32, le)
            ms = r64(d, p + 40, le)
            al = r64(d, p + 48, le)
            fl = r32(d, p + 4, le) 
        end
        
        t = t .. sf("[%2d] %-8s %s %s %s %s %s %-3s %s\n",
            i, nm(pt_tbl, tp), hx(off), hx(va), hx(pa),
            hx(fs, 6), hx(ms, 6), pflg(fl), hx(al, 6))
    end
    return t
end

local function dump_dynamic(d, le, sho, shn, she, elf_class)
    local dt_entry_size = elf_class == ELFCLASS32 and 8 or 16
    
    for i = 0, shn - 1 do
        local p = sho + i * she
        if p + 4 > #d then break end
        
        local tp = r32(d, p + 4, le)
        if tp == SHT_DYNAMIC then
            local off, sz, lk
            
            if elf_class == ELFCLASS32 then
                off = r32(d, p + 16, le)
                sz = r32(d, p + 20, le)
                lk = r32(d, p + 24, le)
            else
                off = r64(d, p + 24, le)
                sz = r64(d, p + 32, le)
                lk = r32(d, p + 40, le)
            end
            
            local n = math.floor(sz / dt_entry_size)
            
                   local strt = ""
            if lk > 0 and lk < shn then
                local sp = sho + lk * she
                local s_off, s_sz
                if elf_class == ELFCLASS32 then
                    s_off = r32(d, sp + 16, le)
                    s_sz = r32(d, sp + 20, le)
                else
                    s_off = r64(d, sp + 24, le)
                    s_sz = r64(d, sp + 32, le)
                end
                if s_off + s_sz <= #d then
                    strt = d:sub(s_off + 1, s_off + s_sz)
                end
            end
            
            local t = "=== Dynamic ===\n"
            for j = 0, n - 1 do
                local dp = off + j * dt_entry_size
                if dp + dt_entry_size > #d then break end
                
                local tag, val
                if elf_class == ELFCLASS32 then
                    tag = r32(d, dp, le)
                    val = r32(d, dp + 4, le)
                else
                    tag = r64(d, dp, le)
                    val = r64(d, dp + 8, le)
                end
                
                if tag == DT_NULL then break end
                
                local tn = nm(dt_tbl, tag)
                if tag == DT_NEEDED or tag == DT_SONAME or tag == DT_RPATH or tag == DT_RUNPATH then
                    local s = (val < #strt) and get_str(strt, val) or ""
                    t = t .. sf("  %-16s %s\n", tn, s)
                else
                    t = t .. sf("  %-16s %s\n", tn, hx(val))
                end
            end
            return t .. "\n"
        end
    end
    return ""
end

local function dump_symbols(d, le, sho, shn, she, shstrndx, elf_class)
    local t = ""
    
     local section_strtab = ""
    if shstrndx > 0 and shstrndx < shn then
        local ssp = sho + shstrndx * she
        local sso, sssz
        if elf_class == ELFCLASS32 then
            sso = r32(d, ssp + 16, le)
            sssz = r32(d, ssp + 20, le)
        else
            sso = r64(d, ssp + 24, le)
            sssz = r64(d, ssp + 32, le)
        end
        if sso + sssz <= #d then
            section_strtab = d:sub(sso + 1, sso + sssz)
        end
    end
    
    for i = 0, shn - 1 do
        local p = sho + i * she
        if p + 4 > #d then break end
        
        local tp = r32(d, p + 4, le)
        if tp == SHT_SYMTAB or tp == SHT_DYNSYM then
            local off, sz, lk, es
            
            if elf_class == ELFCLASS32 then
                off = r32(d, p + 16, le)
                sz = r32(d, p + 20, le)
                lk = r32(d, p + 24, le)
                es = r32(d, p + 36, le)
            else
                off = r64(d, p + 24, le)
                sz = r64(d, p + 32, le)
                lk = r32(d, p + 40, le)
                es = r64(d, p + 56, le)
            end
            
            if es == 0 then
                es = elf_class == ELFCLASS32 and 16 or 24
            end
            
            local num = math.floor(sz / es)
            if num == 0 then break end
            
                      local sym_strtab = ""
            if lk > 0 and lk < shn then
                local sp = sho + lk * she
                local s_off, s_sz
                if elf_class == ELFCLASS32 then
                    s_off = r32(d, sp + 16, le)
                    s_sz = r32(d, sp + 20, le)
                else
                    s_off = r64(d, sp + 24, le)
                    s_sz = r64(d, sp + 32, le)
                end
                if s_off + s_sz <= #d then
                    sym_strtab = d:sub(s_off + 1, s_off + s_sz)
                end
            end
            
                  local section_name = ""
            if #section_strtab > 0 then
                local name_off = r32(d, p, le)
                section_name = get_str(section_strtab, name_off)
            end
            
            t = t .. "=== Symbol table (" .. section_name .. ") ===\n"
            t = t .. "[Nr] Value   Size   Type    Bind   Sect Nome\n"
            
            local max_syms = math.min(num - 1, 199)
            for j = 0, max_syms do
                local sp = off + j * es
                if sp + es > #d then break end
                
                local name_offset, value, size, info, sndx
                
                if elf_class == ELFCLASS32 then
                    name_offset = r32(d, sp, le)
                    value = r32(d, sp + 4, le)
                    size = r32(d, sp + 8, le)
                    info = r8(d, sp + 12)
                    sndx = r16(d, sp + 14, le)
                else
                    name_offset = r32(d, sp, le)
                    info = r8(d, sp + 4)
                    sndx = r16(d, sp + 6, le)
                    value = r64(d, sp + 8, le)
                    size = r64(d, sp + 16, le)
                end
                
                local bd = (info >> 4) & 0xF
                local sty = info & 0xF
                
                local sym_name = ""
                if #sym_strtab > 0 then
                    sym_name = get_str(sym_strtab, name_offset)
                end
                
                t = t .. sf("[%3d] %s %s %-7s %-6s %4d %s\n",
                    j, hx(value), hx(size, 5),
                    nm(type_sym_tbl, sty), nm(bind_tbl, bd), sndx, sym_name)
            end
            
            if num > 200 then
                t = t .. "... + " .. (num - 200) .. " mais\n"
            end
            t = t .. "\n"
        end
    end
    return t
end

local function dump_notes(d, le, sho, shn, she, shstrndx, elf_class)
    local t = ""
    
    
    local section_strtab = ""
    if shstrndx > 0 and shstrndx < shn then
        local ssp = sho + shstrndx * she
        local sso, sssz
        if elf_class == ELFCLASS32 then
            sso = r32(d, ssp + 16, le)
            sssz = r32(d, ssp + 20, le)
        else
            sso = r64(d, ssp + 24, le)
            sssz = r64(d, ssp + 32, le)
        end
        if sso + sssz <= #d then
            section_strtab = d:sub(sso + 1, sso + sssz)
        end
    end
    
    for i = 0, shn - 1 do
        local p = sho + i * she
        if p + 4 > #d then break end
        
        if r32(d, p + 4, le) == SHT_NOTE then
            local off, sz
            if elf_class == ELFCLASS32 then
                off = r32(d, p + 16, le)
                sz = r32(d, p + 20, le)
            else
                off = r64(d, p + 24, le)
                sz = r64(d, p + 32, le)
            end
            
            if sz < 12 or off + sz > #d then break end
            
                    local section_name = ""
            if #section_strtab > 0 then
                local name_off = r32(d, p, le)
                section_name = get_str(section_strtab, name_off)
            end
            
            local namesz = r32(d, off, le)
            local descsz = r32(d, off + 4, le)
            local ntype = r32(d, off + 8, le)
            
            local name = ""
            if namesz > 0 and off + 12 + namesz <= #d then
                name = get_str(d, off + 12, namesz)
            end
            
            t = t .. "=== Notes (" .. section_name .. ") ===\n"
            t = t .. sf("  Name: %s  Type: 0x%X  Size: %d\n", name, ntype, descsz)
            t = t .. "\n"
        end
    end
    return t
end

local function choose_file()
    local r = gg.prompt({"Selecione o arquivo ELF (.so/.elf):"}, info, {"file"})
    if r and #r > 0 then
        gg.saveVariable(r, g.config)
        g.last = r[1]
        return r[1]
    end
    return nil
end

local function main()
    gg.setVisible(false)
    local fn = choose_file()
    if not fn then return end

    local f = io.open(fn, "rb")
    if not f then
        gg.alert("Erro ao abrir arquivo")
        return
    end
    
    local d = f:read("*a")
    f:close()

    
    if #d < 52 or d:sub(1, 4) ~= ELF_MAGIC then
        gg.alert("Arquivo ELF invalido")
        return
    end
    
    local elf_class = r8(d, 4)
    if elf_class ~= ELFCLASS32 and elf_class ~= ELFCLASS64 then
        gg.alert("Classe ELF invalida: " .. elf_class)
        return
    end
    
    local le = r8(d, 5) == ELFDATA2LSB
    
    local sho, shn, she, shstrndx, pho, phn, phe
    
    if elf_class == ELFCLASS32 then
        sho = r32(d, 32, le)
        shn = r16(d, 48, le)
        she = r16(d, 46, le)
        shstrndx = r16(d, 50, le)
        pho = r32(d, 28, le)
        phn = r16(d, 44, le)
        phe = r16(d, 42, le)
        
        if she < 40 then she = 40 end
        if phe < 32 then phe = 32 end
    else 
        sho = r64(d, 40, le)
        shn = r16(d, 60, le)
        she = r16(d, 58, le)
        shstrndx = r16(d, 62, le)
        pho = r64(d, 32, le)
        phn = r16(d, 56, le)
        phe = r16(d, 54, le)
        
        if she < 64 then she = 64 end
        if phe < 56 then phe = 56 end
    end
    
 if shn == 0 or sho == 0 then
        gg.alert("ELF sem seções (stripado?)")
        return
    end
    
    if shstrndx >= shn then
        gg.alert("Índice da string table de seções inválido")
        return
    end

    local out = "=== ELF DUMPER ARM32/64 ===\nArquivo: " .. fn:match("[^/]+$") .. "\n\n"
    out = out .. dump_header(d, le, elf_class) .. "\n"
    out = out .. dump_sections(d, le, sho, shn, she, shstrndx, elf_class) .. "\n"
    out = out .. dump_segments(d, le, pho, phn, phe, elf_class) .. "\n"
    out = out .. dump_dynamic(d, le, sho, shn, she, elf_class)
   -- out = out .. dump_symbols(d, le, sho, shn, she, shstrndx, elf_class)
    out = out .. dump_notes(d, le, sho, shn, she, shstrndx, elf_class)
print(out)
 
    local tmp = os.tmpname()
    local fo = io.open(tmp, "w")
    if fo then
        fo:write(out)
        fo:close()
        gg.alert("Dump salvo em:\n" .. tmp .. "\n\n" .. out:sub(1, 8000))
    else
        gg.alert("Erro ao salvar arquivo temporário\n\n" .. out:sub(1, 8000))
    end
end

main()