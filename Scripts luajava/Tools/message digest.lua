

if luajava == nil then gg.alert(' unavaliable please use gameguardian mod (suport luajava)') else end


import "android.ext.*"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "java.security.*"
import "java.nio.ByteBuffer"
import "java.lang.*"

local Class = luajava.bindClass
local new = luajava.new
local astable = luajava.astable
local methods = luajava.methods

local MessageDigest = Class("java.security.MessageDigest")

print("1. getInstance(String):")
local md5 = MessageDigest.getInstance("MD5")
local sha1 = MessageDigest.getInstance("SHA-1")
local sha256 = MessageDigest.getInstance("SHA-256")
print("   MD5 create:", md5:toString())
print("   SHA-1 create:", sha1:toString())
print("   SHA-256 create:", sha256:toString())
print()

print("2. getAlgorithm():")
print("   MD5 algorithm:", md5:getAlgorithm())
print("   SHA-1 algorithm:", sha1:getAlgorithm())
print("   SHA-256 algorithm:", sha256:getAlgorithm())
print()

print("3. getDigestLength():")
print("   MD5 digest length:", md5:getDigestLength())
print("   SHA-1 digest length:", sha1:getDigestLength())
print("   SHA-256 digest length:", sha256:getDigestLength())
print()

print("4. getProvider():")
local provider = md5:getProvider()
print("   Provider:", provider:getName())
print("   Version:", provider:getVersion())
print("   Info:", provider:getInfo())
print()

print("9. digest():")
local hashMd5 = md5:digest()
local hashSha1 = sha1:digest()
local hashSha256 = sha256:digest()
print("   MD5 hash size:", #hashMd5 .. " bytes")
print("   SHA-1 hash size:", #hashSha1 .. " bytes")
print("   SHA-256 hash size:", #hashSha256 .. " bytes")
print()

print("   Hash1 == Hash2?", MessageDigest.isEqual(hash1, hash2))
print("   Hash1 == Hash3?", MessageDigest.isEqual(hash1, hash3))
print("   Null hash == Null hash?", MessageDigest.isEqual(nil, nil))
print()

print("15. toString():")
print("   MD5 string:", md5:toString())
print("   SHA-1 string:", sha1:toString())
print()

print("16. hashCode():")
print("   MD5 hashCode:", md5:hashCode())
print("   SHA-1 hashCode:", sha1:hashCode())
print()