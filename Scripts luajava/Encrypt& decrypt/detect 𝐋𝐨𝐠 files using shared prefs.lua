local t_dir = gg.FILES_DIR
local original_path = t_dir:gsub("files", "shared_prefs/" .. gg.PACKAGE .. "_preferences.xml")

local t = {
    "loadfile", "Loadfile", "LOADFILE", "load", "log", "LOAD", "Log", "decompile", 
    "Decompile", "Hook", "HOOK", "Decode", "DECODE", "decrypt", "Decrypt", 
    "DECRYPT", "decompiler", "DECOMPILER", "Decompiler", "Decryptor", 
    "DECRYPTOR", "Decoding", "DECODING", "decoding", "Hooker", "HOOKER", 
    "loader", "LOADER", "Loader", "Lasm", "LASM", "lasm"
}

local function verify(content, ws)
    for _, w in ipairs(ws) do
        if content:find(w) then
            gg.alert("Bro, no executing files for decrypting my script")
            print("No use of these resources:", w)
            os.exit()
        end
    end
end

local content = file.read(original_path)
verify(content or "", t)

local folders = {}

for name, path in string.gmatch(content or "", '<string name="(history%-%d+)">(.-)</string>') do
    local folder = path
    if folder:match("%.lua$") or folder:match("%..+[^/]*$") then
        folder = folder:match("(.*/)")
        if folder then
            folder = folder:gsub("/$", "")
        end
    end
    if folder and #folder > 25 and not folders[folder] then
        table.insert(folders, folder)
        folders[folder] = true
    end
end

local function checkSuspiciousFiles(folder)
    local extensions = {".tar", ".lasm", ".tail", "log.txt"}
    local files = file.list(folder)
    if files and type(files) == "table" then
        for _, filename in ipairs(files) do
            local lower = filename:lower()
            for _, ext in ipairs(extensions) do
                if lower:sub(-#ext) == ext then
                    return true, ext, filename
                end
            end
        end
    end
    return false
end

for _, folder in ipairs(folders) do
    local found, ext, file = checkSuspiciousFiles(folder)
    if found then
        gg.alert("Detected suspicious file '" .. file .. "' (ends with '" .. ext .. "') in folder:\n" .. folder)
        os.exit()
    end
end