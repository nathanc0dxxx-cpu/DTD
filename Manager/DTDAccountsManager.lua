
local session = true
local users = {}
local function loadservers()
    users = {}
    local ss = io.popen("curl -s https://api.github.com/repos/tutugrande1235-DTD/DTD-Source-Scripts/contents/Accounts")
    if ss then
        local cont = ss:read("*a")
        for v in cont:gmatch("%s*\"name\"%s*:%s*\"(.-)\"") do
        	table.insert(users, v)
        end
        ss:close()
    end
end loadservers()

local sla = io.popen("curl -s https://raw.githubusercontent.com/nathanc0dxxx-cpu/DTD/main/SystemManagers/DTDAccountGenerator.lua")
if sla then load(sla:read("*a"))() sla:close() else return end

while session do
	os.execute("clear")
    print("\27[44m[Accounts]:\27[0m\n")
    for i,v in ipairs(users) do
        print("\27[92m "..i.." \27[93m"..v.."")
    end print("\n\27[0m\27[44m[=========]\27[0m")
    io.write(" > \27[90mexit, reset, new, logout\27[24D\27[92m")
    local uinp = io.read()
    if uinp == "exit" then
        session = false
        os.execute("clear")
    elseif uinp == "reset" then
        loadservers()
    elseif uinp == "new" then
        os.execute("clear")
        print("\27[0m\27[44m[UserName]:\27[0m")
        io.write(" > \27[92m")
        local name = io.read()
        if name ~= "" then
            print("\27[0m\27[44m[PassWord]:\27[0m")
            io.write(" > \27[92m")
            local password = io.read()
            if password ~= "" then
                local tab = genuser(name, password)
                if tab then 
                    print("\27[91mlogin with:\27[0m")
                    print(tab.nm)
                    print(tab.ps)
                    local file = io.open("DTDUser","r")
                    io.read()
                    if file then 
                        os.remove("DTDUser")
                        os.execute("clear")
                        file:close()
                        os.exit()
                    end
                else
                    print("\27[91mfail!\27[0m")
                end
            else
                print("\27[91mtype a password!\27[0m")
            end
        else
            print("\27[91mtype a name bro...\27[0m")
            io.read()
        end
    elseif uinp == "logout" then
        os.remove("DTDUser")
        os.execute("clear")
        os.exit()
    end
end