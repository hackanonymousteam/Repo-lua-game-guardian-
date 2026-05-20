
if luajava == nil then gg.alert(' unavaliable please use gameguardian mod (suport luajava)') else end


import "android.ext.*"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "java.security.*"
import "javax.crypto.*"
import "java.lang.*"

local Class = luajava.bindClass
local new = luajava.new
local astable = luajava.astable
local methods = luajava.methods

local KeyFactory = Class("java.security.KeyFactory")
local KeyPairGenerator = Class("java.security.KeyPairGenerator")

local rsaKeyFactory = KeyFactory.getInstance("RSA")
local dsaKeyFactory = KeyFactory.getInstance("DSA")

print("   Hash code RSA:", rsaKeyFactory:hashCode())
print("   Hash code DSA:", dsaKeyFactory:hashCode())
