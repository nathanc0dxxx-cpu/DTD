
os.execute("clear")
local stdsession = true

function()
    local ss = io.popen("curl -s https://raw.githubusercontent.com/nathanc0dxxx-cpu/DTD/main/DTDMarketStudioPX.mp.lua")
    if ss then load(ss:read("*a")) end
    ss:close()
end

local packs = {}
local function loadpacks()
    local ss = io.popen("curl -s https://api.github.com/repos/nathanc0dxxx-cpu/DTD/contents/Market")
    local ssc = ss:read("*a")
    ss:close()
    packs = {}
    for i,v in ssc:gmatch("%s*\"name\"%s*:%s*\"(.-)@(.-)\"") do
        local obj = { name = i, owner = v }
        table.insert(packs, obj)
    end
end  loadpacks() _G.std = {
    newcmd = function(self, json)
        local obj = {
            token = json.token,
            func = json.func,
            desc = json.desc,
        } table.insert(self.cmd, obj)
    end,
    cmd = {},
    args = {},
} local function loadplugins()
    local fpipe = io.popen("ls")
    local files = fpipe:read("*a")
    fpipe:close()
    local found = false
    for v in files:gmatch("%S+") do
        if v:match(".mp.lua$") then
            found = true
            dofile(v)
            print("\27[44m[MS::PIL]:\27[0m \27[92mloaded "..v)
        end
    end if found == false then
        print("\27[44m[MS::PIL]:\27[0m \27[91mno plugin found")
    end
end loadplugins()

while stdsession do
    io.write("\27[0m > \27[90mhelp\27[4D\27[92m")
    local inp = io.read() print()
    std.args = {}
    for v in inp:gmatch("%S+") do
        table.insert(std.args, v)
    end io.write("\27[0m")
    
    local sucess = false
    for i,v in ipairs(std.cmd) do
        if std.args[1] == v.token then
            if std.args[2] == "--help" then
                print("\27[32m --description: \27[0m\n"..v.desc)
            else
                v.func()
            end
            sucess = true
        end
    end if sucess == false then
        if not std.args[1] then
            io.write("\27[2A\r      \r")
        else
            io.write("\27[2A\27[0m\27[91mcmd \27[93m"..std.args[1].."\27[91m inval or not registed\27[0m\n")
        end
    end
end