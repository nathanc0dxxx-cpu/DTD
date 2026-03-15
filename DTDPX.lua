if not dot then
    local path = os.getenv("PREFIX").."/bin/dotapp/"
    dot = {} dot.path = path
end

local function f(name, fn)
    local fn = string.dump(fn)
    local f = io.open(dot.path..name, "w")
    if f then
        f:write(fn)
        f:close()
        print("installed: "..name)
    else
        print("failed installing: "..name)
    end
end

print("preparing at: "..dot.path)
print("installing programs...")

f("help", function()
    local d = dot.getexecutables(dot.path)
    print("programs installed:")
    for i,v in ipairs(d) do
        print("\27[94m. "..v)
    end
    io.write("\27[0m")
end)

f("ls", function(input)
    if not input:match("^.-/") then input = dot.path .. input end
    local p = io.popen("ls -p "..string.format("%q",input))
    if not p then print("error") return end
    local c = p:read("*a")
    p:close()
    local raw = { dir = {}, file = {} }
    for v in c:gmatch("%S+") do
        if v:match("/$") then
            table.insert(raw.dir, v:gsub("/$",""))
        else
            table.insert(raw.file, v)
        end
    end
    for i,v in ipairs(raw.file) do
        print("\27[0m[P]: "..i.." "..v)
    end for i,v in ipairs(raw.dir) do
        print("\27[94m[D]: "..i.." "..v)
    end
    io.write("\27[0m")
end)

