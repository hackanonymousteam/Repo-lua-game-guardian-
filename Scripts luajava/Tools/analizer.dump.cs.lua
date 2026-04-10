g = {}
g.last = "/sdcard/"
g.info = nil
g.config = gg.EXT_CACHE_DIR .. "/" .. gg.getFile():match("[^/]+$") .. "cfg"
g.data = loadfile(g.config)
if g.data ~= nil then
g.info = g.data()
g.data = nil
end
if g.info == nil then
g.info = { g.last, g.last:gsub("/[^/]+$", "") }
end

g.classes = {}
g.methods = {}
g.currentClass = nil
g.returnTypes = {} 

function parseDumpCS(content)
g.classes = {}
g.methods = {}
g.returnTypes = {}
local lines = {}
for line in content:gmatch("[^\r\n]+") do
table.insert(lines, line)
end

local i = 1
while i <= #lines do
local line = lines[i]
local classPatterns = {
"public%s+class%s+([%w_]+)",
"public%s+static%s+class%s+([%w_]+)",
"private%s+class%s+([%w_]+)",
"private%s+static%s+class%s+([%w_]+)",
--"internal%s+class%s+([%w_]+)",
"protected%s+class%s+([%w_]+)",
"class%s+([%w_]+)" 
}

local className = nil
for _, pattern in ipairs(classPatterns) do
className = line:match(pattern)
if className then
local namespace = nil
if i > 1 then
local prevLine = lines[i-1]
namespace = prevLine:match("Namespace:%s*(.+)")
if not namespace then
namespace = prevLine:match("namespace%s+([%w_%.]+)")
end
end

local classInfo = {
name = className,
namespace = namespace,
line = i,
fullName = namespace and (namespace .. "." .. className) or className,
methods = {}
}

table.insert(g.classes, classInfo)
g.methods[classInfo.fullName] = {}
g.currentClass = classInfo.fullName
break
end
end

if g.currentClass then
local fullLine = lines[i]

if fullLine:find("RVA:") or fullLine:find("%( %)") or fullLine:find("%(.-%)") then
local methodName = fullLine:match("([%w_]+)%s*%(")
if not methodName then
methodName = fullLine:match("%.([%w_]+)%s*%(") 
end

if methodName then
local returnType = "unknown"
local returnTypeMatch = fullLine:match("^%s*([%w_<>%[%],%s]+)%s+[%w_%.]+%s*%(")
if returnTypeMatch then
returnType = returnTypeMatch:gsub("%s+", "")
if returnType ~= "unknown" and returnType ~= "" then
local found = false
for _, rt in ipairs(g.returnTypes) do
if rt == returnType then
found = true
break
end
end
if not found then
table.insert(g.returnTypes, returnType)
end
end
end

local params = fullLine:match("%((.-)%)")
if params then
params = params:gsub("%s+", " ")
end

local va = fullLine:match("VA:%s*(0x[%w]+)")
if not va then
va = fullLine:match("0x[%w]+")
end

if not va and i > 1 then
local prevLine = lines[i-1]
va = prevLine:match("VA:%s*(0x[%w]+)")
end

if not va and i < #lines then
local nextLine = lines[i+1]
va = nextLine:match("VA:%s*(0x[%w]+)")
end

local methodInfo = {
name = methodName,
returnType = returnType,
parameters = params or "",
va = va,
line = i,
fullSignature = returnType .. " " .. methodName .. "(" .. (params or "") .. ")"
}

table.insert(g.methods[g.currentClass], methodInfo)
end
end
if fullLine:match("^%}") then
g.currentClass = nil
end
end
i = i + 1
end
table.sort(g.returnTypes)

function groupMethodsByReturnType(methods)
local grouped = {}
for _, method in ipairs(methods) do
local rt = method.returnType
if not grouped[rt] then
grouped[rt] = {}
end
table.insert(grouped[rt], method)
end
return grouped
end

function filterMethodsByReturnType(methods, returnType)
local filtered = {}
for _, method in ipairs(methods) do
if method.returnType == returnType then
table.insert(filtered, method)
end
end
return filtered
end

function getSetMethods(classMethods)
local setMethods = {}
for _, method in ipairs(classMethods) do
if method.name:lower():match("^set_") then
table.insert(setMethods, method)
end
end
return setMethods
end

function getGetMethods(classMethods)
local getMethods = {}
for _, method in ipairs(classMethods) do
if method.name:lower():match("^get_") then
table.insert(getMethods, method)
end
end
return getMethods
end

function searchClassesByKeyword(keyword)
if not keyword or #keyword == 0 then
return g.classes, g.classNames
end

keyword = keyword:lower()
local filteredClasses = {}
local filteredNames = {}

for i, classInfo in ipairs(g.classes) do
local className = classInfo.name:lower()
local fullName = classInfo.fullName:lower()
local namespace = classInfo.namespace and classInfo.namespace:lower() or ""

if className:find(keyword) or fullName:find(keyword) or namespace:find(keyword) then
table.insert(filteredClasses, classInfo)
table.insert(filteredNames, classInfo.fullName)
end
end
return filteredClasses, filteredNames
end

function showClassMenu(classes)
if #classes == 0 then
gg.alert("No classes found!")
return nil
end

local items = {}
for i, classInfo in ipairs(classes) do
local methodsCount = #(g.methods[classInfo.fullName] or {})
items[i] = i .. ". " .. classInfo.fullName .. " (" .. methodsCount .. " methods)"
end

