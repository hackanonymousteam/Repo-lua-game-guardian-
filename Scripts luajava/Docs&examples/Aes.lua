import "android.ext.*"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "javax.crypto.*"
import "java.security.*"
import "java.nio.ByteBuffer"
import "java.lang.*"

local Class = luajava.bindClass
local methods = luajava.methods

local Cipher = Class("javax.crypto.Cipher")
local KeyGenerator = Class("javax.crypto.KeyGenerator")
local SecretKey = Class("javax.crypto.SecretKey")


local aesCipher = Cipher.getInstance("AES")
local desCipher = Cipher.getInstance("DES")

--  hashCode()
print("hashCode():")
print("   Hash code AES:", aesCipher:hashCode())
print("   Hash code DES:", desCipher:hashCode())
print()

