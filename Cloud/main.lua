if not DTDUser then DTDUser = { name = "Dougla037" } end
os.execute("clear")
print("\27[93minitializing...\27[0m")
do
    local ss = io.popen("curl -s https://raw.githubusercontent.com/nathanc0dxxx-cpu/DTD/main/SystemManagers/DTDPostService.lua")
    if ss then load(ss:read("*a"))() ss:close() else print("\27[91mfail while loading postservice...\27[0m") end
end
print("\27[93mloading objects...\27[0m")
local files = {}
local function loadfiles(tb, path)
    if not tb then return end
    if path == nil then path = "" end
    local ss = io.popen("curl -s https://api.github.com/repos/nathanc0dxxx-cpu/DTD/contents/Cloud/"..DTDUser.name..path)
    local ssc = ss:read("*a") ss:close()
    for i,v in ssc:gmatch("\"name\"%s*:%s*\"(.-)\".-\"type\"%s*:%s*\"(.-)\"") do
        local obj = { name = i, tp = v }
        table.insert(tb, obj)
    end
end loadfiles(files)
local clouds = true
while clouds do
    local havefile = false
    os.execute("clear")
    print("\27[0m\27[44m[Your files Colection!]:\27[0m")
    do
        local max = 3
        for i,v in ipairs(files) do
            if v.tp == "file" then
                havefile = true
                io.write("\27[96m"..v.name.."\27[0m")
            elseif v.tp == "dir" then
                havefile = true
                io.write("\27[93m"..v.name.."\27[0m")
            end
            if i >= max then
                print("\n")
            end
        end
    end if havefile == false then print("\n\27[90mHmm... Nothing stocked here...\27[0m\n") end
    print("\27[0m\27[44m[============]:\27[0m")
    io.write(" > \27[90m<name>, exit, stock\27[19D\27[92m")
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
                                DTDPostService:cloud(filec, v, "PUT")
                                updatef = true
                            end
                        end if updatef == false then
                            print("\27[93mstocking file...\27[0m")
                            DTDPostService:cloud(filec, v, "POST")
                        end
                    else
                        print("\27[93mseeking...\27[0m")
                    end
                end
            end
        end
    end
end
