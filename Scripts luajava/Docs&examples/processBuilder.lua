
import "android.ext.*"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "java.io.*"
import "java.security.*"
import "java.util.zip.CRC32"
import "java.math.BigInteger"

local Class = luajava.bindClass
local new = luajava.new
local astable = luajava.astable
local methods = luajava.methods

local ProcessBuilder = Class("java.lang.ProcessBuilder")
local File = Class("java.io.File")
local ProcessBuilderRedirect = Class("java.lang.ProcessBuilder$Redirect")

local pb1 = new(ProcessBuilder, "ls", "/sdcard")
local processo1 = pb1:start()
print("Processo 1 criado:", processo1:toString())
--processo1:waitFor() --loop infinite

local pb3 = new(ProcessBuilder, "echo", "Hello InheritIO")
pb3:inheritIO()
local processo3 = pb3:start()
processo3:waitFor()

local errorFile = new(File, "/sdcard/error_log.txt")
local pb4 = new(ProcessBuilder, "ls", "/diretorio_inexistente")
pb4:redirectError(errorFile)
local processo4 = pb4:start()
processo4:waitFor()
print("Erro redirecionado para arquivo")

local outputFile = new(File, "/sdcard/output_log.txt")
local pb5 = new(ProcessBuilder, "ls", "/sdcard")
pb5:redirectOutput(outputFile)
local processo5 = pb5:start()
processo5:waitFor()
print("Output redirecionado para arquivo")

local pb6 = new(ProcessBuilder, "cat")
pb6:redirectInput(inputFile)
local processo6 = pb6:start()
--processo6:waitFor()

local currentErrorRedirect = pb4:redirectError()
print("Redirect de erro atual:", currentErrorRedirect:toString())

local currentInputRedirect = pb6:redirectInput()
print("Redirect de input atual:", currentInputRedirect:toString())

local currentOutputRedirect = pb5:redirectOutput()
print("Redirect de output atual:", currentOutputRedirect:toString())

print("\n4. STREAM DE ERROS:")

local isErrorStreamRedirected = pb4:redirectErrorStream()
--print("Error stream redirecionado?", isErrorStreamRedirected)

local pb7 = new(ProcessBuilder, "ls", "/sdcard", "/sdcard/Telegram")
pb7:redirectErrorStream(true) -- 
local processo7 = pb7:start()

local inputStream = processo7:getInputStream()
local reader = new(Class("java.io.BufferedReader"), new(Class("java.io.InputStreamReader"), inputStream))
local line = reader:readLine()
while line do
  --  print("Output/Erro combinado:", line)
    line = reader:readLine()
end
reader:close()
processo7:waitFor()

print("Exemplo 1 - Logging completo:")
local logDir = new(File, "/sdcard/logs")
logDir:mkdirs()

local stdoutLog = new(File, logDir, "stdout.log")
local stderrLog = new(File, logDir, "stderr.log")

local pbLog = new(ProcessBuilder, "ls", "-la", "/sdcard")
pbLog:redirectOutput(stdoutLog)
pbLog:redirectError(stderrLog)
local processLog = pbLog:start()
processLog:waitFor()
print("Logs salvos em /sdcard/logs/")

print("\n10. LIMPEZA:")

local filesToClean = {
    "/sdcard/error_log.txt",
    "/sdcard/output_log.txt", 
    "/sdcard/input.txt",
    "/sdcard/temp_input.txt",
    "/sdcard/command_error.log",
    "/sdcard/complete_stdout.log",
    "/sdcard/complete_stderr.log"
}

for _, filePath in ipairs(filesToClean) do
    local file = new(File, filePath)
    if file:exists() then
        file:delete()
        print("Limpo: " .. filePath)
    end
end

if logDir:exists() then
    local logFiles = logDir:listFiles()
    for _, logFile in ipairs(luajava.astable(logFiles)) do
      --  logFile:delete()
    end
  --  logDir:delete()
    print("Diretório de logs limpo")
end

local pb6 = new(ProcessBuilder, "cat")
pb6:redirectInput(inputFile)
local process6 = pb6:start()

local isAlive = process6:isAlive()
print("Process is alive:", isAlive)

process6:destroy() 
process6:destroyForcibly() 

local pb = new(ProcessBuilder, "grep", "search_term")
pb:redirectInput(ProcessBuilderRedirect.PIPE)
pb:redirectOutput(ProcessBuilderRedirect.PIPE)
local process = pb:start()

function monitorProcess(process)
    local monitorThread = thread(function()
        while process:isAlive() do
            print("Process still running...")
            Thread.sleep(1000)
        end
        print("Process finished")
    end)
    return monitorThread
end

local monitor = monitorProcess(process6)
