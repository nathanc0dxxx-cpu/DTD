_G.dot = {}
dot.elements = {}
dot.path = os.getenv("PREFIX")
if dot.path == nil then
    local s = os.execute("cd /usr")
    if s == 0 then dot.path = "/usr/bin/"
    else dot.path = "./"
    end
else
    dot.path = dot.path.."/bin/"
end
dot.path = dot.path .. "dotapp/"
local path = dot.path
os.execute("mkdir "..dot.path:sub(1, #dot.path - 1).." >/dev/null 2>&1")

dot.components = {}
function dot.loadelements()
    local d = io.popen("ls -p "..path)
    if d then
        local dd = d:read("*a")
        d:close()
        for v in dd:gmatch("%S+") do
            if not v:match("/$") then
                table.insert(dot.elements, v)
            end
        end
    end
end
function dot.getexecutables(pt)
    local p = io.popen("ls -p "..pt)
    local tab = {}
    if p then
        local c = p:read("*a")
        p:close()
        for v in c:gmatch("%S+") do
            if not v:match("/$") then
                table.insert(tab, v)
            end
        end
    end
    return tab
end

function dot.getkey()
    local inp = io.read(1)
    if inp == "\n" or inp == "" or inp == "\r" or inp == "\n\r" or inp == "\r\n" then
        inp = "enter"
    elseif inp == "\8" or inp == "\127" or inp == "\b" then
        inp = "backspace"
    end
    return inp
end

dot.stdin = {
    input = ""
}
dot.stdout = {
    text = ""
}
dot.terminal = {
    size = {
        x = 0,
        y = 0
    }
}
function dot.err(txt)
    print("\27[44m[DOT]:\27[0m\27[91m ERROR: \27[0m"..txt)
end
function dot.notify(txt)
    print("\27[44m[DOT]:\27[0m "..txt)
end

os.execute("stty -icanon -echo -isig min 1 time 0")
io.write("\27[?25l")

dot.loadelements()
local d = io.popen("stty size")
local dd = d:read("*a") d:close()
local y,x = dd:match("(%d*) (%d*)")
dot.terminal.size.x = tonumber(x)
dot.terminal.size.y = tonumber(y)
print("\n")

while true do
    local input = dot.stdin.input
    local args = {}
    for v in input:gmatch("%S+") do
        table.insert(args, v)
    end
    if not args[1] then args[1] = " " end
    do
        local reply = ""
        for i,v in ipairs(dot.elements) do
            if v:sub(1, #args[1]) == args[1] then
                reply = v break
            end
        end local input2 = input
        if args[1] == reply then input2 = "\27[92m"..args[1].."\27[96m"..input:sub(#args[1] + 1, #input) end

        print("\27[1A\27[0J\27[96m > :\27[0m"..input2.."\27[93m<\27[90m"..reply:sub(#input + 1, #reply).."\27[0m")

    end

    local k = dot.getkey()

    if k == "enter" then
        if input == "exit" then os.execute("clear") os.execute("stty sane") io.write("\27[?25h") return end

        if input:gsub(" ","") ~= "" then
        local got = false
        local pathin = path
        if input:match("^.-/") then pathin = args[1]:match("^(.-)/.-") or "" pathin = pathin.."/" end
        local g = dot.getexecutables(pathin)
        for i,v in ipairs(g) do
            if v == args[1] then
                got = true
                local f, err = loadfile(pathin..v)
                if f then
                    local leng = #args[1]
                    local fin = input:sub(leng + 2, #input)
                    local out = f(fin)
                    if out then
                        if type(out) == "table" then
                            local result = {}
                            local function parse(tab)
                                for i,v in ipairs(tab) do
                                    if type(v) == "table" then
                                        parse(v)
                                    else
                                        table.insert(result, v)
                                    end
                                end
                            end for i,v in ipairs(result) do
                                print(tostring(v))
                            end
                        else print(tostring(out))
                        end
                    end
                else
                    dot.err(pathin..v..": "..tostring(err))
                end
                break
            end
        end
        if got == false and input == "--lua" then
            local code = ""
            print("\27[90mpress CTRL+R to run or CTRL+Q to exit.\27[0m")
            while true do
                local k = dot.getkey()
                if k == "enter" then break end
            end
            while true do
                io.write("\27[3J\27[2J\27[H\27[0m"..code.."\27[47m \27[0m")
                local sin = dot.getkey()

                if sin == "enter" then
                    code = code.."\n"
                elseif sin == "backspace" then
                    code = code:sub(1, #code - 1)
                elseif sin == "\18"then
                    break
                elseif sin == "\17" then
                    code = ""
                    break
                else
                    code = code..sin
                end
            end
            local fn,err = load(code)
            if fn then
                got = true fn(input)
            elseif not fn and err then
                dot.err("inline: "..tostring(err))
            end
        end
        if got == false then
            dot.err(pathin..": file "..args[1].." not found")
        end dot.stdin.input = ""
        end
        print()
    elseif k == "backspace" then
        dot.stdin.input = input:sub(1, #input - 1)
    else
        dot.stdin.input = input .. k
    end
end

io.write("\27[?25h")
os.execute("stty sane")