
os.execute("clear")
print("\27[0m\27[44m[DTD::SM]:\27[0m \27[93minitializing...")
if not DTDUser then _G.DTDUser = { name = "User" } end

local ss = io.popen("curl -s https://raw.githubusercontent.com/nathanc0dxxx-cpu/DTD/main/SystemManagers/DTDPostService.lua")
load(ss:read("*a"))()
ss:close()

exit = false

inp = io.read()

if inp == "exit" then
  exit = true
end

os.execute("clear")
if exit == false then
  goto s
end