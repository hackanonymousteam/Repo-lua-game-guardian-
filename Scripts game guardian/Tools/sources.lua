
local bit32 = {}

local function checkint( name, argidx, x, level )
	local n = tonumber( x )
	if not n then
		error( string.format(
			"bad argument #%d to '%s' (number expected, got %s)",
			argidx, name, type( x )
		), level + 1 )
	end
	return math.floor( n )
end

local function checkint32( name, argidx, x, level )
	local n = tonumber( x )
	if not n then
		error( string.format(
			"bad argument #%d to '%s' (number expected, got %s)",
			argidx, name, type( x )
		), level + 1 )
	end
	return math.floor( n ) % 0x100000000
end

function bit32.bnot( x )
	x = checkint32( 'bnot', 1, x, 2 )

	-- In two's complement, -x = not(x) + 1
	-- So not(x) = -x - 1
	return ( -x - 1 ) % 0x100000000
end

local logic_and = {
	[0] = { [0] = 0, 0, 0, 0},
	[1] = { [0] = 0, 1, 0, 1},
	[2] = { [0] = 0, 0, 2, 2},
	[3] = { [0] = 0, 1, 2, 3},
}
local logic_or = {
	[0] = { [0] = 0, 1, 2, 3},
	[1] = { [0] = 1, 1, 3, 3},
	[2] = { [0] = 2, 3, 2, 3},
	[3] = { [0] = 3, 3, 3, 3},
}
local logic_xor = {
	[0] = { [0] = 0, 1, 2, 3},
	[1] = { [0] = 1, 0, 3, 2},
	[2] = { [0] = 2, 3, 0, 1},
	[3] = { [0] = 3, 2, 1, 0},
}


local function comb( name, args, nargs, s, t )
	for i = 1, nargs do
		args[i] = checkint32( name, i, args[i], 3 )
	end

	local pow = 1
	local ret = 0
	for b = 0, 31, 2 do
		local c = s
		for i = 1, nargs do
			c = t[c][args[i] % 4]
			args[i] = math.floor( args[i] / 4 )
		end
		ret = ret + c * pow
		pow = pow * 4
	end
	return ret
end

function bit32.band( ... )
	return comb( 'band', { ... }, select( '#', ... ), 3, logic_and )
end

function bit32.bor( ... )
	return comb( 'bor', { ... }, select( '#', ... ), 0, logic_or )
end

function bit32.bxor( ... )
	return comb( 'bxor', { ... }, select( '#', ... ), 0, logic_xor )
end

function bit32.btest( ... )
	return comb( 'btest', { ... }, select( '#', ... ), 3, logic_and ) ~= 0
end

function bit32.extract( n, field, width )
	n = checkint32( 'extract', 1, n, 2 )
	field = checkint( 'extract', 2, field, 2 )
	width = checkint( 'extract', 3, width or 1, 2 )
	if field < 0 then
		error( "bad argument #2 to 'extract' (field cannot be negative)", 2 )
	end
	if width <= 0 then
		error( "bad argument #3 to 'extract' (width must be positive)", 2 )
	end
	if field + width > 32 then
		error( 'trying to access non-existent bits', 2 )
	end

	return math.floor( n / 2^field ) % 2^width
end

function bit32.replace( n, v, field, width )
	n = checkint32( 'replace', 1, n, 2 )
	v = checkint32( 'replace', 2, v, 2 )
	field = checkint( 'replace', 3, field, 2 )
	width = checkint( 'replace', 4, width or 1, 2 )
	if field < 0 then
		error( "bad argument #3 to 'replace' (field cannot be negative)", 2 )
	end
	if width <= 0 then
		error( "bad argument #4 to 'replace' (width must be positive)", 2 )
	end
	if field + width > 32 then
		error( 'trying to access non-existent bits', 2 )
	end

	local f = 2^field
	local w = 2^width
	local fw = f * w
	return ( n % f ) + ( v % w ) * f + math.floor( n / fw ) * fw
end


-- For the shifting functions, anything over 32 is the same as 32
-- and limiting to 32 prevents overflow/underflow
local function checkdisp( name, x )
	x = checkint( name, 2, x, 3 )
	return math.min( math.max( -32, x ), 32 )
end

function bit32.lshift( x, disp )
	x = checkint32( 'lshift', 1, x, 2 )
	disp = checkdisp( 'lshift', disp )

	return math.floor( x * 2^disp ) % 0x100000000
end

function bit32.rshift( x, disp )
	x = checkint32( 'rshift', 1, x, 2 )
	disp = checkdisp( 'rshift', disp )

	return math.floor( x / 2^disp ) % 0x100000000
end

