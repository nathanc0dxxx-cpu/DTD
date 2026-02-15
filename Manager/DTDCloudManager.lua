
if not DTDUser then DTDUser = { name = "Dougla037" } end
os.execute("clear")
print("\27[93minitializing...\27[0m")
do
    local ss = io.popen("curl -s https://raw.githubusercontent.com/nathanc0dxxx-cpu/DTD/main/SystemManagers/DTDCloudService.lua")
    if ss then load(ss:read("*a"))() ss:close() else print("\27[91mfail while loading postservice...\27[0m") end
end
print("\27[93mloading objects...\27[0m")
local files = {}
local function loadfiles(tb, path)
    if not tb then return end
    if path == nil then path = "" end
    local ss = io.popen("curl -s https://api.github.com/repos/tutugrande1235-DTD/DTD-Source-Scripts/contents/Cloud/"..DTDUser.name..path)
    local ssc = ss:read("*a") ss:close()
    for i,v in ssc:gmatch("\"name\"%s*:%s*\"(.-)\".-\"type\"%s*:%s*\"(.-)\"") do
        local obj = { name = i, tp = v }
        table.insert(tb, obj)
    end
end loadfiles(files)
local clouds = true
local dirpath = ""
while clouds do
    local havefile = false
    os.execute("clear")
    print("\27[0m\27[44m[Your files Colection!]:\27[0m\n")
    do
        local max = 2
        for i,v in ipairs(files) do
            if v.tp == "file" then
                havefile = true
                io.write("\27[96m"..v.name.."\27[0m ")
            elseif v.tp == "dir" then
                havefile = true
                io.write("\27[93m"..v.name.."\27[0m ")
            end
            if i >= max then
                print("\n")
            end
        end
    end if havefile == false then print("\27[90mHmm... Nothing stocked here...\27[0m") end
    print("\n\n\27[0m\27[44m[Your Local Files]:\27[0m\n")
    do
        local havelfile = false
        local pip = io.popen("ls")
        local pipc = pip:read("*a")
        pip:close()
        local max = 2
        local i = 0
        for v in pipc:gmatch("%S+") do
            havelfile = true
            i = i + 1
            io.write("\27[96m"..v.."\27[0m ")
            if i >= max then
                print("\n")
            end
        end if havelfile == false then print("\27[90mWow! you dont have nothing to stock...\27[0m") end
    end
    print("\n\n\27[0m\27[44m[============]:\27[0m")
    if dirpath ~= "" then print("\27[93mpath:\27[92m "..dirpath.."\27[0m") else print("\27[92mat home\27[0m") end
    io.write(" > \27[90m<name>, exit, stock, restore, folder\27[36D\27[92m")
    local input = io.read()
    if input == "exit" then
        os.execute("clear")
        clouds = false
        print("\27[91mlogout\27[0m")
    elseif input:sub(1,5) == "stock" then
        os.execute("clear")
        local query = input:sub(7)
        if not query then
            print("\27[93mtype an local file name!\27[0m")
            io.read()
        else
            local pip = io.popen("ls")
            local pipc = pip:read("*a")
            pip:close()
            local sucess = false
            for v in pipc:gmatch("%S+") do
                if v:match(query) then
                    print("\27[93mis "..v.." you want to stock?\27[0m")
                    print("\27[92m[Y]\27[0m/\27[91m[N]\27[0m:")
                    io.write(" > ")
                    local ask = io.read()
                    if ask == "y" or ask == "Y" then
                        print("\27[93mworking...\27[0m")
                        local file = io.open(v, "r")
                        local filec = file:read("*a")
                        file:close()
                        local updatef = false
                        for j,c in ipairs(files) do
                            if c.tp == "file" and c.name == v then
                                print("\27[93mupdating file...\27[0m")
                                DTDPostService:cloud(filec, DTDUser.name.."/"..dirpath..v, "PUT")
                                updatef = true
                                os.execute("clear")
                            end
                        end if updatef == false then
                            print("\27[93mstocking file...\27[0m")
                            DTDPostService:cloud(filec, DTDUser.name.."/"..dirpath..v, "POST")
                            os.execute("sleep 2")
                            files = {}
                            loadfiles(files, dirpath)
                            os.execute("clear")
                        end sucess = true break
                    else
                        print("\27[93mseeking...\27[0m")
                    end
                end
            end
            if sucess == false then print("\27[91mno file found...\27[0m") io.read() end
        end
    elseif input:sub(1,7) == "restore" then
        local query = input:sub(9)
        if not query then
            print("\27[91mno file name provided!\27[0m")
            io.read()
        else
            local foundfile = false
            for i,v in ipairs(files) do
                if v.name:match(query) then
                    print("\27[93mis "..v.name.." you want to restore?\27[0m")
                    print("\27[92m[Y]\27[0m/\27[91m[N]\27[0m:")
                    io.write(" > ")
                    local ask = io.read()
                    if ask == "y" or ask == "Y" then
                        foundfile = true
                        do
                            local ss = io.popen("curl -s https://raw.githubusercontent.com/tutugrande1235-DTD/DTD-Source-Scripts/main/Cloud/"..DTDUser.name.."/"..dirpath..v.name)
                            local ssc = ss:read("*a")
                            ss:close()
                            local loadf = io.open(v.name, "r")
                            if loadf then
                                loadf:close()
                                loadf = io.open(v.name, "w")
                                print("\27[93mupdating local file...\27[0m")
                                loadf:write(ssc)
                                loadf:close()
                                print("\27[92mfinished!\27[0m")
                            else
                                loadf = io.open(v.name, "w")
                                print("\27[92mrestoring file...\27[0m")
                                loadf:write(ssc)
                                loadf:close()
                                print("\27[92mfinished!\27[0m")
                            end
                        end break
                    else
                        print("\27[93mseeking...\27[0m")
                    end
                end
            end if foundfile == false then print("\27[91mno file found...\27[0m") io.read() end
        end
    elseif input:sub(1,6) == "folder" then
        local name = input:sub(8)
        local founddir = false
        if name:gsub(" ","") ~= "" and name:sub(1,6) ~= "remove" then
            for i,v in ipairs(files) do
                if v.tp == "dir" and v.name == name then
                    founddir = true
                    print("\27[91mdirectory already exists!\27[0m")
                end
            end if founddir == false then
                print("\27[93mcreating directory...\27[0m")
                DTDPostService:cloud("", DTDUser.name.."/"..dirpath..name.."/Folder", "POST")
                files = {}
                loadfiles(files, dirpath)
                break
            end
        elseif name:sub(1,6) == "remove" then
            local query = input:sub(15)
            if query then
                for i,v in ipairs(files) do
                    if v.tp == "dir" and v.name == query then
                        print("\27[93mremoving...\27[0m")
                        DTDPostService:cloud("", DTDUser.name.."/"..dirpath..query.."/Folder", "DELETE")
                        os.execute("sleep 3")
                        files = {}
                        loadfiles(files, dirpath)
                        break
                    end
                end
            else
                print("\27[91mno folder name provided!\27[0m")
                io.read()
            end
        else
            print("\27[91mno folder name provided\27[0m")
            print("usage: <name> to create\n remove <name> to delete")
            io.read()
        end
    else
        local openeddir = false
        for i,v in ipairs(files) do
            if v.tp == "dir" and v.name:match(input) then
                print("\27[93myou want to open "..v.name.." folder?\27[0m")
                print("\27[92m[Y]\27[0m/\27[91m[N]\27[0m:")
                io.write(" > ")
                local ask = io.read()
                if ask == "y" or ask == "Y" then
                    if dirpath == "" then
                        dirpath = "/"..v.name
                    else
                        dirpath = dirpath .. v.name .. "/"
                    end openeddir = true
                    files = {}
                    loadfiles(files, dirpath)
                    break
                end
            end
        end
        if openeddir == false and input == "home" then
            dirpath = ""
            files = {}
            loadfiles(files, dirpath)
        elseif openeddir == false and input == ".." then
            local lt = {}
            for v in dirpath:gmatch("([^/]+)") do
                if v ~= "" then
                    table.insert(lt, v)
                end
            end
            local intn = 0
            if lt[#lt] then
                for v in lt[#lt]:gmatch("(.)") do
                    intn = intn + 1
                end intn = intn + 1
                dirpath = dirpath:sub(1, #dirpath - intn)
                files = {}
                loadfiles(files, dirpath)
            end
        elseif openeddir == false then
            local query = input
            for i,v in ipairs(files) do
                if v.tp == "file" and v.name:match(query) then
                    print("\27[93mis "..v.name.." file you want to open?\27[0m")
                    print("\27[92m[Y]\27[0m/\27[91m[N]\27[0m:")
                    io.write(" > ")
                    local ask = io.read()
                    if ask == "y" or ask == "Y" then
                        local hub = true
                        local function loadfilecont()
                                local ss = io.popen("curl -s https://raw.githubusercontent.com/tutugrande1235-DTD/DTD-Source-Scripts/main/Cloud/"..DTDUser.name.."/"..dirpath..v.name)
                                if ss then local content = ss:read("*a") ss:close() return content else print("\27[91mfailed while loading file content...\27[0m") end
                        end local filecont = loadfilecont()
                        while hub do
                            local dirpath2 = dirpath
                            if dirpath2 == "" then
                                dirpath2 = "home"
                            end
                            os.execute("clear")
                            print("\27[0m\27[93mpath: \27[92m"..dirpath2.."\27[0m")
                            print("\27[0m\27[44m["..v.name.."][content]:\27[0m")
                            print(filecont)
                            print("\27[44m[Raw Link]:\27[92m\n".."https://raw.githubusercontent.com/tutugrande1235-DTD/DTD-Source-Scripts/main/Cloud/"..DTDUser.name.."/"..dirpath..v.name.."\27[0m")
                            print("\27[0m\27[44m[=============]:\27[0m")
                            io.write(" > \27[90mback, remove\27[12D\27[92m")
                            local userinp = io.read()
                            if userinp == "back" then
                                os.execute("clear")
                                hub = false
                                break
                            elseif userinp == "remove" then
                                print("\27[93myou really want to remove this file?\27[0m")
                                print("\27[92m[Y]\27[0m/\27[91m[N]\27[0m:")
                                io.write(" > ")
                                local ask2 = io.read()
                                if ask2 == "y" or ask2 == "Y" then
                                    hub = false
                                    os.execute("clear")
                                    print("\27[93mremoving...\27[0m")
                                    DTDPostService:cloud("", DTDUser.name.."/"..dirpath..v.name, "DELETE")
                                    print("\27[92mfinished!\27[0m")
                                    io.read()
                                    print("\27[93mupdating session...\27[0m")
                                    files = {}
                                    loadfiles(files, dirpath)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end