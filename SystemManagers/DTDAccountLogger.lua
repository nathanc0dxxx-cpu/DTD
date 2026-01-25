
local doreq = true
local users = {}

local function buildaccount(nm, ps, idd)
    local file = io.open("DTDUser","w")
    if file then
        file:write(nm.."\n"..ps)
        file:close()
        local raw = { name = nm, id = idd }

_G.DTDUser = setmetatable({}, {
    __index = raw,
    __newindex = function()
        error("attempt to modify a constant", 2)
    end,
    __metatable = false
})
    end os.execute("clear")
end

local function main()
    if doreq == true then
        local ss = io.popen("curl -s https://api.github.com/repos/nathanc0dxxx-cpu/DTD/contents/Accounts")
        users = {}
        if ss then
        for v in ss:read("*a"):gmatch("%s*\"name\"%s*:%s*\"(.-)\"") do
            table.insert(users, v)
        end ss:close()
        local ss2 = io.popen("curl -s https://raw.githubusercontent.com/nathanc0dxxx-cpu/DTD/main/SystemManagers/DTDAccountGenerator.lua")
        if ss2 then
            load(ss2:read("*a"))()
            ss2:close()
        else return 
        end
        doreq = false
    else
        return
    end end
    local name
    local pass
    local session = true
    local file = io.open("DTDUser","r")
    if file then
        local tab2 = {}
        for v in file:read("*a"):gmatch("%S+") do
            table.insert(tab2, v)
        end name = tab2[1] pass = tab2[2]
        registed = true
        file:close()
    end

    while session do
    os.execute("clear")
    local sucess = false

    print("\27[0m\27[44m[UserName]:\27[0m")
    io.write(" > \27[90mUser\27[4D\27[92m")
    if not registed then 
        name = io.read()
    end
    if name ~= "" then
        for i,v in ipairs(users) do
            if name == v then
                print("\27[0m\27[44m[PassWord]:\27[0m")
                io.write(" > \27[90mUser\27[4D\27[92m")
                if not registed then
                    pass = io.read()
                end
                local info = ""
                local ss = io.popen("curl -s https://raw.githubusercontent.com/nathanc0dxxx-cpu/DTD/main/Accounts/"..name)
                if ss then info = ss:read("*a") ss:close() else print("\27[91man unexpected error as ocurred...\27[0m") return end
                local tab = {}
                for v in info:gmatch("%S+") do
                    table.insert(tab, v)
                end local salt = tab[3] local hash = tab[1]
                local hashg = simple_hash(pass, salt)
                if hashg == hash then
                    local id = tab[2]
                    buildaccount(name, pass, id)
                    sucess = true session = false
                else
                    print("\27[91mincorrect password\27[0m")
                    io.read()
                end
            end
        end
    end end
end
main()