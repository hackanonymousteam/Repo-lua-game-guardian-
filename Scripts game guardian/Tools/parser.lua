gg.setVisible(false)

local Parser = {}

local function tokenize(code)
    local tokens = {}
    local i = 1
    local len = #code

    while i <= len do
        local c = code:sub(i,i)

        if c:match("%s") then
            i = i + 1

        elseif c:match("[%a_]") then
            local start = i
            while code:sub(i,i):match("[%w_]") do
                i = i + 1
            end
            table.insert(tokens,{
                type="name",
                value=code:sub(start,i-1)
            })

        elseif c:match("%d") then
            local start = i
            while code:sub(i,i):match("[%d%.]") do
                i = i + 1
            end
            table.insert(tokens,{
                type="number",
                value=code:sub(start,i-1)
            })

        elseif c == '"' then
            local start = i
            i = i + 1
            while code:sub(i,i) ~= '"' and i <= len do
                i = i + 1
            end
            i = i + 1
            table.insert(tokens,{
                type="string",
                value=code:sub(start,i-1)
            })

        else
            table.insert(tokens,{
                type="symbol",
                value=c
            })
            i = i + 1
        end
    end

    table.insert(tokens,{type="eof",value=""})
    return tokens
end


function Parser.parse(code)

    local tokens = tokenize(code)
    local pos = 1

    local function current()
        return tokens[pos]
    end

    local function advance()
        pos = pos + 1
    end

    local function expect(val)
        if current().value ~= val then
            error("Expected '"..val.."' near '"..current().value.."'")
        end
        advance()
    end

    local function parsePrimary()
        local tok = current()

        if tok.type == "number" or tok.type == "string" then
            advance()
            return {type="literal", value=tok.value}

        elseif tok.type == "name" then
            advance()
            return {type="variable", name=tok.value}
        end

        error("Unexpected token '"..tok.value.."'")
    end

    local function parseExpression()
        local left = parsePrimary()

        while current().value == "+" or
              current().value == "-" or
              current().value == "*" or
              current().value == "/" or
              current().value == "==" do

            local op = current().value
            advance()
            local right = parsePrimary()

            left = {
                type="binary",
                operator=op,
                left=left,
                right=right
            }
        end

        return left
    end

    local function parseBlock()
        local body = {}

        while current().value ~= "end" and current().type ~= "eof" do
            table.insert(body, parseStatement())
        end

        expect("end")
        return body
    end

    function parseStatement()
        local tok = current()

        if tok.value == "if" then
            advance()
            local cond = parseExpression()
            expect("then")
            local body = parseBlock()
            return {type="if", condition=cond, body=body}

        elseif tok.value == "while" then
            advance()
            local cond = parseExpression()
            expect("do")
            local body = parseBlock()
            return {type="while", condition=cond, body=body}

        elseif tok.type == "name" and tokens[pos+1].value == "=" then
            local var = tok.value
            advance()
            expect("=")
            local expr = parseExpression()
            return {type="assign", name=var, value=expr}

        else
            return parseExpression()
        end
    end

    local ast = {}

    while current().type ~= "eof" do
        table.insert(ast, parseStatement())
    end

    return ast
end
    

    

local input = gg.prompt({"Enter Lua code to analyze:"},{""})[1]

if not input then
    os.exit()
end

local ok, result = pcall(function()
    return Parser.parse(input)
end)

if ok then
    gg.alert("Syntax OK\nAST Nodes: "..#result)
else
    gg.alert("Syntax Error:\n"..result)
end