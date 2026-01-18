os.execute("clear")
print("\27[93minitializing...")
print("\27[93mgetting account Services...")
local ss = io.popen("curl -s https://raw.githubusercontent.com/nathanc0dxxx-cpu/DTD/main/DTDAccountsManager.lua")
print("injecting...")
load(ss:read("*a"))()
print("\27[93mloaded!\27[0m")

local so = os.execute
    local names = DTDAccountsManager:getusersname()

local username = nil
local password = nil

local function buildaccount(nm, ps)
    _G.DTDUser = {
        name = nm,
        id = pcall(function() DTDAccountsManager:getid(nm) end),
    } buildaccount = nil
    local save = io.open("DTDUser","w")
    save:write(nm.."\n"..ps)
    save:close()
    print("\27[92maccount construction completed!\27[0m")
end
local session = false
local filetest = io.open("DTDUser","r+")
if filetest then
  local filet = filetest:read("*a")
  filetest:close()
  local datat = {}
  for v in filet:gmatch("%S+") do
    table.insert(datat,v)
  end buildaccount(datat[1], datat[2])
else
  session = true
end

while session do
    so("clear")
    print("\27[44m[DTD::LG]:\27[0m \27[93mUsername:")
    io.write("\27[0m > \27[96m ...\27[0m\27[3D")
    local uinp = io.read()
    for v in names:gmatch("%S+") do
        if uinp == v then
            username = v
            print("\27[44m[DTD::LG]:\27[0m \27[93mPassWord")
            io.write("\27[0m > \27[96m ...\27[0m\27[3D")
            local ups = io.read()
            local upw = DTDAccountsManager:getpass(username, "imaop!dud:p")
            if not upw then upw = "TEST" end
            if ups == upw then password = upw session = false buildaccount(username, password)else print("\27[91mINCORRECT PASSWORD! dont try enter others account...\27[0m\npress any key to procced") io.read() end
        end
        if not username then print("\27[44m[DTD::LG]:\27[0m \27[91myour current username does not match any dtdaccount,\ntry check if your username exists or try later...\27[0m\npress any key to procced") io.read() end
    end
end