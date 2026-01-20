
os.execute("clear")
print("\27[0m\27[44m[DTD::SM]:\27[0m \27[93minitializing...")
if not DTDUser then _G.DTDUser = { name = "User" } end

local ss = io.popen("curl -s https://raw.githubusercontent.com/nathanc0dxxx-cpu/DTD/main/SystemManagers/DTDPostService.lua")
load(ss:read("*a"))()
ss:close() local ss = io.popen("curl -s https://api.github.com/repos/nathanc0dxxx-cpu/DTD/contents/Servers")
local serverstxt = ss:read("*a") ss:close()

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
print("\n\27[0m\27[44m[======================================]")

exit = false

inp = io.read()

if inp == "exit" then
  exit = true
elseif inp == "create" then
    local session = true
    local doreq = true
    while session do 
        os.execute("clear")
        
        local cinp = io.read()
        if cinp == "back" then
            os.execute("clear")
            session = false
        end
    end
end

os.execute("clear")
if exit == false then
  goto s
end