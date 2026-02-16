if not DTDUser then DTDUser = { name = "Dougla037"} end
local dirpath = ""

dtdstd:newcmd({
  token = "help",
  func = function()
    for i,v in ipairs(dtdstd.cmd) do
      print("\27[96m"..i.." \27[92m"..v.token.."\n  \27[93m"..v.desc.."\27[0m\n")
    end
  end,
  desc = "it helps you bro... JUST!"
})
dtdstd:newcmd({
    token = "clear",
    func = function()
        os.execute("clear")
    end,
    desc = "clear the screen"
})
dtdstd:newcmd({
    token = "deploy",
    func = function()
        local query = dtdstd.args[2]
        local pip = io.popen("ls "..dirpath)
        local pipc = pip:read("*a")
        pip:close()
        for v in pipc:gmatch("%S+") do
            if v:match(query) then
                print("\27[93mis "..v.." you want to deploy?\n\27[92m[Y]\27[0m/\27[91m[N]\27[0m: ")
                local answer = io.read()
                if answer == "y" or answer == "Y" then
                    print("\27[93mworking...\27[0m")
                    local file = io.open(v,"r")
                    if file then
                        local content = file:read("*a")
                        file:close()
                        local strucn = v.."@".._G.DTDUser.name
                        print("\27[93mloading service...")
                        local ss = io.popen("curl -s https://raw.githubusercontent.com/nathanc0dxxx-cpu/DTD/main/SystemManagers/DTDPostService.lua")
                        if ss then load(ss:read("*a"))() ss:close()
                            local test = io.popen("curl -s https://api.github.com/repos/tutugrande1235-DTD/DTD-Source-Scripts/contents/Market")
                            local testc = test:read("*a")
                            test:close()
                            local packgs = {}
                            for g,j in testc:gmatch("\"name\"%s*:%s*\"(.-)@(.-)\"") do
                                local obj = { name = g, owner = j }
                                table.insert(packgs, obj)
                            end local found = false
                            for j,k in ipairs(packgs) do
                                if v == k.name and _G.DTDUser.name ~= k.owner then 
                                    found = true
                                end
                            end local found2 = false
                            for j,k in ipairs(packgs) do
                                if k.owner == _G.DTDUser.name and k.name == v then
                                    found2 = true
                                end
                            end
                            print("\27[93minsert pack description:\27[0m")
                            io.write(" > ")
                            local packdesc = io.read()
                            if packdesc == "" then 
                                packdesc = "no description provided"
                            end
                            if found == false and found2 == false then
                                print("\27[93msending...")
                                DTDPostService:market(content, strucn.."/content", "POST")
                                DTDPostService:market(packdesc, strucn.."/description", "POST")
                                break
                            elseif found == false and found2 == true then
                                print("\27[93msending...")
                                DTDPostService:market(content, strucn.."/content", "PUT")
                                break
                            end
                        else
                            print("\27[91mfailed to load postservice, aborting...\27[0m")
                            return
                        end
                    else
                        print("\27[91mthe file got null\27[0m")
                    end
                else
                    print("\27[0m\n")
                end
            end
        end
    end,
    desc = "deploy a file to the market"
})
dtdstd:newcmd({
    token = "deorbit",
    func = function()
        local query = dtdstd.args[2]
        local ss = io.popen("curl -s https://api.github.com/repos/tutugrande1235-DTD/DTD-Source-Scripts/contents/Market")
        local ssc if ss then ssc = ss:read("*a") ss:close() else print("\27[91mfailed server connection...\27[0m") return end

        local packgs = {}
        for i,v in ssc:gmatch("%s*\"name\"%s*:%s*\"(.-)@(.-)\"") do
            local obj = { name = i, owner = v }
            table.insert(packgs, obj)
        end
        print("\27[93mloading service...\27[0m")
        local sss = io.popen("curl -s https://raw.githubusercontent.com/nathanc0dxxx-cpu/DTD/main/SystemManagers/DTDPostService.lua")
        if sss then load(sss:read("*a"))() sss:close() else print("\27[91mfailed to load service 1...\27[0m") return end
        
        local sucessd = false
        for i,v in ipairs(packgs) do
            if v.name:match(query) and v.owner == _G.DTDUser.name then
                print("\27[93mis "..v.name.." what you want to delete?\27[0m\27[92m[Y]\27[0m/\27[91m[N]\27[0m?\n")
                local answer = io.read()
                if answer == "y" or answer == "Y" then
                    print("\27[93mdeleting...\27[0m")
                    DTDPostService:market("",v.name.."@".._G.DTDUser.name.."/content", "DELETE")
                    DTDPostService:market("",v.name.."@".._G.DTDUser.name.."/description",  "DELETE")
                    
                    print("\27[92mdeleted sucefully!")
                    sucessd = true
                    break
                else
                    print("\27[93mok! seeking...\27[0m")
                end
            end
        end if sucessd == false then print("\27[96msorry i dont found any pack named "..query.." or likey in your posts... :c\27[0m") end
    end,
    desc = "delete an market file in who you deployed"
})
dtdstd:newcmd({
    token = "view",
    func = function()
        local ss = io.popen("curl -s https://api.github.com/repos/tutugrande1235-DTD/DTD-Source-Scripts/contents/Market")
        local handle = ss:read("*a")
        ss:close() local pkgs = {}
        for i,v in handle:gmatch("%s*\"name\"%s*:%s*\"(.-)@(.-)\"") do
            local obj = { name = i, owner = v }
            table.insert(pkgs, obj)
        end for i,v in ipairs(pkgs) do
            if v.owner == _G.DTDUser.name then
                print("\27[92m [ \27[96m"..v.name.."\27[92m ]\27[0m")
            end
        end
    end,
    desc = "view your deployed files"
})
dtdstd:newcmd({
    token = "ls",
    func = function()
        local pip = io.popen("ls -p "..dirpath)
        local c = pip:read("*a")
        pip:close()
        if c ~= "" then
            print("\27[0m\27[44m[current files]:\27[0m\n")
            local maxi = 0
            local i = 0
            for v in c:gmatch("%S+") do
                i = i + 1
                if not v:match("/$") then
                    maxi = maxi + 1
                    io.write("  \27[96m"..v)
                    if i > maxi then
                        print("\n")
                    end
                end
            end
            i = 0
            maxi = 0
            print("\n\27[0m\27[44m[folders]:\27[0m\n")
            for v in c:gmatch("%S+") do
                i = i + 1
                if v:match("/$") then
                    maxi = maxi + 1
                    io.write("  \27[93m"..v)
                    if i > maxi then
                        print("\n")
                    end
                end
            end
            print("\27[0m\27[44m[=======]:\27[0m")
        else
            print("\27[91mno files or directories here...")
        end
    end,
    desc = "list your local files"
})
dtdstd:newcmd({
    token = "path",
    func = function()
        if dirpath == "" then
            print("\27[0mPATH: \27[92mat home")
        else
            print("\27[0mPATH: \27[92m"..dirpath)
        end
    end,
    desc = "show the actual dir path"
})
dtdstd:newcmd({
    token = "open",
    func = function()
        local dir = dtdstd.args[2]
        local ifc = ""
        if dirpath ~= "" then
            ifc = "/"
        end
        local cmd = io.popen("ls "..dirpath..ifc..dir)
        local cmdc = cmd:read("*a")
        cmd:close()

        if cmdc == "" then
            print("\27[91mfolder not found!\27[0m")
            return
        end

        if dir then
            if dir ~= ".." then
                dirpath = dirpath .. "/".. dir
            else
                dirpath = dirpath:gsub("/(.-)$","")
            end
        else
            print("\27[91mno folder name provided!\27[0m")
        end
    end,
    desc = "open a folder/directory"
})
dtdstd:newcmd({
    token = "desc",
    func = function()
        local query = dtdstd.args[2]
        if query then
            local ss = io.popen("curl -s https://api.github.com/repos/tutugrande1235-DTD/DTD-Source-Scripts/contents/Market")
            if ss then
                do
                    print("\27[93mloading service...\27[0m")
                    local ss = io.popen("curl -s https://raw.githubusercontent.com/nathanc0dxxx-cpu/DTD/main/SystemManagers/DTDPostService.lua")
                    if ss then load(ss:read("*a"))() ss:close() else print("\27[91mfailed while loading postservice...") return end
                end
                local cont = ss:read("*a")
                ss:close()
                local packs = {}
                for i,v in cont:gmatch("\"name\"%s*:%s*\"(.-)@(.-)\"") do
                    local obj = { name = i, owner = v }
                    table.insert(packs, obj)
                end
                local target = nil
                for i,v in ipairs(packs) do
                    if v.name == query and v.owner == DTDUser.name then
                        target = v
                        break
                    elseif v.name:find(query, 1, true) and v.owner == DTDUser.name then
                        print("\27[0mis "..v.name.." you want? \27[92m[Y]\27[0m/\27[91m[N]\27[0m:")
                        io.write(" > ")
                        local ask = io.read()
                        if ask == "y" or ask == "Y" then
                            target = v
                        end
                        break
                    end
                end
                if target then
                    local session = true
                    local function rd()
                        local ss = io.popen("curl -s https://raw.githubusercontent.com/tutugrande1235-DTD/DTD-Source-Scripts/main/Market/"..target.name.."@"..target.owner.."/description")
                        if ss then local c = ss:read("*a") ss:close() return c else return nil end
                    end
                    local pdesc = rd()
                    while session do
                        os.execute("clear")
                        print("\27[0m\27[44m["..target.name.."]:\27[0m")
                        print(pdesc)
                        print("\27[0m\27[44m[=================]:\27[0m")
                        io.write(" > \27[90mback, edit, reset\27[17D\27[92m")
                        local di = io.read()
                        if di == "back" then
                            os.execute("clear")
                            session = false
                            break
                        elseif di == "reset" then
                            pdesc = rd()
                        elseif di == "edit" then
                            os.execute("clear")
                            print("\27[93m => inputting new description for "..target.name)
                            io.write("\27[0m > ")
                            local newdesc = io.read()
                            if newdesc ~= "" then
                                os.execute("clear")
                                print("\27[93mworking...")
                                if pdesc:sub(1,3) == "404" then
                                    DTDPostService:market(newdesc, target.name.."@"..target.owner.."/description",  "POST")
                                else
                                    DTDPostService:market(newdesc, target.name.."@"..target.owner.."/description",  "PUT")
                                end
                                print("\27[92mfinished!\27[0m")
                                os.execute("sleep 1")
                                pdesc = rd()
                            else
                                print("\27[91minvalid desc!\27[0m")
                                io.read()
                            end
                        end
                    end
                end
            else
                print("\27[91mfailed to load your packages...\27[0m")
            end
        end
    end,
    desc = "change a posted package description"
})