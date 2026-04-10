gg.setVisible(false)

local lexer = {}

local function array_to_set(t)
    local s = {}
    for i = 1, #t do
        s[t[i]] = true
    end
    return s
end


local sbyte = string.byte
local ssub = string.sub
local schar = string.char
local sreverse = string.reverse
local tconcat = table.concat
local mfloor = math.floor

local BYTE_0, BYTE_9 = sbyte("0"), sbyte("9")
local BYTE_a, BYTE_z = sbyte("a"), sbyte("z")
local BYTE_A, BYTE_Z = sbyte("A"), sbyte("Z")
local BYTE_DOT = sbyte(".")
local BYTE_QUOTE = sbyte("'")
local BYTE_DQUOTE = sbyte('"')
local BYTE_DASH = sbyte("-")
local BYTE_SPACE = sbyte(" ")
local BYTE_LF = sbyte("\n")
local BYTE_CR = sbyte("\r")


local keywords = array_to_set({
"and","break","do","else","elseif","end","false","for","function",
"goto","if","in","local","nil","not","or","repeat","return","then",
"true","until","while"
})


local function is_alpha(b)
    return (b>=BYTE_a and b<=BYTE_z)
        or (b>=BYTE_A and b<=BYTE_Z)
        or b==sbyte("_")
end

local function is_digit(b)
    return b>=BYTE_0 and b<=BYTE_9
end

local function is_space(b)
    return b==BYTE_SPACE or b==BYTE_LF or b==BYTE_CR or b==sbyte("\t")
end


function lexer.new_state(src)
    return {
        src = src,
        offset = 1,
        line = 1,
        line_offset = 1
    }
end

local function next_byte(state)
    state.offset = state.offset + 1
    return sbyte(state.src, state.offset)
end

local function skip_space(state)
    local b = sbyte(state.src, state.offset)
    while b and is_space(b) do
        if b==BYTE_LF then
            state.line = state.line + 1
            state.line_offset = state.offset + 1
        end
        state.offset = state.offset + 1
        b = sbyte(state.src, state.offset)
    end
    return b
end


local function lex_number(state)
    local start = state.offset
    local b = sbyte(state.src, state.offset)

    while b and (is_digit(b) or b==BYTE_DOT) do
        state.offset = state.offset + 1
        b = sbyte(state.src, state.offset)
    end

    return "number", ssub(state.src,start,state.offset-1)
end

local function lex_ident(state)
    local start = state.offset
    local b = sbyte(state.src, state.offset)

    while b and (is_alpha(b) or is_digit(b)) do
        state.offset = state.offset + 1
        b = sbyte(state.src, state.offset)
    end

    local word = ssub(state.src,start,state.offset-1)

    if keywords[word] then
        return word
    end

    return "name", word
end

local function lex_string(state, quote)
    state.offset = state.offset + 1
    local start = state.offset
    local b = sbyte(state.src, state.offset)

    while b and b~=quote do
        if b==BYTE_LF then
            return nil,"unfinished string"
        end
        state.offset = state.offset + 1
        b = sbyte(state.src, state.offset)
    end

    if not b then
        return nil,"unfinished string"
    end

    local value = ssub(state.src,start,state.offset-1)
    state.offset = state.offset + 1
    return "string", value
end

local function lex_comment(state)
    state.offset = state.offset + 2
    local start = state.offset
    local b = sbyte(state.src, state.offset)

    while b and b~=BYTE_LF do
        state.offset = state.offset + 1
        b = sbyte(state.src, state.offset)
    end

    return "comment", ssub(state.src,start,state.offset-1)
end


function lexer.next_token(state)

    local b = skip_space(state)

    if not b then
        return "eof", nil, state.line, state.offset - state.line_offset + 1
    end

    local token_line = state.line
    local token_column = state.offset - state.line_offset + 1

   
    if is_digit(b) then
        local tk, val = lex_number(state)
        return tk, val, token_line, token_column
    end

  
    if is_alpha(b) then
        local tk, val = lex_ident(state)
        return tk, val, token_line, token_column
    end

   
    if b==BYTE_QUOTE or b==BYTE_DQUOTE then
        local tk, val = lex_string(state,b)
        return tk, val, token_line, token_column
    end

  
    if b==BYTE_DASH and sbyte(state.src,state.offset+1)==BYTE_DASH then
        local tk, val = lex_comment(state)
        return tk, val, token_line, token_column
    end

   
    state.offset = state.offset + 1
    return schar(b), nil, token_line, token_column
end

local input = gg.prompt({"Enter Lua code:"},{""})
if not input then os.exit() end

local state = lexer.new_state(input[1])

local output = {}

while true do
    local token,value,line,col = lexer.next_token(state)
    table.insert(output,"["..line..":"..col.."] "..tostring(token).." "..tostring(value or ""))
    if token=="eof" then break end
end

gg.alert(table.concat(output,"\n"))