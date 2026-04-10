
gv	= gg.getValues
sv	= gg.setValues
sf	= string.format
get = gg.getRangesList
un = get("libunity.so")[1].start
--------------------------------------------------------------------------------
function batHex(val)
return val>=0 and string.format("%X", tonumber(val)) or string.format("%X", (val~ 0xffffffffffffffff <<((math.floor(math.log(math.abs(val))/math.log(10)) + 1) *4)))
end
---------------------// Defined (Not Completed, I'm too lazy !) //-------------------------------
_OSABI		= { "System V", "HP-UX", "NetBSD", "Linux", "GNU Hurd", "Solaris", "AIX", "IRIX", "FreeBSD", "Tru64", "Novell Modesto", "OpenBSD", "OpenVMS", "NonStop Kernel", "AROS", "Fenix OS", "CloudABI" }
_Type		= { ["0"] = "ET_NONE", ["1"] = "ET_REL", ["2"] = "ET_EXEC", ["3"] = "ET_DYN", ["4"] = "ET_CORE", ["65024"] = "ET_LOOS", ["65279"] = "ET_HIOS", ["65280"] = "ET_LOPROC", ["65535"] = "ET_HIPROC" }
_Machine	= { ["0"] = "No Specific Instruction Set !", ["2"] = "SPARC", ["3"] = "x86", ["8"] = "MIPS", ["20"] = "PowerPC", ["22"] = "S390", ["40"] = "ARM", ["42"] = "SuperH", ["50"] = "IA-64", ["62"] = "x86-64", ["183"] = "AArch64", ["243"] = "RISC-V" }
_pHdrType	= { "PT_NULL", "PT_LOAD", "PT_DYNAMIC", "PT_INTERP", "PT_NOTE", "PT_SHLIB", "PT_PHDR" }
_DT			= { "DT_NULL", "DT_NEEDED", "DT_PLTRELSZ", "DT_PLTGOT", "DT_HASH", "DT_STRTAB", "DT_SYMTAB", "DT_RELA", "DT_RELASZ", "DT_RELAENT", "DT_STRSZ", "DT_SYMENT", "DT_INIT", "DT_FINI", "DT_SONAME", "DT_RPATH", "DT_SYMBOLIC", "DT_REL", "DT_RELSZ", "DT_RELENT", "DT_PLTREL", "DT_DEBUG", "DT_TEXTREL", "DT_JMPREL" }
_ST			= {"STT_NOTYPE", "STT_OBJECT", "STT_FUNC", "STT_SECTION", "STT_FILE", "STT_COMMON", "STT_TLS" }

