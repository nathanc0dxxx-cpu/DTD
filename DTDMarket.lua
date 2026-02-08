if not DTDUser then DTDUser = { name = "Dougla037" } end

os.execute("clear")
local exit = false
local hubs = false
local markets = true
local packs = {}
local function loadpacks()
    local ss = io.popen("curl -s https://api.github.com/repos/tutugrande1235-DTD/DTD-Source-Scripts/contents/Market")
    local sst = ss:read("*a")
    ss:close()
    packs = {}
    for i,v in sst:gmatch("%s*\"name\"%s*:%s*\"%s*(.-)@(.-)\"") do
        local obj = { name = i, owner = v }
        table.insert(packs, obj)
    end
end loadpacks()

local inp = nil

local function search(query)
    os.execute("clear")
    print("\27[0m\27[44m[Results]:\27[41m[============]\27[0m\n")
    for i,v in ipairs(packs) do
        if v.name:match(query) then
            print("\27[92m [ \27[93m"..i.."\27[92m ]: \27[0m\27[42m"..v.name.."\27[0m \27[90m"..v.owner.."\n")
        end
    end print("\27[0m\27[44m[======================]\27[0m")
    io.write(" > \27[90m<pack>, back\27[12D\27[92m")
    inp = io.read()
    if inp == "back" then
        markets = true
        return
    else
        hubs = true
        return
    end
end

local function market()
    os.execute("clear")
    local usedpacks = {}
    print("\27[0m\27[44m[Market]:\27[41m[=============]\27[0m\n")
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
        end if foundpkg == false then io.write("\27[90mWOW! nothing here...\27[0m\n\n") end
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
    local foundpkg = false
        for i = #packs, #packs - 9 do
            local target = packs[i]
            if target and (not table.concat(usedpacks, " "):match(target.name)) then
                io.write("\27[92m [\27[93m"..target.name:gsub("%.%s*(.-)$","").."\27[92m]\27[0m")
                foundpkg = true
                if i >= maxi then
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
    print("\n\n\27[44m[======================]\27[0m")
    io.write(" > \27[90m<pack>, search, exit, reset\27[27D\27[92m")
    inp = io.read()
    if inp == "exit" then
        os.execute("clear")
        print("\27[91mlogout\27[0m")
        exit = true
        return
    elseif inp == "reset" then
        loadpacks()
        markets = true
        return
    elseif inp:sub(1,7) == "search " then
        search(inp:sub(8))
    else
        hubs = true
        return
    end
end
local inpackage = false
local obj = {}
local function hub(query)
    os.execute("clear")
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
    os.execute("clear")
    obj.desc = obj.desc or "type: \27[32mdesc\27[0m to load the package description"
    print("\27[0m\27[44m[HUB]:\27[41m[==========]\27[0m")
    print(string.format([[
  .--_____
  |       | %s
  |---?---| %s %s
  |       |
  |_______|
  %s
    ]], "\27[96m"..obj.name.."\27[0m", "\27[90mby ", obj.owner.."\27[0m", obj.desc))
    print("\27[0m\27[44m[================]\27[0m")
    io.write(" > \27[90mback, install, comments\27[23D\27[92m")
    local uinp = io.read()
    if uinp == "back" then
        inpackage = false
        markets = true
        return
    elseif uinp == "install" then
        os.execute("clear")
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
        local ss = io.popen("curl -s https://raw.githubusercontent.com/tutugrande1235-DTD/DTD-Source-Scripts/main/Market/"..obj.name.."@"..obj.owner.."/content")
        if ss then
            packagecontent = ss:read("*a")
            ss:close()
        else
            print("\27[91merror on dependencies check...\27[0m")
            markets = true
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
        end if not toinstall[1] then print("  \27[90mno dependencies to install\27[0m\n") end
        print("\27[0m\27[44m[====================]:\27[0m")
        print("\27[93mprocced? \27[92m[Y]\27[0m/\27[91m[N]\27[0m:")
        io.write(" > ")
        local ask = io.read()
        if ask == "y" or ask == "Y" then
            print("procceding...")
        else
            print("cancelling...")
            markets = true
            return
        end

        for i,targetpack in ipairs(toinstall) do
            print("\27[93mdownloading "..targetpack.name.."...\27[0m")
            local ssi = io.popen("curl -s https://raw.githubusercontent.com/tutugrande1235-DTD/DTD-Source-Scripts/main/Market/"..targetpack.all.."/content")
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
        io.read()
        hubs = true
        return
    elseif uinp == "comments" then
        local commentss = true
        local doreqc = true
        local issues = ""
        local foundissue = false
        local packcomments = {}
        while commentss do
            os.execute("clear")
            local mainissue = ""
            if doreqc == true then
                foundissue = false
                packcomments = {}
                print("\27[93mloading...\27[0m")
                local dds = io.popen("curl -s https://raw.githubusercontent.com/nathanc0dxxx-cpu/DTD/main/SystemManagers/DTDIssueService.lua")
                if dds then load(dds:read("*a"))() dds:close() else hubs = true break end
                doreqc = false
                issues = DTDIssueService.get()
                for i,v in ipairs(issues) do
                    local a = v.content
                    if a == obj.name.."@comments" then
                        packcomments = DTDIssueService.comment.read(v.id)
                        mainissue = v.id
                        foundissue = true
                        break
                    end
                end os.execute("clear")
            end

            print("\27[44m[Comments]:\27[0m") local foundcm = false

            for i,v in ipairs(packcomments) do
                local a = v.body:find("@")
                if a then
                    foundcm = true
                    local ac = v.body:sub(1, a-1)
                    local ad = v.body:sub(a+1)
                    print("\n\27[94m @"..ac.."\27[0m\n  "..ad.."\n----------------")
                end
            end if foundcm == false and foundissue == true then
                print("\n\27[90mno comments yet.\27[0m\n")
            elseif foundissue == false then
                print("\27[91missue root not found...\27[0m\n")
            end
            print("\27[0m\27[44m[=========]:\27[0m")

            io.write(" > \27[90mback, comment, reset, removeall\27[31D\27[92m")
            local cminp = io.read() io.write("\27[0m")
            if cminp == "back" then
                os.execute("clear")
                commentss = false
                hubs = true
                return
            elseif cminp == "comment" then
                doreqc = true
                os.execute("clear")
                print("\27[96m leave your comment!\n\27[93mpress ENTER to send\27[0m")
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
                                io.read()
                                spam = true
                                break
                            end
                        end
                    end
                    if spam == false then
                        print("\27[93msendding...\27[0m")
                        DTDIssueService.comment.add(mainissue, _G.DTDUser.name.."@"..ucm)
                        os.execute("sleep 2")
                        doreq = true
                    end
                else
                    print("\27[91mnot a valid comment!\27[0m")
                    os.execute("clear")
                end
            elseif cminp == "reset" then
                doreqc = true
            elseif cminp == "debug" then
                for i,v in ipairs(packcomments) do
                    print(v.body)
                end io.read()
            elseif cminp == "removeall" then
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
                os.execute("sleep 1")
                doreqc = true
            end
        end
    elseif uinp == "desc" then
        local ssdesc = io.popen("curl -s https://raw.githubusercontent.com/tutugrande1235-DTD/DTD-Source-Scripts/main/Market/"..obj.name.."@"..obj.owner.."/description")
        if ssdesc then obj.desc = ssdesc:read("*a") ssdesc:close() else print("\27[91mfailed to load package description") io.read() end
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
    end
end