local choices = gg.multiChoice(items, nil, "Select classes to analyze (" .. #classes .. " found)")
if not choices then return nil end

local result = {}
for index, selected in pairs(choices) do
if selected then
table.insert(result, classes[index])
end
end
return result
end

function showReturnTypeMenu(methods)
local grouped = groupMethodsByReturnType(methods)
local returnTypes = {}
for rt, _ in pairs(grouped) do
table.insert(returnTypes, rt)
end
table.sort(returnTypes)

local items = {"All types"}
for _, rt in ipairs(returnTypes) do
table.insert(items, rt .. " (" .. #grouped[rt] .. " methods)")
end

local choice = gg.choice(items, nil, "Select return type:")
if not choice then return nil end

if choice == 1 then
return "all", methods
else
local selectedType = returnTypes[choice - 1]
return selectedType, grouped[selectedType]
end
end

function showMethodOptions(classMethods, className)
if #classMethods == 0 then
gg.alert("No methods found for class: " .. className)
return nil
end

local grouped = groupMethodsByReturnType(classMethods)
local returnTypesCount = 0
for _ in pairs(grouped) do
returnTypesCount = returnTypesCount + 1
end

local methodOptions = {
"View all methods (" .. #classMethods .. ")",
"Group by return type (" .. returnTypesCount .. " types)",
"View set_ methods only",
"View get_ methods only",
"Search methods by name"
}

local methodChoice = gg.choice(methodOptions, nil, "Class: " .. className)
if not methodChoice then return nil end
local methodsToShow = {}
if methodChoice == 1 then
methodsToShow = classMethods

elseif methodChoice == 2 then
local selectedType, typedMethods = showReturnTypeMenu(classMethods)
if selectedType then
if selectedType == "all" then
methodsToShow = classMethods
else
methodsToShow = typedMethods
end
end

elseif methodChoice == 3 then
methodsToShow = getSetMethods(classMethods)

elseif methodChoice == 4 then
methodsToShow = getGetMethods(classMethods)

elseif methodChoice == 5 then
local searchTerm = gg.prompt({"Enter method name to search:"}, {""}, {"text"})
if searchTerm and searchTerm[1] and #searchTerm[1] > 0 then
local term = searchTerm[1]:lower()
for _, method in ipairs(classMethods) do
if method.name:lower():find(term) then
table.insert(methodsToShow, method)
end
end
end
end

if #methodsToShow == 0 then
gg.alert("No methods found with this filter!")
return nil
end
return methodsToShow
end

function showMethodsMenu(methods, className)
if not methods or #methods == 0 then
gg.alert("No methods found with this filter!")
return nil
end

local items = {}
for i, method in ipairs(methods) do
local vaInfo = method.va and " [VA: " .. method.va .. "]" or " [VA: Not found]"
table.insert(items, i .. ". " .. method.name .. " (" .. method.returnType .. ")" .. vaInfo)
end

local choices = gg.multiChoice(items, nil, "Select methods to view details (" .. #methods .. " methods):")
if not choices then return nil end

local selectedMethods = {}
for i, selected in ipairs(choices) do
if selected then
table.insert(selectedMethods, methods[i])
end
end

return selectedMethods
end

function showMethodOffsets(methods)
if #methods == 0 then return end
local result = "METHOD OFFSETS:\n\n"
for i, method in ipairs(methods) do
result = result .. string.format("[%d] %s\n", i, method.fullSignature)
if method.va then
result = result .. "    VA: " .. method.va .. "\n\n"
else
result = result .. "    VA: Not found\n\n"
end
end

gg.alert(result)
end

g.info = gg.prompt({
'Select dump.cs file:',
'Destination folder:'
}, g.info, {
'file',
'path'
})

if not g.info then return end

gg.saveVariable(g.info, g.config)
g.last = g.info[1]

if not g.last:lower():match("%.cs$") then
gg.alert("Please select a .cs file!")
return
end

local file = io.open(g.last, "r")
if not file then
gg.alert("Error opening file!")
return
end

local DATA = file:read("*a")
file:close()

parseDumpCS(DATA)

gg.alert(string.format("Analysis complete!\nClasses found: %d\nReturn types found: %d\nCheck console for details", #g.classes, #g.returnTypes))

while true do
local mainOptions = {
"Search classes by keyword",
"Exit"
}

local mainChoice = gg.choice(mainOptions, nil, "Dump.cs Analyzer - " .. #g.classes .. " classes, " .. #g.returnTypes .. " return types")
if not mainChoice then break end
local currentClasses = g.classes
if mainChoice == 1 then
local searchInput = gg.prompt({"Enter keyword to search in class names:"}, {""}, {"text"})
if not searchInput then break end
local keyword = searchInput[1]
currentClasses, _ = searchClassesByKeyword(keyword)

if #currentClasses == 0 then
gg.alert("No classes found containing: " .. keyword)
else
gg.alert(string.format("Found %d classes containing '%s'", #currentClasses, keyword))
end

if mainChoice == 1  then
local selectedClasses = showClassMenu(currentClasses)
if selectedClasses and #selectedClasses > 0 then
for _, classInfo in ipairs(selectedClasses) do
local classMethods = g.methods[classInfo.fullName] or {}
if #classMethods > 0 then
local methodsToShow = showMethodOptions(classMethods, classInfo.name)
if methodsToShow and #methodsToShow > 0 then
local selectedMethods = showMethodsMenu(methodsToShow, classInfo.name)
if selectedMethods and #selectedMethods > 0 then
showMethodOffsets(selectedMethods)
end
end
else
gg.alert("No methods found for class: " .. classInfo.name)
end
end
end end
end end
