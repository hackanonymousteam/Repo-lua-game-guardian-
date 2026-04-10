function exit()
  print("Script ended")
  os.exit()
end

function init()
  DWORD = gg.TYPE_DWORD
  DOUBLE = gg.TYPE_DOUBLE
  FLOAT = gg.TYPE_FLOAT
  WORD = gg.TYPE_WORD
  BYTE = gg.TYPE_BYTE
  XOR = gg.TYPE_XOR
  QWORD = gg.TYPE_QWORD

  Ca = gg.REGION_C_ALLOC
  Ch = gg.REGION_C_HEAP
  Jh = gg.REGION_JAVA_HEAP
  Cd = gg.REGION_C_DATA
  Cb = gg.REGION_C_BSS
  PS = gg.REGION_PPSSPP
  A = gg.REGION_ANONYMOUS
  J = gg.REGION_JAVA
  S = gg.REGION_STACK
  As = gg.REGION_ASHMEM
  O = gg.REGION_OTHER
  B = gg.REGION_BAD
  Xa = gg.REGION_CODE_APP
  Xs = gg.REGION_CODE_SYS

  maxCount = 9999999
end

function main()
  gg.showUiButton()
  while true do
    if gg.isClickedUiButton() then
      local idx = gg.choice({
        'Fast find unique address (binary search)'
      })
      if idx ~= nil then
        runItemOne(idx)
      end
    end
    gg.sleep(200)
  end
end

function item01()
  local idx = gg.choice({
    'Automatic version'
  })
  if idx ~= nil then
    runItemTwo(idx,"01")
  end
end

function item0101()
  if gg.getResultsCount() == 0 then
    gg.alert("Please search for all possible results first!")
    return
  end

  local rTable = gg.prompt(
    {'Change value',"Restore value","Test duration (seconds)"},
    {},
    {[1]='number',[2]='number',[3]='number'}
  )

  if rTable == nil or rTable[1] == nil or rTable[2] == nil or rTable[3] == nil then
    gg.alert("Change value, restore value or test duration cannot be empty!")
    return
  end

  if tonumber(rTable[3]) < 5 then
    gg.alert("Test duration must be greater than 5 seconds!")
    return
  end

  local editValue = rTable[1]
  local discoverValue = rTable[2]
  local sleepTime = rTable[3] * 1000

  local saveResults = {}
  local editHalfTable
  while (getResults(saveResults) > 1) do
    editHalfTable = changeHalf(saveResults,editValue)
    gg.toast("Start testing!")
    gg.sleep(sleepTime - 3000)
    gg.toast("Prompt will appear in 3 seconds, finish testing!")
    gg.sleep(3000)
    local tResult = gg.alert("Did the current change have effect?","No","Yes")
    if tResult == 1 then
      saveResults = afterNoChangeResults(#editHalfTable)
    else
      saveResults = afterChangeResults(saveResults,#editHalfTable,discoverValue)
    end
  end
end

function afterChangeResults(searchResults,editCount,discoverValue)
  local deleteResults = gg.getResults(#searchResults,editCount)
  gg.removeResults(deleteResults)
  gg.toast("Removed useless results, count:"..#deleteResults)
  local editResults = gg.getResults(maxCount)
  for i = 1,#editResults do
    editResults[i]["value"] = discoverValue
  end
  gg.setValues(editResults)
  gg.toast("Restored remaining results, count:"..#editResults)
  return gg.getResults(maxCount)
end

function afterNoChangeResults(editCount)
  local deleteResults = gg.getResults(editCount)
  gg.removeResults(deleteResults)
  gg.toast("Removed useless results, count:"..#deleteResults)
  return gg.getResults(maxCount)
end

function changeHalf(searchResults,editValue)
  searchResults = gg.getResults(maxCount)
  gg.toast("Result count:"..#searchResults..",\r\nChange value:"..editValue)
  gg.sleep(1000)
  local changeTable = {}
  local count = #searchResults
  local m = count % 2
  local halfCount = 0
  if m ~= 0 then
    halfCount = count / 2 + 1
  else
    halfCount = count / 2
  end
  changeTable = gg.getResults(halfCount)
  for i = 1,halfCount do
    changeTable[i]["value"] = editValue
  end
  gg.setValues(changeTable)
  gg.toast("Changed "..halfCount.." values to:"..editValue)
  return changeTable
end

function getResults(results)
  results = gg.getResults(maxCount)
  local count = #results
  gg.toast("Remaining results:"..count)
  return count
end

function runItemOne(index)
  local iStr = index < 10 and "0" .. index or tostring(index)
  local str = "item" .. iStr .. "()" 
  load(str)()
end

function runItemTwo(index,firstNum)
  local iStr = index < 10 and "0" .. index or tostring(index)
  local str = "item" .. firstNum .. iStr .. "()" 
  load(str)()
end

init()
main()