f("apps", function()
    local cursor = {
        x = 0,
        y = 0
    }
    os.execute("mkdir "..dot.path.."apps >/dev/null 2>&1")
    io.write("\27[?1000h")
    io.write("\27[?1006h")
    
    local function mouse()
        local k = io.read(1)
        if k == "\27" then
            local seq = ""
            while true do
                local g = io.read(1)
                seq = seq..g
                if g == "M" or g == "m" then
                    seq = k..seq
                    break
                end
            end
            local b,x,y = seq:match("(%d*);(%d*);(%d*)")
            bb = tonumber(b)
            xx = tonumber(x)
            yy = tonumber(y)
            if not xx then xx = 0 end
            if not yy then yy = 0 end
            cursor.x = xx
            cursor.y = yy
            local tab = {
                x = xx,
                y = yy,
                b = bb
            }
            return tab
        else
            return {
                x = 0,
                y = 0,
                b = 0
            }
        end
    end
    
    while true do
        local g = io.popen("stty size")
        local cc = g:read("*a") g:close()
        local y,x = cc:match("(%d*) (%d*)")
        x = tonumber(x)
        y = tonumber(y)
        if y < 28 then
            print("\27[3J\27[2J\27[Hplease click everywhere on the screen\nto remove the virtual keyboard")
            print(y)
            os.execute("sleep 1")
        else
            break
        end
    end
    
    local d = io.popen("stty size")
    local dd = d:read("*a") d:close()
    local y,x = dd:match("(%d*) (%d*)")
    sizex = tonumber(x)
    sizey = tonumber(y)
    local flfill = string.rep(" ",sizex)
    local filld = string.rep(flfill.."\n", sizey)
    local d = io.popen("ls -p "..dot.path.."apps")
    local dd = d:read("*a") d:close()
    local apps = {}
    for v in dd:gmatch("%S+") do
        if not v:match("/$") and v:match("%.dapp%.lua$") then
            table.insert(apps, v)
        end
    end
    local function clear()
        io.write("\27[0m\27[3J\27[2J\27[H")
        io.write(filld)
    end clear()

    dot.api = {
        sessions = {},
        obj = {},
        screen = {
            section = 1,
            size = {
                x = sizex,
                y = sizey
            },
        },
        session = {
            on = nil,
            new = function(name)
                local obj = {
                    objs = {},
                    objsevents = {}
                }
                dot.api.sessions[#dot.api.sessions + 1] = obj
                dot.api.session.get[name] = #dot.api.sessions + 1
                return obj
            end,
            get = {}
        },
    }
    dot.api.session.new("Main")
    local session = dot.api.sessions[dot.api.screen.section]
    dot.api.session.on = dot.api.sessions[dot.api.screen.section]
    
    
    
    function dot.api.obj.new(type)
        if not type then type = "text" end
        local idt = math.random(1000,9999)
        local obj = {
            pos = {
                x = 1,
                y = 1
            }, size = {
                x = 1,
                y = 1
            },
            id = idt,
            name = "Instance",
            color = 41,
            class = type,
            text = "Obj",
            textcolor = 97,
            onclick = function(self, fn)
                local init = {
                    event = fn,
                }
                table.insert(dot.api.sessions[dot.api.screen.section].objsevents, init)
            end
        }
        table.insert(dot.api.sessions[dot.api.screen.section].objs, obj)
        return obj
    end
    local subfill = string.rep(" ",dot.api.screen.size.x)
    local fill = string.rep(subfill.."\n",dot.api.screen.size.y)
    local screenlines = {}
    for v in fill:gmatch("([^\n]*)") do
        table.insert(screenlines, v)
    end
    dot.api.screen.lines = screenlines
    
    local exitbt = dot.api.obj.new("button")
    exitbt.size.x = 3
    exitbt.size.y = 3
    local main = true
    exitbt:onclick(function()
        main = false
    end)
    local aahhh = 0

    while main do
        if dot.api.screen.section ~= aahhh then
            aahhh = dot.api.screen.section
            dot.api.session.on = dot.api.sessions[dot.api.screen.section]
        end
        do
            for j = 1, #screenlines do
                screenlines[j] = string.rep(" ", dot.api.screen.size.x)
            end

            for i,v in ipairs(session.objs) do
                for j = v.pos.y, math.min(v.pos.y + v.size.y - 1, #screenlines) do
                    local line = screenlines[j]
                    if line then
                        local text = ""..v.text
                        text = text:sub(1, math.min(#text, v.size.x))
                        local pre  = line:sub(1, v.pos.x - 1)
                        local post = line:sub(v.pos.x + v.size.x)
                        
                        post = post:sub(#text + 1, #post)
                        screenlines[j] = pre .. "\27["..v.color.."m"..string.rep(" ", v.size.x).."\27[0m" .. post
                    end
                end
            end
            fill = ""
            for i,v in ipairs(screenlines) do
                fill = fill..v.."\n"
            end
            fill = fill:sub(1, #fill - 1)
            local m = mouse()
            clear()
            io.write(fill)
            io.write("\27[0m\27[1m\27["..cursor.y..";"..cursor.x.."H*.\27[0m")
        end
        for i,v in ipairs(session.objs) do
            local k = session.objsevents[i]
            if k then
                if cursor.x >= v.pos.x and cursor.x <= v.size.x + v.pos.x
                and cursor.y >= v.pos.y and cursor.y <= v.size.y + v.pos.y then
                    k.event()
                end
            end
        end
    end
    io.write("\27[?1000l")
    io.write("\27[?1006l")
end)

f("clear",function(input)
    if input == nil or input == "" then input = "all" end
    
    if input == "all" then
        io.write("\27[3J\27[2J\27[H")
    elseif input == "scroll" then
        io.write("\27[3J")
    elseif input == "screen" then
        io.write("\27[2J\27[0;0H")
    end
end)

f("join", function(input)
    if input == nil or input == "" then print("\27[91mno url provided\27[0m\nusage: -r to reload or type a host") return end
    local url = ""
    if input:match("^http.://") then
        url = input
    elseif input == "-r" then
        print("creating file...")
        local f = io.open(dot.path.."servers.txt","w")
        if not f then print("\27[91mno write permission...\27[0m") return end
        f:write("[empty]")
        f:close()
        print("fetching data...")
        os.execute("curl -fs https://api.github.com/repos/tutugrande1235-DTD/DTD-Source-Scripts/contents/Servers > "..dot.path.."servers.txt 2>&1 &")
        local n = 0
        local anim = {
            [0] = "",
            [1] = ".",
            [2] = "..",
            [3] = "..."
        }
        local nn = 0
        while true do
            nn = nn + 1
            n = n + 1
            if n > 3 then n = 0 end
            print("\27[3J\27[2J\27[H\27[0m[Loading]: \27[92m"..anim[n])
            
            os.execute("sleep 0.2")
            
            io.flush()
            local ff = io.open(dot.path.."servers.txt","r")
            if ff then
                local c = ff:read("*a")
                ff:close()
                if c ~= "[empty]" and c ~= "" then
                    io.write("\27[3J\27[2J\27[H")
                    return
                end
            end
            if nn > 25 then
                print("\27[91mtimeout.")
                return
            end
        end
    else
        print("searching for: "..input)
        local f = io.open(dot.path.."servers.txt","r")
        if f then
            local c = f:read("*a")
            f:close()
            if c == "" or c == "[empty]" then print("empty...") return end
            local s = {}
            for v,g in c:gmatch("\"name\"%s*:%s*\"(.-)@(.-)\"") do
                local obj = { name = v, owner = g }
                table.insert(s, obj)
            end
            for i,v in ipairs(s) do
                if input == v.name then
                    url = v.name.."@"..v.owner
                    url = "https://raw.githubusercontent.com/tutugrande1235-DTD/DTD-Source-Scripts/main/Servers/"..url
                    break
                end
            end
        else
            print("\27[91mno cache found...")
        end
    end
    
    if url ~= "" and url ~= nil then
        local function req(urll)
        local cont = ""
        local f = io.open("connection.txt","w")
        if f then
            f:write("[nil]")
            f:close()
        else
            print("\27[91mno write permission.")
            return
        end
        os.execute("curl -fs "..urll.." > connection.txt 2>&1 &")
        
        local n = 0
        local anim = {
            [0] = "   ",
            [1] = ".  ",
            [2] = ".. ",
            [3] = "..."
        }
        local nn = 0
        while true do
            nn = nn + 1
            n = n + 1
            if n > 3 then n = 1 end
            print("\27[3J\27[2J\27[H    \27[92m:"..anim[n]..":\27[0m")
            os.execute("sleep 0.2")
            
            io.flush()
            local ff = io.open("connection.txt","r")
            if ff then
                local c = ff:read("*a")
                ff:close()
                if c ~= "[nil]" and c ~= "" then
                    cont = c
                    os.remove("connection.txt")
                    return c
                end
            end
            
            if nn > 50 then
                print("\27[91mtimeout.")
                return nil
            end
        end
        os.remove("connection.txt")
        return cont
        end
        
        print("fetching url...")
        local server = req(url)
        os.execute("sleep 0.1")
        print("fetching data...")
        local ss = io.popen("curl -fs "..server)
        if not ss then print("\27[91mfailed on request.") return end
        local content = ss:read("*a")
        ss:close()
        
        if content == nil then
            print("null content.")
            return
        end
        
        io.write("\27[3J\27[2J\27[H\27[?25h")
        
        while true do
            local g = io.popen("stty size")
            local cc = g:read("*a") g:close()
            local y,x = cc:match("(%d*) (%d*)")
            x = tonumber(x)
            y = tonumber(y)
            if y < 28 then
                print("\27[3J\27[2J\27[Hplease click everywhere on the screen\nto remove the virtual keyboard.")
                
                os.execute("sleep 1")
            else
                break
            end
        end
        os.execute("stty sane")
        local fn, err = load(content)
        if fn then
            fn()
        else
            print("\27[91mcode error: \27[0m"..tostring(err))
        end
        io.write("\27[?25l")
        os.execute("stty -icanon -echo -isig min 1 time 0")
    else
        print("\27[91mbad url format: probally system error.")
    end
end)