function bit32.arshift( x, disp )
	x = checkint32( 'arshift', 1, x, 2 )
	disp = checkdisp( 'arshift', disp )

	if disp <= 0 then
		-- Non-positive displacement == left shift
		-- (since exponent is non-negative, the multipication can never result
		-- in a fractional part)
		return ( x * 2^-disp ) % 0x100000000
	elseif x < 0x80000000 then
		-- High bit is 0 == right shift
		-- (since exponent is positive, the division will never increase x)
		return math.floor( x / 2^disp )
	elseif disp > 31 then
		-- Shifting off all bits
		return 0xffffffff
	else
		-- 0x100000000 - 2 ^ ( 32 - disp ) creates a number with the high disp
		-- bits set. So shift right then add that number.
		return math.floor( x / 2^disp ) + ( 0x100000000 - 2 ^ ( 32 - disp ) )
	end
end

-- For the rotation functions, disp works mod 32.
-- Note that lrotate( x, disp ) == rrotate( x, -disp ).
function bit32.lrotate( x, disp )
	x = checkint32( 'lrotate', 1, x, 2 )
	disp = checkint( 'lrotate', 2, disp, 2 ) % 32

	local x = x * 2^disp
	return ( x % 0x100000000 ) + math.floor( x / 0x100000000 )
end

function bit32.rrotate( x, disp )
	x = checkint32( 'rrotate', 1, x, 2 )
	disp = -checkint( 'rrotate', 2, disp, 2 ) % 32

	local x = x * 2^disp
	return ( x % 0x100000000 ) + math.floor( x / 0x100000000 )
end

local SHIFT = 8

local function caesar_encode(s)
    local t = {}
    for i = 1, #s do
        t[i] = string.char((string.byte(s, i) + SHIFT) % 256)
    end
    return table.concat(t)
end

local function caesar_decode(s)
    local t = {}
    for i = 1, #s do
        t[i] = string.char((string.byte(s, i) - SHIFT) % 256)
    end
    return table.concat(t)
end

local function hex_encode(str)
    return (str:gsub(".", function(c)
        return string.format("%02X", string.byte(c))
    end))
end

local function hex_decode(hex)
    return (hex:gsub("(%x%x)", function(cc)
        return string.char(tonumber(cc, 16))
    end))
end

function ascii_encode(str)
    local result = {}
    for i = 1, #str do
        result[#result + 1] = string.byte(str, i)
    end
    return table.concat(result, '\\')
end

local function ascii_decode(s)
    local t = {}
    for n in s:gmatch("%d+") do
        t[#t+1] = string.char(tonumber(n))
    end
    return table.concat(t)
end

local shift = 7

function caesar_encode(str, shift)
    shift = shift or 8  -- default shift if nil
    local result = {}
    for i = 1, #str do
        local byte = string.byte(str, i)
        local new_byte = (byte + shift) % 256
        table.insert(result, string.char(new_byte))
    end
    return table.concat(result)
end

function caesar_decode(str, shift)
    shift = shift or 8
    local ceil = nil
    local result = {}
    for i = 1, #str do
        local byte = string.byte(str, i)
        local new_byte = (byte - shift) % 256
        table.insert(result, string.char(new_byte))
    end
    return table.concat(result)
end
--math.randomseed(os.time())

local bytecode = "gg.alert('7')"
local asciibyte = ascii_encode(bytecode)
local hexascii = hex_encode(asciibyte)
local caesarhex = caesar_encode(hexascii, 3)



local e = [[
function a(str)
    local result = ""
    for i = 1, #str do
        local obscured_byte = str:byte(i)
        local original_byte = (obscured_byte + 10) / 2
        result = result .. string.char(original_byte)
    end
    return result
end 
function b(str)
    local decoded_data = ""
    for i = 1, #str, 2 do
        local byte = tonumber(str:sub(i, i + 1), 16)
        decoded_data = decoded_data .. string.char(byte)
    end
    return decoded_data
end
]]

local d = hex_encode(e)

print(d)
--hex_decode

--print(hex_encode(ascii_encode(hex_encode(caesar_encode((bytecode))))))

--print(hex_decode(ascii_decode(hex_decode(caesar_decode(("35345C37305C35345C37305C35315C35345C35345C35375C35355C35325C35345C36385C35355C36355C35355C36375C35315C34385C35305C37305C35315C37305C35305C37305C35315C3439"))))))

--[[
local p = caesarhex

-- decode steps (reverse order!)
local hexascii = caesar_decode(p, 3)
local asciibyte = hex_decode(hexascii)
local bytecode = ascii_decode(asciibyte)

--local f, err = load(bytecode)
--assert(f, err)
--f()

print(asciibyte)
print("\n\n")
print(hexascii)
print("\n\n")
print(caesarhex)
print("\n\n")







]]



