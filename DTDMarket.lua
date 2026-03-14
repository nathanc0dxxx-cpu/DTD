if not DTDUser then DTDUser = { name = "Dougla037" } end
local error0 = "Error: 0"
io.write("\27[?1006h")
io.write("\27[?1000h")

os.execute("stty -icanon -echo -isig min 1 time 0")

local function key()
    io.flush()
    io.write("\27[?1006l")
    io.write("\27[?1000l")
    local k = io.read(1)
    io.write("\27[?1006h")
    io.write("\27[?1000h")
    return k
end

local function mouse()
    os.execute("sleep 0.1")
    local c = io.read(1)
    if c ~= "\27" then
        return nil
    end

    local seq = c
    while true do
        local ch = io.read(1)
        seq = seq .. ch
        if ch == "M" or ch == "m" then
            break
        end
    end
    io.flush()
    if not seq:match("<(%d+);(%d+);(%d+)") then return 0,0,0 end

    local b,x,y = seq:match("<(%d+);(%d+);(%d+)")
    if not b then b = 0 end
    if not x then x = 0 end
    if not y then y = 0 end
    seq =""
    return tonumber(x), tonumber(y), tonumber(b)
end

os.execute("clear")
local exit = false
local hubs = false
local markets = true
local searchs = false
local packs = {}
local cache = false
local fcache = false

local function loadpacks()
    local sst = ""
    if fcache == false then
        local f = io.open("markethandler.txt","r")
        if f then
            cache = true
            sst = f:read("*a")
            f:close()
        end
    end
    fcache = false
    local cmd, out = "curl", "null"
    if cache == false then
        local f = io.open("markethandler.txt","w")
        if f then f:write("loading...") f:close() else sst = string.format("\"name\": \"%s@System\"", "Error: 1") end
        os.execute("curl -s https://api.github.com/repos/tutugrande1235-DTD/DTD-Source-Scripts/contents/Market > markethandler.txt")
    end
    local frames = {
        [0] = "[        ",
        [1] = "[\27[47m  \27[0m      ",
        [2] = "[\27[47m    \27[0m    ",
        [3] = "[\27[47m      \27[0m  ",
        [4] = "[\27[47m        \27[0m"
        
    }
    local n = -1
    local timeout = 5
    local second = 0
    
    while true do
        if cache == true then break end
        second = second + 0.2
        n = n + 1
        if n > #frames then n = 0 end
        io.write("\27[2J\27[3J\27[H")
        print("\27[92m"..frames[n].."\27[92m]")
        print("\27[0m\27[41m[Loading]\27[0m")
        
        os.execute("sleep 0.2")
        
        local f = io.open("markethandler.txt","r")
        if f then
            cont = f:read("*a")
            f:close()
            if not cont:find("loading...", 1, true) then
                sst = cont
                break
            end
        end
        
        if second > timeout then
            sst = string.format("\"name\": \"%s@System\"\n\"name\": \"%s@System\"", "Request Timeout", out.." "..cmd)
            break
        end
    end
    
    packs = {}
    for i,v in sst:gmatch("%s*\"name\"%s*:%s*\"%s*(.-)@(.-)\"") do
        local obj = { name = i, owner = v }
        table.insert(packs, obj)
    end
end loadpacks()

local function clear()
    io.write("\27[3J\27[2J\27[H")
end

