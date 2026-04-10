import "java.lang.Runtime"

local Runtime = luajava.bindClass("java.lang.Runtime")
local runtime = Runtime.getRuntime()

print("freeMemory():")
local freeMem = runtime:freeMemory()
print("Free memory:", freeMem, "bytes")
print("Free memory:", string.format("%.2f MB", freeMem / (1024 * 1024)))

print("totalMemory():")
local totalMem = runtime:totalMemory()
print("Total memory:", totalMem, "bytes")
print("Total memory:", string.format("%.2f MB", totalMem / (1024 * 1024)))

print("maxMemory():")
local maxMem = runtime:maxMemory()
print("Max memory:", maxMem, "bytes")
print("Max memory:", string.format("%.2f MB", maxMem / (1024 * 1024)))

print("gc() - Garbage Collection:")
print("Before GC - Free memory:", string.format("%.2f MB", runtime:freeMemory() / (1024 * 1024)))
runtime:gc()
print("After GC - Free memory:", string.format("%.2f MB", runtime:freeMemory() / (1024 * 1024)))

print("runFinalization():")
runtime:runFinalization()
print("Finalization executed")

runtime:traceInstructions(true)
runtime:traceInstructions(false)
print("Instruction tracing: DISABLED")

print("runFinalizersOnExit(boolean):")
Runtime.runFinalizersOnExit(true)
print("Finalizers on exit: ENABLED")
Runtime.runFinalizersOnExit(false)
print("Finalizers on exit: DISABLED")

print("Inherited Object methods:")
print("hashCode():", runtime:hashCode())
print("getClass():", runtime:getClass():getName())
print("toString():", runtime:toString())

print("=== MEMORY STATUS SUMMARY ===")
local freeMemory = runtime:freeMemory()
local totalMemory = runtime:totalMemory()
local maxMemory = runtime:maxMemory()
local usedMemory = totalMemory - freeMemory

print(string.format("Used memory:    %.2f MB", usedMemory / (1024 * 1024)))
print(string.format("Free memory:    %.2f MB", freeMemory / (1024 * 1024)))
print(string.format("Total memory:    %.2f MB", totalMemory / (1024 * 1024)))
print(string.format("Max memory:   %.2f MB", maxMemory / (1024 * 1024)))
print(string.format("Memory usage:   %.1f%%", (usedMemory / totalMemory) * 100))

print("=== PERFORMING FINAL CLEANUP ===")
print("Free memory before GC:", string.format("%.2f MB", runtime:freeMemory() / (1024 * 1024)))
runtime:gc()
runtime:runFinalization()
print("Free memory after GC:", string.format("%.2f MB", runtime:freeMemory() / (1024 * 1024)))


--  exit(int)
-- runtime:exit(0)  -- kill gg

-- halt(int)
-- runtime:halt(1)  --kill gg