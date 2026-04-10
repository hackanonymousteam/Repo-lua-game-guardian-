---------------------// ELF Parser Complete Implementation //-------------------------------
_OSABI = { "System V", "HP-UX", "NetBSD", "Linux", "GNU Hurd", "Solaris", "AIX", "IRIX", "FreeBSD", "Tru64", "Novell Modesto", "OpenBSD", "OpenVMS", "NonStop Kernel", "AROS", "Fenix OS", "CloudABI" }
_Type = { ["0"] = "ET_NONE", ["1"] = "ET_REL", ["2"] = "ET_EXEC", ["3"] = "ET_DYN", ["4"] = "ET_CORE", ["65024"] = "ET_LOOS", ["65279"] = "ET_HIOS", ["65280"] = "ET_LOPROC", ["65535"] = "ET_HIPROC" }
_Machine = { ["0"] = "No Specific Instruction Set", ["2"] = "SPARC", ["3"] = "x86", ["8"] = "MIPS", ["20"] = "PowerPC", ["22"] = "S390", ["40"] = "ARM", ["42"] = "SuperH", ["50"] = "IA-64", ["62"] = "x86-64", ["183"] = "AArch64", ["243"] = "RISC-V" }
_pHdrType = { "PT_NULL", "PT_LOAD", "PT_DYNAMIC", "PT_INTERP", "PT_NOTE", "PT_SHLIB", "PT_PHDR", "PT_TLS", "PT_GNU_EH_FRAME", "PT_GNU_STACK", "PT_GNU_RELRO" }
_DT = { "DT_NULL", "DT_NEEDED", "DT_PLTRELSZ", "DT_PLTGOT", "DT_HASH", "DT_STRTAB", "DT_SYMTAB", "DT_RELA", "DT_RELASZ", "DT_RELAENT", "DT_STRSZ", "DT_SYMENT", "DT_INIT", "DT_FINI", "DT_SONAME", "DT_RPATH", "DT_SYMBOLIC", "DT_REL", "DT_RELSZ", "DT_RELENT", "DT_PLTREL", "DT_DEBUG", "DT_TEXTREL", "DT_JMPREL", "DT_BIND_NOW", "DT_INIT_ARRAY", "DT_FINI_ARRAY", "DT_INIT_ARRAYSZ", "DT_FINI_ARRAYSZ", "DT_RUNPATH", "DT_FLAGS", "DT_PREINIT_ARRAY", "DT_PREINIT_ARRAYSZ", "DT_SYMTAB_SHNDX", "DT_VERSYM", "DT_VERDEF", "DT_VERDEFNUM", "DT_VERNEED", "DT_VERNEEDNUM" }
_ST = { "STT_NOTYPE", "STT_OBJECT", "STT_FUNC", "STT_SECTION", "STT_FILE", "STT_COMMON", "STT_TLS" }
_STB = { "STB_LOCAL", "STB_GLOBAL", "STB_WEAK" }

-- Helper functions
function tohex(num)
    return string.format("0x%X", num)
end

