os.execute("clear")
print("\27[0m\27[44m[DTD::SM]:\27[0m \27[93minitializing...")
if not DTDUser then _G.DTDUser = { name = "User" } end

local serversjson = nil
local servers = {}
local function loadservers()
local ss = io.popen("curl -s https://api.github.com/repos/nathanc0dxxx-cpu/DTD/contents/Servers")
serversjson = ss:read("*a") ss:close()

servers = {}
for i,v in serversjson:gmatch("%s*\"name\"%s*:%s*\"(.-)%s*@(.-)\"") do
    local obj = { name = i, owner = v }
    table.insert(servers, obj)
end
end

local ssa = io.popen("curl -s https://raw.githubusercontent.com/nathanc0dxxx-cpu/DTD/main/SystemManagers/DTDPostService.lua")
local ssac = ssa:read("*a")
ssa:close()
local ssacl = load(ssac)()

loadservers()

::s::

os.execute("clear")
print("\27[0m\27[44m[DTD::SERVERS]:\27[41m[=======================]")
----------

header = ""
for i,v in ipairs(servers) do
    local owner = v.owner
    header = header .. "\n\27[0m\27[44m[SS::HOST]:\27[0m \27[92m[ \27[93m"..v.name.."\27[92m ]\27[0m\n\27[44m[SS::OWNER]:\27[0m "..owner.."\27[0m\n"
end

print(header)
----------
print("\n\27[0m\27[44m[======================================]\27[0m")

exit = false
io.write("\27[0m > \27[90mexit, create\27[12D\27[92m")
inp = io.read()

if inp == "exit" then
  exit = true
elseif inp == "create" then
    local session = true
    local doreq = true
    while session do 
        os.execute("clear")
        print("\27[0m\27[44m[ Servers Colection! ]:\27[0m\n")

        local maxi = 3
        for i,v in ipairs(servers) do
            if v.owner == _G.DTDUser.name then
                if i > maxi then
                    maxi = maxi + 3
                    print("\n")
                end
                io.write("\27[92m\27[1m[\27[96m"..v.name.."\27[92m]\27[0m ")
            end
        end

        print("\n\n\27[0m\27[44m[=====================]")

        io.write("\27[0m > \27[90mback, new, delete\27[17D\27[92m")
        local cinp = io.read()
        if cinp == "back" then
            os.execute("clear")
            session = false
        elseif cinp == "new" then
            os.execute("clear")
            print("\27[0m\27[44m[HOST/NAME]:\27[0m")
            io.write("> \27[92m")
            local name = io.read()
            local can = true

            for i,v in ipairs(servers) do
                if name == v.name then
                    can = false
                end
            end

            if can == true then
                print("\27[0m\27[44m[URL]:\27[0m")
                io.write("> \27[92m")
                local url = io.read()
                if url then
                    print("\27[93mworking...\27[0m")
                    local strucn = name.."@".._G.DTDUser.name
                    strucn = strucn:gsub("\n",""):gsub(" ","")
                    DTDPostService:servers(url, strucn, "POST")
                    os.execute("clear")
                    print("\27[92m created sucessfully! \27[93mloading servers...\27[0m]")
                    os.execute("sleep 1")
                    loadservers()
                else
                    print("bro we literally cant create a server without a url! :|")
                end
            else
                print("\27[91mserver name already defined!\27[0m")
            end
        elseif cinp == "delete" then
            local session2 = true
            while session2 do
            os.execute("clear")
            print("\27[44m[SELECT AN SERVER TO DELETE]:\27[0m")
            io.write("> \27[92m")
            local smaxi = 3
            for i,v in ipairs(servers) do
                if v.owner == _G.DTDUser.name then
                    if i > smaxi then
                        smaxi = smaxi + 3
                        print("\n")
                    end
                    io.write("\27[0m\27[92m\27[1m[ \27[96m"..v.name.."\27[92m ]\27[0m")
                end
            end
            print("\27[44m[===============================]\27[0m")
            io.write("> \27[92m")
            local nameh = io.read()
            if nameh:sub(1,1) ~= " " and nameh:sub(1,1) ~= "" then
                for i,v in ipairs(servers) do
                    if nameh == v.name and _G.DTDUser.name == v.owner then
                        print("\27[93mworking...\27[0m")
                        DTDPostService:servers("",v.name.."@".._G.DTDUser.name, "DELETE")
                        os.execute("clear")
                        session2 = false
                        print("\27[92mfinished! \27[93mloading servers...\27[0m")
                        os.execute("sleep 3")
                        loadservers()
                        break
                    end if session2 == true and (nameh ~= v.name or _G.DTDUser.name ~= v.owner) then
                        print("\27[91mserver not found.\27[0m")
                    end
                end
            else
                session2 = false
            end
            end
        end
    end
end

os.execute("clear")
if exit == false then
  goto s
end