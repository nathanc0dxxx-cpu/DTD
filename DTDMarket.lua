
os.execute("clear")
local exit = false
local hubs = false
local markets = true
local packs = {}
local function loadpacks()
    local ss = io.popen("curl -s https://api.github.com/repos/nathanc0dxxx-cpu/DTD/contents/Market")
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

local function hub(query)
    os.execute("clear")
    local obj = {}
    for i,v in ipairs(packs) do
        if v.name:match(query) then
            obj = v
            break
        end
    end if not obj.name then markets = true return end
    obj.desc = "\27[0m no description provided!"
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
        markets = true
        return
    elseif uinp == "install" then
        os.execute("clear")
        print("\27[93mdownloading...\27[0m")
        local ssi = io.popen("curl -s https://raw.githubusercontent.com/nathanc0dxxx-cpu/DTD/main/Market/"..obj.name.."@"..obj.owner.."/content")
        if ssi then
            local ssic = ssi:read("*a")
            ssi:close()
            print("\27[93minstalling...\27[0m")
            local file = io.open(obj.name, "w")
            if file then
                file:write(ssic)
                file:close()
                print("\27[92minstalled!\n\27[0mpath: ")
                os.execute("pwd")
                os.execute("sleep 3")
                hubs = true
                return
            else
                print("\27[91merror while downloading...\27[0m")
            end
        end
        markets = true
        return
    elseif uinp == "comments" then
        local commentss = true
        local doreqc = true
        local issues = ""
        while commentss do
            os.execute("clear")
            if doreqc == true then
                print("\27[93mloading...\27[0m")
                local dds = io.popen("curl -s https://raw.githubusercontent.com/nathanc0dxxx-cpu/DTD/main/SystemManagers/DTDIssueService.lua")
                if dds then load(dds:read("*a"))() dds:close() else hubs = true return end
                doreqc = false
                issues = DTDIssueService:get()
            end
            
            print("\27[44m[Comments]:\27[0m") local foundcm = false
            for i,v in ipairs(issues) do
                local a, b, c = v.content:match("^(.-)@(.-)@(.*)$")
                if c == obj.name then
                    foundcm = true
                    print("\n\27[94m @"..a.."\27[0m\n  "..b.."\n----")
                end
            end if foundcm == false then print("\n\27[90mno comments yet.\27[0m\n") end
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
                    for i,v in ipairs(issues) do
                        local a, b, c = v.content:match("(.-)@(.-)@(.-)")
                        if a == _G.DTDUser.name and b == ucm and c == obj.name then
                            print("\27[91mspam detected\27[0m")
                            io.read()
                            break
                        end
                        DTDIssueService.new(_G.DTDUser.name.."@"..ucm.."@"..obj.name)
                        os.execute("sleep 2")
                        break
                    end
                else
                    print("\27[91mnot a valid comment!\27[0m")
                    os.execute("clear")
                end
            elseif cminp == "reset" then
                doreqc = true
            elseif cminp == "debug" then
                for i,v in ipairs(issues) do
                    print(v.content)
                end io.read()
            elseif cminp == "removeall" then
                for i,v in ipairs(issues) do
                    local a, b, c = v.content:match("^(.-)@(.-)@(.*)$")
                    if a == DTDUser.name and c == obj.name then
                        DTDIssueService.close(v.content)
                    end
                end
            end
        end
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