function rwmem(Address, SizeOrBuffer)
  _rw = {}
  if type(SizeOrBuffer) == "number" then
    _ = ""
    for _ = 1, SizeOrBuffer do _rw[_] = {address = (Address - 1) + _, flags = gg.TYPE_BYTE} end
    for v, __ in ipairs(gv(_rw)) do _ = _ .. sf("%02X", __.value & 0xFF) end
    return _
  end
  Byte = {} SizeOrBuffer:gsub("..", function(x) 
      Byte[#Byte + 1] = x _rw[#Byte] = {address = (Address - 1) + #Byte, flags = gg.TYPE_BYTE, value = x .. "h"} 
  end)
  sv(_rw)
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
function GetLibInformation(LibName)
	local LibBase = GetLibraryBase(LibName)
	if LibBase ~= nil then
		_ = gv({
			{address = LibBase, flags = gg.TYPE_DWORD },		-- Magic
			{address = LibBase + 0x4, flags = gg.TYPE_BYTE },	-- Class
			{address = LibBase + 0x5, flags = gg.TYPE_BYTE },	-- Data
			{address = LibBase + 0x6, flags = gg.TYPE_BYTE },	-- Version
			{address = LibBase + 0x7, flags = gg.TYPE_BYTE },	-- OS ABI
			{address = LibBase + 0x8, flags = gg.TYPE_BYTE },	-- ABI Version
			-- EI_PAD skipped --
			{address = LibBase + 0x10, flags = gg.TYPE_WORD },	-- Type
			{address = LibBase + 0x12, flags = gg.TYPE_WORD },	-- Machine
			{address = LibBase + 0x14, flags = gg.TYPE_DWORD },	-- Version
			{address = LibBase + 0x18, flags = gg.TYPE_DWORD },	-- Entry Point
			{address = LibBase + 0x1C, flags = gg.TYPE_DWORD },	-- Program Header Table (PH) Offset
			{address = LibBase + 0x20, flags = gg.TYPE_DWORD },	-- Section Header Offset
			{address = LibBase + 0x24, flags = gg.TYPE_DWORD },	-- Flags
			{address = LibBase + 0x28, flags = gg.TYPE_WORD },	-- Elf Header Size
			{address = LibBase + 0x2A, flags = gg.TYPE_WORD },	-- Program Header Table (PH) Size Entry
			{address = LibBase + 0x2C, flags = gg.TYPE_WORD },	-- Number Of Entries In Program Header Table (PH) 
			{address = LibBase + 0x2E, flags = gg.TYPE_WORD },	-- Size Of Section Header Table Entry
			{address = LibBase + 0x30, flags = gg.TYPE_WORD },	-- Number of Entries In Section Header Table
			{address = LibBase + 0x32, flags = gg.TYPE_WORD },	-- Section Header String Index
			})
		local Elf = { -- Elf Information Table Structure--
			Magic		= _[1].value,
			Class		= _[2].value,
			Data		= _[3].value,
			Version		= _[4].value,
			OSABI		= _[5].value,
			ABIVer		= _[6].value,
			Type		= _[7].value,
			Machine 	= _[8].value,
			Version2	= _[9].value,
			EntryPoint 	= _[10].value,
			PHOffset 	= _[11].value,
			SHOffset	= _[12].value,
			Flags 		= _[13].value,
			HeaderSize 	= _[14].value,
			PHSize 		= _[15].value,
			PHNum		= _[16].value,
			SHSize 		= _[17].value,
			SHNum 		= _[18].value,
			SHStrIndex	= _[19].value,
			pHdr		= {},
			Dyn			= {},
			Sym			= {}
		}
		for _ = 1, Elf.PHNum do -- Parsing Program Header
			local _pHdr = LibBase + Elf.PHOffset + (_ * Elf.PHSize)
			local pHdr = gv({
				{ address = _pHdr, flags = gg.TYPE_DWORD }, 		-- p_type
				{ address = _pHdr + 4, flags = gg.TYPE_DWORD }, 	-- p_offset
				{ address = _pHdr + 8, flags = gg.TYPE_DWORD }, 	-- p_vaddr
				{ address = _pHdr + 0xC, flags = gg.TYPE_DWORD },	-- p_paddr
				{ address = _pHdr + 0x10, flags = gg.TYPE_DWORD },	-- p_filesz
				{ address = _pHdr + 0x14, flags = gg.TYPE_DWORD },	-- p_memsz
				{ address = _pHdr + 0x18, flags = gg.TYPE_DWORD },	-- p_flags
				{ address = _pHdr + 0x1C, flags = gg.TYPE_DWORD },	-- p_align
			})
			Elf.pHdr[_] = { -- All data in Program Header now in Elf.pHdr[Elf.PHNum]
				p_type		= pHdr[1].value,
				p_offset	= pHdr[2].value,
				p_vaddr		= pHdr[3].value,
				p_paddr		= pHdr[4].value,
				p_filesz	= pHdr[5].value,
				p_memsz		= pHdr[6].value,
				p_flags		= pHdr[7].value,
				p_align		= pHdr[8].value
			}
		end
		for _ = 1, Elf.PHNum do  -- Parsing Dynamic Segment
			if _pHdrType[Elf.pHdr[_].p_type + 1] == "PT_DYNAMIC" then
				local DynCount = 0
				while true do
					local _Dyn = gv({
						{ address = LibBase + Elf.pHdr[_].p_vaddr + (DynCount * 8), flags = gg.TYPE_DWORD }, -- d_tag
						{ address = LibBase + Elf.pHdr[_].p_vaddr + 4 + (DynCount * 8), flags = gg.TYPE_DWORD } -- d_ptr / d_val
					})
					if _Dyn[1].value == 0 and _Dyn[2].value == 0 then break end -- End of dynamic segment
					DynCount = DynCount + 1 -- Keep growing !
					Elf.Dyn[DynCount] = { -- All data in Dynamic Segment now in Elf.Dyn[Section]
						d_tag = _Dyn[1].value, 
						d_val = _Dyn[2].value, 
						d_ptr = _Dyn[2].value 
					}
				end
			end
		end
		---------------// Parsing symbol //------------------
		for _ = 1, #Elf.Dyn do
			if _DT[tonumber(Elf.Dyn[_].d_tag) + 1] == "DT_HASH" then nChain = gv({{address = (Elf.Dyn[_].d_ptr + 4) + LibBase, flags = gg.TYPE_DWORD}})[1].value end
			if _DT[tonumber(Elf.Dyn[_].d_tag) + 1] == "DT_STRTAB" then strtab = Elf.Dyn[_].d_ptr + LibBase end
			if _DT[tonumber(Elf.Dyn[_].d_tag) + 1] == "DT_SYMTAB" then symtab = Elf.Dyn[_].d_ptr + LibBase end
		end
		if nChain ~= nil then
			for _ = 1, nChain do
				local sym = symtab + (_ * 0x10)
				__ = gv({
					{ address = sym, flags = gg.TYPE_DWORD },		-- st_name
					{ address = sym + 0x4, flags = gg.TYPE_DWORD },	-- st_value
					{ address = sym + 0x8, flags = gg.TYPE_DWORD },	-- st_size
					{ address = sym + 0xC, flags = gg.TYPE_DWORD }	-- st_info
				})
				Elf.Sym[_] = {
					name		= rdstr(strtab + __[1].value),
					st_name		= __[1].value,
					st_value	= __[2].value,
					st_size		= __[3].value,
					st_info		= __[4].value
				}
			end
		end
		return Elf
	end
	return nil
end
-----------------------// scan library//--------------------------
if not GetLibraryBase("libunity.so") then
    gg.alert("libunity.so not found!")
    return
end

TargetLib = "libunity.so"
LibBase = GetLibraryBase(TargetLib)
Elf = GetLibInformation(TargetLib)

local ti = gg.getTargetInfo()
local function getUnityBase()
    for k, v in ipairs(gg.getRangesList("libunity.so")) do
        if v.state == "Xa" then
            return v.start
        end
    end
end
local unity_base = getUnityBase()
if unity_base == nil then
    return
end  
gg.clearResults()

local outputFile = "/storage/emulated/0/dumped_libunity.txt"

local file = io.open(outputFile, "w")
if file == nil then
    gg.alert("failed open file.")
    return
end
--------------------------------------------------------------------------------------------------------------------------------
gg.setRanges(gg.REGION_CODE_APP)
gg.searchNumber(":nativeSurfaceTextureReady", nil, nil, nil, unity_base)
if gg.getResultsCount() > 0 then
    local t = gg.getResults(1)
    gg.clearResults()
    gg.setRanges(gg.REGION_C_DATA)
    gg.searchNumber(t[1].address, ti.x64 and 32 or 4)
    if gg.getResultsCount() > 0 then
        t = gg.getResults(1)
        t[1].address = t[1].address + (ti.x64 and 0x8 or 0x4) * 2
        t = gg.getValues(t)
        t[1].address = t[1].value & (ti.x64 and t[1].value or 0xffffffff)
        t[1].name = string.format("// RVA: 0x%X\tVA: 0x%X\nvoid nativeSurfaceTextureReady(JNIEnv *env, jobject instance, jobject event) { }", t[1].address - unity_base, t[1].address - unity_base, t[1].address)
 file:write("\n//Dumped by Batman Games")
file:write("\n\n")
        file:write(t[1].name .. "\n\n")
    end
end
--------------------------------------------------------------------------------------------------------------------------------
gg.clearResults()
gg.setRanges(gg.REGION_CODE_APP)
gg.searchNumber(":nativeFrameReady", nil, nil, nil, unity_base)
if gg.getResultsCount() > 0 then
    local tt = gg.getResults(1)
    gg.clearResults()
    gg.setRanges(gg.REGION_C_DATA)
    gg.searchNumber(tt[1].address, ti.x64 and 32 or 4)
    if gg.getResultsCount() > 0 then
        tt = gg.getResults(1)
        tt[1].address = tt[1].address + (ti.x64 and 0x8 or 0x4) * 2
        tt = gg.getValues(tt)
        tt[1].address = tt[1].value & (ti.x64 and tt[1].value or 0xffffffff)
        tt[1].name = string.format("// RVA: 0x%X\tVA: 0x%X\nvoid nativeFrameReady(JNIEnv *env, jobject instance, jobject event) { }", tt[1].address - unity_base, tt[1].address - unity_base, tt[1].address)
        
        file:write(tt[1].name .. "\n\n")
    end
end
--------------------------------------------------------------------------------------------------------------------------------
gg.clearResults()
gg.setRanges(gg.REGION_CODE_APP)
gg.searchNumber(":nativeUpdateOrientationLockState", nil, nil, nil, unity_base)
if gg.getResultsCount() > 0 then
    local ttt = gg.getResults(1)
    gg.clearResults()
    gg.setRanges(gg.REGION_C_DATA)
    gg.searchNumber(ttt[1].address, ti.x64 and 32 or 4)
    if gg.getResultsCount() > 0 then
        ttt = gg.getResults(1)
        ttt[1].address = ttt[1].address + (ti.x64 and 0x8 or 0x4) * 2
        ttt = gg.getValues(ttt)
        ttt[1].address = ttt[1].value & (ti.x64 and ttt[1].value or 0xffffffff)
        ttt[1].name = string.format("// RVA: 0x%X\tVA: 0x%X\nvoid nativeUpdateOrientationLockState(JNIEnv *env, jobject instance, jobject event) { }", ttt[1].address - unity_base, ttt[1].address - unity_base, ttt[1].address)
        
        file:write(ttt[1].name .. "\n\n")
    end
end
--------------------------------------------------------------------------------------------------------------------------------
gg.clearResults()
gg.setRanges(gg.REGION_CODE_APP)
gg.searchNumber(":nativeInjectEvent", nil, nil, nil, unity_base)
if gg.getResultsCount() > 0 then
    local tttt = gg.getResults(1)
    gg.clearResults()
    gg.setRanges(gg.REGION_C_DATA)
    gg.searchNumber(tttt[1].address, ti.x64 and 32 or 4)
    if gg.getResultsCount() > 0 then
        tttt = gg.getResults(1)
        tttt[1].address = tttt[1].address + (ti.x64 and 0x8 or 0x4) * 2
        tttt = gg.getValues(tttt)
        tttt[1].address = tttt[1].value & (ti.x64 and tttt[1].value or 0xffffffff)
        tttt[1].name = string.format("// RVA: 0x%X\tVA: 0x%X\nvoid nativeInjectEvent(JNIEnv *env, jobject instance, jobject event) { }", tttt[1].address - unity_base, tttt[1].address - unity_base, tttt[1].address)
        
        file:write(tttt[1].name .. "\n\n")
    end
end
--------------------------------------------------------------------------------------------------------------------------------
gg.clearResults()
gg.setRanges(gg.REGION_CODE_APP)
gg.searchNumber(":nativeSetInputString", nil, nil, nil, unity_base)
if gg.getResultsCount() > 0 then
    local ttttt = gg.getResults(1)
    gg.clearResults()
    gg.setRanges(gg.REGION_C_DATA)
    gg.searchNumber(ttttt[1].address, ti.x64 and 32 or 4)
    if gg.getResultsCount() > 0 then
        ttttt = gg.getResults(1)
        ttttt[1].address = ttttt[1].address + (ti.x64 and 0x8 or 0x4) * 2
        ttttt = gg.getValues(ttttt)
        ttttt[1].address = ttttt[1].value & (ti.x64 and ttttt[1].value or 0xffffffff)
        ttttt[1].name = string.format("// RVA: 0x%X\tVA: 0x%X\nvoid nativeSetInputString(JNIEnv *env, jobject instance, jobject event) { }", ttttt[1].address - unity_base, ttttt[1].address - unity_base, ttttt[1].address)
        
        file:write(ttttt[1].name .. "\n\n")
        
    end
end
--------------------------------------------------------------------------------------------------------------------------------
gg.clearResults()
gg.setRanges(gg.REGION_CODE_APP)
gg.searchNumber(":nativeSetLaunchURL", nil, nil, nil, unity_base)
if gg.getResultsCount() > 0 then
    local a = gg.getResults(1)
    gg.clearResults()
    gg.setRanges(gg.REGION_C_DATA)
    gg.searchNumber(a[1].address, ti.x64 and 32 or 4)
    if gg.getResultsCount() > 0 then
        a = gg.getResults(1)
        a[1].address = a[1].address + (ti.x64 and 0x8 or 0x4) * 2
        a = gg.getValues(a)
        a[1].address = a[1].value & (ti.x64 and a[1].value or 0xffffffff)
        a[1].name = string.format("// RVA: 0x%X\tVA: 0x%X\nvoid nativeSetLaunchURL(JNIEnv *env, jobject instance, jobject event) { }", a[1].address - unity_base, a[1].address - unity_base, a[1].address)
        
        file:write(a[1].name .. "\n\n")
    end
end

gg.clearResults()
gg.setRanges(gg.REGION_CODE_APP)
gg.searchNumber(":nativeDone", nil, nil, nil, unity_base)
if gg.getResultsCount() > 0 then
    local aa = gg.getResults(1)
    gg.clearResults()
    gg.setRanges(gg.REGION_C_DATA)
    gg.searchNumber(aa[1].address, ti.x64 and 32 or 4)
    if gg.getResultsCount() > 0 then
        aa = gg.getResults(1)
        aa[1].address = aa[1].address + (ti.x64 and 0x8 or 0x4) * 2
        aa = gg.getValues(aa)
        aa[1].address = aa[1].value & (ti.x64 and aa[1].value or 0xffffffff)
        aa[1].name = string.format("// RVA: 0x%X\tVA: 0x%X\nvoid nativeDone(JNIEnv *env, jobject instance, jobject event) { }", aa[1].address - unity_base, aa[1].address - unity_base, aa[1].address)
        
        file:write(aa[1].name .. "\n\n")
    end
end

gg.clearResults()
gg.setRanges(gg.REGION_CODE_APP)
gg.searchNumber(":nativePause", nil, nil, nil, unity_base)
if gg.getResultsCount() > 0 then
    local bb = gg.getResults(1)
    gg.clearResults()
    gg.setRanges(gg.REGION_C_DATA)
    gg.searchNumber(bb[1].address, ti.x64 and 32 or 4)
    if gg.getResultsCount() > 0 then
        bb = gg.getResults(1)
        bb[1].address = bb[1].address + (ti.x64 and 0x8 or 0x4) * 2
        bb = gg.getValues(bb)
        bb[1].address = bb[1].value & (ti.x64 and bb[1].value or 0xffffffff)
        bb[1].name = string.format("// RVA: 0x%X\tVA: 0x%X\nvoid nativePause(JNIEnv *env, jobject instance, jobject event) { }", bb[1].address - unity_base, bb[1].address - unity_base, bb[1].address)
        
        file:write(bb[1].name .. "\n\n")
    end
end

gg.clearResults()
gg.setRanges(gg.REGION_CODE_APP)
gg.searchNumber(":nativeRecreateGfxState", nil, nil, nil, unity_base)
if gg.getResultsCount() > 0 then
    local cc = gg.getResults(1)
    gg.clearResults()
    gg.setRanges(gg.REGION_C_DATA)
    gg.searchNumber(cc[1].address, ti.x64 and 32 or 4)
    if gg.getResultsCount() > 0 then
        cc = gg.getResults(1)
        cc[1].address = cc[1].address + (ti.x64 and 0x8 or 0x4) * 2
        cc = gg.getValues(cc)
        cc[1].address = cc[1].value & (ti.x64 and cc[1].value or 0xffffffff)
        cc[1].name = string.format("// RVA: 0x%X\tVA: 0x%X\nvoid nativeRecreateGfxState(JNIEnv *env, jobject instance, jobject event) { }", cc[1].address - unity_base, cc[1].address - unity_base, cc[1].address)
        
        file:write(cc[1].name .. "\n\n")
    end
end

gg.clearResults()
gg.setRanges(gg.REGION_CODE_APP)
gg.searchNumber(":nativeSendSurfaceChangedEvent", nil, nil, nil, unity_base)
if gg.getResultsCount() > 0 then
    local dd = gg.getResults(1)
    gg.clearResults()
    gg.setRanges(gg.REGION_C_DATA)
    gg.searchNumber(dd[1].address, ti.x64 and 32 or 4)
    if gg.getResultsCount() > 0 then
        dd = gg.getResults(1)
        dd[1].address = dd[1].address + (ti.x64 and 0x8 or 0x4) * 2
        dd = gg.getValues(dd)
        dd[1].address = dd[1].value & (ti.x64 and dd[1].value or 0xffffffff)
        dd[1].name = string.format("// RVA: 0x%X\tVA: 0x%X\nvoid nativeSendSurfaceChangedEvent(JNIEnv *env, jobject instance, jobject event) { }", dd[1].address - unity_base, dd[1].address - unity_base, dd[1].address)
        
        file:write(dd[1].name .. "\n\n")
    end
end

gg.clearResults()
gg.setRanges(gg.REGION_CODE_APP)
gg.searchNumber(":nativeRender", nil, nil, nil, unity_base)
if gg.getResultsCount() > 0 then
    local ddd = gg.getResults(1)
    gg.clearResults()
    gg.setRanges(gg.REGION_C_DATA)
    gg.searchNumber(ddd[1].address, ti.x64 and 32 or 4)
    if gg.getResultsCount() > 0 then
        ddd = gg.getResults(1)
        ddd[1].address = ddd[1].address + (ti.x64 and 0x8 or 0x4) * 2
        ddd = gg.getValues(ddd)
        ddd[1].address = ddd[1].value & (ti.x64 and ddd[1].value or 0xffffffff)
        ddd[1].name = string.format("// RVA: 0x%X\tVA: 0x%X\nvoid  nativeRender(JNIEnv *env, jobject instance, jobject event) { }", ddd[1].address - unity_base, ddd[1].address - unity_base, ddd[1].address)
        
        file:write(ddd[1].name .. "\n\n")
        
    end
end

gg.clearResults()
gg.setRanges(gg.REGION_CODE_APP)
gg.searchNumber(":nativeResume", nil, nil, nil, unity_base)
if gg.getResultsCount() > 0 then
    local eee = gg.getResults(1)
    gg.clearResults()
    gg.setRanges(gg.REGION_C_DATA)
    gg.searchNumber(eee[1].address, ti.x64 and 32 or 4)
    if gg.getResultsCount() > 0 then
        eee = gg.getResults(1)
        eee[1].address = eee[1].address + (ti.x64 and 0x8 or 0x4) * 2
        eee = gg.getValues(eee)
        eee[1].address = eee[1].value & (ti.x64 and eee[1].value or 0xffffffff)
        eee[1].name = string.format("// RVA: 0x%X\tVA: 0x%X\nvoid  nativeResume(JNIEnv *env, jobject instance, jobject event) { }", eee[1].address - unity_base, eee[1].address - unity_base, eee[1].address)
        
        file:write(eee[1].name .. "\n\n")
    end
end

gg.clearResults()
gg.setRanges(gg.REGION_CODE_APP)
gg.searchNumber(":nativeLowMemory", nil, nil, nil, unity_base)
if gg.getResultsCount() > 0 then
    local eeea = gg.getResults(1)
    gg.clearResults()
    gg.setRanges(gg.REGION_C_DATA)
    gg.searchNumber(eeea[1].address, ti.x64 and 32 or 4)
    if gg.getResultsCount() > 0 then
        eeea = gg.getResults(1)
        eeea[1].address = eeea[1].address + (ti.x64 and 0x8 or 0x4) * 2
        eeea = gg.getValues(eeea)
        eeea[1].address = eeea[1].value & (ti.x64 and eeea[1].value or 0xffffffff)
        eeea[1].name = string.format("// RVA: 0x%X\tVA: 0x%X\nvoid  nativeLowMemory(JNIEnv *env, jobject instance, jobject event) { }", eeea[1].address - unity_base, eeea[1].address - unity_base, eeea[1].address)
        
        file:write(eeea[1].name .. "\n\n")
    end
end

gg.clearResults()
gg.setRanges(gg.REGION_CODE_APP)
gg.searchNumber(":nativeApplicationUnload", nil, nil, nil, unity_base)
if gg.getResultsCount() > 0 then
    local fffb = gg.getResults(1)
    gg.clearResults()
    gg.setRanges(gg.REGION_C_DATA)
    gg.searchNumber(fffb[1].address, ti.x64 and 32 or 4)
    if gg.getResultsCount() > 0 then
        fffb = gg.getResults(1)
        fffb[1].address = fffb[1].address + (ti.x64 and 0x8 or 0x4) * 2
        fffb = gg.getValues(fffb)
        fffb[1].address = fffb[1].value & (ti.x64 and fffb[1].value or 0xffffffff)
        fffb[1].name = string.format("// RVA: 0x%X\tVA: 0x%X\nvoid  nativeApplicationUnload(JNIEnv *env, jobject instance, jobject event) { }", fffb[1].address - unity_base, fffb[1].address - unity_base, fffb[1].address)
        
        file:write(fffb[1].name .. "\n\n")
    end
end

gg.clearResults()
gg.setRanges(gg.REGION_CODE_APP)
gg.searchNumber(":nativeFocusChanged", nil, nil, nil, unity_base)
if gg.getResultsCount() > 0 then
    local ggg = gg.getResults(1)
    gg.clearResults()
    gg.setRanges(gg.REGION_C_DATA)
    gg.searchNumber(ggg[1].address, ti.x64 and 32 or 4)
    if gg.getResultsCount() > 0 then
        ggg = gg.getResults(1)
        ggg[1].address = ggg[1].address + (ti.x64 and 0x8 or 0x4) * 2
        ggg = gg.getValues(ggg)
        ggg[1].address = ggg[1].value & (ti.x64 and ggg[1].value or 0xffffffff)
        ggg[1].name = string.format("// RVA: 0x%X\tVA: 0x%X\nvoid  nativeFocusChanged(JNIEnv *env, jobject instance, jobject event) { }", ggg[1].address - unity_base, ggg[1].address - unity_base, ggg[1].address)
        
        file:write(ggg[1].name .. "\n\n")
    end
end

gg.clearResults()
gg.setRanges(gg.REGION_CODE_APP)
gg.searchNumber(":nativeSetInputArea", nil, nil, nil, unity_base)
if gg.getResultsCount() > 0 then
    local hhh = gg.getResults(1)
    gg.clearResults()
    gg.setRanges(gg.REGION_C_DATA)
    gg.searchNumber(hhh[1].address, ti.x64 and 32 or 4)
    if gg.getResultsCount() > 0 then
        hhh = gg.getResults(1)
        hhh[1].address = hhh[1].address + (ti.x64 and 0x8 or 0x4) * 2
        hhh = gg.getValues(hhh)
        hhh[1].address = hhh[1].value & (ti.x64 and hhh[1].value or 0xffffffff)
        hhh[1].name = string.format("// RVA: 0x%X\tVA: 0x%X\nvoid  nativeSetInputArea(JNIEnv *env, jobject instance, jobject event) { }", hhh[1].address - unity_base, hhh[1].address - unity_base, hhh[1].address)
        
        file:write(hhh[1].name .. "\n\n")
    end
end

gg.clearResults()
gg.setRanges(gg.REGION_CODE_APP)
gg.searchNumber(":nativeSetKeyboardIsVisible", nil, nil, nil, unity_base)
if gg.getResultsCount() > 0 then
    local hhha = gg.getResults(1)
    gg.clearResults()
    gg.setRanges(gg.REGION_C_DATA)
    gg.searchNumber(hhha[1].address, ti.x64 and 32 or 4)
    if gg.getResultsCount() > 0 then
        hhha = gg.getResults(1)
        hhha[1].address = hhha[1].address + (ti.x64 and 0x8 or 0x4) * 2
        hhha = gg.getValues(hhha)
        hhha[1].address = hhha[1].value & (ti.x64 and hhha[1].value or 0xffffffff)
        hhha[1].name = string.format("// RVA: 0x%X\tVA: 0x%X\n boolean   nativeSetKeyboardIsVisible(JNIEnv *env, jobject instance, jobject event) { }", hhha[1].address - unity_base, hhha[1].address - unity_base, hhha[1].address)
        
        file:write(hhha[1].name .. "\n\n")
    end
end

gg.clearResults()
gg.setRanges(gg.REGION_CODE_APP)
gg.searchNumber(":nativeSetInputSelection", nil, nil, nil, unity_base)
if gg.getResultsCount() > 0 then
    local iiib = gg.getResults(1)
    gg.clearResults()
    gg.setRanges(gg.REGION_C_DATA)
    gg.searchNumber(iiib[1].address, ti.x64 and 32 or 4)
    if gg.getResultsCount() > 0 then
        iiib = gg.getResults(1)
        iiib[1].address = iiib[1].address + (ti.x64 and 0x8 or 0x4) * 2
        iiib = gg.getValues(iiib)
        iiib[1].address = iiib[1].value & (ti.x64 and iiib[1].value or 0xffffffff)
        iiib[1].name = string.format("// RVA: 0x%X\tVA: 0x%X\n boolean    nativeSetInputSelection(JNIEnv *env, jobject instance, jobject event) { }", iiib[1].address - unity_base, iiib[1].address - unity_base, iiib[1].address)
        
        file:write(iiib[1].name .. "\n\n")
    end
end

gg.clearResults()
gg.setRanges(gg.REGION_CODE_APP)
gg.searchNumber(":nativeSoftInputClosed", nil, nil, nil, unity_base)
if gg.getResultsCount() > 0 then
    local jjj = gg.getResults(1)
    gg.clearResults()
    gg.setRanges(gg.REGION_C_DATA)
    gg.searchNumber(jjj[1].address, ti.x64 and 32 or 4)
    if gg.getResultsCount() > 0 then
        jjj = gg.getResults(1)
        jjj[1].address = jjj[1].address + (ti.x64 and 0x8 or 0x4) * 2
        jjj = gg.getValues(jjj)
        jjj[1].address = jjj[1].value & (ti.x64 and jjj[1].value or 0xffffffff)
        jjj[1].name = string.format("// RVA: 0x%X\tVA: 0x%X\n boolean    nativeSoftInputClosed(JNIEnv *env, jobject instance, jobject event) { }", jjj[1].address - unity_base, jjj[1].address - unity_base, jjj[1].address)
        
        file:write(jjj[1].name .. "\n\n")
    end
end

gg.clearResults()
gg.setRanges(gg.REGION_CODE_APP)
gg.searchNumber(":nativeSoftInputCanceled", nil, nil, nil, unity_base)
if gg.getResultsCount() > 0 then
    local kkk = gg.getResults(1)
    gg.clearResults()
    gg.setRanges(gg.REGION_C_DATA)
    gg.searchNumber(kkk[1].address, ti.x64 and 32 or 4)
    if gg.getResultsCount() > 0 then
        kkk = gg.getResults(1)
        kkk[1].address = kkk[1].address + (ti.x64 and 0x8 or 0x4) * 2
        kkk = gg.getValues(kkk)
        kkk[1].address = kkk[1].value & (ti.x64 and kkk[1].value or 0xffffffff)
        kkk[1].name = string.format("// RVA: 0x%X\tVA: 0x%X\n boolean    nativeSoftInputCanceled(JNIEnv *env, jobject instance, jobject event) { }", kkk[1].address - unity_base, kkk[1].address - unity_base, kkk[1].address)
        
        file:write(kkk[1].name .. "\n\n")
    end
end

gg.clearResults()
gg.setRanges(gg.REGION_CODE_APP)
gg.searchNumber(":nativeReportKeyboardConfigChanged", nil, nil, nil, unity_base)
if gg.getResultsCount() > 0 then
    local LLL = gg.getResults(1)
    gg.clearResults()
    gg.setRanges(gg.REGION_C_DATA)
    gg.searchNumber(LLL[1].address, ti.x64 and 32 or 4)
    if gg.getResultsCount() > 0 then
        LLL = gg.getResults(1)
        LLL[1].address = LLL[1].address + (ti.x64 and 0x8 or 0x4) * 2
        LLL = gg.getValues(LLL)
        LLL[1].address = LLL[1].value & (ti.x64 and LLL[1].value or 0xffffffff)
        LLL[1].name = string.format("// RVA: 0x%X\tVA: 0x%X\n boolean  nativeReportKeyboardConfigChanged(JNIEnv *env, jobject instance, jobject event) { }", LLL[1].address - unity_base, LLL[1].address - unity_base, LLL[1].address)
        
        file:write(LLL[1].name .. "\n\n")
    end
end

gg.clearResults()
gg.setRanges(gg.REGION_CODE_APP)
gg.searchNumber(":nativeSoftInputLostFocus", nil, nil, nil, unity_base)
if gg.getResultsCount() > 0 then
    local mmm = gg.getResults(1)
    gg.clearResults()
    gg.setRanges(gg.REGION_C_DATA)
    gg.searchNumber(mmm[1].address, ti.x64 and 32 or 4)
    if gg.getResultsCount() > 0 then
        mmm = gg.getResults(1)
        mmm[1].address = mmm[1].address + (ti.x64 and 0x8 or 0x4) * 2
        mmm = gg.getValues(mmm)
        mmm[1].address = mmm[1].value & (ti.x64 and mmm[1].value or 0xffffffff)
        mmm[1].name = string.format("// RVA: 0x%X\tVA: 0x%X\n boolean    nativeSoftInputLostFocus(JNIEnv *env, jobject instance, jobject event) { }", mmm[1].address - unity_base, mmm[1].address - unity_base, mmm[1].address)
        
        file:write(mmm[1].name .. "\n\n")
    end
end

gg.clearResults()
gg.setRanges(gg.REGION_CODE_APP)
gg.searchNumber(":nativeUnitySendMessage", nil, nil, nil, unity_base)
if gg.getResultsCount() > 0 then
    local nnn = gg.getResults(1)
    gg.clearResults()
    gg.setRanges(gg.REGION_C_DATA)
    gg.searchNumber(nnn[1].address, ti.x64 and 32 or 4)
    if gg.getResultsCount() > 0 then
        nnn = gg.getResults(1)
        nnn[1].address = nnn[1].address + (ti.x64 and 0x8 or 0x4) * 2
        nnn = gg.getValues(nnn)
        nnn[1].address = nnn[1].value & (ti.x64 and nnn[1].value or 0xffffffff)
        nnn[1].name = string.format("// RVA: 0x%X\tVA: 0x%X\nstring   nativeUnitySendMessage(JNIEnv *env, jobject instance, jobject event) { }", nnn[1].address - unity_base, nnn[1].address - unity_base, nnn[1].address)
        
        file:write(nnn[1].name .. "\n\n")
    end
end

gg.clearResults()
gg.setRanges(gg.REGION_CODE_APP)
gg.searchNumber(":nativeIsAutorotationOn", nil, nil, nil, unity_base)
if gg.getResultsCount() > 0 then
    local ooo = gg.getResults(1)
    gg.clearResults()
    gg.setRanges(gg.REGION_C_DATA)
    gg.searchNumber(ooo[1].address, ti.x64 and 32 or 4)
    if gg.getResultsCount() > 0 then
        ooo = gg.getResults(1)
        ooo[1].address = ooo[1].address + (ti.x64 and 0x8 or 0x4) * 2
        ooo = gg.getValues(ooo)
        ooo[1].address = ooo[1].value & (ti.x64 and ooo[1].value or 0xffffffff)
        ooo[1].name = string.format("// RVA: 0x%X\tVA: 0x%X\ndouble  nativeIsAutorotationOn(JNIEnv *env, jobject instance, jobject event) { }", ooo[1].address - unity_base, ooo[1].address - unity_base, ooo[1].address)
        
        file:write(ooo[1].name .. "\n\n")
    end
end

gg.clearResults()
gg.setRanges(gg.REGION_CODE_APP)
gg.searchNumber(":nativeMuteMasterAudio", nil, nil, nil, unity_base)
if gg.getResultsCount() > 0 then
    local ppp = gg.getResults(1)
    gg.clearResults()
    gg.setRanges(gg.REGION_C_DATA)
    gg.searchNumber(ppp[1].address, ti.x64 and 32 or 4)
    if gg.getResultsCount() > 0 then
        ppp = gg.getResults(1)
        ppp[1].address = ppp[1].address + (ti.x64 and 0x8 or 0x4) * 2
        ppp = gg.getValues(ppp)
        ppp[1].address = ppp[1].value & (ti.x64 and ppp[1].value or 0xffffffff)
        ppp[1].name = string.format("// RVA: 0x%X\tVA: 0x%X\ndouble  nativeMuteMasterAudio(JNIEnv *env, jobject instance, jobject event) { }", ppp[1].address - unity_base, ppp[1].address - unity_base, ppp[1].address)
        
        file:write(ppp[1].name .. "\n\n")
    end
end

gg.clearResults()
gg.setRanges(gg.REGION_CODE_APP)
gg.searchNumber(":nativeRestartActivityIndicator", nil, nil, nil, unity_base)
if gg.getResultsCount() > 0 then
    local qqq = gg.getResults(1)
    gg.clearResults()
    gg.setRanges(gg.REGION_C_DATA)
    gg.searchNumber(qqq[1].address, ti.x64 and 32 or 4)
    if gg.getResultsCount() > 0 then
        qqq = gg.getResults(1)
        qqq[1].address = qqq[1].address + (ti.x64 and 0x8 or 0x4) * 2
        qqq = gg.getValues(qqq)
        qqq[1].address = qqq[1].value & (ti.x64 and qqq[1].value or 0xffffffff)
        qqq[1].name = string.format("// RVA: 0x%X\tVA: 0x%X\ndouble  nativeRestartActivityIndicator(JNIEnv *env, jobject instance, jobject event) { }", qqq[1].address - unity_base, qqq[1].address - unity_base, qqq[1].address)
        
        file:write(qqq[1].name .. "\n\n")
    end
end

gg.clearResults()
gg.setRanges(gg.REGION_CODE_APP)
gg.searchNumber(":nativeOrientationChanged", nil, nil, nil, unity_base)
if gg.getResultsCount() > 0 then
    local rrr = gg.getResults(1)
    gg.clearResults()
    gg.setRanges(gg.REGION_C_DATA)
    gg.searchNumber(rrr[1].address, ti.x64 and 32 or 4)
    if gg.getResultsCount() > 0 then
        rrr = gg.getResults(1)
        rrr[1].address = rrr[1].address + (ti.x64 and 0x8 or 0x4) * 2
        rrr = gg.getValues(rrr)
        rrr[1].address = rrr[1].value & (ti.x64 and rrr[1].value or 0xffffffff)
        rrr[1].name = string.format("// RVA: 0x%X\tVA: 0x%X\ndouble  nativeOrientationChanged(JNIEnv *env, jobject instance, jobject event) { }", rrr[1].address - unity_base, rrr[1].address - unity_base, rrr[1].address)
        
        file:write(rrr[1].name .. "\n\n")
    end
end

gg.clearResults()
gg.setRanges(gg.REGION_CODE_APP)
gg.searchNumber(":nOnChoreographer", nil, nil, nil, unity_base)
if gg.getResultsCount() > 0 then
    local sss = gg.getResults(1)
    gg.clearResults()
    gg.setRanges(gg.REGION_C_DATA)
    gg.searchNumber(sss[1].address, ti.x64 and 32 or 4)
    if gg.getResultsCount() > 0 then
        sss = gg.getResults(1)
        sss[1].address = sss[1].address + (ti.x64 and 0x8 or 0x4) * 2
        sss = gg.getValues(sss)
        sss[1].address = sss[1].value & (ti.x64 and sss[1].value or 0xffffffff)
        sss[1].name = string.format("// RVA: 0x%X\tVA: 0x%X\ndouble  nOnChoreographer(JNIEnv *env, jobject instance, jobject event) { }", sss[1].address - unity_base, sss[1].address - unity_base, sss[1].address)
        
        file:write(sss[1].name .. "\n\n") 
    end
end

gg.clearResults()
gg.setRanges(gg.REGION_CODE_APP)
gg.searchNumber(":nOnRefreshPeriodChanged", nil, nil, nil, unity_base)
if gg.getResultsCount() > 0 then
    local SSS = gg.getResults(1)
    gg.clearResults()
    gg.setRanges(gg.REGION_C_DATA)
    gg.searchNumber(SSS[1].address, ti.x64 and 32 or 4)
    if gg.getResultsCount() > 0 then
        SSS = gg.getResults(1)
        SSS[1].address = SSS[1].address + (ti.x64 and 0x8 or 0x4) * 2
        SSS = gg.getValues(SSS)
        SSS[1].address = SSS[1].value & (ti.x64 and SSS[1].value or 0xffffffff)
        SSS[1].name = string.format("// RVA: 0x%X\tVA: 0x%X\ndouble  nOnRefreshPeriodChanged(JNIEnv *env, jobject instance, jobject event) { }", SSS[1].address - unity_base, SSS[1].address - unity_base, SSS[1].address)
        
        file:write(SSS[1].name .. "\n\n")
    end
end

gg.clearResults()
gg.setRanges(gg.REGION_CODE_APP)
gg.searchNumber(":nSetSupportedRefreshPeriods", nil, nil, nil, unity_base)
if gg.getResultsCount() > 0 then
    local vvv = gg.getResults(1)
    gg.clearResults()
    gg.setRanges(gg.REGION_C_DATA)
    gg.searchNumber(vvv[1].address, ti.x64 and 32 or 4)
    if gg.getResultsCount() > 0 then
        vvv = gg.getResults(1)
        vvv[1].address = vvv[1].address + (ti.x64 and 0x8 or 0x4) * 2
        vvv = gg.getValues(vvv)
        vvv[1].address = vvv[1].value & (ti.x64 and vvv[1].value or 0xffffffff)
        vvv[1].name = string.format("// RVA: 0x%X\tVA: 0x%X\ndouble  nSetSupportedRefreshPeriods(JNIEnv *env, jobject instance, jobject event) { }", vvv[1].address - unity_base, vvv[1].address - unity_base, vvv[1].address)
        
        file:write(vvv[1].name .. "\n\n")
    end
end

gg.clearResults()
gg.setRanges(gg.REGION_CODE_APP)
gg.searchNumber(":nativeStatusQueryResult", nil, nil, nil, unity_base)
if gg.getResultsCount() > 0 then
    local hsa = gg.getResults(1)
    gg.clearResults()
    gg.setRanges(gg.REGION_C_DATA)
    gg.searchNumber(hsa[1].address, ti.x64 and 32 or 4)
    if gg.getResultsCount() > 0 then
        hsa = gg.getResults(1)
        hsa[1].address = hsa[1].address + (ti.x64 and 0x8 or 0x4) * 2
        hsa = gg.getValues(hsa)
        hsa[1].address = hsa[1].value & (ti.x64 and hsa[1].value or 0xffffffff)
        hsa[1].name = string.format("// RVA: 0x%X\tVA: 0x%X\nvoid nativeStatusQueryResult(JNIEnv *env, jobject instance, jobject event) { }", hsa[1].address - unity_base, hsa[1].address - unity_base, hsa[1].address)
        
        file:write(hsa[1].name .. "\n\n")
    end
end

gg.clearResults()
gg.setRanges(gg.REGION_CODE_APP)
gg.searchNumber("-0.50347691774;9.99999997e-7:9", gg.TYPE_FLOAT)
gg.refineNumber("9.99999997e-7", gg.TYPE_FLOAT)
if gg.getResultsCount() > 0 then
    local results = gg.getResults(1)
    for i, result in ipairs(results) do
        local S = {}
        S[1] = result.address
        file:write('//RVA: 0x'..batHex(S[1]-un)..' ')
        file:write('   VA: 0x'..batHex(S[1]-un)..' ')
        file:write("\n")
        file:write('float  Wallhack() { }') 
   file:write("\n\n")
 end
end

gg.clearResults()
gg.setRanges(gg.REGION_CODE_APP)
gg.searchNumber("-7.16145955e24;0.00100000005::5", gg.TYPE_FLOAT)
gg.refineNumber("0.00100000005", gg.TYPE_FLOAT)
        fre = gg.getResults(1)
        if gg.getResultsCount() == 1 then
            local SSS = {}
            SSS[1] = fre[1].address
            file:write('//RVA: 0x'..batHex(SSS[1]-un)..' ')
            file:write('   VA: 0x'..batHex(SSS[1]-un)..' ')
            file:write("\n")
            file:write('float  setAlphaColor() { }') 
       file:write("\n\n")
       end

gg.clearResults()
gg.setRanges(gg.REGION_CODE_APP)
gg.searchNumber("-7.16042653e24;360;3.14159274101::9", gg.TYPE_FLOAT)
gg.refineNumber("360", gg.TYPE_FLOAT)
local roo = gg.getResults(1)
if gg.getResultsCount() == 1 then
    local SS = {}
    SS[1] = roo[1].address
    file:write('//RVA: 0x'..batHex(SS[1]-un)..' ')
    file:write('   VA: 0x'..batHex(SS[1]-un)..' ')
    file:write("\n")
    file:write('float  camera360() { }') 
file:write("\n\n")
else
    gg.searchNumber("-7.15917215e24;360;3.14159274101::9", gg.TYPE_FLOAT)
    gg.refineNumber("360", gg.TYPE_FLOAT)
    roo = gg.getResults(1)
    if gg.getResultsCount() == 1 then
        local SS = {}
        SS[1] = roo[1].address
        file:write('//RVA: 0x'..batHex(SS[1]-un)..' ')
        file:write('   VA: 0x'..batHex(SS[1]-un)..' ')
        file:write("\n")
        file:write('float  camera360() { }') 
  file:write("\n\n")
  else
        gg.searchNumber("360;3.14159274101::5", gg.TYPE_FLOAT)
        gg.refineNumber("360", gg.TYPE_FLOAT)
        roo = gg.getResults(1)
        if gg.getResultsCount() == 1 then
            local SS = {}
            SS[1] = roo[1].address
            file:write('//RVA: 0x'..batHex(SS[1]-un)..' ')
            file:write('   VA: 0x'..batHex(SS[1]-un)..' ')
            file:write("\n")
            file:write('float  camera360() { }') 
       file:write("\n\n")
 else
           gg.searchNumber("-7.16919215e24~-7.15917215e24;360;3.14159274101::9", gg.TYPE_FLOAT)
            gg.refineNumber("360", gg.TYPE_FLOAT)
            roo = gg.getResults(1)
            if gg.getResultsCount() == 1 then
                local SS = {}
                SS[1] = roo[1].address
                file:write('//RVA: 0x'..batHex(SS[1]-un)..' ')
                file:write('   VA: 0x'..batHex(SS[1]-un)..' ')
                file:write("\n")
                file:write('float  camera360() { }') 
            file:write("\n\n")
           end
        end
    end
end

gg.clearResults()
gg.searchNumber("-2188690589493493752;-2220275583137349632:25", gg.TYPE_QWORD)


--gg.searchNumber("-448F;-388,099.5F;240F;-2188690589493493752;-2220275583137349632:2961", gg.TYPE_QWORD)


gg.refineNumber("-2220275583137349632", gg.TYPE_QWORD)
     
freee= gg.getResults(1)
        if gg.getResultsCount() == 1 then
            local SSSSS = {}
            SSSSS[1] = freee[1].address
            file:write('//RVA: 0x'..batHex(SSSSS[1]-un)..' ')
            file:write('   VA: 0x'..batHex(SSSSS[1]-un)..' ')
            file:write("\n")
            file:write('float  speedMusic() { }') 
       file:write("\n\n")
       gg.clearResults()
       end

gg.clearResults()
gg.setRanges(gg.REGION_CODE_APP)
gg.searchNumber("0.99000000954;0.57735025883;0.00999999978;9.99999997e-7:13", gg.TYPE_FLOAT)
gg.refineNumber("9.99999997e-7", gg.TYPE_FLOAT)
     free= gg.getResults(1)
        if gg.getResultsCount() == 1 then
            local SSSS = {}
            SSSS[1] = free[1].address
            file:write('//RVA: 0x'..batHex(SSSS[1]-un)..' ')
            file:write('   VA: 0x'..batHex(SSSS[1]-un)..' ')
            file:write("\n")
            file:write('float  Blacksky() { }') 
       file:write("\n\n")
       gg.clearResults()
       end

gg.clearResults()
gg.setRanges(gg.REGION_CODE_APP)
gg.searchNumber("1.74909376e-13;0.00001:21", gg.TYPE_FLOAT)
gg.refineNumber("0.00001", gg.TYPE_FLOAT)
     fly= gg.getResults(1)
        if gg.getResultsCount() == 1 then
            local FFF = {}
            FFF[1] = fly[1].address
            file:write('//RVA: 0x'..batHex(FFF[1]-un)..' ')
            file:write('   VA: 0x'..batHex(FFF[1]-un)..' ')
            file:write("\n")
            file:write('float  FlyHack() { }') 
       file:write("\n\n")
       gg.clearResults()
       end

gg.clearResults()
gg.setRanges(gg.REGION_CODE_APP)
gg.searchNumber("0.70710676908;0.9238795042;0.38268342614::9", gg.TYPE_FLOAT)
gg.refineNumber("0.70710676908", gg.TYPE_FLOAT)
     sou= gg.getResults(1)
        if gg.getResultsCount() == 1 then
            local GGG = {}
            GGG[1] = sou[1].address
            file:write('//RVA: 0x'..batHex(GGG[1]-un)..' ')
            file:write('   VA: 0x'..batHex(GGG[1]-un)..' ')
            file:write("\n")
            file:write('float  sound() { }') 
       file:write("\n\n")
       gg.clearResults()
       end
       
       
gg.clearResults()
gg.setRanges(gg.REGION_CODE_APP)
gg.searchNumber("0;1000;11,273.5:89", gg.TYPE_FLOAT)
gg.refineNumber("1000", gg.TYPE_FLOAT)
     rem= gg.getResults(1)
        if gg.getResultsCount() == 1 then
            local HHH = {}
            HHH[1] = rem[1].address
            file:write('//RVA: 0x'..batHex(HHH[1]-un)..' ')
            file:write('   VA: 0x'..batHex(HHH[1]-un)..' ')
            file:write("\n")
            file:write('float  remove sound() { }') 
       file:write("\n\n")
       gg.clearResults()
       end
       
       
gg.clearResults()
gg.setRanges(gg.REGION_CODE_APP)
gg.searchNumber("1.40129846e-45;0;1.40129846e-45;-3.1514847e24;0.14177720249;0;-1048576D;997:1233", gg.TYPE_FLOAT)
gg.refineNumber("0.14177720249", gg.TYPE_FLOAT)
     speee= gg.getResults(1)
        if gg.getResultsCount() == 1 then
            local III = {}
            III[1] = speee[1].address
            file:write('//RVA: 0x'..batHex(III[1]-un)..' ')
            file:write('   VA: 0x'..batHex(III[1]-un)..' ')
            file:write("\n")
            file:write('float  setSpeed () { }') -- 
       file:write("\n\n")
       gg.clearResults()
       end
       
SymInfoChooser = {}
	for _=1, #Elf.Sym do SymInfoChooser[#SymInfoChooser + 1] = "["..tostring(_).."]: "..Elf.Sym[_].name end
		SymInfoValue = {}
 for _=2, #Elf.Sym do
    local offset = Elf.Sym[_].st_value
    if offset ~= 0 then
        local RVA = offset 
        offset = string.gsub(string.format("%08X", offset), "00", "0x") 
        RVA = string.gsub(string.format("%08X", RVA), "00", "0x") 
        file:write(sf("// RVA: %s\tVA: %s\nvoid %s(JNIEnv *env, jobject instance, jobject event) { }\n\n", RVA, offset, Elf.Sym[_].name))
    end
end

file:close()

gg.alert("saved in: " .. outputFile)