function rwmem(Address, SizeOrBuffer)
    _rw = {}
    if type(SizeOrBuffer) == "number" then
        _ = ""
        for _ = 1, SizeOrBuffer do _rw[_] = {address = (Address - 1) + _, flags = gg.TYPE_BYTE} end
        for v, __ in ipairs(gg.getValues(_rw)) do _ = _ .. string.format("%02X", __.value & 0xFF) end
        return _
    end
    Byte = {} 
    SizeOrBuffer:gsub("..", function(x) 
        Byte[#Byte + 1] = x 
        _rw[#Byte] = {address = (Address - 1) + #Byte, flags = gg.TYPE_BYTE, value = x .. "h"} 
    end)
    gg.setValues(_rw)
end

function rdstr(Address, StrSize)
    if StrSize == nil or type(StrSize) ~= "number" then StrSize = 128 end
    local str = ""
    for _ in rwmem(Address, StrSize):gmatch("..") do
        if _ == "00" then break end
        str = str .. string.char(tonumber(_, 16))
    end
    return str
end

function GetLibraryBase(lib)
    for _, __ in pairs(gg.getRangesList(lib)) do
        if __["state"] == "Xa" then return __["start"], __["end"] end
    end
    return nil
end

function ParseSymbolInfo(info)
    local bind = (info >> 4) & 0xF
    local type = info & 0xF
    return {
        bind = _STB[bind + 1] or "STB_UNKNOWN",
        type = _ST[type + 1] or "STT_UNKNOWN"
    }
end

function GetLibInformation(LibName)
    local LibBase = GetLibraryBase(LibName)
    if LibBase == nil then return nil end
    
    -- Read ELF header
    local elf_header = gg.getValues({
        {address = LibBase, flags = gg.TYPE_DWORD },        -- Magic
        {address = LibBase + 0x4, flags = gg.TYPE_BYTE },  -- Class
        {address = LibBase + 0x5, flags = gg.TYPE_BYTE },  -- Data
        {address = LibBase + 0x6, flags = gg.TYPE_BYTE },  -- Version
        {address = LibBase + 0x7, flags = gg.TYPE_BYTE },  -- OS ABI
        {address = LibBase + 0x8, flags = gg.TYPE_BYTE },  -- ABI Version
        {address = LibBase + 0x10, flags = gg.TYPE_WORD }, -- Type
        {address = LibBase + 0x12, flags = gg.TYPE_WORD }, -- Machine
        {address = LibBase + 0x14, flags = gg.TYPE_DWORD }, -- Version
        {address = LibBase + 0x18, flags = gg.TYPE_DWORD }, -- Entry Point
        {address = LibBase + 0x1C, flags = gg.TYPE_DWORD }, -- PH Offset
        {address = LibBase + 0x20, flags = gg.TYPE_DWORD }, -- SH Offset
        {address = LibBase + 0x24, flags = gg.TYPE_DWORD }, -- Flags
        {address = LibBase + 0x28, flags = gg.TYPE_WORD },  -- Elf Header Size
        {address = LibBase + 0x2A, flags = gg.TYPE_WORD }, -- PH Size Entry
        {address = LibBase + 0x2C, flags = gg.TYPE_WORD },  -- PH Num
        {address = LibBase + 0x2E, flags = gg.TYPE_WORD }, -- SH Size Entry
        {address = LibBase + 0x30, flags = gg.TYPE_WORD },  -- SH Num
        {address = LibBase + 0x32, flags = gg.TYPE_WORD }   -- SH Str Index
    })

    local Elf = {
        -- ELF Header Information
        Magic = elf_header[1].value,
        Class = elf_header[2].value,
        Data = elf_header[3].value,
        Version = elf_header[4].value,
        OSABI = _OSABI[elf_header[5].value + 1] or "Unknown",
        ABIVer = elf_header[6].value,
        Type = _Type[tostring(elf_header[7].value)] or "Unknown",
        Machine = _Machine[tostring(elf_header[8].value)] or "Unknown",
        Version2 = elf_header[9].value,
        EntryPoint = elf_header[10].value,
        PHOffset = elf_header[11].value,
        SHOffset = elf_header[12].value,
        Flags = elf_header[13].value,
        HeaderSize = elf_header[14].value,
        PHSize = elf_header[15].value,
        PHNum = elf_header[16].value,
        SHSize = elf_header[17].value,
        SHNum = elf_header[18].value,
        SHStrIndex = elf_header[19].value,
        
        -- Sections
        pHdr = {},  -- Program Headers
        Dyn = {},   -- Dynamic Segment
        Sym = {},   -- Symbol Table
        Shdr = {},  -- Section Headers
        Got = {},   -- Global Offset Table
        Plt = {},   -- Procedure Linkage Table
        Rel = {}    -- Relocation Table
    }

    -- Parse Program Headers
    for i = 0, Elf.PHNum - 1 do
        local pHdrAddr = LibBase + Elf.PHOffset + (i * Elf.PHSize)
        local pHdr = gg.getValues({
            { address = pHdrAddr, flags = gg.TYPE_DWORD },       -- p_type
            { address = pHdrAddr + 4, flags = gg.TYPE_DWORD },   -- p_offset
            { address = pHdrAddr + 8, flags = gg.TYPE_DWORD },   -- p_vaddr
            { address = pHdrAddr + 0xC, flags = gg.TYPE_DWORD }, -- p_paddr
            { address = pHdrAddr + 0x10, flags = gg.TYPE_DWORD },-- p_filesz
            { address = pHdrAddr + 0x14, flags = gg.TYPE_DWORD },-- p_memsz
            { address = pHdrAddr + 0x18, flags = gg.TYPE_DWORD },-- p_flags
            { address = pHdrAddr + 0x1C, flags = gg.TYPE_DWORD } -- p_align
        })
        
        local p_type = pHdr[1].value
        Elf.pHdr[i+1] = {
            p_type = p_type,
            p_type_str = _pHdrType[p_type + 1] or tohex(p_type),
            p_offset = pHdr[2].value,
            p_vaddr = pHdr[3].value,
            p_paddr = pHdr[4].value,
            p_filesz = pHdr[5].value,
            p_memsz = pHdr[6].value,
            p_flags = pHdr[7].value,
            p_align = pHdr[8].value
        }
    end

    -- Parse Dynamic Segment
    local dynamic_segment = nil
    for _, phdr in ipairs(Elf.pHdr) do
        if phdr.p_type_str == "PT_DYNAMIC" then
            dynamic_segment = phdr
            break
        end
    end

    if dynamic_segment then
        local dyn_count = 0
        while true do
            local dyn_addr = LibBase + dynamic_segment.p_vaddr + (dyn_count * 8)
            local dyn_entry = gg.getValues({
                { address = dyn_addr, flags = gg.TYPE_DWORD },      -- d_tag
                { address = dyn_addr + 4, flags = gg.TYPE_DWORD }   -- d_val/d_ptr
            })
            
            if dyn_entry[1].value == 0 and dyn_entry[2].value == 0 then break end
            
            local tag = dyn_entry[1].value
            Elf.Dyn[dyn_count+1] = {
                d_tag = tag,
                d_tag_str = _DT[tag + 1] or tohex(tag),
                d_val = dyn_entry[2].value,
                d_ptr = dyn_entry[2].value
            }
            dyn_count = dyn_count + 1
        end
    end

    -- Find important dynamic entries
    local strtab, symtab, strsz, syment, hash, pltgot, pltrelsz, jmprel = 0, 0, 0, 0, 0, 0, 0, 0
    for _, dyn in ipairs(Elf.Dyn) do
        if dyn.d_tag_str == "DT_STRTAB" then strtab = dyn.d_ptr end
        if dyn.d_tag_str == "DT_SYMTAB" then symtab = dyn.d_ptr end
        if dyn.d_tag_str == "DT_STRSZ" then strsz = dyn.d_val end
        if dyn.d_tag_str == "DT_SYMENT" then syment = dyn.d_val end
        if dyn.d_tag_str == "DT_HASH" then hash = dyn.d_ptr end
        if dyn.d_tag_str == "DT_PLTGOT" then pltgot = dyn.d_ptr end
        if dyn.d_tag_str == "DT_PLTRELSZ" then pltrelsz = dyn.d_val end
        if dyn.d_tag_str == "DT_JMPREL" then jmprel = dyn.d_ptr end
    end

    -- Parse Symbol Table
    if symtab > 0 and strtab > 0 then
        -- Get number of symbols from hash table if available
        local sym_count = 0
        if hash > 0 then
            local hash_header = gg.getValues({
                { address = LibBase + hash, flags = gg.TYPE_DWORD },      -- nbucket
                { address = LibBase + hash + 4, flags = gg.TYPE_DWORD }  -- nchain
            })
            sym_count = hash_header[2].value
        end
        
        -- If no hash table, estimate symbol count
        if sym_count == 0 then
            sym_count = 1000  -- Default estimate, can be adjusted
        end
        
        for i = 0, sym_count - 1 do
            local sym_addr = LibBase + symtab + (i * 16)  -- 16 bytes per symbol entry
            local sym_entry = gg.getValues({
                { address = sym_addr, flags = gg.TYPE_DWORD },       -- st_name
                { address = sym_addr + 4, flags = gg.TYPE_DWORD },   -- st_value
                { address = sym_addr + 8, flags = gg.TYPE_DWORD },    -- st_size
                { address = sym_addr + 12, flags = gg.TYPE_BYTE },   -- st_info
                { address = sym_addr + 13, flags = gg.TYPE_BYTE },  -- st_other
                { address = sym_addr + 14, flags = gg.TYPE_WORD }   -- st_shndx
            })
            
            local name_offset = sym_entry[1].value
            local name = name_offset > 0 and rdstr(LibBase + strtab + name_offset) or ""
            local sym_info = ParseSymbolInfo(sym_entry[4].value)
            
            Elf.Sym[i+1] = {
                name = name,
                st_name = name_offset,
                st_value = sym_entry[2].value,
                st_size = sym_entry[3].value,
                st_info = sym_entry[4].value,
                st_other = sym_entry[5].value,
                st_shndx = sym_entry[6].value,
                st_bind = sym_info.bind,
                st_type = sym_info.type
            }
        end
    end

    -- Parse PLT/GOT if available
    if pltgot > 0 then
        -- Parse first 3 GOT entries which are special
        Elf.Got = {
            { address = LibBase + pltgot, value = gg.getValues({{address = LibBase + pltgot, flags = gg.TYPE_DWORD}})[1].value },
            { address = LibBase + pltgot + 4, value = gg.getValues({{address = LibBase + pltgot + 4, flags = gg.TYPE_DWORD}})[1].value },
            { address = LibBase + pltgot + 8, value = gg.getValues({{address = LibBase + pltgot + 8, flags = gg.TYPE_DWORD}})[1].value }
        }
        
        -- Parse PLT relocations if available
        if jmprel > 0 and pltrelsz > 0 then
            local num_entries = pltrelsz / 8  -- Assuming 8 bytes per relocation entry
            for i = 0, num_entries - 1 do
                local rel_addr = LibBase + jmprel + (i * 8)
                local rel_entry = gg.getValues({
                    { address = rel_addr, flags = gg.TYPE_DWORD },      -- r_offset
                    { address = rel_addr + 4, flags = gg.TYPE_DWORD }  -- r_info
                })
                
                Elf.Rel[i+1] = {
                    r_offset = rel_entry[1].value,
                    r_info = rel_entry[2].value,
                    r_sym = (rel_entry[2].value >> 8),
                    r_type = (rel_entry[2].value & 0xFF)
                }
            end
        end
    end

    return Elf
end

-- Main execution
if not GetLibraryBase("libunity.so") then
    gg.alert("libunity.so not found!")
    return
end

local TargetLib = "libunity.so"
local LibBase = GetLibraryBase(TargetLib)
local Elf = GetLibInformation(TargetLib)

if Elf then
    -- Display basic ELF information
    gg.alert(string.format(
        "ELF Information for %s:\n" ..
        "Type: %s\n" ..
        "Machine: %s\n" ..
        "Entry Point: 0x%X\n" ..
        "Program Headers: %d\n" ..
        "Symbols: %d\n" ..
        "Dynamic Entries: %d",
        TargetLib,
        Elf.Type,
        Elf.Machine,
        Elf.EntryPoint,
        #Elf.pHdr,
        #Elf.Sym,
        #Elf.Dyn
    ))
    
    -- Example: Find and display specific symbols
    local interesting_symbols = {}
    for _, sym in ipairs(Elf.Sym) do
        if sym.name:match("^Unity") or sym.name:match("^il2cpp") then
            table.insert(interesting_symbols, string.format("%s @ 0x%X (%s, %s)", 
                sym.name, sym.st_value, sym.st_bind, sym.st_type))
        end
    end
    
    if #interesting_symbols > 0 then
        gg.alert("Found " .. #interesting_symbols .. " interesting symbols:\n" .. 
            table.concat(interesting_symbols, "\n"))
    else
        gg.alert("No interesting symbols found")
    end
else
    gg.alert("Failed to parse ELF information for " .. TargetLib)
end