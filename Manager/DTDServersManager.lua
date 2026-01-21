
os.execute("clear")
print("\27[0m\27[44m[DTD::SM]:\27[0m \27[93minitializing...")
if not DTDUser then _G.DTDUser = { name = "User" } end

local ss = io.popen("curl -s https://api.github.com/repos/nathanc0dxxx-cpu/DTD/contents/Servers")
local serverstxt = ss:read("*a") ss:close()

local ssa = io.popen("curl -v https://raw.githubusercontent.com/nathanc0dxxx-cpu/DTD/main/SystemManagers/DTDPostService.lua")
local ssac = ssa:read("*a")
ssa:close() print(ssac)
local ssacl = load(ssac)()

::s::

os.execute("clear")
print("\27[0m\27[44m[DTD::SERVERS]:\27[41m[=======================]")
----------

local servers = {}
for i,v in serverstxt:gmatch("%s*\"name\"%s*:%s*\"(.-)%s*<(.-)>\"") do
    local obj = { name = i, owner = v }
    table.insert(servers, obj)
end

header = ""
for i,v in ipairs(servers) do
    local owner = v.owner
    header = header .. "\n\27[0m\27[44m[SS::HOST]:\27[0m \27[92m[ \27[93m"..v.name.."\27[92m ]\27[0m\n\27[44m[SS::OWNER]:\27[0m "..owner.."\27[0m\n"
end

print(header)
----------
print("\n\27[0m\27[44m[======================================]\27[0m")

exit = false
io.write("\27[0m > \27[92m")
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
            if i > maxi then
                print("\n")
            end
            io.write("\27[92m\27[1m[\27[96m"..v.name.."\27[92m]\27[0m ")
        end
        
        print("\n\n\27[0m\27[44m[=====================]")
        
        io.write("\27[0m > \27[90mback, new, delete\27[17D\27[92m")
        local cinp = io.read()
        if cinp == "back" then
            os.execute("clear")
            session = false
        elseif cinp == "new" then
            os.execute("clear")
            print("\27[44m[HOST/NAME]:\27[0m")
            io.write("> \27[92m")
            local name = io.read()
            local can = true
            
            for i,v in ipairs(servers) do
                if name == v.name then
                    can = false
                end
            end
            
            if can == true then
                local url = io.read()
                if url then
                    local strucn = name.."<".._G.DTDUser.name..">"
                    DTDPostService:servers(url, strucn, "POST")
                    os.execute("sleep 20")
                    print("\27[92m created sucessfully!")
                else
                    print("bro we literally cant create a server without a url! :|")
                end
            else
                print("\27[91mserver name already defined!\27[0m")
            end
        end
    end
end

os.execute("clear")
if exit == false then
  goto s
end