local inp = nil
local query = ""
local function search()
    clear()
    local results = {}
    print("\27[0m\27[44m[Search]:\27[41m[TYPE: CTRL+Q TO LEAVE]\27[0m")
    for i,v in ipairs(packs) do
        if v.name:find(query, 1, true) then
            table.insert(results, v)
        end
    end
    io.write(" > \27[38;5;208m"..query)
    for i,v in ipairs(results) do
        if v.name:sub(1, #query) == query then
            local leng = v.name
            io.write("\27[90m"..v.name:sub(#query + 1, #leng).."\27[0m")
            break
        end
    end
    io.write("\n\n")
    if #results > 10 then
        for i = 1,10 do
            local v = results[i]
            print("\27[94m [ \27[96m"..i.."\27[94m ]: \27[0m\27[44m"..v.name.."\27[0m \27[90m"..v.owner.."\n")
        end
    elseif #results > 1 then
        for i,v in ipairs(results) do
            print("\27[94m [ \27[96m"..i.."\27[94m ]: \27[0m\27[44m"..v.name.."\27[0m \27[90m"..v.owner.."\n")
        end
    else
        local i = #results
        if i > 0 then 
            local v = results[i]
            print("\27[94m [ \27[96m"..i.."\27[94m ]: \27[0m\27[46m"..v.name.."\27[0m \27[90m"..v.owner.."\n")
        end
    end

    print("\27[0m\27[41m[======================]\27[0m")
    local uinp = key()

    if uinp == "" or uinp == "\n" then
        local set = 1
        local target = ""
        while true do
            if #results == 1 then
                inp = results[1].name
                hubs = true
                return
            end
            local max = #results
            if max == 0 then
                searchs = true
                return
            end
            if set <= 0 then set = 1 end
            if set >= max + 1 then set = max end
            clear()
            print("\27[44m[Results]:\27[41m[============]:\27[0m\n")
            for i,v in ipairs(results) do
                local arrow = ""
                if i == set then
                    arrow = " \27[1m<\27[0m"
                    target = v.name
                end
                print(" \27[38;5;208m["..v.name.."]:\27[0m\27[90m "..v.owner.."\27[0m"..arrow.."\n")
            end

            print("\27[0m\27[44m[======================]\27[0m")
            io.write(" > \27[90m<Exit> |<Back> | <Up> | <Down> | <Select>\27[0m\n")
            io.write(" > \27[92m [^Q]  |  [Q]  |  [W] |  [S]   |  [ENTER]\27[0m\n")
            local k = key()
            if k == "q" then
                searchs = true
                return
            elseif k == "Q" then
                markets = true
                return
            elseif k == "s" then
                set = set + 1
            elseif k == "w" then
                set = set - 1
            elseif k == "" or k == "\n" then
                inp = target
                hubs = true
                return
            end
        end
        searchs = true
        return
    elseif uinp == "\8" or uinp == "\127" then
        query = query:sub(1, #query - 1)
        searchs = true
        return
    elseif uinp == "\3" or uinp == "\17" then
        markets = true
        return
    else
        query = query .. uinp
        searchs = true
        return
    end
end

local function market()
    clear()
    local usedpacks = {}
    print("\27[0m\27[44m[Market]:\27[41m[=====]:\27[44m[X];[S];[R]\27[0m\n")
    do
    local maxi = 2
    local foundpkg = false
        for i = 1,9 do
            if packs[i] then
                table.insert(usedpacks, packs[i].name)
                foundpkg = true
                io.write("\27[92m [\27[93m"..packs[i].name:gsub("%.%s*(.-)$","").."\27[92m]\27[0m")
                if i >= maxi then
                    maxi = maxi + 2
                    print("\n")
                end
            end
        end if foundpkg == false then io.write("\27[90mWOW! nothing here, why dont you try to load the list?\27[0m") end
    end
    print("\n\n\27[0m\27[45m[Some Plugins for you!]:\27[0m\n")
    do
    local maxi = 2
    local foundpkg = false
        for i = #usedpacks, #packs do
            local target = packs[i]
            if target and (not table.concat(usedpacks, " "):match(target.name)) and target.name:match("%.dtdp%.lua$") then
                io.write("\27[92m [\27[93m"..target.name:gsub("%.%s*(.-)$","").."\27[92m]\27[0m")
                foundpkg = true
                if i >= maxi then
                    maxi = maxi + 2
                    print("\n")
                end
            end
        end if foundpkg == false then io.write("\27[90mhmm... no plugin here today...\27[0m") end
    end
    print("\n\n\27[0m\27[43m[Try some of these stuff!]:\27[0m\n")
    do
    local maxi = 2
    local ii = 0
    local foundpkg = false
        for i = math.max(#packs - 9, 1), #packs do
            ii = ii + 1
            local target = packs[i]
            if target and (not table.concat(usedpacks, " "):match(target.name)) then
                io.write("\27[92m [\27[93m"..target.name:gsub("%.%s*(.-)$","").."\27[92m]\27[0m")
                foundpkg = true
                if ii >= maxi then
                    maxi = maxi + 2
                    print("\n")
                end
            end
        end if foundpkg == false then io.write("\27[90msorry, here dont have any recent pack...\27[0m") end
    end
    print("\n\n\27[0m\27[46m[Some Frameworks and Studio extensions!]:\27[0m\n")
    do
    local maxi = 2
    local foundpkg = false
        for i = #usedpacks, #packs do
            local target = packs[i]
            if target and (not table.concat(usedpacks, " "):match(target.name)) and target.name:match("%.mp%.lua$") then
                io.write("\27[92m [\27[93m"..packs[i].name:gsub("%.%s*(.-)$","").."\27[92m]\27[0m")
                foundpkg = true
                if i >= maxi then
                    maxi = maxi + 2
                    print("\n")
                end
            end
        end if foundpkg == false then io.write("\27[90mHmm... looks like there’s nothing of this type here.\27[0m") end
    end
    print("\n\n\27[41m[======================]\27[0m")
    
    local x,y = mouse()
    local yy = false
    if y >= 1 and y <= 2 then yy = true end
    if x >= 18 and x <= 21 and yy == true then
        clear()
        print("\27[91mlogout\27[0m")
        exit = true
        return
    elseif x >= 28 and x <= 31 and yy == true then
        fcache = true
        cache = false
        loadpacks()
        markets = true
        return
    elseif x >= 23 and x <= 26 and yy == true then
        searchs = true
        query = ""
        return
    else
        markets = true
        return
    end
end
local inpackage = false
local obj = {}
local function hub(query)
    clear()
    for i,v in ipairs(packs) do
        if inpackage == true then break else obj = {} end
        if v.name == query then
            obj = v
            break
        elseif v.name:find(query, 1, true) then
            print("\27[0mis "..v.name.." what you want? \27[92m[Y]\27[0m/\27[91m[N]\27[0m:")
            io.write(" > ")
            local ask = io.read()
            if ask == "y" or ask == "Y" then
                obj = v
                inpackage = true
                break
            elseif ask == "no" then
                break
            else
                print("going to next...")
            end
        end
    end if not obj.name then markets = true return end
    local defaultd = "press \27[4m\27[94mHere\27[0m to load the package description"
    obj.desc = obj.desc or defaultd
    obj.loadeddesc = obj.loadeddesc or false
    print("\27[0m\27[44m[HUB]:\27[41m[===]:[X]\27[0m")
    print(string.format([[
  .--_____
  |       | %s
  |---?---| %s
  |       | %s
  |_______| %s
  %s
    ]], "\27[96m"..obj.name:gsub("(%..-)$","").."\27[0m", "\27[90mby \27[94m@"..obj.owner.."\27[0m", "\27[90mtype: \27[91m"..obj.name:gsub("^(.-)%.","").."\27[0m", "\27[42m[Install]\27[0m", obj.desc))
    print("\27[0m\27[44m[==============]:\27[45m[Comments]\27[0m")
    
    local uinp = ""
    local x,y = mouse()
    if y == 1 and x >= 13 and x <= 15 then
        inpackage = false
        markets = true
        return
    elseif y == 6 and x >= 13 and x <= 21 and obj.name ~= error0 then
        clear()
        local toinstall = {
            [1] = { all = obj.name.."@"..obj.owner, name = obj.name, owner = obj.owner }
        }

        local requires = {
            [1] = {
                keyword = "require",
            },
            [2] = {
                keyword = "import",
            },
            [3] = {
                keyword = "#include",
            },
        }

        print("\27[93mchecking dependencies...")
        local packagecontent = ""
        local ss = io.popen("curl -s https://raw.githubusercontent.com/tutugrande1235-DTD/DTD-Source-Scripts/main/Market/"..obj.name.."@"..obj.owner.."/content@"..obj.owner)
        if ss then
            packagecontent = ss:read("*a")
            ss:close()
        else
            print("\27[91merror on dependencies check...\27[0m")
            markets = true
            key()
            return
        end
        local toformat = {}
        for i,v in ipairs(requires) do
            for g in packagecontent:gmatch("%S+") do
                if g:match(v.keyword) then
                    local dpd = g
                    dpd = dpd:gsub("\"","")
                    dpd = dpd:gsub(v.keyword, "")
                    dpd = dpd:gsub("\'","")
                    dpd = dpd:gsub("%(","")
                    dpd = dpd:gsub("%)","")
                    dpd = dpd:gsub("<","")
                    dpd = dpd:gsub(">","")
                    table.insert(toformat, dpd)
                end
            end
        end
        print("formating...")
        for i,v in ipairs(toformat) do
            for j,g in ipairs(packs) do
                if g.name == v then
                    local object = { all = g.name.."@"..g.owner, name = g.name, owner = g.owner }
                    table.insert(toinstall, object)
                end
            end
        end
        print("\27[0m\27[44m[OBJECT]:\27[0m")
        print("  installing: \27[92m"..obj.name.."\27[0m")
        print("\27[0m\27[44m[PACKAGE DEPENDENCIES]:\27[0m\n")
        for i,v in ipairs(toinstall) do
            if v.name ~= obj.name then
                print("  \27[95m["..v.name.."]\27[0m\n")
            end
        end if not toinstall[2] then print("  \27[90mno dependencies to install\27[0m\n") end
        print("\27[0m\27[44m[====================]:\27[0m")
        print("\27[93mprocced? \27[92m[Y]\27[0m/\27[91m[N]\27[0m:")
        while true do
            local ask = key()
            if ask:lower() == "y" then
                print("procceding...")
                break
            elseif ask:lower() == "n" then
                print("cancelling...")
                markets = true
                return
            end
        end

        for i,targetpack in ipairs(toinstall) do
            print("\27[93mdownloading "..targetpack.name.."...\27[0m")
            local ssi = io.popen("curl -s https://raw.githubusercontent.com/tutugrande1235-DTD/DTD-Source-Scripts/main/Market/"..targetpack.all.."/content@"..targetpack.owner)
            if ssi then
                local ssic = ssi:read("*a")
                ssi:close()
                print("\27[93minstalling...\27[0m")
                local file = io.open(targetpack.name, "w")
                if file then
                    file:write(ssic)
                    file:close()
                    print("\27[92minstalled!\n\27[0mpath: ")
                    os.execute("pwd")
                else
                    print("\27[91merror while downloading...\27[0m")
                end
            end
        end
        io.write("\27[32m[process completed, press ENTER]:\27[0m")
        key()
        hubs = true
        return
    elseif y == 9 and x >= 18 and x <= 27 and obj.name ~= error0 then
        local commentss = true
        local doreqc = true
        local issues = ""
        local foundissue = false
        local packcomments = {}
        while commentss do
            clear()
            local mainissue = ""
            if doreqc == true then
                foundissue = false
                packcomments = {}
                print("\27[93mloading...\27[0m")

                local dds = io.popen("curl -s https://raw.githubusercontent.com/nathanc0dxxx-cpu/DTD/main/SystemManagers/DTDIssueService.lua")

                if dds then
                    local c = dds:read("*a")
                    dds:close()
                    local var = load(c)
                    if var then
                        var()
                        print("\27[92mloaded service.\27[0m")
                    else
                        print(c)
                        print(tostring(var))
                        hubs = true
                        commentss = false
                        io.read()
                        return
                    end
                else
                    hubs = true
                    commentss = false
                    return
                end
                doreqc = false
                print("searching for current channel...")
                issues = DTDIssueService.get()
                for i,v in ipairs(issues) do
                    local a = v.content
                    if a == obj.name.."@comments" then
                        print("loading channel comments...")
                        packcomments = DTDIssueService.comment.read(obj.name.."@comments")
                        mainissue = v.id
                        foundissue = true
                        break
                    end
                end clear()
            end

            print("\27[44m[Comments]:\27[0m") local foundcm = false
            if not packcomments then packcomments = { [1] = { body = "System@error! a unexpected error as ocurred while loading this package comments... im sorry.<br> > i got these info: ID: "..mainissue.." IF: "..tostring(foundissue).." ", id = "404"} } end
            for i,v in ipairs(packcomments) do
                local a = v.body:find("@")
                if a then
                    foundcm = true
                    local ac = v.body:sub(1, a-1)
                    local ad = v.body:sub(a+1)
                    print("\n\27[94m @"..ac.."\27[0m\n  "..ad:gsub("<br>","\n"):gsub("$<dtd$ball$>","@").."\n----------------\n")
                end
            end if foundcm == false and foundissue == true then
                print("\n\27[90mno comments yet.\27[0m\n")
            elseif foundissue == false then
                print("\27[91missue root not found...\27[0m\n")
            end
            print("\27[0m\27[44m[=========]:\27[0m")

            io.write(" > \27[90m<Back> | <Comment> | <Reset> | <RemoveAllComments>\27[0m\n")
            io.write(" > \27[92m [Q]   |    [C]    |   [R]   |         [A]\n")
            local cminp = key() io.write("\27[0m")
            if cminp == "q" then
                clear()
                commentss = false
                hubs = true
                return
            elseif cminp == "c" then
                clear()
                print("\27[96m leave your comment!\n\27[93mpress ENTER to send, use: <br> to \\n a line (break line)\27[0m")
                io.write(" > \27[90mwhat are you thinking now?...\27[29D\27[0m")
                local ucm = io.read()
                if ucm:gsub(" ","") ~= "" then
                    local spam = false
                    for i,v in ipairs(packcomments) do
                        local a = v.body:find("@")
                        if a then
                            local b = v.body:sub(1, a-1)
                            local c = v.body:sub(a+1)
                            if b == _G.DTDUser.name and c == ucm then
                                print("\27[91mspam detected\27[0m")
                                key()
                                spam = true
                                break
                            end
                        end
                    end
                    if spam == false then
                        print("\27[93msendding...\27[0m")
                        DTDIssueService.comment.add(obj.name.."@comments", ucm:gsub("@","$<dtd$ball$>"))
                        print("\27[93mwait 15 seconds before reset, please!...\27[0m")
                        io.write("[press ENTER]:")
                        key()
                    end
                else
                    print("\27[91mnot a valid comment!\27[0m")
                    key()
                end
            elseif cminp == "r" then
                doreqc = true
            elseif cminp == "d" then
                for i,v in ipairs(packcomments) do
                    print(v.body)
                end key()
            elseif cminp == "a" then
                print("\27[91mremoving...\27[0m")
                for i,v in ipairs(packcomments) do
                    local a = v.body:find("@")
                    if a then
                        local b = v.body:sub(1, a-1)
                        if b == DTDUser.name then
                            print(v.id)
                            DTDIssueService.comment.remove(v.id)
                        end
                    end
                end
                print("\27[93mwait 15 seconds before reset, please!...\27[0m")
                io.write("[press ENTER]:")
                key()
            end
        end
    elseif y == 7 and x >= 9 and x <= 12 and obj.loadeddesc == false and obj.name ~= error0 then
        local f = io.open("marketdescriptor.txt","w")
        if f then
            f:write("empty")
            f:close()
        else
            obj.desc = "\27[91mno file writing permission...\27[0m"
            hubs = true
            return
        end
        os.execute("curl -s https://raw.githubusercontent.com/tutugrande1235-DTD/DTD-Source-Scripts/main/Market/"..obj.name.."@"..obj.owner.."/description@"..obj.owner.." > marketdescriptor.txt &")
        local n = 0
        local nn = 0
        while true do
            if n > 3 then n = 0 end
            io.write("\27[3J\27[2J\27[H")
            io.write("\27[90mloading description"..string.rep(".",n))
            local f = io.open("marketdescriptor.txt","r")
            if f then
                local c = f:read("*a")
                f:close()
                if c ~= "empty" and c ~= "" then
                    obj.desc = c
                    break
                end
            end
            if nn > 25 then obj.desc = "\27[91mtimeout.\27[0m" break end
            os.execute("sleep 0.2")
            n = n + 1
            nn = nn + 1
        end
        
        os.remove("marketdescriptor.txt")
        hubs = true
        return
    else
        hubs = true
        return
    end
end

while not exit do
    if markets == true then
        markets = false
        market()
    elseif hubs == true then
        hubs = false
        hub(inp)
    elseif searchs == true then
        searchs = false
        search()
    end
end

io.write("\27[?1006l")
io.write("\27[?1000l")
os.execute("stty sane")